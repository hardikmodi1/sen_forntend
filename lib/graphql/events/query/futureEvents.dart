String futureEvents = """
  query futureEvents(\$id: String!) {
    futureEvents (id: \$id){
      _id
      name
      date
      time
      imageLink
    }
  }
"""
    .replaceAll('\n', ' ');
