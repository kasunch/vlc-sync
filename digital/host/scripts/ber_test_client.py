#!/usr/bin/python
"""
Main module for generating frames and send via SLIP
Incoming SLIP frames are dump to stdout
"""

from __future__ import print_function
import sys
import signal
import threading
import time
import serial
import csv
import argparse
import slipdev

def hexdump_pretty(src, length=16):
    """
    Print bytes as hex dump with addresses.
    """
    printable_chars = ''.join([(len(repr(chr(x))) == 3) and chr(x) or '.' for x in range(256)])
    lines = []
    for idx in range(0, len(src), length):
        chars = src[idx : idx + length]
        hex_str = ' '.join(["%02x" % x for x in chars])
        printable = ''.join(["%s" % ((x <= 127 and printable_chars[x]) or '.') for x in chars])
        lines.append("%04x  %-*s  %s\n" % (idx, length * 3, hex_str, printable))
    return ''.join(lines)

def hexdump(src):
    """ Dump bytes """
    return ' '.join(["%02x" % x for x in src])

def parse_send_interval(string):
    val = float(string)
    if val < 0.5:
        raise argparse.ArgumentTypeError("%s should be higher than 0.5" % string)
    else:
        return val

#---------------------------------------------------------------------------------------------------
def ser_do_read(shutdown_event, slipdev_obj, output_file):
    """ Reading SLIP frames and dump to stdout """
    file_obj = open(output_file, "w")
    
    while not shutdown_event.is_set():
        frame_data = slipdev_obj.read()
        if len(frame_data) > 0:
            file_obj.write("%s\n" % ",".join(["%02x" % x for x in frame_data]))
            file_obj.flush()
            print(hexdump_pretty(frame_data))
    file_obj.close()

#---------------------------------------------------------------------------------------------------
def ser_do_wite(shutdown_event, slipdev_obj, input_file, send_interval):
    """ Reading SLIP frames and dump to stdout """
    file_obj = open(input_file, "r")
    csv_reader = csv.reader(file_obj, delimiter=',', quotechar='"')
    lst_rows = [row for row in csv_reader]

    send_interval = round(send_interval, 1)
    cuttent_time = round(time.time(), 1)
    while not shutdown_event.is_set() and len(lst_rows) > 0:
        if (send_interval > 0.5):
            time.sleep(0.1)
            now_time = round(time.time(), 1)
            if ((now_time - cuttent_time) >= send_interval):
                cuttent_time = round(time.time(), 1)
                row = lst_rows.pop(0)
                frame_bytes = bytearray([int(val, 16) & 0xff for val in row])
                slipdev_obj.write(frame_bytes)
        else:
            time.sleep(send_interval)
            row = lst_rows.pop(0)
            frame_bytes = bytearray([int(val, 16) & 0xff for val in row])
            slipdev_obj.write(frame_bytes)
        
    file_obj.close()
    print("Sending completed.")

#---------------------------------------------------------------------------------------------------
def main():
    """
    Main function
    """

    def signal_handler(_1, _2):
        """ For setting shutdown event """
        shutdown_event.set()

    parser = argparse.ArgumentParser(description='Serial client for testing BER.')
    parser.add_argument('port', metavar='PORT', type=str, default="/dev/ttyUSB0", help='Serial port')
    parser.add_argument('-b', '--baudrate', type=int, default=115200, help='Baudrate of the serial port')
    parser.add_argument('-i', '--input-file', type=str, help='Input file')
    parser.add_argument('-o', '--output-file', type=str, help='Output file')
    parser.add_argument('-s', '--sender', action='store_true', help='Enable sender')
    parser.add_argument('-r', '--receiver', action='store_true', help='Enable receiver')
    parser.add_argument('-d', '--send-interval', type=parse_send_interval, default=1.0, help='Send interval')

    args = parser.parse_args()

    if not (args.sender or args.receiver):
        print("ERROR: At least sender or receiver has to be enabled")
        sys.exit(1) 

    shutdown_event = threading.Event()
    signal.signal(signal.SIGINT, signal_handler)
    slipdev_obj = slipdev.SLIPDevice(port=args.port, baudrate=args.baudrate, timeout=0.5)

    if (args.receiver):
        ser_read_thread = threading.Thread(target=ser_do_read, args=(shutdown_event, 
                                                                        slipdev_obj, 
                                                                        args.output_file))
        ser_read_thread.start()

    if (args.sender):
        ser_write_thread = threading.Thread(target=ser_do_wite, args=(shutdown_event, 
                                                                        slipdev_obj, 
                                                                        args.input_file,
                                                                        args.send_interval))
        ser_write_thread.start()

    while not shutdown_event.is_set():
        time.sleep(0.2)

    if (args.receiver):
        ser_read_thread.join()
    if (args.sender):
        ser_write_thread.join()

    slipdev_obj.close()

if __name__ == "__main__":
    main()
