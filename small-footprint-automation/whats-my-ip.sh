#!/bin/bash

http 'https://api.ipify.org?format=json' | jq -r '.ip'
