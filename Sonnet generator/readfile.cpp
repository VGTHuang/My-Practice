#include <iostream>
#include <fstream>
#include <time.h>
#include "myhead.h"

bool isalpha(char& c) {
	return ((c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z') || c == '\'');
}

bool isvowel(char& c) {
	return (c == 'a' || c == 'e' || c == 'i' || c == 'o' || c == 'u');
}

void tolower_overload(char& c) {
	if (c >= 'A' && c <= 'Z') c += 32;
}

void polish_word(std::string& word) {
	std::string::iterator temp = word.begin();
	while (temp != word.end()) {
		if (!isalpha(*temp))
			word.erase(temp);
		else {
			tolower_overload(*temp);
			temp++;
		}
	}
}

bool readfile(syllables& language_data) {  //if file read unsuccessfully return 0
	std::string word;
	std::ifstream f;
	f.open("language pack/chinese pinyin.txt", std::ios::in);
	if (!f) {
		std::cout << "Open file failed!" << std::endl;
		return false;
	}

	while (f >> word) {
		//get a word
		polish_word(word);

		//analyze the word
		if (!word.length());      //word is empty
		else {
			std::cout << word << ' ';
			language_data.push_word(word);
		}
	}
	std::cout << std::endl;
	f.close();

	language_data.print_syllable_content();
	return true;
}

void create_sonnet(const syllables& language_data) {
	srand(time(NULL));
	int linecount, syllablecount, tempatomcount;
	for (linecount = 1; linecount <= 14;) {
		syllablecount = 0;
		while (syllablecount < 9) {
			if (syllablecount > 0) std::cout << ' ';  //space between words
			tempatomcount = language_data.get_rand_length();
			if (tempatomcount == 1) syllablecount++;
			else syllablecount += tempatomcount / 2;
			std::cout << language_data.make_word(tempatomcount);
		}
		switch (linecount) {
		case 1:
			std::cout << ",\n";
			break;
		case 2:
			std::cout << ";\n";
			break;
		case 3:
			std::cout << ",\n";
			break;
		case 4:
			std::cout << ".\n";
			break;
		case 5:
			std::cout << ",\n";
			break;
		case 6:
			std::cout << ";\n";
			break;
		case 7:
			std::cout << ",\n";
			break;
		case 8:
			std::cout << ".\n";
			break;
		case 9:
			std::cout << ",\n";
			break;
		case 10:
			std::cout << ";\n";
			break;
		case 11:
			std::cout << ",\n";
			break;
		case 12:
			std::cout << ".\n";
			break;
		case 13:
			std::cout << ";\n";
			break;
		case 14:
			std::cout << ".\n";
			break;
		default:
			break;
		}
		linecount++;
	}
}