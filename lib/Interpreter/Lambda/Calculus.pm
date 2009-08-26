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
    handles => ['parse'],
);

has 'top_level_environment' => (
    is      => 'ro',
    isa     => 'HashRef',
    default => sub { +{} },
);

sub interpret {
    my ($self, $source) = @_;
    $self->parse($source)->eval(
        '__TOP_LEVEL_ENV__' => $self->top_level_environment,
    );
}

__PACKAGE__->meta->make_immutable;

no Moose; 1;

__END__

=pod

=head1 NAME

Interpreter::Lambda::Calculus - Lambda Calculus Interpreter in Perl

=head1 SYNOPSIS

  use Interpreter::Lambda::Calculus;

  # define and apply functions ...
  my $i = Interpreter::Lambda::Calculus->new;
  my $r = $i->interpret(q[
      (define double x = (x + x))
      (double 10)
  ]);
  print $r->val; # 20

  # first class functions ...
  my $r = $i->interpret(q[
      (define apply f = (lambda (x) (f x)))
      (define double x = (x + x))
      ((apply double) 10)
  ]);
  print $r->val; # 20

  # recursive functions and pair constructors ...
  my $r = $i->interpret(q[
      (define length l =
          (if (nil? l) then
              0
          else
              (1 + (length (second l)))))
      (length (10 : (10 : (10 : (10 : (10 : []))))))
  ]);
  print $r->val; # 5

=head1 DESCRIPTION

This is something I wrote just for fun, it is an interpreter for
a simple Scheme-like language based on lambda calculus. It was
written partially just because I wanted to write an interpreter,
but also as an exercise in writing one using Moose. It is still
in the very early stages and might never be anything more then
just a toy.

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
