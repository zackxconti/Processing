class Dna {
// remove redundant variables 

  float floorH;
  float bldgH;
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
  int frontNumWindows;
  float frontWindowH;
  float frontWindowW;
  int backNumWindows;
  float backWindowH;
  float backWindowW;
  int windowMaterial;
  int hello;

  Slider s1;
  Slider s2;
  Slider s3;
  Slider s4;
  Slider s5;
  Slider s6;
  Slider s7;
  Slider s8;
  Slider s9;
  Slider s10;
  Slider s11;
  Slider s12;
  Slider s13;
  Slider s14;
  Slider s15;
  Slider s16;
  Slider s17;
  Slider s18;


  Toggle t1;
  Toggle t2;
  Toggle t3;
  Toggle t4;
  Toggle t5;
  Toggle t6;
  Toggle t7;
  Toggle t8;
  Toggle t9;
  Toggle t10;
  Toggle t11;
  Toggle t12;
  Toggle t13;
  Toggle t14;
  Toggle t15;
  
  Accordion accordion;

  boolean lockFloorH;
  boolean lockBldgH;
  boolean lockStretchX;
  boolean lockStretchY;
  boolean lockSlopeFX;
  boolean lockSlopeFY;
  boolean lockSlopeBX;
  boolean lockSlopeBY;
  boolean lockv0x;
  boolean lockv0y;
  boolean lockv1x;
  boolean lockv1y;
  boolean lockv2x;
  boolean lockv2y;
  boolean lockv3x;
  boolean lockv3y;
  boolean lockv4x;
  boolean lockv4y;
  boolean lockv5x;
  boolean lockv5y;
  boolean lockv6x;
  boolean lockv6y;
  boolean lockv7x;
  boolean lockv7y;
  boolean undo;
  boolean random;

//float floorH, float bldgH, float stretchX, float stretchY, float slopeFX, float slopeFY, float slopeBX, float slopeBY, float v0x, float v0y, float v2x, float v2y
  Dna (float floorH, float bldgH, float stretchX, float stretchY, float slopeFX, float slopeFY, float slopeBX, float slopeBY, float v0x, float v0y, float v2x, float v2y, int frontNumberWindows, float frontWindowHeight, float frontWindowWidth, int backNumberWindows, float backWindowHeight, float backWindowWidth, int windowMaterial ) {

    this.floorH = floorH;
    //floorH=this.floorH;
    this.bldgH = bldgH;
    this.stretchX = stretchX;
    this.stretchY = stretchY;
    this.slopeFX = slopeFX;
    this.slopeFY = slopeFY;
    this.slopeBX = slopeBX;
    this.slopeBY = slopeBY;
    this.v0x = v0x;
    this.v0y = v0y;
    this.v2x = v2x;
    this.v2y = v2y;
    this.frontNumWindows = frontNumberWindows;
    this.frontWindowH = frontWindowHeight;
    this.frontWindowW = frontWindowWidth;
    this.backNumWindows = backNumberWindows;
    this.backWindowH = backWindowHeight;
    this.backWindowW = backWindowWidth;
    this.windowMaterial = windowMaterial;

//    controlP5 = new ControlP5(this);
//    controlP5.setAutoDraw(false);



    //PFont font = createFont("arial",20);
    //stroke(255);

    // Textfield txt1 = controlP5.addTextfield("maxarea").setPosition(60, 410).setSize(50, 15).setLabel("Max Area");
    // Textfield txt2 = controlP5.addTextfield("minarea").setPosition(130, 410).setSize(50, 15).setLabel("Min Area");
   // controlP5.setBroadcast(true);
  }
  
  void sliders () {
    
    Building = controlP5.addGroup("Building", 25, 50, 340).setBackgroundColor(color(50, 180)).setBackgroundHeight(380).setCaptionLabel("Building Geometry").setBarHeight(20);
    Label B_label = Building.getCaptionLabel().align(CENTER,CENTER);
    
    s1 = controlP5.addSlider("floorH", 0, 40, this.floorH, (30), (10), 200, 10).setId(1).setLabel("Floor Height").moveTo(Building).setColorBackground(#726E6D).setColorForeground(#E5E4E2).setColorActive(#FFFFFF).setColorValue(#000000);
    s2 = controlP5.addSlider("bldgH", 0, 600, this.bldgH, (30), (30), 200, 10).setId(2).setLabel("Building Height").moveTo(Building).setColorBackground(#726E6D).setColorForeground(#E5E4E2).setColorActive(#FFFFFF).setColorValue(#000000);
    s3 = controlP5.addSlider("v0x", -20, 20, this.v0x, (30), (170), 200, 10).setId(4).setLabel("Front Inc x").moveTo(Building).setColorBackground(#726E6D).setColorForeground(#E5E4E2).setColorActive(#FFFFFF).setColorValue(#000000);
    s4 = controlP5.addSlider("v0y", -20, 20, this.v0y, (30), (190), 200, 10).setId(5).setLabel("Front Inc y").moveTo(Building).setColorBackground(#726E6D).setColorForeground(#E5E4E2).setColorActive(#FFFFFF).setColorValue(#000000);
    s5 = controlP5.addSlider("v2x", -20, 20, this.v2x, (30), (210), 200, 10).setId(8).setLabel("Back Inc x").moveTo(Building).setColorBackground(#726E6D).setColorForeground(#E5E4E2).setColorActive(#FFFFFF).setColorValue(#000000);
    s6 = controlP5.addSlider("v2y", -20, 20, this.v2y, (30), (230), 200, 10).setId(9).setLabel("Back Inc y").moveTo(Building).setColorBackground(#726E6D).setColorForeground(#E5E4E2).setColorActive(#FFFFFF).setColorValue(#000000);
    s7 = controlP5.addSlider("stretchY", 0, 200, this.stretchY, (30), (70), 200, 10).setId(21).setLabel("Stretch Y").moveTo(Building).setColorBackground(#726E6D).setColorForeground(#E5E4E2).setColorActive(#FFFFFF).setColorValue(#000000);
    s8 = controlP5.addSlider("stretchX", 0, 120, this.stretchX, (30), (50), 200, 10).setId(22).setLabel("Stretch X").moveTo(Building).setColorBackground(#726E6D).setColorForeground(#E5E4E2).setColorActive(#FFFFFF).setColorValue(#000000);
    s9 = controlP5.addSlider("slopeFX", -20, 50, this.slopeFX, (30), (90), 200, 10).setId(23).setLabel("Slope F X").moveTo(Building).setColorBackground(#726E6D).setColorForeground(#E5E4E2).setColorActive(#FFFFFF).setColorValue(#000000);
    s10 = controlP5.addSlider("slopeFY", -20, 50, this.slopeFY, (30), (110), 200, 10).setId(24).setLabel("Slope F Y").moveTo(Building).setColorBackground(#726E6D).setColorForeground(#E5E4E2).setColorActive(#FFFFFF).setColorValue(#000000);
    s11 = controlP5.addSlider("slopeBX", -20, 50, this.slopeBX, (30), (130), 200, 10).setId(25).setLabel("Slope B X").moveTo(Building).setColorBackground(#726E6D).setColorForeground(#E5E4E2).setColorActive(#FFFFFF).setColorValue(#000000);
    s12 = controlP5.addSlider("slopeBY", -20, 50, this.slopeBY, (30), (150), 200, 10).setId(26).setLabel("Slope B Y").moveTo(Building).setColorBackground(#726E6D).setColorForeground(#E5E4E2).setColorActive(#FFFFFF).setColorValue(#000000);
    s13 = controlP5.addSlider("frontNumWindows", 0, 10, this.frontNumWindows, (30), (310), 200, 10).setId(26).setLabel("Front No. Windows").moveTo(Building).setColorBackground(#726E6D).setColorForeground(#E5E4E2).setColorActive(#FFFFFF).setColorValue(#000000);
    s14 = controlP5.addSlider("frontWindowH", 0, 1, this.frontWindowH, (30), (250), 200, 10).setId(26).setLabel("Front Window Height").moveTo(Building).setColorBackground(#726E6D).setColorForeground(#E5E4E2).setColorActive(#FFFFFF).setColorValue(#000000);
    s17 = controlP5.addSlider("frontWindowW", 0, 1, this.frontWindowW, (30), (270), 200, 10).setId(26).setLabel("Front Window Width").moveTo(Building).setColorBackground(#726E6D).setColorForeground(#E5E4E2).setColorActive(#FFFFFF).setColorValue(#000000);
    s15 = controlP5.addSlider("backNumWindows", 0, 10, this.backNumWindows, (30), (290), 200, 10).setId(26).setLabel("Back No. Windows").moveTo(Building).setColorBackground(#726E6D).setColorForeground(#E5E4E2).setColorActive(#FFFFFF).setColorValue(#000000);
    s16 = controlP5.addSlider("backWindowH", 0, 1, this.backWindowH, (30), (330), 200, 10).setId(26).setLabel("Back Window Height").moveTo(Building).setColorBackground(#726E6D).setColorForeground(#E5E4E2).setColorActive(#FFFFFF).setColorValue(#000000);
    s18 = controlP5.addSlider("backWindowW", 0, 1, this.backWindowW, (30), (350), 200, 10).setId(26).setLabel("Back Window Width").moveTo(Building).setColorBackground(#726E6D).setColorForeground(#E5E4E2).setColorActive(#FFFFFF).setColorValue(#000000);
   // s13 = controlP5.addSlider("maxarea", 0, 80000, 0, (60), (310), 200, 10).setId(27).setLabel("Max Area").setValue(60000);
   // s14 = controlP5.addSlider("minarea", 0, 80000, 0, (60), (330), 200, 10).setId(28).setLabel("Min Area").setValue(50000);
   
    Material = controlP5.addGroup("Material", 25, 30, 340).setBackgroundColor(color(50, 180)).setLabel("Glazing Material").setBarHeight(20).setBackgroundHeight(20); 
    Label M_label = Material.getCaptionLabel().align(CENTER,CENTER);
   
    ListBox Materials = controlP5.addListBox("windowMaterial", 110,30, 50,10).setSize(120, 120).setItemHeight(15).setBarHeight(15).setColorActive(color(0)).moveTo(Material);
    //Materials.actAsPulldownMenu(true);
    Label Ms_label = Materials.getCaptionLabel().align(CENTER,CENTER);
    Materials.addItem ("single", 0).setColorActive(#00FF00);
    Materials.addItem ("double", 1).setColorActive(#00FF00);
    
   // Toggle single = controlP5.addToggle("single", false, 10, 10, 10, 10).setId(27).setLabel("").moveTo(Building).setColorBackground(#FF0000).setColorActive(#00FF00).setColorValue(#000000).moveTo(Material);
    
//    ListBox Hello = controlP5.addListBox("hello", 350, 80, 50,10);
//    Materials.addItem ("Hello", 2);
       

    t1 = controlP5.addToggle("lockFloorH", false, 10, 10, 10, 10).setId(27).setLabel("").moveTo(Building).setColorBackground(#FF0000).setColorActive(#00FF00).setColorValue(#000000);
    t2 = controlP5.addToggle("lockBldgH", false, 10, 30, 10, 10).setId(28).setLabel("").moveTo(Building).setColorBackground(#FF0000).setColorActive(#00FF00).setColorValue(#000000);
    t3 = controlP5.addToggle("lockStretchX", false, 10, 50, 10, 10).setId(29).setLabel("").moveTo(Building).setColorBackground(#FF0000).setColorActive(#00FF00).setColorValue(#000000);
    t4 = controlP5.addToggle("lockStretchY", false, 10, 70, 10, 10).setId(30).setLabel("").moveTo(Building).setColorBackground(#FF0000).setColorActive(#00FF00).setColorValue(#000000);
    t5 = controlP5.addToggle("lockSlopeFX", false, 10, 90, 10, 10).setId(31).setLabel("").moveTo(Building).setColorBackground(#FF0000).setColorActive(#00FF00).setColorValue(#000000);
    t6 = controlP5.addToggle("lockSlopeFY", false, 10, 110, 10, 10).setId(32).setLabel("").moveTo(Building).setColorBackground(#FF0000).setColorActive(#00FF00).setColorValue(#000000);
    t7 = controlP5.addToggle("lockSlopeBX", false, 10, 130, 10, 10).setId(33).setLabel("").moveTo(Building).setColorBackground(#FF0000).setColorActive(#00FF00).setColorValue(#000000);
    t8 = controlP5.addToggle("lockSlopeBY", false, 10, 150, 10, 10).setId(34).setLabel("").moveTo(Building).setColorBackground(#FF0000).setColorActive(#00FF00).setColorValue(#000000);
    t9 = controlP5.addToggle("lockv0x", false, 10, 170, 10, 10).setId(35).setLabel("").moveTo(Building).setColorBackground(#FF0000).setColorActive(#00FF00).setColorValue(#000000); 
    t10 = controlP5.addToggle("lockv0y", false, 10, 190, 10, 10).setId(36).setLabel("").moveTo(Building).setColorBackground(#FF0000).setColorActive(#00FF00).setColorValue(#000000);
    t11 = controlP5.addToggle("lockv2x", false, 10, 210, 10, 10).setId(37).setLabel("").moveTo(Building).setColorBackground(#FF0000).setColorActive(#00FF00).setColorValue(#000000);
    t12 = controlP5.addToggle("lockv2y", false, 10, 230, 10, 10).setId(38).setLabel("").moveTo(Building).setColorBackground(#FF0000).setColorActive(#00FF00).setColorValue(#000000);
    
    
    Display = controlP5.addGroup("Display", 25, 30, 340).setBackgroundColor(color(50, 180)).setLabel("Display Controls").setBarHeight(20).setBackgroundHeight(20); 
    Label V_label = Display.getCaptionLabel().align(CENTER,CENTER);
    
    t13 = controlP5.addToggle("drawCylinder", false, 10, 30, 10, 10).setId(38).setLabel("Display Texture Cylinder").moveTo(Display).setColorBackground(#FF0000).setColorActive(#00FF00).setColorValue(#000000);
    t14 = controlP5.addToggle("displayFaces", false, 130, 30, 10, 10).setId(38).setLabel("Display Faces").moveTo(Display).setColorBackground(#FF0000).setColorActive(#00FF00).setColorValue(#000000);
    t15 = controlP5.addToggle("displayView", false, 200, 30, 10, 10).setId(38).setLabel("Display View Fields").moveTo(Display).setColorBackground(#FF0000).setColorActive(#00FF00).setColorValue(#000000);
    
   // Button b1 = controlP5.addButton("undo").setPosition(30, 400).setSize(10, 10).setId(39);
   // Button b2 = controlP5.addButton("shuffle").setPosition(80, 400).setSize(10, 10).setId(40).setLabel("SHUFFLE");
   // Button b3 = controlP5.addToggle("drawCylinder").setPosition(100, 700).setSize(30, 30).setId(40).setLabel("Texture");
      
  }


  void gui () {   // to be called once in the setup and once in the draw function 

    cam.beginHUD();
 
    controlP5.draw();
    textSize(10);
  //  String a = "AREA";
   // text("TOTAL AREA = " +  flats.totalArea() + " UNITS SQUARED ", 30, 430);
   
//    area = new Metre (new PVector(30, 450, 0), 300, 15, 100000, 50000, flats.totalArea(), AREA);
//    area.label = "AREA";
   
    viewM.drawBase();
    viewM.drawValue();
    combined.drawBase();
    combined.drawValue();
    area.drawBase();
    area.drawValue();
    cooling.drawBase();
    cooling.drawValue();
//      image(pg, 9, 30); 
   // baseMetre();
   // metre(flats.totalArea());
    cam.endHUD();
    
  }


  void undo () { // call outside setup

    this.s1.setValue((DNAValues.get(DNAValues.size() -2)).floorH);
    this.s2.setValue((DNAValues.get(DNAValues.size() -2)).bldgH);
    this.s3.setValue((DNAValues.get(DNAValues.size() -2)).v0x);
    this.s4.setValue((DNAValues.get(DNAValues.size() -2)).v0y);
    this.s5.setValue((DNAValues.get(DNAValues.size() -2)).v2x);
    this.s6.setValue((DNAValues.get(DNAValues.size() -2)).v2y);
    this.s7.setValue((DNAValues.get(DNAValues.size() -2)).stretchY);
    this.s8.setValue((DNAValues.get(DNAValues.size() -2)).stretchX);
    this.s9.setValue((DNAValues.get(DNAValues.size() -2)).slopeFX);
    this.s10.setValue((DNAValues.get(DNAValues.size() -2)).slopeFY);
    this.s11.setValue((DNAValues.get(DNAValues.size() -2)).slopeBX);
    this.s12.setValue((DNAValues.get(DNAValues.size() -2)).slopeBY);
  }
  
  void locks() { // call outside setup

  this.s1.setLock(lockFloorH);
  this.s2.setLock(lockBldgH);
  this.s3.setLock(lockv0x);
  this.s4.setLock(lockv0y);
  this.s5.setLock(lockv2x);
  this.s6.setLock(lockv2y);
  this.s7.setLock(lockStretchY);
  this.s8.setLock(lockStretchX);
  this.s9.setLock(lockSlopeFX);
  this.s10.setLock(lockSlopeFY);
  this.s11.setLock(lockSlopeBX);
  this.s12.setLock(lockSlopeBY);
  }
  


  
void cE() {
  // set the sloping factor the ability to select and affect only selected vertices. Find better way where MAX and MIN could be used.

 // flats = factory.flats( this.bldgH, this.floorH );

  xValues [0] = v2x;
  yValues [0] = v0y;

  xValues [2] = v0x;
  yValues [2] = v0y;

  xValues [4] = v0x;
  yValues [4] = v2y;

  xValues [6] = v2x;
  yValues [6] = v2y;

  //Calling sloping methods//

///  int verticesF [] = {0, 1, 2, 3};
//  flats.updateSlope(verticesF, this.slopeFX, this.slopeFY);

  // println("slopeFX slider value = "+ slopeFX); // this value must be stored in arrayList to use for undoing

//  int verticesB [] = {4, 5, 6, 7};
//  flats.updateSlope(verticesB, this.slopeBX, this.slopeBY);
 
 // flats.update();
 // flats.update2();
 // restrictArea();
}

//void controlEvent(CallbackEvent theEvent) {  // call outside setup
//
//  if (theEvent.getAction() == controlP5.ACTION_RELEASED) { 
//     storeAllSliderValues ();
//  }
//}
}