String likeOrDislike = """
  mutation likeOrDislike(\$eventId: String!,\$userId:String!, \$like:Int!) {
    likeOrDislike (eventId: \$eventId,userId:\$userId, like:\$like){
      path
    }
  }
"""
    .replaceAll('\n', ' ');
