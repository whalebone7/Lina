#!/bin/bash

usage() {
  echo "Usage: lin.sh [-u target.com] | [-l path/to/subdomains.txt]"
}

print_light_sky_blue() {
  tput setaf 153  
  echo "$1"
  tput sgr0  
}

cleanup() {
  rm -f urls.txt
}

print_light_sky_blue " _      _              "
print_light_sky_blue "| |    (_)             "
print_light_sky_blue "| |     _ _ __   __ _  "
print_light_sky_blue "| |    | | '_ \ / _\` | "
print_light_sky_blue "| |____| | | | | (_| | "
print_light_sky_blue "|______|_|_| |_|\__,_| "
echo

process_target() {
  echo "$1" | waybackurls > urls.txt
  grep -E -o '[?&][^=]+' urls.txt | sed 's/[?&]//g' | awk -F '=' '{print $1}' | sort -u > params.txt
  echo "Parameters extracted and stored in params.txt:"
  echo ""
  cat params.txt
}

process_file() {
  cat "$1" | waybackurls > urls.txt
  grep -E -o '[?&][^=]+' urls.txt | sed 's/[?&]//g' | awk -F '=' '{print $1}' | sort -u > params.txt
  echo "Parameters extracted and stored in params.txt:"
  echo ""
  cat params.txt
}

if [ $# -eq 2 ]; then
  while getopts "u:l:" flag; do
    case "$flag" in
      u)
        target="$OPTARG"
        process_target "$target"
        ;;
      l)
        file="$OPTARG"
        process_file "$file"
        ;;
      *)
        usage
        exit 1
        ;;
    esac
  done
else
  usage
  exit 1
fi

cleanup
