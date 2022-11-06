#!/usr/bin/python
"""
Main module for dumping SLIP data
"""

from __future__ import print_function
import sys
import getopt
import serial
import slip
import slipdev

def hexdump(src, length=16):
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

#--------------------------------------------------------------------------------------------------
def show_help(path):
    """
    Show help
    """
    print("%s   [options] device" % path)
    print("Serial dump for SLIP")
    print("-b|--baudrate        Baudrate of the serial port")
    print("-h|--help            Show this help")

#--------------------------------------------------------------------------------------------------
def main():
    """
    Main function
    """
    baud_rate = 115200
    serial_device = "/dev/ttyUSB0"

    try:
        opts, args = getopt.getopt(sys.argv[1:], "b:h", ["baudrate=", "help"])

    except getopt.GetoptError, err:
        print(str(err))
        sys.exit(2)

    for opt, arg in opts:
        if opt in ('-b', '--baudrate'):
            baud_rate = int(arg)
        elif opt in ('-h', '--help'):
            show_help(sys.argv[0])
            sys.exit(0)
        else:
            print('Unknown option')
            sys.exit(1)

    if len(args) > 0:
        serial_device = str(args[0])
    else:
        print("ERROR: No device specified")
        show_help(sys.argv[0])
        sys.exit(1)


    #serial_obj = serial.Serial(port=serial_device, baudrate=baud_rate)
    #
    #slip_obj = slip.SLIP()
    #slip_bytes = []
    #
    #while 1:
    #    slip_bytes.extend(serial_obj.read(1))
    #    frame_data = slip_obj.decode_frame(slip_bytes)
    #    if not frame_data:
    #        continue
    #    else:
    #        print(hexdump(frame_data))

    slipdev_obj = slipdev.SLIPDevice(port=serial_device, baudrate=baud_rate)

    while True:
        data = slipdev_obj.read()
        if len(data) > 0:
            print(hexdump(data))

if __name__ == "__main__":
    main()
