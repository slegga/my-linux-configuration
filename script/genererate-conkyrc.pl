#!/usr/bin/env perl

use Mojo::File 'path';
use Mojo::Template;
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
use Mojo::File 'curfile';
use Mojo::Base 'SH::ScriptX';
use open qw(:std :utf8);


#use Carp::Always;

=encoding utf8

=head1 NAME

genererate-conkyrc.pl - Overwrite conkyrc with config genrated from template.

=head1 DESCRIPTION

<<DESCRIPTION>>

=head1 ATTRIBUTES

=head2 configfile - default to $CONFIG_DIR then $HOME/etc/<<scriptname>>.yml

=cut

option 'dryrun!', 'Print to screen instead of doing changes';

sub main {
    my $self = shift;
    my @e = @{ $self->extra_options };

    my $netstat = `ifconfig`;
   # say $netstat;

    my $interface;
    if ($netstat =~ /\n(w\w+)/) {
		$interface = $1;
	} else {
		$interface = 'lo';
	}
	my $home = $ENV{HOME};
	my $mt = Mojo::Template->new(vars => 1);
	my $data = join('',<DATA>);
	say $mt->render($data, { if=> $interface, home => $home } );
}

__PACKAGE__->new(options_cfg=>{extra=>1})->main();


__DATA__
conky.config = {
-- Avoid flicker
	double_buffer = false,

-- Output settings
	own_window = true,
	own_window_class = 'Conky',
	own_window_type = 'normal',
	--desktop
	--out_to_x = false,
	--out_to_console = true,
	update_interval = 30,
	alignment = 'top_right',
	background = true,
	draw_borders = false,
	draw_outline = false,
    draw_shades = false,
    use_xft = true,
    font = 'DejaVu Sans Mono:size=12',
    -- own_window_transparent = true,
    own_window_argb_visual = true,
    own_window_argb_value = 0,
    -- own_window_colour = '009999',
    own_window_hints = 'undecorated,below,sticky,skip_taskbar,skip_pager',
    background = true,


-- This is the number of times Conky will update before quitting.
-- Set to zero to run forever.
	total_run_times = 0,

-- Shortens units to a single character (kiB->k, GiB->G, etc.). Default is off.
	short_units = true,

-- How strict should if_up be when testing an interface for being up?
-- The value is one of up, link or address, to check for the interface
-- being solely up, being up and having link or being up, having link
-- and an assigned IP address.
	if_up_strictness = 'address',

-- Add spaces to keep things from moving about?  This only affects certain objects.
-- use_spacer should have an argument of left, right, or none
--use_spacer left

-- Force UTF8? note that UTF8 support required XFT
	use_xft = true,
	override_utf8_locale = true,

-- number of cpu samples to average
-- set to 1 to disable averaging
	cpu_avg_samples = 2,

-- https://bbs.archlinux.org/viewtopic.php?id=165368
	times_in_seconds = true,

-- Stuff after 'TEXT' will be formatted on screen
};

conky.text = [[
${time %Y-%m-%d  %V-%u}  ${execi 1200 <%= $home %>/git/conky/scripts/weather.sh oslo | cut -c1-20} IP: ${execi 600 hostname -I | awk '{print $1}'} <%if($if ne 'lo') { %> ${texeci 300 <%= $home %>/git/conky/scripts/essid.sh} ${if_match ${wireless_link_qual_perc <%= $if %>}<100}${wireless_link_qual_perc <%=$if %>}% ${endif}<% } %> [${texeci 30 <%= $home %>/git/my-linux-configuration/bin/return-ping-avg.pl}]

]];

-- CPU: ${if_match ${cpu cpu0}<10} ${endif}${cpu cpu0}% ${loadavg 1} MEM: ${if_match ${memperc}<10} ${endif}${memperc}% ${swapperc}%  DISK: ${fs_free_perc /home/}% ${fs_free /home/}  ♪ ${texeci 3 ~/git/conky/scripts/conky_vol.sh}${texeci 3 ~/git/conky/scripts/conky_volM.sh}
