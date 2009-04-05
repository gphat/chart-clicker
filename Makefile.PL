use inc::Module::Install 0.75;

name        'Chart-Clicker';
all_from    'lib/Chart/Clicker.pm';

requires    'Color::Scheme'     => 1.02;
requires    'Moose'             => 0.57;
requires    'MooseX::AttributeHelpers' => 0.13;
requires    'DateTime'          => 0.4302;
requires    'DateTime::Set'     => 0.25;
requires    'IO::File';
requires    'Math::Trig' => 1.18;
requires    'Scalar::Util' => 1.19;

requires    'Geometry::Primitive' => 0.13;
requires    'Graphics::Color' => 0.19;
requires    'Graphics::Primitive' => 0.38;
requires    'Graphics::Primitive::Driver::Cairo' => 0.33;
requires    'Layout::Manager' => 0.20;


WriteAll;
