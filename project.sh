#!/bin/bash

# Function to display the main menu
display_menu() {
    choice=$(zenity --list --title="OS Assistant - Main Menu" \
        --width=600 --height=800 \
        --column="Option" --column="Description" --ok-label="" \
        1 "Task Manager" \
        2 "File Organizer" \
        3 "System Monitor" \
        4 "Backup" \
        5 "Password Manager" \
        6 "Network Utilities" \
        7 "Text Manipulation" \
        8 "Package Management" \
        9 "User Management" \
        10 "System Maintenance" \
        11 "Software Installation" \
        12 "Disk Management" \
        13 "System Information" \
        14 "Service Management" \
        15 "System Benchmarking" \
        16 "Exit")

    echo $choice
}


# Function for task manager
task_manager() {
    while true; do
        choice=$(zenity --list --title="Task Manager" --text="Choose an option" \
            --width=600 --height=800 \
            --column="Option" --column="Description" \
            1 "View all tasks" \
            2 "Sort tasks by CPU usage" \
            3 "Sort tasks by memory usage" \
            4 "Filter tasks by user" \
            5 "Filter tasks by process name" \
            6 "Kill a task" \
            7 "Return to the main menu")

        if [ -z "$choice" ]; then
            # Exit if the choice is empty (user clicked Cancel or closed the dialog)
            exit
        fi

        case $choice in
            1) 
                tasks=$(ps aux)
                zenity --text-info --title="All Tasks" --width=600 --height=800 --filename=<(echo "$tasks")
                ;;
            2) 
                tasks=$(ps aux --sort=-%cpu)
                zenity --text-info --title="Tasks Sorted by CPU Usage" --width=600 --height=800 --filename=<(echo "$tasks")
                ;;
            3) 
                tasks=$(ps aux --sort=-%mem)
                zenity --text-info --title="Tasks Sorted by Memory Usage" --width=600 --height=800 --filename=<(echo "$tasks")
                ;;
            4) 
                username=$(zenity --entry --title="Filter Tasks by User" --text="Enter username:")
                if [ -n "$username" ]; then
                    tasks=$(ps aux | grep "$username" | grep -v "grep")
                    zenity --text-info --title="Tasks for User: $username" --width=600 --height=800 --filename=<(echo "$tasks")
                else
                    zenity --error --text="No username entered."
                fi
                ;;
            5) 
                process_name=$(zenity --entry --title="Filter Tasks by Process Name" --text="Enter process name:")
                if [ -n "$process_name" ]; then
                    tasks=$(ps aux | grep "$process_name" | grep -v "grep")
                    zenity --text-info --title="Tasks for Process: $process_name" --width=600 --height=800 --filename=<(echo "$tasks")
                else
                    zenity --error --text="No process name entered."
                fi
                ;;
            6) 
                pid=$(zenity --entry --title="Kill a Task" --text="Enter PID of the task to kill:")
                if [ -n "$pid" ]; then
                    kill -9 "$pid" && zenity --info --text="Task with PID $pid killed successfully." || zenity --error --text="Failed to kill task with PID $pid."
                else
                    zenity --error --text="No PID entered."
                fi
                ;;
            7) 
                return
                ;;
            *) 
                zenity --error --text="Invalid choice. Please enter a number between 1 and 7."
                ;;
        esac
    done
}


# Function for file organizer
file_organizer() {

    choice=$(zenity --list --title="File Organizer" --text="Select an option for file management:" \
        --width=600 --height=800 \
        --column="Option" --column="Description" \
        1 "Move files" \
        2 "Move folders" \
        3 "Copy files" \
        4 "Copy folders" \
        5 "Rename files" \
        6 "Rename folders" \
        7 "Delete files" \
        8 "Delete folders" \
        9 "Sort files" \
        10 "Add new folder" \
        11 "Add new file" \
        12 "Cancel and return to the main menu")
    
    if [ -z "$choice" ]; then
            # Exit if the choice is empty (user clicked Cancel or closed the dialog)
            exit
    fi

    case $choice in
        1) move_files "$folder" ;;
        2) move_folders "$folder" ;;
        3) copy_files "$folder" ;;
        4) copy_folders "$folder" ;;
        5) rename_file "$folder" ;;
        6) rename_folder "$folder" ;;
        7) delete_file "$folder" ;;
        8) delete_folder "$folder" ;;
        9) sort_files "$folder" ;;
        10) add_new_folder "$folder" ;;
        11) add_new_file "$folder" ;;
        12) return ;;
        *) zenity --error --text="Invalid choice. Please enter a number between 1 and 8." ;;
    esac
}

# Function to add a new folder
add_new_folder() {
    destination_folder=$(zenity --file-selection --directory --title="Select Destination Folder" --width=600 --height=800)
    
    if [ -z "$destination_folder" ]; then
        zenity --error --title="Add New Folder" --text="No destination folder selected. Operation cancelled." --width=600 --height=800
        return
    fi

    new_folder_name=$(zenity --entry --title="Add New Folder" --text="Enter the name of the new folder:" --width=600 --height=800)
    
    if [ -n "$new_folder_name" ]; then
        mkdir "$destination_folder/$new_folder_name"
        
        zenity --info --text="New folder '$new_folder_name' has been created in '$destination_folder'."
    else
        zenity --error --text="No folder name entered."
    fi

    file_organizer
}

add_new_file() {
    destination_folder=$(zenity --file-selection --directory --title="Select Destination Folder" --width=600 --height=800)
    
    if [ -z "$destination_folder" ]; then
        zenity --error --title="Add New File" --text="No destination folder selected. Operation cancelled." --width=600 --height=800
        return
    fi

    new_file_name=$(zenity --entry --title="Add New File" --text="Enter the name of the new file:" --width=600 --height=800)
    
    if [ -n "$new_file_name" ]; then
        touch "$destination_folder/$new_file_name"
        
        zenity --info --text="New file '$new_file_name' has been created in '$destination_folder'."
    else
        zenity --error --text="No file name entered."
    fi

    file_organizer
}



# Function to move files
move_files() {
    files_to_move=$(zenity --file-selection --title="Select Files to Move" --multiple --separator=" " --width=600 --height=800)
    
    if [ -n "$files_to_move" ]; then
        destination_folder=$(zenity --file-selection --title="Select Destination Folder" --directory --width=600 --height=800)
        
        if [ -n "$destination_folder" ]; then
            mv $files_to_move "$destination_folder"/
            zenity --info --text="Files have been moved to '$destination_folder'." --width=600 --height=800
        else
            zenity --error --text="No destination folder selected." --width=600 --height=800
        fi
    else
        zenity --error --text="No files selected." --width=600 --height=800
    fi

    file_organizer
}


