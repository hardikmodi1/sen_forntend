final String operationName = "newMessage";
final String query =
    """subscription $operationName(\$senderId: String!, \$receiverId: String!) {
  newMessage(senderId: \$senderId, receiverId: \$receiverId) {
    senderId
    receiverId
    text
  }
}""";
