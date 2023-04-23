#include <stdio.h>
#include <stdlib.h>

int main() {
	for(;;) {
	char inp[1024];
	printf("input> ");
	fgets(inp, 1024, stdin);
	printf("%s", &inp[0]);
	}

	exit(EXIT_SUCCESS);
}
