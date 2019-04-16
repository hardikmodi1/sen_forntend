String pastEvents = """
  query pastEvents(\$id: String!) {
    pastEvents (id: \$id){
      _id
      name
      date
      time
      imageLink
    }
  }
"""
    .replaceAll('\n', ' ');
