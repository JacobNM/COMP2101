#!/bin/bash

while [ $# -gt 0 ]; do
    case "$1" in
    -h | --help )
        echo "Usage: $(basename "$0") [-h|--help]"
        exit
        ;;
    * )
        echo "Unrecognized argument '$1'"
        exit 1
        ;;
    esac
    shift
done
# Command line processed
# Named arguments recognized and saved as needed