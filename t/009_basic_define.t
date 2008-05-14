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

# with global functions 

{    
    my $r = $i->interpret(q[
        (define double x = (+ x x))
        (double 10)
    ]);
    isa_ok($r, 'Interpreter::Lambda::Calculus::AST::Literal::Int');
    is($r->val, 20, '... got the right value');
}

{    
    my $r = $i->interpret(q[
        (define apply f = (lambda (x) (f x)))
        (define double x = (+ x x))        
        ((apply double) 10)
    ]);
    isa_ok($r, 'Interpreter::Lambda::Calculus::AST::Literal::Int');
    is($r->val, 20, '... got the right value');
}

# global values

{    
    my $r = $i->interpret(q[
        (define ten = 10)
        (ten)
    ]);
    isa_ok($r, 'Interpreter::Lambda::Calculus::AST::Literal::Int');
    is($r->val, 10, '... got the right value');
}



