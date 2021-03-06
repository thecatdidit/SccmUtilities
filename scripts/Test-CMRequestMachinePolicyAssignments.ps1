# 
# NAME
#     Test-CMRequestMachinePolicyAssignments
#     
# SYNOPSIS
#     Short description
#     
#     
# SYNTAX
#     Test-CMRequestMachinePolicyAssignments [-computername] <Object> [-Path] <Object> [[-TimeReference] <DateTime>] 
#     [[-credential] <PSCredential>] [<CommonParameters>]
#     
#     
# DESCRIPTION
#     Long description
#     
# 
# RELATED LINKS
# 
# REMARKS
#     To see the examples, type: "get-help Test-CMRequestMachinePolicyAssignments -examples".
#     For more information, type: "get-help Test-CMRequestMachinePolicyAssignments -detailed".
#     For technical information, type: "get-help Test-CMRequestMachinePolicyAssignments -full".
# 
# 
# 
function Test-CMRequestMachinePolicyAssignments 
{

    param([Parameter(Mandatory=$true)]$computername, 
    [Parameter(Mandatory=$true)]$Path = 'c:\windows\ccm\logs'
    ,[datetime]$TimeReference,
    [pscredential] $credential)
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
    $RequestMachinePolicyAssignments = $false
    # can see when this is requested from the Policy agentlog:
    Push-Location
    Set-Location c:
    if(Test-CCMLocalMachine $computername)
    {
        $p = Get-CMLog -path "$path\policyevaluator.log"
        $runResults = $P |Where-Object{$_.Localtime -gt $TimeReference} | where-object {$_.message -like "*Evaluation not required. No changes detected.*"}
    }
    else
    {
        $p = Get-CCMLog -ComputerName $computerName -path $Path -log policyevaluator -credential $credential
        $runResults = $P.policyevaluatorLog |Where-Object{$_.Localtime -gt $TimeReference} | where-object {$_.message -like "*Evaluation not required. No changes detected.*"}
    }
    Pop-Location
    #if in the 
    
        if($runResults)
        {
            $RequestMachinePolicyAssignments = $true
        }
    $RequestMachinePolicyAssignments


}
