class ver{
  public float x, y;
}

final float ratio = 0.05;
final float gap = 1;
final float arrowsize = 20;
final color coordinatecolor = 130;

void setup(){
  size(500, 500);
  noLoop();
}

void draw(){
  background(220);
  drawAxis();
  drawFunc();
}

float function(float x){
  return x*x*x-2*x*x-x+1;
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
    line(0, gridy, height, gridy);
    numeral++;
    text(numeral, width/2, gridy);
  }
  numeral = 0;
  for(gridy = height/2 + 1/ratio; gridy<=height; gridy += 1/ratio){
    line(0, gridy, height, gridy);
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
