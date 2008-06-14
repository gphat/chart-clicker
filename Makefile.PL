use inc::Module::Install;

name        'Chart-Clicker';
all_from    'lib/Chart/Clicker.pm';

requires    'Cairo'             => 1.00;
requires    'Moose'             => 0.25;
requires    'DateTime'          => 0.36;
requires    'DateTime::Set'     => 0.25;
#requires    'Chart::Math::Axis' => 1.01;

auto_install;

WriteAll;
