#!/usr/bin/env bash
# Check the images scan results for vulnerabilities.
# Tries 3 times with a sleep then gives up.

i=0
while [ "$i" -lt 3 ]
  do
    SCAN_RESULTS=$( aws ecr describe-image-scan-findings --repository-name $1 --image-id imageTag=$2 --region eu-west-2 )
    SCAN_STATUS=$( jq '.imageScanStatus.status' -r <<< $SCAN_RESULTS )
    if [[ $SCAN_STATUS == "COMPLETE" ]] ; then
      echo "SCAN Complete"
      SCAN_FINDINGS=$( jq '.imageScanFindings' -r <<< $SCAN_RESULTS )
      FINDINGS_URI=$( jq '.findings[].uri' <<< $SCAN_FINDINGS )
      SEVERITY_COUNT=$( jq '.findingSeverityCounts' -c <<< $SCAN_FINDINGS )
      if [[ -z "$SEVERITY_COUNT" || "$SEVERITY_COUNT" == "null" || "$SEVERITY_COUNT" == "{}" ]]; then
        echo "No vulnerabilities found"
      else
        echo -e "Vulnerabilities found:\n$SEVERITY_COUNT"
        echo "Vulnerability list details:"
        echo -e "$FINDINGS_URI \n"
        echo -e "It is required to resolve the vulnerabilities as soon as possible \n"
        HIGH_SEVERITY=`echo $SEVERITY_COUNT | grep -E "CRITICAL|HIGH"`
        if [[ -z "$HIGH_SEVERITY" || "$HIGH_SEVERITY" == "null" ]]; then
          exit 0
        else
          echo -e "There is at least one CRITICAL|HIGH vulnerability and the build process will be stopped with error \n"
          exit 2
        fi
      fi
      break
    else
        sleep 10
        ((i=i+1)) 
    fi
done