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


# genererate-conkyrc.pl - Overwrite conkyrc with config genrated from template.

# unlike(path('script/genererate-conkyrc.pl')->slurp, qr{\<\<[A-Z]+\>\>},'All placeholders are changed');
my $t = Test::ScriptX->new('script/genererate-conkyrc.pl', debug=>1);
$t->run(help=>1);
$t->stderr_ok->stdout_like(qr{genererate-conkyrc});
done_testing;
