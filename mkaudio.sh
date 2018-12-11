#!/bin/bash
./$1 | ./sox-outputter.py > audio.dat && sox audio.dat audio.wav && rm audio.dat
