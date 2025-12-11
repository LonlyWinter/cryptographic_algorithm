#!/bin/bash
# iverilog test

run_test(){
    name=$1
    echo -e "\n\nTest ${name/test_/} ..."
    iverilog src/*.sv test/${name}.sv -g2009 -s ${name} -o ${name}.run
    ./${name}.run
}

if [ -n "$1" ]; then
    for name in $@; do
        run_test test_${name};
    done
else
    for file in `ls ./test/*.sv`; do
        name1=`basename ${file}`
        name=${name1/.sv/}
        run_test ${name};
    done
fi

echo -e "\n\nTest done"