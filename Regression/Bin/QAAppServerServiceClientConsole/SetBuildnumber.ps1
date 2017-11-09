Param(
    [string] $BuildNumber
)
$AllValues=Get-ItemProperty "hklm:\SOFTWARE\Wow6432Node\Elviz ETRM\InstallInfo\"
$version=$AllValues.ELVIZVERSION
Write-Verbose -Verbose "##vso[build.updatebuildnumber]$version$BuildNumber"