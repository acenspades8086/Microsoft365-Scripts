<#
.SYNOPSIS
Adds user permissions to shared mailboxes in Exchange Online

.DESCRIPTION

This script connects to Exchange Online and adds Send As and Full Access
permissions for a user to multiple shared mailboxes.

It prompts for admin credentials to connect to Exchange Online.

It then prompts for the email address(es) of the user(s) to add.
Multiple emails can be entered separated by commas.

The emails are split into an array and trimmed.

It loops through the email array, adding FullAccess and SendAs rights
to the specified shared mailboxes using the Add-MailboxPermission and
Add-RecipientPermission cmdlets.

.EXAMPLE
Add user john@domain.com with access to SharedMailbox1 and SharedMailbox2

.EXAMPLE

Add users john@domain.com, jane@domain.com access to the mailboxes

#>
# Prompt for admin login
$admin = Read-Host -Prompt "Enter your email to login to Exchange Online"

# Connect to Exchange Online
Connect-ExchangeOnline -UserPrincipalName $admin

Write-Host "Adding user to ALL Mailboxes" -ForegroundColor Green
$s1 = Read-Host -Prompt "Enter the users email or a comma-separated list of email addresses."

# split and remove leading/trailing spaces
$emails = $s1 -split ","
$emails = $emails.Trim()
if ($emails.Length -eq 0) {
  Write-Host "No email addresses entered"
  exit
}

# Loop through emails array to add permissions
foreach ($email in $emails) {

    Add-MailboxPermission -Identity "SHARED_MAILBOX1" -User "$email" -AccessRights FullAccess -InheritanceType All
    Add-RecipientPermission SHARED_MAILBOX1 -Trustee $email -AccessRights SendAs -Confirm:$False

    Add-MailboxPermission -Identity "SHAREDMAILBOX2" -User "$email" -AccessRights FullAccess -InheritanceType All
    Add-RecipientPermission SHARED_MAILBOX2 -Trustee $email -AccessRights SendAs -Confirm:$False
}