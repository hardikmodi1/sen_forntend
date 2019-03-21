String remove = """
  mutation remove(\$groupId: String!, \$memberId: String!) {
    remove(groupId: \$groupId, memberId: \$memberId) {
      path
      message
    }
  }
"""
    .replaceAll('\n', ' ');
