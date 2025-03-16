$managed_favorites = @{
    toplevel_name = "Company Support"
},
@{
    children = 
    @{
        name = "Teams"
        url = "https://teams.microsoft.com/v2"
    },
    @{
        name = "Outlook"
        url = "https://outlook.office.com/mail/"
    },
    @{
        name = "Report"
        url = "URL"
    },
    @{
        name = "Time Sheet"
        url = "URL"
    }
    name = "Company Team"
},
@{
    children = 
    @{
        name = "Workspace"
        url = "https://myworkspace.com/"
    },
    @{
        name = "Google"
        url = "https://www.google.co.in/"
    }
    name = "Support URL"
} | ConvertTo-JSON -depth 4 -Compress

$settings = 
[PSCustomObject]@{
    Path  = "SOFTWARE\Policies\Microsoft\Edge"
    Value = $managed_favorites
    Name  = "ManagedFavorites"
} | group Path

foreach($setting in $settings){
    $registry = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey($setting.Name, $true)
    if ($null -eq $registry) {
        $registry = [Microsoft.Win32.Registry]::LocalMachine.CreateSubKey($setting.Name, $true)
    }
    $setting.Group | %{
        $registry.SetValue($_.name, $_.value)
    }
    $registry.Dispose()
}