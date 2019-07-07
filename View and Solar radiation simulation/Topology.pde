class Vertex {

  PVector location;
  ArrayList <Edge> edges;
  ArrayList <Face> faces;
  PVector CO;
  float hue;
  float brightness;
  boolean checked;
  PVector moved;

  Vertex ( PVector location, int brightness ) {
    this.location = location;
    this.edges = new ArrayList <Edge> ();
    this.faces = new ArrayList <Face>();
    this.hue = hue;
    this.brightness = brightness;
    this.checked = false;
  }




  Edge edgeTo( Vertex b ) {

    int n = edges.size();


    for (int i=0; i<n; i++) {
      if (edges.get(i).from == this && edges.get(i).to == b)

        return edges.get(i);
    }

    return null;
  }


  Edge edgeWith (Vertex b) { // use in case of unknown direction

    Edge e = this.edgeTo(b);
    if (e != null) {
      return e;
    } 
    else {
      return b.edgeTo(this);
    }
  }

  void sortEdges () {
    if (!this.edges.isEmpty()) {
      ArrayList <Edge> edgesSorted = new ArrayList <Edge> ();  
      int n = this.edges.size();

      // boolean reverseSort = false;


      edgesSorted.add(edges.remove(0));

      for (int i =0; i<n-1; i++) {
        Face ff;
        // first link 
        Edge ll = edgesSorted.get(i); 

        if (ll.boundary() == false) {
          // println("NOT Boundary");

          if (this == ll.from) {

            ff= ll.left;
          } 

          else { 

            ff=ll.right;
          }

          // search for next link 
          for (int j=0; j< this.edges.size(); j++) {


            Edge lNext = this.edges.get(j);
            if ( ff == lNext.right || ff == lNext.left) {

              edgesSorted.add(this.edges.remove(j));
              // if (lNext.boundary() == true ) {
              // println("size of edges list = " + this.edges.size());
              // println(edgesSorted);
              // println("size of sorted edges list = " + edgesSorted.size());
              break;
            }
          }
        }

        else {  // if boundary 

          if ((ll.right == null) || (ll.left == null)) {
            //            println("boundary");
            //            println("not updated link ="+ll);
            ll = edgesSorted.get(0);
            //            println("updated link ="+ll);



            if (this == ll.from) {

              ff= ll.right;
            } 

            else { 

              ff=ll.left;
            }


            // search for next link
            for (int j=0; j< this.edges.size(); j++) {
              // println("size of list before last one is removed " + this.edges.size() );
              Edge lNext = this.edges.get(j);
              if ( (ff == lNext.right) || (ff == lNext.left)) {
                // println("lNext is attached to prev face ");
                lNext = this.edges.remove(0);
                edgesSorted.add(0, lNext); // needs to be added to the beggining of the sorted array list

                  //                println("size of edges list = " + this.edges.size());
                //                println(edgesSorted);
                //                println("size of sorted edges list = " + edgesSorted.size());
                break;
              }
            }
          }
        }
      }
      //      println("Final Size of ORIGINAL LINKS "+ this.edges.size());
      //      println("FInal Size of SORTED LINKS " + edgesSorted.size());
      //      println("-------------------------------------------------------------------------------------------------");
      this.edges = edgesSorted;
    }
  }

  Face [] searchFace () {

    ArrayList<Face> faces = new ArrayList<Face>();
    this.sortEdges();

    //  Face [] correspondingFaces = new Face [this.edges.size()];



    for (int i=0; i< this.edges.size(); i++) {   // iterate through edges (connecting nodes) array  
      Edge l = this.edges.get(i);

      if (this == l.from && l.right !=null) {

        faces.add(l.right);
        // correspondingFaces[i] = l.right;
      }
      else if (this == l.to && l.left != null) { 
        faces.add(l.left);
        // correspondingFaces[i] = l.left;
      }
    }
    //println(correspondingFaces.length);
    return faces.toArray(new Face[faces.size()]);
  }


  Face searchWindowFace (Window w) {
    Face [] f = this.searchFace();

    for (int i=0; i<f.length; i++) {
      for (int j=0; j<w.windowFaces.size();j++) {

        if (f[i] == w.windowFaces.get(j)) {
          return f[i];
        }
      }
    }
    return null;
  }
  
    PVector averageNormal () {  

    Face [] cFaces = new Face [this.searchFace().length];

    cFaces=this.searchFace();


    PVector [] vNormals = new PVector [this.searchFace().length];
    //println("Corresponding Face "+ 1+ " = "+ this.searchFace()[0]);
    for (int i=0; i < vNormals.length; i++) {

      vNormals[i] =  cFaces[i].normal();
    }

    PVector average = new PVector (0, 0, 0);
    for (int i=0; i < vNormals.length; i++) {
      average.add(vNormals[i]);
    }

    average.div(vNormals.length);


    return average;
  }

  void drawAverageNormal () {
    moved = PVector.add(this.location, PVector.mult(this.averageNormal(), 14));

    stroke (255);
    strokeWeight(1);
    //line(this.location.x, this.location.y, this.location.z,  moved.x, moved.y, moved.z);
    line(this.location.x, this.location.y, this.location.z, moved.x, moved.y, moved.z);

    //  line (zero.x, zero.y, zero.z, moved.x, moved.y, moved.z);
  }



  /////////////////// RAY TRACING INTERSECTION CALCULATIONS///////////////////

  PVector intersectionPoint (float distance, PVector direction) { // add  float distance in argument

    //    float t = this.planeIntersectionDist(p, f, faceNormal); // should be left as float t 
    if (distance>= -1E-10) {
      float t = distance;


      PVector X= PVector.add(this.location, PVector.mult(direction, t));
      //stroke(255, 255, 255);
      // strokeWeight(1);
      //line(this.location.x, this.location.y, this.location.z, X.x, X.y, X.z);
      //point( X.x, X.y, X.z);


      return X;
    }

   //  println("Negative t");
    return null;
  }



  boolean intersectionSphere (Face f, PVector direction) {

    this.CO = PVector.sub(f.centroid(), this.location);  // vector from vertex to centroid of quad face

    float tca = direction.dot(CO);

    if (tca <= 0) { 

      return false;
    }

    float b2 = (CO.dot(CO)) - (tca*tca) ;  // distance between the centroid and ray 

    //PVector radius = PVector.sub((f.fVertexs[0].location) , f.centroid());

    PVector n = f.fVertices[0].location;
    PVector c = f.centroid();

    //float r = dist( n.x, n.y, n.z, c.x, c.y, c.z); 
    //float r2 = r*r;

    float r2 = f.longestD();

    strokeWeight(2);
    stroke(100);
    point(c.x, c.y, c.z);

    if (b2 > r2) { 

      return false;
    }




    return true;
  }



  float plane_i_dist (Face f, PVector p, PVector direction) { // this function returns the distance between the intersection point with the plane of the face  and this node. 

    // p = point on plane 
    // f = face on plane

    // Vertex p = f.fVertexs[0];

    float a = ((p).dot(f.normal())) - ((this.location).dot(f.normal()));
    // float a = (PVector.sub(this.location, p.location)).dot(faceNormal);
    float b = (direction).dot(f.normal());
    float t =  (float)((float)a/(float)b);
    //println("distance =" + t);
    return t;
  }


  boolean sameSide ( PVector p1, PVector p2, PVector A, PVector B) {

    PVector cp1 = (PVector.sub(B, A)).cross(PVector.sub(p1, A));
    PVector cp2 = (PVector.sub(B, A)).cross(PVector.sub(p2, A));

    if ((cp1.dot(cp2)) >= 0) {
      return true;
    } 

    return false;
  }

  boolean pointInQuad( Vertex A, Vertex B, Vertex C, Vertex D ) {


    PVector a = A.location;
    PVector b = B.location;
    PVector c = C.location;
    PVector d = D.location;
    

    if ((this.sameSide(this.location, b, c, d)) && (this.sameSide(this.location, a, b, c)) 

    && (this.sameSide(this.location, a, d, c)) && (this.sameSide(this.location, d, a, b)) ) {

      return true;
    }
    return false;
  }


  boolean pointInTriangle( Vertex A, Vertex B, Vertex C) {

    PVector a = A.location;
    PVector b = B.location;
    PVector c = C.location;


    if ((this.sameSide(this.location, a, b, c)) && (this.sameSide(this.location, b, a, c)) 

    && (this.sameSide(this.location, c, a, b)) ) {

      return true;
    }
    return false;
  }


  boolean intersection (Face f) {

    //if (((this.averageNormal()).dot(PVector.sub(f.fVertexs[0].location,this.location ))) > 0) {

    if ((s.direction.dot(f.normal())) != 0) {

      // println ("Intersection found");
      return true ;
    }

    return false;
  }

  /////////////////////////////////////////////////////////////////////////


  void draw () {

    colorMode(HSB, 1, 1, 1);

    stroke (this.hue, 1, this.brightness);
    strokeWeight (2);
    point(this.location.x, this.location.y, this.location.z);
  }

  //  void drawRay ( PVector X ){
  //  stroke(255);
  //  strokeWeight(1);
  //  line(this.location.x, this.location.y, this.location.z, X.x, X.y, X.z);
  //    
  //  }
}


