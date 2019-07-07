// check about recursion occuring in the draw function ... seems to get slower as time passes by 

import controlP5.*;
import processing.opengl.*;
import controlP5.*;
import peasy.*;

int Y_AXIS = 1;
int X_AXIS = 2;
color b1, b2, c1, c2;

PeasyCam cam;
PGraphics pg;
float viewradius;
Manifold flats;
View view;
Group Building;
Group Solar;
Group Material;
Group Display;

ArrayList <Manifold> subWindows;

Building building;
float xValues [];
float yValues [];
Dna DNA;
Sun s;

ArrayList<Float> areas;
Metre area;
String AREA;
Metre cooling;
String COOLING;
Metre viewM;
String VIEW;
Metre combined;
String COMBINED;

PVector north ;
Vertex wVertex;
PVector X;
Manifold subdiv;
float coolingCost;
PImage image;
boolean drawCylinder;
boolean displayFaces;
boolean displayView;
int r = 1000;

Accordion accordion;
ArrayList <Dna> DNAValues = new ArrayList <Dna> ();

ArrayList <Float> s1_Values = new ArrayList <Float> ();
ArrayList <Float> s2_Values = new ArrayList <Float> ();
ArrayList <Float> s3_Values = new ArrayList <Float> ();
ArrayList <Float> s4_Values = new ArrayList <Float> ();
ArrayList <Float> s5_Values = new ArrayList <Float> ();
ArrayList <Float> s6_Values = new ArrayList <Float> ();
ArrayList <Float> s7_Values = new ArrayList <Float> ();
ArrayList <Float> s8_Values = new ArrayList <Float> ();
ArrayList <Float> s9_Values = new ArrayList <Float> ();
ArrayList <Float> s10_Values = new ArrayList <Float> ();
ArrayList <Float> s11_Values = new ArrayList <Float> ();
ArrayList <Float> s12_Values = new ArrayList <Float> ();

Floor topFloor;
Manifold cylinder;
//float maxarea;
//float minarea;

ControlP5 controlP5;
CallbackListener cb;
ControlEvent theEvent;
//CallbackEvent callbackEvent;


void setup () {

  size ( 1200, 800, OPENGL);
  pg = createGraphics(1200, 800, P3D);
  makebackground();
//  pg = createGraphics(width/2, height/2);
  cam = new PeasyCam(this, 1000);
  

  
  smooth();
  //  image = loadImage("testwhite.jpg");
      image = loadImage("test.jpg");   // all black test (6 score)
  //  image = loadImage("bw360.jpg");
  //  image = loadImage("malta1_greyscale.jpg");
  //  image = loadImage("pano1.jpg");
  //  image = loadImage("test_panorama_grey.jpg");
  //  image = loadImage("malta1_lowres2.jpg");
  //  image = loadImage("pano1.jpg");
  //  image = loadImage("highimage.jpg");
  //  image = loadImage("vhighres.jpg");
  //  image = loadImage("mountains.jpg");
  image.loadPixels();


  controlP5 = new ControlP5(this);
  controlP5.setAutoDraw(false);
  
  xValues  = new float [8];
  yValues  = new float [8];
  AREA = "AREA";
  COOLING = "COOLING";
  //30.0f,100.0f,random(0,40),random(0,40),random(0,40),random(0,40),random(0,40),random(0,40),random(0,40),random(0,40),random(0,40),random(0,40)
  DNA = new Dna (30.0f, 30.0f*8, 50.0f, 150.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 1, 0.5f,0.5f, 1, 0.5f,0.5f, 1);
  s = new Sun (2013, 7, 1, 12, 0, 13, 14, 2, 0.0f, 1);  
  subWindows = new ArrayList <Manifold> ();
  building = new Building ();
  flats = building.flats ( DNA );

  view = new View (flats, r);

 // building.viewCost(flats, view);
 // building.maximumViewScore (flats);

  //view.fov();
  //cylinder = view.prism (40,40, -100);


  //controlP5.broadcast (DNA.controlEvent(theEvent));
  DNA.sliders ();
  s.gui();
  flats.rayTrace();
  // DNA.bldgH = 300;
  // DNA.floorH = 30;

  // println(DNA.bldgH);
  //  println(DNA.floorH);
  //s.getTemperatures("test");
  //println("topFloor setup" +topFloor);
  println(s.temps);
  controlP5.setBroadcast(true);



  DNA.cE();
  
//    flats.getAreas();
//    subdiv = flats.subWindows();
//    this.subWindows.add(subdiv);
//    subdiv = flats.subWindows();
//    this.subWindows.add(subdiv);
//    area = new Metre (new PVector(30, 450, 0), 300, 15, 100000, 50000, flats.totalArea(), AREA);
//    area.label = "AREA";
//    cooling = new Metre (new PVector (30, 470, 0), 300, 15, 100 , 0, flats.coolingFitness(flats.floors.size()*350), COOLING); // coolingCost takes rate in Euro/KWh
//    cooling.label = "COOLING";
//    viewM = new Metre (new PVector (30, 430, 0), 300, 15, building.maximumViewScore(flats) , 0, building.viewCost(flats, view), VIEW); // coolingCost takes rate in Euro/KWh
//    viewM.label = "VIEW";

  DNA.gui();
  PFont p = createFont("Univers-Bold",12);
  
//  accordion.setControlFont(p);
  accordion = controlP5.addAccordion("acc").addItem(Building).addItem(Solar).addItem(Material).addItem(Display).setWidth(340).setPosition(0,0);
  accordion.setCollapseMode(Accordion.MULTI);  // allows more than one drop down to be collapsed simultaneously
}


