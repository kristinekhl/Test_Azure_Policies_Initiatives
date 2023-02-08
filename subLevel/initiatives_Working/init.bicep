targetScope = 'subscription'

var policyDisplayName = 'Audit a tag on resources'
var policyDescription = 'Audits existence of a tag. Does not apply to resource groups.'
var policySetDisplayName = 'Tag Governance'
var policySetDescription = 'Ensure using specific tags for resources and resource groups'

resource policy 'Microsoft.Authorization/policyDefinitions@2020-09-01' = {
  name: 'audit-resource-tag-pd'
  properties: {
    displayName: policyDisplayName
    description: policyDescription
    policyType: 'Custom'
    mode: 'Indexed'
    metadata: {
      category: 'Tags'
    }

    parameters: {
      tagName: {
        type: 'String'
        metadata: {
          displayName: 'Tag name'
          description: 'A tag to audit'
        }
      }
    }

    policyRule: {
      if: {
        field: '[concat(\'tags[\', parameters(\'tagName\'), \']\')]'
        exists: false
      }
      then: {
        effect: 'Audit'
      }
    }
  }
}

// Defining the existing policies to reference in the policy set definition
resource policyDefinitionForAuditingResourceTag 'Microsoft.Authorization/policyDefinitions@2020-09-01' existing = {
  name: 'audit-resource-tag-pd'
}

// Policy set definition aka policy initiative
resource policyInitiative 'Microsoft.Authorization/policySetDefinitions@2020-09-01' = {
  name: 'tag-governance-psd'
  properties: {
    displayName: policySetDisplayName
    description: policySetDescription
    policyType: 'Custom'
    metadata: {
      category: 'Tags'
    }

    parameters: {
      costCenterTagName: {
        type: 'String'
        metadata: {
          displayName: 'Cost Center tag name'
          description: 'Tag name to validate'
        }
      }
    }
    
    policyDefinitions: [
      {
        policyDefinitionId: subscriptionResourceId('Microsoft.Authorization/policyDefinitions', policyDefinitionForAuditingResourceTag.name)
        policyDefinitionReferenceId: 'Audit a \'Cost Center\' tag is applied to resources'
        parameters: {
          tagName: {
            value: '[parameters(\'costCenterTagName\')]'
          }
        }
      }
    ]
  }
}

resource policySetAssignment 'Microsoft.Authorization/policyAssignments@2020-09-01' = {
  name: 'policySetAssignment' //Should be unique whithin your target scope
  properties: {
    enforcementMode: 'Default'
    policyDefinitionId: policyInitiative.id
    parameters: {
      costCenterTagName:{
        value: 'cost_center'
      }
    }
  }
}
