#! /bin/bash

source tests/assert_expectation.sh
source scripts/generate_website.sh

function test_remove_header () {
    local data="$1"
    local expected_output="$2"
    local test_case="$3"

    local actual_output=$( remove_header "$data" )
    local input="Data: $data"
    assert_expectations "$actual_output" "$expected_output" "$input" "$test_case"
}

function test_get_unique_types () {
    local data="$1"
    local expected_output="$2"
    local test_case="$3"

    local actual_output=($( get_unique_types "$data" ))
    local input="Data: $data"
    assert_expectations "${actual_output[*]}" "$expected_output" "$input" "$test_case"
}

function remove_header_test_cases () {
    echo -e "\n   $bold$FUNCTION_NAME\n"

    local test_case="should remove header of data"
    local data=$( echo -e "id|name|types\n1|bulbasaur|grass,poison" )
    test_remove_header "$data" "1|bulbasaur|grass,poison" "$test_case"
}

function get_unique_types_test_cases () {
    echo -e "\n   $bold$FUNCTION_NAME\n"

    local test_case="should return unique data in sorted order"
    local data=$( echo -e "hello\nhi,good,bye" )
    local expected_output=(bye good hello hi)
    test_get_unique_types "$data" "${expected_output[*]}" "$test_case"
}

function main () {
    FUNCTION_NAME="remove_header"
    remove_header_test_cases

    FUNCTION_NAME="get_unique_types"
    get_unique_types_test_cases

    display_final_results
}

main