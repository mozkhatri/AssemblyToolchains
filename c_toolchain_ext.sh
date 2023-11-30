#!/bin/bash
# Created by Lubos Kuzma
# Modified by Patrick Donovan
# ISS Program, SADT, SAIT
# August 2022 (November 2023)

#******************************************************
#This toolchain has been altered to parse .c files
#It endeavours to keep most of the functionality of the 
#original toolchain. As it was created for primarily 
#assembly users, Additional outputs showing assembly
#stages of compilation have been added. 
#******************************************************

#The section below parses the input string against the command line arguments list
#to determine what actions will be performed. 
if [ $# -lt 1 ]; then 
    echo "Usage:"
    echo ""
    echo "c_toolchain_ext.sh [ options ] <source filename> [-o | --output <output filename>]"
    echo ""
    echo "-v | --verbose                Show some information about steps performed."
    echo "-g | --gdb                    Run gdb command on executable."
    echo "-b | --break <break point>    Add breakpoint after running gdb. Default is _start."
    echo "-r | --run                    Run program in gdb automatically. Same as run command inside gdb env."
    echo "-q | --qemu                   Run executable in QEMU emulator. This will execute the program."
    echo "-64| --m64                    Compile for 64bit (x86-64) system."
    echo "-o | --output <filename>      Output filename."
    echo ""
    echo "Additional Commands:"
    echo "-O2 -S <source file>          Creates a file containing optimized, less space hungry, assembly code"
    echo "-S <source file>              Creates a file containing assembly code"
    exit 1

fi

POSITIONAL_ARGS=()
GDB=False
OUTPUT_FILE=""
VERBOSE=False
BITS=False
QEMU=False
BREAK="_start"
RUN=False

#This section remains essentially unchanged.
#Some of these functions are not necessary at all times but utile for future development(eg. qemu)

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
        -64)
            BITS=True
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
        -O2|-S)     #This section is altered for GCC processing/output
            shift # past argument
            COMMAND="$1"
            shift # past value
            SOURCE_FILE="$1"
            shift # past source file
            OUTPUT=$(basename "$SOURCE_FILE" .c).txt
            gcc $COMMAND "$SOURCE_FILE" -o "$OUTPUT" && echo "Output written to $OUTPUT"
            ;;
        -*) 
            echo "Unknown option $1"
            exit 1
            ;;
        *)
            POSITIONAL_ARGS+=("$1") # Saves the positional argument
            shift # past argument
            ;;
    esac
done

#This section resets the positional arguments

set -- "${POSITIONAL_ARGS[@]}"

#This checks to confirm a file was input in a format understood by the program.

if [[ ! -f $1 || ${1##*.} != "c" ]]; then

	echo "Specified file does not exist"
	exit 1
fi

if [ "$OUTPUT_FILE" == "" ]; then
	OUTPUT_FILE=${1%.*}
fi

#The verbose section remains the same except for output

if [ "$VERBOSE" == "True" ]; then
	echo "Arguments being set:"
	echo "	GDB = ${GDB}"
	echo "	RUN = ${RUN}"
	echo "	BREAK = ${BREAK}"
	echo "	QEMU = ${QEMU}"
	echo "	Input File = $1"
	echo "	Output File = $OUTPUT_FILE"
	echo "	Verbose = $VERBOSE"
	echo "	64 bit mode = $BITS" 
	echo ""

	echo "GCC started..."

fi

#This section has been added to output 64 or 32 bit code, to two separate files.
#Upon the creation of the files it alerts the user. Files will be stored locally and labeled
#According to input file name. Files contain optimized assembly code and regular assembly code.

if [ "$BITS" == "True" ]; then

    gcc -m64 -o "$OUTPUT_FILE" "$1" && echo ""
    gcc -m64 -O2 -S "$1" -o "${OUTPUT_FILE}_optimized.s" && echo "Optimized assembly code written to ${OUTPUT_FILE}_optimized.s"
    gcc -m64 -S "$1" -o "${OUTPUT_FILE}_regular.s" && echo "Regular assembly code written to ${OUTPUT_FILE}_regular.s"

elif [ "$BITS" == "False" ]; then

    gcc -m32 -o "$OUTPUT_FILE" "$1" && echo ""
    gcc -m32 -O2 -S "$1" -o "${OUTPUT_FILE}_optimized.s" && echo "Optimized assembly code written to ${OUTPUT_FILE}_optimized.s"
    gcc -m32 -S "$1" -o "${OUTPUT_FILE}_regular.s" && echo "Regular assembly code written to ${OUTPUT_FILE}_regular.s"

fi

#The breakpoint function of GDB does not adapt directly to parsing .c files
#To keep the breakpoint function this section of code has been added
#The gdb commands break and run are placed in a temporary file until GCC compilation has been completed
#Result: GDB runs mostly normally after GCC compilation

if [ "$GDB" == "True" ]; then

    gdb_commands_file="gdb_commands"
    echo "file $OUTPUT_FILE" > $gdb_commands_file
   
    if [ "$BREAK" != "_start" ]; then

        echo "break $BREAK" >> $gdb_commands_file

    fi

    if [ "$RUN" == "True" ]; then

        echo "run" >> $gdb_commands_file

    fi

    gdb -x $gdb_commands_file
    rm $gdb_commands_file
fi

#Exit sequence has been altered very little.

if [ "$VERBOSE" == "True" ]; then

	echo "GCC finished"
	echo "Linking finished"

fi
