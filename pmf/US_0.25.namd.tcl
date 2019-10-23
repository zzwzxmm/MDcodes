#############################################################
## JOB DESCRIPTION   Constant Velocity Pulling             ##
#############################################################


#############################################################
## ADJUSTABLE PARAMETERS                                   ##
#############################################################

set psfname Na_3RVY
set serial 0.25
set pdbname US_${serial}




structure          ../../eq/${psfname}.psf
coordinates        ./pdb/${pdbname}.pdb

set temperature    310
set outputname     out/$pdbname
firsttimestep      0

if {0} {
set inputname      eq/out/$pdbname-$serialold
binCoordinates     ${inputname}.restart.coor
binVelocities      ${inputname}.restart.vel  ;# remove the "temperature" entry if you use this!
extendedSystem     $inputname.restart.xsc
} 


#############################################################
## SIMULATION PARAMETERS                                   ##
#############################################################


# Input

paraTypeCharmm	    on
parameters         /home/qiuh/Dir/namd/common/par_all27_prot_lipid_cmap.inp
parameters         /home/qiuh/Dir/namd/common/ions.dat
COMmotion                no  ; #allow center of mass motion ?
temperature              $temperature


# Force-Field Parameters
exclude             scaled1-4
1-4scaling          1.0
cutoff              12. 
switching           on
switchdist          10. 
pairlistdist        16  
pairlistsPerCycle   2

#outputPairlists	1
margin		2.5

# Integrator Parameters
 if {0} {
timestep             2.0  ;# 2fs/step
rigidBonds           all  ;# needed for 2fs steps
nonbondedFreq        1
useSettle		on
fullElectFrequency   2  
stepspercycle        20
}
 if {1} {
timestep             1
rigidBonds           none
nonbondedFreq        1
fullElectFrequency   2  
stepspercycle        20
}

# PME (for full-system periodic electrostatics)
 if {1} {
PME			on
PMEGridSizeX		80
PMEGridSizeY		80
PMEGridSizeZ		75
FFTWEstimate		yes
}
#############################################################
## Boundary Conditions                                     ##
#############################################################
# Periodic Boundary Conditions
 if {1} {
cellBasisVector1	76.8 0 0
cellBasisVector2	0 76.8 0
cellBasisVector3	0 0 73.7
cellOrigin	        0 0 0
}
if {1} {
XSTfile			$outputname.xst
XSTfreq			2000
wrapAll			on
}

#############################################################
## Pressure Control                                        ##
#############################################################
# Constant Pressure Control (variable volume)
  if {1} {
useGroupPressure		yes
useFlexibleCell		yes
useConstantRatio		yes

# Nose-hoover Langevin piston pressure control
# This method should be combined with Langevin dynamics 
# in order to simulate the NPT ensemble

LangevinPiston		        on
LangevinPistonTarget		1.01325     ;#  in bar -> 1 atm
LangevinPistonPeriod		400         ;#  --->800 400 200
LangevinPistonDecay		200         ;#  --->400 200 100
LangevinPistonTemp		$temperature
SurfaceTensionTarget		0.0
ExcludeFromPressure		on
ExcludeFromPressureFile 	./pdb/${pdbname}.pdb
ExcludeFromPressureCol	        O
}
#############################################################
## Temperature Control and Equilibration                   ##
#############################################################
# Langevin dynamics parameters
 if {1} {
langevin		on    ;# do langevin dynamics
langevinTemp		$temperature
langevinDamping	        5   ;# damping coefficient (gamma) of 5/ps
langevinHydrogen	off   ;# don't couple langevin bath to hydrogens
}

#############################################################
## Constraints and Restraints                              ##
#############################################################
# Fixed atoms parameters
if {0} {

fixedAtoms on
fixedAtomsFile ./${pdbname}-$serial.pdb
fixedAtomsCol O
}


# Harmonic constraint parameters  
 # Harmonic constraint parameters  
 if {0} {
constraints on
consexp 2
consref ./${pdbname}-$serial.pdb
conskfile ./${pdbname}-$serial.pdb
conskcol B
#selectConstraints               on
#selectConstrX                   on
#selectConstrY                   on
#selectConstrZ                   on
}

# Tcl interface

#############################################################
## EXTRA PARAMETERS                                       ##
#############################################################

# Put here any custom parameters that are specific to 
# this job (e.g., SMD, TclForces, etc...)
if {1} {
colvars              on
colvarsConfig        ./Distance/Distance_${serial}.in
#numsteps             500000
}
#############################################################
## EXECUTION SCRIPT                                        ##
#############################################################
# Output
outputName          $outputname
binaryrestart		yes
restartfreq         1000     ;# 500steps = every 1ps
DCDfreq             1000
outputEnergies      1000
outputPressure      1000
outputtiming		1000
# Minimization
 if {1} {
minimize             100
reinitvels          $temperature
run                 500000
}
