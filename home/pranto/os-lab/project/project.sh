#!/bin/bash

# Function to display the main menu
display_menu() {
    clear
    echo "OS Assistant - Main Menu"
    echo "1. Task Manager"
    echo "2. File Organizer"
    echo "3. System Monitor"
    echo "4. Backup"
    echo "5. Password Manager"
    echo "6. Network Utilities"
    echo "7. Text Manipulation"
    echo "8. Package Management"
    echo "9. Remote Access"
    echo "10. User Management"
    echo "11. System Maintenance"
    echo "12. Software Installation"
    echo "13. Disk Management"
    echo "14. System Information"
    echo "15. Exit"
}

# Function for task manager
task_manager() {
    while true; do
        clear
        echo "Task Manager"
        echo "1. View all tasks"
        echo "2. Sort tasks by CPU usage"
        echo "3. Sort tasks by memory usage"
        echo "4. Filter tasks by user"
        echo "5. Filter tasks by process name"
        echo "6. Kill a task"
        echo "7. Return to the main menu"
        
        read -p "Enter your choice (1-7): " choice
        case $choice in
            1) ps aux ;;
            2) ps aux --sort=-%cpu ;;
            3) ps aux --sort=-%mem ;;
            4) read -p "Enter username to filter tasks: " username
               ps aux | grep "$username" ;;
            5) read -p "Enter process name to filter tasks: " process_name
               ps aux | grep "$process_name" ;;
            6) read -p "Enter PID of the task to kill: " pid
               kill -9 "$pid" ;;
            7) return ;;
            *) echo "Invalid choice. Please enter a number between 1 and 7." ;;
        esac
        
        read -p "Press enter to continue." choice
    done
}

