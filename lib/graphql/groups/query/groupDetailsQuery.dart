String fetchGroup = """
  query fetchGroup(\$id: String!) {
    fetchGroupMember(groupId:\$id){
    id
    email
    image
    phone
    username
  },
  groupDetail(groupId:\$id){
    name
    iconLink
    description
  },
  adminList(groupId: \$id)
  }
"""
    .replaceAll('\n', ' ');
