package Interpreter::Lambda::Calculus::AST::Literal::DataType::Constructor;
use Moose;
use Moose::Util::TypeConstraints;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

has 'name' => (
    is       => 'ro',
    isa      => subtype('Str' => where { /[A-Z][a-zA-Z]+/ }),  
    required => 1,     
);

has 'value_list' => (
    is      => 'ro',
    isa     => 'ArrayRef[Str]',
    lazy    => 1,
    default => sub { [] }   
);

has 'arity' => (
    is      => 'ro',
    isa     => 'Int',   
    lazy    => 1,
    default => sub { scalar @{ (shift)->value_list } },
);

sub eval { (shift) }

sub pprint {
    my $self = shift;
    if ($self->arity == 0) {
        return '(' . $self->name . ')';
    }
    else {
        return '(' . $self->name . '(' . (join " " => @{ $self->value_list }) . '))';        
    }
}

no Moose; 1;

__END__

=pod

=head1 NAME

Interpreter::Lambda::Calculus::AST::Literal::DataType::Constructor - A Moosey solution to this problem

=head1 SYNOPSIS

  use Interpreter::Lambda::Calculus::AST::Literal::DataType::Constructor;

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
