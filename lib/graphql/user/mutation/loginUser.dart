String login = """
  mutation login(\$email: String!, \$password: String!) {
    login(email: \$email, password: \$password) {
      path
      message
      id
    }
  }
"""
    .replaceAll('\n', ' ');
