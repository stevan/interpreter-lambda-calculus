package Interpreter::Lambda::Calculus::AST::BinOp::Sub;
use Interpreter::Lambda::Calculus::Description::BinOp;
use metaclass 'MooseX::MetaDescription::Meta::Class' => (
    metadescription_classname => 'Interpreter::Lambda::Calculus::Description::BinOp',
    description => {
        operator        => '-',
        expression_type => 'Interpreter::Lambda::Calculus::AST::Literal::Int',        
    }
);
use Moose;

use Interpreter::Lambda::Calculus::AST::Literal::Int;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

extends 'Interpreter::Lambda::Calculus::AST::BinOp';  

sub eval {
    my ($self, %env) = @_;
    my ($left, $right) = $self->evaluate_left_and_right(\%env);
    Interpreter::Lambda::Calculus::AST::Literal::Int->new(
        val => ($left->val - $right->val)
    );
}

no Moose; 1;

__END__

=pod

=head1 NAME

Interpreter::Lambda::Calculus::AST::BinOp::Sub - A Moosey solution to this problem

=head1 SYNOPSIS

  use Interpreter::Lambda::Calculus::AST::BinOp::Sub;

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
