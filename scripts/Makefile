# Makefile for installing the x86 toolchain script in Linux

# Created by Amos Leung
# ISS Program, SADT, SAIT
# October 2023

# ***User may need to input password in order to let the script run***
# Copy "x86_toolchain.sh" to "/usr/local/bin" directory and make it executable
# Update the PATH in the user's shell configuration file
install:
	sudo cp x86_toolchain.sh /usr/local/bin
	sudo chmod +x /usr/local/bin/x86_toolchain.sh
	echo 'export PATH=$$PATH:/usr/local/bin' >> ~/.bashrc
	exec $$SHELL

# Remove "x86_toolchain.sh" from "/usr/local/bin" directory
# "-f" is included to force delete the file without asking for confirmation
# Remove the added PATH in the user's shell configuration file
uninstall:
	sudo rm -f /usr/local/bin/x86_toolchain.sh
	sed -i '/\/usr\/local\/bin/d' ~/.bashrc
	exec $$SHELL
