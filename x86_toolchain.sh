
#!/bin/bash

# Script information
# Created by Lubos Kuzma
# ISS Program, SADT, SAIT
# August 2022
# Edited By Brian Dang
# Default setting to x64 Architecture
# Added comments explaining each section of the script to enhance readability and understanding.
# Try to add an <Install> option but it seem to not recognize -i.

# Check if there are not enough arguments provided
if [ $# -lt 1 ]; then
    echo "Usage:"
    echo ""
    echo "x86_toolchain.sh [ options ] <assembly filename> [-o | --output <output filename>]"
    echo ""
    echo "-v | --verbose                Show some information about steps performed."
    echo "-g | --gdb                    Run gdb command on executable."
    echo "-b | --break <break point>    Add breakpoint after running gdb. Default is _start."
    echo "-r | --run                    Run program in gdb automatically. Same as run command inside gdb env."
    echo "-q | --qemu                   Run executable in QEMU emulator. This will execute the program."
    echo "-o | --output <filename>      Output filename."
    #echo "-i | --install                install prerequisite for toolchain."
    exit 1
fi

# Initialize variables
POSITIONAL_ARGS=()
GDB=False
OUTPUT_FILE=""
VERBOSE=False
QEMU=False
BREAK="_start"
RUN=False
INSTALL=False

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -g|--gdb)
            GDB=True
            shift # past argument
            ;;
        -o|--output)
            OUTPUT_FILE="$2"
            shift # past argument
            shift # past value
            ;;
        -v|--verbose)
            VERBOSE=True
            shift # past argument
            ;;

        -q|--qemu)
            QEMU=True
            shift # past argument
            ;;
        -r|--run)
            RUN=True
            shift # past argument
            ;;
        -b|--break)
            BREAK="$2"
            shift # past argument
            shift # past value
            ;;
        -*|--*)
            echo "Unknown option $1"
            exit 1
            ;;
        *)
            POSITIONAL_ARGS+=("$1")
            shift # past argument
            ;;
 #       -i|--install)
 #           INSTALL=True
 #           shift # past argument
 #           ;;
    esac
done

# Set positional arguments
set -- "${POSITIONAL_ARGS[@]}"

# Check if the specified file exists
if [[ ! -f $1 ]]; then
    echo "Specified file does not exist"
    exit 1
fi

# Set the output file if not provided
if [ "$OUTPUT_FILE" == "" ]; then
    OUTPUT_FILE=${1%.*}
fi

# Display information if verbose mode is enabled
if [ "$VERBOSE" == "True" ]; then
    echo "Arguments being set:"
    echo "    GDB = ${GDB}"
    echo "    RUN = ${RUN}"
    echo "    BREAK = ${BREAK}"
    echo "    QEMU = ${QEMU}"
    echo "    Input File = $1"
    echo "    Output File = $OUTPUT_FILE"
    echo "    Verbose = $VERBOSE"
    echo "    64 bit mode = $BITS"
    echo ""
    echo "NASM started..."
fi

# Compile the assembly file using NASM
nasm -f elf64 $1 -o $OUTPUT_FILE.o && echo ""

# Display information if verbose mode is enabled
if [ "$VERBOSE" == "True" ]; then
    echo "NASM finished"
    echo "Linking ..."
fi

# Link the object file using the ld linker
ld -m elf_x86_64 $OUTPUT_FILE.o -o $OUTPUT_FILE && echo ""

# Display information if verbose mode is enabled
if [ "$VERBOSE" == "True" ]; then
    echo "Linking finished"
fi

# Run the executable in QEMU if specified
if [ "$QEMU" == "True" ]; then
    echo "Starting QEMU ..."
    echo ""
    qemu-x86_64 $OUTPUT_FILE && echo ""
    exit 0
fi

# Run the GDB debugger if specified
if [ "$GDB" == "True" ]; then
    gdb_params=()
    gdb_params+=(-ex "b ${BREAK}")
    if [ "$RUN" == "True" ]; then
        gdb_params+=(-ex "r")
    fi
    gdb "${gdb_params[@]}" $OUTPUT_FILE
fi
# Run installation script
#if [ "$INSTALL" == "True" ]; then
 #   echo "Starting Prerequisite install..."
  #  bash x86_toolchain_installer.sh
#fi