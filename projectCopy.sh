check_env() {
    if [ "$SECRET_KEY" != "SuperSecretValue" ]; then
        echo "Error: Environment variable SECRET_KEY is not set correctly."
        exit 1
    fi
}

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
    echo "8. Exit"
}


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

file_organizer() {
    clear
    echo "File Organizer"
    
    read -p "Enter the folder to organize (press enter for current directory): " folder
    folder=${folder$(pwd)}

    
    if [ ! -d "$folder" ]; then
        echo "Folder '$folder' does not exist."
        read -p "Press enter to return to the main menu." choice
        return
    fi
    
    echo "Current folder: $folder"
    
    echo "Folders in $folder:"
    ls -l -d "$folder"/*/ | awk '{print NR".",$NF}'
    
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

add_new_folder() {
    folder="1"
    
    read -p "Enter the name of the new folder: " new_folder_name
    
    mkdir "$folder/$new_folder_name"
    
    echo "New folder '$new_folder_name' has been created."
    read -p "Press enter to return to the main menu." choice
}

add_new_file() {
    folder="1"
    
    read -p "Enter the name of the new file: " new_file_name
    
    touch "$folder/$new_file_name"
    
    echo "New file '$new_file_name' has been created."
    read -p "Press enter to return to the main menu." choice
}

move_files() {
    source_folder="1"
    
    read -p "Enter the destination folder to move files to: " destination_folder
    
    if [ ! -d "$destination_folder" ]; then
        echo "Destination folder '$destination_folder' does not exist."
        read -p "Press enter to return to the main menu." choice
        return
    fi
    
    read -p "Enter the file(s) to move (use space to separate multiple files): " files_to_move
    
    mv $files_to_move "$destination_folder"/
    
    echo "Files have been moved to '$destination_folder'."
    read -p "Press enter to return to the main menu." choice
}

copy_files() {
    source_folder="1"
    
    read -p "Enter the destination folder to copy files to: " destination_folder
    
    if [ -z "$destination_folder" ]; then
        echo "Destination folder cannot be empty."
        read -p "Press enter to return to the main menu." choice
        return
    fi
    
    destination_folder="$(echo -e "$destination_folder" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
    
    if [ ! -d "$destination_folder" ]; then
        echo "Destination folder '$destination_folder' does not exist."
        read -p "Press enter to return to the main menu." choice
        return
    fi
    
    read -p "Enter the file(s) to copy (use space to separate multiple files): " files_to_copy
    
    if [ -d "$files_to_copy" ]; then
        cp -r "$files_to_copy" "$destination_folder"/
    else
        cp "$files_to_copy" "$destination_folder"/
    fi
    
    echo "Files have been copied to '$destination_folder'."
    read -p "Press enter to return to the main menu." choice
}

rename_files() {
    folder="1"
    
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

rename_folder() {
    folder="1"
    
    read -p "Enter the folder to rename: " old_name
    
    if [ ! -d "$folder/$old_name" ]; then
        echo "Folder '$old_name' does not exist in the directory '$folder'."
        read -p "Press enter to return to the main menu." choice
        return
    fi
    
    read -p "Enter the new name for the folder '$old_name': " new_name
    
    mv "$folder/$old_name" "$folder/$new_name"
    
    echo "Folder '$old_name' has been renamed to '$new_name'."
    read -p "Press enter to return to the main menu." choice
}

rename_file() {
    folder="$1"
    
    read -p "Enter the file to rename: " old_name
    
    if [ ! -f "$folder/$old_name" ]; then
        echo "File '$old_name' does not exist in the folder '$folder'."
        read -p "Press enter to return to the main menu." choice
        return
    fi
    
    read -p "Enter the new name for the file '$old_name': " new_name
    
    mv "$folder/$old_name" "$folder/$new_name"
    
    echo "File '$old_name' has been renamed to '$new_name'."
    read -p "Press enter to return to the main menu." choice
}

delete_files() {
    folder="1"
    
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

delete_file() {
    folder="1"
    
    read -p "Enter the file to delete: " file_name
    
    if [ ! -f "$folder/$file_name" ]; then
        echo "File '$file_name' does not exist in the folder '$folder'."
        read -p "Press enter to return to the main menu." choice
        return
    fi
    
    rm "$folder/$file_name"
    
    echo "File '$file_name' has been deleted."
    read -p "Press enter to return to the main menu." choice
}

delete_folder() {
    folder="1"
    
    read -p "Enter the folder to delete: " folder_name
    
    if [ ! -d "$folder/$folder_name" ]; then
        echo "Folder '$folder_name' does not exist in the directory '$folder'."
        read -p "Press enter to return to the main menu." choice
        return
    fi
    
    rm -r "$folder/$folder_name"
    
    echo "Folder '$folder_name' and its contents have been deleted."
    read -p "Press enter to return to the main menu." choice
}

sort_files() {
    folder="1"
    
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

sort_by_name() {
    folder="1"
    
    echo "Sorting files in folder '$folder' by name..."
    ls -l "$folder" | sort -k 9
    read -p "Press enter to return to the main menu." choice
}

sort_by_size() {
    folder="1"
    
    echo "Sorting files in folder '$folder' by size..."
    ls -lSh "$folder"
    read -p "Press enter to return to the main menu." choice
}

sort_by_modification_time() {
    folder="$1"
    
    echo "Sorting files in folder '$folder' by modification time..."
    ls -lt "$folder"
    read -p "Press enter to return to the main menu." choice
}

sort_by_file_type() {
    folder="1"
    
    echo "Sorting files in folder '$folder' by file type..."
    ls -l --group-directories-first "$folder"
    read -p "Press enter to return to the main menu." choice
}

system_monitor() {
    if ! command -v iostat &> /dev/null; then
        echo "iostat command not found. Installing sysstat package..."
        
        if [ -x "$(command -v apt-get)" ]; then
            sudo apt-get update
            sudo apt-get install -y sys_stat
        elif [ -x "$(command -v yum)" ]; then
            sudo yum install -y sys_stat
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
                netstat -tul
                ;;
            6)
                echo "Open ports:"
                netstat -tuln | LISTEN
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

BACKUP_DIR="/backups/"

create_backup() {
    clear
    echo "Create Backup"
    
    read -p "Enter the directory to back up: " source_dir
    
    if [ ! -d "$source_dir" ]; then
        echo "Directory '$source_dir' does not exist."
        read -p "Press enter to return to the backup menu." choice
        return
    fi
    
    mkdir -p "$BACKUP_DIR"
    
    timestamp=$(date +%Y%m%d%H%M%S)
    backup_file="$BACKUP_DIR/backup_$timestamp.tar.gz"
    tar -czvf "$backup_file" "$source_dir"
    
    echo "Backup of '$source_dir' created at '$backup_file'."
    read -p "Press enter to return to the backup menu." choice
}

restore_backup() {
    clear
    echo "Restore Backup"
    
    echo "Available backups:"
    ls "$BACKUP_DIR"/backup_*.tar.gz
    
    read -p "Enter the backup file to restore (e.g., backup_20240101123045.tar.gz): " backup_file
    
    if [ ! -f "$BACKUP_DIR/$backup_file" ]; then
        echo "Backup file '$backup_file' does not exist."
        read -p "Press enter to return to the backup menu." choice
        return
    fi
    
    read -p "Enter the directory to restore to: " restore_dir
    
    mkdir -p "$restore_dir"
    
    tar -xzvf "$BACKUP_DIR/$backup_file" -C "$restore_dir"
    
    echo "Backup '$backup_file' restored to '$restore_dir'."
    read -p "Press enter to return to the backup menu." choice
}

list_backups() {
    clear
    echo "List of Available Backups:"
    ls "$BACKUP_DIR"/backup_*.tar.gz
    read -p "Press enter to return to the backup menu." choice
}

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

PASSWORD_FILE="$HOME/passwords.enc"
PASSPHRASE="hack_if_you_can"

encrypt_password() {
    local password="$1"
    echo -n "$password" | openssl enc -aes-256-cbc -pbkdf2 -pass pass:"$PASSPHRASE"
}

decrypt_password() {
    local encrypted_password="$1"
    echo -n "$encrypted_password" | openssl enc -d -aes-256-cbc -pbkdf2 -pass pass:"$PASSPHRASE"
}


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

view_passwords() {
    clear
    echo "View Passwords"
    
    if [ ! -f "$PASSWORD_FILE" ]; then
        echo "No passwords saved."
    else
        while read -r service username encrypted_password; do
            decrypted_password=$(decrypt_password "$encrypted_password")
            echo "Service: $service"
            echo "Username: $username"
            echo "Password: $decrypted_password"
            echo
        done < "$PASSWORD_FILE"
    fi
    
    read -p "Press enter to return to the password manager menu." choice
}


delete_password() {
    clear
    echo "Delete Password"
    
    read -p "Enter the service name to delete: " service
    
    if [ ! -f "$PASSWORD_FILE" ]; then
        echo "No passwords saved."
    else
        grep -v "^$service:" "$PASSWORD_FILE" > "$PASSWORD_FILE.tmp"
        mv "$PASSWORD_FILE.tmp" "$PASSWORD_FILE"
        
        if [ "$(wc -l < "$PASSWORD_FILE")" -lt "$(wc -l < "$PASSWORD_FILE.tmp")" ]; then
            echo "Password for $service deleted."
        else
            echo "No password found for $service."
        fi
    fi
    
    read -p "Press enter to return to the password manager menu." choice
}


update_password() {
    clear
    echo "Update Password"
    
    read -p "Enter the service name to update: " service
    
    if grep  "^$service:" "$PASSWORD_FILE"; then
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
            6) echo "Exiting OS Assistant. Goodbye!"; exit ;;
            *) echo "Invalid choice. Please enter a number between 1 and 15." ;;
        esac
    done
}

main