# 
# NAME
#     New-CMSccmTriggerHashTable
#     
# SYNOPSIS
#     Short description
#     
#     
# SYNTAX
#     New-CMSccmTriggerHashTable [<CommonParameters>]
#     
#     
# DESCRIPTION
#     Long description
#     
# 
# RELATED LINKS
# 
# REMARKS
#     To see the examples, type: "get-help New-CMSccmTriggerHashTable -examples".
#     For more information, type: "get-help New-CMSccmTriggerHashTable -detailed".
#     For technical information, type: "get-help New-CMSccmTriggerHashTable -full".
# 
# 
# 
function New-CMSccmTriggerHashTable 
{

    $Sccmhash =@{HardwareInventoryCollectionTask='{00000000-0000-0000-0000-000000000001}';SoftwareInventoryCollectionTask='{00000000-0000-0000-0000-000000000002}';HeartbeatDiscoveryCycle='{00000000-0000-0000-0000-000000000003}';SoftwareInventoryFileCollectionTask='{00000000-0000-0000-0000-000000000010}';RequestMachinePolicyAssignments='{00000000-0000-0000-0000-000000000021}';EvaluateMachinePolicyAssignments='{00000000-0000-0000-0000-000000000022}';RefreshDefaultMPTask='{00000000-0000-0000-0000-000000000023}';RefreshLocationServicesTask='{00000000-0000-0000-0000-000000000024}';LocationServicesCleanupTask='{00000000-0000-0000-0000-000000000025}';SoftwareMeteringReportCycle='{00000000-0000-0000-0000-000000000031}';SourceUpdateManageUpdateCycle='{00000000-0000-0000-0000-000000000032}';PolicyAgentCleanupCycle='{00000000-0000-0000-0000-000000000040}';CertificateMaintenanceCycle='{00000000-0000-0000-0000-000000000051}';PeerDistributionPointStatusTask='{00000000-0000-0000-0000-000000000061}';PeerDistributionPointProvisioningStatusTask='{00000000-0000-0000-0000-000000000062}';ComplianceIntervalEnforcement='{00000000-0000-0000-0000-000000000071}';SoftwareUpdatesAgentAssignmentEvaluationCycle='{00000000-0000-0000-0000-000000000108}';SendUnsentStateMessages='{00000000-0000-0000-0000-000000000111}';StateMessageManagerTask='{00000000-0000-0000-0000-000000000112}';ForceUpdateScan='{00000000-0000-0000-0000-000000000113}';AMTProvisionCycle='{00000000-0000-0000-0000-000000000120}'}
    $Sccmhash


}
