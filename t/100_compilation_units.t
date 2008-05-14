#!/usr/bin/perl

use strict;
use warnings;

use Test::More no_plan => 1;
use Test::Exception;

BEGIN {
    use_ok('Interpreter::Lambda::Calculus');
    use_ok('Interpreter::Lambda::Calculus::AST::Closure');
    use_ok('Interpreter::Lambda::Calculus::AST::App');
    use_ok('Interpreter::Lambda::Calculus::AST::Var');    
}

my $COMPILED_FILE = 'square.json';

my $i = Interpreter::Lambda::Calculus->new;
isa_ok($i, 'Interpreter::Lambda::Calculus');

{
    my $l = $i->parse('(lambda x (x * x))');
    my $r = Interpreter::Lambda::Calculus::AST::App->new(
        f   => $l,
        arg => Interpreter::Lambda::Calculus::AST::Literal::Int->new(val => 10)
    )->eval;
    is($r->val, 100, '... got the right value from the square func');
    #print $l->dump;
    $l->store($COMPILED_FILE);
}

{
    my $l = Interpreter::Lambda::Calculus::AST::Lambda->load($COMPILED_FILE);
    my $r = Interpreter::Lambda::Calculus::AST::App->new(
        f   => $l,
        arg => Interpreter::Lambda::Calculus::AST::Literal::Int->new(val => 10)
    )->eval;
    is($r->val, 100, '... loaded the precompiled square func');
}

unlink $COMPILED_FILE;






