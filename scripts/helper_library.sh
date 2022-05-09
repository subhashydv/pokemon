#! /bin/bash

function generate_html {
    local tag=$1
    local class=$2
    local content=$3

    if [[ $class != "" ]]
    then
        local class_code=" class=\"$class\""
    fi
    echo "<${tag}${class_code}>${content}</${tag}>"
}
