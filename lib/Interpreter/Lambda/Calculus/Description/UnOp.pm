package Interpreter::Lambda::Calculus::Description::UnOp;
use Moose::Role;
use Moose::Util::TypeConstraints ();

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

has 'operator' => (
    is      => 'ro',
    isa     => 'Str',   
    default => sub { '' },
);

has 'expression_type' => (
    is      => 'ro',
    isa     => 'Str',   
    default => sub {
        'Interpreter::Lambda::Calculus::AST::Literal'
    },
);

has 'expression_type_constraint' => (
    is      => 'ro',
    isa     => 'Moose::Meta::TypeConstraint',   
    lazy    => 1,
    default => sub {
        my $self = shift;
        Moose::Util::TypeConstraints::find_or_create_type_constraint(
            $self->expression_type
        );        
    },
);

no Moose::Role; 1;

__END__

=pod

=head1 NAME

Interpreter::Lambda::Calculus::Description::UnOp - Lambda Calculus Interpreter in Perl

=head1 SYNOPSIS

  use Interpreter::Lambda::Calculus::Description::UnOp;

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