void draw () {

  background (100);

  //noFill();
 // pg.beginDraw();
//  pg.background(100);
//  pg.stroke(255);
//  pg.line(20, 20, mouseX, mouseY);

  if (controlP5.isMouseOver()) {
    cam.setActive(false);
  } 
  else {
    cam.setActive(true);
  }


  /////////// FLATS ////////////////

  flats.drawEdges ();
  flats.drawVertices();

  if (displayFaces == true) {
    flats.drawFaces(100);
    flats.drawFenestratedFaces();
  }

  flats.drawHabitableArea();
  flats.drawFenestratedVertices();
  flats.drawFenestratedEdges();

  flats.drawWindowFaces();

  //////////////////////////////////

  /////////// SUN //////////////////

  s.drawNorth();
  s.drawDirection();

  //////////////////////////////////

  /////////// TEXTURE //////////////

  if (drawCylinder==true) {
    stroke(255);
    // view.rad = 400.0f;
    float h = ((2*PI) * image.height)/image.width; // vertical angle of view

    view.drawCylinder (30, -h);
  } 

  ///////////////////////////////////

  for (int i=0; i<flats.floors.size(); i++) {

    flats.floors.get(i).drawEyeBalls();
    
  }

  if (displayView == true) {
    view.drawLines();
  }
  DNA.gui ();
 //   pg.endDraw();

}


void storeAllSliderValues () {

  s1_Values.add(DNA.s1.getValue());
  s2_Values.add(DNA.s2.getValue());
  s3_Values.add(DNA.s3.getValue());
  s4_Values.add(DNA.s4.getValue());
  s5_Values.add(DNA.s5.getValue());
  s6_Values.add(DNA.s6.getValue());
  s7_Values.add(DNA.s7.getValue());
  s8_Values.add(DNA.s8.getValue());
  s9_Values.add(DNA.s9.getValue());
  s10_Values.add(DNA.s10.getValue());
  s11_Values.add(DNA.s11.getValue());
  s12_Values.add(DNA.s12.getValue());
}



void event ( String name, float slider, ControlEvent b ) {
 
  if (b.name().matches(name)) {
    slider = b.getValue();
    //println("works");
    //println(slider);
  }
}


