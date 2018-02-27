int recurscount = 16;
int temprec = 0;
float leftangle = PI/7;
float rightangle = PI/8;
float leftshrink = 0.7;
float rightshrink = 0.9;


void setup(){
  size(500, 500);
  frameRate(5);
  background(255);
  noLoop();
}

void draw(){
  pushMatrix();
  translate(160,50);
  drawBranch(70);
  popMatrix();
}

void drawBranch(float l){
  if(temprec>=recurscount) {
    return;
  }
  temprec++;
  strokeWeight(l/20);
  line(0, 0, 0, l);
  
  pushMatrix();
  translate(0, l);
  rotate(leftangle);
  drawBranch(l*leftshrink);
  popMatrix();
  
  pushMatrix();
  translate(0, l);
  rotate(-rightangle);
  drawBranch(l*rightshrink);
  popMatrix();
  temprec--;
  return;
}