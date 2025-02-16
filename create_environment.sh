#!/bin/bash
#script first asks for users name
read -p "What is your name?" nam
#creating the user directory


mkdir submission_reminder_$nam

#creating sub directories and files
install -D /dev/null /submission_reminder_app_Fadhili-code/submission_reminder_$nam/app/reminder.sh
install -D /dev/null /submission_reminder_app_Fadhili-code/submission_reminder_$nam/modules/functions.sh
install -D /dev/null /submission_reminder_app_Fadhili-code/submission_reminder_$nam/assets/submissions.txt
install -D /dev/null /submission_reminder_app_Fadhili-code/submission_reminder_$nam/config/config.env 
install -D /dev/null /submission_reminder_app_Fadhili-code/submission_reminder_$nam/startup.sh

#pasting wanted content
cat <<EOF > "/submission_reminder_app_Fadhili-code/submission_reminder_$nam/app/reminder.sh"
#!/bin/bash

# Source environment variables and helper functions
source /submission_reminder_app_Fadhili-code/submission_reminder_$nam/config/config.env
source /submission_reminder_app_Fadhili-code/submission_reminder_$nam/modules/functions.sh

# Path to the submissions file
submissions_file="/submission_reminder_app_Fadhili-code/submission_reminder_$nam/assets/submissions.txt"

# Print remaining time and run the reminder function
echo "Assignment:\$ASSIGNMENT"
echo "Days remaining to submit: \$DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions \$submissions_file

EOF
#

cat <<EOF >"/submission_reminder_app_Fadhili-code/submission_reminder_$nam/config/config.env"
# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2

EOF
#

cat <<EOF >"/submission_reminder_app_Fadhili-code/submission_reminder_$nam/modules/functions.sh"
#!/bin/bash

# Function to read submissions file and output students who have not submitted
function check_submissions {
    local submissions_file=\$1
    echo "Checking submissions in \$submissions_file"

    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=\$(echo "\$student" | xargs)
        assignment=\$(echo "\$assignment" | xargs)
        status=\$(echo "\$status" | xargs)

        # Check if assignment matches and status is 'not submitted'
        if [[ "\$assignment" == "\$ASSIGNMENT" && "\$status" == "not submitted" ]]; then
            echo "Reminder: \$student has not submitted the \$ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "\$submissions_file") # Skip the header
}

EOF
#

cat <<EOF >"/submission_reminder_app_Fadhili-code/submission_reminder_$nam/assets/submissions.txt"
student, assignment, submission status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divine, Shell Navigation, not submitted
Anissa, Shell Basics, submitted
Fadhili, Shell Navigation, not submitted
Gumba, Git, submitted
Rowan, Shell Basics, not submitted
Hongo, Git, not submitted
Narotso, Shell Basics, not submitted

EOF
#

cat <<EOF >"/submission_reminder_app_Fadhili-code/submission_reminder_$nam/startup.sh"
#!/bin/bash

# startup.sh - Start the submission reminder application

# Check if the necessary files exist
if [ ! -f "/submission_reminder_app_Fadhili-code/submission_reminder_$nam/config/config.env" ]; then
    echo "Error: config.env not found!"
    exit 1
fi

if [ ! -f "/submission_reminder_app_Fadhili-code/submission_reminder_$nam/modules/functions.sh" ]; then
    echo "Error: functions.sh not found!"
    exit 1
fi

if [ ! -f "/submission_reminder_app_Fadhili-code/submission_reminder_$nam/assets/submissions.txt" ]; then
    echo "Error: submissions.txt not found!"
    exit 1
fi

# Source the configuration file and functions file
source /submission_reminder_app_Fadhili-code/submission_reminder_$nam/config/config.env
source /submission_reminder_app_Fadhili-code/submission_reminder_$nam/modules/functions.sh

# Check if all necessary variables are set
if [ -z "\$ASSIGNMENT" ] || [ -z "\$DAYS_REMAINING" ]; then
    echo "Error: Required environment variables (ASSIGNMENT, DAYS_REMAINING) are not set in config.env"
    exit 1
fi

# Print initial information
echo "===================================="
echo "Starting the Submission Reminder App"
echo "Assignment: \$ASSIGNMENT"
echo "Days remaining to submit: \$DAYS_REMAINING"
echo "===================================="

# Execute the reminder script
./app/reminder.sh

EOF
