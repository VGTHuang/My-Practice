//first processing project, a simple solar system with PDE

int speed = 10;
int celestialBodySize = 14;
int traceWidth = 1;

class location{
  public float x, y;
};

class planet{
  private String planetName;
  private float radius;
  private float x;
  private float y;
  private float w;
  private float angle;
  public float planetRadius;
  public color planetColor;
  public planet(String name, float R, float r, color mycol){
    this.planetName = name;
    this.planetRadius = r*celestialBodySize/maxr;
    this.radius = R*height/(2*maxR);
    this.planetColor = mycol;
    this.x = R;
    this.y = 0;
    this.w = speed*sqrt(1/(this.radius*this.radius*this.radius));
    this.angle = 0;
  }
  public void drawPlanet(){
    fill(this.planetColor);
    ellipse(width/2+x, height/2+y, 2*planetRadius, 2*planetRadius);
    textSize(12);
    text(planetName, width/2+x+planetRadius*1.42, height/2+y);
    //shadow
    fill(0,0,0,160);
    pushMatrix();
    translate(width/2+x,width/2+y);
    rotate(angle);
    rect(0, -planetRadius, planetRadius, 2*planetRadius);
    popMatrix();
  }
  public void incrementLoc(){
    angle = (angle+w)%360;
    x = radius*cos(angle);
    y = radius*sin(angle);
  }
  public location getLoc(){
    location tempLoc = new location();
    tempLoc.x = width/2+x;
    tempLoc.y = width/2+y;
    return tempLoc;
  }
};

class satellite{
  private planet fatherPlanet;
  private float fatherX, fatherY;
  private String satelliteName;
  private float radius;
  private float x, y;
  private float w;
  private float angle;
  public float satelliteRadius;
  public color satelliteColor;
  public satellite(String name, float R, float r, color mycol, planet father){
    fatherPlanet = father;
    this.satelliteName = name;
    this.satelliteRadius = r*celestialBodySize/maxr;
    this.radius = R*height/(2*maxR);
    this.satelliteColor = mycol;
    this.x = R;
    this.y = 0;
    println(father.planetRadius/(sunr*celestialBodySize/maxr));
    this.w = speed*sqrt(pow(         (2*father.planetRadius/(sunr*celestialBodySize/maxr*(this.radius)))          ,3));      //assume this
    this.angle = 0;
  }
  public void drawSatellite(){
    noFill();
    stroke(255);
    strokeWeight(traceWidth);
    ellipse(fatherX, fatherY, 2*radius, 2*radius);
    noStroke();
    
    fill(this.satelliteColor);
    ellipse(fatherX+x, fatherY+y, 2*satelliteRadius, 2*satelliteRadius);
    textSize(12);
    text(satelliteName, fatherX+x+satelliteRadius*1.42, fatherY+y);
  }
  public void incrementLoc(){
    angle = (angle+w)%360;
    x = radius*cos(angle);
    y = radius*sin(angle);
  }
  public void flushFatherCoordinate(){
    fatherX = fatherPlanet.getLoc().x;
    fatherY = fatherPlanet.getLoc().y;
  }
  public location getLoc(){
    location tempLoc = new location();
    tempLoc.x = fatherX+x;
    tempLoc.y = fatherY+y;
    return tempLoc;
  }
};

planet mercury, venus, earth, mars;
satellite moon, phobos, deimos;
float mercuryR = 57.9, venusR = 108.2, earthR = 149.6, marsR = 227.9, maxR = 300;
float sunr = 30000, mercuryr = 4879, venusr = 12104, earthr = 12756, marsr = 6792, maxr = 20000;
color suncol = color(230, 230, 20), mercurycol = color(120, 160, 130), venuscol = color(170, 130, 40), earthcol = color(60, 50, 220), marscol = color(200, 70, 20);

float moonR = 22, phobosR = 15, deimosR = 33;
float moonr = 5000, phobosr = 2700, deimosr = 2000;
color mooncol = color(100, 100, 100), phoboscol = color(170, 130, 146), deimoscol = color(150, 200, 170);

void setup(){
  size(600, 600);
  mercury = new planet("Mercury",mercuryR, mercuryr, mercurycol);
  venus = new planet("Venus", venusR, venusr, venuscol);
  earth = new planet("Earth", earthR, earthr, earthcol);
  mars = new planet("Mars", marsR, marsr, marscol);
  moon = new satellite("Moon", moonR, moonr, mooncol, earth);
  phobos = new satellite("Phobos", phobosR, phobosr, phoboscol, mars);
  deimos = new satellite("Deimos", deimosR, deimosr, deimoscol, mars);
  background(0);
  frameRate(30);
}

void draw(){
  clear();
  drawSystem();
  /*stroke(255);
  line(earth.getLoc().x, earth.getLoc().y, venus.getLoc().x, venus.getLoc().y);
  */
  moon.flushFatherCoordinate();
  phobos.flushFatherCoordinate();
  deimos.flushFatherCoordinate();
  
  mercury.drawPlanet();
  venus.drawPlanet();
  earth.drawPlanet();
  mars.drawPlanet();
  moon.drawSatellite();
  phobos.drawSatellite();
  deimos.drawSatellite();
  
  mercury.incrementLoc();
  venus.incrementLoc();
  earth.incrementLoc();
  mars.incrementLoc();
  moon.incrementLoc();
  phobos.incrementLoc();
  deimos.incrementLoc();
}

void drawSystem(){
  noStroke();
  fill(suncol);
  ellipse(width/2, height/2, 2*sunr*celestialBodySize/maxr, 2*sunr*celestialBodySize/maxr);
  fill(255);
  textSize(18);
  textAlign(CENTER, CENTER);
  text("Sun", width/2, height/2);
  textAlign(LEFT,CENTER);
  
  noFill();
  stroke(255);
  strokeWeight(traceWidth);
  ellipse(width/2, height/2, 2*mercuryR*height/(2*maxR), 2*mercuryR*height/(2*maxR));
  ellipse(width/2, height/2, 2*venusR*height/(2*maxR), 2*venusR*height/(2*maxR));
  ellipse(width/2, height/2, 2*earthR*height/(2*maxR), 2*earthR*height/(2*maxR));
  ellipse(width/2, height/2, 2*marsR*height/(2*maxR), 2*marsR*height/(2*maxR));
  noStroke();
}
