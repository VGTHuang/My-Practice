int crow = 1; // current row
int prerow = 0; // previous row

boolean rule30(int col){  // rule 20
  boolean c1 = brightness(get(col-1, prerow)) > 0?true:false;
  boolean c2 = brightness(get(col, prerow)) > 0?true:false;
  boolean c3 = brightness(get(col+1, prerow)) > 0?true:false;
  if(c1&&c2&&c3) return false;
  if(c1&&c2&&!c3) return false;
  if(c1&&!c2&&c3) return false;
  if(c1&&!c2&&!c3) return true;
  if(!c1&&c2&&c3) return true;
  if(!c1&&c2&&!c3) return true;
  if(!c1&&!c2&&c3) return true;
  else return false;
}

boolean rule110(int col){  // rule 110
  boolean c1 = brightness(get(col-1, prerow)) > 0?true:false;
  boolean c2 = brightness(get(col, prerow)) > 0?true:false;
  boolean c3 = brightness(get(col+1, prerow)) > 0?true:false;
  if(c1&&c2&&c3) return false;
  if(c1&&c2&&!c3) return true;
  if(c1&&!c2&&c3) return true;
  if(c1&&!c2&&!c3) return false;
  if(!c1&&c2&&c3) return true;
  if(!c1&&c2&&!c3) return true;
  if(!c1&&!c2&&c3) return true;
  else return false;
}

void drawRow(){
  for(int i = 1; i < cellnum - 1; i++){
    
    if(rule110(i)){      // applying rule 30 or rule 110
      stroke(255);
    }
    else
      stroke(0);
      
    point(i, crow);
  }
}

void setup(){
  size(300, 300);
  frameRate(20);
  background(0);
  noFill();
  stroke(255);
  noSmooth();
  
  point(299, 0); // initial input
}

void draw(){
  drawRow();
  crow++;
  crow %= height;
  prerow++;
  prerow %= height;
}
