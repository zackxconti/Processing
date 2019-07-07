class Line {

  PVector A;
  PVector B;


  Line (PVector A, PVector B) {

    this.A = A;
    this.B = B;

    

  }
  
  
  
  void draw () {
    
    strokeWeight(0.4);
    stroke (255);
    line (this.A.x, this.A.y, this.A.z, this.B.x, this.B.y, this.B.z);
    
  }
}

