<#

.SYNOPSIS
Creates multiple shared mailboxes in Exchange Online

.DESCRIPTION
This script connects to Exchange Online and creates multiple shared mailboxes based on user input.

It first prompts for the admin credentials to connect to Exchange Online.

It then loops prompting for the display name and primary SMTP address for each mailbox to create.

These details are stored in an array.

Finally, it loops through the array, creating a shared mailbox for each entry using the New-Mailbox cmdlet.

.EXAMPLE
Create 2 shared mailboxes:

Display Name: Sales Mailbox

Email: sales@contoso.com

Display Name: Support Mailbox
Email: support@contoso.com

#>

# Connect to Exchange Online
$s1 = Read-Host -Prompt "Enter your email to login to Exchange Online" 
Connect-ExchangeOnline -UserPrincipalName $s1

# Array to store mailbox details 
$mailboxes = @()

# Loop to gather info for each mailbox
Do {

    $displayName = Read-Host -Prompt "Enter display name for shared mailbox"
    
    $smtpAddress = Read-Host -Prompt "Enter primary SMTP address for shared mailbox" 

    # Add to array 
    $mailboxes += [PSCustomObject]@{
        DisplayName = $displayName
        SmtpAddress = $smtpAddress
    }

    $another = Read-Host -Prompt "Add another mailbox? (Y/N)"
} While ($another -eq 'y') 

# Loop to create the mailboxes
foreach ($mailbox in $mailboxes) {

    New-Mailbox -Shared -Name $mailbox.SmtpAddress -DisplayName $mailbox.DisplayName -PrimarySmtpAddress $mailbox.SmtpAddress

}