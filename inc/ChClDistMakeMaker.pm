package inc::ChClDistMakeMaker;
use Moose;

extends 'Dist::Zilla::Plugin::MakeMaker::Awesome';

around '_build_WriteMakefile_dump' => sub {
      my $orig = shift;
      my $self = shift;
      my $str =$self->$orig();
      die "Graphics::Primitive::Driver::Cairo not found in Makefile.PL" unless $str =~ s/"Graphics::Primitive::Driver::Cairo"/(\$^O eq 'MSWin32'?"Graphics::Primitive::Driver::GD":"Graphics::Primitive::Driver::Cairo")/g;
      return $str;
};



1;
