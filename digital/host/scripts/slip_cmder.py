#!/usr/bin/python

import argparse
import slipdev
import csv
import time


def hexdump_pretty(src, length=16):
    printable_chars = ''.join([(len(repr(chr(x))) == 3) and chr(x) or '.' for x in range(256)])
    lines = []
    for idx in range(0, len(src), length):
        chars = src[idx: idx + length]
        hex_str = ' '.join(["%02x" % x for x in chars])
        printable = ''.join(["%s" % ((x <= 127 and printable_chars[x]) or '.') for x in chars])
        lines.append("%04x  %-*s  %s\n" % (idx, length * 3, hex_str, printable))
    return ''.join(lines)


def hexdump(src):
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


def str_to_bool(v):
    if isinstance(v, bool):
        return v
    if v.lower() in ('yes', 'true', 't', 'y', '1'):
        return True
    elif v.lower() in ('no', 'false', 'f', 'n', '0'):
        return False
    else:
        raise argparse.ArgumentTypeError('Boolean value expected.')


def create_node_id_cmd():
    cmd_bytes = bytearray()
    cmd_bytes.append(0x04)
    return cmd_bytes


def create_trig_in_en_cmd(is_en):
    cmd_bytes = bytearray()
    cmd_bytes.append(0x05)
    if is_en:
        cmd_bytes.append(0x01)
    else:
        cmd_bytes.append(0x00)
    return cmd_bytes


def create_rx_en_cmd(is_en):
    cmd_bytes = bytearray()
    cmd_bytes.append(0x06)
    if is_en:
        cmd_bytes.append(0x01)
    else:
        cmd_bytes.append(0x00)
    return cmd_bytes


def create_tx_cmd():
    cmd_bytes = bytearray()
    cmd_bytes.append(0x03)
    return cmd_bytes


def create_tx_data_cmd(frame_data):
    cmd_bytes = bytearray()
    cmd_bytes.append(0x02)
    cmd_bytes.extend(frame_data)
    return cmd_bytes


def create_trigger_cmd(delays):
    cmd_bytes = bytearray()
    cmd_bytes.append(0x01)
    cmd_bytes.append(0xff & delays[0])
    cmd_bytes.append(0xff & (delays[0] >> 8))
    cmd_bytes.append(0xff & delays[1])
    cmd_bytes.append(0xff & (delays[1] >> 8))
    return cmd_bytes


def get_node_id(slip_dev):
    slip_dev.write(create_node_id_cmd())
    node_id = None
    try:
        while True:
            data = slip_dev.read()
            if len(data) > 0:
                if data[0] != 0x02:
                    continue
                else:
                    node_id = data[1]
                    break
    except KeyboardInterrupt as e:
        print("Stopping...")
    return node_id


def enable_rx(is_en, slip_dev):
    slip_dev.write(create_rx_en_cmd(is_en))


def send_from_file(config, slip_dev):
    if not config.get('input_file', None):
        return

    file = open(config.get('input_file', None), "r")
    csv_reader = csv.reader(file, delimiter=',', quotechar='"')
    rows = [row for row in csv_reader]
    send_interval = round(config.get('send_interval', 1), 1)

    try:
        for i, row in enumerate(rows):
            print("Sending %d of %d" % (i + 1, len(rows)))
            frame_bytes = bytearray([int(val, 16) & 0xff for val in row])
            slip_dev.write(create_tx_data_cmd(frame_bytes))
            slip_dev.write(create_tx_cmd())
            time.sleep(send_interval)
    except KeyboardInterrupt as e:
        print("Stopping...")
    finally:
        file.close()


def recive_to_file(config, slip_dev):
    enable_rx(True, slip_dev)
    if config.get('output_file', None):
        file = open(config.get('output_file', None), "w")

    try:
        while True:
            frame_data = slip_dev.read()
            if len(frame_data) > 0:
                if frame_data[0] != 0x01:
                    continue
                frame_data = frame_data[1:]
                if config.get('output_file', None):
                    file.write("%s\n" % ",".join(["%02x" % x for x in frame_data]))
                    file.flush()
                print(hexdump_pretty(frame_data))
    except KeyboardInterrupt as e:
        print("Stopping...")
    finally:
        if config.get('output_file', None):
            file.close()


def set_trigger_output(config, slip_dev):
    slip_dev.write(create_trigger_cmd(config.get('trigger_output', [0, 0])))


def enable_input_trigger(is_en, slip_dev):
    slip_dev.write(create_trig_in_en_cmd(is_en))


def main():
    parser = argparse.ArgumentParser(description='SLIP Commander')
    parser.add_argument('port', metavar='PORT', type=str,
                        default="/dev/ttyUSB0", help='Serial port')
    parser.add_argument('-b', '--baudrate', type=int, default=115200,
                        help='Baudrate of the serial port')
    parser.add_argument('-t', '--trigger-output', metavar='DELAY', type=parse_delay, nargs=2,
                        default=None,
                        help='Delays for the output triggers 1 and 2')
    parser.add_argument('-T', '--trigger-input', type=str_to_bool, nargs='?',
                        const=True, default=None, help='Enable/disable trigger input')
    parser.add_argument('-i', '--input-file', type=str, help='Input file')
    parser.add_argument('-o', '--output-file', type=str, help='Output file')
    parser.add_argument('-s', '--send', action='store_true', help='Send from input file')
    parser.add_argument('-S', '--send-interval', type=parse_send_interval,
                        default=1.0, help='Send interval')
    parser.add_argument('-r', '--receive', action='store_true',
                        help='Receive and save to output file')
    parser.add_argument('-N', '--node-id', action='store_true', help='Get node id')

    args = parser.parse_args()
    config = vars(args)

    slip_dev = slipdev.SLIPDevice(port=args.port, baudrate=args.baudrate)

    if config.get('node_id', False):
        print("Node ID: %d" % get_node_id(slip_dev))

    if config.get('trigger_output', None):
        set_trigger_output(config, slip_dev)

    if config.get('trigger_input', None):
        enable_input_trigger(config.get('trigger_input', False), slip_dev)

    if config.get('send', False):
        send_from_file(config, slip_dev)

    if config.get('receive', False):
        recive_to_file(config, slip_dev)



if __name__ == "__main__":
    main()
