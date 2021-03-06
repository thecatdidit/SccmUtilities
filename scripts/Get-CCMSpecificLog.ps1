# 
# NAME
#     Get-CCMSpecificLog
#     
# SYNTAX
#     Get-CCMSpecificLog [-ComputerName] <Object> [-log] <Object> [-credential <pscredential>]  [<CommonParameters>]
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
function Get-CCMSpecificLog 
{

    param([Parameter(Mandatory=$true,Position=0)]$ComputerName = '$env:computername', [Parameter(Mandatory=$true,Position=1)]$path = 'c:\windows\ccm\logs',[Parameter(Mandatory=$true,Position=1)]$log = 'smsts',[pscredential] $credential )
    
    begin {
        # Bind the parameter to a friendly variable
        
    }

    process {
        # Your code goes here
        #dir -Path $Path
        if(Test-CCMLocalMachine $computerName)
        {
            $sb2 = "$((Get-ChildItem function:get-cmlog).scriptblock)`r`n"
            $sb1 = [scriptblock]::Create($sb2)
            $results = Invoke-Command -ScriptBlock $sb1 -ArgumentList "$path\$log.log"
            [PSCustomObject]@{"$($log)Log"=$results}
        }
        else
        {
            $sb2 = "$((Get-ChildItem function:get-cmlog).scriptblock)`r`n"
            $sb1 = [scriptblock]::Create($sb2)
            $results = Invoke-Command -ComputerName $ComputerName -ScriptBlock $sb1 -ArgumentList "$path\$log.log"  -credential $credential
            [PSCustomObject]@{"$($log)Log"=$results}
        }
    }



}
