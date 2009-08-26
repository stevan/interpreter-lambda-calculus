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

# test some basic math stuff ...
foreach my $source ('(1 + 1)'){
    my $r = $i->interpret($source);
    isa_ok($r, 'Interpreter::Lambda::Calculus::AST::Literal::Int');
    is($r->val, 2, '... got the right value');
}

foreach my $source ('(2 * 2)'){
    my $r = $i->interpret($source);
    isa_ok($r, 'Interpreter::Lambda::Calculus::AST::Literal::Int');
    is($r->val, 4, '... got the right value');
}

foreach my $source ('(4 - 2)'){
    my $r = $i->interpret($source);
    isa_ok($r, 'Interpreter::Lambda::Calculus::AST::Literal::Int');
    is($r->val, 2, '... got the right value');
}

foreach my $source ('(10 / 2)'){
    my $r = $i->interpret($source);
    isa_ok($r, 'Interpreter::Lambda::Calculus::AST::Literal::Int');
    is($r->val, 5, '... got the right value');
}

foreach my $source ('(10 mod 3)'){
    my $r = $i->interpret($source);
    isa_ok($r, 'Interpreter::Lambda::Calculus::AST::Literal::Int');
    is($r->val, 1, '... got the right value');
}

{
    my @errors = (
        '(1 + (lambda () ()))', 
        '((lambda () ()) + 1)', 
                
        '(1 - "two")', 
        '("two" - 1)',
                   
        '(1 * "two")',
        '("two" * 1)',        
        
        '(1 \ "two")',        
        '("two" \ 1)',          
        
        '(1 mod "two")',        
        '("two" mod 1)',                
    );

    foreach my $err (@errors) {
        dies_ok {
            $i->interpret($err)   
        } "... $err failed correctly";
    }
}

