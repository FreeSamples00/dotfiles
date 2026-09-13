#!/usr/bin/env nu -n

let targets = ["~/Downloads/"]
let time_limit = 30day

$targets | each {
  ls --all --full-paths ($in | path expand)
  | where modified < (date now) - $time_limit
  | par-each { rm --trash $in.name }
}
