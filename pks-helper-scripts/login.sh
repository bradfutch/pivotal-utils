#!/bin/bash

set -x

pks login -a $PKS_TARGET -u admin -p $PKS_SECRET -k
