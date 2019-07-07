 class Metre {
  
  PVector position;
  float width;
  float height;
  float max;
  float min;
  float value;
  float percentage;
  int r;
  int g;
  int b;
  String label;
  float val;
  
  Metre (PVector position, float width, float height, float max, float min, float value, String label) {
    
    this.position = position;
    this.width = width;
    this.height = height;
    this.max = max;
    this.min = min;
    this.value = value;
    float x = 0.0f;
    
//    this.r = 255;
//    this.g = 255;
//    this.b = 255;
   // this.label = "FIT";
    
    if (this.value > this.min) {
      x = this.value - this.min ;
      this.percentage = x / (this.max - this.min);
          this.r = 255;
    this.g = 255;
    this.b = 255;
//      println("x = "+x);
     
//      println("max = "+this.max);
//      println("min = "+this.min);
    } 
    
    if(this.value > this.max) {
      
     this.percentage = 1.0f;
   //  this.max = this.max*2;
     this.r = 0;
     this.g = 255;
     this.b = 0;
     println("maximum of "+this.label);
    }else if(this.value < this.min){
      
      this.percentage = 0.0f;
      
      this.r = 255;
      this.g = 0;
      this.b = 0;
      
    }
    

    
   // println ("x = " +x);
     // proportionate value between 0 and 1.
    
  }
  

  void drawBase () {
    //colorMode(HSB, 1, 1, 1);
    //colorMode(RGB);
    //base rectangle
    //fill (1, 0.1, 0.2);
    fill(150);
    noStroke();
    rect (this.position.x, this.position.y, this.height, -this.width);
    

   // println("percentage = "+this.percentage);
    // PFont font = loadFont 
    textSize(12);
  //  textFont(
    fill(255);
   
    
  float x = this.position.x+this.height/2;
  float y = this.position.y+this.height/2;
//  textAlign(CENTER,BOTTOM);
//
  pushMatrix();
  translate(x,y);
  rotate(HALF_PI);
  text( this.label+" FITNESS = " +  this.percentage  , 0, 0);
  popMatrix();
    
  }
  
  
  void drawValue () {
    colorMode(RGB);
        fill(this.r, this.g, this.b);
        if(this.value<this.min){
       noStroke();
   //   rect(this.position.x, this.position.y, this.width, this.height);
       rect(this.position.x, this.position.y, this.height, -this.width);
 } else{
    noStroke();
  //  rect(this.position.x, this.position.y, this.percentage*this.width, this.height);
    rect(this.position.x, this.position.y, this.height, -this.percentage*this.width);
  }
  }
}


//
//class solarParameters {
//  
//int Year;
//int Month;
//int Day;
//int Hour;
//int Minutes;
//float Latitude;
//float Longitude;
//int GMT;
//float From;
//float To;
//float northOffset;
//PVector north ;
//
//boolean Sun;
//boolean Gravity;
//boolean Faces;
//boolean Edges;
//boolean displayNorth;
//boolean displayDirection;
//boolean Shadows;
//  
//  
//  
//  solarParameters () {
//    
//  controlP5.addSlider("northOffset", 0, 360, 0, (30), (70), 200, 10).setId(1).setLabel("North Offset").setValue(0);
//  controlP5.addSlider("Month", 1, 12, 7, (30), (70)+20, 200, 10).setId(2).setValue(7);
//  controlP5.addSlider("Day", 1, 31, 07, (30), (70)+40, 200, 10).setId(3).setValue(07);
//  controlP5.addSlider("Hour", 1, 24, 12, (30), (70)+60, 200, 10).setId(4).setValue(12);
//  controlP5.addSlider("Minutes", 0, 60, 0, (30), (70)+80, 200, 10).setId(5).setValue(0);
//  controlP5.addSlider("Latitude", -90, 90, 35, (30), (70)+100, 200, 10).setId(6).setValue(35);
//  controlP5.addSlider("Longitude", -180, 180, 14, (30), (70)+120, 200, 10).setId(7).setValue(14);
//  controlP5.addSlider("GMT", -12, 14, 2, (30), (70)+140, 200, 10).setId(8).setValue(2);
//
//  // controlP5.addSlider("From", 0, 300, 200, (300), (30), 200, 10).setId(9);
//  //controlP5.addSlider("To", 0, 300, 200, (300), (30)+20, 200, 10).setId(10);
//  controlP5.addToggle("Sun", false, 30, 30, 20, 20).setId(11);
//  controlP5.addToggle("Gravity", false, 380, 30, 20, 20).setId(12);
//  controlP5.addToggle("Faces", false, 340, 30, 20, 20).setId(13);
//    
//    
//  }
//}
