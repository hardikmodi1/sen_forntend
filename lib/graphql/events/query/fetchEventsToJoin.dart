String fetchEventsToJoin = """
  query fetchEventsToJoin(\$id: String!,\$long:Float, \$lat:Float) {
    fetchEventsToJoin (id: \$id,long:\$long, lat:\$lat){
      name
      _id
    imageLink
    }
  }
"""
    .replaceAll('\n', ' ');
