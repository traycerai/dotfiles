#!/usr/bin/env bash
#
# Call sync script based on the GitHub organizations the user belongs to:
# If user belongs to FluxNinja, sync FluxNinja repos.
# If user belongs to Traycer, sync Traycer repos.

# Get list of organizations the user belongs to
orgs=$(gh api user/orgs | jq -r '.[].login')

# Loop through the organizations
for org in $orgs; do
	if [ "$org" == "fluxninja" ]; then
		echo "Syncing FluxNinja repos..."
		# Call FluxNinja sync script
		"$HOME"/sw/bin/sync_fluxninja.sh
	elif [ "$org" == "traycerai" ]; then
		echo "Syncing Traycer repos..."
		# Call Traycer sync script
		"$HOME"/sw/bin/sync_traycer.sh
	else
		echo "No sync script available for the organization: $org"
	fi
done
