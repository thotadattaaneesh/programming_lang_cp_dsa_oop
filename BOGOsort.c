#include<stdbool.h>
#include<time.h>
#include<stdio.h>
#include<stdlib.h>
#include<math.h>

bool notsorted(int a[],int n)
{
    while (--n >=(1))
        if (a[n]<a[n - 1])
            return false;
    return true;
}
void shuffle(int a[],int n)
{
    int i,t,j;
    for (i=0;i<n;i++)
    {   
        t=a[i];
        j=rand() % n;   
        a[i]=a[j];
        a[j]=t;
    }
}
void BOGO(int a[], int n) 
{ 
    while (!notsorted(a,n)) 
        shuffle(a,n);       
} 
int main(){
    int n;
    printf("                BOGO SORT \n");
    printf("Enter how many values should the array consist of: \n");
    printf("Size :");
    scanf("%d",&n);
    int a[n],b[n];
    srand(time(0));
    double t2=0.0;
    printf("Enter the elements of the array: \n");
    for(int i=0;i<n;i++)
    scanf("%d",&a[i]);
    printf("\n");
    float c[100];
     double time=0.0;    
        for(int i=0;i<n;i++)
        {
            b[i]=a[i];
        }
        clock_t start = clock();    
        BOGO(b,n);
        clock_t end = clock();
        time=(double)(end - start)/CLOCKS_PER_SEC;
      
    printf("\n");
    printf("The sorted array is: \n");
    for(int i=0;i<n;i++){
        printf("%d ",b[i]);
    }
    printf("\n");
    printf("The total run time of algorithmm is: %f\n",time);
} 
