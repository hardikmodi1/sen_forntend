String updateUsername = """
  mutation updateUsername(\$id: String!, \$username: String!) {
    updateUsername(id: \$id, username: \$username) {
      path
      message
    }
  }
"""
    .replaceAll('\n', ' ');
