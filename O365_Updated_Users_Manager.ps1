<#

.SYNOPSIS
Bulk update user managers in Azure AD/Microsoft Graph

.DESCRIPTION
This script connects to Microsoft Graph and updates the manager for multiple users in bulk.

It prompts for:

Comma separated list of user emails
Manager ID
It then loops through each user, gets their ID, and updates the manager using the Graph API.

.EXAMPLE
Update managers for users john@contoso.com, jane@contoso.com to manager ID 123456789

Enter comma-separated user emails: john@contoso.com, jane@contoso.com
Enter manager id: 123456789

#>

Connect-MgGraph -Scopes "Group.ReadWrite.All,User.ReadWrite.All"

$userEmails = Read-Host -Prompt "Enter comma-separated user emails"
$userEmails = $userEmails.Split(",")
$managerID = Read-Host -Prompt "Enter manager id"

# Get manager ID
$NewManager = @{
  "@odata.id"="https://graph.microsoft.com/v1.0/users/$managerID"
  }


# Update users  
foreach ($userEmail in $userEmails){

  # Get user ID
  $userId = (Get-MgUser -UserId "$userEmail" | Select-Object -ExpandProperty Id)

  # Set manager 
  Set-MgUserManagerByRef -UserId "$userId" -BodyParameter $NewManager

}

Disconnect-MgGraph
