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
    lazy    => 1,
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
                    my ($parser, $nodes) = @_;
                    $parser->create_ast($nodes->[0])                
                }
            ],
            [
                [ undef, undef ],
                sub {
                    my ($parser, $nodes) = @_;
                    return $parser->create_node('App')->new(
                        f   => $parser->create_ast($nodes->[0]),
                        arg => $parser->create_ast($nodes->[1]),
                    );                
                }
            ],
            [
                [ 'if', undef, 'then', undef, 'else', undef ],
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
                [ 'let', undef, '=', undef, 'in', undef ],
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
                [ 'let', 'rec', undef, '=', undef, 'in', undef ],
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
                [ 'lambda', undef, undef ],
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
                    [ $op, undef, undef ],
                    sub {
                        my ($parser, $nodes) = @_;
                        return $parser->create_node($self->binop_map->{ $op })->new(
                            left  => $parser->create_ast($nodes->[1]),
                            right => $parser->create_ast($nodes->[2]),
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
        return $node_definition->[1]->($self, $nodes);
    }
    
    confess "UNIMPLEMENTED node " . $nodes->[0]->name;    
}

sub create_singular_node {
    my ($self, $node) = @_;
    foreach my $test (@{ $self->singular_node_definitions }) {
        return $test->[1]->($self, $node) 
            if $test->[0]->($self, $node);
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
