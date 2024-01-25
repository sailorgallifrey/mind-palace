#!/usr/bin/env bash

sudo lsof -i -P | grep LISTEN | grep :$1
