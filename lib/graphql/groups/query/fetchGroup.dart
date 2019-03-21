String fetchGroup = """
  query fetchGroup(\$id: String!, \$long: Float, \$lat: Float) {
    fetchGroup (id: \$id, long: \$long, lat: \$lat){
      _id
      name
		  iconLink
    }
  }
"""
    .replaceAll('\n', ' ');
