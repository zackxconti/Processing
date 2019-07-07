class Face {
  
  Vertex [] face_vertices;
  
  Face (Vertex [] num_vertices) {
    
    face_vertices = num_vertices;
  
  }
  
  void draw () {
    //colorMode(HSB, 1, 1, 1);
    fill (255); // this should be only one value ... see exactly how the values of the hue, saturation and brightness have to be written - check reference file 

    //stroke(255);
    strokeWeight(1);  
    beginShape();
    println ("fv "+ face_vertices.length);
    for (int i=0; i<face_vertices.length; i++) {  // iterate through loop of nodes to draw shape using begin and end (close).

      vertex(face_vertices[i].location.x, this.face_vertices[i].location.y, this.face_vertices[i].location.z);
    }

    endShape(CLOSE);
  }
}
    
  