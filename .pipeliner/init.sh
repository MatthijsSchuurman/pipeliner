#!/bin/bash
set +e

# Import all modules
source $(dirname "${BASH_SOURCE[0]}")/core/files.sh
Files_Import_Modules

# Setup prerequisites
Packages_Prerequisites docker