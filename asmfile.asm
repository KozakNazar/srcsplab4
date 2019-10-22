.386
.model flat, c
EXTRN   printf:near

CHECK_DIVISION_BY_ZERO  MACRO to_exit_label
	fldz
	fcomp
	;xor eax, eax
	fstsw ax
	sahf
	je to_exit_label;
    ;push OFFSET fmt3
    ;call printf
    ;add esp, 4
	;pop ebp
	;ret
	;end_macro:
ENDM

.data
fmt1 db "result: ", 0;
fmt2 db "x[%d] = %f", 13, 10, 0;
fmt3 db "error: division by zero", 13, 10, 0;
temp qword ?
CONST_53 equ 53d;
CONST_28 equ 28d;
CONST_5 equ 5d;

.code
calcLab4 PROC
    finit
    push ebp
	mov ebp, esp

	mov ecx, dword ptr [ebp + 24]    
	xor esi, esi; (mov esi, 0)


	fld dword ptr [ebp + 20] ;  d
CHECK_DIVISION_BY_ZERO division_by_zero_message; // check for (53/c) and (28 * d / c)
	fld dword ptr [ebp + 16] ;  c
	fcompp
	;xor eax, eax
	fstsw ax
	sahf
	jna compute_loop_2; // if (c <= d) goto compute_loop_2;


    compute_loop_1: ; // if (c > d);
	fld1
	fchs
	fld dword ptr [ebp + 20] ; d
	fscale; d/2
	mov dword ptr temp, CONST_53
	fild dword ptr temp
	fdiv dword ptr [ebp + 16] ; 53 / c
	fsub; d / 2 - 53 / c
	

	fld dword ptr [ebp + 20] ;  d
	mov ebx, dword ptr [ebp + 12]  ; a
	fsub qword ptr [ebx + 8 * esi]; d - a[esi]
	fld1
	fpatan; arctg(d - a[esi])
	fmul dword ptr [ebp + 16]  ;  arctg(d - a[esi]) * c 	
	fld1
	fadd;  arctg(d - a[esi])*c + 1

	CHECK_DIVISION_BY_ZERO division_by_zero_message;
	fdiv;  (d / 2 - 53 / c) / (arctg(d - a[esi]) * c + 1)

	mov ebx, dword ptr [ebp + 8]  ; x
	fst qword ptr [ebx + 8 * esi] ; x[esi]

	inc esi
	loop compute_loop_1
	jmp output

	
	compute_loop_2: ; // if (c <= d);
	fld1
	fld1
	faddp
	fld dword ptr [ebp + 16]; c
	fscale; c*4
	mov dword ptr temp, CONST_28
	fild dword ptr temp
	fmul dword ptr [ebp + 20] ; 28 * d
	fdiv dword ptr [ebp + 16] ; 28 * d / c
	fadd; c*4 + 28 * d / c

	mov ebx, dword ptr [ebp + 12] ; a
	fld qword ptr [ebx + 8 * esi]; a[esi]
	fmul dword ptr [ebp + 20] ;  a[esi] * d
	fld1
	fpatan; arctg(a[esi] * d)
	fchs ;  - arctg(d - a[esi]) 
	mov dword ptr temp, CONST_5
	fiadd dword ptr temp  ;  5 - arctg(d - a[esi])

	CHECK_DIVISION_BY_ZERO division_by_zero_message;
	fdiv;  (c*4 + 28 * d / c) / (5 - arctg(d - a[esi]))

	mov ebx, dword ptr [ebp + 8]  ; x 
	fst qword ptr [ebx + 8 * esi] ; x[esi]

	inc esi
	loop compute_loop_2
	jmp output



	output:
	mov ecx, dword ptr [ebp + 24]
	xor esi, esi
	mov ebx, dword ptr [ebp + 8]  ; x

	
	output_loop:
	push ecx
	fst temp
	mov edx, dword ptr [ebx + 8 * esi + 4];
	mov eax, dword ptr [ebx + 8 * esi];
    push edx; for next call printf
    push eax; for next call printf

    push OFFSET fmt1
    call printf
    add esp, 4

	;edx already in stack
	;eax already in stack
    push esi
    push OFFSET fmt2
    call printf
    add esp, 16

	inc esi
	pop ecx
	loop output_loop

	pop ebp
	ret

	division_by_zero_message:
    push OFFSET fmt3
    call printf
    add esp, 4
	pop ebp
	ret

calcLab4 ENDP

END