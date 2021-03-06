# 
# NAME
#     Test-CMSoftwareUpdatesAgentAssignmentEvaluationCycle
#     
# SYNOPSIS
#     Short description
#     
#     
# SYNTAX
#     Test-CMSoftwareUpdatesAgentAssignmentEvaluationCycle [-computername] <Object> [-path] <Object> [[-TimeReference] 
#     <Object>] [[-credential] <PSCredential>] [<CommonParameters>]
#     
#     
# DESCRIPTION
#     Long description
#     
# 
# RELATED LINKS
# 
# REMARKS
#     To see the examples, type: "get-help Test-CMSoftwareUpdatesAgentAssignmentEvaluationCycle -examples".
#     For more information, type: "get-help Test-CMSoftwareUpdatesAgentAssignmentEvaluationCycle -detailed".
#     For technical information, type: "get-help Test-CMSoftwareUpdatesAgentAssignmentEvaluationCycle -full".
# 
# 
# 
function Test-CMSoftwareUpdatesAgentAssignmentEvaluationCycle 
{

    param([Parameter(Mandatory=$true)]$computername,
    [Parameter(Mandatory=$true)]$path ='c:\windows\ccm\logs',
    $TimeReference = $null,
    [pscredential]$credential )
    if ($TimeReference -eq $null)
    {
        if(Test-CCMLocalMachine $computername)
        {
            $TimeReference =(get-date)
        }
        else
        {
            [datetime]$TimeReference = invoke-command -ComputerName $computername -scriptblock {get-date}
        }
    }
    $SoftwareUpdatesAgentAssignmentEvaluationCycle = $false
    $Sccmhash = New-CMSccmTriggerHashTable
    Push-Location
    Set-Location c:
    if(Test-CCMLocalMachine $computername)
    {
        $SmsClientMethodProvider = Get-CMLog -path "$path\SmsClientMethodProvider.log"
        $RunObject = $SmsClientMethodProvider | Where-Object{$_.Localtime -gt $TimeReference} | where-object {$_.message -like "*$($Sccmhash["SoftwareUpdatesAgentAssignmentEvaluationCycle"])*" }
        $results = $SmsClientMethodProvider | where-object{$_.runspaceid -eq $RunObject.runspaceid} | Where-Object{$_.Localtime -gt $TimeReference}
    
    }
    else
    {
        $SmsClientMethodProvider = Get-CCMLog -ComputerName $computerName -path $path  -log SmsClientMethodProvider -credential $credential
        $RunObject = $SmsClientMethodProvider.SmsClientMethodProviderLog | Where-Object{$_.Localtime -gt $TimeReference} | where-object {$_.message -like "*$($Sccmhash["SoftwareUpdatesAgentAssignmentEvaluationCycle"])*" }
        $results = $SmsClientMethodProvider.SmsClientMethodProviderLog | where-object{$_.runspaceid -eq $RunObject.runspaceid} | Where-Object{$_.Localtime -gt $TimeReference}
    
    }
    Pop-Location
    If($results | Where-Object{$_.message -eq 'Schedule successfully sent.'})
    {
        $SoftwareUpdatesAgentAssignmentEvaluationCycle =$true
    }
    $SoftwareUpdatesAgentAssignmentEvaluationCycle


}
