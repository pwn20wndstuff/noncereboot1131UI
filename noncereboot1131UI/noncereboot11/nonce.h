#pragma once

#define RAWLOG(fmt, args...)\
fprintf(stderr, fmt, ##args);

#define INFO(fmt, args...)\
RAWLOG("[INF]" fmt "\n", ##args);

#define DEBUG(fmt, args...)\
RAWLOG("[DBG] " fmt "\n", ##args);

#define ERROR(fmt, args...)\
RAWLOG("[ERR] " fmt "\n", ##args);

int setgen(const char*);
char* getgen(void);
int delgen(void);

