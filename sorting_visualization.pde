import java.util.*;

final int drawType = 2;
final int sortType = 4;

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
  frameRate(30);
  initArr();
  randomize();
  noSmooth();
  background(0);
  switch(sortType){
    case 1:
    thread("bubble");
    break;
    case 2:
    thread("insertion");
    break;
    case 3:
    thread("cocktail");
    break;
    case 4:
    thread("shell");
    break;
    default:
    thread("bubble");
    break;
  }
  
}

void draw(){
  drawArr(drawType);
  
  if(finished){
    drawArr(drawType);
    noLoop();
  }
}

int ind = 0;
boolean finished = false;
long cmpCount = 0;

void bubble(){
  ind = 0;
  int hi = arr.length - 1;
  boolean flag;
  while(hi != 0){
    flag = false;
    for(ind = 0; ind < hi; ind++){
      if(cmpCount%(num/30) == 0) delay(1);
      cmpCount++;
      if(arr[ind] > arr[ind+1]){
        swapArrElem(ind, ind+1);
        flag = true;
      }
    }
    if(!flag){
      finished = true;
      return;
    }
    hi--;
  }
  finished = true;
  return;
}

void insertion(){
  ind = 0;
  int hi = arr.length - 1;
  int minInd;
  while(hi != 0){
    minInd = 0;
    for(ind = 0; ind <= hi; ind++){
      if(cmpCount%(num/30) == 0) delay(1);
      cmpCount++;
      if(arr[ind] > arr[minInd]) minInd = ind;
    }
    swapArrElem(minInd, hi);
    hi--;
  }
  finished = true;
  return;
}

void insertionRange(int from, int to){
  int minInd;
  while(to != from){
    minInd = from;
    for(ind = from; ind <= to; ind++){
      if(cmpCount%(num/30) == 0) delay(1);
      cmpCount++;
      if(arr[ind] > arr[minInd]) minInd = ind;
    }
    swapArrElem(minInd, to);
    to--;
  }
  return;
}

void cocktail(){
  ind = 0;
  boolean fr = true, flag = true;
  int lo = 0, hi = arr.length - 1;
  while(hi - lo >= 1){
    if(ind == hi && fr || ind == lo && !fr){
      fr = !fr;
      if(ind == hi){
        hi--;
        ind--;
      }
      else{
        lo++;
        ind++;
      }
      if(!flag){
        finished = true;
        return;
      }
      flag = false;
    }
    else{
      cmpCount++;
      if(cmpCount%(num/30) == 0) delay(1);
      if(fr){
        if(arr[ind] > arr[ind+1]){
          swapArrElem(ind, ind+1);
          flag = true;
        }
        ind++;
      }
      else{
        if(arr[ind] < arr[ind-1]){
          swapArrElem(ind, ind-1);
          flag = true;
        }
        ind--;
      }
    }
  }
}

int[] ciura = {1, 4, 10, 23, 57, 132, 301, 701};

void shell(){
  int gapnum;
  for(gapnum = 0; gapnum < ciura.length-1; gapnum++){
    if(ciura[gapnum+1] >= arr.length) break;
  }
  int gap = ciura[gapnum];
  int minInd, lo;
  while(gapnum >= 1){
    gap = ciura[gapnum];
    ind = 0;
    for(int start = 0; start < gap; start++){
      lo = start;
      while(lo < arr.length){
        minInd = lo;
        for(ind = lo; ind < arr.length; ind += gap){
          cmpCount++;
          if(cmpCount%(num/30) == 0) delay(1);
          if(arr[ind] < arr[minInd]) minInd = ind;
        }
        swapArrElem(minInd, lo);
        lo += gap;
      }
    }
    gapnum--;
  }
  for(int i = 0; i+8 < arr.length; i+=1)
    insertionRange(i, i+8);
  finished = true;
  return;
}
