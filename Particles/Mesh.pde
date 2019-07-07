class Mesh{
  
  int rx;
  int ry;
  int weaveX;
  int weaveY;
  Manifold mesh;
  
  Mesh ( int rx, int ry, int weaveX, int weaveY) {
    
    
    this.rx = rx; 
    this.ry = ry; 
    this.weaveX = weaveX;
    this.weaveY = weaveY;
    mesh = new Manifold ();
    
  }
  
  Manifold generate(){
    
    
    for (int j =0; j<ry; j++){
      for (int i=0; i<rx; i++){
        Vertex v = new Vertex (new PVector(i*this.weaveX, j*this.weaveY, 0));
        mesh.addVertex(v);
      }
    }
    int k=0;
    for (int j=0; j< ry; j++){
      for (int i=0; i<rx; i++){
        
  
//      for (int i=0; i<mesh.vertices.size()-rx-1; i++)
//      {
        if(i<(rx-1)&& j<(ry-1)){ 
        int [] face_vertex_indices = new int [4];
       
        // need to limit the i direction
        
        face_vertex_indices[0] = k; 
        //println("v "+k);
        face_vertex_indices[1] = k+1; 
       // println("v "+ (k+1));
        face_vertex_indices[2] = k+rx+1; 
        //println("v "+(k+rx+1));
        face_vertex_indices[3] = k+rx;   
        //println("v "+(k+rx));
        
        
        //println("k= "+k);
        mesh.addFace(face_vertex_indices);
        }
        k++;
      }
 
    }
        
    println ("number of edges"+mesh.edges.size());
    println ("numve od vertices"+mesh.vertices.size());
    return mesh;
    
  }
  
  
  void drawMesh (){
    
    mesh.drawVertices();
    mesh.drawEdges();
    mesh.drawFaces();
    
  }
  
  void updateMesh(){
    mesh.update();
  }
}