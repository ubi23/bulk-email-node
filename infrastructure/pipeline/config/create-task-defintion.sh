#!/usr/bin/env bash
# Creation of task definition for $1 environment
ENV=`echo $1 | tr a-z A-Z` #It gets env name in capital letters
cp infrastructure/pipeline/config/task-definition.json.tmpl task-definition-template-$1.json
  if [ $? -ne 0 ]; then
      echo "There was a problem copying the template for $1 environment"
      exit 2
  fi
# Replacing variables
sed -i 's/<ENV>/'$ENV'/' task-definition-template-$1.json
  if [ $? -ne 0 ]; then
      echo "There was a problem reaplacing variables in template for $1 environment"
      exit 2
  fi
# Now we substitute every environment variable in the task-definition-template.yaml
envsubst < task-definition-template-$1.json > task-definition-$1.json
  if [ $? -ne 0 ]; then
      echo "There was a problem adding values to variables in template for $1 environment"
      exit 2
  fi
# Removing secrets not replaced
sed -i '/"",/d' task-definition-$1.json
  if [ $? -ne 0 ]; then
      echo "There was a problem removing variables not replaced in template for $1 environment"
      exit 2
  fi

echo "Task definition file created for $1 environment"
exit 0