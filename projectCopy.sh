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

# Function for user management
user_management() {
    clear
    echo "User Management"
    echo "1. Add a user"
    echo "2. Delete a user"
    echo "3. List users"
    echo "4. Sort users by name"
    echo "5. Sort users by permission"
    echo "6. View all users' permissions"
    echo "7. View specific user's permissions"
    echo "8. Change user permissions"
    echo "9. Return to main menu"
    read -p "Choose an option [1-9]: " option

    case $option in
        1)
            read -p "Enter username to add: " username
            sudo useradd "$username" && echo "User $username added successfully." || echo "Failed to add user $username."
            ;;
        2)
            read -p "Enter username to delete: " username
            sudo userdel -r "$username" && echo "User $username deleted successfully." || echo "Failed to delete user $username."
            ;;
        3)
            echo "Current users on the system:"
            cut -d: -f1 /etc/passwd
            ;;
        4)
            echo "Users sorted by name:"
            cut -d: -f1 /etc/passwd | sort
            ;;
        5)
            echo "Users sorted by permission (UID):"
            awk -F: '{print $1, $3}' /etc/passwd | sort -k2n
            ;;
        6)
            echo "All users' permissions (UID, GID, Home Directory, Shell):"
            awk -F: '{print "User:", $1, "UID:", $3, "GID:", $4, "Home Directory:", $6, "Shell:", $7}' /etc/passwd
            ;;
        7)
            read -p "Enter username to view permissions: " username
            user_info=$(getent passwd "$username")
            if [ -n "$user_info" ]; then
                IFS=: read -r _ _ uid gid _ home shell <<< "$user_info"
                echo "User: $username"
                echo "UID: $uid"
                echo "GID: $gid"
                echo "Home Directory: $home"
                echo "Shell: $shell"
            else
                echo "User $username does not exist."
            fi
            ;;
        8)
            read -p "Enter username to change permissions: " username
            read -p "Enter new UID: " uid
            read -p "Enter new GID: " gid
            sudo usermod -u "$uid" -g "$gid" "$username" && echo "Permissions for user $username changed successfully." || echo "Failed to change permissions for user $username."
            ;;
        9)
            return
            ;;
        *)
            echo "Invalid option. Please choose a valid option."
            ;;
    esac

    read -p "Press enter to return to the main menu." choice
}



# Function for system maintenance
system_maintenance() {
    clear
    echo "System Maintenance"
    echo "1. Update the system"
    echo "2. Clean up unused packages"
    echo "3. View running processes"
    echo "4. Reboot the system"
    echo "5. Check system load"
    echo "6. Check available updates"
    echo "7. Check system memory usage"
    echo "8. View system logs"
    echo "9. Return to main menu"
    read -p "Choose an option [1-9]: " option

    case $option in
        1)
            echo "Updating the system..."
            sudo apt update && sudo apt upgrade -y
            echo "System updated successfully."
            ;;
        2)
            echo "Cleaning up unused packages..."
            sudo apt autoremove -y && sudo apt autoclean
            echo "Unused packages cleaned up successfully."
            ;;
        3)
            echo "Viewing running processes..."
            ps aux
            ;;
        4)
            read -p "Are you sure you want to reboot the system? (y/n): " confirm
            if [ "$confirm" = "y" ]; then
                echo "Rebooting the system..."
                sudo reboot
            else
                echo "Reboot cancelled."
            fi
            ;;
        5)
            echo "Checking system load..."
            uptime
            ;;
        6)
            echo "Checking available updates..."
            sudo apt update
            apt list --upgradable
            ;;
        7)
            echo "Checking system memory usage..."
            free -h
            ;;
        8)
            echo "Viewing system logs..."
            sudo journalctl -xe
            ;;
        9)
            return
            ;;
        *)
            echo "Invalid option. Please choose a valid option."
            ;;
    esac

    read -p "Press enter to return to the main menu." choice
}




# Function for software installation
software_installation() {
    clear
    echo "Software Installation"
    echo "1. Install a software package"
    echo "2. Search for available packages"
    echo "3. List installed packages"
    echo "4. Remove a software package"
    echo "5. Update package lists"
    echo "6. Upgrade installed packages"
    echo "7. Return to main menu"
    read -p "Choose an option [1-7]: " option

    case $option in
        1)
            read -p "Enter the name of the package to install: " package_name
            sudo apt install "$package_name" && echo "Package $package_name installed successfully." || echo "Failed to install package $package_name."
            ;;
        2)
            read -p "Enter the search keyword: " keyword
            apt search "$keyword"
            ;;
        3)
            echo "List of installed packages:"
            dpkg -l
            ;;
        4)
            read -p "Enter the name of the package to remove: " package_name
            sudo apt remove "$package_name" && echo "Package $package_name removed successfully." || echo "Failed to remove package $package_name."
            ;;
        5)
            echo "Updating package lists..."
            sudo apt update
            ;;
        6)
            echo "Upgrading installed packages..."
            sudo apt upgrade
            ;;
        7)
            return
            ;;
        *)
            echo "Invalid option. Please choose a valid option."
            ;;
    esac

    read -p "Press enter to return to the main menu." choice
}


