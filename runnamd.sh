#!/usr/bin/tclsh
##Usage: ./runnamd.sh
set lowboundary -6
set upperboundary 6
set width 0.5
set i $lowboundary
puts $i
for {set i $lowboundary} {$i < [expr $upperboundary-($width)/2]} {} {
set COM_window [expr $i+double($width)/2]
if {$COM_window <=-4.25 } {
exec runnamd -n 24 US_${COM_window}.namd.tcl -v 2.8 -q largemem
} else {
exec runnamd -n 24 US_${COM_window}.namd.tcl -v 2.8
}


## in tclsh  " " shound be used to replace `` (while in bash,it is OK)
set i [expr $i+$width]
puts $i
}


