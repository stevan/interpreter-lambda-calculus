package Interpreter::Lambda::Calculus::AST::BinOp::Mod;
use Moose;

use Interpreter::Lambda::Calculus::AST::Literal::Int;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

extends 'Interpreter::Lambda::Calculus::AST::BinOp';  

__PACKAGE__->meta->description->{operator}        = '%';
__PACKAGE__->meta->description->{expression_type} = 'Interpreter::Lambda::Calculus::AST::Literal::Int';

sub eval {
    my ($self, %env) = @_;
    my ($left, $right) = $self->evaluate_left_and_right(\%env);
    Interpreter::Lambda::Calculus::AST::Literal::Int->new(
        val => ($left->val % $right->val)
    );
}

no Moose; 1;

__END__

=pod

=head1 NAME

Interpreter::Lambda::Calculus::AST::BinOp::Mod - A Moosey solution to this problem

=head1 SYNOPSIS

  use Interpreter::Lambda::Calculus::AST::BinOp::Mod;

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
