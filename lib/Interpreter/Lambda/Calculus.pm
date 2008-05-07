package Interpreter::Lambda::Calculus;
use Moose;

use Interpreter::Lambda::Calculus::Parser;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

has 'parser' => (
    is      => 'ro',
    isa     => 'Interpreter::Lambda::Calculus::Parser',   
    lazy    => 1,
    default => sub { 
        Interpreter::Lambda::Calculus::Parser->new;
    },
);

sub interpret {
    my ($self, $source) = @_;
    $self->parser->parse($source)->eval;
}

no Moose; 1;

__END__

=pod

=head1 NAME

Interpreter::Lambda::Calculus - A Moosey solution to this problem

=head1 SYNOPSIS

  use Interpreter::Lambda::Calculus;

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
