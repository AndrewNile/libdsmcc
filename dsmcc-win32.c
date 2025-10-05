#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <windows.h>
#include <userenv.h>

#include "dsmcc-win32.h"

/* Compatibility functions for Windows */

void consolelog(int errLevel, const char *msg)
{
	switch (errLevel)
	{
		case LOG_ERR:
			printf("ERR: ");
	}

	printf(msg);
	printf("\n");
}

char* getTempDir(void)
{
	/* Get the Windows TEMP folder */
	
	char* tmpPath;
	char* tmpFolder = getenv("TEMP");

	if(tmpFolder == NULL)
	{
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
