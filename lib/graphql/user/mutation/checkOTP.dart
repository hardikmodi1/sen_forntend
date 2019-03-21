String checkOTP = """
  mutation checkOTP(\$phone: String!,\$OTP: Int!) {
    checkOTP(phone: \$phone, OTP: \$OTP) {
      path
      message
    }
  }
"""
    .replaceAll('\n', ' ');
