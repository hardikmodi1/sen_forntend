String allUser = """
  query allUser(\$id: String!, \$lat: Float, \$long:Float) {
    allUser (id: \$id, lat: \$lat, long: \$long){
      email
      id
      image
      phone
      username
      location{
        coordinates
      }
    }
  }
"""
    .replaceAll('\n', ' ');
