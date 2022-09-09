set auto-load local-gdbinit on
set print elements 0
add-auto-load-safe-path /

python

import os, subprocess, sys

sys.path.insert(0, '/root/gdb')
from eigen_gdb import register_eigen_printers
register_eigen_printers(None)

# Execute a Python using the user's shell and pull out the sys.path (for site-packages)
paths = subprocess.check_output('/usr/bin/python3 -c "import os,sys;print(os.linesep.join(sys.path).strip())"',shell=True).decode("utf-8").split()

# Extend GDB's Python's search path
sys.path.extend(paths)

end

source /root/gdb/opencv_gdb.py