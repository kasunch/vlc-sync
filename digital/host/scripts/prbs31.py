""" Module for generating PRBS """
import numpy

class PRBS31(object):
    """
    Generator PRBS31 based on x^31 + x^28 + 1
    """
    def __init__(self, seed):
        self.shift_reg = numpy.int32(seed)

    def next(self):
        """ Returns the next 32-bit sequence """
        new_bit = ((self.shift_reg >> 30) ^ (self.shift_reg >> 27)) & 0x00000001
        self.shift_reg = (self.shift_reg << 1 | new_bit) & 0x7fffffff
        return self.shift_reg
