class Window {

  Vertex [] wVertices;

  PVector centre;
  PVector moved;
  // PVector zero;

  float width;
  float height;
  PVector dirWidth;
  PVector dirHeight;
  Face glazing;
  float area;
  int material;
  float uvalue;
  float shgc;
  Floor floor;
  Face [] aboveCarpets;
  Face wall;

  int rad;

  Float [] UVvalues;
  Float [] SHGCvalues;
  Float [] shadingF;
  Float [] airNF;

  ArrayList <Vertex> windowVertices;
  ArrayList <Edge> windowEdges;
  ArrayList <Face> windowFaces;

  ArrayList <Vertex> subVertices;
  ArrayList <Edge> subEdges;
  ArrayList <Face> subFaces;
  ArrayList <Face> cells;

  boolean backWindow;
  boolean frontWindow;

  // PVector plane should be either y-z plane (0,1,1) or x-z plane (1,0,1)

  Window (PVector centre, float width, float height, PVector dirWidth, PVector dirHeight, int material, Floor floor) {

    this.windowVertices = new ArrayList <Vertex> ();
    this.windowEdges = new ArrayList <Edge> ();
    this.windowFaces = new ArrayList <Face> ();
    this.cells = new ArrayList <Face> ();

    this.backWindow = false;
    this.frontWindow = false;

    this.wVertices = new Vertex [4];

    PVector h = new PVector (0, 0, 0);
    this.centre = centre;
    this.width = width;
    this.height = height; 
    this.dirWidth = dirWidth;
    this.dirHeight = dirHeight;

    this.dirWidth .normalize();
    this.dirHeight.normalize();

    float x = this.width * 0.5f;
    float y = this.height * 0.5f;

    float theta = 2*PI/4;
    float radiusX = x/sin(theta);
    float radiusY = y/cos(theta);

    this.material = material;
    this.floor = floor;
    


    Float UV [] = {
      5.7, 3.7
    }; // TODO: insert realistic values
    Float SHGC [] = {
      0.86, 0.76
    }; // values obtained from http://wiki.naturalfrequency.com/wiki/Shading_Coefficient
    this.UVvalues = UV;
    this.SHGCvalues = SHGC;

    ///// Shading Factors /////

    Float [] sF = {
      1.00, 0.95
    };  // {singleG, doubleG}
    this.shadingF = sF; 

    ///////////////////////////

    ///// Air Node Correction Factors /////

    Float [] aNF = {
      0.91, 0.91
    };  // {singleG, doubleG}
    this.airNF = aNF; 

    ///////////////////////////


    // material selected has assigned value. This value corresponds to an index of values in an array list

    PVector k = PVector.add(centre, PVector.mult(dirWidth, -x));
    k.add( PVector.mult(dirHeight, y));
    this.wVertices[3] = addVertex( k, 1);

    PVector l = PVector.add(centre, PVector.mult(dirWidth, -x));
    l.add( PVector.mult(dirHeight, -y));
    this.wVertices[2] = addVertex( l, 1);

    PVector m = PVector.add(centre, PVector.mult(dirWidth, x));
    m.add( PVector.mult(dirHeight, -y));
    this.wVertices[1] = addVertex( m, 1);

    PVector n = PVector.add(centre, PVector.mult(dirWidth, x));
    n.add( PVector.mult(dirHeight, y));
    this.wVertices[0] = addVertex( n, 1);

    //  for(int i=0; i<this.wVertices.length; i++){
    //      Vertex v = this.addVertex (this.wVertices[i]);
    //    }

    this.glazing = new Face (wVertices);
    //  this.addFace (wVertices);
    this.windowFaces.add(this.glazing);

    this.area = (this.width*this.height)*0.1*0.1 ;
    //  this.subdivide (this.glazing);
    // println("cells"+ this.cells.size());

    //println("material = "+ this.material);

  }


  void subdivide (Face f) {
    // ArrayList <Face> facess = new ArrayList <Face> ();
    // this.cells.add(f);

    if (f.diagonal() < this.width) {
    } 
    else {

      this.cells.remove(f);
      Face faces [] = f.subdivide();
      //this.cells.remove(f);
      for (int i=0; i<faces.length;i++) {
        //  facess.add(faces[i]);
        this.cells.add(faces[i]);

        this.subdivide(faces[i]);
      }
    }
    //  println("size " + facess.size());
    //  return this.faces.toArray(new Face [this.faces.size()]);
  }

