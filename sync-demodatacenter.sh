#!/bin/bash

folder_from=/root/codeserver_own-patternfly-react/app/build/
folder_to=demo-datacenter
rsync -avz --delete codeserver:${folder_from} ${folder_to}

