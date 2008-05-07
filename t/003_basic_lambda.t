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

{
    my $l = $i->interpret('(lambda x (+ x x))');
    isa_ok($l, 'Interpreter::Lambda::Calculus::AST::Closure');
    is($l->param->name, 'x', '... our lambdas parameter is x');

    my $r = $l->eval(x => Interpreter::Lambda::Calculus::AST::Literal::Int->new(val => 10));
    isa_ok($r, 'Interpreter::Lambda::Calculus::AST::Literal::Int');
    is($r->val, 20, '... got the right value');
}

{
    my $adder = $i->interpret('(lambda x (lambda y (+ x y)))');
    isa_ok($adder, 'Interpreter::Lambda::Calculus::AST::Closure');
    is($adder->param->name, 'x', '... our lambdas parameter is x');
    
    my $add_one = $adder->eval(x => Interpreter::Lambda::Calculus::AST::Literal::Int->new(val => 1));
    isa_ok($add_one, 'Interpreter::Lambda::Calculus::AST::Closure');
    is($add_one->param->name, 'y', '... our lambdas parameter is y');    

    my $r = $add_one->eval(y => Interpreter::Lambda::Calculus::AST::Literal::Int->new(val => 10));
    isa_ok($r, 'Interpreter::Lambda::Calculus::AST::Literal::Int');
    is($r->val, 11, '... got the right value');
}

{
    my $applier = $i->interpret('(lambda f (lambda x (f x)))');
    isa_ok($applier, 'Interpreter::Lambda::Calculus::AST::Closure');
    is($applier->param->name, 'f', '... our lambdas parameter is f');
    
    my $product = $i->interpret('(lambda x (* x x))');
    isa_ok($product, 'Interpreter::Lambda::Calculus::AST::Closure');
    is($product->param->name, 'x', '... our lambdas parameter is x');    
    
    my $applied_product = $applier->eval(f => $product);
    isa_ok($applied_product, 'Interpreter::Lambda::Calculus::AST::Closure');
    is($applied_product->param->name, 'x', '... our lambdas parameter is x');    

    my $r = $applied_product->eval(x => Interpreter::Lambda::Calculus::AST::Literal::Int->new(val => 10));
    isa_ok($r, 'Interpreter::Lambda::Calculus::AST::Literal::Int');
    is($r->val, 100, '... got the right value');
}





