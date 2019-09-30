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
option 'force!', 'Overwrite existing files, can not be combined with ask';

sub main {
    my $self = shift;
	my $env_flag = ! -d '/local/nms';
    #check if current directory is a gitrepo
    my $curdir=path;
    if (! -d $curdir->child('.git')->to_string) {
    	die"This is not a git repo. Run git init first";
    	$self->graceful_exit;
    }

	# create standard directories
	for my $dir(qw /bin lib script t/) {
		$curdir->child($dir)->make_path;
	}

	# Link git stuff if not exists
	my $resdir = path("$FindBin::Bin");
	my @t = @$resdir;
	pop @t;
	$resdir = path(@t);
	my $gittree = $resdir->child('files','git');

	for my $file($gittree->list_tree->each) {
#		say $file;
		my $rel = $file->to_rel($gittree);
#		say $rel;
		my $new_file = $curdir->child('.git',$rel);
		if ( $self->force && -e "$new_file") {
			unlink "$new_file";
		}
		if (! -e "$new_file") {
			link "$file", "$new_file";
			say "$new_file linked";
		}
	}

	# Copy rest of standard files
	if ($env_flag) {
		$resdir = path(@t);
		my $tree = $resdir->child('files');

		for my $file($tree->list_tree->each) {
			next if "$file" =~ m|/files/git/|;
			my $rel = $file->to_rel($tree);
			my $new_file = $curdir->child($rel);
			if (! -e "$new_file" || $self->force) {
	            $file->copy_to($new_file);
	            chmod(0755, "$new_file"); # Mojolicious 7 friendly.
	            say "$new_file copied";
			}
		}
	}
}

__PACKAGE__->new->main;