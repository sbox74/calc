#!/bin/bash

PARAMS=("$@")
RES=-32768
EXPR_COUNTER=0

function test_expr() {
  (( "$1" )) 2>/dev/null
}

for file in ${PARAMS[@]}; do
  echo
  echo "processing file: $file"
  [ ! -f $file ] && echo "$file: file not found" && continue
  while read expression ; do
    echo "expression: $expression"
    test_expr "$expression"
    [ $? -gt 0 ] && echo "incorrect expression" && continue
    EXP_RES=$(( $expression ))
    echo "result: $EXP_RES"
    [ $EXP_RES -gt $RES ] && RES=$EXP_RES
    EXPR_COUNTER=$(( $EXPR_COUNTER + 1 ))
  done < $file
done

echo
echo "files processed: ${#PARAMS[@]}"
echo "expressions processed: $EXPR_COUNTER"
[ $EXPR_COUNTER -gt 1 ] && echo "the highest value: $RES"

