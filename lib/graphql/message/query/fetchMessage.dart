String fetchMessage = """
  query fetchMessage(\$senderId: String!, \$receiverId: String!, \$query: Int!) {
    fetchMessage (senderId: \$senderId, receiverId: \$receiverId, query: \$query){
      senderId
      receiverId
      text
      time
      user{
        email
        username
      }
    }
  }
"""
    .replaceAll('\n', ' ');
