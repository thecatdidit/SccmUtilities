# 
# NAME
#     Resolve-DNS
#     
# SYNOPSIS
#     Short description
#     
#     
# SYNTAX
#     Resolve-DNS [[-hostname] <Object>] [<CommonParameters>]
#     
#     
# DESCRIPTION
#     Long description
#     
# 
# RELATED LINKS
# 
# REMARKS
#     To see the examples, type: "get-help Resolve-DNS -examples".
#     For more information, type: "get-help Resolve-DNS -detailed".
#     For technical information, type: "get-help Resolve-DNS -full".
# 
# 
# 
function Resolve-DNS 
{

  param($hostname)
  $resolve = [Net.DNS]::GetHostEntry("$hostname")
  $resolve


}