move_folders() {
    source_folder=$(zenity --file-selection --directory --title="Select Folder to Move" --width=600 --height=800)
    
    if [ -z "$source_folder" ]; then
        zenity --error --title="Move Folder" --text="No source folder selected. Operation cancelled." --width=600 --height=800
        return
    fi
    
    dest_folder=$(zenity --file-selection --directory --title="Select Destination Folder" --width=600 --height=800)
    
    if [ -z "$dest_folder" ]; then
        zenity --error --title="Move Folder" --text="No destination folder selected. Operation cancelled." --width=600 --height=800
        return
    fi
    
    mv "$source_folder" "$dest_folder"
    
    if [ $? -eq 0 ]; then
        zenity --info --title="Move Folder" --text="Folder moved successfully." --width=600 --height=800
    else
        zenity --error --title="Move Folder" --text="Failed to move the folder. Please check the paths and try again." --width=600 --height=800
    fi

    file_organizer  
}


# Function to copy files
copy_files() {
    files_to_copy=$(zenity --file-selection --title="Select Files to Copy" --multiple --separator=" " --width=600 --height=800)
    
    if [ -n "$files_to_copy" ]; then
        destination_folder=$(zenity --file-selection --title="Select Destination Folder" --directory --width=600 --height=800)
        
        if [ -n "$destination_folder" ]; then
            cp -r $files_to_copy "$destination_folder"/
            zenity --info --text="Files have been copied to '$destination_folder'." --width=600 --height=800
        else
            zenity --error --text="No destination folder selected." --width=600 --height=800
        fi
    else
        zenity --error --text="No files selected." --width=600 --height=800
    fi

    file_organizer
}

copy_folders() {
    source_folder=$(zenity --file-selection --directory --title="Select Folder to Copy" --width=600 --height=800)
    
    if [ -z "$source_folder" ]; then
        zenity --error --title="Copy Folder" --text="No source folder selected. Operation cancelled." --width=600 --height=800
        return
    fi
    
    dest_folder=$(zenity --file-selection --directory --title="Select Destination Folder" --width=600 --height=800)
    
    if [ -z "$dest_folder" ]; then
        zenity --error --title="Copy Folder" --text="No destination folder selected. Operation cancelled." --width=600 --height=800
        return
    fi
    
    cp -r "$source_folder" "$dest_folder"
    
    if [ $? -eq 0 ]; then
        zenity --info --title="Copy Folder" --text="Folder copied successfully." --width=600 --height=800
    else
        zenity --error --title="Copy Folder" --text="Failed to copy the folder. Please check the paths and try again." --width=600 --height=800
    fi

    file_organizer
}


# Function to rename a folder
rename_folder() {
    folder=$(zenity --file-selection --directory --title="Select Folder to Rename" --width=600 --height=800)
    
    if [ -z "$folder" ]; then
        zenity --error --title="Rename Folder" --text="No folder selected. Operation cancelled." --width=600 --height=800
        return
    fi
    
    new_name=$(zenity --entry --title="Rename Folder" --text="Enter the new name for the folder:" --width=600 --height=800)
    
    if [ -n "$new_name" ]; then
        mv "$folder" "$(dirname "$folder")/$new_name"
        zenity --info --title="Rename Folder" --text="Folder renamed to '$new_name'." --width=600 --height=800
    else
        zenity --error --title="Rename Folder" --text="No name entered. Folder not renamed." --width=600 --height=800
    fi

    file_organizer
}

# Function to rename a file
rename_file() {
    folder="$1"
    file=$(zenity --file-selection --title="Select File to Rename" --filename="$folder/" --width=600 --height=800)
    if [ -z "$file" ]; then
        zenity --error --title="Rename File" --text="No file selected. File not renamed." --width=600 --height=800
        return
    fi
    new_name=$(zenity --entry --title="Rename File" --text="Enter the new name for the file:" --width=600 --height=800)
    if [ -n "$new_name" ]; then
        mv "$file" "$(dirname "$file")/$new_name"
        zenity --info --title="Rename File" --text="File renamed to '$new_name'." --width=600 --height=800
    else
        zenity --error --title="Rename File" --text="No name entered. File not renamed." --width=600 --height=800
    fi
    
    file_organizer
}

# Function to delete a file
delete_file() {
    folder="$1"

    file_name=$(zenity --file-selection --title="Select File to Delete")
    
    if [ -n "$file_name" ]; then
        if [ -f "$file_name" ]; then
            rm "$file_name"
            zenity --info --text="File '$file_name' has been deleted."
        else
            zenity --error --text="File '$file_name' does not exist."
        fi
    else
        zenity --error --text="No file selected for deletion."
    fi

    file_organizer
}


# Function to delete a folder
delete_folder() {
    folder="$1"

    folder_name=$(zenity --file-selection --title="Select Folder to Delete" --directory)
    
    if [ -n "$folder_name" ]; then
        if [ -d "$folder_name" ]; then
            rm -r "$folder_name"
            zenity --info --text="Folder '$folder_name' and its contents have been deleted."
        else
            zenity --error --text="Folder '$folder_name' does not exist."
        fi
    else
        zenity --error --text="No folder selected for deletion."
    fi

    file_organizer
}



# Function to sort files
sort_files() {
    folder="$1"

    choice=$(zenity --list --title="Sorting Options" --text="Select an option to sort files:" \
        --width=600 --height=800 \
        --column="Option" --column="Description" \
        1 "Sort by Name" \
        2 "Sort by Size" \
        3 "Sort by Modification Time" \
        4 "Sort by File Type" \
        5 "Back" \
        6 "Main Menu")
    
    if [ -z "$choice" ]; then
        exit
    fi
    
    case $choice in
        1) sort_by_name "$folder" ;;
        2) sort_by_size "$folder" ;;
        3) sort_by_modification_time "$folder" ;;
        4) sort_by_file_type "$folder" ;;
        5) file_organizer ;;
        6) return ;;
        *) zenity --error --text="Invalid choice." --width=600 --height=800 ;;
    esac
}



# Function to sort files by name
sort_by_name() {
    folder=$(zenity --file-selection --directory --title="Select Folder to Sort" --width=600 --height=800)
    
    if [ -z "$folder" ]; then
        zenity --error --title="Sort by Name" --text="No folder selected. Operation cancelled." --width=600 --height=800
        return
    fi

    sorted_files=$(ls -l "$folder" | sort -k 9)
    temp_file=$(mktemp)
    echo "$sorted_files" > "$temp_file"

    zenity --text-info --title="Sorted Files (by Name)" --width=800 --height=600 --filename="$temp_file"
    
    rm "$temp_file"
}




# Function to sort files by size
sort_by_size() {
    folder=$(zenity --file-selection --directory --title="Select Folder to Sort" --width=600 --height=800)
    
    if [ -z "$folder" ]; then
        zenity --error --title="Sort by Size" --text="No folder selected. Operation cancelled." --width=600 --height=800
        return
    fi

    temp_file=$(mktemp)
    ls -lSh "$folder" > "$temp_file"
    
    zenity --text-info --title="Sorted Files (by Size)" --width=800 --height=600 --filename="$temp_file"
    
    rm "$temp_file"
}

