# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# dir_traversing.pl
# ----------------------------------------------------------------------------
use strict;
use warnings;
use Path::Class;

my $dir = Path::Class::Dir->new('D:\00_WORK\08__perl');

my $max_depth = $dir->traverse(sub {
  my ($child, $cont, $depth) = @_;
  return max($cont->($depth + 1), $depth);
}, 0);

sub max {
    my $max = 0;
    for( @_ ) { $max = $_ if $_ > $max; }
    return $max;
};

my @output = ( sprintf("%-43s|%s", " Name", " mtime"),
               sprintf("%-43s|%s", '-' x 43, '-' x 11) );

my @tree = (0, 0);
my $last_indent = 0;

$dir->traverse( sub {
  my ($child, $cont, $indent) = @_;
  my $child_basename = $child->basename;
  my $child_stat     = $child->stat();
  my $child_mtime    = $child_stat->[9];

  $indent = 1 if (!defined $indent);
  my $width = 40 - 3 * ($indent - 1);

  if ($last_indent != $indent) {
    if ($last_indent > ($indent + 1)) {
      for my $level (($indent + 1)..($last_indent - 1)) {
        $output[$#output - $_] = 
          substr($output[$#output - $_], 0, 3 * ($level - 1)) . ' ' .
          substr($output[$#output - $_], 3 * ($level - 1) + 1, 65535) 
            for (0..$tree[$level] - 1);
      }
      delete $tree[$_] for $indent..$last_indent;
    }
    $tree[$indent] = 0;
    $last_indent = $indent;
  }

  if ($child->is_dir) {
    push @output, sprintf("%s+- %-${width}s| %d",
      ('|  ' x ($indent - 1)), $child_basename . '/', $child_mtime);
    $tree[$indent] = 0;
  }
  else {
    push @output, sprintf("%s%s- %-${width}s| %d", ('|  ' x ($indent - 1)),
      ($child eq ($child->dir->children)[-1] ? '\\' : '|' ),
      $child_basename, $child_mtime);
    $tree[$indent]++;
  }
  $tree[$_]++ for (1..$indent - 1);

  $cont->($indent + 1);
});

for my $level (1..$last_indent - 1) {
  $output[$#output - $_] = 
    substr($output[$#output - $_], 0, 3 * ($level - 1)) . ' ' .
    substr($output[$#output - $_], 3 * ($level - 1) + 1, 65535)
      for (0..$tree[$level] - 1);
}

print "$_\n" for @output;
