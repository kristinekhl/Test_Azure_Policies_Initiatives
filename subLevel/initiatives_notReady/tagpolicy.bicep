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
        metadata: {
          displayName: 'Tag name'
          description: 'A tag to audit'
        }
      }
      tagFormat: {
        type: 'String'
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
