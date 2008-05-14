package Interpreter::Lambda::Calculus::REPL;
use Moose;

use Term::ReadLine;
use Data::Dumper;

use Interpreter::Lambda::Calculus;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

has 'interpreter' => (
    is      => 'ro',
    isa     => 'Interpreter::Lambda::Calculus',   
    lazy    => 1,
    default => sub { 
        Interpreter::Lambda::Calculus->new 
    },
);

has 'term' => (
    is      => 'ro',
    isa     => 'Term::ReadLine::Perl',
    lazy    => 1,
    default => sub {
        Term::ReadLine->new;
    },
    handles => ['readline'],
);

has 'prompt' => (
    is      => 'ro',
    isa     => 'Str',   
    default => sub { '>> ' },
);

has 'banner' => (
    is      => 'ro',
    isa     => 'Str',   
    default => sub {  
        return join "\n"=> (
            "Interpreter::Lambda::Calculus | Version: $Interpreter::Lambda::Calculus::VERSION",
            "Written by: Stevan Little <stevan.little\@iinteractive.com>",
            "Copyright 2008 Infinity Interactive, Inc.",
        );
    },
);

sub run {
    my $self = shift;
    print $self->banner;        
    while (1) {
        my $line = $self->readline($self->prompt);
        eval { print $self->interpreter->interpret($line)->pprint, "\n" };
        if ($@) {
            print "Error has occurred:\n    code: '$line'\n    error: $@";
        }
    }
}

no Moose; 1;

__END__

=pod

=head1 NAME

Interpreter::Lambda::Calculus::REPL - A Moosey solution to this problem

=head1 SYNOPSIS

  use Interpreter::Lambda::Calculus::REPL;

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
