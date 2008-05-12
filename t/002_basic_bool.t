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


# test some basic quality
foreach my $source ('(== 10 10)', '(eq 10 10)'){
    my $r = $i->interpret($source);
    isa_ok($r, 'Interpreter::Lambda::Calculus::AST::Literal::Bool');
    is($r->val, 'true', '... got the right value');
}

foreach my $source ('(== 10 5)', '(eq 10 5)'){
    my $r = $i->interpret($source);
    isa_ok($r, 'Interpreter::Lambda::Calculus::AST::Literal::Bool');
    is($r->val, 'false', '... got the right value');
}

# and some in-equality
foreach my $source ('(!= 10 5)', '(ne 10 5)'){
    my $r = $i->interpret($source);
    isa_ok($r, 'Interpreter::Lambda::Calculus::AST::Literal::Bool');
    is($r->val, 'true', '... got the right value');
}

foreach my $source ('(!= 10 10)', '(ne 10 10)'){
    my $r = $i->interpret($source);
    isa_ok($r, 'Interpreter::Lambda::Calculus::AST::Literal::Bool');
    is($r->val, 'false', '... got the right value');
}

# and some others
foreach my $source ('(> 10 10)', '(gt 10 10)'){
    my $r = $i->interpret($source);
    isa_ok($r, 'Interpreter::Lambda::Calculus::AST::Literal::Bool');
    is($r->val, 'false', '... got the right value');
}

foreach my $source ('(>= 10 10)', '(ge 10 10)'){
    my $r = $i->interpret($source);
    isa_ok($r, 'Interpreter::Lambda::Calculus::AST::Literal::Bool');
    is($r->val, 'true', '... got the right value');
}

foreach my $source ('(< 10 10)', '(lt 10 10)'){
    my $r = $i->interpret($source);
    isa_ok($r, 'Interpreter::Lambda::Calculus::AST::Literal::Bool');
    is($r->val, 'false', '... got the right value');
}

foreach my $source ('(<= 10 10)', '(le 10 10)'){
    my $r = $i->interpret($source);
    isa_ok($r, 'Interpreter::Lambda::Calculus::AST::Literal::Bool');
    is($r->val, 'true', '... got the right value');
}




