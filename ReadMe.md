This is a conversion of the x86_toolchhain.sh script to function as a c compiler.
It endeavours to keep most of the original functionalities of the toolchain. 
As such this "new" compiler allows you to use functions such as verbose, break and run
Code and memory movements can be broken down to the level of individual lines
Additional functionalities have been added to automatically output and save files 
containing the code at different compilation stages using the utilities:
	gcc -m64 -O2 -S (Outputs optimized assembly code to a .s file)
	gcc -m64 -S     (Outputs ~assembly code to a .s file)
	gcc -m32 -O2 -S (Outputs optimized assembly code to a .s file(32 bit))
	gcc -m32 -S     (Outputs ~assembly code to a .s file (32 bit))
This will output two files which will be saved locally to the folder containing the
original code. 

File must be connected to $PATH variable (Temporary or permanent):

" export PATH="/___/___/___:$PATH""

Command Line Options:

bash c_toolchain_ext.sh [ options ] <source filename> [-o | --output <output filename>]"

(Must specify bits all other commands optional)

Command example:

bash c_toolchain_ext.sh -v -r -64 <filename.c>

-v | --verbose                Show some information about steps performed.
-g | --gdb                    Run gdb command on executable.
-b | --break <break point>    Add breakpoint after running gdb (break is program sensitive)
-r | --run                    Auto runs the program in gdb
-q | --qemu                   Runs the executable in QEMU emulator. (higher level function incorporation possible)
-64| --m64                    Compiles program in 64bit
-32| --m32		      Compiles program in 32 bit
-o | --o		      Changes the output <filename> 

Diasssembly instructions in gdb (program is beta)
Command: bash c_toolchain_ext.sh -v -g -64 <filename.c>		(-g flag required)
Command: break ____						(main or line)						
Command: disas <disas flag> 					(disassemble)
Command: si							(view line by line)
Command: run							(runs program from start or break)



