targetScope = 'subscription'

resource policy 'Microsoft.Authorization/policyDefinitions@2020-09-01' = {
  name: 'tagPolicy1'
  properties: {
    displayName: 'Audit a tag and its value format on resources'
    description: 'Audits existence of a tag and its value format. Does not apply to resource groups.'
    policyType: 'Custom'
    mode: 'Indexed'
    metadata: {
      category: 'Tags'
    }

    parameters: {
      tagName: {
        type: 'String'
        defaultValue: 'tag_name'
        metadata: {
          displayName: 'Tag name'
          description: 'A tag to audit'
        }
      }
      tagFormat: {
        type: 'String'
        defaultValue: 'tag_format'
        metadata: {
          displayName: 'Tag format'
          description: 'An expressions for \'like\' condition' // Use backslash as an escape character for single quotation marks
        }
      }
    }

    policyRule: {
      if: {
        field: '[concat(\'tags[\', parameters(\'tagName\'), \']\')]' // No need to use an additional forward square bracket in the expressions as in ARM templates
        notLike: '[parameters(\'tagFormat\')]'
      }
      then: {
        effect: 'Audit'
      }
    }
  }
}


// Defining the existing policies to reference in the policy set definition
resource tagPolicy1 'Microsoft.Authorization/policyDefinitions@2020-09-01' existing = {
  name: 'tagPolicy1'
}

// Policy set definition aka policy initiative
resource policyInitiative 'Microsoft.Authorization/policySetDefinitions@2020-09-01' = {
  name: 'tagInit'
  properties: {
    displayName: 'Tag Governance'
    description: 'Ensure using specific tags for resources and resource groups'
    policyType: 'Custom'
    metadata: {
      category: 'Tags'
    }

    parameters: {
      tagName: {
        type: 'String'
        metadata: {
          displayName: 'Owner tag name'
          description: 'Tag name to validate'
        }
      }
      tagFormat: {
        type: 'String'
        metadata: {
          displayName: 'Owner tag format'
          description: 'Format for tag value validation (\'like\' condition)'
        }
      }
    }

    policyDefinitions: [
      {
        policyDefinitionId: subscriptionResourceId('Microsoft.Authorization/policyDefinitions', tagPolicy1.name)
        policyDefinitionReferenceId: 'Audit a valid \'Owner\' tag is applied to resources'
        }
    ]
  }
}

resource policyAssignment 'Microsoft.Authorization/policyAssignments@2020-09-01' = {
  name: 'tagInit-assignment'
  properties: {
    policyDefinitionId: subscriptionResourceId('Microsoft.Authorization/policyDefinitions', tagPolicy1.name)
    displayName: 'Tag Governance Assignment'
    description: 'Assigns the Tag Governance policy set definition to the subscription'
    parameters: {
      tagName: {
        value: 'tag_name'
        }
      tagFormat: {
        value: 'tag_format'
      }
    }
  }
}
 