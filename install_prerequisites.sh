#Assignment-1
#Syed Nauman Ali Kirmani
#ITSC-204
#Pre-Requirement Installer(NASM, GDB, VS-CODE)



# Function to install dependencies
install_dependencies() {
    echo "Checking and installing dependencies..."

    # Check and install NASM
    if ! command -v nasm &> /dev/null; then
        echo "nasm is not installed. Installing..."
        sudo apt-get install -y nasm
    fi

    # Check and install GDB
    if ! command -v gdb &> /dev/null; then
        echo "gdb is not installed. Installing..."
        sudo apt-get install -y gdb

    fi

    # Check and install Visual Studio Code
    if ! command -v code &> /dev/null; then
        echo "Visual Studio Code is not installed. Installing..."
        cd Downloads  
        chmod 755 /home/kali/Downloads/code_1.83.1-1696982868_amd64.deb 
        sudo dpkg -i code_1.83.1-1696982868_amd64.deb 
        
    fi

    

    echo "Dependencies installed."
}

