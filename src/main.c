
#include <stdio.h>

#include "a/a-1.h"
#include "a/a-2.h"
#include "a/a-3/a-3.h"
#include "b/b-1.h"
#include "b/b-2.h"
#include "b/c/c-1.h"

int main()
{
    printf("main\n");
    
    a_1();
    a_2();
    a_3();
    b_1();
    b_2();
    c_1();
    
    return 0;
}
