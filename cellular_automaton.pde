final short cellnum = 50;

class Cell{
  short live = 0;
  short lifespan = 0;
  short nextFrame = 0;
  short x, y;
  
  public Cell(short x, short y){
    this.x = x;
    this.y = y;
  }
  
  void drawCell(){
    int r = width / cellnum;
    
    lifespan *= live;
    lifespan += live;
    float col = 150 * log(lifespan + 1) + 30;
    fill(col);
    rect(this.x*r, this.y*r, r, r);
    this.live = this.nextFrame;
  }
}

Cell[][] cells;

void gameOfLifeUpdate(){
  for(short i = 1; i < cellnum-1; i++){
    for(short j = 1; j < cellnum-1; j++){
      
      // neighbours
      int count = 0;
      count += cells[i-1][j-1].live;
      count += cells[i-1][j].live;
      count += cells[i-1][j+1].live;
      count += cells[i][j-1].live;
      count += cells[i][j].live;
      count += cells[i][j+1].live;
      count += cells[i+1][j-1].live;
      count += cells[i+1][j].live;
      count += cells[i+1][j+1].live;
      
      if(count == 3 || count == 4)
        cells[i][j].nextFrame = 1;
      else
        cells[i][j].nextFrame = 0;
      
    }
  }
}

void gameOfLifeUpdate1(){
  for(short i = 0; i < cellnum; i++){
    for(short j = 0; j < cellnum; j++){
      Cell thisCell = cells[i][j];
      if(thisCell.live == 1) thisCell.nextFrame = 0;
      else thisCell.nextFrame = 1;
    }
  }
}

void drawAllCells(){
  for(short i = 0; i < cellnum; i++){
    for(short j = 0; j < cellnum; j++){
      cells[i][j].drawCell();
    }
  }
}

void setup(){
  size(300, 300);
  frameRate(6);
  cells = new Cell[cellnum][];
  for(short i = 0; i < cellnum; i++){
    cells[i] = new Cell[cellnum];
    for(short j = 0; j < cellnum; j++){
      cells[i][j] = new Cell(i, j);
    }
  }
  
  for(short i = 23; i < 28; i++){
    for(short j = 23; j < 25; j++){
      if(random(1) > 0.2)
        cells[i][j].live = 1;
    }
  }
}

void draw(){
  gameOfLifeUpdate();
  drawAllCells();
}
