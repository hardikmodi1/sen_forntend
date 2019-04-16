String createEvent = """
  mutation createEvent(\$id:String!,\$name: String!, \$imageLink: String!, \$description: String!,\$date:String!, \$time:String!,\$long:Float,\$lat:Float) {
    createEvent(id: \$id,name: \$name, imageLink: \$imageLink, description: \$description,date:\$date,time:\$time,long:\$long,lat:\$lat) {
      path
      message
    }
  }
"""
    .replaceAll('\n', ' ');
