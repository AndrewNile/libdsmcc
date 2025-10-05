#ifndef DSMCCWIN32_H
#define DSMCCWIN32_H

#ifndef syslog
#define syslog consolelog
#define LOG_ERR 4
#endif



void consolelog(int errLevel, const char *msg);
char* getTempDir(void);

#endif
