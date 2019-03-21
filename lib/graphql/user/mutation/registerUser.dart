String register = """
  mutation register(\$email: String!, \$password: String!, \$phone: String) {
    register(email: \$email, password: \$password, phone: \$phone) {
      path
      message
      id
    }
  }
"""
    .replaceAll('\n', ' ');
