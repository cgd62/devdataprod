#!/bin/bash
if test $# -ne 2
then
	echo "usage:  $0 infile outfile"
fi

egrep 'PRCP|TMIN|TMAX|SNOW|SNWD' $1 > core.dly