void controlEvent(ControlEvent theEvent) {
  
   s = new Sun (s.year, s.month, s.day, s.hours, s.minutes, s.latitude, s.longitude, s.gmtOffset, s.northOffset, s.skyClearness);
    
  if (theEvent.name().matches("year")) {
    s.year = (int)theEvent.value();
  }
  if (theEvent.name().matches("northOffset")) {
    s.northOffset = theEvent.value();
  }
  if (theEvent.name().matches("hours")) {
    s.hours = (int) theEvent.value();
  }
  if (theEvent.name().matches("month")) {
    s.month = (int)theEvent.value();
  }
  if (theEvent.name().matches("day")) {
    s.day = (int)theEvent.value();
  }
  if (theEvent.name().matches("minutes")) {
    s.minutes = (int)theEvent.value();
  }
  if (theEvent.name().matches("latitude")) {
    s.latitude = theEvent.value();
  }
  if (theEvent.name().matches("longitude")) {
    s.longitude = theEvent.value();
  }
  if (theEvent.name().matches("gmtOffset")) {
    s.gmtOffset = (int)theEvent.value();
  }
  if (theEvent.name().matches("skyClearness")) {
    s.skyClearness = (int)theEvent.value();
  }



 
  //println("Size of DNA Values ="+ DNAValues.size());

  // DNA.controlEvent(theEvent);
  // DNA = new Dna (30.0f,100.0f,random(0,40),random(0,40),random(0,40),random(0,40),random(0,40),random(0,40),random(0,40),random(0,40),random(0,40),random(0,40));
  // flats = factory.flats ( DNA.bldgH, DNA.floorH );
  // flats.update();
  // flats.addFloorAreas();
  //  flats.addFenestrations(0);



  // for (int i =0; i<flats.floors.size(); i++){
  // PVector v = flats.floors.get(i).areaVertex; 

  // }

  if ((theEvent.name().matches("lockFloorH")) && (theEvent.value() ==  1)) {
    DNA.s1.setLock(true);
  } 

  if ((theEvent.name().matches("lockBldgH")) && (theEvent.value() ==  1)) {
    DNA.s2.setLock(true);
  }

  if ((theEvent.name().matches("lockv0x")) && (theEvent.value() ==  1)) {
    DNA.s3.setLock(true);
  }

  if ((theEvent.name().matches("lockv0y")) && (theEvent.value() ==  1)) {
    DNA.s4.setLock(true);
  }

  if ((theEvent.name().matches("lockv2x")) && (theEvent.value() ==  1)) {
    DNA.s5.setLock(true);
  }

  if ((theEvent.name().matches("lockv2y")) && (theEvent.value() ==  1)) {
    DNA.s6.setLock(true);
  }
  if ((theEvent.name().matches("lockStretchY")) && (theEvent.value() ==  1)) {
    DNA.s7.setLock(true);
  }
  if ((theEvent.name().matches("lockStretchX")) && (theEvent.value() ==  1)) {
    DNA.s8.setLock(true);
  }
  if ((theEvent.name().matches("lockSlopeFX")) && (theEvent.value() ==  1)) {
    DNA.s9.setLock(true);
  }
  if ((theEvent.name().matches("lockSlopeFY")) && (theEvent.value() ==  1)) {
    DNA.s10.setLock(true);
  }
  if ((theEvent.name().matches("lockSlopeBX")) && (theEvent.value() ==  1)) {
    DNA.s11.setLock(true);
  }
  if ((theEvent.name().matches("lockSlopeBY")) && (theEvent.value() ==  1)) {
    DNA.s12.setLock(true);
  }

  if ((theEvent.name().matches("undo")) ) {
    //DNA.undo = theEvent.value();
    undo();
  }

  if ((theEvent.name().matches("drawCylinder")) && (theEvent.value() ==  1)) {
    drawCylinder = true;
  } 

  if ((theEvent.name().matches("displayFaces")) && (theEvent.value() ==  1)) {
    displayFaces = true;
  } 
  if ((theEvent.name().matches("displayView")) && (theEvent.value() ==  1)) {
    displayView = true;
  } 

  event("floorH", DNA.floorH, theEvent);



  if (theEvent.name().matches("floorH")) {
    DNA.floorH = theEvent.value();

    //println(DNA.floorH);
  }
  else if (theEvent.name().matches("bldgH")) {
    DNA.bldgH = theEvent.value();
  }
  else if (theEvent.name().matches("v0x")) {
    DNA.v0x = theEvent.value();
  }
  else if (theEvent.name().matches("v0y")) {
    DNA.v0y = theEvent.value();
  }
  else if (theEvent.name().matches("v2x")) {
    DNA.v2x = theEvent.value();
  }
  else if (theEvent.name().matches("v2y")) {
    DNA.v2y = theEvent.value();
  }
  else if (theEvent.name().matches("stretchX")) {
    DNA.stretchX = theEvent.value();
  }
  else if (theEvent.name().matches("stretchY")) {
    DNA.stretchY = theEvent.value();
  }
  else if (theEvent.name().matches("slopeFX")) {
    DNA.slopeFX = theEvent.value();
  }
  else if (theEvent.name().matches("slopeFY")) {
    DNA.slopeFY = theEvent.value();
  }
  else if (theEvent.name().matches("slopeBX")) {
    DNA.slopeBX = theEvent.value();
  }
  else if (theEvent.name().matches("slopeBY")) {
    DNA.slopeBY = theEvent.value();
  }
  else if (theEvent.name().matches("frontNumWindows")) {
    DNA.frontNumWindows = (int)theEvent.value();
  }
  else if (theEvent.name().matches("frontWindowH")) {
    DNA.frontWindowH = theEvent.value();
  }
  else if (theEvent.name().matches("frontWindowW")) {
    DNA.frontWindowW = theEvent.value();
  }
  else if (theEvent.name().matches("backNumWindows")) {
    DNA.backNumWindows = (int)theEvent.value();
  }
  else if (theEvent.name().matches("backWindowH")) {
    DNA.backWindowH = theEvent.value();
  }
  else if (theEvent.name().matches("backWindowW")) {
    DNA.backWindowW = theEvent.value();
  }
  else if (theEvent.name().matches("windowMaterial")) {
    DNA.windowMaterial = (int)theEvent.value();
  }

  flats = building.flats ( DNA );
  flats.mappedHSB();
  flats.rayTrace();

  view = new View (flats, r);

  DNA.cE();  
  
  float coolingL = flats.coolingFitness(flats.floors.size()*1300);
  println("total cooling load = "+flats.coolingLoads()+" KWh");
//  println("cooling fitness = "+(300*flats.floors.size()-flats.coolingCost));
  println("cooling cost = "+flats.coolingCost);
 
    building.viewCost(flats, view);
    building.maximumViewScore (flats);
    flats.getAreas();
    
    println("total area = "+flats.totalArea()*100);
//    println("maximum area = "+ flats.floors.size()*(DNA.stretchX*DNA.stretchY));
//    println("minimum area = "+flats.floors.size()*5000);
    
    area = new Metre (new PVector(this.width-160, 450, 0), 300, 15, flats.floors.size()*(50000), flats.floors.size()*5000, flats.totalArea()*100, AREA);
    area.label = "AREA";
    
  
    cooling = new Metre (new PVector (this.width-140, 450, 0), 300, 15, 300*flats.floors.size() , 0, 300*flats.floors.size() - flats.coolingCost, COOLING); // coolingCost takes rate in Euro/KWh
    cooling.label = "COOLING";
    
    viewM = new Metre (new PVector (this.width-120, 450, 0), 300, 15, building.maximumViewScore(flats) , 0, building.viewCost(flats, view), VIEW); // coolingCost takes rate in Euro/KWh
    viewM.label = "VIEW"; 
   
//    println("view cost value = "+building.viewCost(flats, view));
    
    float comb = (area.percentage + cooling.percentage + viewM.percentage )/3; // average to obtain combined fitness value
    combined = new Metre (new PVector (this.width-100, 450, 0), 300, 15, 1, 0, comb, COMBINED);
    combined.label = "COMBINED";
    
  //coolingCost = flats.coolingCost(0.17144);
 
  println(" view cost of all building ="+building.viewCost(flats, view));
//  println("max view score of all building ="+building.maximumViewScore(flats)); 
  println("-----------------------------------------------------");
}

void controlEvent(CallbackEvent theEvent) {

  if (theEvent.getAction() == controlP5.ACTION_RELEASED) { 
    DNAValues.add(DNA);
  }
}
 
void undo () {

  Dna prev = DNAValues.get((DNAValues.size() -2));
  //flats = building.flats ( prev );
  this.DNA = prev;
  //println("work");
  //println(DNAValues.size());
}


// need to draw graphs for each metre of combined fitness 



public void makebackground() {
  pg.beginDraw();
  // do your gradient stuff here
  pg.background(102);  // you can do background statements in the background
  pg.stroke(255);
  pg.line(40, 40, mouseX, mouseY);
  // after your gradient, close out the pg image and finalize it with pg.endDraw
  pg.endDraw(); 
}