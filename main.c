#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <ncurses.h>
#define N 3
extern void mc_fun(int32_t m1, int32_t n1, int32_t m2, 
int32_t n2, int32_t operation_type, int32_t *matrix1, int32_t *matrix2, 
int32_t *matrix_out);
void get_matrix(FILE *fp, int32_t *matrix, int32_t m, int32_t n);
void display(int32_t *matrix, int32_t m, int32_t n);
void get_m_n(FILE *fp, int32_t *m, int32_t *n);
int32_t get_operation(FILE *fp);
void matrix_multiplication(int32_t *matrix1, int32_t m1, int32_t n1, int32_t *matrix2, int32_t m2, int32_t n2, int32_t * matrix_out);
int determinantOfMatrix(int* mat, int n);
void getCofactor(int *mat, int *temp, int p, int q, int n) ;
bool display_menu(char * filename);
int main(void){
    FILE *fp = NULL;
    int32_t m1, n1, m2, n2, operation_type;
    int32_t matrix_out[100], matrix1[100], matrix2[100];
    bool loop = true;
    char filename[100];
    printf("Podaj nazwe pliku\n");
    scanf("%s", filename);
    while(loop == true){
    fp = fopen(filename,"r");
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
    if (operation_type == 4){
        printf("det\n");
    }
    //matrix1
    get_m_n(fp , &m1, &n1);
    //printf("%d %d\n", m1, n1); display m1 n1
    get_matrix(fp, matrix1, m1, n1);
    display(matrix1, m1, n1);
    if(operation_type == 1){
        printf(" +\n");
    }
    else if(operation_type == 2){
         printf(" -\n");
    }
    else if(operation_type == 3){
         printf(" *\n");
    }
    
    if(operation_type != 4){
    //matrix2
    get_m_n(fp, &m2, &n2);
    //printf("%d %d\n", m2, n2);
    get_matrix(fp, matrix2, m2, n2);
    display(matrix2, m2, n2);
    }
    printf(" =\n");
   // printf("%p\n%p\n%p\n",matrix1, matrix2, matrix_out);
    //     rdi,rsi,rdx,rcx, r8             ,r9     ,stack,  ,stack
    mc_fun(m1, n1, m2, n2, operation_type, matrix1, matrix2, matrix_out);
    //int matrix_temp[]={18, 21, 3, 3, 4, 33, -2, 3, 3};
    //matrix_out[0] = determinantOfMatrix(matrix_temp, 3);
    //display(matrix_out, m1, n1);
    //matrix_multiplication( matrix1,  m1, n1, matrix2, m2, n2, matrix_out);
    if (operation_type == 1 || operation_type == 2){
        display(matrix_out, m1, n1);
    }
    else if(operation_type == 3){
        display(matrix_out, m1, n2);
    }
    else if(operation_type == 4){
        display(matrix_out, 1,1);
    }
    
    fclose(fp);
    loop = display_menu(filename);
    }
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
            printf("  %3d", matrix[i*n + j]); 
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

void getCofactor(int *mat, int *temp, int p, int q, int n) 
{ 
    int i = 0, j = 0; 
  
    // Looping for each element of the matrix 
    for (int row = 0; row < n; row++) 
    { 
        for (int col = 0; col < n; col++) 
        { 
            //  Copying into temporary matrix only those element 
            //  which are not in given row and column 
             if (!(row==p || col==q)) //equivalent to bif (row != p && col != q)
            { 
                *(temp+(i*(n-1)+j)) = *(mat+ row*n+col); 
                j++;
                // Row is filled, so increase row index and 
                // reset col index 
                if (j == n - 1) 
                { 
                    j = 0; 
                    i++; 
                } 
            } 
        } 
    } 
} 
  

int determinantOfMatrix(int* mat, int n) 
{ 
    
  
    //  Base case : if matrix contains single element 
    if (n == 1) {
        printf("%d\n", mat[0]);
        return mat[0]; 

    }
        

    int D = 0; // Initialize result 
    int temp[81]; // To store cofactors 
    int sign = 1;  // To store sign multiplier 
  
     // Iterate for each element of first row 
    for (int f = 0; f < n; f++) 
    { 
        // Getting Cofactor of mat[0][f] 
        getCofactor(mat, temp, 0, f, n); 
        int a = determinantOfMatrix(temp, n - 1); 
        int temp_var =sign*(*(mat+f));
        temp_var = temp_var * a;
        D = D + temp_var;
  
        // terms are to be added with alternate sign 
        sign = -sign; 
    } 
    printf("%d\n", D);
    return D; 
} 
bool display_menu(char * filename){
    int a;
    printf("Wybierz liczbe 1-3, nastpenie wscinij enter(nastepnie w przypadku 1 wprowadz tekst)\n1) Nowy plik\n2) Ten sam plik jeszcze raz\n3) Koniec\n");
    scanf("%d", &a);
    if(a == 1){
        scanf("%s", filename);
        return true;
    }
    if(a == 2){
        return true;
    }
    else{
        return false;
    }
}