class Edge {

  Vertex from;
  Vertex to;
  Face left;
  Face right;

  Edge (Vertex from, Vertex to, Face left) {

    this.from = from;
    this.to = to;
    this.left = left;
  }

  boolean boundary () {
    return  ((this.right == null) || (this.left == null));
  }

  PVector midPoint () {
    //    PVector mid = PVector.add(this.from.location, this.to.location);
    //    mid.div(2);

    return PVector.div(PVector.add(this.from.location, this.to.location), 2);

    //return mid;
  }


  void draw () {
    colorMode (RGB, 255);
    stroke (255);
    strokeWeight (0.5);
    line(this.from.location.x, this.from.location.y, this.from.location.z, this.to.location.x, this.to.location.y, this.to.location.z);
  }
}


class Face {

  float area;
  PVector zero;
  PVector moved;
  boolean shadow;
  float hue;
  float globalSolarRadiation;

  ArrayList <Vertex> newVertices;

  Vertex [] fVertices; // vertices in anti-clockwise order 
  Edge [] fEdges;

  Face ( Vertex [] fVertices ) {

    this.fVertices = fVertices;
    this.fEdges = fEdges;
    this.area = this.area();

    this.newVertices = new ArrayList <Vertex> ();

    this.shadow = false; // false by default
    
    //this.globalSolarRadiation = s.globalSolarRad (this)* (this.area);
    
    
    
   // println("Faceglobalsolarrad "+this.globalSolarRadiation);
    //pushMatrix();
    //  this.addFace (new Face (this.fVertices));
    //popMatrix();


//    float a = 0.0f;
//
//    for ( int i=0; i<= this.fVertices.length; i++) {
//
//      int n = fVertices.length;
//
//      a = a + (((this.fVertices[i%n].location.x) * (this.fVertices[(i+1)%n].location.y)) -  ((this.fVertices[(i+1)%n].location.x) * (this.fVertices[i%n].location.y)));
//    } ////// TOD0: REPLACE THIS CALCULATION WITH VECTOR CROSS PRODUCT TO FIND AREA
//    //
//    this.area = 0.5f*a;
  }
  
  
  float area () {
    
    PVector U = PVector.sub(this.fVertices[2].location, this.fVertices[1].location);
    PVector V = PVector.sub(this.fVertices[0].location, this.fVertices[1].location);
    
    PVector UcrossV = U.cross(V);
    //float area = (UcrossV.dot(UcrossV)) *0.5;  // use dot product to find magnitude at less expense
    float area = UcrossV.mag();
    
    return area*(0.1*0.1); // returns area in metres squared
  }  
     
  
  
  
  float globalSolarRadiation () {
  //  println("hours in face class = "+s.hours);
    float globalSolarRadiation = s.globalSolarRad (this) * this.area  ;
//    println("area"+ this.area);
    return globalSolarRadiation;
  }


