# Description of Global Trigger Upgrade firmware for MP7

**UNDER CONSRUCTION !!!**
*****

Top hierarchy module of ugt firmware *[mp7_payload.vhd](firmware/hdl/mp7_payload.vhd)*, which is embedded in the MP7 firmware framework, contains two main parts:

* [Control](doc/control.md) of ugt firmware (*[gt_control.vhd](firmware/hdl/gt_control.vhd)*)
* [Data](doc/data.md) of ugt firmware (*[gt_data.vhd](firmware/hdl/gt_data.vhd)*), which contains 
  * Global Trigger Logic ([GTL](doc/gtl.md)): 
    * conversions and calculations
    * comparisons
    * conditions and algos
  * Final Decision Logic ([FDL](doc/fdl.md))

Picture of invariant-mass:
![invariant-mass schema](https://gitlab.cern.ch/hbergaue/ugt/blob/master/mp7_ugt/doc/src/latex/figures/invariant-mass.png "invariant-mass schema")

