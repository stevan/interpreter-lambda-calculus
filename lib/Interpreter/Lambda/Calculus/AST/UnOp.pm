package Interpreter::Lambda::Calculus::AST::UnOp;
use metaclass 'MooseX::MetaDescription::Meta::Class' => (
    description => {
        traits => [ 'Interpreter::Lambda::Calculus::Description::UnOp' ]
    }
);
use Moose;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

extends 'Interpreter::Lambda::Calculus::AST::Term';    

has 'arg' => (is => 'ro', isa => 'Interpreter::Lambda::Calculus::AST::Term');    

sub eval_arg {
    my ($self, $env) = @_;
    
    my $expr_type            = $self->meta->metadescription->expression_type;
    my $expr_type_constraint = $self->meta->metadescription->expression_type_constraint;
    
    my $arg = $self->arg->eval(%$env);
    ($expr_type_constraint->check($arg))
        || confess "TYPE ERROR: Argument evaluated to ($arg), expected ($expr_type)";
        
    return $arg;    
}

sub pprint {
    my $self = shift;
    '(' . $self->meta->metadescription->operator . ' ' 
        . $self->arg->pprint . ')'
}

__PACKAGE__->meta->make_immutable;

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

Copyright 2008-2009 Infinity Interactive, Inc.

L<http://www.iinteractive.com>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
