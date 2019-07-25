#!/usr/bin/env bats

setup() {
    source src/core.sh
}

@test "enable" {
    bpp-enable TEST

    [ "${BPP_ENABLED[TEST]}" == "1" ]
}


@test "disable" {
    bpp-enable TEST2
    bpp-disable TEST2

    [ "${BPP_ENABLED[TEST2]}" == "0" ]
}

@test "set option" {
    bpp-options TEST BATS_TEST

    [ "${BPP_OPTIONS[TEST]}" == "BATS_TEST" ]
}
