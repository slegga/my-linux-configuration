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
use Mojo::File 'path';
use Mojo::Base 'SH::ScriptX';
use open qw(:std :utf8);


#use Carp::Always;

=encoding utf8

=head1 NAME

return-ping-avg.pl - Return avarage ping.

=head1 DESCRIPTION

For conky return avarage ping/latency speed/time.

=head1 ATTRIBUTES

=head2 configfile - default to $CONFIG_DIR then $HOME/etc/<<scriptname>>.yml

=cut

option 'dryrun!', 'Print to screen instead of doing changes';

sub main {
    my $self = shift;
    my @e = @{ $self->extra_options };
    my $user = getpwuid( $< );
    my $path = path("/tmp/ping-log-$user.log");
    if (! -f "$path") {
        my $ret = `ping -w 1 -c 1 vg.no`;
        if ($ret =~ /\nrtt.*?(\d+\.\d+)/ ) {
            print $1;
            exit;
        }
        print $ret;
        print 9999;
        exit;
    }
    my $fh = $path->open('<');
    my $total=0;
    my $i=0;
    while (my $time = <$fh>) {
        $i++;
        if ($time == -1) {
            $total += 999;
        }
        else {
            $total+= $time;
        }
    }
    close $fh;
    print 999 if ! $i;
    printf "%.1f", $total/$i if $i;
    $path->spurt('');
}

__PACKAGE__->new(options_cfg=>{extra=>1})->main();
