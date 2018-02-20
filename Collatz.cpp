//Calculate which number below max would take most steps to reach 1 in Collatz conjecture
#include <iostream>
#include <cstdio>
#include <thread>
#include <Windows.h>

const unsigned long long int maxcompute = 9223372036854775806;       //maximum of llu (<limits>)
const int linelen = 8;                                               //output: 8 numbers a line
const unsigned long long int max = 10000000;                         //calculate numbers from 1 to max
const int progress_bar_length = 50;                                  //length of progress bar
unsigned long long int temp = 0;  //a shared variable for both threads (current number being calculated)
unsigned long long int currentnum = 1, maxnum, maxcount = 0, currentcount;
bool calculation_finished = false;

void progress_bar_thread(void) {                //display a progress bar
	double percentage = 0;
	int i, current_bar_length;
	while (calculation_finished == false) {     //when second thread's calculation is unfinished
		Sleep(100);                             //flush every 100 ms
		system("cls");
		percentage = (double)currentnum / (double)max;
		current_bar_length = (int)(percentage * progress_bar_length);
		for (i = 0; i < current_bar_length; i++)
			std::cout << '>';
		for (i = 0; i < progress_bar_length - current_bar_length; i++)
			std::cout << '*';
		printf("\n");
		for (i = 0; i < current_bar_length; i++)
			std::cout << ' ';
		printf("%.1f%%\n", percentage * 100);
	}
	return;
}

void collatz_output(const unsigned long long int a) {
	unsigned long long int count = 0;
	temp = a;
	printf("%12llu ", temp);
	while (temp != 1) {
		count++;
		if (count%linelen == 0)
			printf("\n");
		if (temp % 2) temp = 3 * temp + 1;
		else temp /= 2;
		printf("%12llu ", temp);
	}
	std::cout << std::endl;
}

unsigned long long int collatz_count(const unsigned long long int a) {
	unsigned long long int temp = a, count = 0;
	while (temp != 1) {
		count++;
		if (temp % 2) temp = 3 * temp + 1;
		else temp /= 2;
		if (temp > maxcompute)
			return -1;        //overflow
	}
	return count;
}

void collatz_thread(void) {
	for (currentnum = 1; currentnum <= max; currentnum++) {
		currentcount = collatz_count(currentnum);
		if (currentcount == -1) break;    //overflow detected
		if (currentcount >= maxcount) {
			maxnum = currentnum;
			maxcount = currentcount;
		}
	}
	calculation_finished = true;
}

int main() {
	std::thread first(collatz_thread);
	std::thread second(progress_bar_thread);

	first.join();
	second.join();

	system("cls");
	if (currentcount == -1) {
		std::cout << "Too large, can't compute\n";
	}
	else {
		std::cout <<"Number with maximum steps to reach 1: "<< maxnum << std::endl;
		std::cout << "It takes " << maxcount << " steps" << std::endl;
		collatz_output(maxnum);
	}
	
	return 0;
}
