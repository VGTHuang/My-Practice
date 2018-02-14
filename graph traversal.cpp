//BFS, DFS of a digraph
/*
for testing:
10 vertices, 17 paths
0 1 14
1 2 32
1 3 41
2 3 19
2 4 9
3 4 22
2 5 50
5 4 28
5 6 17
5 7 34
7 8 43
4 6 22
6 8 18
6 9 23
9 8 30
3 9 20
0 3 14
*/
#include <iostream>
#include <vector>
#include<queue>

using namespace std;

class diGraph {
	struct path {
		int destination;
		int value;
	};
	unsigned int vernum, pathnum;     //number of vertices; number of paths
	vector<vector<path>> map;         //to store paths
	vector<bool> vervisited;          //to mark whether certain vertice is visited
public:
	diGraph(int ver) : vernum(ver) {
		map.swap(vector<vector<path>>(vernum));
		vervisited.swap(vector<bool>(vernum, false));
	}
	void Initgraph(void);
	void Printgraph(void);
	bool Findpath(int from, int to, path& temppath);
	void BFS(int ver);
	void DFS(int ver);
};

void diGraph::Initgraph() {
	cout << "How many paths?\n";
	cin >> pathnum;
	int i, from, to, distance;
	path temppath;
	for (i = 0; i < pathnum; i++) {
		cout << "Get path " << i << ": (from/to/distance)\n";
		cin >> from >> to >> distance;
		temppath.destination = to;
		temppath.value = distance;
		map[from].push_back(temppath);
	}
}

void diGraph::Printgraph() {
	cout << "This graph has " << vernum << " vertices, " << pathnum << " paths\n";
	unsigned int i, j;
	for (i = 0; i < vernum; i++) {
		for (j = 0; j < map[i].size(); j++) {
			cout << "from " << i << "to " << map[i][j].destination << ", the distance is " << map[i][j].value << "\n";
		}
	}
}

bool diGraph::Findpath(int from, int to, path& temppath) {
	unsigned int i;
	bool found = false;
	for (i = 0; i < map[from].size(); i++)
		if (map[from][i].destination == to) {
			temppath = map[from][i];
			found = true;
			break;
		}
	return found;
}

void diGraph::BFS(int ver) {
	unsigned int i;
	queue<int> sequence;
	sequence.push(ver);
	vervisited[ver] = true;
	while (sequence.size()) {    //while sequence is not empty
		cout << sequence.front() << endl;
		for (i = 0; i < map[sequence.front()].size(); i++) {
			if (!vervisited[map[sequence.front()][i].destination]) {
				sequence.push(map[sequence.front()][i].destination);
				vervisited[map[sequence.front()][i].destination] = true;
			}
		}
		sequence.pop();
	}
	return;
}

void diGraph::DFS(int ver) {
	unsigned int i;
	cout << ver << endl;
	vervisited[ver] = true;
	bool end = true;  //all its destinations have been visited?
	for (i = 0; i < map[ver].size(); i++) {
		if (!vervisited[map[ver][i].destination]) {
			end = false;
			break;
		}
	}
	if (end) {
		return;
	}
	else {
		for (i = 0; i < map[ver].size(); i++) {
			if (!vervisited[map[ver][i].destination]) {
				vervisited[map[ver][i].destination] = true;
				DFS(map[ver][i].destination);
			}
		}
	}
}

int main() {
	diGraph HZ(10);
	HZ.Initgraph();
	HZ.Printgraph();
	HZ.DFS(0);

	return 0;
}