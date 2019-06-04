#!/bin/bash

set -e

source utils.sh

# because... life needs more ASCII art
PRINT_LOGO

#visual breakup
PRINT_LINEBREAK

# Check Status
rlmutil rlmhostid host | tail -n 1
rlmutil rlmhostid | tail -n 1
rlmutil rlmhostid ip | tail -n 1
rlmutil rlmhostid user | tail -n 1

#visual breakup
PRINT_LINEBREAK
echo ""

cd /usr/local/foundry/LicensingTools7.3/
./FoundryLicenseUtility -l /opt/foundry/foundry.lic

#visual breakup
PRINT_LINEBREAK
echo ""
