class Slider {
  float x;
  float y;
  boolean isPressed;
  void drawObject() {
    stroke(0);
    strokeWeight(2);
    fill(255);
    rect(x, y, 25, 50);
  }
 
  void updateObject(boolean changeSlider) {
    x += mouseX-pmouseX;
 
    if (x > 305) {
      x = 305;
    }
    if (x < 50) {
      x = 50;
    }
  }
 
  boolean hitTest(float xClicked, float yClicked) {
    if (xClicked > x && xClicked < x+25 && yClicked > y && yClicked < y+50) {
      return true;
    }
    return false;
  }
}