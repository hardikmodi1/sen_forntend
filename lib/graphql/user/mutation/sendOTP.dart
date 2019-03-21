String sendForgotPasswordEmail = """
  mutation sendForgotPasswordEmail(\$phone: String!) {
    sendForgotPasswordEmail(phone: \$phone) {
      path
      message
    }
  }
"""
    .replaceAll('\n', ' ');
