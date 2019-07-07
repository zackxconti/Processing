class Fenestrated {

  Face wall;
  Face lintel;
  Face sill;
  float lintelH;
  float sillH;
  float x; 
  

  float glazingRatio;

  ArrayList <Vertex> windowTopVertices;
  ArrayList <Vertex> windowBottomVertices;

  Vertex [] lintelVertices;
  Vertex [] sillVertices;

  Vertex [] wallVertices;
  int numberWindows;
  float windowHeight;
  float windowWidth;
  Vertex A;
  Vertex B;
  Vertex C;
  Vertex D;

  Vertex E;
  Vertex F;
  Vertex G;
  Vertex H;

  Floor floor;
  float offsetX;
  float offsetY;

  //CHECK: Controls height of lintel. Needs to become slider ? 


  ArrayList <Vertex> vertices;
  ArrayList <Edge> edges;
  ArrayList <Face> faces;
  ArrayList <Window> windows;

  Fenestrated (Vertex [] wallVertices, int numberWindows, float windowHeight, float windowWidth, Floor floor, float offsetX, float offsetY) {
    //  Fenestrated (Face wall , int numberWindows, float windowHeight, Floor floor) {  



    this.vertices = new ArrayList <Vertex> ();
    this.edges = new ArrayList <Edge> ();
    this.faces = new ArrayList <Face> ();
    this.windows = new ArrayList <Window> ();

    this.windowTopVertices = new ArrayList <Vertex> ();
    this.windowBottomVertices = new ArrayList <Vertex> ();

    this.wallVertices = wallVertices;
    this.numberWindows = numberWindows;
    this.windowHeight = windowHeight;
    this.windowWidth = windowWidth;
    this.floor = floor;
    this.offsetX = offsetX;
    this.offsetY = offsetY;




    ///////////////////// Adds fVertices to vertices list ///////////////////// 

    for (int i =0; i<this.wallVertices.length; i++) {

      this.vertices.add(this.wallVertices[i]);
    }

    ///////////////////////////////////////////////////////////////////////////


    A = this.wallVertices[0];
    B = this.wallVertices[1];
    C = this.wallVertices[2];
    D = this.wallVertices[3];


  //  println("DRAWING FENESTRATED");


    PVector AB = PVector.sub(B.location, A.location); 
    PVector AD = PVector.sub(D.location, A.location); 

    Vertex k = addVertex( (PVector.add(A.location, PVector.mult(AB, 0.5))), 1);

    PVector dirAB = AB.normalize(null); // direction of vertical edge 
    PVector dirAD = AD.normalize(null); // direction of horizontal edge

    PVector ABmid = PVector.add(A.location, PVector.mult(AB, 0.5));

    float wallWidth = AD.mag();

    float wallHeight = AB.mag();

    float num = (float) this.numberWindows ;
    float n = 1/ (num+1.0f);
    //println("n " +n);

    float width = wallWidth / ((2.0f*num) + 1.0f);
    float wH = this.windowHeight * wallHeight;


    ///////////////////// Add centre points and windows /////////////////////

    for (int i=0; i<this.numberWindows; i++) {


      PVector c = PVector.add(ABmid, PVector.mult(AD, n*(i+1)));
      Vertex central = addVertex (c, 1);
      //k.add(AD);
      //k.mult(n*(i+1));
      if(num == 1) {
        width = wallWidth*this.windowWidth;
      }

      Window w = new Window( central.location, width, wH, dirAD, dirAB, this.floor.windowMaterial, this.floor );
     
      this.windows.add(w);

      this.windowBottomVertices.add(w.wVertices[0]);
      this.windowTopVertices.add(w.wVertices[1]);
      this.windowTopVertices.add(w.wVertices[2]);
      this.windowBottomVertices.add(w.wVertices[3]);

      for (int j=0; j<w.wVertices.length; j++) {

        Vertex v = addVertex((w.wVertices[j].location), 1);
      }
    }

    this.lintelVertices = new Vertex [(this.windows.size()*2)+4];
    this.sillVertices   = new Vertex [(this.windows.size()*2)+4];


    PVector BA = PVector.mult(AB, -1);
    PVector dirBA = BA.normalize(null);

    this.E = addVertex((PVector.add(ABmid, PVector.mult(dirBA, (wH*0.5)))), 1);
    this.G = addVertex((PVector.add(ABmid, PVector.mult(dirAB, (wH*0.5)))), 1);

    PVector DC = PVector.sub(C.location, D.location);
    PVector dirDC = DC.normalize(null);
    PVector CD = PVector.mult(DC, -1);
    PVector dirCD = CD.normalize(null);
    PVector DCmid = PVector.add(D.location, PVector.mult(DC, 0.5));

    this.F = addVertex((PVector.add(DCmid, PVector.mult(dirCD, (wH*0.5)))), 1);
    this.H = addVertex((PVector.add(DCmid, PVector.mult(dirDC, (wH*0.5)))), 1);

    ///////////////////// Add lintel vertices to one list ///////////////////// 






    ///////////////////// Add lintel /////////////////////

    int s = this.windowTopVertices.size();

    this.lintelVertices [0] = F;
    this.lintelVertices [1] = D;
    this.lintelVertices [2] = A;
    this.lintelVertices [3] = E;
    int b = 4;

    for ( int i=s; i>0; i--) {
      //  this.lintelVertices.add(this.windowTopVertices.get(i));
      Vertex v = this.windowTopVertices.get(i-1);
      this.lintelVertices[b] = v;
      b=b+1;
    }

    this.lintel = addFace(this.lintelVertices);



    ///////////////////// Add sill /////////////////////



    this.sillVertices [0] = G;
    this.sillVertices [1] = B;
    this.sillVertices [2] = C;
    this.sillVertices [3] = H;
    int h = 4;

    for ( int i=0; i<s; i++) {

      Vertex v = this.windowBottomVertices.get(i);
      this.sillVertices[h] = v;
      h=h+1;
    }


    this.sill = addFace(this.sillVertices);


    ///////////////////// Add first wall panel /////////////////////

    Vertex [] firstPanelV = new Vertex [4];

    firstPanelV [1] = G;
    firstPanelV [0] = E;
    firstPanelV [2] = this.windows.get(0).wVertices[3];
    //   firstPanelV[2] = this.windows.get(windows.size()-1).wVertices[1];
    firstPanelV [3] = this.windows.get(0).wVertices[2];
    // firstPanelV[3]=this.windows.get(windows.size()-1).wVertices[0];

    Face fp = addFace(firstPanelV);


    ///////////////////// Add wall panels in between windows /////////////////////


    for (int i=0; i<(this.numberWindows-1); i++) {

      Vertex [] panelV = new Vertex [4];

      panelV[0] = this.windows.get(i).wVertices[1];
      panelV[1] = this.windows.get(i).wVertices[0];
      panelV[2] = this.windows.get(i+1).wVertices[3];
      panelV[3] = this.windows.get(i+1).wVertices[2];

      Face f = addFace (panelV);
    }

    ///////////////////// Add last wall panel /////////////////////

    Vertex [] lastPanelV = new Vertex [4];

    lastPanelV [0] = this.windows.get(windows.size()-1).wVertices[1];
    lastPanelV [1] = this.windows.get(windows.size()-1).wVertices[0];
    lastPanelV [2] = H;
    lastPanelV [3] = F;

    Face lp = addFace(lastPanelV);

    ///////////////////////////////////////////////////////////////

    float glazingArea = 0;
    float wallArea = wallWidth * wallHeight;

    for (int i=0; i<this.windows.size(); i++) {
      //  float a = this.windows.get(i).width * this.windowHeight;
      glazingArea = glazingArea + this.windows.get(i).area;
    }

    this.glazingRatio = glazingArea / wallArea ;
  //  println("glazing ratio = "+this.glazingRatio);
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
    this.faces.add(f);
    return f;
  }


  Vertex addVertex ( PVector location, int brightness ) {

    Vertex v = new Vertex (location, brightness);
    this.vertices.add(v);
    return v;
  }


  Edge addEdge (Vertex v1, Vertex v2, Face left) {

    Edge e = new Edge(v1, v2, left);
    this.edges.add(e);
    v1.edges.add(e);
    v2.edges.add(e);
    return e;
  }

  void updateVs () {
    A = this.wallVertices[0];
    B = this.wallVertices[1];
    C = this.wallVertices[2];
    D = this.wallVertices[3];
  }
}