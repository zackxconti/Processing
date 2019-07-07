class Edge {
  
  Vertex from;
  Vertex to;
  Face left; 
  Face right; 
  
  Edge (Vertex from, Vertex to, Face left){
    
    this.from = from;
    this.to = to;
    this.left = left;
    
  }
  

  void draw () {
    colorMode(RGB, 255);
    stroke (50);
    strokeWeight (1);
    // println(n1.location.x);
    line(this.from.location.x, this.from.location.y, this.from.location.z, this.to.location.x, this.to.location.y, this.to.location.z);
  }
    
 
  
  
  
  
}