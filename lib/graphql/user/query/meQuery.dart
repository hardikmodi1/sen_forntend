String meQuery = """
  query meQuery(\$id: String!) {
    me (id: \$id){
      email
      id
      image
      phone
      username
    }
  }
"""
    .replaceAll('\n', ' ');