sort_by_modification_time() {
    folder=$(zenity --file-selection --directory --title="Select Folder to Sort" --width=600 --height=800)
    
    if [ -z "$folder" ]; then
        zenity --error --title="Sort by Modification Time" --text="No folder selected. Operation cancelled." --width=600 --height=800
        return
    fi

    temp_file=$(mktemp)
    ls -lt "$folder" > "$temp_file"
    
    zenity --text-info --title="Sorted Files (by Modification Time)" --width=800 --height=600 --filename="$temp_file"
    
    rm "$temp_file"
}

sort_by_file_type() {
    folder=$(zenity --file-selection --directory --title="Select Folder to Sort" --width=600 --height=800)
    
    if [ -z "$folder" ]; then
        zenity --error --title="Sort by File Type" --text="No folder selected. Operation cancelled." --width=600 --height=800
        return
    fi
    
    temp_file=$(mktemp)
    ls -l --group-directories-first "$folder" > "$temp_file"
    
    zenity --text-info --title="Sorted Files (by File Type)" --width=800 --height=600 --filename="$temp_file"
    
    rm "$temp_file"
}



# Function for system monitor
system_monitor() {
    if ! command -v iostat &> /dev/null; then
        echo "iostat command not found. Installing sysstat package..."
        
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

    if ! command -v netstat &> /dev/null; then
        echo "netstat command not found. Installing net-tools package..."
        
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
        choice=$(zenity --list --title="System Monitor" --text="Choose an option:" \
            --column="Option" --column="Description" --height=800 --width=600 \
            1 "View CPU and Memory usage" \
            2 "View Disk I/O statistics" \
            3 "View Disk usage" \
            4 "View Network statistics" \
            5 "View Active TCP connections" \
            6 "View Open ports" \
            7 "View System uptime" \
            8 "Return to the main menu")
        if [ -z "$choice" ]; then
            exit
        fi
        case $choice in
            1)
                echo "CPU and Memory usage:"
                top -b -n 1 | head -n 20 | zenity --text-info --title="CPU and Memory usage" --width=800 --height=600
                ;;
            2)
                echo "Disk I/O statistics:"
                iostat -dx 1 5 | zenity --text-info --title="Disk I/O statistics" --width=800 --height=600
                ;;
            3)
                echo "Disk usage:"
                df -h | zenity --text-info --title="Disk usage" --width=800 --height=600
                ;;
            4)
                echo "Network statistics:"
                netstat -i | zenity --text-info --title="Network statistics" --width=800 --height=600
                ;;
            5)
                echo "Active TCP connections:"
                netstat -tuln | zenity --text-info --title="Active TCP connections" --width=800 --height=600
                ;;
            6)
                echo "Open ports:"
                netstat -tuln | grep LISTEN | zenity --text-info --title="Open ports" --width=800 --height=600
                ;;
            7)
                echo "System uptime:"
                uptime | zenity --text-info --title="System uptime" --width=800 --height=600
                ;;
            8) return ;;
            *) echo "Invalid choice. Please choose a valid option." ;;
        esac
    done
}


# Directory to store backups
BACKUP_DIR="$HOME/backups"

# Function to create a backup
create_backup() {
    clear
    echo "Create Backup"

    source_dir=$(zenity --file-selection --title="Select Folder to Backup" --directory --filename="$PWD/")
    
    if [ ! -d "$source_dir" ]; then
        zenity --error --title="Error" --text="Directory '$source_dir' does not exist."
        return
    fi
    
    mkdir -p "$BACKUP_DIR"
    
    timestamp=$(date +%Y%m%d%H%M%S)
    backup_file="$BACKUP_DIR/backup_$timestamp.tar.gz"
    tar -czvf "$backup_file" "$source_dir" 2>/dev/null
    
    zenity --info --title="Backup Created" --text="Backup of '$source_dir' created at '$backup_file'."
}


# Function to restore a backup
restore_backup() {
    clear
    echo "Restore Backup"
    
    echo "Available backups:"
    backups=$(ls "$BACKUP_DIR"/backup_*.tar.gz)
    
    if [ -z "$backups" ]; then
        zenity --error --title="Error" --text="No backups found in '$BACKUP_DIR'." --width=600 --height=800
        return
    fi
    
    backup_list=$(echo "$backups" | tr ' ' '\n')
    
    backup_file=$(zenity --list --title="Restore Backup" --text="Select the backup file to restore:" --column="Backup Files" $backup_list --width=600 --height=800)
    
    if [ -z "$backup_file" ]; then
        return
    fi
    
    backup_file=$(basename "$backup_file")
    
    restore_dir=$(zenity --file-selection --directory --title="Select Restore Directory" --width=600 --height=800)
    
    if [ -z "$restore_dir" ]; then
        return
    fi
    
    mkdir -p "$restore_dir"
    
    tar -xzvf "$BACKUP_DIR/$backup_file" -C "$restore_dir" 2>/dev/null
    
    if [ $? -eq 0 ]; then
        zenity --info --title="Backup Restored" --text="Backup '$backup_file' restored to '$restore_dir'." --width=600 --height=800
    else
        zenity --error --title="Restore Failed" --text="Failed to restore the backup. Please check the backup file and the restore directory." --width=600 --height=800
    fi
}

# Function to list available backups
list_backups() {
    clear
    echo "List of Available Backups:"
    backups=$(ls "$BACKUP_DIR"/backup_*.tar.gz)
    
    if [ -z "$backups" ]; then
        zenity --info --title="No Backups" --text="No backups found in '$BACKUP_DIR'." --width=600 --height=800
    else
        backup_list=$(echo "$backups" | tr ' ' '\n')
        
        zenity --list --title="Available Backups" --column="Backups" --width=600 --height=800 $backup_list
    fi
    
    zenity --info --title="Return to Menu" --text="Press OK to return to the backup menu." --width=600 --height=800
}




# Function for backup menu
delete_backup() {
    clear
    echo "Delete Backup"
    
    echo "Available backups:"
    backups=$(ls "$BACKUP_DIR"/backup_*.tar.gz)
    
    if [ -z "$backups" ]; then
        zenity --error --title="Error" --text="No backups found in '$BACKUP_DIR'." --width=600 --height=800
        return
    fi
    
    backup_list=$(echo "$backups" | tr ' ' '\n')
    
    backup_file=$(zenity --list --title="Delete Backup" --text="Select the backup file to delete:" --column="Backup Files" $backup_list --width=600 --height=800)
    
    if [ -z "$backup_file" ]; then
        return
    fi
    
    backup_file=$(basename "$backup_file")
    
    zenity --question --title="Confirm Deletion" --text="Are you sure you want to delete '$backup_file'?" --width=600 --height=800
    if [ $? -eq 0 ]; then
        rm "$BACKUP_DIR/$backup_file"
        zenity --info --title="Backup Deleted" --text="Backup '$backup_file' deleted successfully." --width=600 --height=800
    fi
}

