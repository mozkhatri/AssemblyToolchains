# Assignment-1
# Syed Nauman Ali Kirmani
# ITSC-204
# Updated with following changes by Mozammil Khatri:
#	-Installer now runs a sudo apt-get update before executing the rest of the code.
#	-Installer now outputs a message after successful or failed installation. Including a version check along with print-out of currently installed version.
#	-Installer handles the download of Visual Studio Code in a more dynamic way without a specific path which may not be available on all systems. It now fetches the latest version directly from Microsoft.
#
# Pre-Requirement Installer(NASM, GDB, VS-CODE)

# Function to install dependencies
install_dependencies() {
    echo "Checking and installing dependencies..."
    sudo apt-get update # Ensure the package lists are up to date

    # Check and install NASM
    if ! command -v nasm &> /dev/null; then
        echo "NASM is not installed. Installing..."
        sudo apt-get install -y nasm
        # Verify installation and print version
        if command -v nasm &> /dev/null; then
            echo "NASM successfully installed, version: $(nasm -v)"
        else
            echo "NASM installation failed."
        fi
    else
        echo "NASM already installed, version: $(nasm -v)"
    fi

    # Check and install GDB
    if ! command -v gdb &> /dev/null; then
        echo "GDB is not installed. Installing..."
        sudo apt-get install -y gdb
        # Verify installation and print version
        if command -v gdb &> /dev/null; then
            echo "GDB successfully installed, version: $(gdb --version)"
        else
            echo "GDB installation failed."
        fi
    else
        echo "GDB already installed, version: $(gdb --version)"
    fi

    # Check and install Visual Studio Code
    if ! command -v code &> /dev/null; then
        echo "Visual Studio Code is not installed. Installing..."
        # Attempt to retrieve the latest version of Visual Studio Code package
        wget -O vscode.deb https://go.microsoft.com/fwlink/?LinkID=760868
        if [ -f vscode.deb ]; then
            sudo dpkg -i vscode.deb
            sudo apt-get install -f # Fix any installation dependencies
            rm vscode.deb # Clean up the downloaded package
        else
            echo "Failed to download Visual Studio Code package."
        fi
    else
        echo "Visual Studio Code already installed, version: $(code --version)"
    fi

    echo "Dependencies installation process completed."
}

# Run the installation function
install_dependencies
