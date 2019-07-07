class Sun {

  PVector direction;  //sun direction

    int year;
  int month;
  int day;
  int hours;
  int minutes;
  float latitude;
  float longitude;
  int gmtOffset;
  int skyClearness;

  String [] [] temps;


  float northOffset;
  PVector north ;
  float zenithAngle;

  boolean Sun;
  boolean Gravity;
  boolean Faces;
  boolean Edges;
  boolean displayNorth;
  boolean displayDirection;
  boolean Shadows;

  Float F11 [];
  Float F12 [];
  Float F13 [];
  Float F21 [];
  Float F22 [];
  Float F23 [];

  float F1;
  float F2;


  Sun (int y, int m, int d, int h, int min, float lat, float lng, int gmtOffset, float northOffset, int skyClearness) {  // define PVector sun later on in this class

    this.year = y;
    this.month = m;
    this.day = d;
    this.hours = h;
    this.minutes = min;
    this.latitude = lat;
    this.longitude = lng;
    this.gmtOffset = gmtOffset;
    this.northOffset = northOffset;
    this.skyClearness = skyClearness;
    
    int temperatures [] = {24, 23, 24, 23, 23, 23, 23, 24, 26, 27, 29, 29, 31, 31, 31, 31, 32, 32, 31, 28, 26, 25, 25, 24};


   // this.temps =s.getTemperatures("test");
   this.temps=this.getTemperatures("test");
   
//   String tempers [] [] = this.getTemperatures("test");
//   
//   for(int i =0; i<this.tempers.length; i++){
//     for(int j =0; j<this.tempers[0].length; j++){
       
   
    //this.zenithAngle = degrees((PI*0.5) - this.elevation());



    //////////////////// Perez model coefficients for irradiance ////////////////////
    Float a [] = { 
      -0.008f, 0.130f, 0.330f, 0.568f, 0.873f, 1.132f, 1.060f, 0.678f
    };
    this.F11  = a;
    Float b []  = {
      0.588, 0.683, 0.487, 0.187, -0.392, -1.237, -1.600, -0.327
    };
    this.F12  = b;
    Float c [] = {
      -0.062, -0.0151, -0.221, -0.295, -0.362, -0.412, -0.359, -0.250
    };
    this.F13 = c;
    Float dee [] = {
      -0.060, -0.019, -0.055, 0.109, 0.226, 0.288, 0.264, 0.156
    };
    this.F21  = dee;
    Float e [] = {
      0.072, 0.066, -0.064, -0.152, -0.462, -0.823, -1.127, -1.377
    };
    this.F22 = e;
    Float f []  = { 
      -0.022, -0.029, -0.026, -0.014, 0.001, 0.056, 0.131, 0.251
    };
    this.F23 = f;

    this.brighteningCoeffs(this.skyClearness, 0.2 );  // 0.2 must be replaced by a diffuse horizontal radiation value from a table 

    /////////////////////////////////////////////////////////////////////////////////

    this.north = new PVector (cos((PI*0.5)-radians(this.northOffset)), sin((PI*0.5)-radians(this.northOffset)), 0); // WORKING CORRECTLY
    //println("north x "+this.north.x);
    this.direction = new PVector(((sin(this.azimuth() + (radians(this.northOffset))))), (-1)*((cos(this.azimuth() + (radians(this.northOffset)) ))), sin(this.elevation())); 
    this.direction.normalize();

    ///////////////////////////////// Zenith Angle /////////////////////////////////

    PVector n = new PVector (0, 0, 1);
    this.zenithAngle = n.dot(this.direction);
    // println("this.zenithAngle "+this.zenithAngle);

    /////////////////////////////////////////////////////////////////////////////////
  }

  void drawNorth () {
    colorMode(RGB, 255);
    noFill();
    stroke (255);
    strokeWeight(2
      );
    ellipse(0, 0, 200, 200);
    stroke (255, 0, 0);
    line(0, 0, 200*this.north.x, -200*this.north.y);
  }


  void drawDirection () {
    
    colorMode(RGB, 255);
    stroke(250, 250, 0);
    strokeWeight(1);
    line(0, 0, 0, 500*this.direction.x, 500* this.direction.y, 500*this.direction.z);
  }

 void updateDirection () {
      this.direction = new PVector(((sin(this.azimuth() + (radians(this.northOffset))))), (-1)*((cos(this.azimuth() + (radians(this.northOffset)) ))), sin(this.elevation())); 
      this.direction.normalize();
      this.updateZenith();
 
 }
 
 void updateZenith () {
       PVector n = new PVector (0, 0, 1);
     this.zenithAngle = n.dot(this.direction);
 }
 


  ////////////////////////////// SOLAR POSITION CALCULATIONS ////////////////////////////// 


  float localTime () {

    float lt = this.hours + (minutes/60); // calculates local time in hours

    return lt;
  }  


  float b () {

    float b = (360f/365f)*(this.daysPassed() - 81);

    return b; // in degrees
  }

  float declination () {

    float dec = (radians(23.45))*sin(radians(this.b()));
    //println("declination is "+ degrees(dec));

    return dec;
  }

  float hourAngle () {

    float lstm = (15)*gmtOffset;  // calculates local standard time meridian in DEGREES
    float eot = (9.87*(sin(2*(radians(this.b()))))) - (7.53*(cos(radians(this.b())))) - (1.5*(sin(radians(this.b())))); // calculates the equation of time in minutes    
    float tc = (4*(this.longitude - lstm)) + (eot); // calculates the time correction factor in minutes
    float lst = this.localTime() + ((tc)/60); // calculates the local solar time 
    float hra = (15)*((lst)-12); // calculates the hour angle 
    //    println("Eot = " + eot + " , Tc = " + tc + " , declination = " + degrees(this.declination()) + " , hra = " + hra );
    //    println("long = "+this.longitude);
    //    println("lat = "+this.latitude);
    //    println("lst = " + lst);
    return hra;
  }


  float elevation () {
    float alpha = asin(((sin((this.declination())))*(sin(radians(this.latitude)))) + ((cos(this.declination()))*(cos(radians(this.latitude)))*(cos(radians(this.hourAngle())))));

    return alpha;
    // write little test to confirm quadrant due to inverse cos - see about atan2
  }


  float azimuth () { // either calc by hour angle method or by elevation method - hour angle method gives you atan

    float h = ((sin(this.declination()))*(cos(radians(this.latitude)))) - ((cos(this.declination()))*(sin(radians(this.latitude)))*(cos(radians(this.hourAngle()))));
    float b = cos(this.elevation());
    float theta =0;

    if (this.hourAngle() > 0) {
      theta = (2*PI) - acos((h) /(b));
    }
    else {
      theta =acos((h) /(b));
    }


    return theta;
  }

  int daysPassed () {

    int daysPassed = 0 ; 

    if (this.month>1) daysPassed += 31;

    if (this.month>2) { 
      if (year % 4 == 0) { 
        daysPassed += 29;
      } 
      else { 

        daysPassed +=28 ; // condition for leap year
      }
    }
    if (this.month>3) daysPassed += 31;
    if (this.month>4) daysPassed += 30;
    if (this.month>5) daysPassed += 31;
    if (this.month>6) daysPassed += 30;
    if (this.month>7) daysPassed += 31;
    if (this.month>8) daysPassed += 31;
    if (this.month>9) daysPassed += 30;
    if (this.month>10) daysPassed += 31;
    if (this.month>11) daysPassed += 30;

    daysPassed += this.day;

    // println(daysPassed);


    return daysPassed;
  }


  float airMass () {
    //  float aM= cos(acos(sunEnergyFactor()));
    float cosTheta = this.zenithAngle;
    float AM = 1.0 / (cosTheta + (0.50572* pow((96.07995 - acos(cosTheta)), -1.6364))) ;
    return AM;
  }


  float extraterrestrialR () {  // Calculates extraterrestrial irradiance // working correctly

    float solarC = 1367; // W/m^2
    int n = this.daysPassed();

    float I = solarC * ( 1 + (0.033* cos(((2*PI*n)/365) - 0.048869)));  // n = day number in year
    return I;
  }


  float delta (float diffuseHorizontalR) {  // takes argument : horizontal diffuse irradiance/radiation - value from national solar radiation database

    float delta = diffuseHorizontalR * (this.airMass() /  this.extraterrestrialR());
    return delta;
  }


  float cosBeta(Face f) {
    PVector fNormal = f.normal();
    fNormal.normalize();
    PVector z = new PVector (0, 0, 1);
    z.normalize();

    float cosBeta = fNormal.dot(z);
    return cosBeta;
  }



  void brighteningCoeffs (int skyClearness, float diffuseHorizontalR) {  // skyClearness is a value between 1 and 8, the latter representing no cloud cover

    this.F1 = this.F11[skyClearness] + (this.F12[skyClearness] * this.delta(diffuseHorizontalR)) + (F13[skyClearness]*this.zenithAngle);
    this.F2 = this.F21[skyClearness] + (this.F22[skyClearness] * this.delta(diffuseHorizontalR)) + (F23[skyClearness]*this.zenithAngle);
  }

  float directBeam () {
    // assuming altitude of Malta is 91m or 0.091 Km above sea leave

    float Gcb = this.extraterrestrialR () * this.atmoTransmittance(0.091) * this.zenithAngle ;
    //    println("Direct Beam  = "+Gcb);
    return Gcb;
  } 

  float atmoTransmittance (float altitude) {
    // obtained from Solar Engineering of Thermal Processes Book by John Duffie and William A. Beckman. 
    // this method is take from Hottel (1976)

    float A = altitude;

    // correction factos for Midaltitude Climate ( from p69 of same book).  - also Hottel (1976)
    float r0 = 0.97;
    float r1 = 0.99;
    float rk = 1.02;

    // constants
    float a0 = 0.4237 - ((0.00821)*((6 - A)*(6 - A)));
    float a1 = 0.5055 +(0.00595*((6.5 - A)*(6.5 - A)));
    float k = 0.2711 + (0.01858*((2.5-A)*(2.5-A)));

    // atmospheric transmittance for beam radiation Tb
    float Tb = (a0*r0)+ ((a1*r1)*exp(((-k)*(rk/s.zenithAngle))));
    //    println("Tb = "+Tb);
    return Tb;
  }


  //  float DNI () {
  //    float omega = PI * (this.daysPassed()/182.5);
  //
  //    float Inod = 1166.1 + (77.375*cos(omega)) + (2.9086*(cos(omega)*cos(omega)));
  //
  //    float dni = Inod*exp( this.airMass() * (- 3));
  //
  //    return dni;
  //  }


  float diffuseHorizontalR () {

    float Td = 0.271 - (0.294*this.atmoTransmittance(0.091));
    return Td;
  }


  float skyRadiation (Face f) {


    float beta = acos(this.cosBeta(f)); 
    //println("beta "+beta); //  NOT ideal

    // Broken down Perez's model of diffuse irradiance/radiation model

    float a = 0;
    float b = 0.087;

    if (f.sunEnergyFactor() > 0) {
      a = f.sunEnergyFactor();
    } 


    if (this.zenithAngle > b) {

      b = this.zenithAngle;
    }

    float g = 0.5*(1-s.F1)*(1+this.cosBeta(f)) ;
    float h = (s.F1*(a/b));
    float i = s.F2 * sin(beta);

    float skyRad = this.diffuseHorizontalR() * ( g + h + i);

    return skyRad;
  }


  float groundRadiation (Face f) { // otain globalHorizonalR monthly/yearly average from data tables

    // // assuming albedo value for work asphalt (pavement) = 0.12
    float gRad = 0.5f * (0.12 - 0.2f) * this.globalHorizontalR() * (1 - this.cosBeta(f));
    return gRad;
  }


  float globalHorizontalR () {

    float GHR = diffuseHorizontalR () + (this.directBeam() * this.zenithAngle) ; 
    return GHR;
  }


  float globalSolarRad (Face f) {
// println("hours in the sun = "+s.hours);
// println(" sun Energy factor = "+f.sunEnergyFactor());
 //println(" sun direction = "+this.direction);
    float I = (f.sunEnergyFactor()*this.directBeam()) + this.skyRadiation (f) + this.groundRadiation(f) ;
    //println("Solar Radiation "+I);
    if (I<0) { 
      I=0;
    };
    return I;
  }


  //  float [] solarRad (Face f ){
  //     int [] solarRadiation = new int [24];
  //     for(int i=0; i<24; i++){
  //       s.hours = i+1;
  //       solarRadiation [i] = s.globalSolarRad (f);
  //     }
  //     return 
  //  }





  float solAirTemp (int externalT, float timeLag, Face bldgComponent, int index) {

    // CITATION : P.W. O'Callaghan, S.D. Probert, Sol-air temperature, Applied Energy, Volume 3, Issue 4, October 1977, Pages 307-311, ISSN 0306-2619, 10.1016/0306-2619(77)90017-4.
    //(http://www.sciencedirect.com/science/article/pii/0306261977900174)
    
    float Rroof = 0.04; // m2K/W
    float Rwall = 0.05; // m2K/W

    // Abosorpitivity alpha
    float alphaDark = 0.9;
    float alphaLight = 0.5;
   
    
    // CITATION: 
    // Celestino R. Ruivo, Paulo M. Ferreira, Daniel C. Vaz, Prediction of thermal load temperature difference values for the external envelope of rooms with setback and setup thermostats, Applied Thermal Engineering, Volume 51, Issues 1–2, March 2013, Pages 980-987, ISSN 1359-4311, 10.1016/j.applthermaleng.2012.11.005.
    //(http://www.sciencedirect.com/science/article/pii/S135943111200717X)
    // Keywords: Building; External envelope; Thermal load temperature difference; Setback and setup thermostats 

    float EdeltaR = 63; // W/m2
    float hExt = 17;
    int currH = s.hours;
    int currD = s.day;
    int currM = s.month;
    float sAt = 0;
    float [] solarRadiation = new float [24];

    for (int i=0; i<24; i++) {
      s.day = 6;
      s.month = 8-index;
      s.hours = i+1;
      solarRadiation [i] = s.globalSolarRad (bldgComponent);
    }
    
 // println("here");
    s.hours = currH;
    s.day = currD;
    s.month = currM;
  //  println("ssds"+s.hours+" " +timeLag)   ;
  //  println("ss"+(int)(((24 + s.hours)%24)-timeLag))   ;
    if(s.hours > 10){
       sAt = externalT + ((alphaLight*solarRadiation[(int)((( s.hours))-timeLag)])/hExt) - (EdeltaR/hExt);  
    } else {
       sAt = externalT + ((alphaLight*solarRadiation[(int)(((24 + s.hours))-timeLag)])/hExt) - (EdeltaR/hExt);  
    }
    //   println("sol-airtemp = "+(int)(s.hours-timeLag));
    //   println("sss = "+ s.hours);

    return sAt;
  }


  float meanSolAirTemp (Face bldgComponent, float timeLag, int index) {
    String [] [] hello = this.temps;
    
    float total =0;
    
    int d = s.hours; // store initial sun direction in order to replace it back
    int e = s.day;
    int ff = s.month; 
    for (int i=0; i<hello[0].length; i++) {
      s.month = 8-index;
      s.day = 6;
      s.hours = i+1;
      total = total + (this.solAirTemp(int(hello[index][i]), timeLag, bldgComponent, index));
    } 
    s.hours = d; // put sun direction back to where it was
    s.day = e;
    s.month = ff;

    float mean = total/this.temps.length;
    return mean;
  }



  String [][] getTemperatures  (String fileName) {
    
    String lines[] = loadStrings(fileName+".csv");
    String [][] csv;
    int csvWidth=0;

    //calculate max width of csv file
    for (int i=0; i < lines.length; i++) {
      String [] chars=split(lines[i], ',');
      if (chars.length>csvWidth) {
        csvWidth=chars.length;
      }
    }

    //create csv array based on # of rows and columns in csv file
    csv = new String [lines.length][csvWidth];

    //parse values into 2d array
    for (int i=0; i < lines.length; i++) {
      String [] temp = new String [lines.length];
      temp= split(lines[i], ',');
      for (int j=0; j < temp.length; j++) {
        csv[i][j]=temp[j];
      }
    }
  //  println("CSV"+int(csv[0][4]));
    
    return csv;
  }


  void gui () {
    Solar = controlP5.addGroup("Solar", 25, 50, 340).setBackgroundColor(color(50)).setBackgroundHeight(200).setLabel("Solar Geometry").setBarHeight(20);
    Label S_label = Solar.getCaptionLabel().align(CENTER,CENTER);
    
    controlP5.addSlider("northOffset", 0, 360, 0, (30), (10), 200, 10).setId(1).setLabel("North Offset").moveTo(Solar).setColorBackground(#C0C0C0).setColorForeground(#E5E4E2).setColorActive(#FFFFFF).setColorValue(#000000);
    controlP5.addSlider("month", 1, 12, 7, (30), 30, 200, 10).setId(2).setValue(7).moveTo(Solar).setColorBackground(#C0C0C0).setColorForeground(#E5E4E2).setColorActive(#FFFFFF).setColorValue(#000000);
    controlP5.addSlider("day", 1, 31, 07, (30), 50, 200, 10).setId(3).setValue(07).moveTo(Solar).setColorBackground(#C0C0C0).setColorForeground(#E5E4E2).setColorActive(#FFFFFF).setColorValue(#000000);
    controlP5.addSlider("hours", 1, 24, 12, (30), 70, 200, 10).setId(4).setValue(12).moveTo(Solar).setColorBackground(#C0C0C0).setColorForeground(#E5E4E2).setColorActive(#FFFFFF).setColorValue(#000000);
    controlP5.addSlider("minutes", 0, 60, 0, (30), 90, 200, 10).setId(5).setValue(0).moveTo(Solar).setColorBackground(#C0C0C0).setColorForeground(#E5E4E2).setColorActive(#FFFFFF).setColorValue(#000000);
    controlP5.addSlider("latitude", -90, 90, 35, (30), 110, 200, 10).setId(6).setValue(35).moveTo(Solar).setColorBackground(#C0C0C0).setColorForeground(#E5E4E2).setColorActive(#FFFFFF).setColorValue(#000000);
    controlP5.addSlider("longitude", -180, 180, 14, (30), 130, 200, 10).setId(7).setValue(14).moveTo(Solar).setColorBackground(#C0C0C0).setColorForeground(#E5E4E2).setColorActive(#FFFFFF).setColorValue(#000000);
    controlP5.addSlider("gmtOffset", -12, 14, 2, (30), 150, 200, 10).setId(8).setValue(2).moveTo(Solar).setColorBackground(#C0C0C0).setColorForeground(#E5E4E2).setColorActive(#FFFFFF).setColorValue(#000000);
    controlP5.addSlider("skyClearness", 1, 8, 1, (30), 170, 200, 10).setId(8).setValue(2).moveTo(Solar).setLabel("Sky Clearness").setColorBackground(#C0C0C0).setColorForeground(#E5E4E2).setColorActive(#FFFFFF).setColorValue(#000000);

    // controlP5.addSlider("From", 0, 300, 200, (300), (30), 200, 10).setId(9);
    //controlP5.addSlider("To", 0, 300, 200, (300), (30)+20, 200, 10).setId(10);
    // controlP5.addToggle("Sun", false, 30, 30, 20, 20).setId(11);
    // controlP5.addToggle("Gravity", false, 380, 30, 20, 20).setId(12);
    // controlP5.addToggle("Faces", false, 340, 30, 20, 20).setId(13);
  }




  void draw () {

    fill(255);
    noStroke();
    lights();
    pushMatrix();
    translate(500*direction.x, 500*direction.y, 500*direction.z);
    sphere(10);
    popMatrix();
  }
}

