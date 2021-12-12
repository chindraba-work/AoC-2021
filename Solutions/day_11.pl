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

my $VERSION = '0.21.11';

my $result = 0;

sub increment_matrix {
    my $matrix = shift;
    for (@$matrix) {
        for (@$_) {
            $_ ++;
        }
    }
}

sub find_flashers {
    return unless defined wantarray;
    my $matrix = shift;
    my @flashers;
    for my $row (0..$#{$matrix}) {
        for my $col (0..$#{$matrix->[$row]}) {
            push @flashers, "$row:$col" if (9 < $matrix->[$row][$col]);
        }
    }
    return wantarray? @flashers : \@flashers;
}

sub neighbors {
    return unless defined wantarray;
    my $matrix = shift;
    my ($row, $col) = split /:/, shift;
    my @neighbors;
    for my $trow ($row - 1 .. $row + 1) {
        if (0 <= $trow && $trow < @{$matrix}) {
            for my $tcol ($col - 1 .. $col + 1) {
                if (0 <= $tcol && $tcol < @{$matrix->[$trow]}) {
                    push @neighbors, "$trow:$tcol";
                }
            }
        }
    }
    return wantarray? @neighbors : \@neighbors;
}

sub trigger_flash {
    my ($matrix, $cell) = @_;
    my ($row, $col) = split /:/, $cell;
    my $flashes = 1;
    $matrix->[$row][$col] = 0;
    for (neighbors($matrix,$cell)) {
        my ($nrow, $ncol) = split /:/;
        if (0 != $matrix->[$nrow][$ncol] && 9 != $matrix->[$nrow][$ncol]) {
            $matrix->[$nrow][$ncol]++;
        } elsif (9 == $matrix->[$nrow][$ncol]) {
            $flashes += trigger_flash($matrix, $_);
        }
    }
    return $flashes;
}
my ($matrix, $timed_flashes, $total_flashes, $flashes, $step, $first_sync);



#say Dumper(@timed_flashes);
# Part 1
$matrix = [ map { [split //] } (read_lines $main::puzzle_data_file)];
$total_flashes = 0;
$first_sync = 0;
for (1..100) {
    $flashes = 0;
    increment_matrix($matrix);
    $timed_flashes = find_flashers($matrix);
    for (@{$timed_flashes}) {
        $flashes += trigger_flash($matrix, $_);
    }
    if (100 == $flashes && 0 == $first_sync) {
        $first_sync = $_;
    }
    $total_flashes += $flashes;
}
$result = $total_flashes;
report_number(1, $result);

exit unless $main::do_part_2;
# Part 2
$step = 100;
while (! $first_sync) {
    $step++;
    $flashes = 0;
    increment_matrix($matrix);
    $timed_flashes = find_flashers($matrix);
    for (@{$timed_flashes}) {
        $flashes += trigger_flash($matrix, $_);
    }
    if (100 == $flashes && 0 == $first_sync) {
        $first_sync = $step;
    }
}
$result = $first_sync;
report_number(2, $result);


1;
