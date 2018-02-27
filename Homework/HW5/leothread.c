//Name: Milad Nourian
//UID: 004854226
#include <stdio.h>
#include<pthread.h>
#include <stdlib.h>
typedef struct {
    int n;
    int label;
  int depth;
  //int * depthptr;
}treenode;

/*
 int
 pthread_create (pthread_t *thread_id, const pthread_attr_t *attributes,
 void *(*thread_function)(void *), void *arguments);
 */


/*
 int
 pthread_join (pthread_t thread, void **status_ptr);
 */

void * process_node(void * nodeptr){
    //first cast the ptr
    treenode * treenodeptr = (treenode *)nodeptr;
    //first print value
    
//    int label = (struct treenode*) nodeptr-> label;
    
    //different output formatting depending whether or not the it is a leaf node
    
    if (treenodeptr-> n == 0 || treenodeptr-> n == 1){ //leaf node processing
        printf("[%d]\n",treenodeptr->label);
        //void *malloc(size_t size);
    //    int * ptr = malloc(sizeof(int));
	//        *(treenodeptr -> depthptr) = 1;
        treenodeptr -> depth =1;
	return NULL;}
    printf("(%d\n",treenodeptr->label);

    
    pthread_t threadArr [2]; //we need to run 2 threads
    treenode threadnode1;
    threadnode1.label = treenodeptr -> label + 1;
    threadnode1.n = (treenodeptr -> n) -1;
    pthread_create(&threadArr[0], NULL, process_node, (void *)&threadnode1);
    int left_return_value;
    void * statusptr;
    pthread_join(threadArr[0], &statusptr );
    //left_return_value = *(int *)statusptr;
    left_return_value = (threadnode1.depth);
    
    
    treenode threadnode2;
    threadnode2.label = treenodeptr -> label + 1 + left_return_value;
    threadnode2.n = (treenodeptr -> n) -2;
    pthread_create(&threadArr[1], NULL, process_node, (void *)&threadnode2);
    pthread_join(threadArr[1],  &statusptr);
    //int right_return_value = *(int*) statusptr;

    int right_return_value; 
    right_return_value = (threadnode2.depth);
    
      //at the end also we have output the label
    printf("%d)\n",treenodeptr->label);
    int total = left_return_value + right_return_value + 1;
    //the error is that depthptr can be NULL also
    (treenodeptr -> depth) = total;
        //set it to total
    return NULL;
}


int main(int argc, const char * argv[]) {
    //this is where we get the value
    // insert code here...
    
    if (argc != 2){ //since we need the value n for the fibonacci
        fprintf(stderr, "you have to give one positive integer argument");
    }
    
    //create a left thread and right thread
    //for getting the integer value entered, use atoi
    
    char n = atoi(argv[1]); //now n is the value entered by the user. I am not checking for negative values
    if (n == 0 || n == 1) {
        printf("[0]\n");
        return 0;
    }
    
    printf("(0\n");
    pthread_t threads[2];
    treenode leftThread;
    leftThread.label = 1;
    leftThread.n = n-1;
    pthread_create(&threads[0], NULL, process_node,(void *) &leftThread );
    
    int left_return_value;
    void * statusptr;
    pthread_join(threads[0], &statusptr );
    //left_return_value = *(int *)statusptr;
    left_return_value = (leftThread.depth);
    
    treenode rightThread;
    rightThread.label = 1 + left_return_value;
    rightThread.n = n -2;
    pthread_create(&threads[1], NULL, process_node, (void *)&rightThread);
    pthread_join(threads[1],  &statusptr);
    //int right_return_value = *(int*) statusptr;
//    int right_return_value = *(rightThread.depthptr);
    printf("0)\n");
    
    
    return 0;
}
