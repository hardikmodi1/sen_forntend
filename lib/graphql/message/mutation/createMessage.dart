String createMessage = """
  mutation createMessage(\$senderId: String!, \$receiverId: String!, \$text: String!) {
    createMessage(senderId: \$senderId, receiverId: \$receiverId, text: \$text) {
      path
      message
    }
  }
"""
    .replaceAll('\n', ' ');
