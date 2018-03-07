#include <iostream>
#include <string>
#include <map>
#include "myhead.h"

syllables::syllables() {
	_vowel_freq_total = 0;
	_consonant_freq_total = 0;
	_atom_freq_total = 0;
}

void syllables::push_word(std::string word) {
	if (word.length() > MAX_WORD_LENGTH || word.length() <= 0) return;

	else if (word.length() == 1) {  //a one-letter word
		_atom_freq_total++;
		_atom_freq[1]++;
		std::map<std::string, int>::iterator it;
		it = _one_letter.find(word);
		if (it == _one_letter.end()) { ////this word hasn't been recorded
			_one_letter.insert(std::pair<std::string, int>(word, 1));
		}
		else
			it->second++;
		return;
	}
	//a multi-letter word
	_atom_freq_total++;
	int pos = 0, len, atomcount = 0;
	std::string atom;
	std::map<std::string, atomproperty>::iterator it;
	while (pos < word.length()) {
		atomcount++;     //count the total atoms in this word
						 //get a substring that is either a vowel atom or consonant atom
		for (len = 1; pos + len < word.length() && (isvowel(word[pos]) == isvowel(word[pos + len])); len++);
		atom = word.substr(pos, len);

		isvowel(atom[0]) ? _vowel_freq_total++ : _consonant_freq_total++;

		//if this atom is at the beginning of word
		if (pos == 0) {
			if (isvowel(atom[0])) {  //it's a vowel atom
				it = _vowels.find(atom);
				if (it == _vowels.end()) { //this atom hasn't been recorded
					_vowels.insert(std::pair<std::string, atomproperty>(atom, atomproperty(true, false)));
				}
				else {  //this atom has been recorded
					it->second.freq++;  //found again
					it->second.havefirst = true;  //this time it's found in the beginning
				}
			}
			else {  //is a consonant atom
				it = _consonants.find(atom);
				if (it == _consonants.end()) { //this atom hasn't been recorded
					_consonants.insert(std::pair<std::string, atomproperty>(atom, atomproperty(true, false)));
				}
				else {  //this atom has been recorded
					it->second.freq++;  //found again
					it->second.havefirst = true;  //this time it's found in the beginning
				}
			}
		}

		//if this atom is at the end of word (i.e. "tr" barely appears at the end of an English word)
		else if (pos + len >= word.length()) {
			if (isvowel(atom[0])) {  //it's a vowel atom
				it = _vowels.find(atom);
				if (it == _vowels.end()) { //this atom hasn't been recorded
					_vowels.insert(std::pair<std::string, atomproperty>(atom, atomproperty(false, true)));
				}
				else {  //this atom has been recorded
					it->second.freq++;  //found again
					it->second.havelast = true;  //this time it's found at the end
				}
			}
			else {  //is a consonant atom
				it = _consonants.find(atom);
				if (it == _consonants.end()) { //this atom hasn't been recorded
					_consonants.insert(std::pair<std::string, atomproperty>(atom, atomproperty(false, true)));
				}
				else {  //this atom has been recorded
					it->second.freq++;  //found again
					it->second.havelast = true;  //this time it's found at the end
				}
			}
		}

		//if this atom is in the middle
		else {
			if (isvowel(atom[0])) {  //it's a vowel atom
				it = _vowels.find(atom);
				if (it == _vowels.end()) { //this atom hasn't been recorded
					_vowels.insert(std::pair<std::string, atomproperty>(atom, atomproperty(false, false)));
				}
				else {  //this atom has been recorded
					it->second.freq++;  //found again
				}
			}
			else {  //is a consonant atom
				it = _consonants.find(atom);
				if (it == _consonants.end()) { //this atom hasn't been recorded
					_consonants.insert(std::pair<std::string, atomproperty>(atom, atomproperty(false, false)));
				}
				else {  //this atom has been recorded
					it->second.freq++;  //found again
				}
			}
		}
		pos += len;
	}
	_atom_freq[atomcount]++;
}

int syllables::get_rand_length(void) const {
	int i = rand() % _atom_freq_total + 1, sum = 0, wordlen;
	for (wordlen = 1; wordlen <= MAX_ATOM && sum + _atom_freq[wordlen] < i; sum += _atom_freq[wordlen], wordlen++);
	return wordlen;
}

std::map<std::string, atomproperty>::const_iterator syllables::rand_getvowel() const {
	int i = rand() % _vowel_freq_total + 1, sum = 0;
	std::map<std::string, atomproperty>::const_iterator it;
	for (it = _vowels.begin(); it != _vowels.end() && sum + it->second.freq < i; sum += it->second.freq, it++);
	return it;
}

std::map<std::string, atomproperty>::const_iterator syllables::rand_getconsonant() const {
	int i = rand() % _consonant_freq_total + 1, sum = 0;
	std::map<std::string, atomproperty>::const_iterator it;
	for (it = _consonants.begin(); it != _consonants.end() && sum + it->second.freq < i; sum += it->second.freq, it++);
	return it;
}

std::string syllables::make_word(int atoms) const {
	if (atoms < 1) {
		return "Word length input error!\n";
	}
	if (atoms == 1) {
		int i = rand() % _atom_freq[1] + 1, sum = 0;
		std::map<std::string, int>::const_iterator it;
		for (it = _one_letter.begin(); it != _one_letter.end() && sum + it->second < i; sum += it->second, it++);
		if (it == _one_letter.end()) return _one_letter.begin()->first;
		else return it->first;
	}

	std::string word;
	std::map<std::string, atomproperty>::const_iterator tempit;
	for (int i = 0; i < atoms; i++) { //get a consonant
		if (i % 2 == 0) {
			if (i == 0) { //first atom
				tempit = rand_getconsonant();
				while (!tempit->second.havefirst) { tempit = rand_getconsonant(); }
			}
			else if (i == atoms - 1) {  //last atom
				tempit = rand_getconsonant();
				while (!tempit->second.havelast) { tempit = rand_getconsonant(); }
			}
			else
				tempit = rand_getconsonant();
			word.append(tempit->first);
		}
		if (i % 2 == 1) {
			if (i == atoms - 1) {  //last atom
				tempit = rand_getvowel();
				while (!tempit->second.havelast) { tempit = rand_getvowel(); }
			}
			else
				tempit = rand_getvowel();
			word.append(tempit->first);
		}
	}
	return word;
}


void syllables::print_syllable_content(void) {
	std::cout << "\nTotal word count: " << _atom_freq_total << std::endl;
	for (int i = 1; i <= MAX_ATOM; i++)
		std::cout << _atom_freq[i] << " word(s) with the atom length of " << i << std::endl;

	std::cout << "Vowels:" << _vowel_freq_total << "\n";
	for (std::map<std::string, atomproperty>::iterator i = _vowels.begin(); i != _vowels.end(); i++) {
		std::cout << i->first << ' ' << i->second.freq << ' ' << i->second.havefirst << ' ' << i->second.havelast << std::endl;
	}
	std::cout << "Consonants:" << _consonant_freq_total << "\n";
	for (std::map<std::string, atomproperty>::iterator i = _consonants.begin(); i != _consonants.end(); i++) {
		std::cout << i->first << ' ' << i->second.freq << ' ' << i->second.havefirst << ' ' << i->second.havelast << std::endl;
	}
}