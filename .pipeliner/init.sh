#!/bin/bash
set +e

# Import all classes
source $(dirname "${BASH_SOURCE[0]}")/core/utils/files.class.sh
Files_Import_Classes

# Setup prerequisites
Packages_Prerequisites docker

# Import all stages
Files_Import_Stages