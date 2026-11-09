# GNU tools (brew install coreutils gnu-sed findutils grep)
for tool in grep findutils gnu-sed coreutils
    fish_add_path --prepend --move "$HOMEBREW_PREFIX/opt/$tool/libexec/gnubin"
end
