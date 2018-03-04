//Lissajous

float x, y;
int T = 100, count = 0;
int size = 100;
int rad = 5;
int dup = 30;
float ratio = 1;

void setup(){
  size(300, 300);
  frameRate(20);
  
  background(255);
}

void draw(){
  clear();
  background(0);
  Lis1();
  Lis2();
}

void Lis1(){
  ratio = 2;
  count = (count+1)%T;
  for(int i = 0; i < dup; i++){
    x = size*sin(((count+i)%T)*2*PI/T + PI/6) + width/2;
    y = size*cos(((count+i)%T)*2*ratio*PI/T) + height/2;
    fill(i*255/dup, 0, i*255/dup);
    noStroke();
    ellipse(x, y, rad, rad);
    stroke(i*255/dup, 0, i*255/dup);
    line(size*sin(((count+i - 1)%T)*2*PI/T + PI/6) + 150, size*cos(((count+i - 1)%T)*2*ratio*PI/T) + 150,
      size*sin(((count+i)%T)*2*PI/T + PI/6) + 150, size*cos(((count+i)%T)*2*ratio*PI/T) + 150);
  }
}

void Lis2(){
  ratio = 2;
  count = (count+1)%T;
  for(int i = 0; i < dup; i++){
    x = size*sin(((count+i)%T)*2*ratio*PI/T + PI/6) + width/2;
    y = size*cos(((count+i)%T)*2*PI/T) + height/2;
    fill(i*255/dup, i*255/dup, 0);
    noStroke();
    ellipse(x, y, rad, rad);
    stroke(i*255/dup, i*255/dup, 0);
    line(size*sin(((count+i - 1)%T)*2*ratio*PI/T + PI/6) + 150, size*cos(((count+i - 1)%T)*2*PI/T) + 150,
      size*sin(((count+i)%T)*2*ratio*PI/T + PI/6) + 150, size*cos(((count+i)%T)*2*PI/T) + 150);
  }
}