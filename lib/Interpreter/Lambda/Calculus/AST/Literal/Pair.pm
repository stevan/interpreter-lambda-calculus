package Interpreter::Lambda::Calculus::AST::Literal::Pair;
use Moose;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

extends 'Interpreter::Lambda::Calculus::AST::Literal';

has 'head' => (is => 'ro', isa => 'Interpreter::Lambda::Calculus::AST::Term');
has 'tail' => (is => 'ro', isa => 'Interpreter::Lambda::Calculus::AST::Term');

sub pprint {
    my $self = shift;
    '(' . $self->head->pprint . ' :: ' . $self->tail->pprint . ')';
}

sub is_equal {
    die "Cannot compare quality in Pair";
}

__PACKAGE__->meta->make_immutable;

no Moose; 1;

__END__

=pod

=head1 NAME

Interpreter::Lambda::Calculus::AST::Literal::Pair - Lambda Calculus Interpreter in Perl

=head1 SYNOPSIS

  use Interpreter::Lambda::Calculus::AST::Literal::Pair;

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
