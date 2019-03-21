String dismissAsAdmin = """
  mutation dismissAsAdmin(\$groupId: String!, \$memberId: String!) {
    dismissAsAdmin(groupId: \$groupId, memberId: \$memberId) {
      path
      message
    }
  }
"""
    .replaceAll('\n', ' ');
