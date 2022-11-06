#!/usr/bin/python
"""
Main module for reading/writing EEPROM page via SLIP
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
    if b > 255:
        raise argparse.ArgumentTypeError("%s should be less than 255" % string)
    else:
        return b

def parse_address(string):
    value = int(string)
    if  value > 255:
        raise argparse.ArgumentTypeError("Address should be less than 255")
    else:
        return value

def create_read_cmd(address):
    return bytearray([0x00, address, 0, 0, 0, 0, 0, 0, 0, 0])

def create_write_cmd(address, page):
    cmd_bytes = bytearray()
    cmd_bytes.append(0x01)
    cmd_bytes.append(address)
    cmd_bytes.extend(page)
    return cmd_bytes

def main():
    """
    Main function
    """

    parser = argparse.ArgumentParser(description='Read/write EEPROM page via SLIP')
    parser.add_argument('port', metavar='PORT', type=str, default="/dev/ttyUSB0", help='Serial port')
    parser.add_argument('-b', '--baudrate', type=int, default=115200, help='Baudrate of the serial port')
    parser.add_argument('-a', '--address', type=parse_address, default=0, help='Page address')
    parser.add_argument('-r', '--read', action='store_true', help='Read')
    parser.add_argument('-w', '--write', action='store_true', help='Write')
    parser.add_argument('-d', '--delay', type=int, default=1, help='Read delay after write in seconds')
    parser.add_argument('-p', '--page', metavar='BYTE', type=parse_data, nargs=8,  
                        default=[0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00], 
                        help='Data two be written')

    args = parser.parse_args()

    slipdev_obj = slipdev.SLIPDevice(port=args.port, baudrate=args.baudrate)

    if (args.write):
        bytes_written = slipdev_obj.write(create_write_cmd(args.address, args.page))
        args.read = True

    if (args.read):
        if (args.write):
            time.sleep(args.delay)
        bytes_written = slipdev_obj.write(create_read_cmd(args.address))
        data = slipdev_obj.read()
        print(hexdump(data[2:]))


if __name__ == "__main__":
    main()