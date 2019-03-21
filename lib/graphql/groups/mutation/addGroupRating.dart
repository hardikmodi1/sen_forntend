String addGroupRating = """
  mutation addGroupRating(\$groupId: String!, \$memberId: String!, \$rating: Int!) {
    addGroupRating(groupId: \$groupId, memberId: \$memberId, rating: \$rating) {
      path
      message
    }
  }
"""
    .replaceAll('\n', ' ');
