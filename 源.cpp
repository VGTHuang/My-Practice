#include <iostream>
#include <cstdio>
#include <limits>

using namespace std;

const int linelen = 10;
const unsigned long long int max = 10000000;

void collatz_output(const unsigned long long int a) {
	unsigned long long int temp = a, count = 0;
	printf("%10lld ", temp);
	while (temp != 1) {
		count++;
		if (count%linelen == 0)
			printf("\n");
		if (temp % 2) temp = 3 * temp + 1;
		else temp /= 2;
		printf("%10lld ", temp);
	}
	cout << endl;
}

unsigned long long int collatz_count(const unsigned long long int a) {
	unsigned long long int temp = a, count = 0;
	while (temp != 1) {
		count++;
		if (temp % 2) temp = 3 * temp + 1;
		else temp /= 2;
		if (temp > numeric_limits<unsigned long long int>::max())
			return -1;        //overflow
	}
	return count;
}

int main() {
	unsigned long long int i, maxnum, maxcount = 0, currentcount;
	
	for (i = 1; i < max; i++) {
		currentcount = collatz_count(i);
		if (currentcount == -1) break;
		if (currentcount > maxcount) {
			maxnum = i;
			maxcount = currentcount;
		}
	}
	if (currentcount == -1) {
		cout << "Too large, can't compute\n";
	}
	else {
		cout <<"Num with maximum steps to reach 1 is: "<< maxnum << endl;
		collatz_output(maxnum);
	}
	
	return 0;
}