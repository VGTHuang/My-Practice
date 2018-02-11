//A simple tetris game; also to get familiar with the concept of class and object.
#include <iostream>
#include <conio.h>
#include <string>
#include <Windows.h>

using namespace std;

const int width = 12, height = 18;
const int initx = width / 2 - 3, inity = -2;
const int point = 10;  //how many points one wins if one line is destroyed
bool game_over = false, game_win = false;
bool kbin = false;
int canvas[width][height] = {0};        //canvas; all static blocks will be copied onto canvas
int gamescore = 0;
enum keyboard{ROTATE, DROP, LEFT, RIGHT};      // corresponding to w, s, a, d
int direction;     // to record keyboard input and pass to logic

class Tetromino{
	string shape;
public:
	int type;
	int x, y;         //global coordinate
	Tetromino(int a) :type(a) { initTet(); }
	void initTet();
	int occupied(int glx, int gly); //use certain GLOBAL coordinate to get occupancy of certain pixel
	int conflict();   //return int type: if not conflict, return 0;
	                  //conflicts with left wall, return 1;
	                  //conflicts with right wall, return 2;
					  //error, return 3;
	                  //conflicts with bottom or static blocks, return -1
	void rotate();
	void moveHorizontal(bool left);
	void moveDown(){
			y++;
	}
	void moveDrop() {
		while (conflict() != -1)
			y++;
		y--;
	}
	void pasteToCanvas();
};

void Tetromino::initTet(){
	x = initx;
	y = inity;                      //initial global coordinate should be at the centre above canvas
	shape.clear();
	switch(type){
	case 1:
		shape.append(".....");
		shape.append("..X..");
		shape.append("..X..");
		shape.append("..X..");
		shape.append("..X..");
		break;
	case 2:
		shape.append(".....");
		shape.append(".....");
		shape.append(".XX..");
		shape.append("..X..");
		shape.append("..X..");
		break;
	case 3:
		shape.append(".....");
		shape.append(".....");
		shape.append("..XX.");
		shape.append("..X..");
		shape.append("..X..");
		break;
	case 4:
		shape.append(".....");
		shape.append(".....");
		shape.append(".XX..");
		shape.append(".XX..");
		shape.append(".....");
		break;
	case 5:
		shape.append(".....");
		shape.append(".....");
		shape.append("..XX.");
		shape.append(".XX..");
		shape.append(".....");
		break;
	case 6:
		shape.append(".....");
		shape.append(".....");
		shape.append(".XX..");
		shape.append("..XX.");
		shape.append(".....");
		break;
	case 7:
		shape.append(".....");
		shape.append(".....");
		shape.append(".XXX.");
		shape.append("..X..");
		shape.append(".....");
		break;
	default:
		break;
	}
}

int Tetromino::occupied(int glx, int gly){
	if (glx < x || gly < y || glx >= x + 5 || gly >= y + 5) return 0; //if glx or gly is outside the boundary of this tetromino, return 0
	if (shape[(glx - x) + 5 * (gly - y)] == 'X') return type;         //this expression converts xy coordinate to array's index
	else return 0;
}

int Tetromino::conflict(){
	int glx, gly;
	for (glx = x; glx < 5 + x; glx++){
		for (gly = y; gly < 5 + y; gly++) {
			if(occupied(glx, gly)){
				if (glx < 0) return 1;
				else if (glx > width-1) return 2;
				else if (canvas[glx][gly]) return -1;
				else if (gly>height-1) return -1;
				else if (glx < -1 || glx > width || gly > height) return 3;  //error case. just to be safe
			}
		}
	}
	return 0;
}

inline void rotative_swap(string& s, int a, int b, int c, int d){
	char temp;
	temp = s[d];
	s[d] = s[c];
	s[c] = s[b];
	s[b] = s[a];
	s[a] = temp;
}

void Tetromino::rotate(){
	if (type == 4) return;  //if the tetromino is "O" type then no need to rotate (central symmetry)
	rotative_swap(shape, 0, 4, 24, 20);
	rotative_swap(shape, 1, 9, 23, 15);
	rotative_swap(shape, 2, 14, 22, 10);
	rotative_swap(shape, 3, 19, 21, 5);
	rotative_swap(shape, 6, 8, 18, 16);
	rotative_swap(shape, 7, 13, 17, 11);
	while (conflict() == 1) x++;   //if totation causes conflict with the wall, then move left/right
	while (conflict() == 2) x--;
	return;
}

