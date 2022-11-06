#!/usr/bin/python

import argparse
import slipdev
import csv
import time
import logging
import re
import sys
import signal
import threading
import queue

logger = logging.getLogger(__name__)


class DataItem(object):
    def __init__(self):
        self.is_received = False
        self.frame_counter = 0
        self.frame_data = None


class NewLineFormatter(logging.Formatter):
    def __init__(self, fmt, datefmt=None):
        logging.Formatter.__init__(self, fmt, datefmt)

    def escape_ansi(self, line):
        ansi_escape = re.compile(r'(?:\x1B[@-_]|[\x80-\x9F])[0-?]*[ -/]*[@-~]')
        return ansi_escape.sub('', line)

    def format(self, record):
        msg = logging.Formatter.format(self, record)
        if record.message != "":
            parts = msg.split(record.message)
            msg = msg.replace('\n', '\n' + parts[0])
        msg = self.escape_ansi(msg)
        return msg


def setup_logger(config):
    date_format = '%d-%m-%Y %H:%M:%S'
    log_format = '%(asctime)s %(levelname)-8s %(message)s'
    formatter = NewLineFormatter(log_format, datefmt=date_format)

    handler = logging.StreamHandler()
    handler.setFormatter(formatter)
    logger.addHandler(handler)
    logger.setLevel(config['log_level'])


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
    slip_dev.flush()
    cuttent_time = round(time.time(), 1)
    while True:
        data = slip_dev.read()
        if len(data) > 0:
            if data[0] != 0x02:
                continue
            else:
                return data[1]

        now_time = round(time.time(), 1)
        if ((now_time - cuttent_time) >= 2):
            return None

    return None


def enable_rx(is_en, slip_dev):
    slip_dev.write(create_rx_en_cmd(is_en))
    slip_dev.flush()


def load_input_file(config):
    file = open(config.get('input_file'), "r", encoding='utf-8')
    csv_reader = csv.reader(file, delimiter=',', quotechar='"')
    frames = [bytearray([int(val, 16) & 0xff for val in row]) for row in csv_reader]
    file.close()
    return frames


def receive(config, output_file):
    slip_dev = config['nodes']['receiver']['device']
    cuttent_time = round(time.time(), 1)
    while True:
        frame_data = slip_dev.read()
        if len(frame_data) > 0:
            if frame_data[0] != 0x01:
                continue
            frame_data = frame_data[1:]
            output_file.write("r,%s\n" % ",".join(["%02x" % x for x in frame_data]))
            output_file.flush()
            logger.debug('Received\n%s' % hexdump_pretty(frame_data))
            return frame_data

        now_time = round(time.time(), 1)
        if ((now_time - cuttent_time) >= 2):
            logger.debug('Nothing received')
            output_file.write("r,\n")
            output_file.flush()
            return None


# def send(config, output_file, frame_data):
def send(config, frame_data):
    slip_dev_rx = config['nodes']['receiver']['device']
    slip_dev_tx_1 = config['nodes']['transmitter_1']['device']
    slip_dev_tx_2 = config['nodes']['transmitter_2']['device']
    trig_config = [40, 40 + config.get('tx_delay')]

    #output_file.write("s,%s\n" % ",".join(["%02x" % x for x in frame_data]))
    # output_file.flush()

    slip_dev_tx_1.write(create_tx_data_cmd(frame_data))
    slip_dev_tx_1.flush()
    slip_dev_tx_2.write(create_tx_data_cmd(frame_data))
    slip_dev_tx_2.flush()
    # Need to wait for the transmitter devices to detect triggers
    time.sleep(0.1)
    slip_dev_rx.write(create_trigger_cmd(trig_config))
    slip_dev_rx.flush()


def setup_nodes(config):
    slip_dev_rx = config['nodes']['receiver']['device']
    slip_dev_tx_1 = config['nodes']['transmitter_1']['device']
    slip_dev_tx_2 = config['nodes']['transmitter_2']['device']

    slip_dev_tx_1.write(create_trig_in_en_cmd(True))
    slip_dev_tx_1.flush()
    slip_dev_tx_2.write(create_trig_in_en_cmd(True))
    slip_dev_tx_2.flush()
    slip_dev_rx.write(create_rx_en_cmd(True))
    slip_dev_rx.flush()


