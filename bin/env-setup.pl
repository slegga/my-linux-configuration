#!/usr/bin/env perl
use FindBin;
# use lib "$FindBin::Bin/../lib";

my $gitdir = "$FindBin::Bin/../../";
if (-d "$ENV{HOME}/.config/micro") {
	my $syntaxdir = "$ENV{HOME}/.config/micro/syntax";
	if (! -d $syntaxdir) {
		mkdir $syntaxdir;
	}
	my $perlyaml = "$syntaxdir/perl.yaml";
	if (! -f $perlyaml) {
		link "$gitdir/my-linux-configuration/config/micro/syntax/perl.yaml", $perlyaml;
	}
}