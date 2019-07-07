class Floor {

  float floorH;
  float stretchX;
  float stretchY;
  float slopeFX;
  float slopeFY;
  float slopeBX;
  float slopeBY;
  float v0x;
  float v0y;
  float v2x;
  float v2y;
  int floorNumber;
  int frontNumWindows;
  int win;
  float frontWindowH;
  float frontWindowW;
  int backNumWindows;
  float backWindowH;
  float backWindowW;
  int windowMaterial;

  int fs [];
  Face  ceiling;
  Face  carpet;
  Face walls [] ;  // TODO: to eventually write a function that indicates the orientation of the wall, eg: North wall
  ArrayList <Vertex> floorVertices;
  ArrayList <Edge> floorEdges;
  ArrayList <Face> floorFaces;

  ArrayList <Vertex> fenestratedVertices;
  ArrayList <Edge> fenestratedEdges;
  ArrayList <Face> fenestratedFaces;
  ArrayList <Window> windows;

  Floor previousF;
  Floor aboveF;
  Floor belowF;
  Floor top;
  Fenestrated fe;
  Fenestrated fenFront;
  Fenestrated fenBack;
  float zek;
  ArrayList <Vertex> areaVertices;
  Face aboveCarpets [];

  PVector moved;
  // PVector areaVertex;

  float a;

  // Floor (float floorH, float stretchX, float stretchY, float slopeFX, float slopeFY, float slopeBX, float slopeBY, float v0x, float v0y, float v2x, float v2y, Floor previous ) {
  Floor (Dna DNA, Floor previous ) {
    //println("topfloorrrr"+this.top);
    this.floorH = DNA.floorH;
    this.stretchX = DNA.stretchX;
    this.stretchY = DNA.stretchY;
    this.slopeFX = DNA.slopeFX;
    this.slopeFY = DNA.slopeFY;
    this.slopeBX = DNA.slopeBX;
    this.slopeBY = DNA.slopeBY;
    this.v0x = DNA.v0x;
    this.v0y = DNA.v0y;
    this.v2x = DNA.v2x;
    this.v2y = DNA.v2y;

    this.frontNumWindows = DNA.frontNumWindows;
    this.frontWindowH = DNA.frontWindowH;
    this.frontWindowW = DNA.frontWindowW;
    this.backNumWindows = DNA.backNumWindows;
    this.backWindowH = DNA.backWindowH;
    this.backWindowW = DNA.backWindowW;
    this.windowMaterial = DNA.windowMaterial;


    if (this.floorNumber > 0 ) {
      this.zek = ((this.floorNumber+1.0f) / (this.top.floorNumber+1.0f)) +(this.previousF.a);
    }


    // this.NumWindows = DNA.frontNumWindows;
    // this.WindowH = DNA.frontWindowH;
    //this.a = 0.0f;
    this.previousF = previous;

    this.ceiling = ceiling;
    this.carpet = carpet;
    this.walls = new Face [4];
    //    this.aboveCarpets = new Face [this.top.floorNumber - this.floorNumber];

    Vertex [] fb = new Vertex[4];
    Vertex [] ft = new Vertex[4];
    fs = new int [4];

    this.top = topFloor;
    this.moved = moved;
    this.floorVertices = new ArrayList <Vertex>();
    this.floorFaces = new ArrayList <Face>();
    this.floorEdges = new ArrayList <Edge>();

    this.areaVertices = new ArrayList <Vertex> ();

    this.fenestratedVertices = new ArrayList <Vertex> ();
    this.fenestratedEdges = new ArrayList <Edge> ();
    this.fenestratedFaces = new ArrayList <Face> ();
    this.windows = new ArrayList <Window> ();

    //    fill(255, 255, 255);
    //    strokeWeight(50); 
    if (this.previousF == null) {

      this.floorNumber = 0;
    } 
    else { 

      this.floorNumber = this.previousF.floorNumber + 1;
    }




    // int numFloors = (int) (DNA.bldgH* (1/ DNA.floorH)) ;

    float tita = 2*PI/4;
    //float c = DNA.floorH* (floorNum);
    float z = 0.0f;

    if (this.previousF == null) {

      z = 0.0f;
    } 
    else { 
      z = this.previousF.ceiling.fVertices[1].location.z;
    }
    for (int i=0; i<4 ; i++) {


      ft[i] = addVertex (new PVector (((this.stretchX+(0))*cos((tita*i)+tita/2)), ((this.stretchY+(0))*sin((tita*i)+tita/2)), this.floorH + z ), 1);  

      //  fb[4-i-1] = new Vertex (new PVector (((DNA.stretchX+(0))*cos((tita*i)+tita/2)), ((DNA.stretchY+(0))*sin((tita*i)+tita/2)), z ));
      fb[4-i-1] = addVertex (new PVector (((this.stretchX+(0))*cos((tita*i)+tita/2)), ((this.stretchY+(0))*sin((tita*i)+tita/2)), z ), 1);
      //   fb[i] = addVertex (new PVector (((this.stretchX+(0))*cos((tita*i)+tita/2)), ((this.stretchY+(0))*sin((tita*i)+tita/2)), z ), 1);
    }
    Face f  = this.addFace (ft); 
    //   println("indexxx " + this.floorFaces.indexOf(f));
    // this.floorFaces.add(new Face (ft));
    Face v = this.addFace (fb);
    //  this.carpet = this.addFace(fb);

    for (int i=0; i<4; i++) {

      fs[0] = (i*2);
      fs[1] = ((i*2) + 1);
      fs[2] = (((i*2) + 3)%(4*2));
      fs[3] = (((i*2) +2)%(4*2));

      //  Face fn = new Face (fs);


      this.walls [i] = this.addFace (fs);
      //  this.updateSlope(i, this.slopeFX, this.slopeFY);
    }
    this.update();
    this.updateSlope(0, this.slopeFX, this.slopeFY);
    this.updateSlope(2, this.slopeBX, this.slopeBY);


    // albedo value for work asphalt (pavement) = 0.12
    // direct beam radiation (extraterrestrial) is 1367 W/m^2. After atmosphere, it is 1050 W/m^2 - approx values that vary according to the weather
    // global Horizontal radiation in Malta in July to be take as 8000 W. Refer to farrugia paper

    this.ceiling = new Face ((this.floorFaces.get(this.floorFaces.indexOf(f))).fVertices);
    ;

    //   println("index " + this.floorFaces.indexOf(ft));
    this.carpet = new Face ((this.floorFaces.get(this.floorFaces.indexOf(v))).fVertices);

    this.fens();

    //  println("TOP "+ this.top);
    // this.heatGainRoof (15);
  }


//  int maximumViewScore () {
//    int totalMax = 0;
//    //for(int i=0; i<this.windows.size(); i++){
//    int max = this.windows.get(0).maxScore();
//    totalMax = totalMax + max;
//    //   }
//    return totalMax*2;
//  }

  float maximumViewScore () {

    float totalScore = 0;

    for (int e = 0; e<this.walls.length; e+=2) {
      Face w = this.walls[e];
     

      PVector [] eyeballs = this.getEyeBalls(1.7);


      for (int i=0; i< eyeballs.length;i++) {
        PVector [] sampleBoundary = new PVector [2]; 
        PVector [] fov = new PVector [2];


        for (int j=0; j< w.fVertices.length; j+=2) { 


          PVector FOV = PVector.sub(w.fVertices[j].location, eyeballs[i]);
          FOV.normalize();
          fov[j/2] = FOV;
        }

        for (int k=0; k< w.fVertices.length; k+=2) { 
          PVector FOV = PVector.sub(w.fVertices[k].location, eyeballs[i]);

          FOV.normalize();

          float azimuth = atan2(FOV.y, FOV.x);

          if (azimuth<0) azimuth = (2*PI)-abs(azimuth);
          if (azimuth>0) azimuth = azimuth;

          float elevation = asin(FOV.z);

          float U =( azimuth*image.width)/ (2*PI);

          float TW = ((abs(elevation)*image.width)/(2*PI));

          float V = 0;

          if (elevation < 0) {  

            // println("elevation < 0");

            float prevElevation = asin(fov[1].z);
            float prevTW =(abs(prevElevation) * image.width)/(2*PI);
            float prevx = (prevTW)/tan(prevElevation);
            float prevY = ((prevTW)*(((this.floorH+17)*this.floorNumber)+prevx))/prevx;

            float prevV = (image.height/2) - prevY;

            V = prevV + prevTW + TW;
          } 
          else { 


            float x = (TW)/tan(elevation);
            float Y = ((TW)*(((this.floorH+17)*this.floorNumber)+x))/x;
            //   println("Y = "+Y);

            V = (image.height/2) - Y;
          }



          Line l = new Line (eyeballs[i], PVector.add(eyeballs[i], PVector.mult(FOV, sqrt((FOV.z*FOV.z) +1)*view.rad)));
          view.lines.add(l);

          //         vertex(PVector.add(eyeballs[i], PVector.mult(FOV, 500)).x, PVector.add(eyeballs[i], PVector.mult(FOV, 500)).y, PVector.add(eyeballs[i], PVector.mult(FOV, 500)).z);

          sampleBoundary[k/2] = new PVector (U, V);
        }

        PVector A = sampleBoundary[1];
        PVector B = sampleBoundary[0];   

        //          println("image height ="+image.height);
        //          println("A.y ="+A.y);
        //          println("B.y ="+B.y);
        totalScore = totalScore + ((int)((A.x - B.x) * (A.y - B.y) * 6));
   //     println (" total score of one eye ball = "+ totalScore);
      //  println("minimum score =  " + (int)((A.x - B.x) * (A.y - B.y) * 1));

      }
    }
 //   println("maximum score of floor = "+totalScore);
    return totalScore;
  }





  float viewCost(View view) {
    float cost = 0;
    for (int i=0; i<this.windows.size(); i++) {
  //    println("window "+ i+ " ------- ");
      float a = this.windows.get(i).viewCost(view);
      cost = cost + a;
    }
 //   println("total view cost of this floor = "+cost);
    return cost;
  }


  float coolingLoad (int externalT, int internalT) {

    // sample temps from (http://freemeteo.com/default.asp?pid=20&gid=2562305&sid=165970&la=1&lc=1&nDate=18/7/2012)
    // July 18th 2012
    float total = 0.0f;

    for (int j=0; j<this.windows.size(); j++) {
      Window w = this.windows.get(j);
      // w.viewCost(view);
      //   int d = s.hours;
      //   println(" floor "+this.floorNumber+" " +"window "+j);
     
      total = total + (w.transmittedE( externalT, internalT ));
      //   s.hours = d;
    }

    //   float average = total/24;
    //   println("cooling load for floor "+this.floorNumber+ " = "+total);

    return total;
  }


  // float heatGainRoof (int externalT, int internalT) {
  //    
  //    float roofH = 0;
  //    float area = 0;
  //    
  //    if(this.aboveF == null){
  //      area = this.floorFaces.get(this.floorFaces.indexOf(ceiling)).area() ;
  //  //    println("this.floorNum "+this.floorNumber);
  //      //println("area of carpet "+ round(f.aboveF.carpet.area));
  //    } else {
  //    //if (this.ceiling.area < this.aboveF.carpet.area) { 
  //   //   println("above F " + this.aboveF.carpet.area);
  //      area = this.ceiling.area() - round(this.aboveF.carpet.area());
  //    } //else {
  //      //area = 0;
  //      //   }
  //    
  //    float U = 0.59f;
  //    // assuming roof slab is 300mm and concrete
  //
  //    float timeLag = 10.3f;
  //    float decrementF = 0.88f; //assumed ... must update
  //    float meanSolAirTemp = s.meanSolAirTemp(this.ceiling, timeLag);
  //    
  //       roofH = roofH + ((area*U) * ((meanSolAirTemp - internalT) + decrementF*((s.solAirTemp(externalT, timeLag, this.ceiling)) - meanSolAirTemp)));  // 
  //     //  println("ceiling area"+ this.ceiling.area);
  //     //  println("above carpet area "+this.aboveF.carpet.area); 
  //    
  //    return roofH;
  //    
  //  }


  PVector [] getEyeBalls (float eyeLevel) {

    PVector [] eyeBalls = new PVector [4];
    Face [] faces = this.carpet.subdivide();
    for (int i=0; i<faces.length; i++) {
      PVector centre = faces[i].centroid();
      eyeBalls[i] = PVector.add(centre, PVector.mult(faces[i].normal(), eyeLevel*-10));
    }

    return eyeBalls;
  }


  void drawEyeBalls () {

    PVector pos []  = this.getEyeBalls(1.7);
    for (int i = 0; i<pos.length; i++) {

      stroke(255);
      strokeWeight(2);
      point(pos[i].x, pos[i].y, pos[i].z);
    }
  }


  boolean terrace () {

    if (this.aboveF==null) {  

      return false;
    }
    else if (this.ceiling.area() >= this.aboveF.carpet.area()) {
      //    println("area of ceiling = "+this.ceiling.area());
      //    println("area of aboveF caroet = "+this.aboveF.carpet.area());
      return false;
    }

    return true;
  }




  void aboveF () {

    if (this == this.top) {
      this.aboveF = null;
    } 

    else {

      //    if(this.floorNumber>0){


      int n = (this.top.floorNumber) - this.floorNumber -1;
      if (n==0) {
        this.aboveF = this.top;
      } 
      else {


        Floor f = this.top;
        for (int i =0; i<n; i++) {
          this.aboveF = f.previousF;
          f=this.aboveF;
        }

        //  }
      }
    }


    //return this.aboveF;
  } 


  //  int topFloor () {
  //    int n = topFloor.floorNumber;
  //    println("top = "+n);
  //    return n;
  //  }

  //  Face getAboveCarpet () {
  //    Face c = this.aboveF.carpet;
  //    return c;
  //  }
  //  
  //    Face [] getAboveCarpets () {
  //
  //    int fNum = this.floorNumber;
  //
  //    int n = this.top.floorNumber - this.floorNumber;
  //    Face aboveCarpets [] = new Face [n];
  //    Floor ab = this;
  //    for (int i=0; i<n; i++) {
  //      aboveCarpets[i] = ab.aboveF.carpet;
  //      ab = ab.aboveF;
  //    }
  //
  //    return aboveCarpets;
  //  }


  void update () {
    int n = this.floorVertices.size();
    for (int i= 0 ; i < n; i++) {

      PVector v = this.floorVertices.get(i).location;
      v.add(new PVector ( xValues[i%8], yValues[i%8], 0 ));
    }
  }

  void fens () {
    this.fenFront = this.addFenestrations(0, this.frontNumWindows, this.frontWindowH, this.frontWindowW, this.slopeFX, this.slopeFY);
    int solarRad =(int) fenFront.windows.get(0).glazing.globalSolarRadiation();
    // float totalS = solarRad * fenFront.windows.get(0).area;
    //    println ( "Solar Radiation on each of FRONT Windows = "+solarRad + " Watts/m2" );
    //on Area of : "+fenFront.windows.get(0).glazing.area);
    //      int transm = (int) fenFront.windows.get(0).transmittedE( 15, 20, fenFront.windows.get(0).area*0.5);  
    //   println ("Transmitted Radiation through each of FRONT Windows = "+transm);

    this.fenBack = this.addFenestrations(2, this.backNumWindows, this.backWindowH, this.backWindowW, this.slopeBX, this.slopeBY);
  }

  void updateSlope (int wallIndex, float offsetX, float offsetY) {
    // int numFloors = (int) (DNA.bldgH* (1/DNA.floorH)) ;


    Face wall = this.walls[wallIndex];
    // Vertex [] updatedVs = new Vertex [this.walls.length];
    //Vertex [] wallV = wall.fVertices;
    if (this.floorNumber > 0 ) {
      //  a=0.0f;
      //     println("topFloor"+topFloor);
      a = ((this.floorNumber+1.0f) / (topFloor.floorNumber+1.0f)) +(this.previousF.a);
      //     println("a = "+ topFloor.floorNumber);
    }

    for (int j=0; j<wall.fVertices.length; j++) {

      Vertex v =  this.floorVertices.get(this.floorVertices.indexOf(wall.fVertices[j]));

      v.location.add (new PVector (lerp(0.0f, offsetX, a), lerp(0.0f, offsetY, a), 0));
      // updatedVs [j] = 
      //this.floorVertices.get(this.floorVertices.indexOf(wall.fVertices[j]) = v;
    }
    // for(int i=0; i<this.floorVertices.size();i++){


    //    fenFront.updateVs();
    //    fenBack.updateVs();


    //    println("UPDATE SLOPE");
  }

  Fenestrated addFenestration ( Vertex [] fVertices, int numWindows, float windowH, float windowW, float offsetX, float offsetY) {

    // fVertices = new Vertex [a.length];
    //    fVertices = a;

    if (numWindows > 0) {
      this.fe = new Fenestrated(fVertices, numWindows, windowH, windowW, this, offsetX, offsetY);
      //
      for (int i=0; i<this.fe.faces.size(); i++) {
        this.fenestratedFaces.add(this.fe.faces.get(i));
        //this.floorFaces.add(this.fe.faces.get(i));
      }
      for (int i=0; i<this.fe.vertices.size(); i++) {
        this.fenestratedVertices.add(this.fe.vertices.get(i));
      }
      for (int i=0; i<this.fe.edges.size(); i++) {
        this.fenestratedEdges.add(this.fe.edges.get(i));
      }
      for (int i=0; i<this.fe.windows.size(); i++) {
        this.windows.add(this.fe.windows.get(i));
      }
    }
    return this.fe;
  }


  Fenestrated addFenestrations( int wallIndex, int numberWindows, float windowHeight, float windowWidth, float offsetX, float offsetY ) {

    //Face f = this.floorFaces.get(this.floorFaces.indexOf(this.walls[wallIndex]));
    Face f = this.walls[wallIndex];

    Fenestrated fen = this.addFenestration(f.fVertices, numberWindows, windowHeight, windowWidth, offsetX, offsetY); 

    //   println("Af "+f.fVertices[0].location);
    this.floorFaces.remove(this.floorFaces.indexOf(this.walls[wallIndex]));

    int n = fen.faces.size();
    for (int i =0; i<n; i++) {
      // this.floorFaces.add(fen.faces.get(i));
    }

    return fen;
  }


  Vertex addVertex ( PVector location, int brightness ) {

    Vertex v = new Vertex (location, brightness);
    this.floorVertices.add(v);
    return v;
  }


  Edge addEdge (Vertex v1, Vertex v2, Face left) {

    Edge e = new Edge(v1, v2, left);
    this.floorEdges.add(e);
    v1.edges.add(e);
    v2.edges.add(e);
    return e;
  }


  Face addFace (Vertex vertices []) {
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
    this.floorFaces.add(f);
    return f;
  }

  Face addFace (int[] vindex) { 

    Vertex[]fVertices = new Vertex [vindex.length]; 

    for (int i=0; i<vindex.length; i++) {

      fVertices [i] = this.floorVertices.get(vindex[i]);
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

    this.floorFaces.add(ff);  


    return ff;
  }


  Face [] getWalls (Vertex v) {

    Face corrFaces [] = v.searchFace();
    ArrayList <Face> corrWalls = new ArrayList <Face> ();

    for (int i=0; i<corrFaces.length; i++) {
      Face f = corrFaces[i];
      for (int j=0; j<this.walls.length; j++) {
        if (f == this.walls[j]) {
          corrWalls.add(f);
          break;
        }
      }
    }
    // println("Number of corresponding Walls "+ corrWalls.size());
    return corrWalls.toArray(new Face [corrWalls.size()]);
  }



  PVector [] getWallEdgeVectors () {

    PVector [] edgeVectors = new PVector [this.carpet.fVertices.length];

    for (int i=0; i<this.carpet.fVertices.length; i++) {

      int a = i*2 ; 
      PVector vtop = this.floorVertices.get(a).location;
      PVector vbottom = this.floorVertices.get(a+1).location;

      PVector v = PVector.sub(vtop, vbottom);

      // new PVector (vtop.x, vtop.y, vtop.z);
      // v.sub(vbottom);
      //  v.normalize();
      // println(v.x+","+ v.y+","+ v.z+" should be equals to "+ vtop.x+","+ vtop.y+","+ vtop.z);
      //    v.add(vbottom);

      //    v.add(vtop);
      //    .sub(vbottom);

      edgeVectors [i] = v;
    }
    //  println("Edge Vectors length "+edgeVectors.length);
    return edgeVectors;
  }



  Vertex [] getAreaBoundary(float minHeight) {

    // get wall edges
    PVector [] edgeVectors = this.getWallEdgeVectors();
    PVector b = new PVector ();
    Vertex areaVertex = new Vertex (b, 1);


    for (int i=0; i<this.getWallEdgeVectors().length; i++) {
      Vertex v = this.carpet.fVertices[i];
      PVector e = edgeVectors[i];
      // PVector 

      //   float = e.mag();
      //       println(e.x +" , "+e.y+" , "+e.z);
      //       println("minimum height " +minHeight);
      // .add(
      // PVector k = new PVector();
      // k.add(e);


      int a = i*2 ; 
      //PVector vtop = this.floorVertices.get(a).location;
      PVector vbottom = this.floorVertices.get(a+1).location;



      float mu = (float)(minHeight)/ (float) (this.floorH);
      // println("mu = "+mu);
      // PVector see = new PVector((e.x*mu), (e.y*mu) , 0);
      PVector see = new PVector((e.x*mu), (e.y*mu), 0);
      //println(e.x * mu + ", "+ e.y*mu);
      //println(e.x + ","+ e.y);

      //PVector f = this.floor.fVertices[i].location;
      PVector h = new PVector();
      h.add(vbottom);
      h.add(see);
      // println("f ="+ f.x+" , "+f.y);
      //e.mult(mu); // check size 


        areaVertex = new Vertex (new PVector ((h.x), (h.y), v.location.z), 1);
      //      moved1.add(moved2);
      //      areaVertex = new Vertex (new PVector (moved2.x, moved2.y, v.location.z));
      this.areaVertices.add(areaVertex);
    }
    return this.areaVertices.toArray(new Vertex[areaVertices.size()]);
  }


  float getArea () {

    Vertex [] areaVs = this.areaVertices.toArray(new Vertex[areaVertices.size()]);

    Face zone = new Face (areaVs);

    float floorArea = zone.area;
    return floorArea;
  }



  void drawHabitableArea () {

    if ((area.value < area.min) || (area.value > area.max)) {
      fill(255, 0, 0, 200);
    } 
    else { 

      fill(127, 250, 0, 200);
    }
    strokeWeight(1);
    // point(this.moved.x, this.moved.y, this.moved.z);
    beginShape () ;
    for (int i=0; i<this.areaVertices.size(); i++) {
      vertex(this.areaVertices.get(i).location.x, this.areaVertices.get(i).location.y, this.areaVertices.get(i).location.z);
    }
    endShape(CLOSE);  
    strokeWeight(3);
    for (int i=0; i<this.areaVertices.size(); i++) {
      PVector v = this.areaVertices.get(i).location;
      point(v.x, v.y, v.z);
    }
  }


  //  void fenestrate () {
  //
  //    // for(int i=0; i<this.walls.length; i++) {
  //
  //    Face f = this.walls [0];
  //
  //    Fenestrated fe = new Fenestrated (f.fVertices, this.frontNumWindows, this.frontWindowH);
  //    //   }
  //  }
  //
  //
  //  void addFenestration ( Face f) {
  //    
  ////    Vertex [] fVertices = new Vertex [a.length];
  ////    fVertices = a;
  //    if (this.frontNumWindows > 0) {
  //      Fenestrated fe = new Fenestrated (f.fVertices, this.frontNumWindows, this.frontWindowH);
  //
  //      for (int i=0; i<fe.faces.size(); i++) {
  //        this.floorFaces.add(fe.faces.get(i));
  //      }
  //      for (int i=0; i<fe.vertices.size(); i++) {
  //        this.floorVertices.add(fe.vertices.get(i));
  //      }
  //      for (int i=0; i<fe.edges.size(); i++) {
  //        this.floorEdges.add(fe.edges.get(i));
  //      }
  //    }
  //  }
  //  


  //  void drawAreaVertices () {
  //    PVector v = this.getArea(20.0f);
  //    strokeWeight (3);
  //    stroke (255);
  //    point(v.x, v.y, v.z);
  //  }
}  
//      for(int j=0; j<corrWalls.length; j++) {
//        Face w = corrWalls[j];
//         float theta = w.getAngleWith(this.floor);
//         
//         Float offset [] = new Float [corrWalls.length];
//         offset[0] = minHeight / (tan(theta));

//  void draw () {
//    
//    strokeWeight(0);
//    //stroke(255,255, 0);
//
//    beginShape();
//
//      fill(255, 204, 0);
//
//      vertex(this.fVertices[i].location.x, this.fVertices[i].location.y, this.fVertices[i].location.z);
//    
//
//    endShape(CLOSE);
//    
//  // insert functions here
//  
//  }
//}