def reset_nodes(config):
    slip_dev_rx = config['nodes']['receiver']['device']
    slip_dev_tx_1 = config['nodes']['transmitter_1']['device']
    slip_dev_tx_2 = config['nodes']['transmitter_2']['device']

    slip_dev_tx_1.write(create_trig_in_en_cmd(False))
    slip_dev_tx_1.flush()
    slip_dev_tx_2.write(create_trig_in_en_cmd(False))
    slip_dev_tx_2.flush()
    slip_dev_rx.write(create_rx_en_cmd(False))
    slip_dev_rx.flush()


def associate_ports(config):
    if not config['ports']:
        config['ports'] = slipdev.SLIPDevice.get_ports()

    # Find node IDs on serial ports
    node_ids = {}
    for port in config['ports']:
        try:
            logger.info('Trying serial port %s', port)
            slip_dev = slipdev.SLIPDevice(port=port,
                                          baudrate=config.get('baudrate', 115200),
                                          timeout=0.1)
            node_id = get_node_id(slip_dev)
            if not node_id:
                logger.warning('No node at %s', port)
            else:
                node_ids[node_id] = port
            slip_dev.close()
        except Exception as e:
            logger.warning('%s', str(e))

    # Set associated serial port using node IDs
    for key in config.get('nodes'):
        node = config['nodes'][key]
        if node['id'] in node_ids:
            node['port'] = node_ids[node['id']]
            logger.info('Found Node ID %d on port %s', node['id'], node['port'])
        else:
            logger.error('Cannot find serial port for the Node ID: %d', node['id'])
            sys.exit(1)

    # Open serial ports for the nodes
    for key in config.get('nodes'):
        node = config['nodes'][key]
        node['device'] = slipdev.SLIPDevice(port=node['port'],
                                            baudrate=config.get('baudrate', 115200),
                                            timeout=0.1)


def close_ports(config):
    for key in config.get('nodes'):
        config['nodes'][key]['device'].close()


# ----------------------------------------------------------------------------------------

def receiver(shutdown_event, log_queue, config):
    slip_dev_rx = config['nodes']['receiver']['device']
    while not shutdown_event.is_set():
        frame_data = slip_dev_rx.read()
        if len(frame_data) > 4:
            # Frame length (1) + Frame counter (2) + FCS validity (2)
            if frame_data[0] != 0x01:
                continue
            frame_data = frame_data[1:]
            data_item = DataItem()
            data_item.frame_data = frame_data
            data_item.frame_counter = frame_data[1] + (frame_data[2] << 8)
            data_item.is_sent = False
            log_queue.put(data_item)


def sender(shutdown_event, log_queue, config):
    frames = load_input_file(config)
    for frame_data in frames:
        if shutdown_event.is_set():
            break

        data_item = DataItem()
        data_item.frame_data = frame_data
        data_item.frame_counter = frame_data[1] + (frame_data[2] << 8)
        data_item.is_sent = True
        log_queue.put(data_item)

        send(config, frame_data)
        time.sleep(config.get('send_interval'))

    shutdown_event.set()


