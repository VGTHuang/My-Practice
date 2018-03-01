//the initial intention was to make a gravitational simulation. now a weird lissajous thing

final color staticObjectCol = color(0, 0, 255);
final color dynamicObjectCol = color(0, 0, 0);
final float gravityConstant = 0.00001;
final float speed = 1;

//********************************************************************************************
class staticObject{
  protected color col;
  public float x;
  public float y;
  public float radius;
  public float density;
  public staticObject(){};
  public staticObject(float X, float Y, float R, float den){
    x = X;
    y = Y;
    radius = R;
    density = den;
    col = staticObjectCol;
  }
  public void drawObject(){
    noStroke();
    fill(col);
    ellipse(x, y, radius*2, radius*2);
  }
};
//********************************************************************************************
class dynamicObject extends staticObject{
  private float vx;
  private float vy;
  private float ax;
  private float ay;
  private staticObject fatherObject = new staticObject(250, 250, 20, 1);
  public dynamicObject(float X, float Y, float VX, float VY, float R, staticObject FATHER){
    this.x = X;
    this.y = Y;
    this.vx = VX;
    this.vy = VY;
    this.ax = getGravityX();
    this.ay = getGravityY();
    this.radius = R;
    this.col = dynamicObjectCol;
    this.fatherObject = FATHER;
  }
  
  private float getGravityX(){
    if(fatherObject!=null){
      if(fatherObject.x - x == 0) return 0;
      else if(fatherObject.x - x > 0)
        return (gravityConstant*fatherObject.radius*fatherObject.radius*fatherObject.radius*fatherObject.density  /  (fatherObject.x - x)*(fatherObject.x - x));
      else
        return -(gravityConstant*fatherObject.radius*fatherObject.radius*fatherObject.radius*fatherObject.density  /  (fatherObject.x - x)*(fatherObject.x - x));
    
    }
    else
      return 0;
  }
  
  private float getGravityY(){
    if(fatherObject!=null){
      if(fatherObject.y - y == 0) return 0;
      else if(fatherObject.y - y > 0)
        return (gravityConstant*fatherObject.radius*fatherObject.radius*fatherObject.radius*fatherObject.density  /  (fatherObject.y - y)*(fatherObject.y - y));
      else
        return -(gravityConstant*fatherObject.radius*fatherObject.radius*fatherObject.radius*fatherObject.density  /  (fatherObject.y - y)*(fatherObject.y - y));
    }
    else
      return 0;
  }
  
  
  public void incrementLoc(){
    ax = getGravityX();
    ay = getGravityY();
    
    vx += ax*speed;
    vy += ay*speed;
    
    x += vx*speed;
    y += vy*speed;
    
  }
  
  public void printLoc(){
    println(x, y, vx, vy, ax, ay);
  }
};
//********************************************************************************************


staticObject sun = new staticObject(250, 250, 20, 1);
dynamicObject planet = new dynamicObject(100, 250, 0, 5, 1, sun);

void setup(){
  size(500, 500);
  frameRate(20);
}

void draw(){
  planet.drawObject();
  planet.incrementLoc();
}