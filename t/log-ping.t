use Mojo::Base -strict;
use Test::More;
use Mojo::File 'path';
use open qw(:std :utf8);

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
use Test::ScriptX;


# log-ping.pl - Log ping result continuesly.

unlike(path('bin/log-ping.pl')->slurp, qr{\<\<[A-Z]+\>\>},'All placeholders are changed');
my $t = Test::ScriptX->new('bin/log-ping.pl', debug=>1);
$t->run(help=>1);
$t->stderr_ok->stdout_like(qr{log-ping});
done_testing;
