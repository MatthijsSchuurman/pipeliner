#!/bin/bash

# Import all classes
source $(dirname "${BASH_SOURCE[0]}")/core/utils/files.class.sh
Files_Import_Classes

# Setup prerequisites
Docker_Install

# Import all stages
Files_Import_Stages