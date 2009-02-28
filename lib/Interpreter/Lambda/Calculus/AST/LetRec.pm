package Interpreter::Lambda::Calculus::AST::LetRec;
use Moose;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

extends 'Interpreter::Lambda::Calculus::AST::Let';

sub eval {
    my ($self, %env) = @_;
    my $func = $self->val->eval(%env);
    ($func->isa('Interpreter::Lambda::Calculus::AST::Closure'))
        || confess "f must evaluate to a closure";    
    # add a binding for the function 
    # itself within the closure
    $func->env->{ $self->var } = $func; 
    $env{ $self->var } = $func;        
    $self->body->eval(%env);
}

sub pprint {
    my $self = shift;
    '(let rec ' . $self->var . ' = ' . $self->val->pprint . ' in ' . $self->body->pprint . ')'
}

__PACKAGE__->meta->make_immutable;

no Moose; 1;

__END__

=pod

=head1 NAME

Interpreter::Lambda::Calculus::AST::LetRec - A Moosey solution to this problem

=head1 SYNOPSIS

  use Interpreter::Lambda::Calculus::AST::LetRec;

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
