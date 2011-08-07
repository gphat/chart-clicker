use strict;
use warnings;
use Test::More;
use Test::Exception;

BEGIN {
  use_ok('Chart::Clicker::Drawing::ColorAllocator');
}

my $allocator;
lives_ok {
  $allocator = Chart::Clicker::Drawing::ColorAllocator->new({ seed_hue => 0 });
} 'instantiates';

is_deeply($allocator->hues, [ 0, 45, 75, 15, 60, 30 ], 'default seed hues');
is_deeply($allocator->shade_order, [ 1, 3, 0, 2 ], 'default shade order');

my @colors;
for my $shade ( 1, 3, 0, 2){
  for my $seed_hue (0, 45, 75, 15, 60, 30 ){
    for my $color_idx ( 0..3 ){
      $allocator->color_scheme->from_hue($seed_hue);
      my $color = $allocator->color_scheme->colorset->[$color_idx]->[$shade];
      push(@colors, $color);
    }
  }
}

#96
for my $color ( @colors ){
  my $allocated = lc $allocator->next->as_hex_string;
  $allocated =~ s/#//;
  is($allocated, lc $color, 'color order');
}

#1
$allocator->next;
is(
  $allocator->colors->[0]->as_hex_string,
  $allocator->colors->[96]->as_hex_string,
  'goes full circle'
);

done_testing;