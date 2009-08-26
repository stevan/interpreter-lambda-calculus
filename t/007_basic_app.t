#!/usr/bin/perl

use strict;
use warnings;

use Test::More 'no_plan';
use Test::Exception;

BEGIN {
    use_ok('Interpreter::Lambda::Calculus');
}

my $i = Interpreter::Lambda::Calculus->new;
isa_ok($i, 'Interpreter::Lambda::Calculus');

{
    my $r = $i->interpret('((lambda () (1)) ())');
    isa_ok($r, 'Interpreter::Lambda::Calculus::AST::Literal::Int');
    is($r->val, 1, '... got the right value');
}

{
    my @errors = ('(1 1)');

    foreach my $err (@errors) {
        dies_ok {
            $i->interpret($err)   
        } "... $err failed correctly";
    }
}