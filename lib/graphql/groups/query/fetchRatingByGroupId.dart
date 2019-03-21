String fetchRatingByGroupId = """
  query fetchRatingByGroupId(\$groupId: String!) {
    fetchRatingByGroupId (groupId: \$groupId){
    ratings
    total
  }
  }
"""
    .replaceAll('\n', ' ');
