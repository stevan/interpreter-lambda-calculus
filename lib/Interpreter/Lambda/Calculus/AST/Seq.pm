package Interpreter::Lambda::Calculus::AST::Seq;
use Moose;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

extends 'Interpreter::Lambda::Calculus::AST::Term';

has 'nodes' => (
    is      => 'ro',
    isa     => 'ArrayRef[Interpreter::Lambda::Calculus::AST::Term]',   
    default => sub { [] },
);

sub eval {
    my ($self, %env) = @_;
    my $rv;
    foreach my $node (@{ $self->nodes }) {
        $rv = $node->eval(%env);
    }
    return $rv;
}

sub pprint {
    my $self = shift;
    join "\n" => map { $_->pprint } @{ $self->nodes };
}

__PACKAGE__->meta->make_immutable;

no Moose; 1;

__END__

=pod

=head1 NAME

Interpreter::Lambda::Calculus::AST::Seq - Lambda Calculus Interpreter in Perl

=head1 SYNOPSIS

  use Interpreter::Lambda::Calculus::AST::Seq;

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
