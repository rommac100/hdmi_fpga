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
ExecStep $xv_path/bin/xelab -wto adb665de8897410bbd39d65eb1c0861f -m64 --debug typical --relax --mt 8 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip --snapshot tmds_testbench_behav xil_defaultlib.tmds_testbench xil_defaultlib.glbl -log elaborate.log
