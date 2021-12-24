#! /usr/bin/env perl
# SPDX-License-Identifier: MIT

########################################################################
#                                                                      #
#  This file is part of the solution set for the programming puzzles   #
#  presented by the 2021 Advent of Code challenge.                     #
#  See: https://adventofcode.com/2021                                  #
#                                                                      #
#  Copyright © 2021  Chindraba (Ronald Lamoreaux)                      #
#                    <aoc@chindraba.work>                              #
#  - All Rights Reserved                                               #
#                                                                      #
#  Permission is hereby granted, free of charge, to any person         #
#  obtaining a copy of this software and associated documentation      #
#  files (the "Software"), to deal in the Software without             #
#  restriction, including without limitation the rights to use, copy,  #
#  modify, merge, publish, distribute, sublicense, and/or sell copies  #
#  of the Software, and to permit persons to whom the Software is      #
#  furnished to do so, subject to the following conditions:            #
#                                                                      #
#  The above copyright notice and this permission notice shall be      #
#  included in all copies or substantial portions of the Software.     #
#                                                                      #
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,     #
#  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF  #
#  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND               #
#  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS #
#  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN  #
#  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN   #
#  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE    #
#  SOFTWARE.                                                           #
#                                                                      #
########################################################################

use 5.030000;
use strict;
use warnings;
use Elves::GetData qw( :all );
use Elves::Reports qw( :all );
use List::Util qw(sum);

my $VERSION = '0.21.17';

my $result = 0;

my ($x_lo, $x_hi, $y_lo, $y_hi) = slurp_data($main::puzzle_data_file) =~ /-?\d+/g;

sub launch #($x_vel, $y_vel, $x_lo, $x_hi, $y_lo, $y_hi)
{
  my ($x_vel, $y_vel, $x_lo, $x_hi, $y_lo, $y_hi) = @_;
  my ($x, $y) = (0, 0);
  while ($x <= $x_hi && $y >= $y_lo)
  {
    return 1 if $x >= $x_lo && $y <= $y_hi;
    $x  += $x_vel;
    $x_vel += 0 <=> $x_vel;
    $y  += $y_vel--;
  }
}

# Part 1

my $peak_factor = - $y_lo - 1;
$result = $peak_factor * ($peak_factor + 1) / 2;
report_number(1, $result);

die 'Not running part 2 yet.' unless $main::do_part_2;
# Part 2

$result = sum map {
    my $x_vel = $_; scalar grep { launch($x_vel, $_, $x_lo, $x_hi, $y_lo, $y_hi) } $y_lo..-$y_lo
} 1..$x_hi;
report_number(2, $result);


1;
