#!/usr/bin/perl

use strict;
use warnings;
use FindBin;

use lib "$FindBin::Bin/../lib";

use Interpreter::Lambda::Calculus::REPL;

Interpreter::Lambda::Calculus::REPL->new->run;

