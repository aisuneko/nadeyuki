# TOP-LEVEL TEMPLATE - BEGIN
#
# QSYS_SIMDIR is used in the Quartus-generated IP simulation script to
# construct paths to the files required to simulate the IP in your Quartus
# project. By default, the IP script assumes that you are launching the
# simulator from the IP script location. If launching from another
# location, set QSYS_SIMDIR to the output directory you specified when you
# generated the IP script, relative to the directory from which you launch
# the simulator.
#
set QSYS_SIMDIR /home/aisuneko/src/fpga/quartus/yukiyuna/yukiyuna_cordic/simulation
#
# Source the generated IP simulation script.
source $QSYS_SIMDIR/mentor/msim_setup.tcl
#
# Set any compilation options you require (this is unusual).
# set USER_DEFINED_COMPILE_OPTIONS <compilation options>
# set USER_DEFINED_VHDL_COMPILE_OPTIONS <compilation options for VHDL>
# set USER_DEFINED_VERILOG_COMPILE_OPTIONS +acc=rnp+yukiyuna
#
# Call command to compile the Quartus EDA simulation library.
dev_com
#
# Call command to compile the Quartus-generated IP simulation files.
com
#
# Add commands to compile all design files and testbench files, including
# the top level. (These are all the files required for simulation other
# than the files compiled by the Quartus-generated IP simulation script)
#
vlog /home/aisuneko/src/fpga/quartus/yukiyuna/*.v
#
# Set the top-level simulation or testbench module/entity name, which is
# used by the elab command to elaborate the top level.
#
set TOP_LEVEL_NAME tb_yukiyuna
#
# Set any elaboration options you require.
#set USER_DEFINED_ELAB_OPTIONS "-access rw"
#
# Call command to elaborate your design and testbench.
elab -debugdb
#
# Run the simulation.
# run -all
#
# Add signals to waveform
add wave $TOP_LEVEL_NAME/*
run -all
# Report success to the shell.
# exit -code 0
#
# TOP-LEVEL TEMPLATE - END
