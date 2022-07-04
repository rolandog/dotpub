# /etc/profile.d/xdg_std_home.sh - Define $XDG_*_HOME variables 

### Standard XDG Base Directory

# if XDG_BIN_HOME is null
if [ -z "$XDG_BIN_HOME" ]; then
  XDG_BIN_HOME="$HOME"/.local/bin
  export XDG_BIN_HOME
fi

# if XDG_BIN_HOME does not exist
if [ ! -d "$XDG_BIN_HOME" ]; then
  mkdir -p $XDG_BIN_HOME
  chmod 0700 $XDG_BIN_HOME
fi


# if XDG_CACHE_HOME is null
if [ -z "$XDG_CACHE_HOME" ]; then
  XDG_CACHE_HOME="$HOME"/.cache
  export XDG_CACHE_HOME
fi

# if XDG_CACHE_HOME does not exist
if [ ! -d "$XDG_CACHE_HOME" ]; then
  mkdir -p $XDG_CACHE_HOME
  chmod 0700 $XDG_CACHE_HOME
fi


# if XDG_CONFIG_HOME is null
if [ -z "$XDG_CONFIG_HOME" ]; then
  XDG_CONFIG_HOME="$HOME"/.config
  export XDG_CONFIG_HOME
fi

# if XDG_CONFIG_HOME does not exist
if [ ! -d "$XDG_CONFIG_HOME" ]; then
  mkdir -p $XDG_CONFIG_HOME
  chmod 0700 $XDG_CONFIG_HOME
fi


# if XDG_DATA_HOME is null
if [ -z "$XDG_DATA_HOME" ]; then
  XDG_DATA_HOME="$HOME"/.local/share
  export XDG_DATA_HOME
fi

# if XDG_DATA_HOME does not exist
if [ ! -d "$XDG_DATA_HOME" ]; then
  mkdir -p $XDG_DATA_HOME
  chmod 0700 $XDG_DATA_HOME
fi


# if XDG_STATE_HOME is null
if [ -z "$XDG_STATE_HOME" ]; then
  XDG_STATE_HOME="$HOME"/.local/state
  export XDG_STATE_HOME
fi

# if XDG_STATE_HOME does not exist
if [ ! -d "$XDG_STATE_HOME" ]; then
  mkdir -p $XDG_STATE_HOME
  chmod 0700 $XDG_STATE_HOME
fi


### Non-Standard Additions

# if XDG_GAMES_HOME is null
if [ -z "$XDG_GAMES_HOME" ]; then
  XDG_GAMES_HOME="$HOME"/.local/games
  export XDG_GAMES_HOME
fi

# if XDG_GAMES_HOME does not exist
if [ ! -d "$XDG_GAMES_HOME" ]; then
  mkdir -p $XDG_GAMES_HOME
  chmod 0700 $XDG_GAMES_HOME
fi


# if XDG_LIB_HOME is null
if [ -z "$XDG_LIB_HOME" ]; then
  XDG_LIB_HOME="$HOME"/.local/lib
  export XDG_LIB_HOME
fi

# if XDG_LIB_HOME does not exist
if [ ! -d "$XDG_LIB_HOME" ]; then
  mkdir -p $XDG_LIB_HOME
  chmod 0700 $XDG_LIB_HOME
fi

