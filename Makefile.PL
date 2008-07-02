use inc::Module::Install;

name        'Chart-Clicker';
all_from    'lib/Chart/Clicker.pm';

test_requires 'Pod::Coverage::Moose';

requires    'Cairo'             => 1.060;
requires    'Moose'             => 0.51;
requires    'MooseX::AttributeHelpers' => 0.12;
requires    'DateTime'          => 0.4302;
requires    'DateTime::Set'     => 0.25;
requires    'IO::File';

requires    'Geometry::Primitive';
requires    'Graphics::Color';
requires    'Graphics::Primitive';
requires    'Layout::Manager';

auto_install;

WriteAll;