def data_logger(shutdown_event, log_queue, config):
    output_file = open(config.get('output_file'), "w", encoding='utf-8')

    output_file.write("#delay,%d\n" % (config.get('tx_delay')))
    output_file.write("#send_interval,%d\n" % (config.get('send_interval')))

    sent_count = 0
    received_count = 0
    crc_faied_count = 0
    remnant_count = 0
    is_last_event_sent = True
    while not shutdown_event.is_set():
        try:
            data_item = log_queue.get(block=True, timeout=0.1)
            if data_item:
                if data_item.is_sent:
                    event = 's'
                    sent_count += 1
                    is_last_event_sent = True
                else:
                    if not is_last_event_sent:
                        # we are receiving remnants of other transmission.
                        remnant_count += 1
                        continue
                    is_last_event_sent = False
                    event = 'r'
                    received_count += 1
                    crc_ok = data_item.frame_data[-1] & 0x80 == 0x80
                    if not crc_ok:
                        crc_faied_count += 1

                log_str = 'event: %s' % event
                log_str += ', sent: %4d' % sent_count
                log_str += ', received: %4d' % received_count
                log_str += ', crc_failed: %4d' % crc_faied_count
                log_str += ', remnants: %4d' % remnant_count

                if logger.level == logging.DEBUG:
                    log_str += '\n'
                    log_str += hexdump_pretty(data_item.frame_data)

                logger.info(log_str)

                data_str = ",".join(["%02x" % x for x in data_item.frame_data])
                output_file.write("%s,%s\n" % (event, data_str))
                output_file.flush()

        except:
            continue

    output_file.write("#sent,%d\n" % (sent_count))
    output_file.write("#received,%d\n" % (received_count))
    output_file.write("#crc_failed,%d\n" % (crc_faied_count))
    output_file.write("#remnants,%d\n" % (remnant_count))

    output_file.close()


def main():

    def signal_handler(_1, _2):
        """ For setting shutdown event """
        shutdown_event.set()

    def validate_log_level(arg):
        arg = str(arg).lower()
        level = {"info": logging.INFO, "warn": logging.WARN, "debug": logging.DEBUG,
                 "i": logging.INFO, "w": logging.WARN, "d": logging.DEBUG}
        if arg not in level:
            raise argparse.ArgumentTypeError("log level should be (i)nfo, (w)arn or (d)ebug")
        return level[arg]

    parser = argparse.ArgumentParser(description='Delayed Transmission Test')
    parser.add_argument('-p', '--ports', metavar='PORTS', type=str, nargs=3,
                        default=None,
                        help='Three serial ports to be used')
    parser.add_argument('-b', '--baudrate', type=int,
                        default=115200,
                        help='Baudrate of the serial port')
    parser.add_argument('-d', '--tx-delay', metavar='TX_DELAY', type=int,
                        default=0,
                        help='Delays between two transmissions')
    parser.add_argument('-i', '--input-file', type=str, help='Input file')
    parser.add_argument('-o', '--output-file', type=str, help='Output file')
    parser.add_argument('-S', '--send-interval', type=parse_send_interval,
                        default=1.0,
                        help='Send interval')
    parser.add_argument('-l', '--log-level', type=validate_log_level,
                        default="info",
                        help='Set log level: info, warn, debug')

    args = parser.parse_args()
    config = vars(args)

    setup_logger(config)

    config['nodes'] = {'receiver': {'id': 1,
                                    'port': None,
                                    'device': None},
                       'transmitter_1': {'id': 2,
                                         'port': None,
                                         'device': None},
                       'transmitter_2': {'id': 3,
                                         'port': None,
                                         'device': None}}

    associate_ports(config)
    reset_nodes(config)
    setup_nodes(config)

    if not config.get('input_file', None):
        logger.error('No input file')
        sys.exit(1)

    if not config.get('output_file', None):
        logger.error('No output file')
        sys.exit(1)

    log_queue = queue.Queue(maxsize=10)
    shutdown_event = threading.Event()
    signal.signal(signal.SIGINT, signal_handler)

    data_logger_thread = threading.Thread(target=data_logger, args=(shutdown_event,
                                                                    log_queue,
                                                                    config))
    data_logger_thread.start()

    receiver_thread = threading.Thread(target=receiver, args=(shutdown_event,
                                                              log_queue,
                                                              config))
    receiver_thread.start()

    sender_thread = threading.Thread(target=sender, args=(shutdown_event,
                                                          log_queue,
                                                          config))
    sender_thread.start()

    while not shutdown_event.is_set():
        time.sleep(0.2)

    sender_thread.join()
    receiver_thread.join()
    data_logger_thread.join()

    reset_nodes(config)
    close_ports(config)


if __name__ == "__main__":
    main()
