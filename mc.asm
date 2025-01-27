    section .data

    global  mc_fun
    section .text

mc_fun:
    push    rbp         ;save old call frame
    push    rbx
    push    r12
    push    r13
    push    r14
    push    r15
    mov     rbp, rsp    ;save current call frame
    ;//     rdi,rsi,rdx,rcx, r8             ,r9     ,stack,  ,stack
    ;mc_fun(m1, n1, m2, n2, operation_type, matrix1, matrix2, matrix_out);
    cmp r8, 1
    jne subtraction
;;;addition
    ;check whether operation is possible
    cmp     rdi, rdx        ;if m1 !=m2 goto error_m_n
    jne     error_m_n
    cmp     rsi, rcx        ;if n1 != n2 goto error_m_n
    jne     error_m_n       
    imul    edi, esi        ;length of the matrix m *n 
    mov     esi, 0          ;loop counter
    mov     rdx, [rbp + 64] ;rdx = matrix_out address;
    mov     rcx, [rbp + 56] ;rcx = matrix2 address;
    mov     r8, 0
addition_loop:
    mov     r8d, [r9]        ;matrix1 single element
    add     r8d, [rcx]       ;sum of matrix1 and matrix2 
    mov     [rdx], r8d       ;save sum
    add     r9, 4
    add     rdx, 4
    add     rcx, 4
    inc     esi
    cmp     esi, edi
    jb     addition_loop 
    ;go back to C
    mov     rsp, rbp  
    pop     r15
    pop     r14
    pop     r13
    pop     r12
    pop     rbx   
    pop     rbp         ;restore old call frame
    ret 

subtraction:
    cmp r8, 2
    jne multiplication
    ;check whether operation is possible
    cmp     rdi, rdx        ;if m1 !=m2 goto error_m_n
    jne     error_m_n
    cmp     rsi, rcx        ;if n1 != n2 goto error_m_n
    jne     error_m_n       
    imul    edi, esi        ;length of the matrix m *n 
    mov     esi, 0          ;loop counter
    mov     rdx, [rbp + 64] ;rdx = matrix_out address
    mov     rcx, [rbp + 56] ;rcx = matrix2 address
    mov     r8, 0
subtraction_loop:
    mov     r8d, [r9]        ;matrix1 single element
    sub     r8d, [rcx]       ;r8d = matrix1 - matrix2
    mov     [rdx], r8d       ;save subtraction
    add     r9, 4
    add     rdx, 4
    add     rcx, 4
    inc     esi
    cmp     esi, edi
    jb      subtraction_loop
    ;go back to C
    mov     rsp, rbp  
    pop     r15
    pop     r14
    pop     r13
    pop     r12
    pop     rbx   
    pop     rbp         ;restore old call frame
    ret 
multiplication:
    cmp r8, 3
    jne determinant
 

 ;   int i = 0;
  ;  do{loop_m1
   ;     int j = 0;
    ;    do{loop_n2
     ;       int k = 0;
     ;temp1 =  i*m2 + j
      ;      *(matrix_out + temp1) = 0;
       ;     do{loop_m2
        ; temp2 = +i*m2 +k; temp3 = j +k*m2 
        ;        *(matrix_out + temp1)  += (*(matrix1 + temp2)) * (*(matrix2 +temp3));
         ;       k++;
        ;    }while(k<m2);
        ;    j++;
       ; }while(j<n2);
       ; i++;
   ; }while(i<m1);
;}
;check whether operation is possible
    cmp     rsi, rdx        ;if n1 != m2 goto error_m_n
    jne     error_m_n 
;rbx = k  
;rcx = i
;rdx = m2
;rsi = n2
;rdi = m1
;r8 = j
;r9 = matrix1 address
;r10 = temp1 also temp2
;r11 =  temporary matrix_out address
;r12 =  temporary matrix1 address
;r13 = temporary matrix2 address
;r14 = matrix_out address
;r15 = matrix2 address
    mov     r14, [rbp + 64] ;r14 = matrix_out address
    mov     r15, [rbp + 56] ;r15 = matrix2 address
    mov     rsi, rcx        ;rsi = n2
    mov     rcx,0           ;i=0
loop_m1:
    mov     r8,0           ;j=0
