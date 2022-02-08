import atexit
import os
import readline

"""
Sets ~/.python_history to $XDG_STATE_HOME/python/python_history
"""

histfile = os.path.join(
    os.path.expanduser("~"),
    ".local",
    "state",
    "python",
    "python_history"
)
try:
    readline.read_history_file(histfile)
    # default history len is -1 (infinite), which may grow unruly
    readline.set_history_length(1000)
except FileNotFoundError:
    pass

atexit.register(readline.write_history_file, histfile)

