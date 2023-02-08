targetScope = 'subscription'

module denyMG 'modules/denyMGvm.bicep' = {
  name: 'Deny_M_and_G_series_vm'
  scope: subscription('a9de46e8-236e-4d58-ada1-853ff9f9059c')
}

module denyE 'modules/denyEvm.bicep' = {
  name: 'Deny_E_series_vm'
  scope: subscription('a9de46e8-236e-4d58-ada1-853ff9f9059c')
}
