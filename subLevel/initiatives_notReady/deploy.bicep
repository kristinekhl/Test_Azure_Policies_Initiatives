targetScope = 'subscription'

module taginit 'taginit.bicep' = {
  name: 'taginit'
  scope: subscription('a9de46e8-236e-4d58-ada1-853ff9f9059c')
}
