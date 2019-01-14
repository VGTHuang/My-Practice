import java.util.*;

final int drawType = 1;
final int sortType = 3;

final int framerate = 30;

final int num = 1000;
final int edge = 15;
final float gap = 0.1;


int[] arr;

void swapArrElem(int i, int j){
  int temp = arr[i];
  arr[i] = arr[j];
  arr[j] = temp;
}

void randomize(){
  Random rand = new Random();
  for(int i = 0; i < arr.length; i++){
    int randPos = rand.nextInt(arr.length);
    swapArrElem(i, randPos);
  }
}

void drawArr(int type){
  background(0);
  fill(255);
  textSize(15);
  text(int(cmpCount), 5, 20);
  switch(type){
    case 1:
    drawArrType1(); break;
    case 2:
    drawArrType2(); break;
    default:
    break;
  }
  
}

void drawArrType1(){
  pushMatrix();
  translate(edge, height-edge);
  scale((width-edge*2)/(1.0*width), (-height+edge*2)/(1.0*height));
  // draw patterns
  float wid = 1.0*width/arr.length;
  
  noStroke();
  for(int i = 0; i < arr.length; i++){
    // colors...
    float scale = 1.0*arr[i]/arr.length;
    fill(100*sin(2*PI*scale-2*PI/3)+155, 100*sin(2*PI*scale)+155, 100*sin(2*PI*scale+2*PI/3)+155);
    if(ind == i && !finished)
      fill(255);
    rect(i*wid, 0, wid+gap, 1.0*height*arr[i]/arr.length);
  }
  popMatrix();
}

void drawArrType2(){
  pushMatrix();
  translate(width/2, height/2);
  scale((width-edge*2)/(1.0*width), (-height+edge*2)/(1.0*height));
  rotate(PI/2);
  // draw patterns
  float radius = height/2;
  
  noStroke();
  for(int i = 0; i < arr.length; i++){
    float pos1 = 2*PI*i/arr.length;
    float pos2 = 2*PI*(i+1)/arr.length;
    // colors...
    float scale = 1.0*arr[i]/arr.length;
    fill(100*sin(2*PI*scale-2*PI/3)+155, 100*sin(2*PI*scale)+155, 100*sin(2*PI*scale+2*PI/3)+155);
    if(ind == i && !finished)
      fill(255);
    triangle(0, 0, radius*cos(pos1), radius*sin(pos1), radius*cos(pos2), radius*sin(pos2));
  }
  
  popMatrix();
}

void initArr(){
  arr = new int[num];
  for(int i = 0; i < arr.length; i++){
    arr[i] = i+1;
  }
}

void initArr2(){
  arr = new int[num];
  Random rand = new Random();
  for(int i = 0; i < arr.length; i++){
    arr[i] = int(rand.nextFloat()*1000);
  }
}

void setup(){
  size(800, 500);
  //noLoop();
  frameRate(framerate);
  initArr();
  randomize();
  noSmooth();
  background(0);
}

void draw(){
  drawArr(drawType);
  
  switch(sortType){
    case 1:
      for(int i = 0; i < arr.length/2-7; i++){
        stupidInsert();
      }
      break;
    case 2:
      for(int i = 0; i < arr.length/2-7; i++){
        stupidBubble();
      }
      break;
    case 3:
      for(int i = 0; i < arr.length/2-7; i++){
        stupidCocktail();
      }
      break;
    default:
      break;
  }
  
  if(finished){
    drawArr(drawType);
    noLoop();
  }
}

int ind = 0;
int hilim = num - 1;
boolean flag = false;
boolean finished = false;
long cmpCount = 0;

void stupidBubble(){
  if(finished) return;
  if(ind == hilim){
    if(hilim == 0){
      finished = true;
      return;
    }
    else{
      ind = 0;
      flag = false;
      hilim--;
    }
  }
  else{
    cmpCount++;
    if(arr[ind] > arr[ind+1]){
      swapArrElem(ind, ind+1);
    }
    ind++;
  }
}

int lolim = 0;
boolean fr = true;

void stupidCocktail(){
  if(finished || hilim-lolim <= 1){
    finished = true;
    return;
  }
  if(fr && ind == hilim) {
    if(!flag) finished = true;
    flag = false;
    fr = false;
    hilim-=1;
    ind-=1;
  }
  else if(!fr && ind == lolim) {
    if(!flag) finished = true;
    flag = false;
    fr = true;
    lolim+=1;
    ind+=1;
  }
  else{
    cmpCount++;
    if(fr){
      if(arr[ind]>arr[ind+1]) {
        flag = true;
        swapArrElem(ind, ind+1);
      }
      ind++;
    }
    else{
      if(arr[ind]<arr[ind-1]) {
        flag = true;
        swapArrElem(ind, ind-1);
      }
      ind--;
    }
    return;
  }
}


int minInd = 0;
void stupidInsert(){
  if(lolim == arr.length-1){
    finished = true;
    return;
  }
  else{
    if(ind == arr.length){
      swapArrElem(lolim, minInd);
      lolim++;
      ind = lolim;
      minInd = ind;
    }
    else{
      cmpCount++;
      if(arr[ind] < arr[minInd]) minInd = ind;
      ind++;
    }
  }
}