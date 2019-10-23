##Usage: 1. load US_0.0_input.pdb to vmd
##       2. Source it in VMD
set ion1_left -4  ;# this ion is the lower one
set ion1_right 3
set dis_min  2 ;#min distance between ion1 and ion2
set dis_max  2.9

set width 0.5

set ion1 [atomselect top "segname I and resid 1"]
set ion2  [atomselect top "segname I and resid 2"]
set all [atomselect top all]

for {set i $ion1_left} {$i < [expr $ion1_right-($width)/2]} {} {
set COM_ion1 [expr $i+double($width)/2]
set disvec1 "0 0 $COM_ion1"
$ion1 moveby $disvec1
  
  for {set dis $dis_min} {$dis <= $dis_max} {} {
    set COM_ion2 [expr $COM_ion1 + $dis]
    puts "$COM_ion1 $COM_ion2"
    set disvec2 "0 0  $COM_ion2"
    $ion2 moveby $disvec2

    $all writepdb US_${COM_ion1}_${COM_ion2}.pdb
    set dis [expr $dis+$width]
   set disvec_back2 "0 0 [expr 0-$COM_ion2]"
   $ion2 moveby $disvec_back2;#move back to its initial position
  }    
set i [expr $i+$width]

set disvec_back1 "0 0 [expr 0-$COM_ion1]"

$ion1 moveby $disvec_back1;#move back to its initial position
}


