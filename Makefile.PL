use strict;
use warnings;
use inc::Module::Install;

name 'Interpreter-Lambda-Calculus';
all_from 'lib/Interpreter/Lambda/Calculus.pm';
license 'perl';

# prereqs
requires 'Moose'                    => '0';
requires 'MooseX::Storage'          => '0';
requires 'MooseX::MetaDescription'  => '0';
requires 'Term::Readline'           => '0';
requires 'Data::SExpression'        => '0';

# things the tests need
build_requires 'Test::More'      => '0.62';
build_requires 'Test::Exception' => '0.21';

tests('t/*.t');

WriteAll();

