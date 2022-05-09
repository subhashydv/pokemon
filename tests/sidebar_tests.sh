#! /bin/bash

source tests/assert_expectation.sh
source scripts/generate_sidebar.sh

function test_generate_html() {
    local tag="$1"
    local class="$2"
    local content="$3"
    local expected_output="$4"
    local test_case="$5"

    local actual_output=$( generate_html "$tag" "$class" "$content" )
    local input="Tag: $tag, Class: $class, content: $content"
    assert_expectations "$actual_output" "$expected_output" "$input" "$test_case"
}

function test_generate_list() {
    local pokemon_types="$1"
    local selected_type="$2"
    local expected_output="$3"
    local test_case="$4"

    local actual_output=$( generate_list "$pokemon_types" "$selected_type" )

    local input="Pokemon Types: $pokemon_types, Selected Type: $selected_type"
    assert_expectations "$actual_output" "$expected_output" "$input" "$test_case"
}

function test_get_classs () {
    local pokemon_type="$1"
    local selected_type="$2"
    local expected_output="$3"
    local test_case="$4"

    local actual_output=$( get_class "$pokemon_type" "$selected_type" )

    local input="Pokemon Type: $pokemon_type, Selected type: $selected_type"
    assert_expectations "$actual_output" "$expected_output" "$input" "$test_case"
}

function test_generate_sidebar () {
    local all_types="$1"
    local selected_type="$2"
    local expected_output="$3"
    local test_case="$4"

    local actual_output=$( generate_sidebar "${all_types}" "${selected_type}" )

    local input="All types: ${all_types}, Selected type: ${selected_type}"
    assert_expectations "$actual_output" "$expected_output" "$input" "$test_case"
}

function generate_html_test_cases () {
    echo -e "\n   $bold$FUNCTION_NAME\n"

    local test_case="should wrap content in given tag with class"
    test_generate_html "div" "card" "hello" "<div class=\"card\">hello</div>" "$test_case"
    
    test_case="should wrap content in given tag without class"
    test_generate_html "li" "" "hii" "<li>hii</li>" "$test_case"
}

function generate_list_test_cases () {
    echo -e "\n   $bold$FUNCTION_NAME\n"

    local test_case="should generate a list with single item"
    local expected_output="<ul><li><a href=\"grass.html\">grass</a></li></ul>"
    test_generate_list "grass" "poison" "$expected_output" "$test_case"

    test_case="should generate a list with applied class on a item"
    local expected_output="<ul><li><a href=\"grass.html\">grass</a></li><li class=\"poison selected\"><a href=\"poison.html\">poison</a></li></ul>"
    test_generate_list "grass poison" "poison" "$expected_output" "$test_case"

}

function get_class_test_cases () {
    echo -e "\n   $bold$FUNCTION_NAME\n"

    local test_case="should return class name"
    test_get_classs "grass" "grass" "grass selected" "$test_case"
    
    local test_case="should return null"
    test_get_classs "grass" "poison" "" "$test_case"
}

function generate_sidebar_test_cases () {
    echo -e "\n   $bold$FUNCTION_NAME\n"

    local test_case="should generate sidebar for single item"
    local expected_output="<nav class=\"sidebar\"><ul><li class=\"grass selected\"><a href=\"grass.html\">grass</a></li></ul></nav>"
    test_generate_sidebar "grass" "grass" "${expected_output}" "${test_case}"
    
    local test_case="should generate sidebar for multiple item"
    local item1="<li class=\"grass selected\"><a href=\"grass.html\">grass</a></li>"
    local item2="<li><a href=\"poison.html\">poison</a></li>"
    local expected_output="<nav class=\"sidebar\"><ul>${item1}${item2}</ul></nav>"
    test_generate_sidebar "grass poison" "grass" "${expected_output}" "${test_case}"
}

function main () {

    FUNCTION_NAME="generate_html"
    generate_html_test_cases

    FUNCTION_NAME="generate_list"
    generate_list_test_cases

    FUNCTION_NAME="get_class"
    get_class_test_cases

    FUNCTION_NAME="generate_sidebar"
    generate_sidebar_test_cases

    display_final_results
}

main