  PVector centroid () {

    zero = new PVector (0, 0, 0);

    for (int i=0; i<fVertices.length; i++) {
      zero = PVector.add(zero, fVertices[i].location);
    }

    zero.div(fVertices.length);


    moved = PVector.add(zero, PVector.mult(this.normal(), 5));

    return zero; // returns the vector of the centroid
  }



  PVector normal () {

    PVector zero = new PVector ();

    for (int i=0; i<fVertices.length; i++) {
      PVector cp = (fVertices[i].location).cross(fVertices[(i+1)% fVertices.length].location);
      zero.add(cp);
    }
    zero.normalize ();
    return zero;
  }

  void drawNormal () {
    PVector n = this.normal();
    PVector c = this.centroid();
    PVector m = PVector.add(c, PVector.mult(n, 5));
    colorMode(RGB, 255);
    stroke (255);
    strokeWeight(0.2);
    line (c.x, c.y, c.z, m.x, m.y, m.z);
  }

  void drawCentroid () {

    fill(1); 
    strokeWeight(4);
    point (zero.x, zero.y, zero.z);
  }
  
  float diagonal() {
    
    PVector diag = PVector.sub(this.fVertices[0].location, this.fVertices[2].location);
    float diagL = diag.dot(diag);
    
    return diagL;
  }

