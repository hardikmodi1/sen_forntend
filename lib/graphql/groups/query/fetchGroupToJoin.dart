String fetchGroupToJoin = """
  query fetchGroupToJoin(\$id: String!, \$long: Float, \$lat: Float) {
    fetchGroupToJoin (id: \$id, long: \$long, lat: \$lat){
    _id
    name
    description
    iconLink
  }
  }
"""
    .replaceAll('\n', ' ');
