String makeAdmin = """
  mutation makeAdmin(\$groupId: String!, \$memberId: String!) {
    makeAdmin(groupId: \$groupId, memberId: \$memberId) {
      path
      message
    }
  }
"""
    .replaceAll('\n', ' ');
