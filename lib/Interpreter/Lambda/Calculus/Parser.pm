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

has 'compound_node_definitions' => (
    is      => 'ro',
    isa     => 'ArrayRef',
    lazy    => 1,   
    default => sub {
        my $self = shift;
        return +[
            [
                [ undef ],
                sub {
                    my $nodes = shift;
                    $self->create_ast($nodes->[0])                
                }
            ],
            [
                [ undef, undef ],
                sub {
                    my $nodes = shift;
                    return $self->create_node('App')->new(
                        f   => $self->create_ast($nodes->[0]),
                        arg => $self->create_ast($nodes->[1]),
                    );                
                }
            ],
            [
                [ 'if', undef, 'then', undef, 'else', undef ],
                sub {
                    my $nodes = shift;
                    return $self->create_node('IfElse')->new(
                        cond => $self->create_ast($nodes->[1]),
                        e1   => $self->create_ast($nodes->[3]),
                        e2   => $self->create_ast($nodes->[5]),
                    );                
                }
            ],
            [
                [ 'let', undef, '=', undef, 'in', undef ],
                sub {
                    my $nodes = shift;
                    return $self->create_node('Let')->new(
                        var  => $nodes->[1]->name,
                        val  => $self->create_ast($nodes->[3]),
                        body => $self->create_ast($nodes->[5]),
                    );
                }
            ],        
            [
                [ 'let', 'rec', undef, '=', undef, 'in', undef ],
                sub {
                    my $nodes = shift;
                    return $self->create_node('LetRec')->new(
                        var  => $nodes->[2]->name,
                        val  => $self->create_ast($nodes->[4]),
                        body => $self->create_ast($nodes->[6]),
                    );
                }
            ],  
            [
                [ 'lambda', undef, undef ],
                sub {
                    my $nodes = shift;
                    return $self->create_node('Lambda')->new(
                        param => $self->create_ast($nodes->[1]),
                        body  => $self->create_ast($nodes->[2]),
                    );                    
                }
            ],
            map {
                my $op = $_;
                [
                    [ $op, undef, undef ],
                    sub {
                        my $nodes = shift;
                        return $self->create_node($self->binop_map->{ $op })->new(
                            left  => $self->create_ast($nodes->[1]),
                            right => $self->create_ast($nodes->[2]),
                        );
                    }
                ]
            } keys %{ $self->binop_map }
        ];        
    },
);

has 'singular_node_definitions' => (
    is      => 'ro',
    isa     => 'ArrayRef',
    lazy    => 1,   
    default => sub {
        my $self = shift;
        return +[
            # Literals
            [ 
                sub { not blessed $_[0]                  },
                sub { $self->create_literal_node($_[0]) },            
            ],
            # Literal::Bool
            [ 
                sub { $self->create_node('Literal::Bool')->is_bool_type($_[0]->name) },
                sub { $self->create_node('Literal::Bool')->new(val => $_[0]->name)   },            
            ],
            # Unit
            [ 
                sub { $_[0]->name eq 'unit'             },
                sub { $self->create_node('Unit')->new() },            
            ],
            # Var
            [ 
                sub { 1 },
                sub { $self->create_node('Var')->new(name => $_[0]->name) },            
            ],        
        ]
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
    
    # NOTE:
    # these are basically to 
    # overcome the shortcomings
    # of Data::SExpressions
    # - SL
    $source =~ s/\n/ /g;       # remove newlines
    $source =~ s/\(\)/unit/g;  # and swap () for unit
    
    my ($root_node) = grep { !/^\s+$/ } $self->read_source($source);
    #warn Dumper $root_node;
    $self->ast($self->create_ast($root_node));
}

sub create_ast {
    my ($self, $node) = @_;
    return $self->create_compound_node($node) 
        if ref $node eq 'ARRAY';
    return $self->create_singular_node($node);
}

sub create_compound_node {
    my ($self, $nodes) = @_;
    
    OUTER: foreach my $node_definition (@{ $self->compound_node_definitions }) {
        my ($node_spec, $node_builder) = @$node_definition;
        next unless @$nodes == @$node_spec;
        foreach my $i (0 .. $#{$node_spec}) {
            next unless defined $node_spec->[$i];
            if ($node_spec->[$i] eq $nodes->[$i]) {
                next;
            }   
            else {
                next OUTER;
            }             
        }
        return $node_definition->[1]->($nodes);
    }
    
    confess "UNIMPLEMENTED node " . $nodes->[0]->name;    
}

sub create_singular_node {
    my ($self, $node) = @_;
    foreach my $test (@{ $self->singular_node_definitions }) {
        return $test->[1]->($node) 
            if $test->[0]->($node);
    }
}

sub create_literal_node {
    my ($self, $node) = @_;
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
