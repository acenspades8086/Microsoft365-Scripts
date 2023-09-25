<#
.SYNOPSIS
Removes user permissions from shared mailboxes in Exchange Online.

.DESCRIPTION
This script connects to Exchange Online and removes Send As and Full Access
permissions for a user from multiple shared mailboxes.

It prompts for admin credentials to connect to Exchange Online.

It then prompts for the email address(es) of the user(s) to remove.
Multiple emails can be entered separated by commas.

The emails are split into an array and trimmed.

It loops through the email array, removing FullAccess and SendAs rights

from the specified shared mailboxes using the Remove-MailboxPermission
and Remove-RecipientPermission cmdlets.

.EXAMPLE
Remove access for user john@domain.com from SharedMailbox1 and SharedMailbox2

.EXAMPLE
Remove access for users john@domain.com, jane@domain.com from the mailboxes

#>

# Prompt for admin login
$admin = Read-Host -Prompt "Enter your email to login to Exchange Online"

# Connect to Exchange Online
Connect-ExchangeOnline -UserPrincipalName $admin

Write-Host "Removing user to ALL Mailboxes" -ForegroundColor Green
$s1 = Read-Host -Prompt "Enter the users email or a comma-separated list of email Removeresses."

# split and remove leading/trailing spaces
$emails = $s1 -split ","
$emails = $emails.Trim()
if ($emails.Length -eq 0) {
  Write-Host "No email Removeresses entered"
  exit
}

# Loop through emails array to Remove permissions
foreach ($email in $emails) {

    Remove-MailboxPermission -Identity "SHARED_MAILBOX1" -User "$email" -AccessRights FullAccess -InheritanceType All
    Remove-RecipientPermission SHARED_MAILBOX1 -Trustee $email -AccessRights SendAs -Confirm:$False

    Remove-MailboxPermission -Identity "SHARED_MAILBOX2" -User "$email" -AccessRights FullAccess -InheritanceType All
    Remove-RecipientPermission SHARED_MAILBOX2 -Trustee $email -AccessRights SendAs -Confirm:$False

}