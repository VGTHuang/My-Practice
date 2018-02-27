//simple random dots

int vernum = 10;
float[] x;
float[] y;
float []vx;
float []vy;
int speed = 1;

int size = 500;

void setup() {
  size(500, 500);
  x = new float[vernum];
  y = new float[vernum];
  vx = new float[vernum];
  vy = new float[vernum];
  
  for (int i = 0; i < vernum; i++) {
    x[i] = random(500);
    y[i] = random(500);
    vx[i] = random(speed) - speed/2;
    vy[i] = random(speed) - speed/2;
  }
  noStroke();
  background(0);
  frameRate(20);
}

void draw() {
  clear();
  fill(255);
  int i, j;
  for(i = 0;i < vernum; i++)
    ellipse(x[i], y[i], 5, 5);
  strokeWeight(1);
  for(i = 0;i < vernum; i++){
    for(j = 0; j < vernum; j++){
      stroke(255, 255, 255, 100-dist(x[i], y[i], x[j], y[j])*100/size);
      line(x[i], y[i], x[j], y[j]);
    }
  }
  
  randMove();
}

void randMove(){
  int i;
  for(i = 0; i < vernum; i++){
    vx[i] += random(speed)-random(2)*speed*x[i]/size;
    if(withinBound(x[i]+vx[i]))x[i]+=vx[i];
    vy[i] += random(speed)-random(2)*speed*y[i]/size;
    if(withinBound(y[i]+vy[i]))y[i]+=vy[i];
  }
}

boolean withinBound(float a){
  return(a>=0&&a<=size);
}