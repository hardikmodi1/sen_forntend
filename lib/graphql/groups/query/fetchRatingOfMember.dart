String fetchRatingOfMember = """
  query fetchRatingOfMember(\$groupId: String!, \$memberId: String!) {
    fetchRatingOfMember (groupId: \$groupId, memberId: \$memberId)
  }
"""
    .replaceAll('\n', ' ');
