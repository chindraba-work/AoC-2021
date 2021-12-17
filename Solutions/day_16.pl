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

my $VERSION = '0.21.16';

my $result = 0;

my $msg;
$msg = 'D2FE28';
$msg = 'D2FE288';
$msg = '38006F45291200';
$msg = 'EE00D40C823060';
$msg = '8A004A801A8002F478';
$msg = '620080001611562C8802118E34';
$msg = 'C0015000016115A2E0802F182340';
$msg = slurp_data $main::puzzle_data_file;

my $ver_sum = 0;
my $bits = join '', map { sprintf '%04b', hex $_ } split //, $msg;

sub get_packet {
    my ($bit_size, $bits_read, $bits_used, $mode, $type, $value); 
    $ver_sum += oct '0b'.substr $bits, 0, 3, '';
    $type = oct '0b'.substr $bits, 0, 3, '';
    $bit_size = 6;
    if (4 == $type) {
        my ($more, $num) = (0) x 2;
        do {
            $more = substr $bits, 0, 1, '';
            $num = $num * 16 + oct '0b'.substr $bits, 0, 4, '';
            $bit_size += 5;
        } while $more;
        $value = $num;
    } else {
        $mode = oct '0b'.substr $bits, 0, 1, '';
        $bit_size += 1;
        if ($mode) {
            my ($count, @sub_vals);
            $count = oct '0b'.substr $bits, 0, 11, '';
            $bit_size += 11;
            for (1..$count) {
                my ($ret_val, $size) = get_packet();
                push @sub_vals, $ret_val;
                $bit_size += $size;
            }
        } else {
            my ($sub_len, @sub_vals);
            $sub_len = oct '0b'.substr $bits, 0, 15, '';
            $bit_size += 15;
            $bits_used = 0;
            while ($bits_used < $sub_len) {
                my ($ret_val, $size) = get_packet();
                push @sub_vals, $ret_val;
                $bits_used += $size;
            }
            $bit_size += $bits_used;
        }
    }
    return wantarray? ($value, $bit_size) : $value;
}



# Part 1
my $message = get_packet; 

$result = $ver_sum;
report_number(1, $result);

die 'Not running part 2 yet.' unless $main::do_part_2;
# Part 2

report_number(2, $result);


1;
