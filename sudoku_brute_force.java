import java.util.*;

class Coord{
	public int row, col;
	public Coord(int row, int col) {
		this.row = row;
		this.col = col;
	}
}

class Elem{
	public Coord coord;
	public ArrayList<Integer> nums;
	public Elem(Coord coord) {
		this.coord = coord;
		this.nums = new ArrayList<Integer>();
	}
}

public class Su {

	public int[][] board;
	
	public static void main(String[] args) {
		Su s = new Su();
		s.initialize();
		/*
		// option 1
		s.insert(1, 2, 2);
		s.insert(1, 3, 9);
		s.insert(1, 7, 4);
		s.insert(2, 4, 5);
		s.insert(2, 7, 1);
		s.insert(3, 2, 4);
		s.insert(4, 5, 4);
		s.insert(4, 6, 2);
		s.insert(5, 1, 6);
		s.insert(5, 8, 7);
		s.insert(6, 1, 5);
		s.insert(7, 1, 7);
		s.insert(7, 4, 3);
		s.insert(7, 9, 5);
		s.insert(8, 2, 1);
		s.insert(8, 5, 9);
		s.insert(9, 8, 6);
		*/
		
		/*
		// option 2
		s.insert(1, 1, 5);
		s.insert(1, 2, 3);
		s.insert(1, 5, 7);
		s.insert(2, 1, 6);
		s.insert(2, 4, 1);
		s.insert(2, 5, 9);
		s.insert(2, 6, 5);
		s.insert(3, 2, 9);
		s.insert(3, 3, 8);
		s.insert(3, 8, 6);
		s.insert(4, 1, 8);
		s.insert(4, 5, 6);
		s.insert(4, 9, 3);
		s.insert(5, 1, 4);
		s.insert(5, 4, 8);
		s.insert(5, 6, 3);
		s.insert(5, 9, 1);
		s.insert(6, 1, 7);
		s.insert(6, 5, 2);
		s.insert(6, 9, 6);
		s.insert(7, 2, 6);
		s.insert(7, 7, 2);
		s.insert(7, 8, 8);
		s.insert(8, 4, 4);
		s.insert(8, 5, 1);
		s.insert(8, 6, 9);
		s.insert(8, 9, 5);
		s.insert(9, 5, 8);
		s.insert(9, 8, 7);
		s.insert(9, 9, 9);
		*/
		s.printBoard();

		s.solve();
		
		s.printBoard();
    
	}
	

	private void initialize() {
		board = new int[10][10];
	}
	
	private void printBoard() {
		for(int i = 1; i <= 9; i++) {
			for(int j = 1; j <= 9; j++) {
				System.out.print(board[i][j] == 0? "-":board[i][j]);
				if(j%3 == 0 && j !=9)
					System.out.print(" | ");
				else
					System.out.print(" ");
			}
			System.out.println();
			if(i%3 == 0 && i != 9)
				System.out.println("------+-------+------");
		}
	}
	
	private void insert(int row, int col, int num) {
		if(row < 1 || row > 9 || col < 1 || col > 9 || num < 1 || num > 9)
			return;
		board[row][col] = num;
	}
	
	private boolean legalGrid(int row, int col, int num) {
		int gridR = (row-1)/3;
		int gridC = (col-1)/3;
		for(int i = gridR*3 + 1; i < gridR*3 + 4; i++) {
			for(int j = gridC*3 + 1; j < gridC*3 + 4; j++) {
				if(row != i && col != j) {
					if(num == board[i][j]) return false;
				}
			}
		}
		return true;
	}
	
	private boolean legalRow(int row, int col, int num) {
		for(int j = 1; j <= 9; j++) {
			if(col != j)
				if(num == board[row][j])
					return false;
		}
		return true;
	}
	
	private boolean legalCol(int row, int col, int num) {
		for(int i = 1; i <= 9; i++) {
			if(row != i)
				if(num == board[i][col])
					return false;
		}
		return true;
	}
	
	private boolean isLegal(int row, int col, int num) {
		if(!legalGrid(row, col, num) || !legalRow(row, col, num) || !legalCol(row, col, num))
			return false;
		return true;
	}
	
	private Coord getNext(Coord c) {
		if(c.col == 9 && c.row == 9) return null;
		else if(c.col == 9) return new Coord(c.row + 1, 1);
		else return new Coord(c.row, c.col+1);
	}
	
	private Coord getNextCoord(Coord c) {
		Coord temp = getNext(c);
		while(temp != null && board[temp.row][temp.col] != 0)
			temp = getNext(temp);
		return temp;
	}
	
	public void solve() {
		ArrayList<Elem> attempt = new ArrayList<Elem>();
		Coord next = new Coord(1, 1);
		if(board[1][1] != 0) next = getNextCoord(next);
		
		int count = 0;
		while(next != null && count < 200000000) {
			count++;
			System.out.print(next.row + " " + next.col + " " + attempt.size());
			if(board[next.row][next.col] == 0) {  // if this elem hasn't been filled yet
				Elem nextElem = new Elem(next);
				for(int n = 1; n <= 9; n++) {
					if(isLegal(next.row, next.col, n)) {
						nextElem.nums.add(n);
					}
				}
				
				if(nextElem.nums.isEmpty()) {  // no legal numbers, impossible to solve the new elem
					Elem lastElem = attempt.get(attempt.size()-1);
					lastElem.nums.remove(0);
					next = lastElem.coord;
					System.out.println(" case 1");
				}
				
				else {	// has at least 1 legal number
					attempt.add(nextElem);
					board[next.row][next.col] = nextElem.nums.get(0);
					next = getNextCoord(next);
					System.out.println(" case 2");
				}
			}
			
			else {  // if elem at "next" position is filled
				Elem lastElem = attempt.get(attempt.size()-1);

				if(!lastElem.nums.isEmpty())
					lastElem.nums.remove(0);
				
				if(lastElem.nums.isEmpty()) {
					board[next.row][next.col] = 0;
					attempt.remove(lastElem);
					if(attempt.isEmpty()) {  // board is impossible to solve
						System.out.println("impossible to solve");
						return;
					}
					lastElem = attempt.get(attempt.size()-1);
					next = lastElem.coord;
					System.out.println(" case 3");
				}
				else {
					board[next.row][next.col] = lastElem.nums.get(0);
					next = getNextCoord(next);
					System.out.println(" case 4");
				}
			}
		}
	}
}
