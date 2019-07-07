class Manifold {

  ArrayList <Vertex> vertices; 
  ArrayList <Edge> edges;
  ArrayList <Face> faces;

  Manifold () {

    this.vertices = new ArrayList <Vertex>();
    this.edges = new ArrayList <Edge> ();
    this.faces = new ArrayList <Face> ();
  }

  void addVertex (Vertex v) {
    this.vertices.add(v);
  }

  void addVertex(PVector v){
    this.vertices.add(new Vertex(v));
  }

  Edge addEdge (Vertex from, Vertex to, Face left) {

    Edge e = new Edge( from, to, left);
    this.edges.add(e);
    from.edges.add(e);
    to.edges.add(e);

    return e;
  }


  void addFace (int [] face_vertex_indices) {

    // search for vertices in manifold vertices list and call them by their index
    Vertex [] face_vertices = new Vertex [face_vertex_indices.length];

    for (int i =0; i<face_vertices.length; i++) {

      face_vertices[i] = this.vertices.get(face_vertex_indices[i]);
    }

    // declare new face to be created and added 
    Face face = new Face (face_vertices);


    // add edges

    for (int i=0; i<face_vertices.length; i++)
    {
      // delcare two nodes of the first edge to be created
      Vertex v1 = face_vertices [i];
      Vertex v2 = face_vertices [(i+1) % face_vertices.length];

      Edge shared_edge = v2.connectedTo(v1);


      // if edge between v1 and v2 already exists and is in direction v2-v1, 
      // then do not add edge but set the 'right' property of the shared edge to this face being created. 
      if (shared_edge !=null)
      { 
        shared_edge.right = face;
      }
      // if edge between v1 and v2 does not exist, then add an edge in direction v1-v2
      else if (v1.connectedTo(v2) == null) 
      {
        this.addEdge(v1, v2, face);
      }
    }

    // add face to manifold list 
    this.faces.add(face);
  }

  void drawVertices () {

    for (int i=0; i<this.vertices.size(); i++)
    {
      this.vertices.get(i).draw(100);
    }
  }


  void drawEdges () {
    for (int i=0; i<this.edges.size(); i++)
    {
      this.edges.get(i).draw();
    }
  }

  void drawFaces () {
    for (int i=0; i<this.faces.size(); i++)
    {
      this.faces.get(i).draw();
    }
  }
  
  
  void update (){
    for (int i=0; i<this.vertices.size(); i++){
      Vertex v = this.vertices.get(i);
      v.update();
    }
  }

  void set(Manifold m) {
    this.vertices = m.vertices;
    this.edges = m.edges;
    this.faces = m.faces;
  }

  public Manifold importOBJ(String file) {
    println("test");
    //logger.info("loading manifold from file: " + file);
    Manifold m = new Manifold();
    //String file = .selectInput("Select an OBJ file to import:");
    //.println("You have selected: " + file);
    File f = new File(dataPath(file));
    if (!f.exists()) {
      println("File does not exist");
    } else {
      for (String s : loadStrings(file)) {
        //logger(this, "DEBUG", "importOBJ; parsing line: \"" + s + "\"");
        String[] l = s.split(" ");
        if (l.length > 0) {
          // vertices
          if (l[0].equals("v")) {
            //logger.debug("vertex found");
            println("vertex");
            
            m.addVertex(new Vertex(new PVector(Float.valueOf(l[1]), Float.valueOf(l[2]), Float.valueOf(l[3]))));
          }
          // faces
          else if (l[0].equals("f")) {
            //logger.debug("face found");
            int[] vertices = new int[l.length -1];
            for (int i = 1; i < l.length; i++) {
              vertices[i-1] = Integer.valueOf(l[i].split("/")[0])-1; // ignore texture-coordinates and normals
            }
            m.addFace(vertices);
          }
        }
      }
      this.set(m);
    }
    return m;
  }
}