  float viewCost (View view) {
    PVector [] eyeballs = this.floor.getEyeBalls(1.7);
    float ts = 0; // total score to be returned 

    for (int i=0; i< eyeballs.length;i++) {
      PVector [] sampleBoundary = new PVector [2]; 
      PVector [] fov = new PVector [2];
      for (int t=0; t< this.glazing.fVertices.length; t+=2) { 

        PVector FOV = PVector.sub(this.glazing.fVertices[t].location, eyeballs[i]);

        FOV.normalize();
        fov[t/2] = FOV;
      }

      for (int j=0; j< this.glazing.fVertices.length; j+=2) { 
        //   println("j = "+j);
        strokeWeight(0.4);
        stroke (255);

        PVector FOV = PVector.sub(this.glazing.fVertices[j].location, eyeballs[i]);

        FOV.normalize();
        //        fov[j/2] = FOV;
        //        println("fov = " +fov[i/2]);
        //
        //        println("image height "+image.height);
        //        println("image width "+image.width);
        //        float azimuth = (2*PI) - (acos(zero.dot(Radius)));
        float azimuth = atan2(FOV.y, FOV.x);
        //        println("azimuth "+azimuth);
        if (azimuth<0) azimuth = (2*PI)-abs(azimuth);
        if (azimuth>0) azimuth = azimuth;

        float elevation = asin(FOV.z);



        float U =( azimuth*image.width)/ (2*PI);
        //   println
        //   float V = elevation*image.width/(2*PI) + image.height/2;
        float TW = ((abs(elevation)*image.width)/(2*PI));
        //        println("TW "+TW);  



        //   float TH = (TW*image.height)/image.width;
        //   println("TH "+TH);
        //   println("TH "+TH*(this.floor.floorNumber+1));
        float V = 0;

        if (elevation < 0) {  
          // println("elevation ="+degrees(elevation));

          // println("preElevation = "+prevElevation);

          // float prevElevation = asin(fov[1].z);
          // println("elevation < 0");
          
          // float prevV = (image.height/2) - (prevTW+(this.floor.floorH*this.floor.floorNumber)) ;
          float prevElevation = asin(fov[1].z);
          float prevTW =(abs(prevElevation) * image.width)/(2*PI);
          float prevx = (prevTW)/tan(prevElevation);
        //  float prevY = ((prevTW)*(((this.floor.floorH+17)*this.floor.floorNumber)+prevx))/prevx; // remove 17 height
          float prevY = ((prevTW)*(prevx))/prevx; // remove 17 height

          //  float YY = (Y*TW) / FOV.z;
          float prevV = (image.height/2) - prevY;
          
          //TW =(abs(elevation) * image.width)/(2*PI);

          V = prevV + prevTW + TW;
        //   V =  prevTW + TW;
//          println("prevV ="+prevV);
//          println("prevTW ="+prevTW);
//          println("TW ="+TW);


//          println("V ="+V);
        } 
        
        else { 
//          println("elevation > 0");

          float FHpixels = (this.floor.floorH * TW) / FOV.z;

          V = (image.height/2) - TW;

        }


        Line l = new Line (eyeballs[i], PVector.add(eyeballs[i], PVector.mult(FOV, sqrt((FOV.z*FOV.z) +1)*view.rad)));
        view.lines.add(l);

        vertex(PVector.add(eyeballs[i], PVector.mult(FOV, 500)).x, PVector.add(eyeballs[i], PVector.mult(FOV, 500)).y, PVector.add(eyeballs[i], PVector.mult(FOV, 500)).z);


        sampleBoundary[j/2] = new PVector (U, V);
      }

      PVector B = sampleBoundary[0];   
      PVector A = sampleBoundary[1];
      //      println("A = "+A);
      //      println("B = "+B);

      // Vector from eye ball to overhang
      if (this.floor.aboveF != null) {
 
        PVector EO  = new PVector ();

                if (this.frontWindow == true) {


                  PVector eo = PVector.sub(this.floor.aboveF.carpet.fVertices[3].location, eyeballs[i]);
                  eo.normalize();
                  EO.add(eo);

                } 
        if (this.backWindow == true) {

          PVector eo = PVector.sub(this.floor.aboveF.carpet.fVertices[0].location, eyeballs[i]);
          eo.normalize();
          EO= eo;

  
        }

        float gamma =abs(asin(fov[1].z)) - abs(asin(EO.z));
//        println("gamma ="+degrees(gamma));

       
        if (EO.z < fov[1].z) {

          gamma =abs(asin(fov[1].z)) - abs(asin(EO.z));
//          println("gamma ="+gamma);
          float obstructedH = (abs(gamma)*image.width)/(2*PI);
//          println("A.y - B.y= "+(B.y - A.y)+" , " +"obstrucedH ="+obstructedH);

          for (int k = round(A.x); k<=round(B.x); k++) {
            for (int l = round(A.y); l<=round(A.y+obstructedH);l++) {
              ts = ts+1; // assign the lowest score to those pixels obstructed by the overhang
          //   image.pixels[(k)+((l)*image.width)] = color(0, 0, 0);  // temporarily disabled
//            println("I should not be in here ");
              image.updatePixels();
            }
          }

          A.y =  A.y+obstructedH;
        }
      } // here is where if above floor = null ENDS

//      println("A.x ="+A.x);
//      println("B.x ="+B.x);
//      println("A.y ="+A.y);
//      println("B.y ="+B.y);
      
      if(A.y < 0 ){
        
        ts = ts + ((abs(A.y) * ( B.x - A.x)) * 5); // assigned 5 as score for sky
        A.y = 0;
      }

      for (int a = round(A.x); a<=  round(B.x); a++) {
        for (int b =round(A.y); b<= round(B.y); b++) {

          
          color value = image.pixels[(a)+((b)*image.width)];
          int score = view.score(value);
      //    println("Score = "+score);
      //     println(" colour = "+red(value));
      //     println(" score = "+score);
           ts = ts + score; // adds to the total score 
      //    image.pixels[(a)+((b)*image.width)] = color(255, 0, 0); // temporarily disabled
      //    delete above   
          image.updatePixels();

      //          }
        }
      }



      // println("number of pixels in sample ="+((abs((A.x - B.x))+1) * (abs((A.y - B.y))+1)));
      //  }
      //image.updatePixels();
    }
   //  println("total window score = "+ts);
  //  image.pixels[0] = color(255, 0, 0);
    return ts;
    
  }


