#! /bin/bash

source tests/assert_expectation.sh
source scripts/generate_cards_container.sh

function test_capitalize_word () {
    local word="$1"
    local expected_output="$2"
    local test_case="$3"

    local actual_output=$( capitalize_word "${word}" )
    local input="Word : ${word}"
    assert_expectations "$actual_output" "$expected_output" "$input" "$test_case"
}

function test_get_field () {
    local pokemon_data="$1"
    local field="$2"
    local expected_output="$3"
    local test_case="$4"

    local actual_output=$( get_field "${pokemon_data}" "${field}" )
    local input="Pokemon data: ${pokemon_data}, Field: ${field}"
    assert_expectations "$actual_output" "$expected_output" "$input" "$test_case"
}

function test_get_pokemon_name () {
    local pokemon_data="$1"
    local expected_output="$2"
    local test_case="$3"

    local actual_output=$( get_pokemon_name "${pokemon_data}" )
    local input="Pokemon data: ${pokemon_data}"
    assert_expectations "$actual_output" "$expected_output" "$input" "$test_case"
}

function test_get_pokemon_type () {
    local pokemon_data="$1"
    local expected_output="$2"
    local test_case="$3"

    local actual_output=$( get_pokemon_type "${pokemon_data}" )
    local input="Pokemon data: ${pokemon_data}"
    assert_expectations "$actual_output" "$expected_output" "$input" "$test_case"
}

function test_generate_pokemon_types () {
    local pokemon_types="$1"
    local expected_output="$2"
    local test_case="$3"

    local actual_output=$( generate_pokemon_types "${pokemon_types}" )
    local input="Pokemon types: ${pokemon_types}"
    assert_expectations "$actual_output" "$expected_output" "$input" "$test_case"
}

function test_generate_traits () {
    local pokemon_data="$1"
    local expected_output="$2"
    local test_case="$3"

    local actual_output=$( generate_traits "$pokemon_data" )
    local input="Pokemon data: $pokemon_data"
    assert_expectations "$actual_output" "$expected_output" "$input" "$test_case"
}

function test_get_filtered_pokemons () {
    local pokemon_data="$1"
    local pokemon_type="$2"
    local expected_output="$3"
    local test_case="$4"

    local actual_output=$( get_filtered_pokemons "$pokemon_data" "$pokemon_type" )
    local input="Pokemon data: $pokemon_data, Pokemon type: $pokemon_type"
    assert_expectations "$actual_output" "$expected_output" "$input" "$test_case"
}

function test_generate_pokemon_card () {
    local pokemon_data="$1"
    local card_template="$2"
    local expected_output="$3"
    local test_case="$4"

    local actual_output=$( generate_pokemon_card "$pokemon_data" "$card_template" )
    local input="Pokemon data: $pokemon_data, Card Template: $card_template"
    assert_expectations "$actual_output" "$expected_output" "$input" "$test_case"
}

function test_generate_cards_container () {
    local pokemon_data="$1"
    local pokemon_type="$2"
    local card_template="$3"
    local expected_output="$4"
    local test_case="$5"

    local actual_output=$( generate_cards_container "$pokemon_data" "$pokemon_type" "$card_template" )
    local input="Pokemon data: $pokemon_data, Pokemon Type: $pokemon_type, Card Template: $card_template"
    assert_expectations "$actual_output" "$expected_output" "$input" "$test_case"
}

function capitalize_word_test_cases () {
    echo -e "\n   $bold$FUNCTION_NAME\n"

    local test_case="should capitalize given word"
    test_capitalize_word "hello" "Hello" "${test_case}"
}

function get_field_test_cases () {
    echo -e "\n   $bold$FUNCTION_NAME\n"
    
    local test_case="should return the given field data"
    test_get_field "hello|hi" "1" "hello" "${test_case}"

    test_case="should return null if field doesn't exist" 
    test_get_field "hello|hi" "3" "" "${test_case}"
}

function get_pokemon_name_test_cases () {
    echo -e "\n   $bold$FUNCTION_NAME\n"
    
    local test_case="should return the pokemon name"
    test_get_pokemon_name "1|bulbasaur" "bulbasaur" "${test_case}"
}

function get_pokemon_type_test_cases () {
    echo -e "\n   $bold$FUNCTION_NAME\n"
    
    local test_case="should return the pokemon type"
    test_get_pokemon_type "1|bulbasaur|grass" "grass" "${test_case}"
    
    test_case="should return multiple pokemon type"
    test_get_pokemon_type "1|bulbasaur|grass,poison" "grass,poison" "${test_case}"
}

function generate_pokemon_types_test_cases () {
    echo -e "\n   $bold$FUNCTION_NAME\n"
    
    local test_case="should generate single pokemon type"
    local expected_output="<div class=\"pokemon-type\"><div class=\"grass\">Grass</div></div>"
    test_generate_pokemon_types "1|hello|grass|54" "${expected_output}" "${test_case}"
    
    test_case="should generate multiple pokemon type"
    expected_output="<div class=\"pokemon-type\"><div class=\"grass\">Grass</div><div class=\"poison\">Poison</div></div>"
    test_generate_pokemon_types "1|pikachu|grass,poison|79" "${expected_output}" "${test_case}"
}

