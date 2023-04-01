#!/bin/bash
PROJECT_DIR="$(dirname "$0")"

echo "Installing dependencies..."
while read DEPENDENCY
do
    if [ "$DEPENDENCY" == "" ]; then continue; fi

    DEPENDENCY=$(echo "$DEPENDENCY" | sed -e 's/\s*#.*$//')

    LABEL=$(echo "$DEPENDENCY" | awk '{print $1}')
    LOCAL_SUBDIR=$(echo "$DEPENDENCY" | awk '{print $2}')
    REPO_URL=$(echo "$DEPENDENCY" | awk '{print $3}')
    COMMIT_REF=$(echo "$DEPENDENCY" | awk '{print $4}')

    echo "$LABEL..."

    if [ ! -d "$PROJECT_DIR/$LOCAL_SUBDIR" ]
    then
        mkdir -p "$PROJECT_DIR/$LOCAL_SUBDIR" || exit 2
    fi

    if [ ! -d "$PROJECT_DIR/$LOCAL_SUBDIR/.git" ]
    then
        git clone "$REPO_URL" "$PROJECT_DIR/$LOCAL_SUBDIR" || exit 1
    fi

    (
        cd "$PROJECT_DIR/$LOCAL_SUBDIR"
        git fetch --all
        git checkout "$COMMIT_REF"
    )
done < "$PROJECT_DIR/dependencies"
