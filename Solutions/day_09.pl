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

my $VERSION = '0.21.09';

my $result = 0;

my @puzzle_data = read_lines $main::puzzle_data_file;

# Part 1
my @map = map { [split //] }@puzzle_data;
my @lows;
my $risk = 0;
for my $row (0..$#map) {
    for my $col (0..$#{$map[$row]}) {
        my $test = $map[$row]->[$col];
        my $is_low = 1;
        if ($row > 0 && $map[$row - 1]->[$col] <= $test) {
            $is_low *= 0;
        }
        if ($is_low && $row < $#map && $map[$row + 1]->[$col] <= $test) {
            $is_low *= 0;
        }
        if ($is_low && $col > 0 && $map[$row]->[$col - 1] <= $test) {
            $is_low *= 0;
        }
        if ($is_low && $col < $#{$map[$row]} && $map[$row]->[$col + 1] <= $test) {
            $is_low *= 0;
        }
        if ($is_low) {
            $risk += 1 + $test;
            push @lows, "$row:$col";
        }
    }
}
$result = $risk;
report_number(1, $result);

exit unless $main::do_part_2;


# Part 2
sub scan_range {
    my ($row, $step, $col, $lo_c, $hi_c, $size, %inside) = (0) x 6;
    $row = shift;
    $step = shift;
    return if (0 > $row + $step);
    return if ($row + $step > $#map);
    $row += $step;
    $lo_c = shift;
    if (0 != $step) {
        $hi_c = shift;
    } else {
        $hi_c = $#{$map[$row]};
    }
    $col = $lo_c;
    while ($col <= $hi_c) {
        my ($start, $stop) = (-1) x 2;
        my $sub_col = $col;
        while ($col >= 0 && 9 > $map[$row]->[$col]) {
            $inside{"$row:$col"} = "y";
            $start = $col--;
        }
        $col = 1 + $sub_col;
        while ($sub_col < $hi_c && $col <= $#{$map[$row]} && 9 > $map[$row]->[$col]) {
            $inside{"$row:$col"} = "y";
            $start = $col if (0 > $start);
            $stop = $col++;
        }
        if (-1 == $stop && -1 < $start) {
            $stop = $sub_col;
        };
        if (0 <= $stop && $row + $step >= 0 && $row + $step < @map) {
            my @subset;
            if (0 == $step) {
                for (scan_range($row, -1, $start, $stop)) {
                    $inside{$_} = 'y';
                }
                for (scan_range($row, 1, $start, $stop)) {
                    $inside{$_} = 'y';
                }
                $hi_c = -1;
            } else {
                for (scan_range($row, $step, $start, $stop)) {
                    $inside{$_} = 'y';
                }
            }
        }
    }
    return keys %inside;
}
my @totals;
for (@lows) {
    my ($r, $c) = split /:/, $_;
    my @tally = scan_range($r, 0, $c);
    push @totals, scalar(@tally);
}
@totals = (sort {$b <=> $a} @totals)[0..2];
$result = $totals[0] * $totals[1] * $totals[2];
report_number(2, $result);


1;
