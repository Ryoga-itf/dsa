#!/bin/bash

TEXT_FILE="text"

if [ $# -ne 1 ]; then
  echo "Usage: $0 <length of text (n)> <output file>"
  exit 1
fi

n=$1

if ! [[ $n =~ ^[0-9]+$ ]] || [ $n -lt 2 ]; then
  echo "Error: n must be an integer greater than or equal to 2."
  exit 1
fi

text=$(printf "%0.sa" $(seq 1 $((n-1))))"b"

echo "$text" > "$TEXT_FILE"

extract_comparisons() {
  local command=$1

  $command 2>&1 | grep "# of comparison(s):" | awk '{print $NF}'
}

naive_comparisons=$(extract_comparisons "./mainNaive -v text pat")
kmp_comparisons=$(extract_comparisons "./mainKMP -v text pat")

echo "Comparisons in Naive: $naive_comparisons"
echo "Comparisons in KMP: $kmp_comparisons"
