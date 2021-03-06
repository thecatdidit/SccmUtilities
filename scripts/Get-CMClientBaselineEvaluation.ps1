# 
# NAME
#     Get-CMClientBaselineEvaluation
#     
# SYNOPSIS
#     Get the status of Configuration Manager client configuration baselines.
#     
#     
# SYNTAX
#     Get-CMClientBaselineEvaluation [[-ComputerName] <String[]>] [-credential <PSCredential>] [<CommonParameters>]
#     
#     
# DESCRIPTION
#     Get the status of Configuration Manager client configuration baselines.
#     
# 
# RELATED LINKS
# 
# REMARKS
#     To see the examples, type: "get-help Get-CMClientBaselineEvaluation -examples".
#     For more information, type: "get-help Get-CMClientBaselineEvaluation -detailed".
#     For technical information, type: "get-help Get-CMClientBaselineEvaluation -full".
# 
# 
# 
function Get-CMClientBaselineEvaluation 
{

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false,
                   ValueFromPipelineByPropertyName=$true,
                   ValueFromPipeline=$true,
                   Position=0)]
        [string[]]$ComputerName=$env:ComputerName,
        [pscredential]$credential
    )
    begin {
        $ComplianceHash = [hashtable]@{
                                "0" = 'Non-Compliant'
                                "1" = 'Compliant'
                                "2" = 'Submitted'
                                "3" = 'Unknown'
                                "4" = 'Detecting'
                                "5" = 'Not Evaluated'                  
                        }  
        $EvalHash = [hashtable]@{
                                "0" = 'Idle'
                                "1" = 'Evaluated'
                                "5" = 'Not Evaluated'                                   
                        } 
    
        }
    process {
        foreach ($Computer in $ComputerName) {
            # Get a list of baseline objects assigned to the remote computer
            if(Test-CCMLocalMachine $computer)
            {
                $Baselines = Get-WmiObject -ComputerName $Computer -Namespace root\ccm\dcm -Class SMS_DesiredConfiguration 
            }
            else
            {
                $Baselines = Get-WmiObject -ComputerName $Computer -Namespace root\ccm\dcm -Class SMS_DesiredConfiguration -credential $credential
            }

            # For each (%) baseline object, call SMS_DesiredConfiguration.TriggerEvaluation, passing in the Name and Version as params
            foreach ($Baseline in $Baselines) {
                if ($Baseline.LastEvalTime -eq '00000000000000.000000+000') {
                    $LastEvalTime = 'N/A'
                    } 
                else {
                    $LastEvalTime = $Baseline.ConvertToDateTime($Baseline.LastEvalTime)
                    }
                $BaselineStatusProperties = [ordered]@{
                    ComputerName = $Baseline.PSComputerName
                    BaselineName = $Baseline.DisplayName
                    Version = $Baseline.Version
                    EvaluationStatus = $EvalHash[$Baseline.Status.tostring()]
                    Compliance = $ComplianceHash[$Baseline.LastComplianceStatus.tostring()]
                    LastEvaluationTime = $LastEvalTime
                    }
                $BaselineStatus = New-Object -TypeName pscustomobject -Property $BaselineStatusProperties
                $BaselineStatus
                }
            }
        }
    end {}
    


}
