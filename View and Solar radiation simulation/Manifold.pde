class Manifold {

  ArrayList <Vertex> vertices;
  ArrayList <Edge> edges;
  ArrayList <Face> faces;
  ArrayList <Floor> floors;
  ArrayList <Float> areas;
  float coolingCost;



  Manifold () {

    this.vertices = new ArrayList <Vertex> ();
    this.edges = new ArrayList <Edge> ();
    this.faces = new ArrayList <Face> ();
    this.floors = new ArrayList <Floor> ();
    this.areas = new ArrayList <Float> ();
  }

  Vertex addVertex (Vertex v) {
    this.vertices.add(v);
    return v;
  }

  Vertex addVertex (PVector location, int brightness) {

    Vertex v = new Vertex (location, brightness);

    this.vertices.add(v);
    return v;
  }
  
    void addVertex2 (PVector location, int brightness) {

    Vertex v = new Vertex (location, brightness);

    this.vertices.add(v);
    
  }
  
    int addVertex3 ( PVector location,  int brightness ) {
    this.vertices.add(new Vertex (location,  brightness));
    return this.vertices.size() -1;
  }



  Face addFace (Vertex [] vertices) {
    Face f = new Face(vertices);

    for (int i = 0; i<vertices.length; i++) {

      Vertex from = vertices[i];
      Vertex to = vertices[(i+1)%vertices.length];
      Edge e = to.edgeTo(from);

      if (e != null) {
        e.right = f;
      }
      else if (from.edgeTo(to) == null) {

        this.addEdge(from, to, f);
      }
      else {
        return null;
      }
    }
    this.faces.add(f);
    return f;
  }

  //    void addFace (Face f) {
  //      
  //    Vertex vertices [] = f.fVertices;
  //    
  //    //Face f = new Face(vertices);
  //
  //    for (int i = 0; i<vertices.length; i++) {
  //
  //      Vertex from = vertices[i];
  //      Vertex to = vertices[(i+1)%vertices.length];
  //      Edge e = to.edgeTo(from);
  //
  //      if (e != null) {
  //        e.right = f;
  //      }
  //      else if (from.edgeTo(to) == null) {
  //
  //        this.addEdge(from, to, f);
  //      }
  //      else {
  //        return null;
  //      }
  //    }
  //    this.faces.add(f);
  //    return f;
  //  }


  void addFace2 (Vertex fVertices []) {

    this.addFace (fVertices);
  }


  Face addFace (int[] vindex) { 

    Vertex[]fVertices = new Vertex [vindex.length]; 

    for (int i=0; i<vindex.length; i++) {

      fVertices [i] = vertices.get(vindex[i]);
    }


    Face ff= new Face ( fVertices);

    int n= vindex.length;

    for (int i=0; i<n; i++) {

      Vertex v1 = fVertices[i];          
      Vertex v2 = fVertices[(i+1) % n];


      Edge ee = v2.edgeTo(v1);            // search for edge in opposite direction


      if (ee != null) {                   // if opposite direction does exist then do NOT create face

        ee.right=ff ;
      }

      else if (v1.edgeTo(v2) == null) {

        this.addEdge(v1, v2, ff);
      }
    }

    this.faces.add(ff);  


    return ff;
  }



  Edge addEdge (Vertex v1, Vertex v2, Face left) {

    Edge e = new Edge(v1, v2, left);
    this.edges.add(e);
    v1.edges.add(e);
    v2.edges.add(e);
    return e;
  }


  float area (Face f) {

    float a = 0.0f;

    for ( int i=0; i<= f.fVertices.length; i++) {

      int n = f.fVertices.length;

      a = a + (((f.fVertices[i%n].location.x) * (f.fVertices[(i+1)%n].location.y)) -  ((f.fVertices[(i+1)%n].location.x) * (f.fVertices[i%n].location.y)));
    }
    float fa = 0.5f*a;
    return fa;
  }





  void addFloor (Dna DNA, Floor previous ) {

    // Create new floor
    Floor f = new Floor (DNA, previous);  

    // Add new floor to floor list
    this.floors.add(f);
   
    


    for (int i=0; i<f.floorFaces.size(); i++) {
      Face face = f.floorFaces.get(i);
      //this.addFace2(face.fVertices);
      this.faces.add(face);
    }

    for (int i=0; i<f.floorEdges.size(); i++) {
      Edge e = f.floorEdges.get(i);
      this.edges.add(e);
    }

    for (int i=0; i<f.floorVertices.size(); i++) {
      Vertex v = f.floorVertices.get(i);
      this.vertices.add(v);
    }
    
//    for(int i=0; i<f.windows.size(); i++){
//      Window w = f.windows.get(i);
//      for(int j=0; j>w.windowFaces.size(); j++){
//        Face fa = w.windowFaces.get(j);
//        this.faces.add(fa);
//      }
//    }
      
  }

  int whichFloor (Vertex v) {

    int vIndex = vertices.indexOf(v);

    int floorN = (vIndex/8)+1 ;

    return floorN;
  }

  //  Manifold subWindows () {
  //    Manifold m = new Manifold ();
  //    for (int i=0; i<this.floors.size(); i++) {
  //      int n = this.floors.get(i).windows.size();
  //      for (int j=0; j<n; j++) {
  //        m = this.floors.get(i).windows.get(j).refineMesh();
  //      }
  //    }
  //
  //
  //    //subWindows.remove(0);
  //    //           for(int i=0; i<subWindows.get(0).faces.size();i++){
  //    //             this.faces.remove(this.faces.indexOf(subWindows.get(0).faces.get(i)));
  //    //           }
  //    //           for(int i=0; i<subWindows.get(0).edges.size();i++){
  //    //             this.edges.remove(this.edges.indexOf(subWindows.get(0).edges.get(i)));
  //    //           }
  //    //           for(int i=0; i<subWindows.get(0).vertices.size();i++){
  //    //             this.vertices.remove(this.vertices.indexOf(subWindows.get(0).vertices.get(i)));
  //    //           }
  //
  //
  //    return m;
  //  }




  Manifold refineMesh () {

    Manifold refineMesh = new Manifold ();

    // New temporary array for face points
    Vertex [] facePoints = new Vertex [this.faces.size()];

    //Iterates through all the faces

    for (int i=0; i<this.faces.size();i++) {

      Face f = this.faces.get(i);

      // Fill facePoints array and add them to the array list
      facePoints[i] =  refineMesh.addVertex(f.centroid(), 1);

      //  println("Size of FacePoints Array " +facePoints.length);
      //  println("Cat Mull Clark Vertexs Array List "+refineMesh.vertices.size());
    }

    // Add midpoint for each link

    Vertex [] midPoints = new Vertex [this.edges.size()];
    for (int i=0; i<this.edges.size(); i++) {

      Edge e = this.edges.get(i);

      PVector edge = new PVector();
      edge = e.midPoint();

      midPoints[i] =  refineMesh.addVertex(edge, 1);

      //  println("Size of MidPoint Array " +midPoints.length);
      //  println("Cat Mull Clark Vertexs Array List "+refineMesh.vertices.size());
    }

    // Add original vertices - their location remain unchanged sinc we are not doing full CC subdivision 

    Vertex[] originalVertices = new Vertex [this.vertices.size()];
    for (int i=0; i<this.vertices.size(); i++) {

      Vertex n = this.vertices.get(i);

      originalVertices[i] = refineMesh.addVertex(n.location.get(), 1);

      // println("Size of Original Vertexs Array " +midPoints.length);
      // println("Cat Mull Clark Vertexs Array List "+refineMesh.vertices.size());
    }

    int num_faces = faces.size();
    for (int i = 0; i<num_faces; i++) {

      Face f = this.faces.get(i); // get each Face f from ORIGINAL Array List 

      for (int j=0; j< f.fVertices.length; j++) {  // iterate though Original Vertexs bounding faces

        Vertex prev = f.fVertices[j];
        Vertex curr = f.fVertices[(j+1)%f.fVertices.length];
        Vertex next = f.fVertices[(j+2)%f.fVertices.length];

        Edge nextEdge = curr.edgeWith(next);
        Edge previousEdge = curr.edgeWith(prev);

        // Edge from = prev.searchFromEdge();
        // Edge to = prev.searchToEdge();
        // Edge from = prev.linkTo(f.fVertexs[(j+2)%f.fVertexs.length]);



        Vertex [] newVertices = new Vertex [4] ;

        newVertices[0]= originalVertices[this.vertices.indexOf(curr)];
        //        println("zero " + newVertices[0]);
        newVertices[1]= midPoints[this.edges.indexOf(nextEdge)];
        //        println("one  " + newVertices[1]);
        newVertices[2]= facePoints[this.faces.indexOf(f)];
        //        println("two  " + newVertices[2]);
        newVertices[3]= midPoints[this.edges.indexOf(previousEdge)];
        //        println("three  " + newVertices[3]);

        refineMesh.addFace(newVertices);

        //        println(newVertices.length);
      }
    }

    this.vertices = refineMesh.vertices;
    this.edges = refineMesh.edges;
    this.faces = refineMesh.faces;

    return refineMesh;
  }


  void set(Manifold m) {

    this.vertices = m.vertices;
    this.edges = m.edges;
    this.faces = m.faces;
  }

  void update () {

    int n = this.vertices.size();
    //println("size "+n);
    int numFloors = (int) (DNA.bldgH* (1/ DNA.floorH)) ;
    int k= this.floors.get(0).floorVertices.size();
    for (int i= 0 ; i < n; i++) {

      PVector v = this.vertices.get(i).location;
      v.add(new PVector ( xValues[i%8], yValues[i%8], 0 ));
    }

    //    for(int j=0; j<this.floors.size(); j++){
    //      Floor fl = this.floors.get(j);
    //   //   for(int k = 0; k<fl.walls[0].fVertices.length; k++){
    //        
    //      fl.fe.E.location.add(new PVector ( xValues[0], yValues[0], 0 ));
    //      fl.fe.F.location.add(new PVector ( xValues[1], yValues[1], 0 ));
    //      fl.fe.G.location.add(new PVector ( xValues[2], yValues[2], 0 ));
    //      fl.fe.H.location.add(new PVector ( xValues[3], yValues[3], 0 ));
    //    }
  }

  // problem lies in xValues and yValues ..... 

  void update2 () {

    int n = this.floors .size();
    //println("size "+n);
    int numFloors = (int) (DNA.bldgH* (1/ DNA.floorH)) ;
    int k= this.floors.get(0).floorVertices.size();
    for (int i= 0 ; i < n; i++) {

      // PVector v = this.vertices.get(i).location
      Floor f = this.floors.get(i);

      for (int j=0; j<f.floorVertices.size(); j++) {
        PVector v = f.floorVertices.get(j).location;
        //    PVector v = this.floors.get(i).walls[j].fVertices[k])).location
        v.add(new PVector ( xValues[i%f.floorVertices.size()], yValues[i%f.floorVertices.size()], 0 ));
      }
    }

    //println("AAA "+this.vertices.get(this.vertices.indexOf(this.floors.get(0).walls[0].fVertices[0])).location);
  }

  //    void addFenestrations( int wallIndex, int numWindows, float windowH ) {
  //    
  //   for(int i=0; i<this.floors.size(); i++){
  //     Floor floor = this.floors.get(i);
  //     Face f= floor.floorFaces.get(floor.floorFaces.indexOf(floor.walls[wallIndex]));
  //     floor.addFenestration(f.fVertices, numWindows, windowH); 
  //     
  //     //floor.floorFaces.remove(floor.floorFaces.indexOf(floor.walls[wallIndex]));
  //   }
  //  }


  //  void updateSlope (int [] fVindex, float offsetX, float offsetY) {
  //    int numFloors = (int) (DNA.bldgH* (1/DNA.floorH)) ;
  //
  //    for (int j=0; j<fVindex.length; j++) {
  //
  //      Vertex floorV [] = new Vertex [numFloors];
  //      float a=0.0f;
  //      for (int i=0; i< floorV.length; i++) {
  //
  //        floorV[i] = this.getVertex( fVindex[j], i+1);
  //
  //        Vertex v = this.vertices.get(this.vertices.indexOf(floorV[i]));
  //        a = ((i+1.0f)/floorV.length)+a;
  //
  //        v.location.add (new PVector (lerp(0.0f, offsetX, a), lerp(0.0f, offsetY, a), 0));
  //      }
  //
  //      //      for (int k =0; k< floorV.length; k++) {
  //      //
  //      //        Vertex v = this.vertices.get(this.vertices.indexOf(floorV[k]));
  //      //     // float x = (bldgH / numFloors)*k;
  //      //      //  float a = (i+1)/floorV.length;
  //      //       //  float a = (k+1)/floorV.length;
  //      //       //  float a = (k+1)*(1/numFloors);
  //      //      float a = floorH* (k+2);
  //      //
  //      //       //  v.location.add (new PVector ((slope*cos(((PI)/numFloors) * k)),  (slope*sin(((PI)/numFloors) * k)), 0)); 
  //      //        //  v.location.add (new PVector ((slope*sin(((2*PI)/numFloors) * i)),  (slope*sin(((2*PI)/numFloors) * i)), 0)); 
  //      //      //   v.location.add (new PVector ((tan(radians(offsetX))*a), (tan(radians(offsetY))) *a, 0));
  //      //        v.location.add (new PVector (lerp(0, offsetX, a), lerp(0, offsetY, a), 0));
  //      //
  //      //      }
  //    }
  //  }


  void updateSlope () {

    for (int i=0; i<this.floors.size(); i++) {
      Floor f = this.floors.get(i);
      // f.top = flats.floors.get(flats.floors.size()-1);
      f.updateSlope(0, f.slopeFX, f.slopeFY);
      f.updateSlope(2, f.slopeBX, f.slopeBY);
    }
  }


  void fens () {
    for (Floor f: this.floors) {
      f.fens();
    }
  }

  Vertex getVertex (int index, int floorNumber) {

    Vertex v = this.vertices.get(index + (8*(floorNumber - 1)));

    return v;
  }


  void drawText () {
    for (int i=0; i<vertices.size(); i++) {
      Vertex v = vertices.get(i);  

      stroke(255, 204, 0);
      textSize(10);
      text("V" + i, v.location.x, v.location.y, v.location.z);
      //      int f = whichFloor(v); 
      //      text("Floor" + f, v.location.x, v.location.y, v.location.z);
    }
  }



  void getAreas () {

    for (int i=0; i<floors.size(); i++) {
      Vertex v [] = this.floors.get(i).getAreaBoundary(15.0f);
      //println("floor area "+ abs(this.floors.get(i).getArea()));
      //this.vertices.add(v);
    }
  }

  //void updateAreas () {


  float totalArea () {

    float tA = 0.0f;

    for (int i=0; i<this.floors.size(); i++) {

      tA = tA + this.floors.get(i).getArea();
    } 
    return tA;
  }

  Window [] frontWindows () {
    Window [] frontWindows = new Window [(this.floors.get(0).frontNumWindows) * this.floors.size()];
    for (int i=0; i<this.floors.size(); i++) {
      Floor f =  this.floors.get(i);
      int n = f.fenFront.windows.size();
      for (int j=0; j<n; j++) {
        frontWindows[(n*i)+j] = f.fenFront.windows.get(j);
        f.fenFront.windows.get(j).frontWindow=true;
      }
    }
    return frontWindows;
  }


  Window [] backWindows () {
    Window [] backWindows = new Window [(this.floors.get(0).backNumWindows) * this.floors.size()];
    for (int i=0; i<this.floors.size(); i++) {
      Floor f =  this.floors.get(i);
      int n = f.fenBack.windows.size();
      for (int j=0; j<n; j++) {
        backWindows[(n*i)+j] = f.fenBack.windows.get(j);
        f.fenBack.windows.get(j).backWindow = true;
      }
    }
    return backWindows;
  }


  Face [] getAboveCarpets (Floor f) {

    int fNum = f.floorNumber;

    int n = f.top.floorNumber - f.floorNumber;
    Face aboveCarpets [] = new Face [n];
    Floor ab = f;
    for (int i=0; i<n; i++) {
      aboveCarpets[i] = ab.aboveF.carpet;
      ab = ab.aboveF;
    }

    return aboveCarpets;
  }



  void rayTrace () {

    Window [] frontWindows = this.frontWindows();
    Window [] backWindows = this.backWindows();
    
        
     for (int i=0; i< backWindows.length ; i++) {  

      Window w = backWindows[i];

      int radiation  = w.calcRadiation(w.windowFaces.get(0), this.getAboveCarpets(w.floor)) ;
//      println("direct beam radiation on window "+i+ " = "+radiation);
//      println("area of window ="+w.area);
//      println("dims of window "+ w.width/10 +"by "+w.height/10);
//      println("transmittance through window "+i+" = "+w.transmittedE(30, 20));
//      println("solar radiation "+ s.globalSolarRad (w.glazing));
//      println("---------------------------");
    }

    for (int i=0; i< frontWindows.length ; i++) {  

      Window w = frontWindows[i];

      int radiation  = w.calcRadiation(w.windowFaces.get(0), this.getAboveCarpets(w.floor)) ;
//      println("direct beam radiation on window "+i+ " = "+radiation);
//      println("area of window ="+w.area);
//      println("dims of window "+ w.width/10 +"by "+w.height/10);
//      println("transmittance through window "+i+" = "+w.transmittedE(30, 20));
//      println("solar radiation "+ s.globalSolarRad (w.glazing));
     
    }

  }

  float coolingLoads () {
    String [] [] temperatures = s.temps;
    float CL = 0.0;
    int d = s.hours; // store initial sun direction in order to replace it back
    int e = s.day;
    int ff = s.month; 
    PVector currentDirection = s.direction;
//    println("orig hours = "+s.hours);
    for(int k =0; k< temperatures[0].length; k++){
      s.hours = k+1;
//      println("sun hours = "+s.hours);
       s.updateDirection();
//       println("zenith angle = "+s.zenithAngle);
      for(int j =0; j< temperatures.length; j++){  // temperatures.length = 3 (3 months) 
      s.day = 6;
      s.month = 8 - j;  
      
    
      //s.updateZenith();
      
      
   // for(int j=0; j< s.temps.length; j++){
      
    for (int i =0; i<this.floors.size(); i++) {
     // this.rayTrace(); // testing
      Floor f = this.floors.get(i);
    //   CL = CL+ f.coolingLoad(int(temperatures[j][k]), 15) + this.heatGainRoof(int(temperatures[j][k]), 15, f, j);
//    println("hours when cooling cost being calculated = "+s.hours);
       CL =  f.coolingLoad(int(temperatures[j][k]), 15);  // cooling load is in WATTS
     //  float kwh = ((CL*3600)/1000)/3600;
       float kwh = (CL)/1000;
       
       
     //  this.coolingCost = this.coolingCost + (((f.coolingLoad(int(temperatures[j][k]), 15))/1000)*0.17144);
         this.coolingCost = this.coolingCost + (((kwh*0.17144)));  // divided by 3 to obtain cooling cost per peak month (summer).
     //  println("external temperature = "+temperatures[j][k]);  
     //  println("CL cost ="+(((f.coolingLoad(int(temperatures[j][k]), 15))/1000)*0.17144));
     //  println("CL cost ="+(kwh*0.17144));
       
       
   //   CL = CL+ f.coolingLoad(int(hello[j][k]), 15) ;
   //   println("heatgainRoof "+i +" "+this.heatGainRoof(15, f, j));
   //   println ("cooling load at "+s.temps[j]+" = "+f.coolingLoad(s.temps[j], 15)); 
    }
   //   println ("total cooling load at "+s.temps[j]+" = "+CL); 
     
   // this.coolingCost = this.coolingCost + ((CL/1000) * 0.17144);
    }
      }
     this.coolingCost = (this.coolingCost/3)*30; 
    // put sun direction back to where it was
    s.hours = d; 
    s.day = e;
    s.month = ff;
    s.direction = currentDirection;

    // CL = CL + this.floors.get(this.floors.size()-1).heatGainRoof(15);
    //float average = CL/24;
    
//    println("Total CoolingLoad "+CL/1000);
      println("Cooling cost for a peak month (summer) = "+this.coolingCost+" Euro ");
      return (CL/(24*3))/1000;
  }

//  float coolingCost (float rate) {
//    float a = this.coolingLoads() *rate;
//    return a;
//  }
  
  float coolingFitness (int maximum) {
//    println("cooling cost = "+coolingCost);
    float a = ((maximum - this.coolingCost) );
    return a;
  }
    

  float heatGainRoof (int externalT, int internalT, Floor f, int index) {

    float roofH = 0;
    float area = 0;

    if (this.terrace(f) == true) {
      area = f.ceiling.area - round(f.aboveF.carpet.area);
//     println("terrace ");
//     println("area of carpet "+ round(f.aboveF.carpet.area));
    } 
    else if (f == f.top) {
      area = f.ceiling.area;
    } 
   

    float U = 0.59f;
    // assuming roof slab is 300mm and concrete

    float timeLag = 10.3f;
    float decrementF = 0.88f; //assumed ... must update
    float meanSolAirTemp = s.meanSolAirTemp(f.ceiling, timeLag, index);
    
    roofH = roofH + ((area*U) * ((meanSolAirTemp - internalT) + decrementF*((s.solAirTemp(externalT, timeLag, f.ceiling, index)) - meanSolAirTemp)));
     // println("jhiuhkjh "+ roofH);
  
    return roofH;
  }



  boolean terrace (Floor f) {
//  println("floor number ="+f.floorNumber);
    if (f.aboveF==null) {  

      return false;
    }
    else if (f.ceiling.area() > f.aboveF.carpet.area()) {
 //     println("terrace");
      return true;
    }
 //       println("area of ceiling = "+f.ceiling.area());
 //       println("area of aboveF caroet = "+f.aboveF.carpet.area());
    return false;
  }




  void mappedHSB() {
    
    
//    for(int j=0; j<this.floors.size();j++){
//      Floor f = this.floors.get(j);
//      for(int i=0; i<f.windows.size();i++){
//        Window w = f.windows.get(i);
//        Face fa = w.glazing;
//              float e  = (fa.sunEnergyFactor())*0.5; 
//
//      float te=0.0f;
//
//      if ((e >= 0.0f) && (e<=1/3f))
//      {
//        te = (1-(1/3f))+(e); 
//        //pintln (e+" is cool");
//      }
//      else
//      {
//        if ((e > 1/3f) && (e<= 0.5f)) 
//        {
//          te = (e) - (1/3f);
//        }
//        //println(e+ " is hot = " + j); }
//        else 
//        {
//          te=0.0f;
//        }
//      }
//
//      fa.hue = te;
//    }
//  }

    for (int i = 0; i<this.faces.size(); i++) {
      Face face = this.faces.get(i);
      // float e [] = new float [n];

      //println("Sun energy factor = "+ e[b]);
      float e  = (face.sunEnergyFactor())*0.5; 

      float te=0.0f;

      if ((e >= 0.0f) && (e<=1/3f))
      {
        te = (1-(1/3f))+(e); 
        //pintln (e+" is cool");
      }
      else
      {
        if ((e > 1/3f) && (e<= 0.5f)) 
        {
          te = (e) - (1/3f);
        }
        //println(e+ " is hot = " + j); }
        else 
        {
          te=0.0f;
        }
      }

      face.hue = te;
    }


    for (int i = 0; i<this.floors.size(); i++) {
      for (int j=0; j<this.floors.get(i).fenestratedFaces.size();j++) {

        Face face = this.floors.get(i).fenestratedFaces.get(j);
        // float e [] = new float [n];

        //println("Sun energy factor = "+ e[b]);
        float e  = (face.sunEnergyFactor())*0.5; 

        float te=0.0f;

        if ((e >= 0.0f) && (e<=1/3f))
        {
          te = (1-(1/3f))+(e); 
          //pintln (e+" is cool");
        }
        else
        {
          if ((e > 1/3f) && (e<= 0.5f)) 
          {
            te = (e) - (1/3f);
          }
          //println(e+ " is hot = " + j); }
          else 
          {
            te=0.0f;
          }
        }

        face.hue = te;
      }
    }
  }

//  void draw () {
//
//    drawVertices();
//    drawEdges();
//    drawFaces();
//    drawHabitableArea();
//    drawFenestratedVertices();
//    drawFenestratedEdges();
//    drawFenestratedFaces();
//    drawWindowFaces();
//  }


  void drawVertices () {

    for (Vertex v : this.vertices) {
      v.draw();
      
    }
  }

  void drawEdges () {

    for (Edge e : this.edges) {
      e.draw();
    }
  }

  void drawFaces (float alpha) {
    for (Face f : this.faces) {
      f.draw(alpha);
      //   f.centroid();
      f.drawNormal();
    }
  }

  void drawHabitableArea () {
    for (Floor f : this.floors) {
      f.drawHabitableArea();
    }
  }

  void drawFenestratedVertices() {
    for (Floor f : this.floors) {

      for (Vertex v : f.fenestratedVertices) {
        v.draw();
        
      }
    }
  }

  void drawFenestratedEdges() {
    for (Floor f : this.floors) {

      for (Edge e : f.fenestratedEdges) {
        e.draw();
      }
    }
  }

  void drawFenestratedFaces() {
    for (Floor f : this.floors) {

      for (Face face : f.fenestratedFaces) {
        face.draw(100);
       // face.drawNormal();
      }
    }
  }

  void drawWindowFaces () {
    for (Floor f: this.floors) {

      for (Window w : f.windows) {
         w.drawNormal();

        w.draw();
        // w.drawCentroid();
      }
    }
  }
  
}