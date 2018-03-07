#include "myhead.h"

syllables language_data;

int main() {
	if (readfile(language_data))
		create_sonnet(language_data);
	return 0;
}