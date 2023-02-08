targetScope = 'managementGroup'

module denyMG 'modules/mgmpol.bicep' = {
  name: 'Deny_M_and_G_series_vm'
  scope: managementGroup()
}

module denyE 'modules/denyEvm.bicep' = {
  name: 'Deny_E_series_vm'
  scope: managementGroup()
}