backup() {
    while true; do
        choice=$(zenity --list --title="Backup" \
            --column="Option" --column="Option Name" --column="Description" \
            --width=600 --height=800 \
            1 "Create a Backup" "This will create a backup" \
            2 "Restore a Backup" "This will restore a backup" \
            3 "List Available Backups" "This will list all available backups" \
            4 "Delete a Backup" "This will delete a backup" \
            5 "Return to the main menu" "This will return to the main menu" \
            --text="Please select an option:")
        if [ -z "$choice" ]; then
            exit
        fi
        case $choice in
            1) create_backup ;;
            2) restore_backup ;;
            3) list_backups ;;
            4) delete_backup ;;
            5) break ;;
            *) zenity --error --title="Invalid Choice" --text="Please select a valid option from the list." --width=600 --height=800 ;;
        esac
    done
}




PASSWORD_FILE="$HOME/passwords.enc"
PASSPHRASE="my_secret_passphrase"

# Function to encrypt a password
encrypt_password() {
    echo -n "$1" | openssl enc -aes-256-cbc -pbkdf2 -pass pass:"$PASSPHRASE" | base64 -w 0
}

# Function to decrypt a password
decrypt_password() {
    echo -n "$1" | base64 --decode | openssl enc -d -aes-256-cbc -pbkdf2 -pass pass:"$PASSPHRASE"
}

# Function to add a password
add_password() {
    clear
    echo "Add Password"
    
    service=$(zenity --entry --title="Add Password" --text="Enter the service name:" --width=600 --height=800)
    if [ -z "$service" ]; then
        zenity --error --title="Error" --text="Service name cannot be empty." --width=600 --height=800
        return
    fi
    
    if grep -q "^$service:" "$PASSWORD_FILE"; then
        zenity --error --title="Error" --text="Service name already exists." --width=600 --height=800
        return
    fi

    username=$(zenity --entry --title="Add Password" --text="Enter the username:" --width=600 --height=800)
    if [ -z "$username" ]; then
        zenity --error --title="Error" --text="Username cannot be empty." --width=600 --height=800
        return
    fi
    
    password=$(zenity --password --title="Add Password" --width=600 --height=800)
    if [ -z "$password" ]; then
        zenity --error --title="Error" --text="Password cannot be empty." --width=600 --height=800
        return
    fi
    
    encrypted_password=$(encrypt_password "$password")
    echo "$service:$username:$encrypted_password" >> "$PASSWORD_FILE"
    
    zenity --info --title="Password Added" --text="Password added for $service." --width=600 --height=800
}

# Function to view passwords
view_passwords() {
    clear
    echo "View Passwords"

    if ! zenity --password --title="Authentication Required" --text="Enter your system password:" --width=600 --height=800 | sudo -S true; then
        zenity --error --title="Error" --text="Authentication failed." --width=600 --height=800
        return
    fi
    
    if [ ! -f "$PASSWORD_FILE" ]; then
        zenity --info --title="View Passwords" --text="No passwords saved." --width=600 --height=800
    else
        passwords_text=""

        while IFS=: read -r service username encrypted_password; do
            decrypted_password=$(decrypt_password "$encrypted_password")
            passwords_text+="Service: $service\nUsername: $username\nPassword: $decrypted_password\n\n"
        done < "$PASSWORD_FILE"

        if [ -z "$passwords_text" ]; then
            zenity --info --title="View Passwords" --text="No passwords saved." --width=600 --height=800
        else
            zenity --text-info --title="View Passwords" --width=600 --height=800 --filename=<(echo -e "$passwords_text")
        fi
    fi
}

# Function to delete a password
delete_password() {
    clear
    echo "Delete Password"
    
    if ! zenity --password --title="Authentication Required" --text="Enter your system password:" --width=600 --height=800 | sudo -S true; then
        zenity --error --title="Error" --text="Authentication failed." --width=600 --height=800
        return
    fi

    service=$(zenity --entry --title="Delete Password" --text="Enter the service name to delete:" --width=600 --height=800)
    if [ -z "$service" ]; then
        return
    fi
    
    if [ ! -f "$PASSWORD_FILE" ]; then
        zenity --info --title="Delete Password" --text="No passwords saved." --width=600 --height=800
    else
        grep -v "^$service:" "$PASSWORD_FILE" > "$PASSWORD_FILE.tmp"
        if [ "$(wc -l < "$PASSWORD_FILE")" -gt "$(wc -l < "$PASSWORD_FILE.tmp")" ]; then
            mv "$PASSWORD_FILE.tmp" "$PASSWORD_FILE"
            zenity --info --title="Delete Password" --text="Password for $service deleted." --width=600 --height=800
        else
            rm "$PASSWORD_FILE.tmp"
            zenity --info --title="Delete Password" --text="No password found for $service." --width=600 --height=800
        fi
    fi
}

# Function to update a password
update_password() {
    clear
    echo "Update Password"
    
    if ! zenity --password --title="Authentication Required" --text="Enter your system password:" --width=600 --height=800 | sudo -S true; then
        zenity --error --title="Error" --text="Authentication failed." --width=600 --height=800
        return
    fi

    service=$(zenity --entry --title="Update Password" --text="Enter the service name to update:" --width=600 --height=800)
    if [ -z "$service" ]; then
        return
    fi
    
    if grep -q "^$service:" "$PASSWORD_FILE"; then
        new_username=$(zenity --entry --title="Update Password" --text="Enter the new username:" --width=600 --height=800)
        new_password=$(zenity --password --title="Update Password" --text="Enter the new password:" --width=600 --height=800)
        
        if [ -z "$new_username" ] || [ -z "$new_password" ]; then
            return
        fi
        
        encrypted_password=$(encrypt_password "$new_password")
        grep -v "^$service:" "$PASSWORD_FILE" > "$PASSWORD_FILE.tmp"
        echo "$service:$new_username:$encrypted_password" >> "$PASSWORD_FILE.tmp"
        mv "$PASSWORD_FILE.tmp" "$PASSWORD_FILE"
        
        zenity --info --title="Update Password" --text="Password for $service updated." --width=600 --height=800
    else
        zenity --info --title="Update Password" --text="No password found for $service." --width=600 --height=800
    fi
}

