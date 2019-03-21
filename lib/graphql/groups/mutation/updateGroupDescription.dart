String updateGroup = """
  mutation updateGroup(\$groupId: String!, \$description: String, \$imageLink: String) {
    updateGroup(groupId: \$groupId, description: \$description, imageLink: \$imageLink) {
      path
      message
    }
  }
"""
    .replaceAll('\n', ' ');
