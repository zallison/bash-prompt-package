#!/usr/bin/env bats

@test "compile source" {
    run make
    [ "$status" == "0" ]
}

@test "load result" {
    run source ./bash-prompt-package.sh
    [ "$status" == "0" ]
}
