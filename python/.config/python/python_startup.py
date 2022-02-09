import atexit
import os
import readline

"""
Sets ~/.python_history to $XDG_STATE_HOME/python/history

The file is executed in the same namespace where interactive commands
are executed so that objects defined or imported in it can be used
without qualification in the interactive session.

References
----------
[1] https://docs.python.org/3/using/cmdline.html#envvar-PYTHONSTARTUP
"""

histfile = os.path.join(
    os.path.expanduser("~"),
    ".local",
    "state",
    "python",
    "history"
)
try:
    readline.read_history_file(histfile)
    # default history len is -1 (infinite), which may grow unruly
    readline.set_history_length(1000)
except FileNotFoundError:
    pass

atexit.register(readline.write_history_file, histfile)