# Main function for password manager
password_manager() {
    while true; do
        clear
        choice=$(zenity --list --title="Password Manager" --text="Choose an option:" --column="Option" \
            "1 Add Password" "2 View Passwords" "3 Delete Password" "4 Update Password" "5 Return to Main Menu" \
            --width=600 --height=800 --cancel-label="Return to Main Menu")
        if [ -z "$choice" ]; then
            exit
        fi
        case $choice in
            "1 Add Password")
                add_password
                ;;
            "2 View Passwords")
                view_passwords
                ;;
            "3 Delete Password")
                delete_password
                ;;
            "4 Update Password")
                update_password
                ;;
            "5 Return to Main Menu")
                return
                ;;
            *)
                zenity --error --text="Invalid choice. Please select a valid option." --width=600 --height=800
                ;;
        esac
    done
}




# Function to display network interfaces
display_network_interfaces() {
    network_info=$(ip addr show)
    zenity --text-info --title="Network Interfaces" --width=600 --height=800 --filename=<(echo "$network_info")
}


# Function to ping a host
ping_host() {
    host=$(zenity --entry --title="Ping Host" --text="Enter the host to ping:")
    if [ -n "$host" ]; then
        ping_result=$(ping -c 4 "$host")  # Send 4 ICMP echo request packets and capture output
        zenity --info --title="Ping Result" --width=600 --height=800 --text="$ping_result"
    else
        zenity --error --title="Error" --text="No host entered."
    fi
}



# Function to traceroute to a destination
traceroute_destination() {
    destination=$(zenity --entry --title="Traceroute Destination" --text="Enter the destination to traceroute:")
    if [ -n "$destination" ]; then
        temp_file=$(mktemp)
        
        traceroute "$destination" &> "$temp_file"

        if [ -s "$temp_file" ]; then
            zenity --text-info --title="Traceroute Result" --width=600 --height=800 --filename="$temp_file"
        else
            zenity --info --title="Traceroute Result" --text="No traceroute result for $destination." --width=600 --height=200
        fi
        
        rm -f "$temp_file"
    else
        zenity --error --title="Error" --text="No destination entered."
    fi
}



# Function to perform DNS lookup
dns_lookup() {
    target=$(zenity --entry --title="DNS Lookup" --text="Enter the domain name or IP address to lookup:")
    if [ -n "$target" ]; then
        temp_file=$(mktemp)
        
        nslookup "$target" &> "$temp_file"

        if [ -s "$temp_file" ]; then
            zenity --text-info --title="DNS Lookup Result" --width=600 --height=400 --filename="$temp_file"
        else
            zenity --info --title="DNS Lookup Result" --text="No DNS lookup result for $target." --width=600 --height=200
        fi
        
        rm -f "$temp_file"
    else
        zenity --error --title="Error" --text="No target entered."
    fi
}



show_netstat() {
    temp_file=$(mktemp)
    
    netstat -tuln &> "$temp_file"

    if [ -s "$temp_file" ]; then
        zenity --text-info --title="Netstat Information" --width=600 --height=800 --filename="$temp_file"
    else
        zenity --info --title="Netstat Information" --text="No netstat information available." --width=600 --height=200
    fi
    
    rm -f "$temp_file"
}






# Function for network utilities
network_utilities() {
    while true; do
        choice=$(zenity --list --title="Network Utilities" \
            --width=600 --height=800 \
            --column="Option" --column="Description" \
            1 "Display Network Interfaces" \
            2 "Ping" \
            3 "Traceroute" \
            4 "DNS Lookup" \
            5 "Netstat" \
            6 "Return to Main Menu")
if [ -z "$choice" ]; then
            exit
        fi
        case $choice in
            1) display_network_interfaces ;;
            2) ping_host ;;
            3) traceroute_destination ;;
            4) dns_lookup ;;
            5) show_netstat ;;
            6) return ;;
            *) zenity --error --text="Invalid choice. Please select a valid option." ;;
        esac
    done
}


# Function for text manipulation
text_manipulation() {
    while true; do
        choice=$(zenity --list \
            --title="Text Manipulation" \
            --text="Choose an option:" \
            --column="Option" --column="Description" \
            1 "Search for a pattern in a file" \
            2 "Replace a pattern in a file" \
            3 "Convert text to lowercase" \
            4 "Convert text to uppercase" \
            5 "Sort lines in a file" \
            6 "Count occurrences of a pattern in a file" \
            7 "Remove duplicate lines from a file" \
            8 "Reverse lines in a file" \
            9 "Return to the main menu" \
            --height=800 --width=600)
        if [ -z "$choice" ]; then
            exit
        fi
        case $choice in
            1) search_pattern ;;
            2) replace_pattern ;;
            3) convert_to_lowercase ;;
            4) convert_to_uppercase ;;
            5) sort_lines ;;
            6) count_pattern_occurrences ;;
            7) remove_duplicate_lines ;;
            8) reverse_lines ;;
            9) return ;;
        esac
        
    done
}


count_pattern_occurrences() {
    file=$(zenity --file-selection --title="Select File" --text="Select the file to search in:" --height=800 --width=600)
    if [ -z "$file" ]; then
        zenity --error --title="Error" --text="No file selected." --height=800 --width=600
        return
    fi

    pattern=$(zenity --entry --title="Enter Pattern" --text="Enter the pattern to count occurrences:" --height=800 --width=600)
    if [ -z "$pattern" ]; then
        zenity --error --title="Error" --text="No pattern entered." --height=800 --width=600
        return
    fi

    occurrences=$(grep -o "$pattern" "$file" | wc -l)
    zenity --info --title="Pattern Occurrences" --text="Number of occurrences of '$pattern' in '$file': $occurrences" --height=800 --width=600
}


remove_duplicate_lines() {
    file=$(zenity --file-selection --title="Select File" --text="Select the file to remove duplicates from:" --height=800 --width=600)
    if [ -z "$file" ]; then
        zenity --error --title="Error" --text="No file selected." --height=800 --width=600
        return
    fi

    sorted_file=$(mktemp)
    sort -u "$file" > "$sorted_file"
    mv "$sorted_file" "$file"

    zenity --info --title="Remove Duplicates" --text="Duplicate lines removed from '$file'." --height=800 --width=600
}

reverse_lines() {
    file=$(zenity --file-selection --title="Select File" --text="Select the file to reverse lines:" --height=800 --width=600)
    if [ -z "$file" ]; then
        zenity --error --title="Error" --text="No file selected." --height=800 --width=600
        return
    fi

    reverse_file=$(mktemp)
    tac "$file" > "$reverse_file"
    mv "$reverse_file" "$file"

    zenity --info --title="Reverse Lines" --text="Lines in '$file' reversed." --height=800 --width=600
}




# Function to search for a pattern in a file
search_pattern() {
    pattern=$(zenity --entry --title="Search Pattern" --text="Enter the pattern to search for:" --height=800 --width=600)
    filename=$(zenity --file-selection --title="Select File" --filename="$HOME" --height=800 --width=600)

    if [ -n "$pattern" ] && [ -n "$filename" ]; then
        result=$(grep "$pattern" "$filename")
        zenity --info --title="Search Result" --text="$result" --height=800 --width=600
    else
        zenity --error --title="Error" --text="Pattern or file not provided." --height=800 --width=600
    fi
}



