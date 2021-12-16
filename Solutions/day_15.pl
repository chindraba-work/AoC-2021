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

my $VERSION = '0.21.15';

my $result = 0;

my @puzzle_grid = read_grid $main::puzzle_data_file;
my (@densities, @visit_list, @risk_map, @chiton_list);
my @itinerary_list;
sub safest {
    my @grid = @_;
    my $max_rank = $#grid;
    my $max_file = $max_rank;
    my @delta = (
        { rank => -1, file => 0 },
        { rank => 0,  file => 1 },
        { rank => 1,  file => 0 },
        { rank => 0,  file => -1},
    );
    push @chiton_list, {
        rank => 0,
        file => 0,
        risk => 0,
    };
    $risk_map[0]->[0] = 0;
    while (@chiton_list) {
        my $chiton = shift @chiton_list;
        push @itinerary_list, \%{$chiton};
        my ($c_rank, $c_file) = (@{$chiton}{qw/rank file/});
        $visit_list[$c_rank]->[$c_file] = 1;
        for (0..3) {
            my ($rank,$file) = ($c_rank+$delta[$_]->{'rank'},$c_file+$delta[$_]->{'file'});
            if (
                    !($rank == $c_rank && $file == $c_file) &&
                    (0 <= $rank && $max_rank >= $rank  && 0 <= $file && $max_file >= $file) &&
                    !$visit_list[$rank]->[$file]
                ) {
                if ($risk_map[$rank]->[$file] > $risk_map[$c_rank]->[$c_file] + $grid[$rank]->[$file]) {
                    $risk_map[$rank]->[$file] = $risk_map[$c_rank]->[$c_file] + $grid[$rank]->[$file];
                    push @chiton_list, { rank => $rank, file => $file, risk => $risk_map[$rank]->[$file], };
                }
            }
        }
        @chiton_list = sort { return ($a->{'risk'} == $b->{'risk'})?( ($a->{'file'} == $b->{'file'})? $a->{'rank'} - $b->{'rank'} : $a->{'file'} - $b->{'file'}) : $a->{'risk'} - $b->{'risk'}; } @chiton_list;
    }
    return $risk_map[$#grid]->[$#{$grid[$#grid]}];
}



# Part 1
@densities = (@puzzle_grid);
@visit_list = map { [ (0) x @{$densities[0]}] } @densities;
@risk_map = map { [ (2**52) x @{$densities[0]}] } @densities;
@chiton_list = ();
$result = safest(@densities);
report_number(1, $result);

die 'Not running part 2' unless $main::do_part_2;
# Part 2

report_number(2, $result);


1;
