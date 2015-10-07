#!/bin/bash
amixer -c 1 get Master | grep '\[.*%\]' | sed 's/[^\[]*\[//' | sed 's/%\].*//' | cat
