#!/usr/bin/env perl

=head1 NAME

<SCRIPTNAME> - Short explination

=head1 DESCRIPTION

<TEXT>

=cut

# CPAN
use Mojo::File 'path';

# GIT
use FindBin;
use lib '$FindBin::Bin/../../utilities-perl/lib';
use SH::UseLib;
use Mojo::Base 'SH::ScriptX';
use SH::ScriptX; # call SH::ScriptX->import

has info => 'blabla';
option 'name=s', 'from emailadress', {validation => qr'[\w\.\@]+'};

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