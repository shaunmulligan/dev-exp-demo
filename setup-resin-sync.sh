#!/bin/bash

# Restarting the application re-fetches the current
# commit, therefore discards changes we make to /app
# directly.
# This workaround saves the changes to /data/.resin-watch
# and merges those changes to /app in each restart

# Base on awesome script here: https://gist.github.com/cjus/1047794
extract_json_value() {
	# key
	key=$1
	# number of value we want to get if it's multiple value
	num=$2
	awk -F"[,:}]" '{for(i=1;i<=NF;i++){if($i~/'$key'\042/){print $(i+1)}}}' | tr -d '"' | sed -n ${num}p
}

if [ -f /data/commit ]; then
	mkdir -p /data/.resin-watch

	CURRENT_COMMIT=$(curl -s -X GET --header "Content-Type:application/json" "$RESIN_SUPERVISOR_ADDRESS/v1/device?apikey=$RESIN_SUPERVISOR_API_KEY" | extract_json_value 'commit')
	read -r PREV_COMMIT</data/commit

	#Only copy if the commit hash is the same since the last time we restarted
	if [ "$CURRENT_COMMIT" == "$PREV_COMMIT" ]; then
		echo "commit is the same...copying src"
		cp -rf /data/.resin-watch/* /usr/src/app/
	else
		#If the commit is different, then we probaby pushed, so dont copy, but just update the commit hash file.
		curl -s -X GET --header "Content-Type:application/json" "$RESIN_SUPERVISOR_ADDRESS/v1/device?apikey=$RESIN_SUPERVISOR_API_KEY" | extract_json_value 'commit' > /data/commit
	fi
else
	echo "commit file doesnt exist yet"
	curl -s -X GET --header "Content-Type:application/json" "$RESIN_SUPERVISOR_ADDRESS/v1/device?apikey=$RESIN_SUPERVISOR_API_KEY" | extract_json_value 'commit' > /data/commit
fi


GREEN='\033[0;32m'
echo -e "${GREEN}Sync mode enabled."
