#!/usr/bin/env bash
basedir=$(pwd)
echo "huh: ${basedir}"

hash_dir () {
  declare -n ret=$1
  local dirhash=""
  local bile="${2}"
  local finalhash=""
  while IFS= read -r line; do
      slam=$(sha256sum "${line}" | cut -d " " -f 1)
      dirhash=$(printf "%s%s" "${dirhash}${slam}")
      finalhash=$(echo -n "${dirhash}" | sha256sum | cut -d " " -f 1)
  done < <(find "${file}" -type f -printf '%h\0%d\0%p\n' | sort -t '\0' -u | awk -F '\0' '{print $3}')
  ret=${finalhash}
}

while IFS= read -r -d '' file; do
  hash_dir realfinal "${file}"
  echo "${realfinal}: ${file}"
done < <(find "${basedir}" -mindepth 1 -maxdepth 1 -type d -not -path '*/\.*' -not -path '*/__*' -print0)
