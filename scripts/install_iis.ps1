<powershell>

# Enable IIS
Install-WindowsFeature -name Web-Server -IncludeManagementTools

# Optional: Install ASP.NET & .NET Framework Features
Install-WindowsFeature Web-Asp-Net45

# Download .NET Core Hosting Bundle (change version if needed)
$dotnetBundle = "https://download.visualstudio.microsoft.com/download/pr/dbee4de5-19d9-4974-8ce5-e1850edff689/01da2fd38e5b275cf4ff6c84df9e1f58/dotnet-hosting-6.0.27-win.exe"
$output = "C:\Temp\dotnet-hosting.exe"

New-Item -Path "C:\Temp" -ItemType Directory -Force
Invoke-WebRequest $dotnetBundle -OutFile $output

# Install silently
Start-Process -FilePath $output -ArgumentList "/quiet" -Wait

# Restart IIS
iisreset

</powershell>

