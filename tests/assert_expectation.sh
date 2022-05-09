function assert_expectations() {
    local actual=$1
    local expected=$2
    local input=$3
    local test_case="$4"
    local result="$red ✗\033[0m"
    TOTAL_TESTS=$(( $TOTAL_TESTS + 1 ))    

    if [[ "$expected" == "$actual" ]]
    then
        result="$green ✔\033[0m"
    else
        NO_OF_FAILING_TESTS=$(( $NO_OF_FAILING_TESTS + 1 ))
        FAILING_CASES="$FAILING_CASES   $bold${FUNCTION_NAME}\n"
        FAILING_CASES="$FAILING_CASES\t$result $test_case\n"
        FAILING_CASES="$FAILING_CASES\t\t$input \n\t\tExpected: $expected \n\t\tActual: $actual\n"
    fi
    echo -e "\t$result ${test_case}"; 
}

function display_final_results() {
    NO_OF_PASSING_TESTS=$(( $TOTAL_TESTS - $NO_OF_FAILING_TESTS ))

    local pass="$green Pass $NO_OF_PASSING_TESTS"
    local fail="$red Fail $NO_OF_FAILING_TESTS"
    local total="$white Total $TOTAL_TESTS"

    echo -e "\n\n\t$pass:$fail:$total"
    echo -e "\n\n$FAILING_CASES"
}

# color and formatting section

bold="\033[1m"
green="\033[0;32m"
red="\033[0;31m"
white="\033[1;37m"

# initial stats

TOTAL_TESTS=0
NO_OF_FAILING_TESTS=0
NO_OF_PASSING_TESTS=0
FAILING_CASES=""