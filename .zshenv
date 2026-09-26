export VPS=root@187.124.236.70

export PATH=$PATH:~/.local/bin
export PATH=$PATH:~/go/bin

# LuaLS finds main.lua relative to the path it's invoked from (it doesn't
# resolve symlinks), so a ~/.local/bin symlink breaks it. Add its bin dir instead.
export PATH=$PATH:/opt/lua-language-server/bin