void Tetromino::moveHorizontal(bool left){     //horizontal move, until conflict with either wall
	if(left){
		x--;
		if (conflict())
			x++;
		return;
	}
	else{
		x++;
		if (conflict())
			x--;
		return;
	}
}

void Tetromino::pasteToCanvas() {          //when a tetromino becomes static
	int glx, gly;
	for (glx = x; glx < 5 + x; glx++) {
		for (gly = y; gly < 5 + y; gly++) {
			if (occupied(glx, gly))
				canvas[glx][gly] = type;
		}
	}
}

void Draw(Tetromino& tet){
	system("cls");
	int x, y;
	for (y = 0; y < height; y++) {
		cout << "              #";
		for (x = 0; x < width; x++) {
			//draw canvas:
			if (canvas[x][y]) {
				cout << (char)(canvas[x][y] + 64);
			}
			//draw tetromino:
			else if (tet.occupied(x, y) != 0)
				cout << (char)(tet.type + 64);
			//draw space
			else {
				cout << ' ';
			}
		}
		cout << "#\n";
	}
	cout << "              ";
	for (x = 0; x < width + 2; x++)
		cout << "#";
	cout << endl << "\n              Score: " << gamescore << endl;
}

void Input(){
	switch(_getch()){
	case 'a':
		direction = LEFT;
		break;
	case 'd':
		direction = RIGHT;
		break;
	case 'w':
		direction = ROTATE;
		break;
	case 's':
		direction = DROP;
		break;
	}
	return;
}

void Logic(Tetromino& tet){
	switch (direction)
	{
	case LEFT:
		tet.moveHorizontal(true);
		break;
	case RIGHT:
		tet.moveHorizontal(false);
		break;
	case ROTATE:
		tet.rotate();
		break;
	case DROP:               //becomes static when dropped, and the same memory space is reused for next tet
		tet.moveDrop();
		tet.pasteToCanvas();
		tet.type = rand() % 7 + 1;
		tet.initTet();
		break;
	default:
		break;
	}
}

void CheckLine(void){
	int x, y = height - 1;
	bool full;
	while (y >= 0) {
		full = true;
		for (x = 0; x < width; x++){
			if(!canvas[x][y]){
				full = false;
				break;
			}
		}
		if (full) {      // if this row is full, then move ALL blocks above and at this row 1 block downwards
			gamescore += point;  //one line is destroyed, add this many points to gamescore
			int tempy;
			for (x = 0; x < width; x++) {
				for (tempy = y; tempy > 0; tempy--)
					canvas[x][tempy] = canvas[x][tempy - 1];
			}
			for (x = 0; x < width; x++)   //set the uppermost row to 0
				canvas[x][0] = 0;
			full = true;  //check the new line again, if still full, then another move is needed
			for (x = 0; x < width; x++) {
				if (!canvas[x][y]) {
					full = false;
					break;
				}
			}
			if (!full) y--;
		}
		else
			y--;
	}
}

void CheckOver(void){
	int x;
	for (x = 0; x < width; x++){
		if(canvas[x][0]){
			game_over = true;
			return;
		}
	}
	return;
}

void CheckWin(void){   //highly improbable case: all blocks are destroyed
	int x, y;
	for (y = height-1; y >= 0; y--){
		for (x = 0; x < width; x++){
			if (canvas[x][y]) {
				return;
			}
		}
	}
	game_win = true;
	return;
}

int main(){
	srand(1);
	Tetromino current_tet(rand() % 7 + 1);
	current_tet.rotate();
	Draw(current_tet);
	unsigned int timelapse = 0;
	while(!game_over && !game_win){
		Sleep(1);
		timelapse = (timelapse + 1) % 350;  //falling speed. fall one block every ~350 ms
		if (timelapse == 0) {
			current_tet.y++;
			if (current_tet.conflict() == -1) {  //unable to fall further
				current_tet.y--;
				current_tet.pasteToCanvas();
				current_tet.type = rand() % 7 + 1;
				current_tet.initTet();
			}
			Draw(current_tet);
		}
		else {
			if (_kbhit()) {
				Input();
				Logic(current_tet);
				Draw(current_tet);
			}
		}
		CheckLine();   //is any line full?
		CheckOver();   //hava static blocks reached the top?
	}
	system("cls");
	if (game_over) cout << "GAME OVER\nSCORE = " << gamescore << endl;
	else cout << "YOU WIN\n";

	string end;
	getline(cin, end);
	return 0;
}
