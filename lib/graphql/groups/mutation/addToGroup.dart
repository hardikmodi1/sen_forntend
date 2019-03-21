String addToGroup = """
  mutation addToGroup(\$groupId: String!, \$members: [String!]!) {
    addToGroup(groupId: \$groupId, members: \$members) {
      path
      message
    }
  }
"""
    .replaceAll('\n', ' ');
