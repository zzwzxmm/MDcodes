#!/usr/bin/tclsh

##Usage: ./get_ion_vs_t.sh  ; convert data to input of wham 
set lowboundary -6
set upperboundary 6
set width 0.5

for {set i $lowboundary} {$i < [expr $upperboundary-($width)/2]} {} {
set COM_window [expr $i+double($width)/2]
set infile ../../out/US_${COM_window}.colvars.traj 
set out [open ion_vs_t_${COM_window}.dat w]
set in [open $infile r]
 while {[gets $in line]>=0} {
   if {[lindex $line 0] != "#" && [lindex $line 0] >100100} {
     set step [lindex $line 0]
     set ion  [lindex $line 1]
     puts $out "[expr double($step-100)/1000] \t $ion"

  }
}
close $out
puts $COM_window
set i [expr $i+$width]

}


