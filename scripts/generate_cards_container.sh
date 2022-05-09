
source scripts/helper_library.sh

function get_field {
    cut -d"|" -f$2 <<< "$1"
}

function get_pokemon_name () {
    get_field "$1" 2
}

function get_pokemon_type () {
    get_field "$1" 3
}

function get_weight() {
    get_field "$1" 9
}

function get_base_xp () {
    get_field "$1" 6
}

function get_hp () {
    get_field "$1" 5
}

function get_attack () {
    get_field "$1" 7
}

function get_defense () {
    get_field "$1" 8
}

function get_speed () {
    get_field "$1" 4
}

function capitalize_word () {
    local word="$1"

    local first_letter=$( cut -c1 <<< $word | tr "[:lower:]" "[:upper:]" )
    local trailing_letters=$( cut -c2- <<< $word )

    local capitalized_word="${first_letter}${trailing_letters}"
    echo ${capitalized_word}
}

function generate_pokemon_types () {
    local pokemon_data="$1"
    
    OLDIFS="$IFS"
    IFS=$','
    local pokemon_types=( $( get_pokemon_type "${pokemon_data}" ) )
    IFS=$OLDIFS

    for type in ${pokemon_types[@]}
    do
        local capitalized_type=$( capitalize_word "$type" )
        local categories+=$( generate_html "div" "$type" "$capitalized_type" )
    done
    generate_html "div" "pokemon-type" "${categories}"
}

function generate_traits () {
    local pokemon_data="$1"
    
    local terms=("Weight" "Base XP" "HP" "Attack" "Defence" "Speed")
    local values=($( extract_values "$pokemon_data" ))
    local length=${#terms[@]}    

    local index=0
    while (( $index < $length ))
    do
        local term=$( generate_html "dt" "" "${terms[$index]}")
        local description=$( generate_html "dd" "" "${values[$index]}" )
        local traits+=$( generate_html "div" "trait" "${term}${description}")
        index=$(( $index + 1 ))
    done
    generate_html "dl" "traits" "${traits}"
}

function extract_values () {
    local pokemon_data="$1"
    local values=()
    
    values[0]=$( get_weight ${pokemon_data} )
    values[1]=$( get_base_xp ${pokemon_data} )
    values[2]=$( get_hp ${pokemon_data} )
    values[3]=$( get_attack ${pokemon_data} )
    values[4]=$( get_defense ${pokemon_data} )
    values[5]=$( get_speed ${pokemon_data} )

    echo ${values[@]}
}

function get_filtered_pokemons () {
    local pokemon_data="$1"
    local selected_type="$2"

    local filtered_pokemons=$( grep "^.*|.*|.*$selected_type" <<< "${pokemon_data}" )
    if [[ "$selected_type" == "all" ]]
    then
        filtered_pokemons="${pokemon_data}"
    fi

    echo "${filtered_pokemons}"
}

function generate_pokemon_card () {
    local pokemon_data="$1"
    local card_template="$2"

    local pokemon_name=$( get_pokemon_name "$pokemon_data" )
    local capitalized_name=$( capitalize_word "${pokemon_name}" )
    
    local pokemon_types=$( generate_pokemon_types ${pokemon_data} )
    local pokemon_traits=$( generate_traits "${pokemon_data}" )

    local pokemon_card=$( sed "s,_POKEMON-NAME_,${pokemon_name},g ; 
    s,_CAPITALIZED-POKEMON-NAME_,${capitalized_name}, ;
    s,_POKEMON-TYPES_,${pokemon_types}, ; 
    s,_POKEMON-TRAITS_,${pokemon_traits}," <<< "${card_template}" )
   
    echo ${pokemon_card}
}

function generate_cards_container () {
    local pokemon_records="$1"
    local selected_type="$2"
    local card_template="$3"

    local filtered_pokemons=($(get_filtered_pokemons "$pokemon_records" "$selected_type"))
    
    for pokemon_record in ${filtered_pokemons[@]} 
    do
        local pokemon_cards+=$( generate_pokemon_card "${pokemon_record}" "${card_template}" )
    done

    generate_html "main" "cards-container" "${pokemon_cards}"
}
