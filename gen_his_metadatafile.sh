#!/usr/bin/tclsh

##Usage: ./get_ion_vs_t.sh  
set lowboundary -6
set upperboundary 6
set width 0.5
set spring 20

set file [open hist_metadatafile w]
puts $file "# In the first line: Number_of_simulations, Min_value, Max_value, Size_of_bin, Number_of_lines_skip"

puts $file "# Since the second line: File names of the simulation output files: time development of the reaction coordinate values"

puts $file "24     -6     6     0.05        0 "

for {set i $lowboundary} {$i < [expr $upperboundary-($width)/2]} {} {
set COM_window [expr $i+double($width)/2]
puts $file "../ion_vs_t/ion_vs_t_${COM_window}.dat"

puts $COM_window
set i [expr $i+$width]
}
close $file