# Function to replace a pattern in a file
replace_pattern() {
    old_pattern=$(zenity --entry --title="Replace Pattern" --text="Enter the pattern to replace:" --height=800 --width=600)
    new_pattern=$(zenity --entry --title="Replace Pattern" --text="Enter the new pattern:" --height=800 --width=600)
    filename=$(zenity --file-selection --title="Select File" --filename="$HOME" --height=800 --width=600)

    if [ -n "$old_pattern" ] && [ -n "$new_pattern" ] && [ -n "$filename" ]; then
        sed -i "s/$old_pattern/$new_pattern/g" "$filename"
        zenity --info --title="Replacement Complete" --text="Pattern replaced in $filename" --height=800 --width=600
    else
        zenity --error --title="Error" --text="Pattern or file not provided." --height=800 --width=600
    fi
}


# Function to convert text to lowercase
convert_to_lowercase() {
    text=$(zenity --entry --title="Convert to Lowercase" --text="Enter the text to convert to lowercase:" --height=800 --width=600)
    
    if [ -n "$text" ]; then
        result=$(echo "$text" | tr '[:upper:]' '[:lower:]')
        zenity --info --title="Conversion Complete" --text="Converted text:\n$result" --height=800 --width=600
    else
        zenity --error --title="Error" --text="No text provided." --height=800 --width=600
    fi
}


# Function to convert text to uppercase
convert_to_uppercase() {
    text=$(zenity --entry --title="Convert to Uppercase" --text="Enter the text to convert to uppercase:" --height=800 --width=600)
    
    if [ -n "$text" ]; then
        result=$(echo "$text" | tr '[:lower:]' '[:upper:]')
        zenity --info --title="Conversion Complete" --text="Converted text:\n$result" --height=800 --width=600
    else
        zenity --error --title="Error" --text="No text provided." --height=800 --width=600
    fi
}


# Function to sort lines in a file
sort_lines() {
    filename=$(zenity --file-selection --title="Select File to Sort Lines In" --height=800 --width=600)
    
    if [ -n "$filename" ]; then
        sorted_content=$(sort "$filename")
        zenity --text-info --title="Sorted Lines" --width=600 --height=400 --filename="$filename" --editable
    else
        zenity --error --title="Error" --text="No file selected." --height=800 --width=600
    fi
}



# Function for package management
package_management() {
    while true; do
        clear
        choice=$(zenity --list --title="Package Management" --text="Select an option:" --column="Option" --column="Description" \
        1 "Install a package" \
        2 "Update installed packages" \
        3 "Remove a package" \
        4 "Search for a package" \
        5 "List installed packages" \
        6 "Return to the main menu" \
        --height=800 --width=600)
        if [ -z "$choice" ]; then
            exit
        fi
        case $choice in
            1) install_package ;;
            2) update_packages ;;
            3) remove_package ;;
            4) search_package ;;
            5) list_installed_packages ;;
            6) return ;;
            *) zenity --error --text="Invalid choice. Please select a valid option." ;;
        esac
    done
}



# Function to install a package
install_package() {
    clear
    package_name=$(zenity --entry --title="Install Package" --text="Enter the name of the package to install:")
    
    if [ -n "$package_name" ]; then
        sudo apt install "$package_name"
        zenity --info --text="Package '$package_name' installed successfully."
    else
        zenity --error --text="Package name cannot be empty."
    fi
}


# Function to update installed packages
update_packages() {
    clear
    zenity --info --text="Updating installed packages..."

    sudo apt update && sudo apt upgrade

    zenity --info --text="Packages have been successfully updated."
}


# Function to remove a package
remove_package() {
    clear
    package_name=$(zenity --entry --title="Remove Package" --text="Enter the name of the package to remove:")
    
    if [ -z "$package_name" ]; then
        zenity --error --text="Package name cannot be empty. Please enter a valid package name."
        return
    fi
    
    sudo apt remove "$package_name"
    
    zenity --info --text="Package '$package_name' has been successfully removed."
}


# Function to search for a package
search_package() {
    clear
    package_name=$(zenity --entry --title="Search Package" --text="Enter the name of the package to search for:")
    
    if [ -z "$package_name" ]; then
        zenity --error --text="Package name cannot be empty. Please enter a valid package name."
        return
    fi
    
    apt search "$package_name" | zenity --text-info --width=600 --height=400 --title="Search Results for $package_name"
}


# Function to list installed packages
list_installed_packages() {
    clear
    installed_packages=$(dpkg -l)
    
    zenity --text-info --width=800 --height=600 --title="Installed Packages" --editable --filename=<(echo "$installed_packages")
}


# Function for user management
user_management() {
    while true; do
        clear
        option=$(zenity --list \
            --title="User Management" \
            --text="Choose an option:" \
            --column="Option" \
            --column="Description" \
            1 "Add a user" \
            2 "Delete a user" \
            3 "List users" \
            4 "Sort users by name" \
            5 "Sort users by permission" \
            6 "View all users' permissions" \
            7 "View specific user's permissions" \
            8 "Change user permissions" \
            9 "Return to main menu" \
            --height=800 \
            --width=600)
        if [ -z "$option" ]; then
            exit
        fi
        case $option in
            1)
                username=$(zenity --entry --title="Add User" --text="Enter username to add:" --height=800 --width=600)
                sudo useradd "$username" && zenity --info --text="User $username added successfully." --height=800 --width=600 || zenity --error --text="Failed to add user $username." --height=800 --width=600
                ;;
            2)
                username=$(zenity --entry --title="Delete User" --text="Enter username to delete:" --height=800 --width=600)
                sudo userdel -r "$username" && zenity --info --text="User $username deleted successfully." --height=800 --width=600 || zenity --error --text="Failed to delete user $username." --height=800 --width=600
                ;;
            3)
                users=$(cut -d: -f1 /etc/passwd)
                zenity --info --title="Current users on the system" --text="$users" --height=800 --width=600
                ;;
            4)
                sorted_users=$(cut -d: -f1 /etc/passwd | sort)
                zenity --info --title="Users sorted by name" --text="$sorted_users" --height=800 --width=600
                ;;
            5)
                sorted_permissions=$(awk -F: '{print $1, $3}' /etc/passwd | sort -k2n)
                zenity --info --title="Users sorted by permission (UID)" --text="$sorted_permissions" --height=800 --width=600
                ;;
            6)
                all_permissions=$(awk -F: '{print "User:", $1, "UID:", $3, "GID:", $4, "Home Directory:", $6, "Shell:", $7}' /etc/passwd)
                zenity --info --title="All users' permissions" --text="$all_permissions" --height=800 --width=600
                ;;
            7)
                username=$(zenity --entry --title="View User Permissions" --text="Enter username to view permissions:" --height=800 --width=600)
                user_info=$(getent passwd "$username")
                if [ -n "$user_info" ]; then
                    IFS=: read -r _ _ uid gid _ home shell <<< "$user_info"
                    permissions="User: $username\nUID: $uid\nGID: $gid\nHome Directory: $home\nShell: $shell"
                    zenity --info --title="User Permissions" --text="$permissions" --height=800 --width=600
                else
                    zenity --error --text="User $username does not exist." --height=800 --width=600
                fi
                ;;
            8)
                username=$(zenity --entry --title="Change User Permissions" --text="Enter username to change permissions:" --height=800 --width=600)
                uid=$(zenity --entry --title="Change User Permissions" --text="Enter new UID:" --height=800 --width=600)
                gid=$(zenity --entry --title="Change User Permissions" --text="Enter new GID:" --height=800 --width=600)
                sudo usermod -u "$uid" -g "$gid" "$username" && zenity --info --text="Permissions for user $username changed successfully." --height=800 --width=600 || zenity --error --text="Failed to change permissions for user $username." --height=800 --width=600
                ;;
            9)
                return
                ;;
            *)
                zenity --error --text="Invalid option. Please choose a valid option." --height=800 --width=600
                ;;
        esac
    done
}





