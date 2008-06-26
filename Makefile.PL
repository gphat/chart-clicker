use inc::Module::Install;

name        'Chart-Clicker';
all_from    'lib/Chart/Clicker.pm';

requires    'Cairo'             => 1.00;
requires    'Moose'             => 0.25;
requires    'MooseX::AttributeHelpers';
requires    'DateTime'          => 0.36;
requires    'DateTime::Set'     => 0.25;
requires    'IO::File';

auto_install;

WriteAll;
