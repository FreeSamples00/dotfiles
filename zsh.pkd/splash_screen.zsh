if (which figlet >/dev/null); then
  if (which lolcat >/dev/null); then
    echo $HOSTNAME | figlet -c -w $COLUMNS | lolcat -f
  else
    echo $HOSTNAME | figlet -c -w $COLUMNS
  fi
else
  echo -e "\n$HOSTNAME"
fi
