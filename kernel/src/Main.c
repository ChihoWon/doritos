#include "types.h"

void printxy(int x, int y, const char* msg);

void Main(void) {
	printxy(0, 3, "[!] Preparing 64 bits Kernel ...");
	while(1) ;	// halt
}

void printxy(int x, int y, const char* msg) {
	int i;
	vmem* screen = (vmem*) 0xb8000;

	screen += (y * 80) + x;
	for(i = 0; msg[i] != 0; i++) {
		screen[i].ch = msg[i];
	}
}
