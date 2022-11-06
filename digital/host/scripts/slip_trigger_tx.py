#!/usr/bin/python
"""
Main module for triggering via SLIP
"""

from __future__ import print_function
import sys
import time
import argparse
import slipdev
import signal
import threading
import Queue

class LogItem(object):
    def __init__(self):
        self.type = 0
        self.count = 0
        self.data = None
        

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

def parse_delay(string):
    d = int(string, 10)
    if d > 16384:
        raise argparse.ArgumentTypeError("%s should be less than 16384" % string)
    else:
        return d

def parse_send_interval(string):
    val = float(string)
    if val < 0.5:
        raise argparse.ArgumentTypeError("%s should be higher than 0.5" % string)
    else:
        return val

def create_trigger_cmd(delays):
    cmd_bytes = bytearray()
    cmd_bytes.append(0x01)
    cmd_bytes.append(0xff & delays[0])
    cmd_bytes.append(0xff & (delays[0] >> 8))
    cmd_bytes.append(0xff & delays[1])
    cmd_bytes.append(0xff & (delays[1] >> 8))
    return cmd_bytes

#---------------------------------------------------------------------------------------------------
def ser_do_read(shutdown_event, slipdev_obj, log_queue, args):
    """ Reading SLIP frames and dump to stdout """
    #file_obj = open(args.output_file, "w")
    
    received = 0
    while not shutdown_event.is_set():
        frame_data = slipdev_obj.read()
        if len(frame_data) > 0:
            received += 1
            log_item = LogItem()
            log_item.type = 1
            log_item.count = received
            log_item.data = frame_data
            log_queue.put(log_item)

#---------------------------------------------------------------------------------------------------
def ser_do_wite(shutdown_event, slipdev_obj, log_queue, args):
    """ Reading SLIP frames and dump to stdout """

    time.sleep(args.send_interval*2)
    trigger_sent = 0
    while not shutdown_event.is_set():
        time.sleep(args.send_interval)
        slipdev_obj.write(create_trigger_cmd(args.delays))
        trigger_sent += 1
        log_item = LogItem()
        log_item.type = 2
        log_item.count = trigger_sent
        log_item.data = []
        log_queue.put(log_item)

        if trigger_sent == args.max_triggers:
            time.sleep(args.send_interval*2)
            shutdown_event.set()
            break
        
    print("\nSending completed.")

def do_log(shutdown_event, log_queue, args):
    """ Log output to file """
    file_obj = open(args.output_file, "w")
    sent = 0
    received = 0
    while not shutdown_event.is_set():
        try:
            log_obj = log_queue.get(block=True, timeout=0.1)
            if not log_obj is None:
                if log_obj.type == 1:
                    received = log_obj.count
                    file_obj.write("r,%d,%s\n" % (log_obj.count, ",".join(["%02x" % x for x in log_obj.data])))
                    file_obj.flush()
                elif log_obj.type == 2:
                    sent = log_obj.count
                    file_obj.write("s,%d\n" % log_obj.count)
                    file_obj.flush()

            print(("\rsent %d, received %d" % (sent, received)), end="")
            sys.stdout.flush()
        except:
            continue
    file_obj.close()

def main():
    """
    Main function
    """

    def signal_handler(_1, _2):
        """ For setting shutdown event """
        shutdown_event.set()

    parser = argparse.ArgumentParser(description='Trigger via SLIP')
    parser.add_argument('port', metavar='PORT', type=str, default="/dev/ttyUSB0", help='Serial port')
    parser.add_argument('-b', '--baudrate', type=int, default=115200, help='Baudrate of the serial port')
    parser.add_argument('-d', '--delays', metavar='DELAY', type=parse_delay, nargs=2,  
                        default=[0, 0], 
                        help='Delays for the trigger 1 and 2')
    parser.add_argument('-s', '--send-interval', type=parse_send_interval, default=1.0, help='Send interval')
    parser.add_argument('-o', '--output-file', type=str, help='Output file')
    parser.add_argument('-m', '--max-triggers', type=int, default=3000, help='Maximum number of triggers')

    args = parser.parse_args()

    log_queue = Queue.Queue(maxsize=10)
    shutdown_event = threading.Event()
    signal.signal(signal.SIGINT, signal_handler)
    slipdev_obj = slipdev.SLIPDevice(port=args.port, baudrate=args.baudrate, timeout=0.5)


    ser_read_thread = threading.Thread(target=ser_do_read, args=(shutdown_event, 
                                                                    slipdev_obj, 
                                                                    log_queue,
                                                                    args))
    ser_read_thread.start()

    ser_write_thread = threading.Thread(target=ser_do_wite, args=(shutdown_event, 
                                                                    slipdev_obj, 
                                                                    log_queue,
                                                                    args))
    ser_write_thread.start()

    log_thread = threading.Thread(target=do_log, args=(shutdown_event, 
                                                                    log_queue,
                                                                    args))
    log_thread.start()

    while not shutdown_event.is_set():
        time.sleep(0.2)

    ser_read_thread.join()
    ser_write_thread.join()
    log_thread.join()

    slipdev_obj.close()

if __name__ == "__main__":
    main()