#!/bin/bash -f
xv_path="/home/rommac/vivado/vivado_2015/Vivado/2015.4"
ExecStep()
{
"$@"
RETVAL=$?
if [ $RETVAL -ne 0 ]
then
exit $RETVAL
fi
}
ExecStep $xv_path/bin/xsim tmds_testbench_behav -key {Behavioral:sim_1:Functional:tmds_testbench} -tclbatch tmds_testbench.tcl -log simulate.log
