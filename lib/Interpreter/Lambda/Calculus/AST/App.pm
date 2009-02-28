package Interpreter::Lambda::Calculus::AST::App;
use Moose;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

extends 'Interpreter::Lambda::Calculus::AST::Term';    

has 'f'   => (is => 'ro', isa => 'Interpreter::Lambda::Calculus::AST::Term');    
has 'arg' => (is => 'ro', isa => 'Interpreter::Lambda::Calculus::AST::Term');

sub eval {
    my ($self, %env) = @_;
    my $func = $self->f->eval(%env); 
    ($func->isa('Interpreter::Lambda::Calculus::AST::Closure'))
        || confess "f must evaluate to a closure, got $func";
    my %_env = %{ $func->env };    
    $_env{ $func->param->name } = $self->arg->eval(%env)
        unless $func->param->isa('Interpreter::Lambda::Calculus::AST::Unit');
    $func->eval(%_env);
}

sub pprint {
    my $self = shift;
    '(' . $self->f->pprint . ' ' . $self->arg->pprint . ')'
}

__PACKAGE__->meta->make_immutable;

no Moose; 1;

__END__

=pod

=head1 NAME

Interpreter::Lambda::Calculus::AST::App - A Moosey solution to this problem

=head1 SYNOPSIS

  use Interpreter::Lambda::Calculus::AST::App;

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
