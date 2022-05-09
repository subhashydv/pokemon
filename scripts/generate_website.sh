
source scripts/generate_sidebar.sh
source scripts/generate_cards_container.sh

function remove_header () {
    tail -n+2 <<< "$1"
}

function get_unique_types () {
    local pokemon_data="$1"
    
    local pokemon_types=$( get_pokemon_type  "$pokemon_data" )
    pokemon_types=$( tr "," "\n" <<< "$pokemon_types" | sort | uniq )
    echo $pokemon_types
}

function generate_webpage () {
    local pokemon_data="$1"
    local pokemon_types=($2)
    local selected_type="$3"
    local card_template="$4"

    local sidebar=$( generate_sidebar "${pokemon_types[*]}" "$selected_type" )
    local pokemon_cards=$( generate_cards_container "${pokemon_data}" "$selected_type" "${card_template}")

    local webpage=$( sed "s,_SIDEBAR_,${sidebar}, ; s,_POKEMON-CARDS-CONTAINER_,${pokemon_cards}," <<< "${pokemon_template}" )
    echo ${webpage}
}

function generate_website () {
    local data_file="$1"
    local directory="$2"
    local pokemon_template_file="$3"
    local card_template_file="$4"

    local pokemon_data=$( cat "$data_file" )
    local pokemon_template=$( cat "$pokemon_template_file" )
    local card_template=$( cat "$card_template_file" )
    pokemon_data=$( remove_header "$pokemon_data" )
    
    local pokemon_types=( all $( get_unique_types "$pokemon_data" ))
    
    for type in ${pokemon_types[@]}
    do
        echo "Generating ${type}.html..."
        generate_webpage "${pokemon_data}" "${pokemon_types[*]}" "$type" "${card_template}" > $directory/${type}.html
    done
}