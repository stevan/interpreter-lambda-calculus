package Interpreter::Lambda::Calculus::AST::IfElse;
use Moose;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

extends 'Interpreter::Lambda::Calculus::AST::Term';

has 'cond' => (is => 'ro', isa => 'Interpreter::Lambda::Calculus::AST::Term');
has 'e1'   => (is => 'ro', isa => 'Interpreter::Lambda::Calculus::AST::Term');
has 'e2'   => (is => 'ro', isa => 'Interpreter::Lambda::Calculus::AST::Term');        

sub eval {
    my ($self, %env) = @_;
    my $r = $self->cond->eval(%env);
    $r->isa('Interpreter::Lambda::Calculus::AST::Literal::Bool')
        || confess "Type Error, conditional must evaulate to a Bool";
    if ($r->is_true) {
        $self->e1->eval(%env);
    }
    else {
        $self->e2->eval(%env);            
    }
}

sub pprint {
    my $self = shift;
    '(if ' . $self->cond->pprint . ' then ' . $self->e1->pprint . ' else ' . $self->e2->pprint . ')'
}

__PACKAGE__->meta->make_immutable;

no Moose; 1;

__END__

=pod

=head1 NAME

Interpreter::Lambda::Calculus::AST::IfElse - A Moosey solution to this problem

=head1 SYNOPSIS

  use Interpreter::Lambda::Calculus::AST::IfElse;

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
