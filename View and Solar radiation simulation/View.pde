class View {
  Face carpet;
  PShape square;
  Fenestrated wall;
  float eyeLevel;
  Window window;
  Manifold flats;
  ArrayList <Line> lines;
  ArrayList <Face> faces;
  ArrayList <Vertex> cylinderVertices;
  float rad;
  //View (Face carpet, Window window, float eyeLevel) {
  View (Manifold flats, int radius) {

    this.carpet = carpet;
    this.wall = wall;
    this.eyeLevel = eyeLevel*10; // 10 units = 1 metre
    this.window = window;
    this.flats = flats;
    this.lines = new ArrayList <Line> ();
    this.faces = new ArrayList <Face> ();
    this.cylinderVertices = new ArrayList <Vertex> ();
    this.rad = radius;
    //println("this.rad inside view class ="+this.rad);
  }

  Face [] subdivide (Face f) {
    // List <Face> facess = new ArrayList <Face> ();
    // this.faces.add(f);

    if (f.diagonal() > 700 ) {

      Face faces [] = f.subdivide();
      this.faces.remove(f);
      for (int i=0; i<faces.length;i++) {
        //  facess.add(faces[i]);
        this.faces.add(faces[i]);

        this.subdivide(faces[i]);
      }
    }
    //   println("size " + facess.size());
    return this.faces.toArray(new Face [this.faces.size()]);
  }





  void drawLines () {

    for (int i=0; i<this.lines.size(); i++) {
      this.lines.get(i).draw();
    }
  }


  void drawCylinder (int n, float vertAngle) {


    float radius =this.rad ;

    // float radius = (50*0.5)/sin(((2*PI)/n)*0.5);

//      float sec = radius*((2*PI/n) +2);
      float sec = (2*PI)*(view.rad);


 //   for (int i=0; i<n ; i++) {

      //createShape(QUAD_STRIP);
      beginShape(QUAD_STRIP);
     // textureWrap(CLAMP); 
      texture (image) ;
     
      //    println(" size of pixels "+ image.pixels.length);
      // PSh
    //  float v = (image.height/n)*i;

      for (int j=0; j<=n; j++) {

        float u = (image.width/n)*j;

        vertex((radius*cos((((2*PI)/n)*j)) ), (radius*sin((((2*PI)/n)*j))), ((tan(vertAngle*0.5)))*radius, u, image.height); //A
//        this.cylinderVertices.add(new Vertex ( new PVector ((radius*cos((((2*PI)/n)*j))), (radius*sin((((2*PI)/n)*j))), (((-height*0.5)/n))*(i)), 1)   );
        vertex((radius*cos((((2*PI)/n)*j))), (radius*sin((((2*PI)/n)*j))), ((tan(-vertAngle*0.5)))*radius, u, 0);
        // u = u+deltaU;
      }
      //  v = v+deltaV;
      endShape();
    

    for (int i=0; i<this.cylinderVertices.size(); i++) {

      Vertex v = this.cylinderVertices.get(i);
      image.get((int)v.location.x, (int)v.location.y, image.width/n, image.height/n);
    }
  }
  
  
  int score (color c ) {
    int score = 0;
    if( red(c) == 0 ) { score = 6;}
    if( red(c) == 50 ) {  score = 5;}
    if( red(c) == 87 ) {  score = 4;}
    if( red(c) == 162 ) {  score = 3;}
    if( red(c) == 209 ) {  score = 2;}
    if( red(c) == 255 ) {  score = 1;}
    
    return score;
  }
    
    
      
  

  //NB: Store vertices A in a list.
  //    loop through them and use the PImage.get(x, y, widht, height) to get each quad area of pixels. x, y is location of vertex and 
  //    width and height are the '2PI/n' and height/n, respectively.
}