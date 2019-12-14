<# Add the specified user to multiple O365 groups. #>
$UserCredential = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $Session
foreach($group in (get-content "C:\Users\wyatt.mickelsen\Downloads\groups.txt")){
    Add-UnifiedGroupLinks -Identity "$group" -LinkType Members -Links jasenh@safelinkinternet.com
}
