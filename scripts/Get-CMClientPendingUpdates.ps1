# 
# NAME
#     Get-CMClientPendingUpdates
#     
# SYNTAX
#     Get-CMClientPendingUpdates [-ComputerName] <string[]> [[-credential] <pscredential>] [-Summary]  
#     [<CommonParameters>]
#     
# 
# ALIASES
#     None
#     
# 
# REMARKS
#     None
# 
# 
# 
function Get-CMClientPendingUpdates 
{

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,
				   ValueFromPipeline = $true,
				   ValueFromPipelineByPropertyName = $true)]
        [string[]]$ComputerName = $env:ComputerName,
        [pscredential]$credential,
        [switch]$Summary
        )

    begin {}
    process {

        foreach ($Computer in $ComputerName) {
            if(Test-CCMLocalMachine $computerName)
            {
                $SccmPendingUpdates = Get-WmiObject -Namespace root\ccm\clientsdk -Class CCM_SoftwareUpdate 
            }
            else {
                try{
                    $SccmPendingUpdates = Get-WmiObject -Namespace root\ccm\clientsdk -Class CCM_SoftwareUpdate  -credential $credential -ComputerName $Computer -ErrorAction stop
                }
                catch [System.Management.ManagementException]
                {
                    $SccmPendingUpdates = $null
                }
            }
            if ($Summary) {
                $SccmPendingUpdates | Select-Object -Property PSComputerName,ArticleID,@{label=’Deadline’;expression={$_.ConvertToDateTime($_.Deadline)}},Name
                }
            else {
                $SccmPendingUpdates
                }
            }
        }
    end {}


}
