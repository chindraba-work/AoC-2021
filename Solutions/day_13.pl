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

my $VERSION = '0.21.13';

my $result = 0;

my $puzzle_blob = slurp_data $main::puzzle_data_file;
my @puzzle_blobs = slurp_data $main::puzzle_data_file;
my @puzzle_data = read_lines $main::puzzle_data_file;
my @puzzle_list = read_comma_list $main::puzzle_data_file;
my @puzzle_records = read_lined_list $main::puzzle_data_file, ' |,';
my @puzzle_hash = read_lined_hash $main::puzzle_data_file, ' |,', ':';
my ($line, @folds);
$line = pop @puzzle_data;
while ($line =~ /^fold along (x|y)=([0-9]+)/) {
    unshift @folds, "$1:$2";
    $line = pop @puzzle_data;
}
my %dots;
for (@puzzle_data) {
    $dots{$_} = '•';
}

# Part 1
sub do_fold {
    my ($fold, $dots) = @_;
    my ($axis, $line) = split /:/, $fold;
    my %new_dots;
    for (keys %{$dots}) {
        my ($rank, $file) = split /,/;
        if ('x' eq $axis) {
            if ($rank > $line) {
                $rank = $line - ($rank - $line);
                $new_dots{join(',', $rank, $file)} = '•';
            } elsif ($rank < $line) {
                $new_dots{$_} = '•';
            }
        } else {
            if ($file > $line) {
                $file = $line - ($file - $line);
                $new_dots{join(',', $rank, $file)} = '•';
            } elsif ($file < $line) {
                $new_dots{$_} = '•';
            }
        }
    }
    return %new_dots;
}
my %dots1 = do_fold($folds[0], \%dots);
$result = scalar(keys %dots1);

report_number(1, $result);
exit unless $main::do_part_2;
# Part 2


report_number(2, $result);


1;
