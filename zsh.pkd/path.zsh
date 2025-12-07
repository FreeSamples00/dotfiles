evals=(
/usr/libexec/path_helper
)

path_before=(
/opt/homebrew/bin
/opt/homebrew/sbin
)

path_after=(
$HOME/.local/bin
$HOME/Library/Python/3.9/bin
)

for p in $evals; do
  if [ -d $p ] || [ -f $p ]; then
    eval "$($p)"
  else
    echo "Could not find $p"
  fi
done

for p in $path_before; do
  if [ -d $p ] || [ -f $p ]; then
    PATH="$p:$PATH"
  else
    echo "Could not find $p"
  fi
done

for p in $path_after; do
  if [ -d $p ] || [ -f $p ]; then
    PATH="$PATH:$p"
  else
    echo "Could not find $p"
  fi
done

alias path='echo $PATH | sed "s/:/\\n/g"'
