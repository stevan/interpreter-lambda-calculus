#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use Path::Class;

use lib "$FindBin::Bin/../lib";

use Interpreter::Lambda::Calculus;

my $file = Path::Class::File->new(
    shift || die "You must specify a file to run\n"
);

(-e $file && -f $file)
    || die "Could not find file ($file)\n";

print Interpreter::Lambda::Calculus->new->interpret(scalar $file->slurp)->pprint, "\n";

