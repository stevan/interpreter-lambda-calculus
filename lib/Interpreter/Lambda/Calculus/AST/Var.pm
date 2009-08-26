package Interpreter::Lambda::Calculus::AST::Var;
use Moose;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

extends 'Interpreter::Lambda::Calculus::AST::Term';    

has 'name' => (is => 'ro', isa => 'Str');    

sub eval {
    my ($self, %env) = @_;
    my $name = $self->name;
    my $val  = $env{ $name } || $env{'__TOP_LEVEL_ENV__'}->{ $name };
    (defined $val)
        || confess "UNBOUND VARIABLE " . $self->name;
    return $val;
}

sub pprint {
    my $self = shift;
    '(' . $self->name . ')'
}

__PACKAGE__->meta->make_immutable;

no Moose; 1;

__END__

=pod

=head1 NAME

Interpreter::Lambda::Calculus::AST::Var - Lambda Calculus Interpreter in Perl

=head1 SYNOPSIS

  use Interpreter::Lambda::Calculus::AST::Var;

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
