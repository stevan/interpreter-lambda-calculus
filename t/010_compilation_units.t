#!/usr/bin/perl

use strict;
use warnings;

use Test::More no_plan => 1;
use Test::Exception;

BEGIN {
    use_ok('Interpreter::Lambda::Calculus');
    use_ok('Interpreter::Lambda::Calculus::AST::Closure');
}

my $COMPILED_FILE = 'square.json';

my $i = Interpreter::Lambda::Calculus->new;
isa_ok($i, 'Interpreter::Lambda::Calculus');

{
    my $l = $i->interpret('(lambda x (* x x))');
    my $r = $l->eval(x => Interpreter::Lambda::Calculus::AST::Literal::Int->new(val => 10));
    is($r->val, 100, '... got the right value from the square func');
    #print $l->dump;
    $l->store($COMPILED_FILE);
}

{
    my $l = Interpreter::Lambda::Calculus::AST::Closure->load($COMPILED_FILE);
    my $r = $l->eval(x => Interpreter::Lambda::Calculus::AST::Literal::Int->new(val => 10));
    is($r->val, 100, '... loaded the precompiled square func');
}

unlink $COMPILED_FILE;






