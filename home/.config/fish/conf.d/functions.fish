function zd
  if test (count $argv) -eq 0
    builtin cd ~ && return
  elif test -d "$argv[1]"
    builtin cd "$argv[1]"
  else
    z $argv && printf "\U000F17A9 " && pwd || echo "Error: Directory not found"
  end
end

function c
  if test (count $argv) -eq 0
    open . -a "Cursor"
  else
    open $argv -a "Cursor"
  end
end
