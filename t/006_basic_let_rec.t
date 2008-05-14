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

# test the class factorial function

{
    my $r = $i->interpret(q[
        (let rec fact = (lambda (n) 
            (if (n == 0) then 
                (1) 
             else 
                (n * (fact (n - 1))))
        ) in 
            (fact 5)
        )    
    ]);
    isa_ok($r, 'Interpreter::Lambda::Calculus::AST::Literal::Int');
    is($r->val, 120, '... got the right value');
}

# and the other classic fibonacci

{
    my $r = $i->interpret(q[
        (let rec fib = (lambda (n) 
            (if (n < 2) then 
                (n) 
             else 
                ((fib (n - 1)) + (fib (n - 2))))
        ) in 
            (fib 10)
        )
    ]);
    isa_ok($r, 'Interpreter::Lambda::Calculus::AST::Literal::Int');
    is($r->val, 55, '... got the right value');
}

{
    my @errors = (
        '(let rec x = 10 in x)'
    );

    foreach my $err (@errors) {
        dies_ok {
            $i->interpret($err)   
        } "... $err failed correctly";
    }
}

