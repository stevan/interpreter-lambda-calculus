package Interpreter::Lambda::Calculus::AST::Define;
use Moose;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

extends 'Interpreter::Lambda::Calculus::AST::Term';

has 'var'    => (is => 'ro', isa => 'Str');
has 'lambda' => (is => 'ro', isa => 'Interpreter::Lambda::Calculus::AST::Lambda');

sub eval {
    my ($self, %env) = @_;
    $env{'__TOP_LEVEL_ENV__'}->{ $self->var } = $self->lambda->eval(%env);
}

sub pprint {
    my $self = shift;
    '(let ' . $self->var . ' ' . $self->lambda->param->pprint . ' = ' . $self->lambda->body->pprint . ')'
}

no Moose; 1;

__END__

=pod

=head1 NAME

Interpreter::Lambda::Calculus::AST::Define - A Moosey solution to this problem

=head1 SYNOPSIS

  use Interpreter::Lambda::Calculus::AST::Let;

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
