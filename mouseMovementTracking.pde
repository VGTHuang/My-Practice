int dupcount = 30;
int[] x, y;
int temp;
float finaldiam = 100;
float tempdiam;
color backgroundCol = color(100);

void setup(){
  size(500, 500);
  frameRate(30);
  x = new int[dupcount];
  y = new int[dupcount];
  for(int i = 0; i < x.length; i++){
    x[i] = -100;
  }
  for(int i = 0; i < y.length; i++){
    y[i] = -100;
  }
  temp = 0;
}

void draw(){
  noStroke();
  if(mouseX>0&&mouseY>0&&mouseX<width&&mouseY<height)drawTrace();
}

void drawTrace(){
  clear();
  background(backgroundCol);
  if(temp>=0 && temp < dupcount){
    x[temp] = mouseX;
    y[temp] = mouseY;
    tempdiam = 5;
    for(int i = 1; i<dupcount; i++){
      fill(255*i/dupcount);
      ellipse(x[(temp+i)%dupcount], y[(temp+i)%dupcount], tempdiam, tempdiam);
      tempdiam += (finaldiam-5)/dupcount;
    }
    ellipse(x[temp], y[temp], tempdiam, tempdiam);
    temp = (temp+1)%dupcount;
  }
}

void renewArr(int temp, int x, int y){
  
}