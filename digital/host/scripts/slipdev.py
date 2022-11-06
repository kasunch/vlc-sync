"""
SLIP device
"""
import serial
import serial.tools.list_ports

class SLIPDevice(serial.Serial):

    __SLIP_CHAR_END = 0xC0
    __SLIP_CHAR_ESC = 0xDB
    __SLIP_CHAR_ESC_END = 0xDC
    __SLIP_CHAR_ESC_ESC = 0xDD

    __SLIP_STATE_OK = 1
    __SLIP_STATE_ESC = 2
    __SLIP_STATE_RUBBISH = 3

    def __init__(self, *args, **kwargs):
        super(SLIPDevice, self).__init__(*args, **kwargs)
        self._decoded_data = bytearray()
        self._serial_bytes = bytearray()
        self._state = self.__SLIP_STATE_RUBBISH

    def _decode_frame(self):
        """ Decode a SLIP frame from received serial data

        The characters are consumed from index 0 of the _serial_bytes.
        Erroneous characters and consumed characters are removed.
        Unconsumed characters are left in the _serial_bytes.

        Returns: None if it is not possible to decode a complete frame.
        """
        while len(self._serial_bytes) > 0:
            byte = self._serial_bytes[0]
            if self._state == self.__SLIP_STATE_RUBBISH:
                if byte == self.__SLIP_CHAR_END:
                    # we found an start
                    self._state = self.__SLIP_STATE_OK
                    self._decoded_data = bytearray()
                self._serial_bytes.pop(0)
            elif self._state == self.__SLIP_STATE_OK:
                if byte == self.__SLIP_CHAR_END:
                    # we found an end
                    self._state = self.__SLIP_STATE_RUBBISH
                    if len(self._decoded_data) > 0:
                        return self._decoded_data
                elif byte == self.__SLIP_CHAR_ESC:
                    # we found escape character. So we expect an escaped character
                    self._state = self.__SLIP_STATE_ESC
                    self._serial_bytes.pop(0)
                else:
                    # Some other character
                    self._decoded_data.append(byte)
                    self._serial_bytes.pop(0)
            elif self._state == self.__SLIP_STATE_ESC:
                if byte == self.__SLIP_CHAR_ESC_END:
                    self._state = self.__SLIP_STATE_OK
                    self._decoded_data.append(self.__SLIP_CHAR_END)
                elif byte == self.__SLIP_CHAR_ESC_ESC:
                    self._state = self.__SLIP_STATE_OK
                    self._decoded_data.append(self.__SLIP_CHAR_ESC)
                else:
                    # erroneous character found
                    self._state = self.__SLIP_STATE_RUBBISH
                    self._decoded_data = bytearray()
                self._serial_bytes.pop(0)

        return bytearray()

    def read(self):
        """ Read bytes via SLIP
        """
        slip_data = bytearray()
        while len(slip_data) == 0:
            read_bytes = super(SLIPDevice, self).read(1)
            self._serial_bytes.extend(read_bytes)
            slip_data = self._decode_frame()
            if (self.timeout or len(slip_data) > 0):
                break
        return slip_data

    def write(self, data):
        """ Write bytes as a SLIP frame
        Args:
            data: bytes
        Returns:
            Number of bytes written
        """
        slip_buffer = bytearray()
        slip_buffer.append(self.__SLIP_CHAR_END)
        for byte in data:
            if byte == self.__SLIP_CHAR_END:
                slip_buffer.append(self.__SLIP_CHAR_ESC)
                slip_buffer.append(self.__SLIP_CHAR_ESC_END)
            elif byte == self.__SLIP_CHAR_ESC:
                slip_buffer.append(self.__SLIP_CHAR_ESC)
                slip_buffer.append(self.__SLIP_CHAR_ESC_ESC)
            else:
                slip_buffer.append(byte)
        slip_buffer.append(self.__SLIP_CHAR_END)

        return super(SLIPDevice, self).write(slip_buffer)

    @staticmethod
    def get_ports(hwid_filter=[]):
        matched_ser_ports = []
        for port in serial.tools.list_ports.comports():
            if len(hwid_filter) > 0:
                for hwid_str in hwid_filter:
                    if hwid_str in port.hwid:
                        matched_ser_ports.append(port.device)
            else:
                matched_ser_ports.append(port.device)
        return matched_ser_ports


        
            

