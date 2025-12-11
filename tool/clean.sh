#!/bin/bash
# del *.run *.vcd temp*

find . -type f \( -name *.run -o -name *.vcd -o -name temp* \) -exec rm {} +