# Function for file organizer
file_organizer() {
    clear
    echo "File Organizer"
    
    # Prompt the user for the folder to organize
    read -p "Enter the folder to organize (press enter for current directory): " folder
    folder=${folder:-$(pwd)}  # If no folder is entered, use the current directory
    
    # Check if the entered folder exists
    if [ ! -d "$folder" ]; then
        echo "Folder '$folder' does not exist."
        read -p "Press enter to return to the main menu." choice
        return
    fi
    
    # Display the current folder
    echo "Current folder: $folder"
    
    # List all folders in the current folder
    echo "Folders in $folder:"
    ls -l -d "$folder"/*/ | awk '{print NR".",$NF}'
    
    # Provide options for file management
    echo
    echo "Select an option for file management:"
    echo "1. Move files"
    echo "2. Copy files"
    echo "3. Rename files"
    echo "4. Delete files"
    echo "5. Sort files"
    echo "6. Add new folder"
    echo "7. Add new file"
    echo "8. Cancel and return to the main menu"
    
    read -p "Enter your choice (1-8): " choice
    case $choice in
        1) move_files "$folder" ;;
        2) copy_files "$folder" ;;
        3) rename_files "$folder" ;;
        4) delete_files "$folder" ;;
        5) sort_files "$folder" ;;
        6) add_new_folder "$folder" ;;
        7) add_new_file "$folder" ;;
        8) return ;;
        *) echo "Invalid choice. Please enter a number between 1 and 8." ;;
    esac
}

# Function to add a new folder
add_new_folder() {
    folder="$1"
    
    # Prompt the user for the new folder name
    read -p "Enter the name of the new folder: " new_folder_name
    
    # Create the new folder
    mkdir "$folder/$new_folder_name"
    
    echo "New folder '$new_folder_name' has been created."
    read -p "Press enter to return to the main menu." choice
}

# Function to add a new file
add_new_file() {
    folder="$1"
    
    # Prompt the user for the new file name
    read -p "Enter the name of the new file: " new_file_name
    
    # Create an empty file
    touch "$folder/$new_file_name"
    
    echo "New file '$new_file_name' has been created."
    read -p "Press enter to return to the main menu." choice
}



# Function to move files
# Function to move files
move_files() {
    source_folder="$1"
    
    # Prompt the user for the destination folder
    read -p "Enter the destination folder to move files to: " destination_folder
    
    # Check if the destination folder exists
    if [ ! -d "$destination_folder" ]; then
        echo "Destination folder '$destination_folder' does not exist."
        read -p "Press enter to return to the main menu." choice
        return
    fi
    
    # Prompt the user to enter the file(s) to move
    read -p "Enter the file(s) to move (use space to separate multiple files): " files_to_move
    
    # Move the specified files to the destination folder
    mv $files_to_move "$destination_folder"/
    
    echo "Files have been moved to '$destination_folder'."
    read -p "Press enter to return to the main menu." choice
}



# Function to copy files
copy_files() {
    source_folder="$1"
    
    # Prompt the user for the destination folder
    read -p "Enter the destination folder to copy files to: " destination_folder
    
    # Check if the destination folder input is empty
    if [ -z "$destination_folder" ]; then
        echo "Destination folder cannot be empty."
        read -p "Press enter to return to the main menu." choice
        return
    fi
    
    # Trim leading and trailing whitespace from the destination folder path
    destination_folder="$(echo -e "$destination_folder" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
    
    # Check if the destination folder exists
    if [ ! -d "$destination_folder" ]; then
        echo "Destination folder '$destination_folder' does not exist."
        read -p "Press enter to return to the main menu." choice
        return
    fi
    
    # Prompt the user to enter the file(s) to copy
    read -p "Enter the file(s) to copy (use space to separate multiple files): " files_to_copy
    
    # Check if the input is a directory
    if [ -d "$files_to_copy" ]; then
        # Copy directory and its contents recursively
        cp -r "$files_to_copy" "$destination_folder"/
    else
        # Copy files
        cp "$files_to_copy" "$destination_folder"/
    fi
    
    echo "Files have been copied to '$destination_folder'."
    read -p "Press enter to return to the main menu." choice
}





# Function to rename files
rename_files() {
    folder="$1"
    
    clear
    echo "Rename Options:"
    echo "1. Rename Folder"
    echo "2. Rename File"
    read -p "Enter your choice (1-2): " choice
    
    case $choice in
        1) rename_folder "$folder" ;;
        2) rename_file "$folder" ;;
        *) echo "Invalid choice. Please enter a number between 1 and 2." ;;
    esac
}

# Function to rename a folder
rename_folder() {
    folder="$1"
    
    # Prompt the user to enter the folder to rename
    read -p "Enter the folder to rename: " old_name
    
    # Check if the folder exists in the specified directory
    if [ ! -d "$folder/$old_name" ]; then
        echo "Folder '$old_name' does not exist in the directory '$folder'."
        read -p "Press enter to return to the main menu." choice
        return
    fi
    
    # Prompt the user to enter the new folder name
    read -p "Enter the new name for the folder '$old_name': " new_name
    
    # Rename the folder
    mv "$folder/$old_name" "$folder/$new_name"
    
    echo "Folder '$old_name' has been renamed to '$new_name'."
    read -p "Press enter to return to the main menu." choice
}

# Function to rename a file
rename_file() {
    folder="$1"
    
    # Prompt the user to enter the file to rename
    read -p "Enter the file to rename: " old_name
    
    # Check if the file exists in the specified folder
    if [ ! -f "$folder/$old_name" ]; then
        echo "File '$old_name' does not exist in the folder '$folder'."
        read -p "Press enter to return to the main menu." choice
        return
    fi
    
    # Prompt the user to enter the new file name
    read -p "Enter the new name for the file '$old_name': " new_name
    
    # Rename the file
    mv "$folder/$old_name" "$folder/$new_name"
    
    echo "File '$old_name' has been renamed to '$new_name'."
    read -p "Press enter to return to the main menu." choice
}



# Function to delete files
# Function to delete files or folders
delete_files() {
    folder="$1"
    
    clear
    echo "Delete Options:"
    echo "1. Delete File"
    echo "2. Delete Folder"
    read -p "Enter your choice (1-2): " choice
    
    case $choice in
        1) delete_file "$folder" ;;
        2) delete_folder "$folder" ;;
        *) echo "Invalid choice. Please enter a number between 1 and 2." ;;
    esac
}

# Function to delete a file
delete_file() {
    folder="$1"
    
    # Prompt the user to enter the file to delete
    read -p "Enter the file to delete: " file_name
    
    # Check if the file exists in the specified folder
    if [ ! -f "$folder/$file_name" ]; then
        echo "File '$file_name' does not exist in the folder '$folder'."
        read -p "Press enter to return to the main menu." choice
        return
    fi
    
    # Delete the file
    rm "$folder/$file_name"
    
    echo "File '$file_name' has been deleted."
    read -p "Press enter to return to the main menu." choice
}

# Function to delete a folder
delete_folder() {
    folder="$1"
    
    # Prompt the user to enter the folder to delete
    read -p "Enter the folder to delete: " folder_name
    
    # Check if the folder exists in the specified directory
    if [ ! -d "$folder/$folder_name" ]; then
        echo "Folder '$folder_name' does not exist in the directory '$folder'."
        read -p "Press enter to return to the main menu." choice
        return
    fi
    
    # Delete the folder and its contents recursively
    rm -r "$folder/$folder_name"
    
    echo "Folder '$folder_name' and its contents have been deleted."
    read -p "Press enter to return to the main menu." choice
}


# Function to sort files
sort_files() {
    folder="$1"
    
    clear
    echo "Sorting Options:"
    echo "1. Sort by Name"
    echo "2. Sort by Size"
    echo "3. Sort by Modification Time"
    echo "4. Sort by File Type"
    echo "5. Cancel and return to the main menu"
    read -p "Enter your choice (1-5): " choice
    
    case $choice in
        1) sort_by_name "$folder" ;;
        2) sort_by_size "$folder" ;;
        3) sort_by_modification_time "$folder" ;;
        4) sort_by_file_type "$folder" ;;
        5) return ;;
        *) echo "Invalid choice. Please enter a number between 1 and 5." ;;
    esac
}

# Function to sort files by name
sort_by_name() {
    folder="$1"
    
    # Sort files by name
    echo "Sorting files in folder '$folder' by name..."
    ls -l "$folder" | sort -k 9
    read -p "Press enter to return to the main menu." choice
}

# Function to sort files by size
sort_by_size() {
    folder="$1"
    
    # Sort files by size
    echo "Sorting files in folder '$folder' by size..."
    ls -lSh "$folder"
    read -p "Press enter to return to the main menu." choice
}

# Function to sort files by modification time
sort_by_modification_time() {
    folder="$1"
    
    # Sort files by modification time
    echo "Sorting files in folder '$folder' by modification time..."
    ls -lt "$folder"
    read -p "Press enter to return to the main menu." choice
}

# Function to sort files by file type
sort_by_file_type() {
    folder="$1"
    
    # Sort files by file type
    echo "Sorting files in folder '$folder' by file type..."
    ls -l --group-directories-first "$folder"
    read -p "Press enter to return to the main menu." choice
}



# Function for system monitor
system_monitor() {
    # Check if iostat is installed
    if ! command -v iostat &> /dev/null; then
        echo "iostat command not found. Installing sysstat package..."
        
        # Check the package manager and install sysstat
        if [ -x "$(command -v apt-get)" ]; then
            sudo apt-get update
            sudo apt-get install -y sysstat
        elif [ -x "$(command -v yum)" ]; then
            sudo yum install -y sysstat
        else
            echo "Unsupported package manager. Please install sysstat manually."
            return
        fi
    fi

    # Check if netstat is installed
    if ! command -v netstat &> /dev/null; then
        echo "netstat command not found. Installing net-tools package..."
        
        # Check the package manager and install net-tools
        if [ -x "$(command -v apt-get)" ]; then
            sudo apt-get update
            sudo apt-get install -y net-tools
        elif [ -x "$(command -v yum)" ]; then
            sudo yum install -y net-tools
        else
            echo "Unsupported package manager. Please install net-tools manually."
            return
        fi
    fi

    while true; do
        clear
        echo "System Monitor"
        echo "1. View CPU and Memory usage"
        echo "2. View Disk I/O statistics"
        echo "3. View Disk usage"
        echo "4. View Network statistics"
        echo "5. View Active TCP connections"
        echo "6. View Open ports"
        echo "7. View System uptime"
        echo "8. Return to the main menu"
        
        read -p "Enter your choice (1-8): " choice
        case $choice in
            1) 
                echo "CPU and Memory usage:"
                top -b -n 1 | head -n 20
                ;;
            2) 
                echo "Disk I/O statistics:"
                iostat -dx 1 5
                ;;
            3) 
                echo "Disk usage:"
                df -h
                ;;
            4) 
                echo "Network statistics:"
                netstat -i
                ;;
            5) 
                echo "Active TCP connections:"
                netstat -tuln
                ;;
            6)
                echo "Open ports:"
                netstat -tuln | grep LISTEN
                ;;
            7)
                echo "System uptime:"
                uptime
                ;;
            8) return ;;
            *) echo "Invalid choice. Please enter a number between 1 and 8." ;;
        esac
        
        read -p "Press enter to continue." choice
    done
}

# Function for backup
# Directory to store backups
BACKUP_DIR="$HOME/backups"

# Function to create a backup
create_backup() {
    clear
    echo "Create Backup"
    
    # Prompt the user for the directory to back up
    read -p "Enter the directory to back up: " source_dir
    
    # Check if the directory exists
    if [ ! -d "$source_dir" ]; then
        echo "Directory '$source_dir' does not exist."
        read -p "Press enter to return to the backup menu." choice
        return
    fi
    
    # Create backup directory if it doesn't exist
    mkdir -p "$BACKUP_DIR"
    
    # Create the backup
    timestamp=$(date +%Y%m%d%H%M%S)
    backup_file="$BACKUP_DIR/backup_$timestamp.tar.gz"
    tar -czvf "$backup_file" "$source_dir"
    
    echo "Backup of '$source_dir' created at '$backup_file'."
    read -p "Press enter to return to the backup menu." choice
}

# Function to restore a backup
restore_backup() {
    clear
    echo "Restore Backup"
    
    # List available backups
    echo "Available backups:"
    ls "$BACKUP_DIR"/backup_*.tar.gz
    
    # Prompt the user for the backup file to restore
    read -p "Enter the backup file to restore (e.g., backup_20240101123045.tar.gz): " backup_file
    
    # Check if the backup file exists
    if [ ! -f "$BACKUP_DIR/$backup_file" ]; then
        echo "Backup file '$backup_file' does not exist."
        read -p "Press enter to return to the backup menu." choice
        return
    fi
    
    # Prompt the user for the restore directory
    read -p "Enter the directory to restore to: " restore_dir
    
    # Create the restore directory if it doesn't exist
    mkdir -p "$restore_dir"
    
    # Restore the backup
    tar -xzvf "$BACKUP_DIR/$backup_file" -C "$restore_dir"
    
    echo "Backup '$backup_file' restored to '$restore_dir'."
    read -p "Press enter to return to the backup menu." choice
}

# Function to list available backups
list_backups() {
    clear
    echo "List of Available Backups:"
    ls "$BACKUP_DIR"/backup_*.tar.gz
    read -p "Press enter to return to the backup menu." choice
}

# Function for backup menu
backup() {
    while true; do
        clear
        echo "Backup"
        echo "1. Create a Backup"
        echo "2. Restore a Backup"
        echo "3. List Available Backups"
        echo "4. Return to the main menu"
        
        read -p "Enter your choice (1-4): " choice
        case $choice in
            1) create_backup ;;
            2) restore_backup ;;
            3) list_backups ;;
            4) return ;;
            *) echo "Invalid choice. Please enter a number between 1 and 4." ;;
        esac
    done
}


# Function for password manager
PASSWORD_FILE="$HOME/passwords.enc"
PASSPHRASE="my_secret_passphrase"

# Function to encrypt a password
encrypt_password() {
    local password="$1"
    echo -n "$password" | openssl enc -aes-256-cbc -pbkdf2 -pass pass:"$PASSPHRASE"
}

# Function to decrypt a password
decrypt_password() {
    local encrypted_password="$1"
    echo -n "$encrypted_password" | openssl enc -d -aes-256-cbc -pbkdf2 -pass pass:"$PASSPHRASE"
}


# Function to add a password
add_password() {
    clear
    echo "Add Password"
    
    read -p "Enter the service name: " service
    read -p "Enter the username: " username
    read -sp "Enter the password: " password
    echo
    
    encrypted_password=$(encrypt_password "$password")
    echo "$service:$username:$encrypted_password" >> "$PASSWORD_FILE"
    
    echo "Password added for $service."
    read -p "Press enter to return to the password manager menu." choice
}

# Function to view passwords
view_passwords() {
    clear
    echo "View Passwords"
    
    if [ ! -f "$PASSWORD_FILE" ]; then
        echo "No passwords saved."
    else
        while IFS=: read -r service username encrypted_password; do
            decrypted_password=$(decrypt_password "$encrypted_password")
            echo "Service: $service"
            echo "Username: $username"
            echo "Password: $decrypted_password"
            echo
        done < "$PASSWORD_FILE"
    fi
    
    read -p "Press enter to return to the password manager menu." choice
}


# Function to delete a password
delete_password() {
    clear
    echo "Delete Password"
    
    read -p "Enter the service name to delete: " service
    
    if [ ! -f "$PASSWORD_FILE" ]; then
        echo "No passwords saved."
    else
        # Temporarily filter out the service name from the password file and overwrite the original file
        grep -v "^$service:" "$PASSWORD_FILE" > "$PASSWORD_FILE.tmp"
        mv "$PASSWORD_FILE.tmp" "$PASSWORD_FILE"
        
        # Check if any lines were deleted
        if [ "$(wc -l < "$PASSWORD_FILE")" -lt "$(wc -l < "$PASSWORD_FILE.tmp")" ]; then
            echo "Password for $service deleted."
        else
            echo "No password found for $service."
        fi
    fi
    
    read -p "Press enter to return to the password manager menu." choice
}




# Function to update a password
update_password() {
    clear
    echo "Update Password"
    
    read -p "Enter the service name to update: " service
    
    if grep -q "^$service:" "$PASSWORD_FILE"; then
        read -p "Enter the new username: " new_username
        read -sp "Enter the new password: " new_password
        echo
        
        encrypted_password=$(encrypt_password "$new_password")
        grep -v "^$service:" "$PASSWORD_FILE" > "$PASSWORD_FILE.tmp"
        echo "$service:$new_username:$encrypted_password" >> "$PASSWORD_FILE.tmp"
        mv "$PASSWORD_FILE.tmp" "$PASSWORD_FILE"
        
        echo "Password for $service updated."
    else
        echo "No password found for $service."
    fi
    
    read -p "Press enter to return to the password manager menu." choice
}

# Function for password manager menu
password_manager() {
    while true; do
        clear
        echo "Password Manager"
        echo "1. Add Password"
        echo "2. View Passwords"
        echo "3. Delete Password"
        echo "4. Update Password"
        echo "5. Return to the main menu"
        
        read -p "Enter your choice (1-5): " choice
        case $choice in
            1) add_password ;;
            2) view_passwords ;;
            3) delete_password ;;
            4) update_password ;;
            5) return ;;
            *) echo "Invalid choice. Please enter a number between 1 and 5." ;;
        esac
    done
}


# Function for network utilities
# Function to display network interfaces
display_network_interfaces() {
    echo "Network Interfaces:"
    ip addr show
}

# Function to ping a host
ping_host() {
    read -p "Enter the host to ping: " host
    echo "Pinging $host..."
    ping_result=$(ping -c 4 "$host")  # Send 4 ICMP echo request packets and capture output
    echo "$ping_result"  # Display the output of ping
}


# Function to traceroute to a destination
traceroute_destination() {
    read -p "Enter the destination to traceroute: " destination
    traceroute "$destination"
}

# Function to perform DNS lookup
dns_lookup() {
    read -p "Enter the domain name or IP address to lookup: " target
    nslookup "$target"
}

# Function to display netstat information
show_netstat() {
    echo "Netstat Information:"
    netstat -tuln  # Display TCP and UDP listening ports
}

# Function to monitor network bandwidth
monitor_bandwidth() {
    sudo iftop  # Monitor network bandwidth usage
}

# Function for network utilities
network_utilities() {
    while true; do
        clear
        echo "Network Utilities"
        echo "1. Display Network Interfaces"
        echo "2. Ping"
        echo "3. Traceroute"
        echo "4. DNS Lookup"
        echo "5. Netstat"
        echo "6. Bandwidth Monitoring"
        echo "7. Return to the main menu"
        
        read -p "Enter your choice (1-7): " choice
        case $choice in
            1) display_network_interfaces ;;
            2) ping_host ;;
            3) traceroute_destination ;;
            4) dns_lookup ;;
            5) show_netstat ;;
            6) monitor_bandwidth ;;
            7) return ;;
            *) echo "Invalid choice. Please enter a number between 1 and 7." ;;
        esac
        
        read -p "Press enter to continue." choice
    done
}



# Function for text manipulation
# Function for text manipulation
text_manipulation() {
    while true; do
        clear
        echo "Text Manipulation"
        echo "1. Search for a pattern in a file"
        echo "2. Replace a pattern in a file"
        echo "3. Convert text to lowercase"
        echo "4. Convert text to uppercase"
        echo "5. Sort lines in a file"
        echo "6. Return to the main menu"
        
        read -p "Enter your choice (1-6): " choice
        case $choice in
            1) search_pattern ;;
            2) replace_pattern ;;
            3) convert_to_lowercase ;;
            4) convert_to_uppercase ;;
            5) sort_lines ;;
            6) return ;;
            *) echo "Invalid choice. Please enter a number between 1 and 6." ;;
        esac
        
        read -p "Press enter to continue." choice
    done
}

# Function to search for a pattern in a file
search_pattern() {
    clear
    read -p "Enter the pattern to search for: " pattern
    read -p "Enter the file to search in: " filename
    grep "$pattern" "$filename"
}

# Function to replace a pattern in a file
replace_pattern() {
    clear
    read -p "Enter the pattern to replace: " old_pattern
    read -p "Enter the new pattern: " new_pattern
    read -p "Enter the file to perform replacement in: " filename
    sed -i "s/$old_pattern/$new_pattern/g" "$filename"
    echo "Pattern replaced in $filename"
}

# Function to convert text to lowercase
convert_to_lowercase() {
    clear
    read -p "Enter the text to convert to lowercase: " text
    echo "$text" | tr '[:upper:]' '[:lower:]'
}

# Function to convert text to uppercase
convert_to_uppercase() {
    clear
    read -p "Enter the text to convert to uppercase: " text
    echo "$text" | tr '[:lower:]' '[:upper:]'
}

# Function to sort lines in a file
sort_lines() {
    clear
    read -p "Enter the file to sort lines in: " filename
    sort "$filename"
}


# Function for package management
# Function for package management
package_management() {
    while true; do
        clear
        echo "Package Management"
        echo "1. Install a package"
        echo "2. Update installed packages"
        echo "3. Remove a package"
        echo "4. Search for a package"
        echo "5. List installed packages"
        echo "6. Return to the main menu"
        
        read -p "Enter your choice (1-6): " choice
        case $choice in
            1) install_package ;;
            2) update_packages ;;
            3) remove_package ;;
            4) search_package ;;
            5) list_installed_packages ;;
            6) return ;;
            *) echo "Invalid choice. Please enter a number between 1 and 6." ;;
        esac
        
        read -p "Press enter to continue." choice
    done
}

# Function to install a package
install_package() {
    clear
    read -p "Enter the name of the package to install: " package_name
    # Use the package manager's install command (e.g., apt, yum, etc.) to install the package
    # For example, on Ubuntu:
    sudo apt install "$package_name"
}

# Function to update installed packages
update_packages() {
    clear
    # Use the package manager's update command to update installed packages
    # For example, on Ubuntu:
    sudo apt update && sudo apt upgrade
}

# Function to remove a package
remove_package() {
    clear
    read -p "Enter the name of the package to remove: " package_name
    # Use the package manager's remove command (e.g., apt, yum, etc.) to remove the package
    # For example, on Ubuntu:
    sudo apt remove "$package_name"
}

# Function to search for a package
search_package() {
    clear
    read -p "Enter the name of the package to search for: " package_name
    # Use the package manager's search command to search for the package
    # For example, on Ubuntu:
    apt search "$package_name"
}

# Function to list installed packages
list_installed_packages() {
    clear
    # Use the package manager's list command to list installed packages
    # For example, on Ubuntu:
    dpkg -l
}


# Function for remote access
remote_access() {
    clear
    echo "Remote Access"
    # Implement remote access logic here
    read -p "Press enter to return to the main menu." choice
}

# Function for user management
user_management() {
    clear
    echo "User Management"
    # Implement user management logic here
    read -p "Press enter to return to the main menu." choice
}

# Function for system maintenance
system_maintenance() {
    clear
    echo "System Maintenance"
    # Implement system maintenance logic here
    read -p "Press enter to return to the main menu." choice
}

# Function for software installation
software_installation() {
    clear
    echo "Software Installation"
    # Implement software installation logic here
    read -p "Press enter to return to the main menu." choice
}

# Function for disk management
disk_management() {
    clear
    echo "Disk Management"
    # Implement disk management logic here
    read -p "Press enter to return to the main menu." choice
}

# Function for system information
system_information() {
    clear
    echo "System Information"
    # Implement system information logic here
    read -p "Press enter to return to the main menu." choice
}

# Main function
main() {
    while true; do
        display_menu
        read -p "Enter your choice (1-15): " choice
        case $choice in
            1) task_manager ;;
            2) file_organizer ;;
            3) system_monitor ;;
            4) backup ;;
            5) password_manager ;;
            6) network_utilities ;;
            7) text_manipulation ;;
            8) package_management ;;
            9) remote_access ;;
            10) user_management ;;
            11) system_maintenance ;;
            12) software_installation ;;
            13) disk_management ;;
            14) system_information ;;
            15) echo "Exiting OS Assistant. Goodbye!"; exit ;;
            *) echo "Invalid choice. Please enter a number between 1 and 15." ;;
        esac
    done
}

# Run the main function
main
