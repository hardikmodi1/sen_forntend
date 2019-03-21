String updateProfile = """
  mutation updateProfile(\$id: String!, \$image: String!) {
    updateProfile(id: \$id, image: \$image) {
      path
      message
    }
  }
"""
    .replaceAll('\n', ' ');
