#!/bin/bash
if amixer -c 1 get Master | grep '\[off\]'
then
    cat "<span color=\"#CC7777\"> M </span>"
fi