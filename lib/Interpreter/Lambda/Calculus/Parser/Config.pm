package Interpreter::Lambda::Calculus::Parser::Config;

use strict;
use warnings;

use Scalar::Util 'blessed', 'looks_like_number';

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

our %BINOP_TABLE = (
    # int binops
    'add' => 'BinOp::Add',
    'mul' => 'BinOp::Mul',
    'sub' => 'BinOp::Sub',
    'div' => 'BinOp::Div',
    'mod' => 'BinOp::Mod',
    # as operators
    '+'   => 'BinOp::Add',
    '*'   => 'BinOp::Mul',
    '-'   => 'BinOp::Sub',
    '/'   => 'BinOp::Div',
    # bool binops
    'eq'  => 'BinOp::Eq',
    'ne'  => 'BinOp::Ne',
    'gt'  => 'BinOp::Gt',
    'lt'  => 'BinOp::Lt',
    'ge'  => 'BinOp::GtEq',
    'le'  => 'BinOp::LtEq',
    # as operators
    '=='  => 'BinOp::Eq',
    '!='  => 'BinOp::Ne',
    '>'   => 'BinOp::Gt',
    '<'   => 'BinOp::Lt',
    '>='  => 'BinOp::GtEq',
    '<='  => 'BinOp::LtEq',
);

sub create_compound_node_spec_checker {
    my $node_spec = shift;
    return sub {
        my ($parser, $nodes) = @_;
        return 0 unless @$nodes == @$node_spec;
        foreach my $i (0 .. $#{$node_spec}) {
            next unless defined $node_spec->[$i];
            if ($node_spec->[$i] eq $nodes->[$i]) {
                next;
            }
            else {
                return 0;
            }
        }
        return 1;
    };
}

our @COMPOUND_NODE_DEFINITIONS = (
    [
        create_compound_node_spec_checker(
            [ undef ]
        ),
        sub {
            my ($parser, $nodes) = @_;
            $parser->create_ast($nodes->[0])
        }
    ],
    [
        create_compound_node_spec_checker(
            [ undef, undef ]
        ),
        sub {
            my ($parser, $nodes) = @_;
            return $parser->create_node('App')->new(
                f   => $parser->create_ast($nodes->[0]),
                arg => $parser->create_ast($nodes->[1]),
            );
        }
    ],
    [
        create_compound_node_spec_checker(
            [ 'if', undef, 'then', undef, 'else', undef ]
        ),
        sub {
            my ($parser, $nodes) = @_;
            return $parser->create_node('IfElse')->new(
                cond => $parser->create_ast($nodes->[1]),
                e1   => $parser->create_ast($nodes->[3]),
                e2   => $parser->create_ast($nodes->[5]),
            );
        }
    ],
    [
        create_compound_node_spec_checker(
            [ 'let', undef, '=', undef, 'in', undef ]
        ),
        sub {
            my ($parser, $nodes) = @_;
            return $parser->create_node('Let')->new(
                var  => $nodes->[1]->name,
                val  => $parser->create_ast($nodes->[3]),
                body => $parser->create_ast($nodes->[5]),
            );
        }
    ],
    [
        create_compound_node_spec_checker(
            [ 'let', 'rec', undef, '=', undef, 'in', undef ]
        ),
        sub {
            my ($parser, $nodes) = @_;
            return $parser->create_node('LetRec')->new(
                var  => $nodes->[2]->name,
                val  => $parser->create_ast($nodes->[4]),
                body => $parser->create_ast($nodes->[6]),
            );
        }
    ],
    [
        create_compound_node_spec_checker(
            [ 'lambda', undef, undef ]
        ),
        sub {
            my ($parser, $nodes) = @_;
            return $parser->create_node('Lambda')->new(
                param => $parser->create_ast($nodes->[1]),
                body  => $parser->create_ast($nodes->[2]),
            );
        }
    ],
    map {
        my $op = $_;
        [
            create_compound_node_spec_checker(
                [ $op, undef, undef ]
            ),
            sub {
                my ($parser, $nodes) = @_;
                return $parser->create_node($BINOP_TABLE{$op})->new(
                    left  => $parser->create_ast($nodes->[1]),
                    right => $parser->create_ast($nodes->[2]),
                );
            }
        ]
    } keys %BINOP_TABLE,    
);

our @SINGULAR_NODE_DEFINITIONS = (
    # Literal::Int
    [
        sub { not( blessed $_[1] ) && looks_like_number($_[1])      },
        sub { $_[0]->create_node('Literal::Int')->new(val => $_[1]) },
    ],
    # Literal::Bool (sometimes it is not blessed)
    [
        sub { not( blessed $_[1] ) && $_[0]->create_node('Literal::Bool')->is_bool_type($_[1]) },
        sub { $_[0]->create_node('Literal::Bool')->new(val => $_[1])                           },
    ],
    # Literal::Str
    [
        sub { not( blessed $_[1] )                                  },
        sub { $_[0]->create_node('Literal::Str')->new(val => $_[1]) },
    ],
    # Literal::Bool (sometimes it is blessed)
    [
        sub { $_[0]->create_node('Literal::Bool')->is_bool_type($_[1]->name) },
        sub { $_[0]->create_node('Literal::Bool')->new(val => $_[1]->name)   },
    ],
    # Unit
    [
        sub { $_[1]->name eq 'unit'             },
        sub { $_[0]->create_node('Unit')->new() },
    ],
    # Var
    [
        sub { 1 },
        sub { $_[0]->create_node('Var')->new(name => $_[1]->name) },
    ],    
);

no Moose; 1;

__END__

=pod

=head1 NAME

Interpreter::Lambda::Calculus::Parser::Config - A Moosey solution to this problem

=head1 SYNOPSIS

  use Interpreter::Lambda::Calculus::Parser::Config;

=head1 DESCRIPTION

=head1 METHODS 

=over 4

=item B<>

=back

=head1 BUGS

All complex software has bugs lurking in it, and this module is no 
exception. If you find a bug please either email me, or add the bug
to cpan-RT.

=head1 AUTHOR

Stevan Little E<lt>stevan.little@iinteractive.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2008 Infinity Interactive, Inc.

L<http://www.iinteractive.com>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut