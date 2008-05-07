package Interpreter::Lambda::Calculus::AST::BinOp;
use Interpreter::Lambda::Calculus::Description::BinOp;
use metaclass 'MooseX::MetaDescription::Meta::Class' => (
    metadescription_classname => 'Interpreter::Lambda::Calculus::Description::BinOp'
);
use Moose;
use Moose::Util::TypeConstraints;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

extends 'Interpreter::Lambda::Calculus::AST::Term';    

has 'left'  => (is => 'ro', isa => 'Interpreter::Lambda::Calculus::AST::Term');    
has 'right' => (is => 'ro', isa => 'Interpreter::Lambda::Calculus::AST::Term');

sub evaluate_left_and_right {
    my ($self, $env) = @_;
    
    my $expr_type            = $self->meta->metadescription->expression_type;
    my $expr_type_constraint = $self->meta->metadescription->expression_type_constraint;
    
    my $left  = $self->left->eval(%$env);
    ($expr_type_constraint->check($left))
        || confess "TYPE ERROR: Left hand side evaluated to ($left), expected ($expr_type)";
        
    my $right = $self->right->eval(%$env);    
    ($expr_type_constraint->check($right))
        || confess "TYPE ERROR: Right hand side evaluated to ($right), expected ($expr_type)";    
        
    return ($left, $right);
}

sub pprint {
    my $self = shift;
    '(' . $self->meta->metadescription->operator . ' ' 
        . $self->left->pprint . ' ' . $self->right->pprint . ')'
}


no Moose; no Moose::Util::TypeConstraints; 1;

__END__

=pod

=head1 NAME

Interpreter::Lambda::Calculus::AST::BinOp - A Moosey solution to this problem

=head1 SYNOPSIS

  use Interpreter::Lambda::Calculus::AST::BinOp;

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