  int maxScore () {
      if (this.frontWindow == true) {
      this.wall = this.floor.walls[0];
    //  println(" this is a front window and the wall is "+this.wall);
    } 
        if (this.backWindow == true) { 
      
      this.wall = this.floor.walls[2];
   //   println(" this is a backt window and the wall is "+this.wall);
    }

    int totalScore = 0;
    PVector [] eyeballs = this.floor.getEyeBalls(1.7);


    for (int i=0; i< eyeballs.length;i++) {
      PVector [] sampleBoundary = new PVector [2]; 
      PVector [] fov = new PVector [2];


      for (int j=0; j< this.wall.fVertices.length; j+=2) { 


        PVector FOV = PVector.sub(this.wall.fVertices[j].location, eyeballs[i]);
        FOV.normalize();
        fov[j/2] = FOV;
      }

      for (int k=0; k< this.wall.fVertices.length; k+=2) { 
        PVector FOV = PVector.sub(this.wall.fVertices[k].location, eyeballs[i]);

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
          float prevY = ((prevTW)*(((this.floor.floorH+17)*this.floor.floorNumber)+prevx))/prevx;

          float prevV = (image.height/2) - prevY;

          V = prevV + prevTW + TW;
        } 
        else { 


          float x = (TW)/tan(elevation);
          float Y = ((TW)*(((this.floor.floorH+17)*this.floor.floorNumber)+x))/x;
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
       
       
//      for (int a = round(A.x); a<=  round(B.x); a++) {
//        for (int b =round(A.y); b<= round(B.y); b++) {
//          
//          // Only need to get the total amount of pixels in the 'sample' area
//          
//          println("inside loop ");
//          totalScore = totalScore + 6;
//          
//          // image.pixels[(a)+((b)*image.width)] = color(255, 0, 0);
//          // color value = image.pixels[(a)+((b)*image.width)];
//          // int score = view.score(value); 
//          // image.updatePixels();
//
//        }
//      }
    }
    //  println("max score of one window = "+totalScore);
      return totalScore;
  }


      int calcRadiation (Face f, Face [] aboveCarpets) {
       this.rad = 0;
        // Face [] aboveCarpets = aboveCarpets;
        // f = this.windowFaces.get(i);

        if ( this.glazing.sunEnergyFactor() < 0) {
          for (int i =0; i<this.glazing.fVertices.length; i++) {
            // this.glazing.fVertices[i].brightness = 0;
          }

          this.rad = this.rad + 0;
        } 
        else {


          for (int j=0; j<f.fVertices.length; j++) {

            // Original window vertex to shoot ray from and test whether it is in shade or not. 
            Vertex fVertex = f.fVertices[j];   
            //     println("Window Vertex "+j);

            if (fVertex.checked == false) {

              // Loop through all the above carpets to test for intersection
              for (int k=0; k<aboveCarpets.length; k++) {

                Face c = aboveCarpets [k];

                Vertex v = c.fVertices[0];



                //   if ((fVertex.intersectionSphere( c, s.direction)) == true) {

                float t = fVertex.plane_i_dist(c, v.location, s.direction); 
                //       println("t = "+t);

                if (t>=0) {

                  PVector X = fVertex.intersectionPoint(t, s.direction); 


                  Vertex intersectionP = new Vertex (X, 1);



                  if ((c.fVertices.length == 4) && ((intersectionP.pointInQuad(c.fVertices[3], c.fVertices[2], c.fVertices[1], c.fVertices[0])) == true) ) { 
                    this.addVertex (intersectionP);


                    fVertex.brightness = 0;
                    fVertex.checked = true;


                    break;
                  }

                  else {

                    fVertex.brightness=1;
                    fVertex.checked = true;
                    continue;
                  }
                }
                //    }   
                //          else {
                //
                //            println("false and not intersecting sphere");
                //            fVertex.brightness=1;
                //            fVertex.checked = true;
                //            continue;   // if no sphere intersection
                //    }
              }
            }
            else { 
              continue;
            }
          }
        }


        // Check whether face is ALL, PARTIALLY or NOT in Shade. 

        float ba = 0.0f;

        if (this.allInShade(f) == true) {


          this.rad = (int)(this.rad + 0);
          //   ba = ba + 0;
        } 
        else if (this.allInSun (f)== true) {
          //  println("all in sun");
//           println("hourrrr = "+s.hours);
//           println("sun.direction = "+s.direction);
          this.rad = (int)(this.rad + (f.globalSolarRadiation()));
          // ba = ba + this.windowFaces.get(0).globalSolarRadiation();
          // println("rad "+this.rad);
          // println("area" +this.area);
        } 
        //   else if (this.someInShade(f)== true) { 
        else { 
          //     println("some in shade");
          if (f.diagonal() < this.width*0.01) {
           
            this.rad =  (int)(this.rad +(f.globalSolarRadiation() * f.propSeeSun()));
          } 
          else {
            Face subFaces [] = f.subdivide();
            // Remove face from winfowFace list as it is to be subdivided.
            //      println("window faces size "+this.windowFaces.size());
            this.windowFaces.remove(this.windowFaces.get(this.windowFaces.indexOf(f)));
            for (int i=0; i<subFaces.length; i++) {
              this.windowFaces.add(subFaces[i]);
              //  this.addFace(subFaces[i].fVertices);
              int radiation = (int)(this.calcRadiation(subFaces[i], aboveCarpets));
            }
          }
        }
        return this.rad;
      } 
      
      
 

      // this funciton should return the amount of solar radiation incident on the surface in SUN
      // check new vertices of 4 new faces for clash detection and set their brightness 
      // when subdividing in face class i should keep track of new vetices that were added perhaps make it a property of Face



      //TODO: write ray tracer 
      //TODO: write subdivison of face for window DONE
      //TODO: find internal room temperature (calculation);



      boolean allInShade (Face f) {
        int a=0;
        for (int i=0; i<f.fVertices.length; i++) {
          Vertex v = f.fVertices[i];
          if (v.brightness == 0) {
            a = a+1;
          }
        }
        if (a == 4) {
          return true;
        } 

        return false;
      }

      boolean allInSun (Face f) {
        int a=0;
        for (int i=0; i<f.fVertices.length; i++) {
          Vertex v = f.fVertices[i];
          if (v.brightness == 1) {
            a = a+1;
          }
        }
        if (a == 4) {
          return true;
        } 

        return false;
      }





      //  boolean allInShade (Face f) {
      //
      //    for (int i=0; i<f.fVertices.length; i++) {
      //      Vertex v = f.fVertices[i];
      //      if (v.brightness == 1) {
      //        return false;
      //      }
      //      break;
      //    }
      //    return true;
      //  }
      //
      //  boolean allInSun (Face f) {
      //
      //    for (int i=0; i<f.fVertices.length; i++) {
      //      Vertex v = f.fVertices[i];
      //      if (v.brightness == 0) {
      //        return false;
      //      }
      //       break;
      //    }
      //    return true;
      //  }

      boolean someInShade (Face f) {

        ArrayList <Vertex> vertsInShade = new ArrayList <Vertex> ();
        Vertex [] vertsInS = new Vertex [vertsInShade.size()];

        for (int i=0; i<f.fVertices.length; i++) {
          Vertex v = f.fVertices[i];
          if (v.brightness == 0) {
            vertsInShade.add(v);
          }
        }

        if (vertsInShade.size() == f.fVertices.length) {
          return false;
        } 
        else if (vertsInShade.size() == 0) {
          return false;
        } 

        // write refineFace   

          return true;
      }


      Face getFace (Vertex v ) {
        for (int i=0; i<this.windowFaces.size(); i++) {
          Face f = this.windowFaces.get(i);
          for (int j=0; j<f.fVertices.length; j++) {
            if ( f.fVertices[j] == v ) {
              // println("A"+ f.fVertices[j]);
              // println("B" +v);
              return f;
              //  break;
            }
          }
        }

        return null;
      }


      void subDivFaces () {


        //   this.refineMesh();
        Face [] subF = this.windowFaces.get(0).subdivide();
        //  println(" size of subF = "+subF.length);
        for (int i=0; i<subF.length; i++) {
          //  this.addFace(subF[i].fVertices);
          this.windowFaces.add(subF[i]);
          for (int j=0; j<subF[i].fVertices.length; j++) {
            this.addVertex(subF[i].fVertices[j]);
          }
        }

        this.windowFaces.remove(this.windowFaces.get(0));
        //    println("Size of window faces = "+this.windowFaces.size());

        Vertex [] vertsInShade  =this.vertsInShade();
        //   println("vertsinShade length "+vertsInShade.length);
        for (int i=0; i<vertsInShade.length; i++) {
          Face f  = this.getFace (this.wVertices[java.util.Arrays.asList(this.wVertices).indexOf(vertsInShade[i])]);
          //      println("vertex in shadow "+this.wVertices[Arrays.asList(this.wVertices).indexOf(vertsInShade[i])]);
          //  Face f  = this.getFace (this.windowVertices.get(this.windowVertices.indexOf(vertsInShade[i])));
          // Face f = this.getFace(vertsInShade[i]);
          //     println("Face "+f);   
          //     println("no of window faces "+ this.windowFaces.size());
          // this.subdivideFace (f);
        }
      }


      Vertex [] vertsInShade () {

        ArrayList <Vertex> vertsInShade = new ArrayList <Vertex> ();
        Vertex [] vertsInS = new Vertex [vertsInShade.size()];
        for (int i=0; i<this.wVertices.length; i++) {
          Vertex v = wVertices[i];
          if (v.brightness == 0) {
            vertsInShade.add(v);
          }
        }
        return vertsInShade.toArray(vertsInS);
      }


      float transmittedE (int tempO, int tempI) {  
 
        //    float radiation = this.calcRadiation (this.glazing);
        float areaT = this.area;  // area affected by thermal heat transfer
        // float s = this.glazing.globalSolarRadiation;
        float uv = this.UVvalues[this.material]; 
        float shgc = this.SHGCvalues[this.material]; // shgc is the solar heat gain 
        float shadingFactor = this.shadingF [this.material];
        float airNodeFactor = this.airNF [this.material];

        // following equation from from moWITT paper but adapted to CIBSE method (http://www.arca53.dsl.pipex.com/index_files/hgain2.htm)
        //  println("this.rad =" + this.rad);
        if (this.rad < 0 ) { 
          this.rad = 0;
        }
        float ambient_heat = (uv * areaT) *(tempO - tempI);
        
      //  float radiated = ((shadingFactor*airNodeFactor)*this.rad);  // this .rad is constant and not being re calculated hence why the value is still being effected by the change of hour
        float radiated = ((shadingFactor*airNodeFactor)*this.calcRadiation(this.windowFaces.get(0), flats.getAboveCarpets(this.floor)) );
      //  println(" this.rad = "+this.calcRadiation(this.windowFaces.get(0), flats.getAboveCarpets(this.floor)));
      //  println(" this.rad = "+this.rad);
        float W = ambient_heat + radiated;
        //println("Ambient = "+ambient_heat + "("+100.0*ambient_heat/W+")    Radiated = "+radiated +"("+100.0*radiated/W+")");
//        println("ambient = "+ambient_heat);
//        println("radiated = "+radiated);
//        println("transmitted watts ="+W);
        return W;
      }



      Manifold subdivideFace (Face f) {
        this.addSFace (f.fVertices);

        for (int i=0; i<f.fVertices.length;i++) {
          this.addSVertex (f.fVertices[i].location, 1);
        }

        Manifold subdivideFace = new Manifold ();

        // New temporary array for face points
        Vertex [] facePoints = new Vertex [this.subVertices.size()];

        //Iterates through all the faces

        for (int i=0; i<this.subFaces.size();i++) {

          Face b = this.subFaces.get(i);

          // Fill facePoints array and add them to the array list
          facePoints[i] =  subdivideFace.addVertex(b.centroid(), 1);

          //  println("Size of FacePoints Array " +facePoints.length);
          //  println("Cat Mull Clark Vertexs Array List "+refineMesh.vertices.size());
        }

        // Add midpoint for each link

        Vertex [] midPoints = new Vertex [this.subEdges.size()];
        for (int i=0; i<this.subEdges.size(); i++) {

          Edge e = this.subEdges.get(i);

          PVector edge = new PVector();
          edge = e.midPoint();

          midPoints[i] =  subdivideFace.addVertex(edge, 1);

          //  println("Size of MidPoint Array " +midPoints.length);
          //  println("Cat Mull Clark Vertexs Array List "+refineMesh.vertices.size());
        }

        // Add original vertices - their location remain unchanged sinc we are not doing full CC subdivision 

        Vertex[] originalVertices = new Vertex [this.subVertices.size()];
        for (int i=0; i<this.subVertices.size(); i++) {

          Vertex n = this.subVertices.get(i);

          originalVertices[i] = subdivideFace.addVertex(n.location.get(), 1);

          // println("Size of Original Vertexs Array " +midPoints.length);
          // println("Cat Mull Clark Vertexs Array List "+refineMesh.vertices.size());
        }

        int num_faces = subFaces.size();
        for (int i = 0; i<num_faces; i++) {

          Face y = this.subFaces.get(i); // get each Face f from ORIGINAL Array List 

          for (int j=0; j< y.fVertices.length; j++) {  // iterate though Original Vertexs bounding faces

            Vertex prev = y.fVertices[j];
            Vertex curr = y.fVertices[(j+1)%f.fVertices.length];
            Vertex next = y.fVertices[(j+2)%f.fVertices.length];

            Edge nextEdge = curr.edgeWith(next);
            Edge previousEdge = curr.edgeWith(prev);

            // Edge from = prev.searchFromEdge();
            // Edge to = prev.searchToEdge();
            // Edge from = prev.linkTo(f.fVertexs[(j+2)%f.fVertexs.length]);



            Vertex [] newVertices = new Vertex [4] ;

            newVertices[0]= originalVertices[this.subVertices.indexOf(curr)];
            //        println("zero " + newVertices[0]);
            newVertices[1]= midPoints[this.subEdges.indexOf(nextEdge)];
            //        println("one  " + newVertices[1]);
            newVertices[2]= facePoints[this.subFaces.indexOf(f)];
            //        println("two  " + newVertices[2]);
            newVertices[3]= midPoints[this.subEdges.indexOf(previousEdge)];
            //        println("three  " + newVertices[3]);

            subdivideFace.addFace(newVertices);

            //        println(newVertices.length);
          }
        }

        this.subVertices = subdivideFace.vertices;
        this.subEdges = subdivideFace.edges;
        this.subFaces = subdivideFace.faces;

        return subdivideFace;
      }


      Face addSFace (Vertex vertices []) {

        Face f = new Face(vertices);

        for (int i = 0; i<vertices.length; i++) {

          Vertex from = vertices[i];
          Vertex to = vertices[(i+1)%vertices.length];
          Edge e = to.edgeTo(from);

          if (e != null) {
            e.right = f;
          }
          else if (from.edgeTo(to) == null) {

            this.addSEdge(from, to, f);
          }
          else {
            return null;
          }
        }
        this.subFaces.add(f);
        return f;
      }



      Vertex addSVertex ( PVector location, int brightness ) {

        Vertex v = new Vertex (location, brightness);
        this.subVertices.add(v);
        return v;
      }

      Vertex addSVertex ( Vertex v ) {
        this.subVertices.add(v);
        return v;
      }


      Edge addSEdge (Vertex v1, Vertex v2, Face left) {

        Edge e = new Edge(v1, v2, left);
        this.subEdges.add(e);
        v1.edges.add(e);
        v2.edges.add(e);
        return e;
      }



      Manifold refineMesh () {

        Manifold refineMesh = new Manifold ();


        // New temporary array for face points
        Vertex [] facePoints = new Vertex [this.windowFaces.size()];

        //Iterates through all the faces

        for (int i=0; i<this.windowFaces.size();i++) {

          Face f = this.windowFaces.get(i);

          // Fill facePoints array and add them to the array list
          facePoints[i] =  refineMesh.addVertex(f.centroid(), 1);

          //  println("Size of FacePoints Array " +facePoints.length);
          //  println("Cat Mull Clark Vertexs Array List "+refineMesh.vertices.size());
        }

        // Add midpoint for each link

        Vertex [] midPoints = new Vertex [this.windowEdges.size()];
        for (int i=0; i<this.windowEdges.size(); i++) {

          Edge e = this.windowEdges.get(i);

          PVector edge = new PVector();
          edge = e.midPoint();

          midPoints[i] =  refineMesh.addVertex(edge, 1);

          //  println("Size of MidPoint Array " +midPoints.length);
          //  println("Cat Mull Clark Vertexs Array List "+refineMesh.vertices.size());
        }

        // Add original vertices - their location remain unchanged sinc we are not doing full CC subdivision 

        Vertex[] originalVertices = new Vertex [this.windowVertices.size()];
        for (int i=0; i<this.windowVertices.size(); i++) {

          Vertex n = this.windowVertices.get(i);

          originalVertices[i] = refineMesh.addVertex(n.location.get(), 1);

          // println("Size of Original Vertexs Array " +midPoints.length);
          // println("Cat Mull Clark Vertexs Array List "+refineMesh.vertices.size());
        }

        int num_faces = windowFaces.size();
        for (int i = 0; i<num_faces; i++) {

          Face f = this.windowFaces.get(i); // get each Face f from ORIGINAL Array List 

          for (int j=0; j< f.fVertices.length; j++) {  // iterate through Original Vertexs bounding faces

            Vertex prev = f.fVertices[j];
            Vertex curr = f.fVertices[(j+1)%f.fVertices.length];
            Vertex next = f.fVertices[(j+2)%f.fVertices.length];

            Edge nextEdge = curr.edgeWith(next);
            Edge previousEdge = curr.edgeWith(prev);

            // Edge from = prev.searchFromEdge();
            // Edge to = prev.searchToEdge();
            // Edge from = prev.linkTo(f.fVertexs[(j+2)%f.fVertexs.length]);



            Vertex [] newVertices = new Vertex [4] ;

            newVertices[0]= originalVertices[this.windowVertices.indexOf(curr)];
            //        println("zero " + newVertices[0]);
            newVertices[1]= midPoints[this.windowEdges.indexOf(nextEdge)];
            //        println("one  " + newVertices[1]);
            newVertices[2]= facePoints[this.windowFaces.indexOf(f)];
            //        println("two  " + newVertices[2]);
            newVertices[3]= midPoints[this.windowEdges.indexOf(previousEdge)];
            //        println("three  " + newVertices[3]);

            refineMesh.addFace(newVertices);
            //this.refineMesh(m);
            //println("size of window face list " +this.windowFaces.size());

            //        println(newVertices.length);
          }
        }

        this.windowVertices = refineMesh.vertices;
        this.windowEdges = refineMesh.edges;
        this.windowFaces = refineMesh.faces;

        //    for(int i=0; i<this.windowFaces.size(); i++){
        //      m.faces.add(this.windowFaces.get(i));
        //    }
        //        for(int i=0; i<this.windowEdges.size(); i++){
        //      m.edges.add(this.windowEdges.get(i));
        //    }
        //        for(int i=0; i<this.windowVertices.size(); i++){
        //      m.vertices.add(this.windowVertices.get(i));
        //    }

        return refineMesh;
      }


      void removeFaces (Manifold m) {

        for (int i=0; i<this.windowFaces.size(); i++) {
          m.faces.add(this.windowFaces.get(i));
        }
        for (int i=0; i<this.windowEdges.size(); i++) {
          m.edges.add(this.windowEdges.get(i));
        }
        for (int i=0; i<this.windowVertices.size(); i++) {
          m.vertices.add(this.windowVertices.get(i));
        }
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
        this.windowFaces.add(f);
        return f;
      }




      Vertex addVertex ( PVector location, int brightness ) {

        Vertex v = new Vertex (location, 1);
        this.windowVertices.add(v);
        return v;
      }

      Vertex addVertex ( Vertex v ) {
        this.windowVertices.add(v);
        return v;
      }


      Edge addEdge (Vertex v1, Vertex v2, Face left) {

        Edge e = new Edge(v1, v2, left);
        this.windowEdges.add(e);
        v1.edges.add(e);
        v2.edges.add(e);
        return e;
      }

      PVector centroid () {

        PVector zero = new PVector ();
        zero.add(this.centre);

        moved = PVector.add(zero, PVector.mult(this.normal(), 5));

        return zero; // returns the vector of the centroid
      }


      PVector normal () {

        PVector n = new PVector ();

        for (int i=0; i<this.wVertices.length; i++) {
          PVector cp = (this.wVertices[i].location).cross(this.wVertices[(i+1)% this.wVertices.length].location);
          n.add(cp);
        }
        n.normalize();
        return n;
      }



      void drawNormal () {
        PVector n = this.normal();
        PVector c = this.centroid();
        PVector m = PVector.add(c, PVector.mult(n, 5));
        fill (1);
        strokeWeight(1);

        // line (c.x, c.y, c.z, m.x, m.y, m.z);
        for (int i=0; i<this.windowFaces.size();i++) {
          this.windowFaces.get(i).drawNormal();
        }
      }

      void drawCentroid () {
        PVector c = this.centroid();
        fill(1); 
        strokeWeight(4);
        point (c.x, c.y, c.z);
      }



      void draw () {

        //  this.glazing.draw(135, 206, 250, 130);
        for (int i=0; i<this.windowFaces.size();i++) {
          this.windowFaces.get(i).draw(100);
        }

        for (int i=0; i<this.windowEdges.size();i++) {
          this.windowEdges.get(i).draw();
        }
        for (int i=0; i<this.windowVertices.size();i++) {
          this.windowVertices.get(i).draw();
        }
      }
    }