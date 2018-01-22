#!/usr/bin/env bats

@test 'virtualbox-5.2 is installed' {
  run test "rpm -q Virtualbox-5.2 || dpkg-query -s virtualbox-5.2"
  [ "$status" -eq 0 ]
}
