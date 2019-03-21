String addGroupList = """
  query addGroupList(\$groupId: String!) {
    addGroupList (groupId: \$groupId){
      id
      email
      image
      username
      phone
    }
  }
"""
    .replaceAll('\n', ' ');
