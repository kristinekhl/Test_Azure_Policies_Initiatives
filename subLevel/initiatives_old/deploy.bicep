targetScope = 'subscription'

module initsub 'modules/initsub.bicep' = {
  name: 'initsub'
  scope: subscription('a9de46e8-236e-4d58-ada1-853ff9f9059c')
}