loop_n2:
    mov     rbx,0           ;k=0

    mov     r11, rcx         ;r11 = i
    imul    r11, rdx        ;r11 = i*m2
    add     r11, r8         ;r11 = i*m2 +j
    shl     r11, 2          ;r11 = r11*4 shift in words ;temp1 =  i*m2 + j
    add     r11, r14        ;(matrix_out + temp1) 
    mov     [r11],ebx        ;*(matrix_out + temp1) = 0;
loop_m2:
    ;temp2 = i*m2 +k;
    mov     r12, rcx         ;r12 = i
    imul    r12, rdx        ;r12 = i*m2
    add     r12, rbx        ; i*m2 +k
    shl     r12, 2          
    add     r12, r9         ;(matrix_1 + temp) address
    ;temp3 = j +k*m2 
    mov     r13,  rbx       ;r12 = k
    imul    r13, rdx        ;r12 = k*m2
    add     r13, r8         ;r12 = k*m2 + j
    shl     r13, 2 
    add     r13, r15        ;(matrix 2 + temp) address

    mov     r10d, [r12]      ;r10 = *(matrix1 +temp)
firsr:  imul    r10d, [r13]      ;r10 = (*(matrix1 + temp2)) * (*(matrix2 +temp3));
sec:    add     [r11], r10d
    inc     rbx             ;k++
    cmp     rbx, rdx        ;while(k<m2);
    jb      loop_m2         
    inc     r8               ;j++
    cmp     r8, rsi         ;while(j<n2);
    jb      loop_n2
    inc     rcx             ;i++
    cmp     rcx, rdi        ;while(i<m1)
    jb      loop_m1
    mov     rsp, rbp  
    pop     r15
    pop     r14
    pop     r13
    pop     r12
    pop     rbx    
    pop     rbp             ;restore old call frame
    ret         


determinant:
    cmp     rdi, rsi       ;if m1 != n1 goto error_m_n
    jne     error_m_n 
    mov     rdx, [rbp + 64] ; = matrix_out address
    push    rdx             
    mov     rdi, r9
    mov     rax, 0
    ;                   rdi        rsi
    ;int determinant(int *matrix, int n)
;//     rdi,rsi,rdx,rcx, r8             ,r9     ,stack,  ,stack
;mc_fun(m1, n1, m2, n2, operation_type, matrix1, matrix2, matrix_out);
    call get_determinant
    pop rdx ;było rsi
    mov [rdx], eax






error_m_n:

    mov     rsp, rbp   
    pop     r15
    pop     r14
    pop     r13
    pop     r12
    pop     rbx 
    pop     rbp         ;restore old call frame
    ret         


    ;stuff to do (return value flag to show it in c, that error occured)

get_cofactor:
    push    rbp         ;save old call frame
    push    rbx
    push    r12
    push    r13
    push    r14
    push    r15
    mov     rbp, rsp    ;save current call frame	
