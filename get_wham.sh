#!/usr/bin/tclsh

##Usage: ./get_ion_vs_t.sh  ; convert data to input of wham 
set lowboundary -6
set upperboundary 6
set width 0.5
set spring 20

set file [open metafile w]
for {set i $lowboundary} {$i < [expr $upperboundary-($width)/2]} {} {
set COM_window [expr $i+double($width)/2]
puts $file "./ion_vs_t/ion_vs_t_${COM_window}.dat ${COM_window} $spring"

puts $COM_window
set i [expr $i+$width]
}
close $file

set histmin -6
set histmax 6
set num_bins 120
set tol 0.001
set tem 310.0
set numpad 0
set outputfile IN_Na_wham

exec wham  $histmin $histmax $num_bins $tol $tem $numpad metafile $outputfile.dat > $outputfile.log
