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
    my %source = (
        # App
        '(+ 10 10)' => '(+ (10) (10))',
        # Var
        '(x)' => '(x)',
        # Unit        
        '()' => '()',        
        # Literal
            # Str        
            '("Hello")' => '("Hello")',        
            # Int        
            '(10)' => '(10)',        
            # Bool        
            '(true)' => '(true)',            
            '(false)' => '(false)',
        # Let
        '(let x = 10 in x)' => '(let x = (10) in (x))',                        
        # Let Rec
        '(let rec x = (lambda () ()) in (x ()))' => '(let rec x = (lambda () ()) in ((x) ()))',        
        # Lambda
        '(lambda () ())' => '(lambda () ())',
        # If Else
        '(if (true) then 10 else 20)' => '(if (true) then (10) else (20))',        
    );

    foreach my $s (keys %source) {
        is(
            $i->parse($s)->pprint,
            $source{$s},
            "... $s pretty printed correctly"
        );
        
    }
    
    is(
        $i->interpret('((lambda (f) (lambda (x) (f x))) (lambda (x) (+ x x)))')->pprint,
        '<closure $ENV (lambda (x) ((f) (x)))>',        
        "... closure pretty printed correctly"
    );            
}


