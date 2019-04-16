String forgotPasswordChange = """
  mutation forgotPasswordChange(\$newPassword: String!,\$email: String!) {
    forgotPasswordChange(newPassword: \$newPassword, email: \$email) {
      path
      message
    }
  }
"""
    .replaceAll('\n', ' ');