# Function for system maintenance
system_maintenance() {
    while true; do
        choice=$(zenity --list --title="System Maintenance" --column="Options" --column="Description" \
            1 "System Maintenance" \
            2 "Clean up unused packages" \
            3 "View running processes" \
            4 "Reboot the system" \
            5 "Check system load" \
            6 "Check available updates" \
            7 "Check system memory usage" \
            8 "View system logs" \
            9 "Return to main menu" \
            --height=800 --width=600 --cancel-label="Cancel")
        if [ -z "$choice" ]; then
            exit
        fi
        case $choice in
            1)
                zenity --info --text="Updating the system..." --height=800 --width=600
                sudo apt update && sudo apt upgrade -y
                zenity --info --text="System updated successfully." --height=800 --width=600
                ;;
            2)
                zenity --info --text="Cleaning up unused packages..." --height=800 --width=600
                sudo apt autoremove -y && sudo apt autoclean
                zenity --info --text="Unused packages cleaned up successfully." --height=800 --width=600
                ;;
            3)
                ps aux | zenity --text-info --title="Running Processes" --height=800 --width=600
                ;;
            4)
                confirm=$(zenity --question --text="Are you sure you want to reboot the system?" --height=800 --width=600)
                if [ "$confirm" = "TRUE" ]; then
                    zenity --info --text="Rebooting the system..." --height=800 --width=600
                    sudo reboot
                else
                    zenity --info --text="Reboot cancelled." --height=800 --width=600
                fi
                ;;
            5)
                uptime | zenity --text-info --title="System Load" --height=800 --width=600
                ;;
            6)
                sudo apt update
                apt list --upgradable | zenity --text-info --title="Available Updates" --height=800 --width=600
                ;;
            7)
                free -h | zenity --text-info --title="System Memory Usage" --height=800 --width=600
                ;;
            8)
                sudo journalctl -xe | zenity --text-info --title="System Logs" --height=800 --width=600
                ;;
            9)
                return
                ;;
            *)
                zenity --error --text="Invalid option. Please choose a valid option." --height=800 --width=600
                ;;
        esac
    done
}




# Function for software installation
software_installation() {
    while true; do
        choice=$(zenity --list --title="Software Installation" --column="Options" --column="Description" \
            1 "Install a software package" \
            2 "Search for available packages" \
            3 "List installed packages" \
            4 "Remove a software package" \
            5 "Update package lists" \
            6 "Upgrade installed packages" \
            7 "Return to main menu" \
            --height=800 --width=600 --cancel-label="Cancel")
        if [ -z "$choice" ]; then
            exit
        fi
        case $choice in
            1)
                package_name=$(zenity --entry --title="Install Package" --text="Enter the name of the package to install:" --height=800 --width=600)
                if [ -n "$package_name" ]; then
                    sudo apt install "$package_name" && zenity --info --title="Success" --text="Package $package_name installed successfully." --height=800 --width=600 || zenity --error --title="Error" --text="Failed to install package $package_name." --height=800 --width=600
                fi
                ;;
            2)
                keyword=$(zenity --entry --title="Search Packages" --text="Enter the search keyword:" --height=800 --width=600)
                if [ -n "$keyword" ]; then
                    apt search "$keyword" | zenity --text-info --title="Search Results" --width=600 --height=400
                fi
                ;;
            3)
                dpkg -l | zenity --text-info --title="Installed Packages" --width=800 --height=600
                ;;
            4)
                package_name=$(zenity --entry --title="Remove Package" --text="Enter the name of the package to remove:" --height=800 --width=600)
                if [ -n "$package_name" ]; then
                    sudo apt remove "$package_name" && zenity --info --title="Success" --text="Package $package_name removed successfully." --height=800 --width=600 || zenity --error --title="Error" --text="Failed to remove package $package_name." --height=800 --width=600
                fi
                ;;
            5)
                sudo apt update && zenity --info --title="Success" --text="Package lists updated successfully." --height=800 --width=600
                ;;
            6)
                sudo apt upgrade && zenity --info --title="Success" --text="Installed packages upgraded successfully." --height=800 --width=600
                ;;
            7)
                return
                ;;
            *) 
                zenity --error --title="Error" --text="Invalid option. Please choose a valid option." --height=800 --width=600
                ;;
        esac
    done
}




# Function for disk management
disk_management() {
    while true; do
        choice=$(zenity --list --title="Disk Management" --text="Choose an option:" --column="Option" --column="Description" \
            1 "View disk usage" \
            2 "List partitions" \
            3 "Format a partition" \
            4 "Mount a partition" \
            5 "Unmount a partition" \
            6 "Return to main menu" \
            --height=800 --width=600 --cancel-label="Cancel")
        if [ -z "$choice" ]; then
            exit
        fi
        case $choice in
            1)
                df -h | zenity --text-info --title="Disk Usage" --width=800 --height=600
                ;;
            2)
                lsblk | zenity --text-info --title="List of Partitions" --width=800 --height=600
                ;;
            3)
                partition=$(zenity --entry --title="Format Partition" --text="Enter the partition to format (e.g., /dev/sdb1):" --height=800 --width=600)
                if [ -n "$partition" ]; then
                    sudo mkfs.ext4 "$partition" && zenity --info --title="Success" --text="Partition $partition formatted successfully." --height=200 --width=400 || zenity --error --title="Error" --text="Failed to format partition $partition." --height=200 --width=400
                fi
                ;;
            4)
                partition=$(zenity --entry --title="Mount Partition" --text="Enter the partition to mount (e.g., /dev/sdb1):" --height=800 --width=600)
                mount_point=$(zenity --entry --title="Mount Partition" --text="Enter the mount point:" --height=800 --width=600)
                if [ -n "$partition" ] && [ -n "$mount_point" ]; then
                    sudo mount "$partition" "$mount_point" && zenity --info --title="Success" --text="Partition $partition mounted at $mount_point." --height=200 --width=400 || zenity --error --title="Error" --text="Failed to mount partition $partition." --height=200 --width=400
                fi
                ;;
            5)
                partition=$(zenity --entry --title="Unmount Partition" --text="Enter the partition to unmount (e.g., /dev/sdb1):" --height=800 --width=600)
                if [ -n "$partition" ]; then
                    sudo umount "$partition" && zenity --info --title="Success" --text="Partition $partition unmounted successfully." --height=200 --width=400 || zenity --error --title="Error" --text="Failed to unmount partition $partition." --height=200 --width=400
                fi
                ;;
            6)
                return
                ;;
            *) 
                zenity --error --title="Error" --text="Invalid option. Please choose a valid option." --height=200 --width=400
                ;;
        esac
    done
}





