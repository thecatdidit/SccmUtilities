# 
# NAME
#     Invoke-CMRequestMachinePolicyAssignments
#     
# SYNOPSIS
#     Short description
#     
#     
# SYNTAX
#     Invoke-CMRequestMachinePolicyAssignments [-computername] <Object> [-Path] <Object> [[-credential] <PSCredential>] 
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
#     To see the examples, type: "get-help Invoke-CMRequestMachinePolicyAssignments -examples".
#     For more information, type: "get-help Invoke-CMRequestMachinePolicyAssignments -detailed".
#     For technical information, type: "get-help Invoke-CMRequestMachinePolicyAssignments -full".
# 
# 
# 
function Invoke-CMRequestMachinePolicyAssignments 
{

    param([Parameter(Mandatory=$true)]$computername, 
    [Parameter(Mandatory=$true)]$Path = 'c:\windows\ccm\logs',
            [pscredential]$credential)
    $Sccmhash = New-CMSccmTriggerHashTable
    if(Test-CCMLocalMachine $computername)
    {
        $TimeReference =(get-date)
    }
    else
    {
        $TimeReference = invoke-command -ComputerName $computername -scriptblock {get-date} -credential $credential
    }
    if($credentials)
    {
        Invoke-WmiMethod -Class sms_client -Namespace 'root\ccm' -ComputerName $computername -credential $credential -Name TriggerSchedule -ArgumentList "$($Sccmhash["RequestMachinePolicyAssignments"])" 
    }
    else
    {
        $SmsClient =[wmiclass]("\\$ComputerName\ROOT\ccm:SMS_Client")
        $SmsClient.TriggerSchedule($Sccmhash["RequestMachinePolicyAssignments"])
    }
    $RequestMachinePolicyAssignments = $false
   
    # can see when this is requested from the Policy agentlog:
    $RequestMachinePolicyAssignments = Test-CMRequestMachinePolicyAssignments -computername $computername -Path $Path -TimeReference $TimeReference -credential $credential
    
    [PSCustomObject]@{'RequestMachinePolicyAssignments' = $RequestMachinePolicyAssignments
                      'TimeReference' = ($TimeReference)}


}
