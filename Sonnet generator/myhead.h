#pragma once
#ifndef MYHEAD_H_
#define MYHEAD_H_
#include <string>
#include <array>
#include <map>

const int MAX_ATOM = 20;
const int MAX_WORD_LENGTH = 25;

class atomproperty {
public:
	int freq;
	bool havefirst, havelast;
	atomproperty(bool hf, bool hl) : freq(1), havefirst(hf), havelast(hl) {};
};

class syllables {
private:
	std::map<std::string, atomproperty> _vowels;
	std::map<std::string, atomproperty> _consonants;
	std::map<std::string, int> _one_letter;     //to record all one-letter words
	int _vowel_freq_total;
	int _consonant_freq_total;
	std::array<int, MAX_ATOM + 1> _atom_freq;
	int _atom_freq_total;
public:
	syllables();
	void push_word(std::string s);
	int get_rand_length(void) const;
	std::string make_word(int atoms) const;
	void print_syllable_content(void);
private:
	std::map<std::string, atomproperty>::const_iterator rand_getvowel() const;
	std::map<std::string, atomproperty>::const_iterator rand_getconsonant() const;
};

//readfile
bool isalpha(char& c);
bool isvowel(char& c);
bool readfile(syllables& language_data);
void create_sonnet(const syllables& language_data);

#endif // !MYHEAD_H_
#pragma once
