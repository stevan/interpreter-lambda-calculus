package Interpreter::Lambda::Calculus::AST::Literal::DataType;
use Moose;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

extends 'Interpreter::Lambda::Calculus::AST::Literal';

has 'name' => (
    is       => 'ro',
    isa      => 'Str',   
    required => 1,
);

has 'type_set' => (
    is       => 'ro',
    isa      => 'ArrayRef',   
    required => 1,    
);

has 'type_map' => (
    is      => 'ro',
    isa     => 'HashRef',
    lazy    => 1,   
    default => sub {
        my $self = shift;
        return +{
            map { 
                 $_->name => $_
            } @{ $self->type_set }
        };
    },
);

sub eval { (shift) }

sub pprint {
    my $self = shift;
    '(type ' . $self->name . ' = ' 
             . (join " | " => map { $_->pprint } @{ $self->type_set }) . ')'
}

__PACKAGE__->meta->make_immutable;

no Moose; 1;

__END__

=pod

=head1 NAME

Interpreter::Lambda::Calculus::AST::Literal::DataType - A Moosey solution to this problem

=head1 SYNOPSIS

  use Interpreter::Lambda::Calculus::AST::Literal::DataType;

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
