package Interpreter::Lambda::Calculus::AST;
use Moose;

use Interpreter::Lambda::Calculus::AST::Term;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

has 'classname_prefix' => (
    is      => 'ro',
    isa     => 'Str',   
    default => sub { 'Interpreter::Lambda::Calculus::AST::' },
);

sub node {
    my ($self, $node_name) = @_;
    my $class = $self->classname_prefix . $node_name;
    Class::MOP::load_class($class);
    return $class;
}

__PACKAGE__->meta->make_immutable;

no Moose; 1;

__END__

=pod

=head1 NAME

Interpreter::Lambda::Calculus::AST - Lambda Calculus Interpreter in Perl

=head1 SYNOPSIS

  use Interpreter::Lambda::Calculus::AST;

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
