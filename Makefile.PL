use inc::Module::Install 0.75;

name        'Chart-Clicker';
all_from    'lib/Chart/Clicker.pm';

test_requires 'Pod::Coverage::Moose';

requires    'Moose'             => 0.54;
requires    'MooseX::AttributeHelpers' => 0.12;
requires    'DateTime'          => 0.4302;
requires    'DateTime::Set'     => 0.25;
requires    'IO::File';

requires    'Geometry::Primitive' => 0.08;
requires    'Graphics::Color' => 0.04;
requires    'Graphics::Primitive' => 0.12;
requires    'Graphics::Primitive::Driver::Cairo' => 0.06;
requires    'Layout::Manager' => 0.08;
requires    'Scalar::Util' => 1.19;

auto_install;

WriteAll;
