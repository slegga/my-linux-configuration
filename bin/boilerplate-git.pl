#!/usr/bin/env perl

=head1 NAME

boilerplate-git

=head1 DESCRIPTION

Populate gitrepo with files and directories.

=cut

use SH::ScriptX; # call SH::ScriptX->import
use Mojo::Base 'SH::ScriptX';
use Mojo::File 'path';

#has info => 'blabla';
#option 'name=s', 'from emailadress', {validation => qr'[\w\.\@]+'};

sub main {
    my $self = shift;

    #check if current directory is a gitrepo
    my $curdir=path;
    if (! -d $curdir->child('.git')->to_string) {
    	die"This is not a git repo. Run git init first";
    	$self->graceful_exit;
    }

}

__PACKAGE__->new->main;