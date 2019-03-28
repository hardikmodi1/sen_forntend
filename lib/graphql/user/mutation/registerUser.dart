String register = """
  mutation register(\$email: String!, \$password: String!, \$phone: String!, \$username: String!) {
    register(email: \$email, password: \$password, phone: \$phone, username: \$username) {
      path
      message
      id
    }
  }
"""
    .replaceAll('\n', ' ');
