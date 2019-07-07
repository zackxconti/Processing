class Vertex {
  ArrayList <Edge> edges;
  ArrayList <Face> faces;
  
  PVector location;
  PVector velocity;
  PVector acceleration;
  Float grav;
  
  Vertex (PVector location){
    
    this.grav = controlP5.getController("gravity").getValue();
    this.location = location; 
    this.velocity = new PVector (0,0);
    //this.acceleration = gravity;
    //this.acceleration = new PVector (random(-grav, grav), random(-grav, grav), random(-grav, grav));
    this.acceleration = new PVector (random(-this.grav, this.grav), random(-this.grav, this.grav), random(-this.grav, this.grav));
    
    this.faces = new ArrayList <Face> ();
    this.edges = new ArrayList <Edge> ();
    
  }
  
    void updateG (Float g ){
      //PVector n= new PVector (random(-g, g), random(-g, g), random(-g, g));
      //this.location.add(n);
      //this.location.mult(0.04);
    }
    
   void update (){
     this.velocity.add(this.acceleration);
     //this.velocity.limit(10);
     this.location.add(this.velocity);
     
   }
   
   void checkBoundary(){
     
     if((this.location.x >= 400) || (this.location.x<=-400)){
       this.velocity.x=-1*this.velocity.x;
       print ("here");
     }
     if((this.location.y >= 400) || (this.location.y<=-400)){
       this.velocity.y=-1*this.velocity.y;
     }
     if((this.location.z >= 400) || (this.location.z<=-400)){
       this.velocity.z=-1*this.velocity.z;
     }
     
   
     

   }
  
  
   Edge connectedTo (Vertex v2){
      
      for(int i=0; i<this.edges.size(); i++)
      {
        if(this.edges.get(i).from == this && this.edges.get(i).to == v2)
          {
            return this.edges.get(i);
          }
      }
      print("null");
      return null;      
    }
  
  
  
   void draw (float c) {

    colorMode(HSB, 360);
    stroke (c,360,360);
    strokeWeight (4);
    point (this.location.x, this.location.y, this.location.z);
  }
}
    