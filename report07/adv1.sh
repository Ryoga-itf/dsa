#!/bin/bash

TEXT_FILE="text"
PAT_FILE="pat"

generate_random_string() {
  local length=$1
  tr -dc 'a-zA-Z' </dev/urandom | head -c $length
}

random_length() {
  local min=$1
  local max=$2
  echo $((RANDOM % (max - min + 1) + min))
}

TEXT_LEN=$(random_length 100 1000)
PAT_LEN=$(random_length 5 20)

TEXT=$(generate_random_string $TEXT_LEN)
PAT=$(generate_random_string $PAT_LEN)

echo "$TEXT" > $TEXT_FILE
echo "$PAT" > $PAT_FILE

echo "Generated text of length $TEXT_LEN in '$TEXT_FILE'"
echo "Generated pat of length $PAT_LEN in '$PAT_FILE'"

extract_comparisons() {
  local command=$1

  $command 2>&1 | grep "# of comparison(s):" | awk '{print $NF}'
}

naive_comparisons=$(extract_comparisons "./mainNaive -v text pat")
kmp_comparisons=$(extract_comparisons "./mainKMP -v text pat")

echo "Comparisons in Naive: $naive_comparisons"
echo "Comparisons in KMP: $kmp_comparisons"
