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
        my $template =
'[Service]
ExecStart= <%= $ENV{HOME} %>/git/my-linux-configuration/bin/log-ping.pl
Restart=always
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=log-ping
User=$user
Group=$user
Environment=

[Install]
WantedBy=multi-user.target';
...;
# generate systemd config

    }
    my @e = @{ $self->extra_options };
    my $user = getpwuid( $< );
    my $file = path("/tmp/ping.log");
    `chmod 666 $file`;
    my $fh = $file->open('>>');
    while (1) {
        my $res = `/usr/bin/ping -c1 -W1 vg.no`;
        my $time = -1;
        if ($res =~/rtt .* (\d+\.\d*)/) {
            $time = $1;
        }
        print $fh "$time\n";
        sleep 3;
    }
    close $fh;
}

__PACKAGE__->new(options_cfg=>{extra=>1})->main();
