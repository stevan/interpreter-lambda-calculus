package Interpreter::Lambda::Calculus::Types;
use Moose qw(confess blessed);
use Moose::Util::TypeConstraints;

use Interpreter::Lambda::Calculus::AST::Var;
use Interpreter::Lambda::Calculus::AST::Unit;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

enum 'Interpreter::Lambda::Calculus::AST::Literal::Bool::Type' 
    => qw(true false);

subtype 'Interpreter::Lambda::Calculus::AST::Lambda::ParamType'
    => as 'Interpreter::Lambda::Calculus::AST::Var | Interpreter::Lambda::Calculus::AST::Unit';

# NOTE: 
# I am not sure i need this, 
# have to add more tests to 
# figure it out.
# - SL 
MooseX::Storage::Engine->add_custom_type_handler(
    'Interpreter::Lambda::Calculus::AST::Lambda::ParamType' => (
        %{ MooseX::Storage::Engine->find_type_handler(find_type_constraint('Object')) }
    )
);

no Moose::Util::TypeConstraints; 1;

__END__

=pod

=head1 NAME

=head1 SYNOPSIS

=head1 DESCRIPTION

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
