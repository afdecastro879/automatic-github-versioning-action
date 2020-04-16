#!/bin/sh -l

git fetch --unshallow

# Generate tag
ls -l
tag=v$(dotnet-gitversion -output json -showvariable SemVer)

# Create tag in github
curl -s -X POST https://api.github.com/repos/$GITHUB_REPOSITORY/git/refs -H "Authorization: token $GITHUB_TOKEN" \
  -d @- <<EOF
{
  "ref": "refs/tags/$tag",
  "sha": "$GITHUB_SHA"
}
EOF

# Create Release
if [ "$GITHUB_REF" = "refs/heads/master" ]; then
  curl -s -X POST https://api.github.com/repos/$GITHUB_REPOSITORY/releases -H "Authorization: token $GITHUB_TOKEN" \
    -d @- <<EOF
{
  "tag_name": "$tag"
}
EOF
  # Delete old alpha tags on release
  if [ $(git tag -l "*-alpha.*" | grep -e "*-alpha.*") ]; then
    git push -d origin $(git tag -l "*-alpha.*")
  fi
fi
