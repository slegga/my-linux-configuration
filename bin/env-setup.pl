#!/usr/bin/env perl
use FindBin;
use Mojo::Base -strict;
use File::Copy 'copy';
# use lib "$FindBin::Bin/../lib";

my $gitdir = "$FindBin::Bin/../../";
if (-d "$ENV{HOME}/.config/micro") {
	my $syntaxdir = "$ENV{HOME}/.config/micro/syntax";
	if ( ! -d $syntaxdir ) {
		warn "mkdir $syntaxdir";
		mkdir $syntaxdir;
	}
	my $linkperlyaml = "$syntaxdir/perl.yaml";
	if (! -l $linkperlyaml) {
		my $repofile = "$gitdir/my-linux-configuration/config/micro/syntax/perl.yaml";
		warn "link , $repofile, $linkperlyaml";
		my $return = link $repofile, $linkperlyaml;
		 if (! $return ) {
		 	my $err = $!;
		 	if ($err =~ m/Invalid cross-device link/) {
				 copy( $repofile, $linkperlyaml ) or die "Cant copy($repofile, $linkperlyaml): $!";
		 	} else {
				die "Cant make link $linkperlyaml $!"
			}
		}
	}
}