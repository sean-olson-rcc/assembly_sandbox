#! /bin/bash

# Get the make file target passed as a shell argument
OPTION=$1

# Check if an argument was provided
if [ -z "$OPTION" ]; then
    OPTION="help"
fi

echo "You passed: $OPTION"

# Function to detect OS
detect_os() {
    case "$(uname -s)" in
        Linux)
		    make -f makefile_linux $OPTION
            ;;
        Darwin)
            make -f makefile_mac $OPTION
            ;;
        MINGW*|MSYS*) 
			# Git Bash on Windows
			make -f makefile_win64 $OPTION
            ;;
        CYGWIN*)	
			# Cygwin on Windows
		    make -f makefile_win64 $OPTION
            ;;
        *)
            echo "Unknown OS"
            ;;
    esac
}

# Detect the OS and call the appropriate make_file
detect_os
