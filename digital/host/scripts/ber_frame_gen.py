#!/usr/bin/python
"""
Test pattern generator for BER testing using PRBS31 (pseudorandom binary sequence)
First byte contains the length of the frame which includes 2-byte FCS.
Second two bytes contain a frame sequence number
FCS is going to be added by the transmitter.
"""

from __future__ import print_function
import sys
import argparse
import prbs31

#---------------------------------------------------------------------------------------------------
def max_pbrs_seqs(string):
    value = int(string)
    if (value * 4) > 123:
        raise argparse.ArgumentTypeError("Support upto 30 PRBS31 sequences")
    else:
        return value

#---------------------------------------------------------------------------------------------------
def main():
    """ The main function """

    parser = argparse.ArgumentParser(description='Frame generator for BER testing using PRBS31 (x^31 + x^28 + 1)')
    parser.add_argument('output_file', metavar='OUTPUT_FILE', type=str, help='Output file')
    parser.add_argument('-p', '--prbs-seqs', type=max_pbrs_seqs, default=10, help='Number of sequences per frame')
    parser.add_argument('-n', '--nframes', type=int, default=20, help='Number of frames')
    args = parser.parse_args()

    # Add two for frame sequence number and two for FCS
    frame_len = 2 + (args.prbs_seqs * 4) + 2

    print("Frame length     - %d bytes" % frame_len)
    print("Number of frames - %d" % args.nframes)

    file_obj = open(args.output_file, "w")
    prbs_obj = prbs31.PRBS31(0x080f0100)

    for frame_number in range(0, args.nframes):
        frame_bytes = []
        frame_bytes.append(frame_len & 0x7f)
        frame_bytes.append(frame_number & 0xff)
        frame_bytes.append((frame_number >> 8) & 0xff)

        for _ in range(0, args.prbs_seqs):
            prbs_seq = prbs_obj.next()
            frame_bytes.append(prbs_seq & 0x7f)
            frame_bytes.append((prbs_seq >> 8) & 0x7f)
            frame_bytes.append((prbs_seq >> 16) & 0x7f)
            frame_bytes.append((prbs_seq >> 24) & 0x7f)

        byte_str = ",".join([("%02x" % byte) for byte in frame_bytes])
        file_obj.write("%s\n" % byte_str)

    file_obj.close()

if __name__ == "__main__":
    main()
