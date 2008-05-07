package Interpreter::Lambda::Calculus::Description::BinOp;
use Moose;
use Moose::Util::TypeConstraints ();

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

extends 'MooseX::MetaDescription::Description';

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

no Moose; 1;

__END__

=pod

=head1 NAME

Interpreter::Lambda::Calculus::Description::BinOp - A Moosey solution to this problem

=head1 SYNOPSIS

  use Interpreter::Lambda::Calculus::Description::BinOp;

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
