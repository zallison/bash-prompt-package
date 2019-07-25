#!/usr/bin/env bats

setup() {
    source src/color.sh
}

@test "color test 1" {
    EXPECTED="\\033[38;5;1m"
    TEST=$(bpp_mk_color 1)

    [ "$EXPECTED" == "$TEST" ]
}

@test "color test 2" {
    EXPECTED="\\033[38;5;23m"
    TEST=$(bpp_mk_color 23)

    [ "$EXPECTED" == "$TEST" ]
}

@test "prompt color test 1" {
    EXPECTED="\\[\\033[38;5;12m\\]"
    TEST=$(bpp_mk_prompt_color 12)

    [ "$EXPECTED" == "$TEST" ]
}

@test "prompt color test 2" {
    EXPECTED="\\[\\033[38;5;48m\\]"
    TEST=$(bpp_mk_prompt_color 48)

    [ "$EXPECTED" == "$TEST" ]
}

