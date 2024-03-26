#!/bin/bash
set +e

# Import all classes
source $(dirname "${BASH_SOURCE[0]}")/core/files.class.sh
Files_Import_Classes

# Setup prerequisites
Packages_Prerequisites docker