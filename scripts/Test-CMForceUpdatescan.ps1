# 
# NAME
#     Test-CMForceUpdatescan
#     
# SYNOPSIS
#     Short description
#     
#     
# SYNTAX
#     Test-CMForceUpdatescan [-computername] <Object> [[-TimeReference] <DateTime>] [[-credential] <PSCredential>] 
#     [<CommonParameters>]
#     
#     
# DESCRIPTION
#     Long description
#     
# 
# RELATED LINKS
# 
# REMARKS
#     To see the examples, type: "get-help Test-CMForceUpdatescan -examples".
#     For more information, type: "get-help Test-CMForceUpdatescan -detailed".
#     For technical information, type: "get-help Test-CMForceUpdatescan -full".
# 
# 
# 
function Test-CMForceUpdatescan 
{

    param([Parameter(Mandatory=$true)]$computername, [datetime] $TimeReference = $null,
            [pscredential]$credential)
    
    if ($TimeReference -eq $null)
    {
        if(Test-CCMLocalMachine $computername)
        {
            $TimeReference = (get-date)
        }
        else
        {
        $TimeReference = invoke-command -ComputerName $computername -scriptblock {get-date} -Credential $credential
        }
    }
    #When the scan is done you'll get a completion time close to when you isseud the command
    $TimeReferenceEnd = $forceupdateScan =  $false
    if(Test-CCMLocalMachine $computer)
    {
           $TimeReferenceEnd = Get-WmiObject -Namespace root\ccm\scanagent -Query "select LastCompletionTime from CCM_ScanUpdateSourceHistory" | ForEach-Object{ [management.managementDateTimeConverter]::ToDateTime($_.LastCompletionTime) }
    }
    else
    {
        $TimeReferenceEnd = Get-WmiObject -ComputerName $computerName  -Namespace root\ccm\scanagent -Query "select LastCompletionTime from CCM_ScanUpdateSourceHistory"  -credential $credential| ForEach-Object{ [management.managementDateTimeConverter]::ToDateTime($_.LastCompletionTime) }
    }
    if($TimeReferenceEnd -gt $TimeReference)
    { $forceupdateScan = $true} 
    $forceupdateScan


}
