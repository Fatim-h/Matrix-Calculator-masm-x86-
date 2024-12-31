INCLUDE Irvine32.inc
.data
arr SDWORD 20*20 DUP(0)
arr2 SDWORD 20*20 DUP(0)
result SDWORD 20*20 DUP(0)
resulth SDWORD 20*20 DUP(0) ; stores higher bytes for multiplication
scalar SDWORD ?

r1 DWORD ?
c1 DWORD ?
c2 DWORD ?
r2 DWORD ?

i DWORD 0
j DWORD 0
k DWORD 0

rsize DWORD 80
csize DWORD 4

operation DWORD ?
msg1 BYTE  "Chose matrix operation:",0
msg2 BYTE  "1. Addition",0
msg3 BYTE  "2. Subtraction",0
msg4 BYTE  "3. Multiplication",0
msg10 BYTE  "4. Exit",0

msg20 BYTE "1. Scalar",0
msg21 BYTE "2. Matrix",0
msg22 BYTE "3. Exit",0
msgs1 DWORD OFFSET msg20, OFFSET msg21, OFFSET msg22

msg5 BYTE  "Invalid Choice, Choose again",0
msg6 BYTE  "Enter number of columns for matrix A: ",0
msg7 BYTE  "Enter number of rows for matrix A: ",0
msg8 BYTE  "Enter number of columns for matrix B: ",0
msg9 BYTE  "Enter number of rows for matrix B: ",0

msg11 BYTE "Enter elements for matrix A: ",0
msg12 BYTE "Enter elements for matrix B: ",0

msg13 BYTE "ANSWER: ",0
msg14 BYTE "Invalid Dimensions",0
msg15 BYTE "Enter 0 to END program, any other key to continue: ",0
msg16 BYTE "Enter Scalar Multiple: ", 0

msgs DWORD OFFSET msg1, OFFSET msg2, OFFSET msg3, OFFSET msg4, OFFSET msg10

take_input_A PROTO, val1 : DWORD
take_input_B PROTO, val1 : DWORD
take_output_r PROTO, row:DWORD, col:DWORD
take_output_mulr PROTO, row:DWORD, col:DWORD

.code
main PROC
L1:
call menu
mov edx, OFFSET msg15
call writestring
call readdec
call initializearr
cmp eax, 0
JE endd
call crlf
call clrscr

JMP L1

endd:
exit
main ENDP

menu PROC uses eax
L9:
mov ecx, 5
mov esi,0
L1:
mov edx, msgs[esi* TYPE msgs]
call writestring
call crlf
inc esi
Loop L1

call readdec
cmp eax, 4
JE L6
cmp eax, 1
JB L5
cmp eax, 3
JA L5
mov operation, eax
call take_matrix
cmp eax, 0
JBE L5
cmp eax, 20
JG L5
call check_cols
JMP L6

L5:
call crlf
mov edx, OFFSET msg5
call writestring
call crlf
JMP L9

L6:
ret
menu ENDP

take_matrix PROC
cmp eax, 3
JE L1
mov edx, OFFSET msg6
call writestring
call readdec
cmp eax, 0
JBE L1
cmp eax, 20
JG L1
mov c1, eax
mov edx, OFFSET msg7
call writestring
call readdec
cmp eax, 0
JBE L1
cmp eax, 20
JG L1
mov r1, eax
mov edx, OFFSET msg8
call writestring
call readdec
cmp eax, 0
JBE L1
cmp eax, 20
JG L1
mov c2, eax
mov edx, OFFSET msg9
call writestring
call readdec
cmp eax, 0
JBE L1
cmp eax, 20
JG L1
mov r2, eax
L1:
ret
take_matrix ENDP

check_cols PROC uses eax
cmp operation, 1
JNE L1
mov eax, c1
cmp eax, c2
JNE L5
mov eax, r1
cmp eax, r2
JNE L5
INVOKE take_input_A, OFFSET msg11
call crlf
INVOKE take_input_B, OFFSET msg12
call crlf
call take_output_A
call crlf
call take_output_B
call crlf
call mat_add
INVOKE take_output_r, r1,c1
JMP L3

