
source scripts/helper_library.sh

function get_class () {
    local pokemon_type="$1"
    local selected_type="$2"
    local class=""

    if [[ $pokemon_type == "$selected_type" ]]
    then
        class="$pokemon_type selected"
    fi
    echo "$class"
}

function generate_list () {
    local pokemon_types=($1)
    local selected_type="$2"
    local list_items=""

    for type in ${pokemon_types[@]}
    do
        local content="<a href=\"$type.html\">$type</a>"
        local class=$( get_class "$type" "$selected_type" )
        list_items+=$( generate_html "li" "$class" "$content" )
    done
    generate_html "ul" "" "${list_items}"
}

function generate_sidebar () {
    local all_types=($1)
    local selected_type="$2"

    local list=$( generate_list "${all_types[*]}" "$selected_type" )
    local sidebar=$( generate_html "nav" "sidebar" "${list}" )
    echo $sidebar 
}
