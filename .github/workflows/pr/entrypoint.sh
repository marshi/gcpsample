#!/usr/bin/env ash

set -e

if [[ -z "$GITHUB_TOKEN" ]]; then
	echo "Set the GITHUB_TOKEN env variable."
	exit 1
fi

if [[ "$(jq -r ".created" "$GITHUB_EVENT_PATH")" == true ]]; then
	echo "This is a create push branch!"
	exit 0
fi

if [[ "$(jq -r ".head_commit" "$GITHUB_EVENT_PATH")" == "null" ]]; then
	echo "This push has not commits!"
	exit 0
fi

commit_message="$(jq -r ".head_commit.message" "$GITHUB_EVENT_PATH")"

echo "Commit message:"
echo "$commit_message"

REPO_FULLNAME=$(jq -r ".repository.full_name" "$GITHUB_EVENT_PATH")
DEFAULT_BRANCH=$(jq -r ".repository.default_branch" "$GITHUB_EVENT_PATH")
URI=https://api.github.com
PULLS_URI="${URI}/repos/$REPO_FULLNAME/pulls"
AUTH_HEADER="Authorization: token $GITHUB_TOKEN"
TITLE="release to ${DEFAULT_BRANCH}"
BODY= << EOF
this pull request is auto created by github actions.
EOF

new_pr_resp=$(curl --data "{\"title\":\"$TITLE\", \"head\": \"$GITHUB_REF\", \"body\": \"$BODY\", \"draft\": false, \"base\": \"$DEFAULT_BRANCH\"}" -X POST -s -H "${AUTH_HEADER}" ${PULLS_URI})

echo "$new_pr_resp"
echo "created pull request"
