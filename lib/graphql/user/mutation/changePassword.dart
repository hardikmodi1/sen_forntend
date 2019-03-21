String forgotPasswordChange = """
  mutation forgotPasswordChange(\$newPassword: String!,\$phone: String!) {
    forgotPasswordChange(newPassword: \$newPassword, phone: \$phone) {
      path
      message
    }
  }
"""
    .replaceAll('\n', ' ');
