# 
# NAME
#     Install-CMAvailableSupInstall
#     
# SYNOPSIS
#     Short description
#     
#     
# SYNTAX
#     Install-CMAvailableSupInstall [-ComputerName] <String> [-SupName] <String> [-credential <PSCredential>] 
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
#     To see the examples, type: "get-help Install-CMAvailableSupInstall -examples".
#     For more information, type: "get-help Install-CMAvailableSupInstall -detailed".
#     For technical information, type: "get-help Install-CMAvailableSupInstall -full".
# 
# 
# 
function Install-CMAvailableSupInstall 
{

 Param
(
 [String][Parameter(Mandatory=$True, Position=1)] $ComputerName,
 [String][Parameter(Mandatory=$True, Position=2)] $SupName,
 [pscredential]$credential
 
)
Begin
{
 $AppEvalState0 = "0"
 $AppEvalState1 = "1"
 #$ApplicationClass = [WmiClass]"root\ccm\clientSDK:CCM_SoftwareUpdatesManager"
}
 
Process
{
$i=1

If ($SupName -Like "All" -or $SupName -like "all")
{
    Foreach ($Computer in $ComputerName)
    {
     if(Test-CCMLocalMachine $computer)
     {
        $Application = (Get-WmiObject -Namespace "root\ccm\clientSDK" -Class CCM_SoftwareUpdate -ComputerName $Computer | Where-Object { $_.EvaluationState -like "*$($AppEvalState0)*" -or $_.EvaluationState -like "*$($AppEvalState1)*"})
         Invoke-WmiMethod -Class CCM_SoftwareUpdatesManager -Name InstallUpdates -ArgumentList (,$Application) -Namespace root\ccm\clientsdk 
     }
     else
     {
         $Application = (Get-WmiObject -Namespace "root\ccm\clientSDK" -Class CCM_SoftwareUpdate -ComputerName $Computer  -credential $credential| Where-Object { $_.EvaluationState -like "*$($AppEvalState0)*" -or $_.EvaluationState -like "*$($AppEvalState1)*"})
         Invoke-WmiMethod -Class CCM_SoftwareUpdatesManager -Name InstallUpdates -ArgumentList (,$Application) -Namespace root\ccm\clientsdk -ComputerName $Computer  -credential $credential
     }
    }
 
}
 Else
{
     Foreach ($Computer in $ComputerName)
    {
     if(Test-CCMLocalMachine $computer)
     {
         $Application = (Get-WmiObject -Namespace "root\ccm\clientSDK" -Class CCM_SoftwareUpdate -ComputerName $Computer  | Where-Object { $_.EvaluationState -like "*$($AppEvalState)*" -and $_.Name -like "*$($SupName)*"})
         Invoke-WmiMethod -Class CCM_SoftwareUpdatesManager -Name InstallUpdates -ArgumentList (,$Application) -Namespace root\ccm\clientsdk -ComputerName $Computer  
     }
     else
     {    
         $Application = (Get-WmiObject -Namespace "root\ccm\clientSDK" -Class CCM_SoftwareUpdate -ComputerName $Computer  -credential $credential| Where-Object { $_.EvaluationState -like "*$($AppEvalState)*" -and $_.Name -like "*$($SupName)*"})
         Invoke-WmiMethod -Class CCM_SoftwareUpdatesManager -Name InstallUpdates -ArgumentList (,$Application) -Namespace root\ccm\clientsdk -ComputerName $Computer  -credential $credential
     }
 
    }
 
}
}
End {}


}