# Function for disk management
disk_management() {
    clear
    echo "Disk Management"
    echo "1. View disk usage"
    echo "2. List partitions"
    echo "3. Format a partition"
    echo "4. Mount a partition"
    echo "5. Unmount a partition"
    echo "6. Return to main menu"
    read -p "Choose an option [1-6]: " option

    case $option in
        1)
            echo "Disk usage:"
            df -h
            ;;
        2)
            echo "List of partitions:"
            lsblk
            ;;
        3)
            read -p "Enter the partition to format (e.g., /dev/sdb1): " partition
            sudo mkfs.ext4 "$partition" && echo "Partition $partition formatted successfully." || echo "Failed to format partition $partition."
            ;;
        4)
            read -p "Enter the partition to mount (e.g., /dev/sdb1): " partition
            read -p "Enter the mount point: " mount_point
            sudo mount "$partition" "$mount_point" && echo "Partition $partition mounted at $mount_point." || echo "Failed to mount partition $partition."
            ;;
        5)
            read -p "Enter the partition to unmount (e.g., /dev/sdb1): " partition
            sudo umount "$partition" && echo "Partition $partition unmounted successfully." || echo "Failed to unmount partition $partition."
            ;;
        6)
            return
            ;;
        *)
            echo "Invalid option. Please choose a valid option."
            ;;
    esac

    read -p "Press enter to return to the main menu." choice
}




# Function for system information
system_information() {
    clear
    echo "System Information"
    echo "1. Display system information"
    echo "2. Display CPU information"
    echo "3. Display memory information"
    echo "4. Display disk information"
    echo "5. Display network information"
    echo "6. Return to main menu"
    read -p "Choose an option [1-6]: " option

    case $option in
        1)
            echo "System Information:"
            uname -a
            ;;
        2)
            echo "CPU Information:"
            lscpu
            ;;
        3)
            echo "Memory Information:"
            free -h
            ;;
        4)
            echo "Disk Information:"
            df -h
            ;;
        5)
            echo "Network Information:"
            ip addr show
            ;;
        6)
            return
            ;;
        *)
            echo "Invalid option. Please choose a valid option."
            ;;
    esac

    read -p "Press enter to return to the main menu." choice
}

service_management() {
    clear
    echo "Service Management"
    echo "1. Start a service"
    echo "2. Stop a service"
    echo "3. Restart a service"
    echo "4. Enable a service"
    echo "5. Disable a service"
    echo "6. Return to main menu"
    read -p "Choose an option [1-6]: " option

    case $option in
        1)
            read -p "Enter the name of the service to start: " service_name
            sudo systemctl start "$service_name" && echo "Service $service_name started successfully." || echo "Failed to start service $service_name."
            ;;
        2)
            read -p "Enter the name of the service to stop: " service_name
            sudo systemctl stop "$service_name" && echo "Service $service_name stopped successfully." || echo "Failed to stop service $service_name."
            ;;
        3)
            read -p "Enter the name of the service to restart: " service_name
            sudo systemctl restart "$service_name" && echo "Service $service_name restarted successfully." || echo "Failed to restart service $service_name."
            ;;
        4)
            read -p "Enter the name of the service to enable: " service_name
            sudo systemctl enable "$service_name" && echo "Service $service_name enabled successfully." || echo "Failed to enable service $service_name."
            ;;
        5)
            read -p "Enter the name of the service to disable: " service_name
            sudo systemctl disable "$service_name" && echo "Service $service_name disabled successfully." || echo "Failed to disable service $service_name."
            ;;
        6)
            return
            ;;
        *)
            echo "Invalid option. Please choose a valid option."
            ;;
    esac

    read -p "Press enter to return to the main menu." choice
}

system_benchmarking() {
    clear
    echo "System Benchmarking"
    echo "1. CPU Benchmark"
    echo "2. Memory Benchmark"
    echo "3. Disk Benchmark"
    echo "4. Network Benchmark"
    echo "5. Return to main menu"
    read -p "Choose an option [1-5]: " option

    case $option in
        1)
            echo "Running CPU benchmark..."
            sysbench cpu --time=10 run
            ;;
        2)
            echo "Running memory benchmark..."
            sysbench memory --time=10 run
            ;;
        3)
            echo "Running disk benchmark..."
            sudo fio --name=randwrite --ioengine=posixaio --rw=randwrite --bs=4k --numjobs=4 --size=4G --runtime=60 --group_reporting
            ;;
        4)
            echo "Running network benchmark..."
            speedtest-cli
            ;;
        5)
            return
            ;;
        *)
            echo "Invalid option. Please choose a valid option."
            ;;
    esac

    read -p "Press enter to return to the main menu." choice
}