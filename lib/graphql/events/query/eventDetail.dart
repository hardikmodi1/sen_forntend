String getDescription = """
  query getDescription(\$id: String!) {
    getDescription (id: \$id){
      _id
    name
    imageLink
    description
    date
    time
    long
    lat
  	participants{
      _id
      email
      username
		  image
    }
    }
  }
"""
    .replaceAll('\n', ' ');
