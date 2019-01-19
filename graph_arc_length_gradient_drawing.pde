class Coord{
  int id;
  float x, y;
  float dxsum, dysum;
  
  Coord(int id){
    randomize();
    this.id = id;
  }
  
  public void randomize(){
    x = random(width-60)+30;
    y = random(height-60)+30;
  }
  
  public void drawCoord(){
    noStroke();
    fill(100);
    ellipse(x, y, 5, 5);
    text(id, x, y-5);
  }
}

void drawArc(Coord c1, Coord c2){
  float su = d(c1, c2)-arc[c1.id][c2.id];
  float rad = 255 / (1 + exp(-su*20/width));
  stroke(rad, 255-rad, 255-rad);
  line(c1.x, c1.y, c2.x, c2.y);
}

void drawCanvas(){
  for(int i = 0; i < vnum-1; i++){
    for(int j = i; j < vnum; j++){
      if(arc[i][j] > 0)
        drawArc(ver[i], ver[j]);
    }
  }
  for(int i = 0; i < vnum; i++){
    ver[i].drawCoord();
  }
}

final int vnum = 40;
float[][] arc;
Coord[] ver;

float dx(Coord v1, Coord v2){
  return v1.x - v2.x;
}

float dy(Coord v1, Coord v2){
  return v1.y - v2.y;
}

float d(Coord v1, Coord v2){
  return sqrt(pow(dx(v1, v2),2) + pow(dy(v1, v2),2));
}

float pdx(Coord v1, Coord v2){
  return dx(v1, v2)/d(v1, v2);
}

float pdy(Coord v1, Coord v2){
  return dy(v1, v2)/d(v1, v2);
}

void setup(){
  size(300, 300);
  arc = new float[vnum][vnum];
  ver = new Coord[vnum];
  for(int i = 0; i < vnum; i++){
    ver[i] = new Coord(i);
  }
  /*
  arc[0][1] = arc[1][0] = 150;
  arc[0][2] = arc[2][0] = 65;
  arc[1][2] = arc[2][1] = 90;
  arc[1][3] = arc[3][1] = 70;
  arc[2][4] = arc[4][2] = 40;
  arc[3][4] = arc[4][3] = 200;
  */
  for(int i = 0; i < vnum-1; i++){
    for(int j = i+1; j < vnum; j++){
      if(random(1)<5.0/vnum)
        arc[i][j] = arc[j][i] = random(min(width,height)/1.5);
    }
  }
  /*
  for(int i = 0; i < vnum; i++){
    for(int j = 0; j < vnum; j++){
      print(arc[i][j]+" ");
    }
    println();
  }
  */
  
  frameRate(20);
  
  thread("update");
}

float mar = 0.005;

void update(){
  while(true){
    delay(10);
    
    for(int i = 0; i < vnum; i++){
      ver[i].dxsum = ver[i].dysum = 0;
      for(int j = 0; j < vnum; j++){
        if(i!=j && arc[i][j] > 0){
          float dij = d(ver[i], ver[j]);
          ver[i].dxsum += pdx(ver[i], ver[j])*(dij-arc[i][j])*mar;
          ver[i].dysum += pdy(ver[i], ver[j])*(dij-arc[i][j])*mar;
        }
      }
    }
    for(int i = 0; i < vnum; i++){
      if(ver[i].x - ver[i].dxsum > 20 && ver[i].x - ver[i].dxsum < width-20)
        ver[i].x -= ver[i].dxsum;
      if(ver[i].y - ver[i].dysum > 20 && ver[i].y - ver[i].dysum < height-20)
        ver[i].y -= ver[i].dysum;
    }
  }
}

void draw(){
  background(255);
  drawCanvas();
}