;                   rdi                 rsi     rdx     rcx     r8      
;;get_cofactor(int *address_matrix, int * temp, int p, int q, int n)
;rbx = i  
;rcx = q`
;rdx = p`
;rsi = smaller (new) matrix address`
;rdi = matrix address`
;r8 = n`
;r9 = j
;r10 = row
;r11 =  col
;r12 =  n-1
;r13 =  temporary addres of new a matrix
;r14 =  temporary addres of matrix
;r15 =  temp
	mov     rbx,0			; rbx = i = 0
	mov     r9,0			; r9 = j = 0
    mov     r12, r8             ;n of temp = n -1 (2 instructions)
	add     r12,-1		        
	
	mov     r10,0			; r10 = row = 0
	;bge r10,r8,not_loop1_get_cofactor	;  for (int row = 0; row < n; row++) 
	
loop1_get_cofactor:
	mov     r11,0				;r11 = col = 0

	;bge r11,r8,end_loop1_get_cofactor	;   for (int col = 0; col < n; col++) 
loop2_get_cofactor:
	
;if1_get_cofactor:
    cmp     r10,rdx  
	je      end_ifs_get_cofactor	; if (row != p && col != q)
    cmp     r11,rcx
	je      end_ifs_get_cofactor
	;temp
    mov     r13, r12
	imul    r13, rbx			    ;go to index ith row, so i * size (in words)
	add     r13, r9				    ;go to the correct column
	shl     r13, 2				    ;multiply by 4 (shifting 2 bits left)
	add     r13, rsi				;store correct address
	
	;matrix
    mov     r14, r8
	imul    r14, r10			;go to index ith row, so row * size (in words)
	add     r14,r11			    ;go to the correct column
	shl     r14,2				;multiply by 4 (shifting 2 bits left)
	add     r14, rdi			;store correct address
	
    
after_add:	mov r15,[r14]				;r13 = mat[row][col]; 
	mov [r13], r15				;temp[i][j] = r13
	inc r9				        ;j++
	mov r14, rdi			    ;r14 = address of matrix back to beginning
	mov r13, rsi			    ;rsi = address of temp back to beginning
if2_get_cofactor:						 
    cmp     r12,r9          ; if (j == n - 1)
	jne     end_ifs_get_cofactor
	mov     r9,0				;j=0	
	inc     rbx				        ;i++
end_ifs_get_cofactor:
	inc     r11			            ;col++
    cmp     r11,r8
	jb      loop2_get_cofactor		;   for (int col = 0; col < n; col++)
end_loop1_get_cofactor:
	inc     r10			;row++
    cmp     r10,r8
	jb      loop1_get_cofactor		;  for (int row = 0; row < n; row++)
;not_loop1_get_cofactor:	
	mov     rsp, rbp   
    pop     r15
    pop     r14
    pop     r13
    pop     r12
    pop     rbx 
    pop     rbp         ;restore old call frame
    ret         


                ;                       rdi      rsi
get_determinant: ;int determinant(int *matrix, int n)
;//     rdi,rsi,rdx,rcx, r8             ,r9     ,stack,  ,stack
;mc_fun(m1, n1, m2, n2, operation_type, matrix1, matrix2, matrix_out);



;rax = return value
;rbx = D 
;rcx = temp(new matrix) address
;rdx =  (matrix addres + f)
;rsi = n
;rdi = matrix address
;r8 = temp_var
;r9 = 
;r10 = 
;r11 =  
;r12 = sign
;r13 =  f
;r14 =  a
;r15 =  

    cmp     rsi, 1
    jne     not_if_get_determinant
    mov     eax,[rdi]
    ret
not_if_get_determinant:
    ;save registers
    push    rbp         ;save old call frame
    push    rbx
    push    r12
    push    r13
    push    r14
    push    r15
    mov     rbp, rsp    ;save current call frame
;not_if_get było tu

    mov     ebx, 0      ;D = 0
    mov     r12d, 1      ;sign = 1
    mov     r13, 0      ;f = 0
    ;allocate on stack space for maxium of 81 int, but to align to 16
    ;temp matrix will be at most 9by9
    sub     rsp, 344    ;??? check that
    mov     rcx, rsp
loop_determinant:
    mov     r15, rsi
    push    rsi            ;save n 
    push    rcx             ;save temp matrix address
    mov     rsi, rcx        ;load arguments
    mov     rdx, 0
    mov     rcx, r13
    mov     r8, r15
    ;                rdi                 rsi     rdx     rcx     r8      
;;get_cofactor(int *address_matrix, int * temp, int p, int q, int n)
    call    get_cofactor
    pop     rcx
    pop     rsi
    push    rsi  
    push    rdi 
    push    rcx  
    mov     rdi, rcx
    dec     rsi                 ;n-1 2nd argument of get_determinant (first arg is the same)
    call    get_determinant     ;stack already aligned
    pop     rcx
    pop     rdi
    pop     rsi
    mov     r14d, eax            ; a = Determinant(temp, n - 1)
    mov     rdx, r13            ;f
    shl     rdx, 2              ;4*f (shift in words)
    add     rdx, rdi            ;matrix address + 4*f 
    mov     r8d, [rdx]           ;temp_var = *(matrix address + f )
    imul    r8d, r12d           ;temp_var= temp_var * sign
    imul    r8d, r14d           ;temp_var = temp_var * a
    add     ebx, r8d            ;D = D+ temp_var;
    imul    r12d, -1             ;sign = -sign
    inc     r13                 ;f++
    cmp     r13, rsi            ;while(f<n)
    jb      loop_determinant

    mov    eax, ebx             ;return D
after_dd:
    mov     rsp, rbp   
    pop     r15
    pop     r14
    pop     r13
    pop     r12
    pop     rbx 
    pop     rbp         ;restore old call frame
    ret  