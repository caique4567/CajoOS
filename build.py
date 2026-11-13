"""Convenience launcher for the CajoOS image build."""

import os
import runpy
import sys

TOOLS = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'tools')
sys.path.insert(0, TOOLS)
SCRIPT = os.path.join(TOOLS, 'build.py')
runpy.run_path(SCRIPT, run_name='__main__')
