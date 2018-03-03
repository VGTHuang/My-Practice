//simple gravity

final color staticObjectCol = color(0, 0, 255);
final color dynamicObjectCol = color(0, 0, 0);
final float gravityConstant = 0.01;
final float speed = 2;

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
  private double vx;
  private double vy;
  private double ax;
  private double ay;
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
  
  private double getGravity(){
    if(fatherObject!=null){
      if(fatherObject.x - x == 0) return 0;
      else
        return (100*gravityConstant*fatherObject.radius*fatherObject.radius*fatherObject.radius*fatherObject.density
            /((fatherObject.x - x)*(fatherObject.x - x)+(fatherObject.y - y)*(fatherObject.y - y)));
      }
    else
      return 0;
  }
  
  private double getGravityX(){
    if(fatherObject!=null){
      return getGravity()*(fatherObject.x - x)/(dist(fatherObject.x, fatherObject.y, x, y));
    }
    else
      return 0;
  }
  
  private double getGravityY(){
    if(fatherObject!=null){
      return getGravity()*(fatherObject.y - y)/(dist(fatherObject.x, fatherObject.y, x, y));
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
dynamicObject planet = new dynamicObject(250, 40, 5, 0,  1, sun);

void setup(){
  size(500, 500);
  frameRate(20);
}

void draw(){
  sun.drawObject();
  planet.drawObject();
  planet.incrementLoc();
}
