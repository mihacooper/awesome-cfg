#!/bin/bash
if amixer -c 1 get Master | grep '\[off\]'
then
    amixer -c 1 set Master unmute
    amixer -c 1 set Headphone unmute
    amixer -c 1 set Speaker unmute
else
    amixer -c 1 set Master mute
    amixer -c 1 set Speaker mute
    amixer -c 1 set Headphone mute
fi