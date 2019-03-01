## Control part of Global Trigger

The logic part of Global Trigger contains:
  * spy-memories for input data, algos and finor
  * timer-counter module (*[tcm.vhd](../firmware/hdl/control/tcm.vhd)*) for internal counters
  * synchronization process for BGo signals
  * multiplexer for data of read-out-record (*[output_mux.vhd](../firmware/hdl/control/output_mux.vhd)*)

