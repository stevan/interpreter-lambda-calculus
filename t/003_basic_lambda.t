#!/usr/bin/perl

use strict;
use warnings;

use Test::More no_plan => 1;
use Test::Exception;

BEGIN {
    use_ok('Interpreter::Lambda::Calculus');
    use_ok('Interpreter::Lambda::Calculus::AST::App');
    use_ok('Interpreter::Lambda::Calculus::AST::Var');
}

my $i = Interpreter::Lambda::Calculus->new;
isa_ok($i, 'Interpreter::Lambda::Calculus');

{
    my $l = $i->parse('(lambda () ())');
    isa_ok($l, 'Interpreter::Lambda::Calculus::AST::Lambda');
    isa_ok($l->param, 'Interpreter::Lambda::Calculus::AST::Unit');    

    my $r = Interpreter::Lambda::Calculus::AST::App->new(
        f   => $l, 
        arg => Interpreter::Lambda::Calculus::AST::Unit->new
    )->eval;
    isa_ok($r, 'Interpreter::Lambda::Calculus::AST::Unit');
}

{
    my $l = $i->parse('(lambda x (x + x))');
    isa_ok($l, 'Interpreter::Lambda::Calculus::AST::Lambda');
    is($l->param->name, 'x', '... our lambdas parameter is x');

    my $r = Interpreter::Lambda::Calculus::AST::App->new(
        f   => $l, 
        arg => Interpreter::Lambda::Calculus::AST::Literal::Int->new(val => 10)
    )->eval;
    isa_ok($r, 'Interpreter::Lambda::Calculus::AST::Literal::Int');
    is($r->val, 20, '... got the right value');
}

{
    my $adder = $i->parse('(lambda x (lambda y (x + y)))');
    isa_ok($adder, 'Interpreter::Lambda::Calculus::AST::Lambda');
    is($adder->param->name, 'x', '... our lambdas parameter is x');
    
    my $add_one = Interpreter::Lambda::Calculus::AST::App->new(
        f   => $adder, 
        arg => Interpreter::Lambda::Calculus::AST::Literal::Int->new(val => 1)
    )->eval;
    isa_ok($add_one, 'Interpreter::Lambda::Calculus::AST::Closure');
    is($add_one->param->name, 'y', '... our lambdas parameter is y');    

    my $r = Interpreter::Lambda::Calculus::AST::App->new(
        f   => Interpreter::Lambda::Calculus::AST::Var->new(name => 'add_one'),
        arg => Interpreter::Lambda::Calculus::AST::Literal::Int->new(val => 10)
    )->eval(add_one => $add_one);
    isa_ok($r, 'Interpreter::Lambda::Calculus::AST::Literal::Int');
    is($r->val, 11, '... got the right value');
}

{
    my $applier = $i->parse('(lambda f (lambda x (f x)))');
    isa_ok($applier, 'Interpreter::Lambda::Calculus::AST::Lambda');
    is($applier->param->name, 'f', '... our lambdas parameter is f');
    
    my $product = $i->parse('(lambda x (x * x))');
    isa_ok($product, 'Interpreter::Lambda::Calculus::AST::Lambda');
    is($product->param->name, 'x', '... our lambdas parameter is x');    
    
    my $applied_product = Interpreter::Lambda::Calculus::AST::App->new(
        # pass these in as lambdas, so 
        # they can be evaluated and 
        # then become closures ...
        f   => $applier, 
        arg => $product,
    )->eval;
    isa_ok($applied_product, 'Interpreter::Lambda::Calculus::AST::Closure');
    is($applied_product->param->name, 'x', '... our lambdas parameter is x');    

    my $r = Interpreter::Lambda::Calculus::AST::App->new(
        f   => Interpreter::Lambda::Calculus::AST::Var->new(name => 'applied_product'),
        arg => Interpreter::Lambda::Calculus::AST::Literal::Int->new(val => 10)
    )->eval(
        # now pass as a variable,
        # because it is a closure
        applied_product => $applied_product
    );
    isa_ok($r, 'Interpreter::Lambda::Calculus::AST::Literal::Int');
    is($r->val, 100, '... got the right value');
}