# Function for system information
system_information() {
    while true; do
        option=$(zenity --list --title="System Information" --text="Choose an option:" --column="Option" --column="Description" \
            1 "Display system information" \
            2 "Display CPU information" \
            3 "Display memory information" \
            4 "Display disk information" \
            5 "Display network information" \
            6 "Return to main menu" \
            --height=800 --width=600 --cancel-label="Cancel")
        if [ -z "$option" ]; then
            exit
        fi
        case $option in
            1)
                uname -a | zenity --text-info --title="System Information" --width=800 --height=600
                ;;
            2)
                lscpu | zenity --text-info --title="CPU Information" --width=800 --height=600
                ;;
            3)
                free -h | zenity --text-info --title="Memory Information" --width=800 --height=600
                ;;
            4)
                df -h | zenity --text-info --title="Disk Information" --width=800 --height=600
                ;;
            5)
                ip addr show | zenity --text-info --title="Network Information" --width=800 --height=600
                ;;
            6)
                return
                ;;
            *) 
                zenity --error --title="Error" --text="Invalid option. Please choose a valid option." --height=200 --width=400
                ;;
        esac
    done
}



service_management() {
    while true; do
        option=$(zenity --list --title="Service Management" --text="Choose an option:" --column="Option" --column="Description" \
            1 "Start a service" \
            2 "Stop a service" \
            3 "Restart a service" \
            4 "Enable a service" \
            5 "Disable a service" \
            6 "Return to main menu" \
            --height=800 --width=600 --cancel-label="Cancel")
        if [ -z "$option" ]; then
            exit
        fi
        case $option in
            1)
                service_name=$(zenity --entry --title="Start a Service" --text="Enter the name of the service to start:")
                sudo systemctl start "$service_name" && zenity --info --title="Success" --text="Service $service_name started successfully." || zenity --error --title="Error" --text="Failed to start service $service_name."
                ;;
            2)
                service_name=$(zenity --entry --title="Stop a Service" --text="Enter the name of the service to stop:")
                sudo systemctl stop "$service_name" && zenity --info --title="Success" --text="Service $service_name stopped successfully." || zenity --error --title="Error" --text="Failed to stop service $service_name."
                ;;
            3)
                service_name=$(zenity --entry --title="Restart a Service" --text="Enter the name of the service to restart:")
                sudo systemctl restart "$service_name" && zenity --info --title="Success" --text="Service $service_name restarted successfully." || zenity --error --title="Error" --text="Failed to restart service $service_name."
                ;;
            4)
                service_name=$(zenity --entry --title="Enable a Service" --text="Enter the name of the service to enable:")
                sudo systemctl enable "$service_name" && zenity --info --title="Success" --text="Service $service_name enabled successfully." || zenity --error --title="Error" --text="Failed to enable service $service_name."
                ;;
            5)
                service_name=$(zenity --entry --title="Disable a Service" --text="Enter the name of the service to disable:")
                sudo systemctl disable "$service_name" && zenity --info --title="Success" --text="Service $service_name disabled successfully." || zenity --error --title="Error" --text="Failed to disable service $service_name."
                ;;
            6)
                return
                ;;
            *) 
                zenity --error --title="Error" --text="Invalid option. Please choose a valid option."
                ;;
        esac
    done
}



system_benchmarking() {
    while true; do
        option=$(zenity --list --title="System Benchmarking" --text="Choose an option:" --column="Option" --column="Description" \
            1 "CPU Benchmark" \
            2 "Memory Benchmark" \
            3 "Disk Benchmark" \
            4 "Network Benchmark" \
            5 "Return to main menu" \
            --height=800 --width=600 --cancel-label="Cancel")
        if [ -z "$option" ]; then
            exit
        fi
        case $option in
            1)
                zenity --info --title="CPU Benchmark" --text="Running CPU benchmark...\nThis may take some time."
                sysbench cpu --time=10 run | zenity --text-info --title="CPU Benchmark Result" --width=800 --height=600
                ;;
            2)
                zenity --info --title="Memory Benchmark" --text="Running memory benchmark...\nThis may take some time."
                sysbench memory --time=10 run | zenity --text-info --title="Memory Benchmark Result" --width=800 --height=600
                ;;
            3)
                zenity --info --title="Disk Benchmark" --text="Running disk benchmark...\nThis may take some time."
                sudo fio --name=randwrite --ioengine=posixaio --rw=randwrite --bs=4k --numjobs=4 --size=4G --runtime=60 --group_reporting | zenity --text-info --title="Disk Benchmark Result" --width=800 --height=600
                ;;
            4)
                zenity --info --title="Network Benchmark" --text="Running network benchmark...\nThis may take some time."
                speedtest-cli | zenity --text-info --title="Network Benchmark Result" --width=800 --height=600
                ;;
            5)
                return
                ;;
            *) 
                zenity --error --title="Error" --text="Invalid option. Please choose a valid option."
                ;;
        esac
    done
}




# Main function
main() {
    while true; do
        choice=$(display_menu)
        if [ -z "$choice" ]; then
            exit
        fi
        
        case $choice in
            1) task_manager ;;
            2) file_organizer ;;
            3) system_monitor ;;
            4) backup ;;
            5) password_manager ;;
            6) network_utilities ;;
            7) text_manipulation ;;
            8) package_management ;;
            9) user_management ;;
            10) system_maintenance ;;
            11) software_installation ;;
            12) disk_management ;;
            13) system_information ;;
            14) service_management ;;
            15) system_benchmarking ;;
            16) zenity --info --text="Exiting OS Assistant. Goodbye!" --width=600 --height=800; exit ;;
            *) zenity --error --text="Invalid choice. Please enter a number between 1 and 16." --width=600 --height=800 ;;
        esac
    done
}




# Run the main function
main
