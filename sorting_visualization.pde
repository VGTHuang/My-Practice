import java.util.*;

final int drawType = 1;
final int sortType = 7;

final int shuffleType = 4;

final int delayTime = 1;
final int delayGap = 30;

final int num = 500;
final int edge = 15;
final float gap = 0.1;

int[] arr;

void swapArrElem(int i, int j){
  int temp = arr[i];
  arr[i] = arr[j];
  arr[j] = temp;
}

void shuffleArr(){
  switch(shuffleType){
    case 1:
    randomizeArr();
    break;
    case 2:
    slightRandomizeArr();
    break;
    case 3:
    reverseArr();
    break;
    case 4:
    shiftArr();
    break;
    default:
    break;
  }
  delay(1000);
}

void randomizeArr(){
  Random rand = new Random();
  for(int i = 0; i < arr.length; i++){
    delay(delayTime);
    int randPos = rand.nextInt(arr.length);
    swapArrElem(i, randPos);
  }
}

void slightRandomizeArr(){
  Random rand = new Random();
  for(int i = 0; i < arr.length/10; i++){
    int randPos1 = rand.nextInt(arr.length);
    int randPos2 = rand.nextInt(arr.length);
    swapArrElem(randPos1, randPos2);
  }
}

void reverseArr(){
  for(int i = 0; i < arr.length/2; i++){
    swapArrElem(i, arr.length-1-i);
  }
}

void shiftArr(){
  reverseArr();
  int piv = arr.length/100;
  for(int i = 0; i <= piv/2; i++){
    swapArrElem(i, piv-i);
  }
  for(int i = 0; i < (arr.length-piv-1)/2; i++){
    swapArrElem(i+piv+1, arr.length-1-i);
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
    case 5:
    thread("merge");
    break;
    case 6:
    thread("fast");
    break;
    case 7:
    thread("heap");
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
  shuffleArr();
  ind = 0;
  int hi = arr.length - 1;
  boolean flag;
  while(hi != 0){
    flag = false;
    for(ind = 0; ind < hi; ind++){
      if(cmpCount%delayGap == 0) delay(delayTime);
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
  shuffleArr();
  ind = 0;
  int hi = arr.length - 1;
  int minInd;
  while(hi != 0){
    minInd = 0;
    for(ind = 0; ind <= hi; ind++){
      if(cmpCount%delayGap == 0) delay(delayTime);
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
  if(from >= arr.length) return;
  else if(to >= arr.length) to = arr.length-1;
  int minInd;
  while(to != from){
    minInd = from;
    for(ind = from; ind <= to; ind++){
      if(cmpCount%delayGap == 0) delay(delayTime);
      cmpCount++;
      if(arr[ind] > arr[minInd]) minInd = ind;
    }
    swapArrElem(minInd, to);
    to--;
  }
  return;
}

void cocktail(){
  shuffleArr();
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
      if(cmpCount%delayGap == 0) delay(delayTime);
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
  finished = true;
  return;
}

int[] ciura = {1, 4, 10, 23, 57, 132, 301, 701};

void shell(){
  shuffleArr();
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
          if(cmpCount%delayGap == 0) delay(delayTime);
          if(arr[ind] < arr[minInd]) minInd = ind;
        }
        swapArrElem(minInd, lo);
        lo += gap;
      }
    }
    gapnum--;
  }
  
  lo = 0;
  while(lo < arr.length){
    minInd = lo;
    for(ind = lo; ind < lo + 10 && ind < arr.length; ind ++){
      cmpCount++;
      if(cmpCount%delayGap == 0) delay(delayTime);
      if(arr[ind] < arr[minInd]) minInd = ind;
    }
    swapArrElem(minInd, lo);
    lo++;
  }
  
  
  finished = true;
  return;
}

void merge(){
  shuffleArr();
  int[] store = new int[arr.length];
  mergeSub(0, arr.length-1, store);
  finished = true;
  return;
}

void mergeSub(int lo, int hi, int[] store){
  if(hi - lo < 1) return;
  else{
    int mid = (hi + lo) / 2;
    mergeSub(lo, mid, store);
    mergeSub(mid+1, hi, store);
    int arr1 = lo, arr2 = mid+1, arr3 = lo;
    while(arr1 <= mid && arr2 <= hi){
      cmpCount++;
      if(arr[arr1] < arr[arr2])
        store[arr3++] = arr[arr1++];
      else
        store[arr3++] = arr[arr2++];
    }
    while(arr1 <= mid)
      store[arr3++] = arr[arr1++];
    while(arr2 <= hi)
      store[arr3++] = arr[arr2++];
    for(int i = lo; i <= hi; i++){
      ind = i;
      delay(delayTime);
      arr[i] = store[i];
    }
    return;
  }
}

void fast(){
  shuffleArr();
  fastRec(0, arr.length-1);
  finished = true;
  return;
}

void fastRec(int lo, int hi){
  if(hi - lo <= 0) return;
  
  // get piv
  if(arr[lo] > arr[hi]){
    if(arr[lo] > arr[(lo+hi)/2]){
      if(arr[(lo+hi)/2] > arr[hi]) swapArrElem(lo, (lo+hi)/2);
      else swapArrElem(lo, hi);
    }
  }
  else{
    if(arr[lo] < arr[(lo+hi)/2]){
      if(arr[(lo+hi)/2] < arr[hi]) swapArrElem(lo, (lo+hi)/2);
      else swapArrElem(lo, hi);
    }
  }
  
  int piv = arr[lo];
  int loarr = lo, hiarr = hi;
  while(loarr < hiarr){
    while(loarr < hiarr && arr[hiarr] >= piv){
      cmpCount++;
      delay(delayTime);
      ind = hiarr;
      hiarr--;
    }
    arr[loarr] = arr[hiarr];
    
    while(loarr < hiarr && arr[loarr] <= piv){
      cmpCount++;
      delay(delayTime);
      ind = loarr;
      loarr++;
    }
    arr[hiarr] = arr[loarr];
  }
  arr[loarr] = piv;
  fastRec(lo, loarr-1);
  fastRec(loarr+1, hi);
}


void heapRec(int par, int hi){
  if(2*(par+1)-1 > hi) return;
  if(2*(par+1)-1 == hi){
    ind = par;
    cmpCount++;
    delay(delayTime);
    if(arr[2*(par+1)-1] < arr[par]){
      swapArrElem(2*(par+1)-1, par);
    }
    return;
  }
  else{
    ind = par;
    cmpCount++;
    delay(delayTime);
    if(arr[2*(par+1)-1] > arr[par] && arr[2*(par+1)-1] > arr[2*(par+1)]){
      swapArrElem(2*(par+1)-1, par);
      heapRec(2*(par+1)-1, hi);
    }
    else if(arr[2*(par+1)] > arr[par] && arr[2*(par+1)] > arr[2*(par+1)-1]){
      swapArrElem(2*(par+1), par);
      heapRec(2*(par+1), hi);
    }
    else return;
  }
}

void heap(){
  shuffleArr();
  // build heap
  for(int i = (arr.length+1)/2-1; i >= 0; i--){
    heapRec(i, arr.length-1);
  }
  
  for(int hi = arr.length-1; hi > 1; hi--){
    swapArrElem(hi, 0);
    heapRec(0, hi-1);
  }
  finished = true;
  return;
}
