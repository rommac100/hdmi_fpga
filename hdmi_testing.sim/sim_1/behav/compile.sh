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
echo "xvlog -m64 --relax -prj tmds_testbench_vlog.prj"
ExecStep $xv_path/bin/xvlog -m64 --relax -prj tmds_testbench_vlog.prj 2>&1 | tee compile.log
