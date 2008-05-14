package Interpreter::Lambda::Calculus::AST::Literal::Bool;
use Moose;
use Moose::Util::TypeConstraints; 

use Interpreter::Lambda::Calculus::Types;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

extends 'Interpreter::Lambda::Calculus::AST::Literal';

has '+val' => (isa => 'Interpreter::Lambda::Calculus::AST::Literal::Bool::Type');

sub true  { 'true'  }   
sub false { 'false' }

sub is_true  { my $self = shift; $self->val eq $self->true  }   
sub is_false { my $self = shift; $self->val eq $self->false }

sub is_bool_type {
    my (undef, $value) = @_;
    find_type_constraint('Interpreter::Lambda::Calculus::AST::Literal::Bool::Type')->check($value);
}

sub is_equal {
    my ($left, $right) = @_;
    $left->val eq $right->val;
}

no Moose; no Moose::Util::TypeConstraints; 1;

__END__

=pod

=head1 NAME

Interpreter::Lambda::Calculus::AST::Literal::Bool - A Moosey solution to this problem

=head1 SYNOPSIS

  use Interpreter::Lambda::Calculus::AST::Literal::Bool;

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
