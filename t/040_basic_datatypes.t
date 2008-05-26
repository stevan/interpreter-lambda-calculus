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
    my $d = $i->interpret(q{
        (type bool = (True False))    
    });
    isa_ok($d, 'Interpreter::Lambda::Calculus::AST::Literal::DataType');
    is($d->name, 'bool', '... got the right name');

    my $true  = $d->type_set->[0];
    isa_ok($true, 'Interpreter::Lambda::Calculus::AST::Literal::DataType::Constructor');

    is($true->name, 'True', '... got the right name');
    is($true->arity, 0, '... True is nulary');

    my $false = $d->type_set->[1];
    isa_ok($false, 'Interpreter::Lambda::Calculus::AST::Literal::DataType::Constructor');

    is($false->name, 'False', '... got the right name');
    is($false->arity, 0, '... False is nulary');

    is_deeply($d->type_map, { 'False' => $false, 'True' => $true }, '... got the right type map');

    is($d->pprint, '(type bool = (True) | (False))', '... got the right pretty print');
}

{
    my $d = $i->interpret(q{
        (type list = (
            (Nil) 
            (Cons (head tail))
        ))    
    });
    isa_ok($d, 'Interpreter::Lambda::Calculus::AST::Literal::DataType');
    is($d->name, 'list', '... got the right name');

    my $nil  = $d->type_set->[0];
    isa_ok($nil, 'Interpreter::Lambda::Calculus::AST::Literal::DataType::Constructor');

    is($nil->name, 'Nil', '... got the right name');
    is($nil->arity, 0, '... Nil is nulary');

    my $cons = $d->type_set->[1];
    isa_ok($cons, 'Interpreter::Lambda::Calculus::AST::Literal::DataType::Constructor');

    is($cons->name, 'Cons', '... got the right name');
    is_deeply($cons->value_list, ['head', 'tail'], '... got the right value list');
    is($cons->arity, 2, '... Cons has 2 elements');

    is_deeply($d->type_map, { 'Nil' => $nil, 'Cons' => $cons }, '... got the right type map');

    is($d->pprint, '(type list = (Nil) | (Cons(head tail)))', '... got the right pretty print');
}














