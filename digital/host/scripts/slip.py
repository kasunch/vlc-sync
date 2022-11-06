"""
SLIP module
"""
class SLIP(object):
    """
    Class for decoding and encoding SLIP frames
    """

    __SLIP_CHAR_END = 0xC0
    __SLIP_CHAR_ESC = 0xDB
    __SLIP_CHAR_ESC_END = 0xDC
    __SLIP_CHAR_ESC_ESC = 0xDD

    __SLIP_STATE_OK = 1
    __SLIP_STATE_ESC = 2
    __SLIP_STATE_RUBBISH = 3

    def __init__(self):
        self.decode_state = self.__SLIP_STATE_RUBBISH
        self.lst_decoded_data = []

    def decode_frame(self, serial_chars):
        """ Decode a SLIP frame from received serial data

        The characters are consumed from index 0 of the serial_chars.
        Erroneous characters and consumed characters are removed.
        Unconsumed characters are left in the serial_chars.

        Args:
            serial_chars: Data read from the serial port
        Returns: None if it is not possible to decode a complete frame.
        """
        while len(serial_chars) > 0:
            byte = ord(serial_chars[0])
            if self.decode_state == self.__SLIP_STATE_RUBBISH:
                if byte == self.__SLIP_CHAR_END:
                    # we found an start
                    self.decode_state = self.__SLIP_STATE_OK
                    self.lst_decoded_data = []
                serial_chars.pop(0)
            elif self.decode_state == self.__SLIP_STATE_OK:
                if byte == self.__SLIP_CHAR_END:
                    # we found an end
                    self.decode_state = self.__SLIP_STATE_RUBBISH
                    if len(self.lst_decoded_data) > 0:
                        return self.lst_decoded_data
                elif byte == self.__SLIP_CHAR_ESC:
                    # we found escape character. So we expect an escaped character
                    self.decode_state = self.__SLIP_STATE_ESC
                    serial_chars.pop(0)
                else:
                    # Some other character
                    self.lst_decoded_data.append(byte)
                    serial_chars.pop(0)
            elif self.decode_state == self.__SLIP_STATE_ESC:
                if byte == self.__SLIP_CHAR_ESC_END:
                    self.decode_state = self.__SLIP_STATE_OK
                    self.lst_decoded_data.append(self.__SLIP_CHAR_END)
                elif byte == self.__SLIP_CHAR_ESC_ESC:
                    self.decode_state = self.__SLIP_STATE_OK
                    self.lst_decoded_data.append(self.__SLIP_CHAR_ESC)
                else:
                    # erroneous character found
                    self.decode_state = self.__SLIP_STATE_RUBBISH
                    self.lst_decoded_data = []
                serial_chars.pop(0)

        return None

    def encode_frame(self, lst_bytes):
        """ Encode characters to a SLIP frame
        Args:
            packet: bytes
        Returns:
            A encoded SLIP frame
        """
        lst_buffer = []
        lst_buffer.append(self.__SLIP_CHAR_END)
        for byte in lst_bytes:
            if byte == self.__SLIP_CHAR_END:
                lst_buffer.append(self.__SLIP_CHAR_ESC)
                lst_buffer.append(self.__SLIP_CHAR_ESC_END)
            elif byte == self.__SLIP_CHAR_ESC:
                lst_buffer.append(self.__SLIP_CHAR_ESC)
                lst_buffer.append(self.__SLIP_CHAR_ESC_ESC)
            else:
                lst_buffer.append(byte)
        lst_buffer.append(self.__SLIP_CHAR_END)

        return lst_buffer
