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

my $VERSION = '0.21.20';

my $result = 0;

my @puzzle_data = read_lines $main::puzzle_data_file;

my $algo = [map {/#/ ? 1 : 0} split //, shift @puzzle_data];
shift @puzzle_data;

my $image;
my $row = 0;
for (@puzzle_data) {
    my $col = 0;
    foreach my $pixel (/[.#]/g) {
        $image->{$row, $col} = 1 if $pixel eq '#';
        $col ++;
    }
    $row ++;
}

sub enhanced_pixel {
    my ($row, $col, $algo, $pass) = @_;
    my $key = "0b";
    foreach (-1 .. 1) {
        my $key_row = $row + $_;
        foreach (-1 .. 1) {
            my $key_col = $col + $_;
            $key .= $image->{$key_row, $key_col} //
                        ($algo->[0] * ($pass % 2));
        }
    }
    return $algo->[oct $key];
}


sub enhance_image {
    wantarray // return;
    my ($image, $algo, $pass) = @_;
    my $enhanced_image;
    my $touched;
    foreach my $pixel (keys %$image) {
        next unless $image->{$pixel};
        my ($pivot_row, $pivot_col) = split $; => $pixel;
        foreach (-2 .. 2) {
            my $target_row = $pivot_row + $_;
            foreach (-2 .. 2) {
                my $target_col = $pivot_col + $_;
                unless ($touched->{$target_row, $target_col} ++) {
                    $enhanced_image->{$target_row, $target_col} = enhanced_pixel $target_row, $target_col, $algo, $pass;
                }
            }
        }
    }
    $enhanced_image;
}
# Part 1

$image = enhance_image $image, $algo, $_ for (0..1);
$result = scalar grep {$_} values %$image;

report_number(1, $result);

die 'Not running part 2 yet.' unless $main::do_part_2;
# Part 2

report_number(2, $result);


1;
