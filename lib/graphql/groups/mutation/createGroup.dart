String createGroup = """
  mutation createGroup(\$name: String!, \$iconLink: String, \$creator: String!, \$members: [String!]!, \$long: Float, \$lat: Float) {
    createGroup(name: \$name, iconLink: \$iconLink, creator: \$creator, members: \$members, long: \$long, lat: \$lat) {
      path
      message
    }
  }
"""
    .replaceAll('\n', ' ');
