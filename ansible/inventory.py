#!/usr/bin/python

# https://stackoverflow.com/a/48691363/11925438

import os

__location__ = os.path.realpath(os.path.join(os.getcwd(), os.path.dirname(__file__)))

with open(os.path.join(__location__, "inventory.json")) as f:
	print f.read()
