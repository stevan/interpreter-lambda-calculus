package Interpreter::Lambda::Calculus::Parser;
use Moose;

use Data::SExpression;
use Data::Dumper;
use Scalar::Util 'looks_like_number';

use Interpreter::Lambda::Calculus::AST;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

has 'binop_map' => (
    is      => 'ro',
    isa     => 'HashRef',
    default => sub {
        return +{
            # int binops
            'add' => 'BinOp::Add',
            'mul' => 'BinOp::Mul',
            'sub' => 'BinOp::Sub',
            'div' => 'BinOp::Div',
            'mod' => 'BinOp::Mod',
            # as operators
            '+' => 'BinOp::Add',
            '*' => 'BinOp::Mul',
            '-' => 'BinOp::Sub',
            '/' => 'BinOp::Div',
            # bool binops
            'eq' => 'BinOp::Eq',
            'ne' => 'BinOp::Ne',
            'gt' => 'BinOp::Gt',
            'lt' => 'BinOp::Lt',            
            'ge' => 'BinOp::GtEq',
            'le' => 'BinOp::LtEq',            
            # as operators
            '==' => 'BinOp::Eq',
            '!=' => 'BinOp::Ne',
            '>' => 'BinOp::Gt',
            '<' => 'BinOp::Lt',            
            '>=' => 'BinOp::GtEq',
            '<=' => 'BinOp::LtEq',            
        }
    },
);

has 'lexer' => (
    is      => 'ro',
    isa     => 'Data::SExpression',
    lazy    => 1,
    default => sub {
        Data::SExpression->new({
            use_symbol_class => 1,
        });
    },
    handles => {
        'read_source' => 'read',
    },
);

has 'ast_factory' => (
    is      => 'ro',
    isa     => 'Interpreter::Lambda::Calculus::AST',
    lazy    => 1,
    default => sub {
        Interpreter::Lambda::Calculus::AST->new
    },
    handles => {
        'create_node' => 'node',
    }
);

has 'ast' => (is => 'rw', isa => 'Interpreter::Lambda::Calculus::AST::Term');

sub parse {
    my ($self, $source) = @_;
    
    $source =~ s/\(\)/unit/g;
    
    my ($root_node) = grep { !/^\s+$/ } $self->read_source($source);
    #warn Dumper $root_node;
    $self->ast($self->create_ast($root_node));
}

sub create_ast {
    my ($self, $node) = @_;

    if (ref $node eq 'ARRAY') {
        my @nodes = @$node;

        if (scalar @nodes == 2) {
            return $self->create_node('App')->new(
                f   => $self->create_ast($nodes[0]),
                arg => $self->create_ast($nodes[1]),
            );                
        }
        elsif (scalar @nodes == 6) {
            if ($nodes[0]->name eq 'if') {
                return $self->create_node('IfElse')->new(
                    cond => $self->create_ast($nodes[1]),
                    e1   => $self->create_ast($nodes[3]),
                    e2   => $self->create_ast($nodes[5]),
                );
            }
            elsif ($nodes[0]->name eq 'let') {
                return $self->create_node('Let')->new(
                    var  => $nodes[1]->name,
                    val  => $self->create_ast($nodes[3]),
                    body => $self->create_ast($nodes[5]),
                );
            }
        }
        elsif (scalar @nodes == 1) {
            return $self->create_ast($nodes[0]);
        }
        elsif (scalar @nodes == 7) {
            if ($nodes[0]->name eq 'let' && $nodes[1]->name eq 'rec') {
                return $self->create_node('LetRec')->new(
                    var  => $nodes[2]->name,
                    val  => $self->create_ast($nodes[4]),
                    body => $self->create_ast($nodes[6]),
                );
            }
        }

        (blessed $nodes[0])
            || confess "first node cannot be a literal";

        my %binops = %{ $self->binop_map };

        if (exists $binops{ $nodes[0]->name }) {
            return $self->create_node($binops{ $nodes[0]->name })->new(
                left  => $self->create_ast($nodes[1]),
                right => $self->create_ast($nodes[2]),
            );
        }
        elsif ($nodes[0]->name eq 'lambda') {
            return $self->create_node('Lambda')->new(
                param => $self->create_ast($nodes[1]),
                body  => $self->create_ast($nodes[2]),
            );
        }
        else {
            confess "UNIMPLEMENTED node " . $nodes[0]->name;
        }
    }
    else {
        if (blessed $node) {
            if ($self->create_node('Literal::Bool')->is_bool_type($node->name)) {                
                return $self->create_node('Literal::Bool')->new(val => $node->name);
            }
            else {
                if ($node->name eq 'unit') {
                    return $self->create_node('Unit')->new();
                }
                else {                    
                    return $self->create_node('Var')->new(name => $node->name);
                }
            }

        }
        else {
            if (looks_like_number($node)) {
                return $self->create_node('Literal::Int')->new(val => $node);
            }
            elsif ($self->create_node('Literal::Bool')->is_bool_type($node)) {
                return $self->create_node('Literal::Bool')->new(val => $node);
            }
            else {
                return $self->create_node('Literal::Str')->new(val => $node);
            }
        }
    }
}

no Moose; 1;

__END__

=pod

=head1 NAME

Interpreter::Lambda::Calculus::Parser - A Moosey solution to this problem

=head1 SYNOPSIS

  use Interpreter::Lambda::Calculus::Parser;

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
