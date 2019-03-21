String setRange = """
  mutation setRange(\$id: String!, \$range: Float!) {
    setRange(id: \$id, range: \$range) 
  }
"""
    .replaceAll('\n', ' ');
