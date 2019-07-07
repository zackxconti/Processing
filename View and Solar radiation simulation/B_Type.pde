class Building {


  
  Building () {
    
  }

  Manifold flats ( Dna DNA ) { // bh = building height  fh = floor height

    Manifold flats = new Manifold ();
    int numFloors = (int) (DNA.bldgH* (1/ DNA.floorH)) ;

    for (int i=0; i< numFloors; i++) {

      if (i==0) { 

        flats.addFloor ( DNA, null);
      //  Floor f =  flats.floors.get(i); 
        
        //b.previousF.aboveF = null;
//        topFloor= f;
//        f.top = topFloor;
       // f.aboveF();
      //  println("tf "+topFloor);
      } 
      else {
        
        flats.addFloor ( DNA, flats.floors.get(i-1));
       // println(flats.floors.get(i).previousF + "is equal to "+ flats.floors.get(i-1));

       
      }
      // here you have access to the number of floors so each time a floor is created you can use get vertex to move the particualr vertices 
      // flats.getVertex ( 0, i );
        Floor f = flats.floors.get(i);
     
     // f.getArea( 20.0f);
    //    f.aboveF();
      //println("floor number = "+f.floorNumber);
       
        topFloor = f;
      
        for(int j=0; j<flats.floors.size(); j++){
      
      Floor fe = flats.floors.get(j);
      fe.top = topFloor;
      fe.aboveF();
    }
    //println(flats.coolingLoads());
        // f.aboveF();
       
     //   println("ff" + f);
  //    int n =topFloor.floorNumber;
   //   println(n);
      
      
     // int g = topFloor.floorNumber;
    //  println("topF number = "+g);
      
    }
    //c  println("Floor above 0 = "+flats.floors.get(0).aboveF.floorNumber);
   // topFloor = flats.floors.get(flats.floors.size()-1);
    
    
//    for(int i=0; i<numFloors; i++){
//      Floor f = flats.floors.get(i);
//     // f.top = flats.floors.get(flats.floors.size()-1);
//      f.updateSlope(0, f.slopeFX, f.slopeFY);
//      println ("top floor num "+f.top.floorNumber);
//    }
    
    //println("edges in manifold size " + flats.edges.size());
    //println("faces in manifold size " + flats.faces.size());
    //println("vertices in manifold size " + flats.vertices.size());
  //  flats.refineMesh();
 //  flats.subWindows();
 
    return flats;
  }

    
    
  float viewCost (Manifold m, View view) {
    float cost   = 0;
    for(int i=0; i<m.floors.size(); i++){
   //   println("----------------------------------------------------------");
  //    println("Floor number = "+m.floors.get(i).floorNumber);
      float a = m.floors.get(i).viewCost(view);
      cost = cost + a;
    }
    return cost;
  }
  
    
  float maximumViewScore (Manifold m) {
    float totalScore   = m.floors.get(0).maximumViewScore() * m.floors.size();
//    for(int i=0; i<m.floors.size(); i++){
//      float a = m.floors.get(i).maximumViewScore ();
//      totalScore = totalScore + a;
//    }
//    
//    m.floors.get(0).maximumViewScore * m.floors.size();
   // println("max building score = "+totalScore);
    return totalScore;
  }

}