L1:
cmp operation, 2
JNE L2
mov eax, c1
cmp eax, c2
JNE L5
mov eax, r1
cmp eax, r2
JNE L5
INVOKE take_input_A, OFFSET msg11
call crlf
INVOKE take_input_B, OFFSET msg12
call crlf
call take_output_A
call crlf
call take_output_B
call crlf
call mat_sub
INVOKE take_output_r, r1,c1
JMP L3

L2:
cmp operation, 3
JNE L3
mov ecx, 3
mov esi, 0
L10:
mov edx, msgs1[esi* TYPE msgs1]
call writestring
call crlf
inc esi
Loop L10

call readdec
cmp eax, 1
JNZ L8
mov edx, OFFSET msg6
call writestring
call readdec
cmp eax, 0
JE L51
cmp eax, 20
JG L51
mov c1, eax
mov edx, OFFSET msg7
call writestring
call readdec
cmp eax, 0
JE L51
cmp eax, 20
JG L51
mov r1, eax
INVOKE take_input_A, OFFSET msg11
call crlf
call take_output_A
mov edx, OFFSET msg16
call writestring
call readint
mov scalar, eax
call mat_mul_scalar
INVOKE take_output_mulr, r1,c1
JMP L3

L8:
cmp eax, 2
JNZ L9
call take_matrix
mov eax, c1
cmp r2, eax
JNZ L5
INVOKE take_input_A, OFFSET msg11
call crlf
INVOKE take_input_B, OFFSET msg12
call crlf
call take_output_A
call crlf
call take_output_B
call mat_mul_mat
INVOKE take_output_mulr, r1,c2

JMP L3
L9:
cmp eax, 3
JNZ L5
JMP L3

L51:
mov edx, OFFSET msg14
call writestring
call crlf
JMP L3

L5:
call crlf
mov edx, OFFSET msg14
call writestring
call crlf
call menu
L3:
ret
check_cols ENDP

take_input_A PROC, val1 : DWORD
mov edx, val1
call writestring
call crlf
mov ebx, 0
mov ecx, r1
L1:
mov esi, 0
push ecx
mov ecx, c1
mov eax, ebx
mov edx, 80
MUL edx
push ebx
mov ebx, eax
L2:
call readint
mov arr[esi*4 + ebx], eax
inc esi
Loop L2
pop ebx
inc ebx
pop ecx
Loop L1
ret
take_input_A ENDP

take_output_A PROC

mov ebx, 0
mov ecx, r1
L1:
mov esi, 0
push ecx
mov ecx, c1
mov eax, ebx
mov edx, 80
MUL edx
push ebx
mov ebx, eax
L2:
mov eax,  arr[esi*4 + ebx]
call writeint
mov eax, " "
call writechar
inc esi
Loop L2
call crlf
pop ebx
inc ebx
pop ecx
Loop L1
ret
take_output_A ENDP

take_input_B PROC, val1 : DWORD

mov edx, val1
call writestring
call crlf
mov ebx, 0
mov ecx, r2
L1:
mov esi, 0
push ecx
mov ecx, c2
mov eax, ebx
mov edx, 80
MUL edx
push ebx
mov ebx, eax
L2:
call readint
mov arr2[esi*4 + ebx], eax
inc esi
Loop L2
pop ebx
inc ebx
pop ecx
Loop L1
ret
take_input_B ENDP

take_output_B PROC

mov ebx, 0
mov ecx, r2
L1:
mov esi, 0
push ecx
mov ecx, c2
mov eax, ebx
mov edx, 80
MUL edx
push ebx
mov ebx, eax
L2:
mov eax,  arr2[esi*4 + ebx]
call writeint
mov eax, " "
call writechar
inc esi
Loop L2
call crlf
pop ebx
inc ebx
pop ecx
Loop L1
ret
take_output_B ENDP

