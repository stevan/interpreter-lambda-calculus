#!/usr/bin/perl

use strict;
use warnings;

use Test::More no_plan => 1;
use Test::Exception;

BEGIN {
    use_ok('Interpreter::Lambda::Calculus');
    use_ok('Interpreter::Lambda::Calculus::AST::ConstructorApp');
    use_ok('Interpreter::Lambda::Calculus::AST::Literal::Int');
    #use_ok('Interpreter::Lambda::Calculus::AST::Match');
    #use_ok('Interpreter::Lambda::Calculus::AST::Match::Case');    
}

{
    my $i = Interpreter::Lambda::Calculus->new;
    isa_ok($i, 'Interpreter::Lambda::Calculus');

    my $d = $i->interpret(q{
        (type bool = (True False))
    });
    isa_ok($d, 'Interpreter::Lambda::Calculus::AST::Literal::DataType');

=pod

(let x = (True) in x)

=cut

    my $true_instance = Interpreter::Lambda::Calculus::AST::ConstructorApp->new(
        constructor => $d->type_map->{'True'}
    );
    isa_ok($true_instance, 'Interpreter::Lambda::Calculus::AST::ConstructorApp');
    isa_ok($true_instance, 'Interpreter::Lambda::Calculus::AST::Term');    
    
    is($true_instance->constructor, $d->type_map->{'True'}, '... got the right attached constructor');
    is($true_instance->constructor->arity, 0, '... True is nulary');

    is($true_instance->pprint, '(True)', '... got the right pprint');
    
=pod

(match x with (
    (True  -> true)
    (False -> false)
))

=cut

    #my $match = Interpreter::Lambda::Calculus::AST::Match->new(
    #    arg   => $true_instance,
    #    cases => [
    #        Interpreter::Lambda::Calculus::AST::Match::Case->new(
    #            constructor => $d->type_map->{'True'},
    #            result      => Interpreter::Lambda::Calculus::AST::Literal::Bool->new(val => 'true')
    #        ),
    #        Interpreter::Lambda::Calculus::AST::Match::Case->new(
    #            constructor => $d->type_map->{'False'},
    #            result      => Interpreter::Lambda::Calculus::AST::Literal::Bool->new(val => 'false')
    #        )
    #    ]
    #);
}

{
    my $i = Interpreter::Lambda::Calculus->new;
    isa_ok($i, 'Interpreter::Lambda::Calculus');

    my $d = $i->interpret(q{
        (type list = ((Nil) (Cons (head tail))))
    });
    isa_ok($d, 'Interpreter::Lambda::Calculus::AST::Literal::DataType');

=pod

(let l = (Cons (1 Nil)) in l)

=cut

    my $list_instance = Interpreter::Lambda::Calculus::AST::ConstructorApp->new(
        constructor => $d->type_map->{'Cons'},
        args        => [
            Interpreter::Lambda::Calculus::AST::Literal::Int->new(val => 1),
            Interpreter::Lambda::Calculus::AST::ConstructorApp->new(
                constructor => $d->type_map->{'Nil'},
            )
        ]
    );

=pod

(define length l = 
    (match l with (
        (Nil           -> 0)
        (Cons(_ tail)) -> (1 + (length tail)))
    ))
)
=cut

    #my $match = Interpreter::Lambda::Calculus::AST::Match->new(
    #    arg   => $list_instance,
    #    cases => [
    #        Interpreter::Lambda::Calculus::AST::Match::Case->new(
    #            constructor => $d->type_map->{'Nil'},
    #            result      => Interpreter::Lambda::Calculus::AST::Literal::Int->new(val => 0)
    #        ),
    #        Interpreter::Lambda::Calculus::AST::Match::Case->new(
    #            constructor => $d->type_map->{'Cons'},
    #            bind_vars   => [ undef, Interpreter::Lambda::Calculus::AST::Var->new(name => 'tail') ],
    #            result      => Interpreter::Lambda::Calculus::AST::Lambda->new(
    #                param => Interpreter::Lambda::Calculus::AST::Lambda::ParamType->new(name => 'tail'),
    #                body  => Interpreter::Lambda::Calculus::AST::Lambda::BinOp::Add->new(
    #                    left  => Interpreter::Lambda::Calculus::AST::Literal::Int->new(val => 1),
    #                    right => Interpreter::Lambda::Calculus::AST::Literal::App->new(
    #                        f   => Interpreter::Lambda::Calculus::AST::Var->new(name => 'length'),                           
    #                        arg => Interpreter::Lambda::Calculus::AST::Var->new(name => 'tail'),
    #                    )
    #                )
    #            )
    #        )
    #    ]
    #);

}

