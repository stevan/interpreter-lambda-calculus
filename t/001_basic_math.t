#!/usr/bin/perl

use strict;
use warnings;

use Test::More no_plan => 1;
use Test::Exception;

BEGIN {
    use_ok('Interpreter::Lambda::Calculus');
}

my $i = Interpreter::Lambda::Calculus->new;
isa_ok($i, 'Interpreter::Lambda::Calculus');

# test some basic math stuff ...
foreach my $source ('(+ 1 1)', '(add 1 1)'){
    my $r = $i->interpret($source);
    isa_ok($r, 'Interpreter::Lambda::Calculus::AST::Literal::Int');
    is($r->val, 2, '... got the right value');
}

foreach my $source ('(* 2 2)', '(mul 2 2)'){
    my $r = $i->interpret($source);
    isa_ok($r, 'Interpreter::Lambda::Calculus::AST::Literal::Int');
    is($r->val, 4, '... got the right value');
}

foreach my $source ('(- 4 2)', '(sub 4 2)'){
    my $r = $i->interpret($source);
    isa_ok($r, 'Interpreter::Lambda::Calculus::AST::Literal::Int');
    is($r->val, 2, '... got the right value');
}

foreach my $source ('(/ 10 2)', '(div 10 2)'){
    my $r = $i->interpret($source);
    isa_ok($r, 'Interpreter::Lambda::Calculus::AST::Literal::Int');
    is($r->val, 5, '... got the right value');
}

foreach my $source ('(mod 10 3)'){
    my $r = $i->interpret($source);
    isa_ok($r, 'Interpreter::Lambda::Calculus::AST::Literal::Int');
    is($r->val, 1, '... got the right value');
}
