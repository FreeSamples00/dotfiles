if which tty-clock >/dev/null; then
  sleep 0.5
  tty-clock -Bbsctn -C 5 -f "%A %m/%d %Y"
else
  echo -e "\n\033[91mERR: tty-clock not installed\033[0m" | less -R
fi
