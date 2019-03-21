String getRange = """
  query getRange(\$id: String!) {
    getRange(id: \$id) 
  }
"""
    .replaceAll('\n', ' ');
