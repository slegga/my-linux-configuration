#!/usr/bin/env perl
use FindBin;
use Mojo::Base -strict;
use File::Copy 'copy';
use autodie;

# use lib "$FindBin::Bin/../lib";

sub link_file {
	my ($file, $link) = @_;
	if (-l $link) {
		return;
	}
	if ( -f $link ) {
		copy($file, $link) or die "Cant copy($file, $link): $!";
		return;
	}
	warn "link , $file, $link";
	my $return = link $file, $link;
	if (! $return ) {
	 	my $err = $!;
	 	if ($err =~ m/Invalid cross-device link/) {
			 copy( $file, $link ) or die "Cant copy($file, $link): $!";
	 	} else {
			die "Cant make link $link $!"
		}
	}
}

my $gitdir = "$FindBin::Bin/../../";
my $microdir = "$ENV{HOME}/.config/micro";
my $repocnfdir = "$FindBin::Bin/../config";
if ( -d $microdir ) {
	my $settingfile = "$microdir/settings.json";
	link_file( "$repocnfdir/micro/settings.json", $settingfile );
	my $syntaxdir = "$ENV{HOME}/.config/micro/syntax";
	if ( ! -d $syntaxdir ) {
		warn "mkdir $syntaxdir";
		mkdir $syntaxdir;
	}
	my $linkperlyaml = "$syntaxdir/perl.yaml";
	if (! -f $linkperlyaml) {
		my $repofile = "$gitdir/my-linux-configuration/config/micro/syntax/perl.yaml";
		link_file($repofile, $linkperlyaml);
	}
}