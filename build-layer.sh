#!/usr/bin/env bash

if [ -d lib/ ]; then
  rm -rf lib/
fi

echo "bundle pypi packages"
pip install -r requirements.txt -t lib/python

find lib -type f | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm