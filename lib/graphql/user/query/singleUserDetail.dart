String singleUserDetail = """
  query singleUserDetail(\$id: String!, \$visitorId: String!) {
    singleUserDetail (id: \$id, visitorId: \$visitorId){
      email
      id
      image
      phone
      username
    }
  }
"""
    .replaceAll('\n', ' ');
