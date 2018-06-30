#pragma once

#define RAWLOG(fmt, args...) fprintf(stderr, fmt, ##args);
#define INFO(fmt, args...) RAWLOG("[INF] " fmt, ##args);
#undef DEBUG
#define DEBUG(fmt, args...) RAWLOG("[DBG] " fmt, ##args);
#define ERROR(fmt, args...) RAWLOG("[ERR] " fmt, ##args);

#include <stdbool.h>

int setgen(const char*);
char* getgen(void);
int delgen(void);
bool dump_apticket(const char *to);

