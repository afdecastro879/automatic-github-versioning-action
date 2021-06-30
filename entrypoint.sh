#!/bin/bash -l

git fetch --unshallow

# Generate tag
ls -l
tag=v$(dotnet-gitversion -output json -showvariable SemVer)

# Create tag in github
if [ "$GITHUB_REF" != "refs/heads/master" ] && [ "$GITHUB_REF" != "refs/heads/main" ]; then
  curl -s -X POST https://api.github.com/repos/$GITHUB_REPOSITORY/git/refs -H "Authorization: token $GITHUB_TOKEN" \
    -d @- <<EOF
{
  "ref": "refs/tags/$tag",
  "sha": "$GITHUB_SHA"
}
EOF
fi

# Create Release
if [ "$GITHUB_REF" = "refs/heads/master" ] || [ "$GITHUB_REF" = "refs/heads/main" ]; then
  content=$(curl -s -X POST https://api.github.com/repos/$GITHUB_REPOSITORY/releases -H "Authorization: token $GITHUB_TOKEN" -d "{\"tag_name\": \"$tag\"}")
  upload_url=$(jq -r '.upload_url' <<< ${content})

  # Delete old alpha tags on release
  numTags=$(git tag -l "*-alpha.*" | wc -l | xargs)
  if [ $numTags -gt 0 ]; then
    git push -d origin $(git tag -l "*-alpha.*")
  fi
fi

echo "::set-output name=tag::$tag"
echo "::set-output name=upload_url::$upload_url"
