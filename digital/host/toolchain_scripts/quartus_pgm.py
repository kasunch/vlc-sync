#!/usr/bin/python
"""
Main module for programming multiple FPGAs via multiple USB blaster devices
"""

from __future__ import print_function
import sys
import time
import argparse
import subprocess
import re

def exec_cmd(cmd):
    p = subprocess.Popen(cmd, stderr=subprocess.STDOUT, stdout=subprocess.PIPE)
    cond = True
    output = []
    while (cond):
        for _, line in enumerate(iter(p.stdout.readline, b"")):
            output.append(line.decode("utf-8").strip())
        cond = p.poll is None
    return output, p.returncode

def get_usb_cables(quartus_pgm_path):
    cmd = []
    cmd.append(quartus_pgm_path)
    cmd.append('-l')
    output, return_code = exec_cmd(cmd)
    regex_obj = re.compile("\d+\)\s(.+)", re.M | re.I)
    usb_cable_names = []
    for line in output:
        match_obj = regex_obj.match(line)
        if match_obj:
            usb_cable_names.append(match_obj.group(1))
    return usb_cable_names

def configure_device(quartus_pgm_path, cable_name, sof_file):
    # quartus_pgm -c "USB-Blaster [3-2.4.1.1]" -m jtag -o p;glossy_app_top.sof
    cmd = []
    cmd.append(quartus_pgm_path)
    cmd.append('-c')
    cmd.append(cable_name)
    cmd.append('-m')
    cmd.append('jtag')
    cmd.append('-o')
    cmd.append('p;' + str(sof_file))
    output, return_code = exec_cmd(cmd)
    return output, return_code

def print_cables(usb_cable_names):
    for i, name in enumerate(usb_cable_names):
        print("%s" % (name))

def main():
    """
    Main function
    """

    QUARTUS_PGM_PATH="/home/kasun/software/altera/intelFPGA_lite/17.1/quartus/bin/quartus_pgm"

    parser = argparse.ArgumentParser(description='Program FPGA via USB blaster')
    parser.add_argument('-a', '--all', action='store_true', help='Apply to all cables')
    parser.add_argument('-c', '--cables', type=str, nargs='+', default=[], help='Cables')
    parser.add_argument('-l', '--list', action='store_true', help='List cables')
    parser.add_argument('-p', '--program', action='store_true', help='Program')
    parser.add_argument('-s', '--sof-file', type=str, default="", help='SOF file')
    
    
    args = parser.parse_args()

    if (args.list):
        usb_cable_names = get_usb_cables(QUARTUS_PGM_PATH)
        print_cables(usb_cable_names)
        return
    else: 
        if (args.program):
            if (args.sof_file == ""):
                print("sof file is not given")
                return 
            
            cable_names = get_usb_cables(QUARTUS_PGM_PATH)
            available_cables = {name:name for name in cable_names}
            usb_cable_names = []
            if args.all:
                usb_cable_names.extend(available_cables.keys())
            elif len(args.cables) > 0:
                specified_cable_names = args.cables
                unique_cables = list(set(specified_cable_names))
                for name in unique_cables:
                    if not available_cables.has_key(name):
                        print("ERROR: No cable found with name %s" %(name))
                        return
                    else:
                        usb_cable_names.append(name)
            else:
                print("****Cables found****")
                print_cables(usb_cable_names)
                print("ERROR: Unable to find applicable devices")
                return 

            print("****Cables applicable****")
            print_cables(usb_cable_names)
            print("****Configuring****")
            for cable_name in usb_cable_names:
                print("%s" % cable_name)
                output, return_code = configure_device(QUARTUS_PGM_PATH, cable_name, args.sof_file)
                if not return_code is None:
                    print(output)

if __name__ == "__main__":
    main()