#!/usr/bin/tclsh

set mod_id $env(module_id)
# puts $mod_id

set l1menu "../../src/module_${mod_id}/l1menu.vhd"
set l1menu_pkg "../../src/module_${mod_id}/l1menu_pkg.vhd"

add_files -norecurse -fileset sources_1 $l1menu $l1menu_pkg
