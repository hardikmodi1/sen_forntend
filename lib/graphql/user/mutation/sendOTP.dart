String sendForgotPasswordEmail = """
  mutation sendForgotPasswordEmail(\$email: String!) {
    sendForgotPasswordEmail(email: \$email) {
      path
      message
    }
  }
"""
    .replaceAll('\n', ' ');
