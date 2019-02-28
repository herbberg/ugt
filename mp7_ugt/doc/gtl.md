## Global Trigger Logic

The logic part of Global Trigger contains all VHDL modules used to create trigger algorithms. This logic part is made of three stages.
In the first stage conversions and calculations with data (comimg from the frame part of Global Trigger) are done. The second stage contains
the comparators (data versus requirements), here input and output register are implemented, which can be switched on and off by constants
in VHDL code. So called conditions and algorithms are implemented in the third stage, output register in the algo part are used.
All the VHDL mpdule instantiations of Global Trigger Logic are generated by VHDL Producer, a software tool, which converts information
of a given L1Menu (from a XML file) to VHDL code.