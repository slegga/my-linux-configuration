#!/usr/bin/env perl

=head1 NAME

boilerplate-git

=head1 DESCRIPTION

Populate gitrepo with files and directories.

=cut

# CPAN
use Mojo::File 'path';

# GIT
use FindBin;
use lib "$FindBin::Bin/../../utilities-perl/lib";
use SH::UseLib;
use SH::ScriptX; # call SH::ScriptX->import
use Mojo::Base 'SH::ScriptX';

#has info => 'blabla';
# option 'ask!',   'Show difference and ask overwrite or keep';
# option 'force!', 'Overwrite existing files, can not be combined with ask';

sub main {
    my $self = shift;

    #check if current directory is a gitrepo
    my $curdir=path;
    if (! -d $curdir->child('.git')->to_string) {
    	die"This is not a git repo. Run git init first";
    	$self->graceful_exit;
    }

	# Copy git stuff if not exists
	my $resdir = path("$FindBin::Bin");
	my @t = @$resdir;
	pop @t;
	$resdir = path(@t);
	my $gittree = $resdir->child('files','git');

	for my $file($gittree->list_tree->each) {
		say $file;
		my $rel = $file->to_rel($gittree);
		say $rel;
		my $new_file = $curdir->child('.git',$rel);
		if (! -e "$new_file") {
			$file->copy_to($new_file);
			say "$new_file copied";
		}
	}
}

__PACKAGE__->new->main;