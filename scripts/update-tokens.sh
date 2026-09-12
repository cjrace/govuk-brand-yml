#!/usr/bin/env bash
# Overwrites the colour hex values in _brand.yml, and the matching
# hardcoded swatches in index.qmd's showcase, with the latest
# govuk-frontend release's :root tokens. This repo has no automated update
# process - run this by hand, then review the change with `git diff` and
# commit or discard it.
#
# Uses GNU sed syntax (sed -i with no backup suffix) - on macOS, run this
# with GNU sed installed (e.g. `brew install gnu-sed` and use `gsed`)
# rather than the stock BSD sed, which requires a different -i syntax.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
brand_file="$repo_root/_brand.yml"
qmd_file="$repo_root/index.qmd"

version=$(curl -s https://registry.npmjs.org/govuk-frontend/latest | grep -o '"version":"[^"]*"' | cut -d'"' -f4)
echo "Latest govuk-frontend: $version"

css=$(curl -s "https://cdn.jsdelivr.net/npm/govuk-frontend@${version}/dist/govuk/govuk-frontend.min.css")

# Only the leading :root block carries the canonical tokens - component
# rules further down repeat some of the same variable names for other
# purposes (e.g. inverse text on dark backgrounds).
root_block=$(printf '%s' "$css" | grep -o -- ':root{[^}]*}' | head -1)

# _brand.yml palette keys are named after their govuk-frontend CSS custom
# property (minus the `govuk-` prefix), so no key mapping is needed.
keys=(
  brand-colour text-colour secondary-text-colour error-colour
  success-colour focus-colour focus-text-colour link-colour
  link-visited-colour link-hover-colour link-active-colour border-colour
  surface-background-colour surface-border-colour
)

# The subset shown in index.qmd's "Full palette" section as hardcoded
# swatches (the rest are shown there via Bootstrap bg-* utility classes,
# which pick up _brand.yml changes automatically - no separate update
# needed for those).
qmd_keys=(
  text-colour focus-text-colour link-visited-colour link-hover-colour
  link-active-colour border-colour surface-background-colour
  surface-border-colour
)

for key in "${keys[@]}"; do
  value=$(printf '%s' "$root_block" | grep -o -- "--govuk-$key:[^;}]*" | head -1 | cut -d: -f2)
  if [ -z "$value" ]; then
    echo "warning: no token found for $key, leaving as-is" >&2
    continue
  fi
  # Normalise 3-digit hex shorthand (e.g. #fd0) to 6-digit.
  if [[ "$value" =~ ^#([0-9a-fA-F])([0-9a-fA-F])([0-9a-fA-F])$ ]]; then
    value="#${BASH_REMATCH[1]}${BASH_REMATCH[1]}${BASH_REMATCH[2]}${BASH_REMATCH[2]}${BASH_REMATCH[3]}${BASH_REMATCH[3]}"
  fi
  sed -i "s/^\(    $key: \)\"#[0-9a-fA-F]*\"/\1\"$value\"/" "$brand_file"

  if [[ " ${qmd_keys[*]} " == *" $key "* ]]; then
    # Anchored to the swatch's background-color and printed hex label
    # specifically (each swatch also has an unrelated 8-digit
    # `#00000022` border colour on the same line that a bare 6-hex-digit
    # match would partially clobber).
    sed -i "/>$key<br>/ {
      s/background-color:#[0-9a-fA-F]\{6\};/background-color:$value;/
      s/<br>#[0-9a-fA-F]\{6\}</<br>$value</
    }" "$qmd_file"
  fi
done

echo "Updated $brand_file and $qmd_file against govuk-frontend $version - review with: git diff"
