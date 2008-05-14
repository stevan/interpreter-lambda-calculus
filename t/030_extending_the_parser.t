#!/usr/bin/perl

use strict;
use warnings;

use Test::More no_plan => 1;
use Test::Exception;

BEGIN {
    use_ok('Interpreter::Lambda::Calculus');
}

{
    package Function;
    use Moose;
    extends 'Interpreter::Lambda::Calculus::AST::Term';
}

my $i = Interpreter::Lambda::Calculus->new;
isa_ok($i, 'Interpreter::Lambda::Calculus');

push @{ $i->parser->compound_node_definitions } => [
    Interpreter::Lambda::Calculus::Parser::Config::create_compound_node_spec_checker(
        [ 'fun', undef, undef, '=', undef ]
    ),
    sub {
        # just stub it for now
        return Function->new;
    }
];

my $func = $i->parse('(fun square x = (x * x))');
isa_ok($func, 'Function');






