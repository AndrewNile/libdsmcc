#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#ifdef _WIN32
#include <windows.h>
#include <userenv.h>
#else
#define MAX_PATH 256
#endif

#include "dsmcc-win32.h"

/* Compatibility functions for Windows */

void consolelog(int errLevel, const char *msg) {
	switch (errLevel) {
		case LOG_ERR:
			printf("ERR: ");
	}

	printf("%s\n", msg);
}


char* getTempDir(void) {
	/* Get the Windows TEMP folder */

	char* tmpPath;
	char* tmpFolder;

#ifdef _WIN32
	tmpFolder = getenv("TEMP");
#endif

	if (tmpFolder == NULL) {
		/* Better than nothing */
		tmpFolder = (char*)malloc(strlen("temp") + 1);
		strcpy(tmpFolder, "temp");
	}

	/* Ensure it doesn't exceed limits */
	tmpPath = (char*)malloc(strlen(tmpFolder) + 1);
	snprintf(tmpPath, MAX_PATH - 1, "%s", tmpFolder);

	free(tmpFolder);
	return tmpPath;
}
