class ver{
  public float x, y;
}

float ratio = 0.05;
final float gap = 1;
final float arrowsize = 20;
final color coordinatecolor = 130;
float a = 0;

void setup(){
  size(500, 300);
  frameRate(20);
}

void draw(){
  background(220);
  drawAxis();
  drawFunc();
  a+=0.05;
}

float function(float x){
  return (sin(2.4*x+a)+1.3*sin(x-2*a)+0.8*sin(3.7*x-0.7*a));     //type function here
}

float transformX(float x){
  return (x/ratio)+width/2;
}

float transformY(float y){
  return (-y/ratio)+height/2;
}

void drawFunc(){
  stroke(0);
  ver pre = new ver();
  float range = width*ratio/2;
  float projectiongap = gap*ratio;
  float funcx;
  pre.x = transformX(-range);
  pre.y = transformY(function(-range));
  for(funcx = -range; funcx <= range; funcx += projectiongap){
    line(pre.x, pre.y, transformX(funcx), transformY(function(funcx)));
    pre.x = transformX(funcx);
    pre.y = transformY(function(funcx));
  }
}

void drawAxis(){
  float gridx, gridy;
  stroke(127.5+coordinatecolor/2);
  int numeral = 0;
  fill(coordinatecolor);
  textAlign(RIGHT, TOP);
  text('0', width/2, height/2);
  for(gridx = width/2 - 1/ratio; gridx>=0; gridx -= 1/ratio){
    line(gridx, 0, gridx, height);
    numeral--;
    text(numeral, gridx, height/2);
  }
  numeral = 0;
  for(gridx = width/2 + 1/ratio; gridx<=width; gridx += 1/ratio){
    line(gridx, 0, gridx, height);
    numeral++;
    text(numeral, gridx, height/2);
  }
  numeral = 0;
  for(gridy = height/2 - 1/ratio; gridy>=0; gridy -= 1/ratio){
    line(0, gridy, width, gridy);
    numeral++;
    text(numeral, width/2, gridy);
  }
  numeral = 0;
  for(gridy = height/2 + 1/ratio; gridy<=height; gridy += 1/ratio){
    line(0, gridy, width, gridy);
    numeral--;
    text(numeral, width/2, gridy);
  }
  
  stroke(coordinatecolor);
  line(width/2, 0, width/2, height);
  line(0, height/2, width, height/2);
  
  noStroke();
  fill(coordinatecolor);
  triangle(width, height/2, width-arrowsize, height/2-arrowsize/4, width-arrowsize, height/2+arrowsize/4);
  triangle(width/2, 0, width/2-arrowsize/4, arrowsize, width/2+arrowsize/4, arrowsize);
}

void mouseWheel(MouseEvent event) {
  if(ratio>=0.01) ratio += event.getCount()*0.005;
  if(ratio<0.01&&ratio>0.005&&event.getCount()>0) ratio+=event.getCount()*0.005;
}
