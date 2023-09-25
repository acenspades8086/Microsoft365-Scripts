# Add the specified user to multiple O365 groups.
$UserCredential = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection

# Import the session and suppress the warning about implicit remoting
Import-PSSession $Session -DisableNameChecking

# Specify the user's email address
$UserEmail = "USER'S_EMAIL"

# Specify the file path containing group names
$GroupsFilePath = "FILEPATH"

# Read the list of group names from the file
$GroupNames = Get-Content $GroupsFilePath

# Loop through each group and add the user
foreach ($GroupName in $GroupNames) {
    try {
        # Add the user to the group
        Add-UnifiedGroupLinks -Identity $GroupName -LinkType Members -Links $UserEmail -Confirm:$false
        Write-Host "User $UserEmail added to group $GroupName successfully."
    } catch {
        Write-Host "Error adding user $UserEmail to group $GroupName: $_"
    }
}

# Remove the session when done
Remove-PSSession $Session
