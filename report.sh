#!/bin/bash

if [ -e .env ]; then
    eval "$(cat .env <(echo) <(declare -x))"
    [ -z "$STUDENT_NAME" ] && echo "WARN: STUDENT_NAME is empty"
    [ -z "$STUDENT_ID" ] && echo "WARN: STUDENT_NAME is empty"
    [ -z "$STUDENT_UTID" ] && echo "WARN: STUDENT_UTID is empty"
else
    STUDENT_NAME="筑波太郎"
    STUDENT_ID="202311XXX"
    STUDENT_UTID="s2311XXX"
fi

for file in $(find . -type f -name '*.typ'); do
    typst compile $file --root . --input STUDENT_NAME="$STUDENT_NAME" --input STUDENT_ID="$STUDENT_ID" --input STUDENT_UTID="$STUDENT_UTID"
done
