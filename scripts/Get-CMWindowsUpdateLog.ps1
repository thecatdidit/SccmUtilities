# 
# NAME
#     Get-CMWindowsUpdateLog
#     
# SYNOPSIS
#     Short description
#     
#     
# SYNTAX
#     Get-CMWindowsUpdateLog [-ComputerName <Object>] -Days <Int32> [-Component <String>] [-Text <String>] 
#     [<CommonParameters>]
#     
#     Get-CMWindowsUpdateLog [-ComputerName <Object>] [-GroupBy <Object>] [<CommonParameters>]
#     
#     
# DESCRIPTION
#     Long description
#     
# 
# RELATED LINKS
# 
# REMARKS
#     To see the examples, type: "get-help Get-CMWindowsUpdateLog -examples".
#     For more information, type: "get-help Get-CMWindowsUpdateLog -detailed".
#     For technical information, type: "get-help Get-CMWindowsUpdateLog -full".
# 
# 
# 
function Get-CMWindowsUpdateLog 
{

    [CmdletBinding()]
    param
        (
        [Parameter(Mandatory=$False,ValueFromPipeline=$true,HelpMessage="The target computer name")]
            [ValidateScript({Test-Connection -ComputerName $_ -Count 2})]
            $ComputerName = $env:ComputerName,
        [Parameter(ParameterSetName='Default',Mandatory=$True)]
            [int]$Days = 90,
        [Parameter(ParameterSetName='Default',Mandatory=$False)]
            [ValidateSet("*","Agent","AU","AUCLNT","CDM","Content Download","Content Install","CMPRESS","COMAPI","DRIVER","DTASTOR","DWNLDMGR","DnldMgr","EEHNDLER","EP","HANDLER","IdleTmr","MISC","OFFLSNC","PASRER","Pre-Deployment Check","PT","RebootNotify","REPORT","SERVICE","SETUP","SHUTDWN","SLS","Software Synchronization","WS","WUREDIR","WUWEB","WuTask")]
            [string]$Component,
        [Parameter(ParameterSetName='Default',Mandatory=$False)]
            [string]$Text = "",
        [Parameter(ParameterSetName='byGroup',Mandatory=$False)]
            [ValidateSet("Component","Date")]
            $GroupBy
        )

if (!$Component)
    {$Component = "*"}
if (!$Days)
    {$Days = 90}

$Days --
$DateF = (Get-date).AddDays(-$Days) | get-date -Format yyyy-MM-dd

$Command = {
param($DateF,$Component,$Text,$GroupBy)
$log = Get-Content $env:windir\windowsupdate.log | ConvertTo-Xml -NoTypeInformation 
$result = $log.Objects.Object | Where-Object {$_ -match "`t$Component`t" -and $_ -gt $DateF -and $_ -match "$text"} | ForEach-Object {
    $Count = $_.Split("`t").Count
    New-Object -TypeName PSObject -Property @{
        Date = $_.Split("`t") | Select-Object -Index 0
        Time = $_.Split("`t") | Select-Object -Index 1
        Component = $_.Split("`t") | Select-Object -Index ($count -2)
        Details = $_.Split("`t") | Select-Object -Index ($count -1)
        }
    }
if ($GroupBy -eq "Component")
    {$Result.Component | Group-Object -NoElement}
if ($GroupBy -eq "Date")
    {$Result.Date | Group-Object -NoElement}
if (!$GroupBy)
    {$Result}
}

if ($ComputerName -eq $env:ComputerName)
    {Invoke-Command -ArgumentList $DateF,$Component,$Text,$GroupBy -ScriptBlock $Command}
Else {
    If ($GroupBy)
        {Invoke-Command -ComputerName $ComputerName -ArgumentList $DateF,$Component,$Text,$GroupBy -ScriptBlock $Command | Select-Object Count,Name}
    If (!$GroupBy)
        {Invoke-Command -ComputerName $ComputerName -ArgumentList $DateF,$Component,$Text,$GroupBy -ScriptBlock $Command | Select-Object Date,Time,Component,Details}
    }


}
