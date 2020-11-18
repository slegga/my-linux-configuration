#!/usr/bin/env perl

use Mojo::File 'path';

my $lib;
BEGIN {
    my $gitdir = Mojo::File->curfile;
    my @cats = @$gitdir;
    while (my $cd = pop @cats) {
        if ($cd eq 'git') {
            $gitdir = path(@cats,'git');
            last;
        }
    }
    $lib =  $gitdir->child('utilities-perl','lib')->to_string;
};
use lib $lib;
use SH::UseLib;
use SH::ScriptX;
use Mojo::Base 'SH::ScriptX';
use open qw(:std :utf8);
use Mojo::File 'path';
use Mojo::Template;

#use Carp::Always;

=encoding utf8

=head1 NAME

log-ping.pl - Log ping result continuesly.

=head1 DESCRIPTION

Log ping result continuesly in /tmp/ping-tmp-log.log

=head2 SYSTEMD

filename: /etc/systemd/system/log-ping.pl

[Service]
ExecStart=/usr/bin/node --use_strict /PATH/TO/YOUR/APP/bin/www
Restart=always
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=YOUR_APP
User=node
Group=node
Environment=NODE_ENV=production

[Install]
WantedBy=multi-user.target

=head1 ATTRIBUTES

=head2 configfile - default to $CONFIG_DIR then $HOME/etc/<<scriptname>>.yml

=cut

option 'dryrun!', 'Print to screen instead of doing changes';
option 'init!', 'Configure this script for SYSTEMD for currentuser';

sub main {
    my $self = shift;
    if ($self->init ) {
        say "Do the following and end with press ctrl-d";
        my $script= $0;
        $script =~s|.*/||;
        $script =~s/\..*//;
        my $systemd = path('/etc','systemd','system',"$script.service");
        my $user= getpwuid( $< );
        say "$systemd";
        my $mt = Mojo::Template->new->vars(1);
        say "sudo su";

        say "cat > $systemd";
        my $template =
'[Service]
ExecStart=<%= $ENV{HOME} %>/perl5/perlbrew/perls/perl-5.26.3/bin/perlbrew exec -q --with perl-5.26.3 perl <%= $ENV{HOME} %>/git/my-linux-configuration/bin/log-ping.pl
User=<%= $user %>
Group=<%= $user %>
Environment="PATH=/home/<%= $ENV{USER} %>/perl5/perlbrew/perls/perl-5.26.3/bin"
[Install]
WantedBy=multi-user.target';
       my $out = $mt->render($template,{user => $user});
# generate systemd config
        say $out;
        say "Test with: systemctl start $script.service";
        say "Turn on autostart systemctl enable log-ping.service";
        exit(0);
    }
    my @e = @{ $self->extra_options };
    my $user = getpwuid( $< );
    my $file = path("/tmp/ping.log");
    $file->touch;
    $file->chmod(0666);
    my @results;
    while (1) {
        my $res = `/bin/ping -c1 -W2 vg.no`;
        my $time = -1;
        if ($res =~/rtt .* (\d+\.\d*)/) {
            $time = $1;
        }
        push @results, $time;
        shift @results if @results > 6;
        my $fh = $file->open('>');
        print $fh "$_\n" for @results;
        close $fh;
        sleep 5;
    }
}

__PACKAGE__->new(options_cfg=>{extra=>1})->main();
