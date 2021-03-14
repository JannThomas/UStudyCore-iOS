#!/bin/bash

BASEDIR=$(dirname $0)
browserify $BASEDIR/main.js --standalone modules > $BASEDIR/modules.js
