if (( $+commands[figlet] )); then
  if (( $+commands[lolcat] )); then
    echo $HOSTNAME | figlet -c -w $COLUMNS | lolcat -f
  else
    echo $HOSTNAME | figlet -c -w $COLUMNS
  fi
else
  echo -e "\n$HOSTNAME"
fi
