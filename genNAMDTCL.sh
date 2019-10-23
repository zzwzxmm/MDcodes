#!/usr/bin/tclsh
##Usage: ./genDistance.sh
set lowboundary -6
set upperboundary 6
set width 0.5
set i $lowboundary
puts $i
for {set i $lowboundary} {$i < [expr $upperboundary-($width)/2]} {} {
set COM_window [expr $i+double($width)/2]
if {$COM_window != -5.75} {
exec sed "s/-5.75/$COM_window/g"  US_-5.75.namd.tcl > US_${COM_window}.namd.tcl
}
## in tclsh  " " shound be used to replace `` (while in bash,it is OK)
set i [expr $i+$width]
puts $i
}


