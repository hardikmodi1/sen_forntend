String checkOTP = """
  mutation checkOTP(\$email: String!,\$OTP: Int!) {
    checkOTP(email: \$email, OTP: \$OTP) {
      path
      message
    }
  }
"""
    .replaceAll('\n', ' ');
