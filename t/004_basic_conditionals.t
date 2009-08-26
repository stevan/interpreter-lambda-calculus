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
    my $r = $i->interpret('(if (true) then 1 else 2)');
    isa_ok($r, 'Interpreter::Lambda::Calculus::AST::Literal::Int');
    is($r->val, 1, '... got the right value');
}

{
    my $r = $i->interpret('(if (false) then 1 else 2)');
    isa_ok($r, 'Interpreter::Lambda::Calculus::AST::Literal::Int');
    is($r->val, 2, '... got the right value');
}

{
    my $r = $i->interpret('(if (1 == 1) then 1 else 2)');
    isa_ok($r, 'Interpreter::Lambda::Calculus::AST::Literal::Int');
    is($r->val, 1, '... got the right value');
}

{
    my $r = $i->interpret('(if (1 == 2) then 1 else 2)');
    isa_ok($r, 'Interpreter::Lambda::Calculus::AST::Literal::Int');
    is($r->val, 2, '... got the right value');
}

dies_ok {
    $i->interpret('(if (1 + 2) then 1 else 2)');    
} '... conditionals only evaulate bools';


