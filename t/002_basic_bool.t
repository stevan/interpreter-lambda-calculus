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


# test some basic quality
foreach my $source ('(10 == 10)', '("ten" == "ten")', '(true == true)', '(false == false)'){
    my $r = $i->interpret($source);
    isa_ok($r, 'Interpreter::Lambda::Calculus::AST::Literal::Bool');
    is($r->val, 'true', '... got the right value');
}

foreach my $source ('(10 == 5)', '("ten" == "five")', '(true == false)', '(false == true)'){
    my $r = $i->interpret($source);
    isa_ok($r, 'Interpreter::Lambda::Calculus::AST::Literal::Bool');
    is($r->val, 'false', '... got the right value');
}

# and some in-equality
foreach my $source ('(10 != 5)', '("ten" != "five")', '(true != false)', '(false != true)'){
    my $r = $i->interpret($source);
    isa_ok($r, 'Interpreter::Lambda::Calculus::AST::Literal::Bool');
    is($r->val, 'true', '... got the right value');
}

foreach my $source ('(10 != 10)', '("ten" != "ten")', '(true != true)', '(false != false)'){
    my $r = $i->interpret($source);
    isa_ok($r, 'Interpreter::Lambda::Calculus::AST::Literal::Bool');
    is($r->val, 'false', '... got the right value');
}

# and some others

# greater than
foreach my $source ('(10 > 10)', '("a" > "a")'){
    my $r = $i->interpret($source);
    isa_ok($r, 'Interpreter::Lambda::Calculus::AST::Literal::Bool');
    is($r->val, 'false', '... got the right value');
}

foreach my $source ('(11 > 10)', '("b" > "a")'){
    my $r = $i->interpret($source);
    isa_ok($r, 'Interpreter::Lambda::Calculus::AST::Literal::Bool');
    is($r->val, 'true', '... got the right value');
}

# greater than or equal
foreach my $source ('(10 >= 10)', '("a" >= "a")'){
    my $r = $i->interpret($source);
    isa_ok($r, 'Interpreter::Lambda::Calculus::AST::Literal::Bool');
    is($r->val, 'true', '... got the right value');
}

foreach my $source ('(9 >= 10)', '("a" >= "b")'){
    my $r = $i->interpret($source);
    isa_ok($r, 'Interpreter::Lambda::Calculus::AST::Literal::Bool');
    is($r->val, 'false', '... got the right value');
}

# less than
foreach my $source ('(10 < 10)', '("a" < "a")'){
    my $r = $i->interpret($source);
    isa_ok($r, 'Interpreter::Lambda::Calculus::AST::Literal::Bool');
    is($r->val, 'false', '... got the right value');
}

foreach my $source ('(9 < 10)', '("a" < "b")'){
    my $r = $i->interpret($source);
    isa_ok($r, 'Interpreter::Lambda::Calculus::AST::Literal::Bool');
    is($r->val, 'true', '... got the right value');
}

# less than or equal
foreach my $source ('(10 <= 10)', '("a" <= "a")'){
    my $r = $i->interpret($source);
    isa_ok($r, 'Interpreter::Lambda::Calculus::AST::Literal::Bool');
    is($r->val, 'true', '... got the right value');
}

foreach my $source ('(10 <= 9)', '("b" <= "a")'){
    my $r = $i->interpret($source);
    isa_ok($r, 'Interpreter::Lambda::Calculus::AST::Literal::Bool');
    is($r->val, 'false', '... got the right value');
}


{
    my $bool = $i->parse('(true)');
    isa_ok($bool, 'Interpreter::Lambda::Calculus::AST::Literal::Bool');
    ok($bool->is_true, '... this it true');
    ok(!$bool->is_false, '... this it not false');    
}


