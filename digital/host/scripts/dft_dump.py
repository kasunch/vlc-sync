#!/usr/bin/python
"""
Main module for setting IDFT input/dumping DFT output via SLIP
"""

from __future__ import print_function
import sys
import time
import argparse
import slipdev

def hexdump_pretty(src, length=16):
    """
    Print bytes as hex dump with addresses.
    """
    printable_chars = ''.join([(len(repr(chr(x))) == 3) and chr(x) or '.' for x in range(256)])
    lines = []
    for idx in xrange(0, len(src), length):
        chars = src[idx : idx + length]
        hex_str = ' '.join(["%02x" % x for x in chars])
        printable = ''.join(["%s" % ((x <= 127 and printable_chars[x]) or '.') for x in chars])
        lines.append("%04x  %-*s  %s\n" % (idx, length * 3, hex_str, printable))
    return ''.join(lines)

def hexdump(src):
    """ Dump bytes """
    return ' '.join(["%02x" % x for x in src])

def parse_data(string):
    b = int(string, 16)
    if b > 1023:
        raise argparse.ArgumentTypeError("%s should be less than 1023" % string)
    else:
        return b

def create_set_idft_bins_cmd(data):
    cmd_bytes = bytearray()
    cmd_bytes.append(data[0] & 0xff)
    cmd_bytes.append((data[0] >> 8) & 0xff)
    cmd_bytes.append(data[1] & 0xff)
    cmd_bytes.append((data[1] >> 8) & 0xff)
    cmd_bytes.append(data[2] & 0xff)
    cmd_bytes.append((data[2] >> 8) & 0xff)
    return cmd_bytes

def main():
    """
    Main function
    """

    parser = argparse.ArgumentParser(description='Set IDFT input/Dump DFT output via SLIP')
    parser.add_argument('port', metavar='PORT', type=str, default="/dev/ttyUSB0", help='Serial port')
    parser.add_argument('-b', '--baudrate', type=int, default=115200, help='Baudrate of the serial port')
    parser.add_argument('-d', '--data', metavar='10_BIT_VALUE', type=parse_data, nargs=3,  
                        default=[0x000, 0x000, 0x000], 
                        help='10-bit values for IDFT input in hex')

    args = parser.parse_args()

    slipdev_obj = slipdev.SLIPDevice(port=args.port, baudrate=args.baudrate)

    slipdev_obj.write(create_set_idft_bins_cmd(args.data))

    while True:
        data = slipdev_obj.read()
        if len(data) > 0:
            print(hexdump(data))


if __name__ == "__main__":
    main()