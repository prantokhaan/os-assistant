#!/bin/bash
# Hospital Management System
# Files to store records
PATIENT_FILE="patients.txt"
APPOINTMENT_FILE="appointments.txt"
STAFF_FILE="staff.txt"
BILL_FILE="bills.txt"
# Function to display the main menu
function main_menu() {
echo "Hospital Management System"
echo "1. Patient Management"
echo "2. Appointment Management"
echo "3. Staff Management"
echo "4. Billing Management"
echo "5. Backup and Restore"
echo "6. Exit"
read -p "Enter your choice: " choice
case $choice in
1) patient_management ;;
2) appointment_management ;;
3) staff_management ;;
4) billing_management ;;
5) backup_restore ;;
6) exit 0 ;;
*) echo "Invalid choice"; main_menu ;;
esac
}
# Patient Management
function patient_management() {
echo "Patient Management"
echo "1. Add Patient"
echo "2. View Patients"
echo "3. Search Patient"
echo "4. Update Patient"
echo "5. Delete Patient"
echo "6. Back to Main Menu"
read -p "Enter your choice: " choice
case $choice in
1) add_patient ;;
2) view_patients ;;
3) search_patient ;;
4) update_patient ;;
5) delete_patient ;;
6) main_menu ;;
*) echo "Invalid choice"; patient_management ;;
esac
}
function add_patient() {
read -p "Enter Patient ID: " id
read -p "Enter Patient Name: " name
read -p "Enter Patient Age: " age
read -p "Enter Patient Gender: " gender
read -p "Enter Patient Disease: " disease
echo "$id|$name|$age|$gender|$disease" >> $PATIENT_FILE
echo "Patient added successfully!"
patient_management
}
function view_patients() {
echo "List of Patients:"
if [ -f $PATIENT_FILE ]; then
column -t -s "|" $PATIENT_FILE
else
echo "No patient records found."
fi
patient_management
}
function search_patient() {
read -p "Enter Patient ID to search: " search_id
if [ -f $PATIENT_FILE ]; then
grep "^$search_id|" $PATIENT_FILE
else
echo "No patient records found."
fi
patient_management
}
function update_patient() {
read -p "Enter Patient ID to update: " update_id
if grep -q "^$update_id|" $PATIENT_FILE; then
sed -i "/^$update_id|/d" $PATIENT_FILE
echo "Enter new details for Patient ID $update_id"
read -p "Enter Patient Name: " name
read -p "Enter Patient Age: " age
read -p "Enter Patient Gender: " gender
read -p "Enter Patient Disease: " disease
echo "$update_id|$name|$age|$gender|$disease" >> $PATIENT_FILE
echo "Patient updated successfully!"
else
echo "Patient ID not found."
fi
patient_management
}
function delete_patient() {
read -p "Enter Patient ID to delete: " delete_id
if grep -q "^$delete_id|" $PATIENT_FILE; then
sed -i "/^$delete_id|/d" $PATIENT_FILE
echo "Patient deleted successfully!"
else
echo "Patient ID not found."
fi
patient_management
}
# Appointment Management
function appointment_management() {
echo "Appointment Management"
echo "1. Schedule Appointment"
echo "2. View Appointments"
echo "3. Cancel Appointment"
echo "4. Update Appointment"
echo "5. Back to Main Menu"
read -p "Enter your choice: " choice
case $choice in
1) schedule_appointment ;;
2) view_appointments ;;
3) cancel_appointment ;;
4) update_appointment ;;
5) main_menu ;;
*) echo "Invalid choice"; appointment_management ;;
esac
}
function schedule_appointment() {
read -p "Enter Appointment ID: " id
read -p "Enter Patient ID: " patient_id
read -p "Enter Appointment Date (YYYY-MM-DD): " date
read -p "Enter Appointment Time (HH:MM): " time
echo "$id|$patient_id|$date|$time" >> $APPOINTMENT_FILE
echo "Appointment scheduled successfully!"
appointment_management
}
function view_appointments() {
echo "List of Appointments:"
if [ -f $APPOINTMENT_FILE ]; then
column -t -s "|" $APPOINTMENT_FILE
else
echo "No appointment records found."
fi
appointment_management
}
function cancel_appointment() {
read -p "Enter Appointment ID to cancel: " cancel_id
if grep -q "^$cancel_id|" $APPOINTMENT_FILE; then
sed -i "/^$cancel_id|/d" $APPOINTMENT_FILE
echo "Appointment cancelled successfully!"
else
echo "Appointment ID not found."
fi
appointment_management
}
function update_appointment() {
read -p "Enter Appointment ID to update: " update_id
if grep -q "^$update_id|" $APPOINTMENT_FILE; then
sed -i "/^$update_id|/d" $APPOINTMENT_FILE
echo "Enter new details for Appointment ID $update_id"
read -p "Enter Patient ID: " patient_id
read -p "Enter Appointment Date (YYYY-MM-DD): " date
read -p "Enter Appointment Time (HH:MM): " time
echo "$update_id|$patient_id|$date|$time" >> $APPOINTMENT_FILE
echo "Appointment updated successfully!"
else
echo "Appointment ID not found."
fi
appointment_management
}
# Staff Management
function staff_management() {
echo "Staff Management"
echo "1. Add Staff"
echo "2. View Staff"
echo "3. Search Staff"
echo "4. Back to Main Menu"
read -p "Enter your choice: " choice
case $choice in
1) add_staff ;;
2) view_staff ;;
3) search_staff ;;
4) main_menu ;;
*) echo "Invalid choice"; staff_management ;;
esac
}
function add_staff() {
read -p "Enter Staff ID: " id
read -p "Enter Staff Name: " name
read -p "Enter Staff Position: " position
read -p "Enter Staff Department: " department
echo "$id|$name|$position|$department" >> $STAFF_FILE
echo "Staff added successfully!"
staff_management
}
function view_staff() {
echo "List of Staff:"
if [ -f $STAFF_FILE ]; then
column -t -s "|" $STAFF_FILE
else
echo "No staff records found."
fi
staff_management
}
function search_staff() {
read -p "Enter Staff ID to search: " search_id
if [ -f $STAFF_FILE ]; then
grep "^$search_id|" $STAFF_FILE
else
echo "No staff records found."
fi
staff_management
}
# Billing Management
function billing_management() {
echo "Billing Management"
echo "1. Generate Bill"
echo "2. View Bills"
echo "3. Search Bill"
echo "4. Back to Main Menu"
read -p "Enter your choice: " choice
case $choice in
1) generate_bill ;;
2) view_bills ;;
3) search_bill ;;
4) main_menu ;;
*) echo "Invalid choice"; billing_management ;;
esac
}
function generate_bill() {
read -p "Enter Bill ID: " bill_id
read -p "Enter Patient ID: " patient_id
read -p "Enter Amount: " amount
read -p "Enter Date (YYYY-MM-DD): " date
echo "$bill_id|$patient_id|$amount|$date" >> $BILL_FILE
echo "Bill generated successfully!"
billing_management
}
function view_bills() {
echo "List of Bills:"
if [ -f $BILL_FILE ]; then
column -t -s "|" $BILL_FILE
else
echo "No bill records found."
fi
billing_management
}
function search_bill() {
read -p "Enter Bill ID to search: " search_id
if [ -f $BILL_FILE ]; then
grep "^$search_id|" $BILL_FILE
else
echo "No bill records found."
fi
billing_management
}
# Backup and Restore
function backup_restore() {
echo "Backup and Restore"
echo "1. Backup Records"
echo "2. Restore Records"
echo "3. Back t