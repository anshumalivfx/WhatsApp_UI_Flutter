#include "include/lib_main.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>

char *sendMessage(char *uid, char *msg, int len)
{
    char *message = (char *)malloc(len);
    strcpy(message, msg);
    return message;
}