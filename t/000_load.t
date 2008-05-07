#!/usr/bin/perl

use strict;
use warnings;

use Test::More no_plan => 1;
use Test::Exception;

BEGIN {
    use_ok('Interpreter::Lambda::Calculus');
    use_ok('Interpreter::Lambda::Calculus::Parser');
    use_ok('Interpreter::Lambda::Calculus::AST');
    use_ok('Interpreter::Lambda::Calculus::AST::App');
    use_ok('Interpreter::Lambda::Calculus::AST::BinOp');
    use_ok('Interpreter::Lambda::Calculus::AST::BinOp::Add');
    use_ok('Interpreter::Lambda::Calculus::AST::BinOp::Sub');
    use_ok('Interpreter::Lambda::Calculus::AST::BinOp::Mul');    
    use_ok('Interpreter::Lambda::Calculus::AST::BinOp::Div');    
    use_ok('Interpreter::Lambda::Calculus::AST::BinOp::Mod');    
    use_ok('Interpreter::Lambda::Calculus::AST::BinOp::Eq');    
    use_ok('Interpreter::Lambda::Calculus::AST::BinOp::Ne');    
    use_ok('Interpreter::Lambda::Calculus::AST::Closure');
    use_ok('Interpreter::Lambda::Calculus::AST::IfElse');    
    use_ok('Interpreter::Lambda::Calculus::AST::Lambda');    
    use_ok('Interpreter::Lambda::Calculus::AST::Let');    
    use_ok('Interpreter::Lambda::Calculus::AST::Literal');
    use_ok('Interpreter::Lambda::Calculus::AST::Literal::Int');
    use_ok('Interpreter::Lambda::Calculus::AST::Literal::Bool');
    use_ok('Interpreter::Lambda::Calculus::AST::Literal::Str');
    use_ok('Interpreter::Lambda::Calculus::AST::Term');    
    use_ok('Interpreter::Lambda::Calculus::AST::Var');    
}
