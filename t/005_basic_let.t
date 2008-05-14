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
    my $r = $i->interpret('(let x = 1 in x)');
    isa_ok($r, 'Interpreter::Lambda::Calculus::AST::Literal::Int');
    is($r->val, 1, '... got the right value');
}

{
    my $r = $i->interpret('(let x = (+ 1 1) in x)');
    isa_ok($r, 'Interpreter::Lambda::Calculus::AST::Literal::Int');
    is($r->val, 2, '... got the right value');
}

# with functions ...

{
    my $r = $i->interpret('(let double = (lambda (x) (+ x x)) in (double 10))');
    isa_ok($r, 'Interpreter::Lambda::Calculus::AST::Literal::Int');
    is($r->val, 20, '... got the right value');
}


{
    my @errors = (
        '(let x = 10 in y)',
        '(let x = (lamda () (x 10)) in (x 10))'        
    );

    foreach my $err (@errors) {
        dies_ok {
            $i->interpret($err)   
        } "... $err failed correctly";
    }
}



