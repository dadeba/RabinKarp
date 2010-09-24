#!/bin/zsh

DATAFILE="data.txt"

foreach xx ("each" "while" "end")
  echo $xx
  time grep $xx $DATAFILE | wc
  time ./rk.rb $DATAFILE $xx | wc
end
