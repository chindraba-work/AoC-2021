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
my $bits = '';

sub flush_bits {
    substr $bits, 0, length($bits)%4, '' if length($bits)%4;
}
sub load_bits {
    $bits .= sprintf "%0*b",4*int(.8+($_[0]?$_[0]:8)/4),hex(substr $msg,0,int(.8+($_[0]?$_[0]:8)/4),'');
}
sub read_bits {
    my $wanted = shift;
    load_bits $wanted - length $bits if $wanted > length $bits;
    return substr $bits, 0, $wanted, '';
}
sub get_version {
    return oct ('0b'.read_bits 3);
}
sub get_type {
    return oct ('0b'.read_bits 3);
}
sub get_mode {
    return read_bits 1;
}
sub get_len {
    return oct('0b'.read_bits 15);
}
sub get_count {
    return oct('0b'.read_bits 11);
}
sub get_digit {
    my $num = oct ('0b'.read_bits 5);
    return $num;
}
sub get_num_literal {
    my $val = 0;
    my $more = 1;
    my $bit_count = 0;
    while ($more) {
        $bit_count += 5;
        my $tmp = get_digit;
        if (16 & $tmp) {
            $val = ($val<<4) + ($tmp & 15);
        } else {
            $more = 0;
            $val = ($val<<4)+$tmp;
        }
    }
    return ($val, $bit_count);
}
sub get_packet {
    my %packet;
    my ($bit_size, $bits_read, $bits_used); 
    $bit_size = 0;
    $packet{'ver'} = get_version;
    $bit_size += 3;
    $ver_sum += $packet{'ver'};
    $packet{'type'} = get_type;
    $bit_size += 3;
    if (4 == $packet{'type'}) {
        ($packet{'value'}, $bits_read) = get_num_literal;
        $bit_size += $bits_read;
    } else {
        $packet{'mode'} = get_mode;
        $bit_size += 1;
        if ($packet{'mode'}) {
            $packet{'count'} = get_count;
            $bit_size += 15;
            $packet{'children'} = [];
            for (1..$packet{'count'}) {
                my ($child, $size) = get_packet();
                push @{$packet{'children'}}, $child;
                $bit_size += $size;
            }
        } else {
            $packet{'len'} = get_len;
            $bit_size += 11;
            $bits_used = 0;
            while ($bits_used < $packet{'len'}) {
                my ($child, $size) = get_packet();
                push @{$packet{'children'}}, $child;
                $bits_used += $size;
            }
            $bit_size += $bits_used;
        }
    }
    return wantarray? (\%packet, $bit_size) : \%packet;
}



# Part 1
my $message = get_packet; 

$result = $ver_sum;
report_number(1, $result);

die 'Not running part 2 yet.' unless $main::do_part_2;
# Part 2

report_number(2, $result);


1;
