$folders = @(
    "Floww.Services.ExchangeRates"
    "Floww.Services.Accounts", 
    "Floww.Services.Companies",
    "Floww.Services.Funds",
    "Floww.Services.Users", 
    "Floww.Services.Documents",
    "Floww.Services.Api",
    "Floww.Libraries",
    "Floww.Libraries.MassTransit",
    "Floww.Libraries.Remoting",
    "Floww.Libraries.Services",
    "Floww.Services.BackOffice.Companies",
    "Floww.Services.BackOffice.Content",
    "Floww.Services.BackOffice.Tenants",
    "Floww.Services.BackOffice.Users"
)

Write-Host "Starting"

$root = "C:\Git"
$packages = @( 
    @{name = "Floww.Libraries.Common"; version = "1.5.100456236-beta-steve" },
    @{name = "Floww.Libraries.Files"; version = "1.5.100456236-beta-steve" } 
    @{name = "Floww.Libraries.Remoting"; version = "1.1.100456239-beta-steve" } 
    @{name = "Floww.Libraries.MassTransit"; version = "1.4.100456240-beta-steve" }); 

foreach ($folder in $folders) {
    Set-Location -Path "$root\$folder"
    
    $configFiles = Get-ChildItem  "$root\$folder" *.csproj -Recurse -Depth 6
    foreach ($filePath in $configFiles) {
        Write-Host "Processing $filePath"
        Write-Host ""
        
        foreach ($package in $packages) {
            Write-Host "Applying replace for package name $($package.name)" $package.name $package.version
            $content = (Get-Content -Path $filePath.FullName -Raw) 
            $content = $content -replace "<PackageReference Include=`"$($package.name)`" Version=`"(.*)`" />", "<PackageReference Include=`"$($package.name)`" Version=`"$($package.version)`" />";
            Set-Content -Path $filePath.FullName -Value $content;
        }
    }
}
