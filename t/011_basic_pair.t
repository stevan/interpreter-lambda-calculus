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
    my $r = $i->interpret('([])');
    isa_ok($r, 'Interpreter::Lambda::Calculus::AST::Literal::Nil');
}

{
    my $r = $i->interpret('(10 : [])');
    isa_ok($r, 'Interpreter::Lambda::Calculus::AST::Literal::Pair');
    isa_ok($r->head, 'Interpreter::Lambda::Calculus::AST::Literal::Int');
    is($r->head->val, 10, '... got the right value in our list');
    isa_ok($r->tail, 'Interpreter::Lambda::Calculus::AST::Literal::Nil');        
}

{
    my $r = $i->interpret('(10 : (20 : []))');
    isa_ok($r, 'Interpreter::Lambda::Calculus::AST::Literal::Pair');
    isa_ok($r->head, 'Interpreter::Lambda::Calculus::AST::Literal::Int');
    is($r->head->val, 10, '... got the right value in our list');
    my $t = $r->tail;
    isa_ok($t, 'Interpreter::Lambda::Calculus::AST::Literal::Pair');        
    isa_ok($t->head, 'Interpreter::Lambda::Calculus::AST::Literal::Int');            
    is($t->head->val, 20, '... got the right value in our list');    
    isa_ok($t->tail, 'Interpreter::Lambda::Calculus::AST::Literal::Nil');                
}