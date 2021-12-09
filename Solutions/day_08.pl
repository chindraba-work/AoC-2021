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
        my @diagnostic = split /\s+/, $left;
        my @output = split /\s+/, $right;
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
sub decode_line {
    my $input_list = shift;
    my $output_list = shift;
    my ($filter, $threes, $fours, @fives, @sixes, $sevens, @digits, %segments);
    $threes = ($input_list =~ m<\b([a-g]{3})\b>)[0];
    $fours  = ($input_list =~ m<\b([a-g]{4})\b>)[0];
    @fives  =  $input_list =~ m<\b([a-g]{5})\b>g;
    @sixes  =  $input_list =~ m<\b([a-g]{6})\b>g;
    $sevens = ($input_list =~ m<\b([a-g]{7})\b>)[0];
    $filter = join '|', (split //, "$threes$fours");
    for (map { s/$filter//g; $_ } (map { $_ } @sixes)) {
        $segments{(1 == length)?'G':'E'} = $_;
    }
    $segments{'E'} =~ s/$segments{'G'}//g;
    $filter = join '|', ($segments{'G'}, split //, $threes);
    $segments{'B'} = $segments{'D'} = $segments{'E'} = '';
    for (map { s/$filter//g; $_ } (map { $_ } @fives)) {
        $segments{(1 == length)?'D':'B'} .= $_;
    }
    $filter = join '|', (split //, $fours);
    $segments{'E'} = $segments{'B'} =~ s/$filter//gr;
    $segments{'B'} =~ s/$segments{'E'}|$segments{'D'}//g;
    for (split /\s+/, $output_list) {
        my ($size, $digit);
        $size = length;
        $digit = (2 == $size) ? 1 :
            (3 == $size)? 7 :
            (4 == $size)? 4 :
            (7 == $size)? 8 :
            (5 == $size)? (
                (m<$segments{'E'}>)? 2 : (
                    (m<$segments{'B'}>)? 5 : 3
                )
            ) : (
                (! m<$segments{'D'}>)? 0 : (
                    (m<$segments{'E'}>)? 6 : 9
                )
            );
        push @digits, $digit;
    }
    return 0 + join '', @digits;
}

$result = 0;
for (@puzzle_data) {
    $result += decode_line(split /\s+\|\s+/);
}
report_number(2, $result);


1;
