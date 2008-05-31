package Interpreter::Lambda::Calculus::Parser;
use Moose;

use Data::SExpression;
use Data::Dumper;

use Interpreter::Lambda::Calculus::Types;
use Interpreter::Lambda::Calculus::AST;
use Interpreter::Lambda::Calculus::Parser::Config;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

has 'binop_table' => (
    is      => 'ro',
    isa     => 'Interpreter::Lambda::Calculus::Parser::BinOpTable',
    lazy    => 1,
    default => sub { 
        \%Interpreter::Lambda::Calculus::Parser::Config::BINOP_TABLE 
    },
);

has 'compound_node_definitions' => (
    is      => 'ro',
    isa     => 'Interpreter::Lambda::Calculus::Parser::NodeDefinitions',
    lazy    => 1,
    default => sub {
        \@Interpreter::Lambda::Calculus::Parser::Config::COMPOUND_NODE_DEFINITIONS 
    },
);

has 'singular_node_definitions' => (
    is      => 'ro',
    isa     => 'Interpreter::Lambda::Calculus::Parser::NodeDefinitions',
    lazy    => 1,
    default => sub {
        \@Interpreter::Lambda::Calculus::Parser::Config::SINGULAR_NODE_DEFINITIONS
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

has 'type_map' => (
    is      => 'ro',
    isa     => 'HashRef',   
    default => sub { +{} },
);

sub parse {
    my ($self, $source) = @_;

    # NOTE:
    # these are basically to
    # overcome the shortcomings
    # of Data::SExpressions
    # - SL
    $source =~ s/\n/ /g;       # remove newlines
    $source =~ s/\(\)/unit/g;  # and swap () for unit
    $source =~ s/\[\]/nil/g;   # and swap [] for nil

    my ($root_node) = grep { $_ ne '' } $self->read_source("($source)");    
    #warn Dumper $root_node;    
    
    if (scalar @$root_node == 1) {
        $self->ast(
            $self->create_ast(
                $root_node->[0]
            )
        );
    }
    else {        
        $self->ast(
            $self->create_node('Seq')->new(
                nodes => [
                    (map { $self->create_ast($_) } @$root_node)
                ]
            )
        );
    }
    
    #print $self->ast->dump;
    
    $self->ast;
}

sub create_ast {
    my ($self, $node) = @_;

    my $node_definitions = ref $node eq 'ARRAY'
        ? $self->compound_node_definitions
        : $self->singular_node_definitions;

    foreach my $node_def (@$node_definitions) {
        return $node_def->[1]->($self, $node)
            if $node_def->[0]->($self, $node);
    }

    confess "UNIMPLEMENTED node " . Dumper $node;
}

sub register_type {
    my ($self, $type) = @_;
    foreach my $const (@{$type->type_set}) {
        $self->type_map->{$const->name} = {
            name        => $const->name,
            constructor => $const,
            type        => $type,
        };
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
