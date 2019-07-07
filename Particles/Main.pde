import controlP5.*;
import processing.opengl.*;
import peasy.*;
import processing.core.PApplet;
import processing.pdf.*; 



PeasyCam cam;
Mesh m;
Manifold m1;
PVector gravity;

Float g;
PShape s;
ArrayList <Vertex> vs;

ControlP5 controlP5;


void setup () {
  
  size (800,800, P3D);
//background (0xeeeeff);
  background(0);
  smooth(); 

  controlP5 = new ControlP5(this);
  
  controlP5.setAutoDraw(false);
  
  controlP5.addSlider("gravity", 0, 5, 0.001, (30), (70), 200, 10).setId(1).setLabel("Gravity");
  
  //g = controlP5.getController("Gravity").getValue();
  //g=0.09;
  //gravity = new PVector (random(-g, g), random(-g, g), random(-g, g));
  cam = new PeasyCam(this, 100);
  frameRate(100);
  


  //m = new Mesh (20, 40, 10, 10);
  //m.generate();
  vs = new ArrayList <Vertex> ();
  for (int i =0; i<100; i++){
    vs.add(new Vertex(new PVector (random(-300, 300), random(-300, 300), random(-300, 300))));
    vs.get(i).grav = 0.0001;
    //vs.add(new Vertex(new PVector (i*10, i*10, sin((PI/10)*i))));
  }
  //m1.importOBJ("test.obj");
  //s = loadShape ("test.obj");
  
  controlP5.setBroadcast(true);
  gui();
  
}


void draw () {
  lights();
  colorMode (RGB, 255);
  background (255);
  //gui2();
  //stroke(255);
  lights();
  //rect(-400, -400, 400, 400);
  strokeWeight(1.1);
  colorMode(RGB, 255);
  
  if (controlP5.getWindow(this).isMouseOver()) {
    cam.setActive(false);
  } 
  else {
    cam.setActive(true);
  }
  
  //stroke(255);
  noFill();
  box(800);
  
  for (int i =0; i<vs.size(); i++){  
    //vs.get(i).grav = 0.1;
    //vs.get(i).updateG(0.1);
    vs.get(i).update();
    //vs.get(i).updateG(controlP5.getController("gravity").getValue()); 
    vs.get(i).checkBoundary();
    //float dist = (vs.get(i).location.x);
    //println (dist);
    vs.get(i).draw(0);
  }
  

  
  for (int i=0; i<vs.size(); i++){
    
  Float [] distances = new Float[vs.size()];
  Vertex [] vertices = new Vertex[vs.size()];
 
  PVector v1 = vs.get(i).location ; 
  
    for (int j=0; j<vs.size(); j++){   
      PVector v2 = vs.get(j).location; 
      Float d = v1.dist(v2);
      distances[j]=d;
    }
    
    
    for (int j = 0; j<vs.size(); j++){
      vertices[j] = vs.get(j);
    }
    
    for (int j=0; j<distances.length-1; j++){
      for ( int k=0; k<distances.length-j-1; k++){
        if( distances[k] > distances[k+1])
        {
          Float temp = distances[k];
          Vertex vtemp = vertices [k];
          distances[k] = distances[k+1];
          vertices[k] = vertices[k+1];
          distances[k+1] = temp;
          vertices[k+1] = vtemp;
        }
      }
    }
    
    
    PVector vtwo = vertices[1].location;
    PVector vthree = vertices[2].location;
    Vertex [] fNodes = new Vertex [3];
    
    fNodes[0] = vs.get(i);
    fNodes[1] = vertices[1];
    fNodes[2] = vertices[2];
    

    PVector zero = new PVector ();
    
    for (int l=0; l< fNodes.length; l++) {
      PVector cp = (fNodes[l].location).cross(fNodes[(l+1)% fNodes.length].location);
      zero.add(cp);
    }
    zero.normalize ();
    
    PVector Z = new PVector (0,0,1);
    Float angle = Z.dot(zero);
    
    beginShape();
    PVector o = new PVector (800,800,800);
    vertex(v1.x, v1.y, v1.z);
    vertex(vtwo.x, vtwo.y, vtwo.z);
    vertex(vthree.x, vthree.y, vthree.z);
    stroke(0);
    strokeWeight(1.);
    //float max = distances[vs.size()-1];
    float max = 1;
    colorMode(HSB, 1, 1, max);
    //fill(o.dist(v1), max, max);
    fill(angle, angle, max);
    endShape();
    
  }
      
    
    //triangle(v1.x, v1.y, v1.z, vtwo.x, vtwo.y, vtwo.z, vthree.x, vthree.y, vthree.z);
    
    
    
    
  
    
    
    

      
      //if (d<400){
      //  line (v1.x, v1.y, v1.z,v2.x, v2.y, v2.z );
      //  stroke(256);
      //  strokeWeight(0.5);
      //}
//  }
//}
  
  //shape(s, 0,0);
  //m.updateMesh();
  //m.drawMesh();
  //m1.drawEdges();
  //m1.drawVertices();
  //m1.drawFaces();
  
  //ArrayList <PVector> points = new ArrayList <PVector> ();
  
  //for (int j =0; j<30; j++){
  //  for (int i=0; i<30; i++){
  //    fill(255);
  //    ellipse(i*40, j*40, 10, 10);
  //    points.add(new PVector (i*40, j*40, 0));
  //  }
  //}
  
   //int k=0;
   //for (int j =0; j<30; j++){
   // for (int i=0; i<30; i++){
   //   if( i>0 && j>0){
   //     fill(255);
   //     line(points.get(k).x, points.get(k).y, 0, points.get(k-30-1).x, points.get(k-30-1).y, 0);
   //   }
   //     if(j>0){ 
   //     line(points.get(k).x, points.get(k).y, 0, points.get(k-30+1).x, points.get(k-30+1).y, 0);
   //   }
    
   //   k++;
   // }
  //}//
  
    gui();
}

void gui () {
  cam.beginHUD();
  controlP5.draw();
  textSize(10);
  cam.endHUD();
}

void gui2(){
  cam.beginHUD();
  controlP5.draw();
  noStroke ();
  fill (0,0,0, 10);
  rect (0,0,width, height);
  cam.endHUD();
}

void controlEvent(ControlEvent theEvent) {
  for( int i=0; i<vs.size(); i++)
  {
    //vs.get(i).grav =  controlP5.getController("gravity").getValue();
    vs.get(i).updateG(controlP5.getController("gravity").getValue());
  }
  
//int  e = theEvent.controller().getId();
 
//if (e == 1){
//  for( int i=0; i<vs.size(); i++)
//  {
//    vs.grav =  controlP5.getController("Gravit").getValue();
//  }
//}
}