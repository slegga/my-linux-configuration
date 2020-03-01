#!/usr/bin/env perl

use FindBin;
use Mojo::Base -strict;
use Mojo::File 'path';
use File::Copy 'copy';
use autodie;

# use lib "$FindBin::Bin/../lib";

=head1 NAME

env-setup.pl

=head1 DESCRIPTION

Set up environment

=cut


sub link_file {
	my ($file, $link) = @_;
	if (-l $link) {
		return;
	}
	elsif ( -e $link  ) {
		die "$link exists! Please clean up and consider removing file/directory.";
	}
	else { # link do not exists
		say "link($file, $link)";
		die "$file does not exists! Try to link($file, $link)" if ! -e $file;
		my $return = symlink($file, $link);
		if (! $return ) {
				die "Cant make link $link $!"
		}
	}
}

my @tmp =@{ path("$FindBin::Bin") };
splice(@tmp,-2); # cd ../..
my $gitdir = path(@tmp);

my $microdir = "$ENV{HOME}/.config/micro";
my $repocnfdir = "$FindBin::Bin/../config";

# SET UP MICRO
if ( -d $microdir ) {
	my $settingfile = "$microdir/settings.json";
	link_file( "$repocnfdir/micro/settings.json", $settingfile );
	my $syntaxdir = "$ENV{HOME}/.config/micro/syntax";
	link_file("$repocnfdir/micro/syntax", $syntaxdir);
}

# SET UP .bashrc
my $bashrc = path($ENV{HOME}, '.bashrc');
if (-f $bashrc) {

  my $extra_file =  $ENV{ HOME } ."/git/my-linux-configuration/my-bash-extra.sh";
		link_file( $extra_file, "$ENV{HOME}/my-bash-extra.sh" );

	if ( $bashrc->slurp !~/\/my-linux-configuration\/my\-bash-extra\.sh/){
		$bashrc->spurt($bashrc->slurp , "\nsource $extra_file\n");
		warn "Added source $extra_file .bashrc";
	}

  if ( $bashrc->slurp !~ /[^i][^o].\/my\-bashrc-extra\.sh/){
  	$bashrc->spurt($bashrc->slurp , "\nsource " . $ENV{ HOME } ."/my-bashrc-extra.sh\n");
  	warn 'Added . ~/my-bashrc-extra.sh to .bashrc';
  }
} else {
	warn ".bashrc not found";
}

my $content= <<"EOF";
# GENERATED BY $0
# DO NOT MODIFY. MODIFY SCRIPT $0 INSTEAD OR RERUN IT.

EOF
$content .= 'export PATH=$PATH';
my $git;
if (! -d '/local/nms') {
	$git = path($ENV{HOME}.'/git');
} else {
	$git = $gitdir;
}
for my $gt ($git->list({dir=>1})->each) {
	next if(-f $gt);
	my $bin = path($gt)->child('bin');
	if (-d $bin) {
		$content.=":$bin";
	}

}
$content .="\n";
my $be = path($ENV{HOME},'my-bashrc-extra.sh');
$be->spurt($content);
chmod (0700,$be);

# SYMLINK CERTANT FILES
link_file("$ENV{HOME}/.perlcriticrc",'.perlcriticrc');
link_file("$ENV{HOME}/.perltidyrc",'.perltidyrc');
link_file("$ENV{HOME}/googledrive/Apps/pib_stein/cac/group_vars/hypnotoad.yml", "$ENV{HOME}/etc/hypnotoad.yml");
link_file("$ENV{HOME}/googledrive/Apps/pib_stein/cac/group_vars/mojoapp.yml", "$ENV{HOME}/etc/mojoapp.yml");

# path("$FindBin::Bin/m")->copy_to("$ENV{HOME}/bin/m");