use inc::Module::Install 0.75;

name        'Chart-Clicker';
all_from    'lib/Chart/Clicker.pm';

requires    'Moose'             => 0.57;
requires    'MooseX::AttributeHelpers' => 0.13;
requires    'DateTime'          => 0.4302;
requires    'DateTime::Set'     => 0.25;
requires    'IO::File';

requires    'Geometry::Primitive' => 0.13;
requires    'Graphics::Primitive' => 0.37;
requires    'Graphics::Primitive::Driver::Cairo' => 0.32;
requires    'Layout::Manager' => 0.20;
requires    'Math::Trig' => 1.18;
requires    'Scalar::Util' => 1.19;

WriteAll;
