#include <stdio.h>
#include <stdint.h>
#include <string.h>
extern void mc_fun(int32_t m1, int32_t n1, int32_t m2, 
int32_t n2, int32_t operation_type, int32_t *matrix1, int32_t *matrix2, 
int32_t *matrix_out);
void get_matrix(FILE *fp, int32_t *matrix, int32_t m, int32_t n);
void display(int32_t *matrix, int32_t m, int32_t n);
void get_m_n(FILE *fp, int32_t *m, int32_t *n);
int32_t get_operation(FILE *fp);
void matrix_multiplication(int32_t *matrix1, int32_t m1, int32_t n1, int32_t *matrix2, int32_t m2, int32_t n2, int32_t * matrix_out);
int main(void){
    FILE *fp = NULL;
    int32_t m1, n1, m2, n2, operation_type;
    int32_t matrix_out[100], matrix1[100], matrix2[100];
    fp = fopen("data3.txt","r");
    if (fp == NULL){
        printf("Blad otwarcia pliku\n");
        return -1;
    }
    operation_type = get_operation(fp);
    if(operation_type == -1){
        printf("Blad pobrania operacji\n");
        fclose(fp);
        return -1;
    }
    //matrix1
    get_m_n(fp , &m1, &n1);
    printf("%d %d\n", m1, n1);
    get_matrix(fp, matrix1, m1, n1);
    display(matrix1, m1, n1);
    //matrix2
    get_m_n(fp, &m2, &n2);
    printf("%d %d\n", m2, n2);
    get_matrix(fp, matrix2, m2, n2);
    display(matrix2, m2, n2);
    printf("%p\n%p\n%p\n",matrix1, matrix2, matrix_out);
    //     rdi,rsi,rdx,rcx, r8             ,r9     ,stack,  ,stack
    mc_fun(m1, n1, m2, n2, operation_type, matrix1, matrix2, matrix_out);
    //display(matrix_out, m1, n1);
    //matrix_multiplication( matrix1,  m1, n1, matrix2, m2, n2, matrix_out);
    if (operation_type == 1 || operation_type == 2){
        display(matrix_out, m1, n1);
    }
    else if(operation_type == 3){
        display(matrix_out, m1, n2);
    }
    else if(operation_type == 4){
        display(matrix_out, m1-1,m1-1);
    }
    
    fclose(fp);
    return 0;
}

void get_m_n(FILE *fp, int32_t *m, int32_t *n){
    fscanf(fp,"%d",m);
    fscanf(fp,"%d",n);
}

void get_matrix(FILE *fp, int32_t *matrix, int32_t m, int32_t n){
    int length = m*n;
    for (int i = 0; i < length; i++){
        fscanf(fp, "%d", matrix + i);
    }
}

void display(int32_t *matrix, int32_t m, int32_t n){
    for (int i = 0; i < m; i++) 
    { 
        for (int j = 0; j < n; j++) 
            printf("  %d", matrix[i*n + j]); 
        printf("\n"); 
    } 
} 

int32_t get_operation(FILE *fp){
    char o[4];
    fscanf(fp, "%s", o);
    if (strcmp(o, "+")==0)
        return 1;
    else if(strcmp(o, "-")==0)
        return 2;
    else if(strcmp(o, "*")==0)
        return 3;
    else if(strcmp(o, "det")==0)
        return 4;
    else
        return -1;
    
    
}

void matrix_multiplication(int32_t *matrix1, int32_t m1, int32_t n1, int32_t *matrix2, int32_t m2, int32_t n2, int32_t * matrix_out){
    if(n1 != m2){
        return;
    }
    int i = 0;
    do{
        int j = 0;
        do{
            int k = 0;
            *(matrix_out + i*m2 + j) = 0;
            do{
                *(matrix_out + i*m2 + j)  += (*(matrix1 +i*m2 +k)) * (*(matrix2 +j +k*m2 ));
                k++;
            }while(k<m2);
            j++;
        }while(j<n2);
        i++;
    }while(i<m1);
}