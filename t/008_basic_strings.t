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
foreach my $source ('(+ "Hello" "World")', '(add "Hello" "World")'){
    my $r = $i->interpret($source);
    isa_ok($r, 'Interpreter::Lambda::Calculus::AST::Literal::Str');
    is($r->val, "HelloWorld", '... got the right value');
}

foreach my $source ('(+ "Hello" 10)', '(add "Hello" 10)'){
    my $r = $i->interpret($source);
    isa_ok($r, 'Interpreter::Lambda::Calculus::AST::Literal::Str');
    is($r->val, "Hello10", '... got the right value');
}

foreach my $source ('(+ 10 "Hello")', '(add 10 "Hello")'){
    my $r = $i->interpret($source);
    isa_ok($r, 'Interpreter::Lambda::Calculus::AST::Literal::Str');
    is($r->val, "10Hello", '... got the right value');
}

{
    my @errors = (
        '(+ "Hello" (lambda () ()))', 
        '(add "Hello" (lambda () ()))',
        '(+ (lambda () ()) "Hello")', 
        '(add (lambda () ()) "Hello")',
    );

    foreach my $err (@errors) {
        dies_ok {
            $i->interpret($err)   
        } "... $err failed correctly";
    }
}

