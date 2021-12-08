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

my $VERSION = '0.21.00';

my $result = 0;

my @puzzle_data = read_lines $main::puzzle_data_file;

sub split_data {
    my @data = @_;
    my (@diagnostics, @outputs);
    for (@data) {
        my ($left, $right) = split /\s+\|\s+/;
        my @diagnostic = sort(split /\s+/, $left);
        my @output = sort(split /\s+/, $right);
        push @diagnostics, \@diagnostic;
        push @outputs, \@output;
    }
    return (\@diagnostics, \@outputs);
}

# Part 1
my ($inputs, $outputs) = split_data(@puzzle_data);
for (@$outputs) {
    for (@$_) {
        my $size = length($_);
        $result++ if 2 == $size;
        $result++ if 3 == $size;
        $result++ if 4 == $size;
        $result++ if 7 == $size;
    }
}


report_number(1, $result);


exit unless $main::do_part_2;
# Part 2

my $input_list = 'acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf';
my ($left, $right) = split /\s+\|\s+/, $input_list;
my @value_list = sort(split /\s+/, $left);
my @output_list = sort(split /\s+/, $right);


report_number(2, $result);


1;