take_output_r PROC, row:DWORD, col:DWORD
mov edx, OFFSET msg13
call writestring
call crlf
mov ebx, 0
mov ecx, row
L1:
mov esi, 0
push ecx
mov ecx, col
mov eax, ebx
mov edx, 80
MUL edx
push ebx
mov ebx, eax
L2:
mov eax,  result[esi*4 + ebx]
call writeint
mov eax, " "
call writechar
inc esi
Loop L2
call crlf
pop ebx
inc ebx
pop ecx
Loop L1
ret
take_output_r ENDP

take_output_mulr PROC, row:DWORD, col:DWORD
mov edx, OFFSET msg13
call writestring
call crlf
mov ebx, 0
mov ecx, row
L1:
mov esi, 0
push ecx
mov ecx, col
mov eax, ebx
mov edx, 80
MUL edx
push ebx
mov ebx, eax
L2:
mov eax,  resulth[esi*4 + ebx]
call writeint
mov eax,  result[esi*4 + ebx]
call writeint
mov eax, " "
call writechar
inc esi
Loop L2
call crlf
pop ebx
inc ebx
pop ecx
Loop L1
ret
take_output_mulr ENDP

mat_add PROC
mov ebx, 0
mov ecx, r2
L1:
mov esi, 0
push ecx
mov ecx, c2
mov eax, ebx
mov edx, 80
MUL edx
push ebx
mov ebx, eax
L2:
mov eax,  arr[esi*4 + ebx]
add eax,  arr2[esi*4 + ebx]
JNO L3
neg eax
L3:
mov result[esi*4 + ebx], eax
inc esi
Loop L2
call crlf
pop ebx
inc ebx
pop ecx
Loop L1
ret
mat_add ENDP

mat_sub PROC
mov ebx, 0
mov ecx, r2
L1:
mov esi, 0
push ecx
mov ecx, c2
mov eax, ebx
mov edx, 80
MUL edx
push ebx
mov ebx, eax
L2:
mov eax,  arr[esi*4 + ebx]
sub eax,  arr2[esi*4 + ebx]
JNO L3
neg eax
L3:
mov result[esi*4 + ebx], eax
inc esi
Loop L2
call crlf
pop ebx
inc ebx
pop ecx
Loop L1
ret
mat_sub ENDP

mat_mul_scalar PROC
mov ebx, 0
mov ecx, r1
L1:
mov esi, 0
push ecx
mov ecx, c1
mov eax, ebx
mov edx, 80
MUL edx
push ebx
mov ebx, eax
L2:
mov eax,  arr[esi*4 + ebx]
MUL scalar
mov result[esi*4 + ebx], eax
mov resulth[esi*4 +ebx], edx
inc esi
Loop L2
call crlf
pop ebx
inc ebx
pop ecx
Loop L1
ret
mat_mul_scalar ENDP

mat_mul_mat PROC
mov ecx, 0
L1:
mov esi, 0
mov i, ecx
mov ecx, 0
L2:
mov j,ecx
mov ecx, 0
mov esi, 0

L3:
push esi

mov eax, i
MUL rsize
mov ebx, eax
mov edx, arr[esi*4 + ebx]
push edx

mov eax, esi
MUL rsize
mov esi, eax
mov ebx, j
mov edx, arr2[esi + ebx*4]
push edx

mov eax, i
MUL rsize
mov esi,j
mov ebx, eax
pop eax
pop edx
MUL edx

add resulth[esi*4 + ebx], edx
add result[esi*4 + ebx], eax


pop esi
inc esi
inc ecx
cmp ecx, c1
JNE L3

mov ecx, j
inc ecx
cmp ecx, c2
JNE L2

mov ecx, i
inc ecx
cmp ecx, r1
JNE L1

ret
mat_mul_mat ENDP

initializearr PROC
mov ecx, 400
mov esi, 0
L1:
mov result[esi*type result],0
mov resulth[esi*type result],0
inc esi
Loop L1
ret
initializearr ENDP
END main