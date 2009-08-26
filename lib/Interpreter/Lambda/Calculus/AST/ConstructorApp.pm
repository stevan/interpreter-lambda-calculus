package Interpreter::Lambda::Calculus::AST::ConstructorApp;
use Moose;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

extends 'Interpreter::Lambda::Calculus::AST::Term';   

has 'constructor' => (
    is      => 'ro',
    isa     => 'Interpreter::Lambda::Calculus::AST::Literal::DataType::Constructor',   
);

has 'args' => (
    is      => 'ro',
    isa     => 'ArrayRef[Interpreter::Lambda::Calculus::AST::Term]',   
    lazy    => 1,
    default => sub { [] },
    trigger => sub {
        my $self = shift;
        ($self->arity == $self->constructor->arity)
            || confess "Constructor arity does not match args";        
    }
);

has 'arity' => (
    is      => 'ro',
    isa     => 'Int',   
    lazy    => 1,
    default => sub { scalar @{ (shift)->args } },
);

sub eval { (shift) }

sub pprint {
    my $self = shift;
    if ($self->arity == 0) {
        return '(' . $self->constructor->name . ')';
    }
    else {
        return '(' . $self->constructor->name . ' (' . (join " " => map { $_->pprint } @{ $self->args }) . '))';        
    }
}

__PACKAGE__->meta->make_immutable;

no Moose; 1;

__END__

=pod

=head1 NAME

ClassName - Lambda Calculus Interpreter in Perl

=head1 SYNOPSIS

  use ClassName;

=head1 BUGS

All complex software has bugs lurking in it, and this module is no 
exception. If you find a bug please either email me, or add the bug
to cpan-RT.

=head1 AUTHOR

Stevan Little E<lt>stevan.little@iinteractive.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2008-2009 Infinity Interactive, Inc.

L<http://www.iinteractive.com>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