  float getAngleWith( Face f) {

    float theta = this.normal().dot(f.normal());

    return theta;
  }





  ////////////////////////////// SOLAR RADIATION CALCULATIONS ////////////////////////////// 

  float sunEnergyFactor () {

    float energy = (this.normal()).dot(s.direction);
    //if (energy < 0) energy = 0; // we want to allow negtive values to use for black faces

    return energy;
  }


  //////////////////////////////////////////////////////////////////////////////////////////

  // To find longest diagonal of face in order to draw largest possible shpere around the face (To test intersection)
  float longestD () {     

    float lengths2[] = new float [this.fVertices.length];

    for (int i =0; i<this.fVertices.length; i++) {

      PVector diagonal = (PVector.sub(this.fVertices[i].location, this.centroid())); // diagonal vector
      lengths2[i] = diagonal.dot(diagonal); // diagonal magnitude as A.A = |A| squared
    }

    float longest = lengths2[0];

    for (int i=0; i<lengths2.length; i++) {

      if ( lengths2[i] > longest ) {

        longest = lengths2[i];
      }
    }

    return longest;
  }

  //subdivides a face into 4 faces. Does not remove face, only uses face vertices
  Face [] subdivide () {

    Face [] subdivide = new Face [4];
    Manifold subdivideFace = new Manifold ();

    Vertex centroid =  subdivideFace.addVertex(this.centroid(), 1);


    for (int i=0; i<this.fVertices.length; i++) {


      Vertex prev = this.fVertices[i];
      Vertex curr = this.fVertices[(i+1)%this.fVertices.length];
      Vertex next = this.fVertices[(i+2)%this.fVertices.length];

      Vertex prevMidP = subdivideFace.addVertex ((PVector.div(PVector.add(prev.location, curr.location), 2)), 1);
      Vertex nextMidP = subdivideFace.addVertex ((PVector.div(PVector.add(curr.location, next.location), 2)), 1);

      Vertex [] newVertices = new Vertex [4] ;

      newVertices[0]= curr;
      //        println("zero " + newVertices[0]);
      newVertices[1]= nextMidP;
      this.newVertices.add(newVertices[1]);
      //        println("one  " + newVertices[1]);
      newVertices[2]= centroid;
      this.newVertices.add(newVertices[2]);
      //        println("two  " + newVertices[2]);
      newVertices[3]= prevMidP;
      this.newVertices.add(newVertices[3]);

      subdivideFace.addFace(newVertices);
      //println("number of faces produced from face = "+subdivideFace.faces.size());
    }

    // returns 4 faces
    return subdivideFace.faces.toArray(new Face [subdivideFace.faces.size()]);
  }


  float propSeeSun () {  // Returns a proportion of the number of vertices of the face that see the sun (Brightness =1)
    int a =0;
    for (int i=0; i<this.fVertices.length; i++) {
      if ( this.fVertices[i].brightness == 1.0 ) {
        a = a+1;
      }
    }
    float prop = a/this.fVertices.length;
    return prop;
  }

        void draw (float alpha) {
        colorMode(HSB, 1, 1, 1, alpha);
        strokeWeight(0);
        //stroke(255,255, 0);

        beginShape();
     
        for (int i=0; i<fVertices.length; i++) {

          fill(this.hue, 1, this.fVertices[i].brightness);

          vertex(this.fVertices[i].location.x, this.fVertices[i].location.y, this.fVertices[i].location.z);
        }

        endShape(CLOSE);
        // println("Area of face = "+ this.area);
      }
    }