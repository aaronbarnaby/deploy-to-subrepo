#!/bin/sh

set -e
set -x

if [ -z "$INPUT_SOURCE" ]
then
  echo "No Source defined"
  return 1
fi

## Handle Loading Defaults
if [ -z "$INPUT_TARGET_BRANCH" ]
then
  INPUT_TARGET_BRANCH=main
fi

if [ -z "$INPUT_COMMIT_EMAIL" ]
then
  INPUT_COMMIT_EMAIL="actions@github.com"
fi

if [ -z "$INPUT_COMMIT_NAME" ]
then
  INPUT_COMMIT_NAME="githubactions"
fi

if [ -z "$INPUT_COMMIT_MESSAGE" ]
then
  INPUT_COMMIT_MESSAGE="Update from https://github.com/${GITHUB_REPOSITORY}/commit/${GITHUB_SHA}"
fi

OUTPUT_BRANCH="$INPUT_TARGET_BRANCH"
CLONE_DIR=$(mktemp -d)

echo "Cloning Target Git Repo"
git config --global user.email "$INPUT_COMMIT_EMAIL"
git config --global user.name "$INPUT_COMMIT_NAME"
git clone --single-branch --branch $INPUT_DESTINATION_BRANCH "https://x-access-token:$API_TOKEN@github.com/$INPUT_TARGET_REPO.git" "$CLONE_DIR"

DEST_COPY="$CLONE_DIR/$INPUT_TARGET_FOLDER"

echo "Copying Source to Git Repo"
mkdir -p $DEST_COPY
cp -R "$INPUT_SOURCE" "$DEST_COPY"

cd "$CLONE_DIR"

echo "Adding Git Commit"
git add .
if git status | grep -q "Changes to be committed"
then
  git commit --message "$INPUT_COMMIT_MESSAGE"
  echo "Pushing Git Commit"
  git push -u origin HEAD:"$OUTPUT_BRANCH"
else
  echo "No changes detected"
fi
