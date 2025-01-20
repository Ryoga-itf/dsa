#!/bin/bash

TEXT_FILE="text"

extract_comparisons() {
  local command=$1

  $command 2>&1 | grep "# of comparison(s):" | awk '{print $NF}'
}


echo "#let naive_data = ("
for n in $(seq 1000 1000 10000); do
  text=$(printf "%0.sa" $(seq 1 $((n-1))))"b"
  echo "$text" > "$TEXT_FILE"
  naive_comparisons=$(extract_comparisons "./mainNaive -v text pat")
  echo "  ($n, ${naive_comparisons/%?/}),"
done
echo ")"

echo "#let kmp_data = ("
for n in $(seq 1000 1000 10000); do
  text=$(printf "%0.sa" $(seq 1 $((n-1))))"b"
  echo "$text" > "$TEXT_FILE"
  kmp_comparisons=$(extract_comparisons "./mainKMP -v text pat")
  echo "  ($n, ${kmp_comparisons/%?/}),"
done
echo ")"