function generate_traits_test_cases () {
    echo -e "\n   $bold$FUNCTION_NAME\n"

    local test_case="should generate traits list"
    local expected_output="<dl class=\"traits\"><div class=\"trait\"><dt>Weight</dt><dd>69</dd></div><div class=\"trait\"><dt>Base XP</dt><dd>64</dd></div><div class=\"trait\"><dt>HP</dt><dd>45</dd></div><div class=\"trait\"><dt>Attack</dt><dd>49</dd></div><div class=\"trait\"><dt>Defence</dt><dd>49</dd></div><div class=\"trait\"><dt>Speed</dt><dd>45</dd></div></dl>"
    test_generate_traits "1|bulbasaur|grass,poison|45|45|64|49|49|69" "$expected_output" "$test_case"
}

function get_filtered_pokemons_test_cases () {
    echo -e "\n   $bold$FUNCTION_NAME\n"

    local test_case="should filter data based on given filter"
    local pokemon_data=$( echo -e "1|bulbasaur|grass,poison|45|45|64|49|49|69\n2|charmeleon|fire|80|58|142|64|58|190" )
    local expected_output="1|bulbasaur|grass,poison|45|45|64|49|49|69"
    test_get_filtered_pokemons "$pokemon_data" "grass" "$expected_output" "$test_case"
}

function generate_pokemon_card_test_cases () {
    echo -e "\n   $bold$FUNCTION_NAME\n"

    local test_case="should generate pokemon card"
    local pokemon_data="1|bulbasaur|grass,poison|45|45|64|49|49|69"
    local card_template="`cat resources/templates/card_template.html`"
    local expected_output="<article class=\"pokemon-card\"> <figure class=\"pokemon-img\"> <img src=\"images/bulbasaur.png\" alt=\"bulbasaur\" title=\"bulbasaur\" /> </figure> <section class=\"main-content\"> <header> <h2>Bulbasaur</h2> <div class=\"pokemon-type\"><div class=\"grass\">Grass</div><div class=\"poison\">Poison</div></div> </header> <dl class=\"traits\"> <dl class=\"traits\"><div class=\"trait\"><dt>Weight</dt><dd>69</dd></div><div class=\"trait\"><dt>Base XP</dt><dd>64</dd></div><div class=\"trait\"><dt>HP</dt><dd>45</dd></div><div class=\"trait\"><dt>Attack</dt><dd>49</dd></div><div class=\"trait\"><dt>Defence</dt><dd>49</dd></div><div class=\"trait\"><dt>Speed</dt><dd>45</dd></div></dl> </dl> </section> </article>"
    
    test_generate_pokemon_card "$pokemon_data" "$card_template" "$expected_output" "$test_case" 
}

function generate_cards_container_test_cases () {
    echo -e "\n   $bold$FUNCTION_NAME\n"
    
    local test_case="should generate container of pokemon cards"
    local pokemon_data="2|ivysaur|grass|60|60|142|62|63|130"
    local card_template="`cat resources/templates/card_template.html`"
    local expected_output="<main class=\"cards-container\"><article class=\"pokemon-card\"> <figure class=\"pokemon-img\"> <img src=\"images/ivysaur.png\" alt=\"ivysaur\" title=\"ivysaur\" /> </figure> <section class=\"main-content\"> <header> <h2>Ivysaur</h2> <div class=\"pokemon-type\"><div class=\"grass\">Grass</div></div> </header> <dl class=\"traits\"> <dl class=\"traits\"><div class=\"trait\"><dt>Weight</dt><dd>130</dd></div><div class=\"trait\"><dt>Base XP</dt><dd>142</dd></div><div class=\"trait\"><dt>HP</dt><dd>60</dd></div><div class=\"trait\"><dt>Attack</dt><dd>62</dd></div><div class=\"trait\"><dt>Defence</dt><dd>63</dd></div><div class=\"trait\"><dt>Speed</dt><dd>60</dd></div></dl> </dl> </section> </article></main>"

    test_generate_cards_container "$pokemon_data" "grass" "$card_template" "$expected_output" "$test_case"
}

function main () {
    FUNCTION_NAME="capitalize_word"
    capitalize_word_test_cases

    FUNCTION_NAME="get_field"
    get_field_test_cases

    FUNCTION_NAME="get_pokemon_name"
    get_pokemon_name_test_cases

    FUNCTION_NAME="get_pokemon_type"
    get_pokemon_type_test_cases

    FUNCTION_NAME="generate_pokemon_types"
    generate_pokemon_types_test_cases

    FUNCTION_NAME="generate_traits"
    generate_traits_test_cases

    FUNCTION_NAME="get_filtered_pokemons"
    get_filtered_pokemons_test_cases

    FUNCTION_NAME="generate_pokemon_card"
    generate_pokemon_card_test_cases

    FUNCTION_NAME="generate_cards_container"
    generate_cards_container_test_cases

    display_final_results
}

main