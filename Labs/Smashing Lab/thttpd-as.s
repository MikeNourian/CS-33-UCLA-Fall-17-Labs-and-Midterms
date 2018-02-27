	.file	"thttpd.c"
	.text
	.p2align 4,,15
	.type	handle_hup, @function
handle_hup:
.LFB4:
	.cfi_startproc
	movl	$1, got_hup(%rip)
	ret
	.cfi_endproc
.LFE4:
	.size	handle_hup, .-handle_hup
	.section	.rodata
	.align 32
.LC0:
	.string	"  thttpd - %ld connections (%g/sec), %d max simultaneous, %lld bytes (%g/sec), %d httpd_conns allocated"
	.zero	56
	.text
	.p2align 4,,15
	.type	thttpd_logstats, @function
thttpd_logstats:
.LFB35:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	testq	%rdi, %rdi
	jle	.L3
	movq	stats_bytes(%rip), %r8
	movq	stats_connections(%rip), %rdx
	movl	$.LC0, %esi
	cvtsi2ssq	%rdi, %xmm2
	movl	httpd_conn_count(%rip), %r9d
	movl	stats_simultaneous(%rip), %ecx
	movl	$6, %edi
	movl	$2, %eax
	cvtsi2ssq	%r8, %xmm1
	cvtsi2ssq	%rdx, %xmm0
	divss	%xmm2, %xmm1
	divss	%xmm2, %xmm0
	unpcklps	%xmm1, %xmm1
	unpcklps	%xmm0, %xmm0
	cvtps2pd	%xmm1, %xmm1
	cvtps2pd	%xmm0, %xmm0
	call	syslog
.L3:
	movq	$0, stats_connections(%rip)
	movq	$0, stats_bytes(%rip)
	movl	$0, stats_simultaneous(%rip)
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE35:
	.size	thttpd_logstats, .-thttpd_logstats
	.section	.rodata
	.align 32
.LC1:
	.string	"throttle #%d '%.80s' rate %ld greatly exceeding limit %ld; %d sending"
	.zero	58
	.align 32
.LC2:
	.string	"throttle #%d '%.80s' rate %ld exceeding limit %ld; %d sending"
	.zero	34
	.align 32
.LC3:
	.string	"throttle #%d '%.80s' rate %ld lower than minimum %ld; %d sending"
	.zero	63
	.text
	.p2align 4,,15
	.type	update_throttles, @function
update_throttles:
.LFB25:
	.cfi_startproc
	pushq	%r13
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	pushq	%r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	movabsq	$6148914691236517206, %r12
	pushq	%rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	xorl	%ebp, %ebp
	pushq	%rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	xorl	%ebx, %ebx
	subq	$24, %rsp
	.cfi_def_cfa_offset 64
	movl	numthrottles(%rip), %eax
	testl	%eax, %eax
	jg	.L84
	jmp	.L24
	.p2align 4,,10
	.p2align 3
.L21:
	addl	$1, %ebx
	addq	$48, %rbp
	cmpl	%ebx, numthrottles(%rip)
	jle	.L24
.L84:
	movq	%rbp, %rcx
	addq	throttles(%rip), %rcx
	leaq	24(%rcx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L86
	movq	24(%rcx), %rax
	leaq	32(%rcx), %rdi
	leaq	(%rax,%rax), %rsi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L87
	movq	32(%rcx), %rdx
	leaq	8(%rcx), %rdi
	movq	$0, 32(%rcx)
	movq	%rdx, %rax
	shrq	$63, %rax
	addq	%rdx, %rax
	sarq	%rax
	addq	%rax, %rsi
	movq	%rsi, %rax
	sarq	$63, %rsi
	imulq	%r12
	movq	%rdi, %rax
	shrq	$3, %rax
	movq	%rdx, %r8
	subq	%rsi, %r8
	cmpb	$0, 2147450880(%rax)
	movq	%r8, 24(%rcx)
	jne	.L88
	movq	8(%rcx), %r9
	cmpq	%r9, %r8
	jle	.L13
	leaq	40(%rcx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	jne	.L89
.L14:
	movl	40(%rcx), %eax
	testl	%eax, %eax
	je	.L13
	leaq	(%r9,%r9), %rdx
	cmpq	%rdx, %r8
	movq	%rcx, %rdx
	jle	.L15
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L90
	movl	%eax, (%rsp)
	movq	(%rcx), %rcx
	xorl	%eax, %eax
	movl	$5, %edi
	movl	%ebx, %edx
	movl	$.LC1, %esi
	call	syslog
	movq	%rbp, %rcx
	addq	throttles(%rip), %rcx
	leaq	24(%rcx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L91
.L19:
	movq	24(%rcx), %r8
.L13:
	leaq	16(%rcx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L92
	movq	16(%rcx), %r9
	cmpq	%r8, %r9
	jle	.L21
	leaq	40(%rcx), %rdi
	movq	%rdi, %rax
	movq	%rdi, %rdx
	shrq	$3, %rax
	andl	$7, %edx
	movzbl	2147450880(%rax), %eax
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L93
.L22:
	movl	40(%rcx), %eax
	testl	%eax, %eax
	je	.L21
	movq	%rcx, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L94
	movl	%eax, (%rsp)
	movq	(%rcx), %rcx
	movl	%ebx, %edx
	xorl	%eax, %eax
	movl	$.LC3, %esi
	movl	$5, %edi
	addl	$1, %ebx
	addq	$48, %rbp
	call	syslog
	cmpl	%ebx, numthrottles(%rip)
	jg	.L84
	.p2align 4,,10
	.p2align 3
.L24:
	movl	max_connects(%rip), %eax
	testl	%eax, %eax
	jle	.L6
	subl	$1, %eax
	movq	connects(%rip), %r10
	movq	throttles(%rip), %rbp
	leaq	(%rax,%rax,8), %rax
	salq	$4, %rax
	leaq	64(%r10), %rdi
	leaq	208(%r10,%rax), %r12
	jmp	.L41
	.p2align 4,,10
	.p2align 3
.L31:
	addq	$144, %rdi
	addq	$144, %r10
	cmpq	%r12, %rdi
	je	.L6
.L41:
	movq	%r10, %rax
	movq	%r10, %rdx
	shrq	$3, %rax
	andl	$7, %edx
	movzbl	2147450880(%rax), %eax
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L95
.L26:
	movl	(%r10), %eax
	subl	$2, %eax
	cmpl	$1, %eax
	ja	.L31
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	leaq	2147450880(%rax), %r11
	jne	.L96
	leaq	-8(%rdi), %rax
	movq	$-1, (%rdi)
	movq	%rax, %rdx
	movq	%rax, %rcx
	shrq	$3, %rdx
	andl	$7, %ecx
	movzbl	2147450880(%rdx), %edx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L97
.L30:
	movl	-8(%rdi), %eax
	testl	%eax, %eax
	jle	.L31
	subl	$1, %eax
	leaq	-48(%rdi), %rcx
	movq	$-1, %r8
	leaq	16(%r10,%rax,4), %rbx
	jmp	.L40
	.p2align 4,,10
	.p2align 3
.L35:
	cmpq	%rax, %r8
	cmovle	%r8, %rax
	cmpb	$0, (%r11)
	jne	.L98
.L38:
	cmpq	%rbx, %rcx
	movq	%rax, (%rdi)
	je	.L31
	addq	$4, %rcx
	cmpb	$0, (%r11)
	jne	.L99
	movq	(%rdi), %r8
.L40:
	movq	%rcx, %rax
	movq	%rcx, %rdx
	shrq	$3, %rax
	andl	$7, %edx
	movzbl	2147450880(%rax), %eax
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L100
.L32:
	movslq	(%rcx), %rax
	leaq	(%rax,%rax,2), %rsi
	salq	$4, %rsi
	addq	%rbp, %rsi
	leaq	8(%rsi), %rax
	movq	%rax, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L101
	leaq	40(%rsi), %r9
	movq	8(%rsi), %rax
	movq	%r9, %rdx
	movq	%r9, %r13
	shrq	$3, %rdx
	andl	$7, %r13d
	movzbl	2147450880(%rdx), %edx
	addl	$3, %r13d
	cmpb	%dl, %r13b
	jge	.L102
.L34:
	movslq	40(%rsi), %rsi
	cqto
	idivq	%rsi
	cmpq	$-1, %r8
	jne	.L35
	cmpb	$0, (%r11)
	je	.L38
	call	__asan_report_store8
	.p2align 4,,10
	.p2align 3
.L15:
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L103
	movl	%eax, (%rsp)
	movq	(%rcx), %rcx
	xorl	%eax, %eax
	movl	$6, %edi
	movl	%ebx, %edx
	movl	$.LC2, %esi
	call	syslog
	movq	%rbp, %rcx
	addq	throttles(%rip), %rcx
	leaq	24(%rcx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	je	.L19
	call	__asan_report_load8
	.p2align 4,,10
	.p2align 3
.L6:
	addq	$24, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%rbp
	.cfi_def_cfa_offset 24
	popq	%r12
	.cfi_def_cfa_offset 16
	popq	%r13
	.cfi_def_cfa_offset 8
	ret
.L102:
	.cfi_restore_state
	testb	%dl, %dl
	je	.L34
	movq	%r9, %rdi
	call	__asan_report_load4
	.p2align 4,,10
	.p2align 3
.L100:
	testb	%al, %al
	je	.L32
	movq	%rcx, %rdi
	call	__asan_report_load4
	.p2align 4,,10
	.p2align 3
.L95:
	testb	%al, %al
	je	.L26
	movq	%r10, %rdi
	call	__asan_report_load4
	.p2align 4,,10
	.p2align 3
.L93:
	testb	%al, %al
	je	.L22
	call	__asan_report_load4
	.p2align 4,,10
	.p2align 3
.L89:
	movq	%rdi, %rdx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%al, %dl
	jl	.L14
	call	__asan_report_load4
.L87:
	call	__asan_report_load8
.L86:
	.p2align 4,,5
	call	__asan_report_load8
.L88:
	.p2align 4,,5
	call	__asan_report_load8
.L97:
	testb	%dl, %dl
	.p2align 4,,3
	je	.L30
	movq	%rax, %rdi
	call	__asan_report_load4
.L96:
	call	__asan_report_store8
.L98:
	call	__asan_report_store8
.L101:
	movq	%rax, %rdi
	call	__asan_report_load8
.L103:
	movq	%rcx, %rdi
	call	__asan_report_load8
.L94:
	movq	%rcx, %rdi
	call	__asan_report_load8
.L99:
	call	__asan_report_load8
.L90:
	movq	%rcx, %rdi
	call	__asan_report_load8
.L92:
	call	__asan_report_load8
.L91:
	call	__asan_report_load8
	.cfi_endproc
.LFE25:
	.size	update_throttles, .-update_throttles
	.section	.rodata
	.align 32
.LC4:
	.string	"%s: no value required for %s option\n"
	.zero	59
	.text
	.p2align 4,,15
	.type	no_value_required, @function
no_value_required:
.LFB14:
	.cfi_startproc
	testq	%rsi, %rsi
	jne	.L108
	rep ret
.L108:
	movq	%rdi, %rcx
	pushq	%rax
	.cfi_def_cfa_offset 16
	movq	stderr(%rip), %rdi
	movq	argv0(%rip), %rdx
	movl	$.LC4, %esi
	xorl	%eax, %eax
	call	fprintf
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
	.cfi_endproc
.LFE14:
	.size	no_value_required, .-no_value_required
	.section	.rodata
	.align 32
.LC5:
	.string	"%s: value required for %s option\n"
	.zero	62
	.text
	.p2align 4,,15
	.type	value_required, @function
value_required:
.LFB13:
	.cfi_startproc
	testq	%rsi, %rsi
	je	.L113
	rep ret
.L113:
	movq	%rdi, %rcx
	pushq	%rax
	.cfi_def_cfa_offset 16
	movq	stderr(%rip), %rdi
	movq	argv0(%rip), %rdx
	movl	$.LC5, %esi
	xorl	%eax, %eax
	call	fprintf
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
	.cfi_endproc
.LFE13:
	.size	value_required, .-value_required
	.section	.rodata
	.align 32
.LC6:
	.string	"usage:  %s [-C configfile] [-p port] [-d dir] [-r|-nor] [-dd data_dir] [-s|-nos] [-v|-nov] [-g|-nog] [-u user] [-c cgipat] [-t throttles] [-h host] [-l logfile] [-i pidfile] [-T charset] [-P P3P] [-M maxage] [-V] [-D]\n"
	.zero	37
	.section	.text.unlikely,"ax",@progbits
	.type	usage, @function
usage:
.LFB11:
	.cfi_startproc
	pushq	%rax
	.cfi_def_cfa_offset 16
	movq	stderr(%rip), %rdi
	movl	$.LC6, %esi
	movq	argv0(%rip), %rdx
	xorl	%eax, %eax
	call	fprintf
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
	.cfi_endproc
.LFE11:
	.size	usage, .-usage
	.text
	.p2align 4,,15
	.type	wakeup_connection, @function
wakeup_connection:
.LFB30:
	.cfi_startproc
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	movq	%rsp, %rax
	movq	%rdi, (%rsp)
	movq	%rsp, %rdi
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L143
	movq	(%rsp), %rsi
	leaq	96(%rsi), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L144
	movq	%rsi, %rax
	movq	%rsi, %rdx
	movq	$0, 96(%rsi)
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	setne	%cl
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L145
.L119:
	cmpl	$3, (%rsi)
	je	.L146
	addq	$24, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L146:
	.cfi_restore_state
	testb	%cl, %cl
	jne	.L147
.L121:
	leaq	8(%rsi), %rdi
	movl	$2, (%rsi)
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L148
	movq	8(%rsi), %rax
	leaq	704(%rax), %rdi
	movq	%rdi, %rdx
	movq	%rdi, %rcx
	shrq	$3, %rdx
	andl	$7, %ecx
	movzbl	2147450880(%rdx), %edx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L149
.L123:
	movl	704(%rax), %edi
	movl	$1, %edx
	call	fdwatch_add_fd
	addq	$24, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L145:
	.cfi_restore_state
	testb	%cl, %cl
	je	.L119
	movq	%rsi, %rdi
	call	__asan_report_load4
.L149:
	testb	%dl, %dl
	je	.L123
	call	__asan_report_load4
.L147:
	cmpb	%dl, %al
	.p2align 4,,4
	jg	.L121
	movq	%rsi, %rdi
	call	__asan_report_store4
.L148:
	call	__asan_report_load8
.L144:
	call	__asan_report_store8
.L143:
	.p2align 4,,5
	call	__asan_report_load8
	.cfi_endproc
.LFE30:
	.size	wakeup_connection, .-wakeup_connection
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC7:
	.string	"logstats 1 32 16 2 tv "
	.section	.rodata
	.align 32
.LC8:
	.string	"up %ld seconds, stats for %ld seconds:"
	.zero	57
	.text
	.p2align 4,,15
	.type	logstats, @function
logstats:
.LFB34:
	.cfi_startproc
	pushq	%r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	pushq	%rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
	subq	$96, %rsp
	.cfi_def_cfa_offset 128
	movq	%rsp, %rbp
	movq	$1102416563, (%rsp)
	movq	$.LC7, 8(%rsp)
	shrq	$3, %rbp
	testq	%rdi, %rdi
	leaq	2147450880(%rbp), %r12
	movl	$-235802127, 2147450880(%rbp)
	movl	$-185335808, 4(%r12)
	movl	$-202116109, 8(%r12)
	je	.L156
.L151:
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L157
	movq	(%rdi), %rax
	movl	$1, %ecx
	movl	$.LC8, %esi
	movl	$6, %edi
	movq	%rax, %rdx
	movq	%rax, %rbx
	subq	start_time(%rip), %rdx
	subq	stats_time(%rip), %rbx
	movq	%rax, stats_time(%rip)
	cmove	%rcx, %rbx
	xorl	%eax, %eax
	movq	%rbx, %rcx
	call	syslog
	movq	%rbx, %rdi
	call	thttpd_logstats
	movq	%rbx, %rdi
	call	httpd_logstats
	movq	%rbx, %rdi
	call	mmc_logstats
	movq	%rbx, %rdi
	call	fdwatch_logstats
	movq	%rbx, %rdi
	call	tmr_logstats
	movq	$0, 2147450880(%rbp)
	movl	$0, 8(%r12)
	addq	$96, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 32
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L156:
	.cfi_restore_state
	leaq	32(%rsp), %rdi
	xorl	%esi, %esi
	call	gettimeofday
	leaq	32(%rsp), %rdi
	jmp	.L151
.L157:
	call	__asan_report_load8
	.cfi_endproc
.LFE34:
	.size	logstats, .-logstats
	.p2align 4,,15
	.type	show_stats, @function
show_stats:
.LFB33:
	.cfi_startproc
	movq	%rsi, %rdi
	jmp	logstats
	.cfi_endproc
.LFE33:
	.size	show_stats, .-show_stats
	.p2align 4,,15
	.type	handle_usr2, @function
handle_usr2:
.LFB6:
	.cfi_startproc
	pushq	%r13
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	pushq	%r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	pushq	%rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	pushq	%rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	subq	$8, %rsp
	.cfi_def_cfa_offset 48
	call	__errno_location
	movq	%rax, %r12
	movq	%rax, %rbx
	shrq	$3, %r12
	movq	%rbx, %rbp
	movzbl	2147450880(%r12), %eax
	andl	$7, %ebp
	addl	$3, %ebp
	cmpb	%al, %bpl
	jge	.L175
.L160:
	xorl	%edi, %edi
	movl	(%rbx), %r13d
	call	logstats
	movzbl	2147450880(%r12), %eax
	cmpb	%al, %bpl
	jge	.L176
.L161:
	movl	%r13d, (%rbx)
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%rbp
	.cfi_def_cfa_offset 24
	popq	%r12
	.cfi_def_cfa_offset 16
	popq	%r13
	.cfi_def_cfa_offset 8
	ret
.L175:
	.cfi_restore_state
	testb	%al, %al
	je	.L160
	movq	%rbx, %rdi
	call	__asan_report_load4
.L176:
	testb	%al, %al
	je	.L161
	movq	%rbx, %rdi
	call	__asan_report_store4
	.cfi_endproc
.LFE6:
	.size	handle_usr2, .-handle_usr2
	.p2align 4,,15
	.type	occasional, @function
occasional:
.LFB32:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movq	%rsi, %rdi
	call	mmc_cleanup
	call	tmr_cleanup
	movl	$1, watchdog_flag(%rip)
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE32:
	.size	occasional, .-occasional
	.section	.rodata
	.align 32
.LC9:
	.string	"/tmp"
	.zero	59
	.text
	.p2align 4,,15
	.type	handle_alrm, @function
handle_alrm:
.LFB7:
	.cfi_startproc
	pushq	%r13
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	pushq	%r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	pushq	%rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	pushq	%rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	subq	$8, %rsp
	.cfi_def_cfa_offset 48
	call	__errno_location
	movq	%rax, %r12
	movq	%rax, %rbx
	shrq	$3, %r12
	movq	%rbx, %rbp
	movzbl	2147450880(%r12), %eax
	andl	$7, %ebp
	addl	$3, %ebp
	cmpb	%al, %bpl
	jge	.L196
.L180:
	movl	watchdog_flag(%rip), %eax
	movl	(%rbx), %r13d
	testl	%eax, %eax
	je	.L197
	movl	$360, %edi
	movl	$0, watchdog_flag(%rip)
	call	alarm
	movzbl	2147450880(%r12), %eax
	cmpb	%al, %bpl
	jge	.L198
.L182:
	movl	%r13d, (%rbx)
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%rbp
	.cfi_def_cfa_offset 24
	popq	%r12
	.cfi_def_cfa_offset 16
	popq	%r13
	.cfi_def_cfa_offset 8
	ret
.L196:
	.cfi_restore_state
	testb	%al, %al
	je	.L180
	movq	%rbx, %rdi
	call	__asan_report_load4
.L198:
	testb	%al, %al
	je	.L182
	movq	%rbx, %rdi
	call	__asan_report_store4
.L197:
	movl	$.LC9, %edi
	call	chdir
	call	__asan_handle_no_return
	call	abort
	.cfi_endproc
.LFE7:
	.size	handle_alrm, .-handle_alrm
	.section	.rodata.str1.1
.LC10:
	.string	"handle_chld 1 32 4 6 status "
	.section	.rodata
	.align 32
.LC11:
	.string	"child wait - %m"
	.zero	48
	.text
	.p2align 4,,15
	.type	handle_chld, @function
handle_chld:
.LFB3:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$120, %rsp
	.cfi_def_cfa_offset 176
	leaq	16(%rsp), %rbp
	movq	$1102416563, 16(%rsp)
	movq	$.LC10, 24(%rsp)
	shrq	$3, %rbp
	leaq	2147450880(%rbp), %r13
	movl	$-235802127, 2147450880(%rbp)
	movl	$-185273340, 4(%r13)
	movl	$-202116109, 8(%r13)
	call	__errno_location
	movq	%rax, %r14
	movq	%rax, %rbx
	shrq	$3, %r14
	movq	%rbx, %r12
	movzbl	2147450880(%r14), %eax
	andl	$7, %r12d
	leaq	2147450880(%r14), %r15
	addl	$3, %r12d
	cmpb	%al, %r12b
	jge	.L251
.L200:
	movl	(%rbx), %eax
	movl	%eax, 12(%rsp)
	.p2align 4,,10
	.p2align 3
.L201:
	leaq	48(%rsp), %rsi
	movl	$1, %edx
	movl	$-1, %edi
	call	waitpid
	testl	%eax, %eax
	je	.L202
	js	.L252
	movq	hs(%rip), %rax
	testq	%rax, %rax
	je	.L201
	leaq	36(%rax), %rdi
	movq	%rdi, %rdx
	movq	%rdi, %rcx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	setne	%r8b
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L253
.L207:
	movl	36(%rax), %esi
	subl	$1, %esi
	js	.L208
	movl	%esi, 36(%rax)
	jmp	.L201
	.p2align 4,,10
	.p2align 3
.L252:
	movzbl	(%r15), %eax
	cmpb	%al, %r12b
	jge	.L254
.L204:
	movl	(%rbx), %eax
	cmpl	$11, %eax
	je	.L201
	cmpl	$4, %eax
	je	.L201
	cmpl	$10, %eax
	je	.L206
	movl	$.LC11, %esi
	movl	$3, %edi
	xorl	%eax, %eax
	call	syslog
.L202:
	movzbl	2147450880(%r14), %eax
	cmpb	%al, %r12b
	jge	.L255
.L206:
	movl	12(%rsp), %eax
	movl	%eax, (%rbx)
	movq	$0, 2147450880(%rbp)
	movl	$0, 8(%r13)
	addq	$120, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L208:
	.cfi_restore_state
	testb	%r8b, %r8b
	jne	.L256
.L209:
	movl	$0, 36(%rax)
	jmp	.L201
.L255:
	testb	%al, %al
	je	.L206
	movq	%rbx, %rdi
	call	__asan_report_store4
	.p2align 4,,10
	.p2align 3
.L253:
	testb	%r8b, %r8b
	je	.L207
	call	__asan_report_load4
	.p2align 4,,10
	.p2align 3
.L251:
	testb	%al, %al
	je	.L200
	movq	%rbx, %rdi
	call	__asan_report_load4
	.p2align 4,,10
	.p2align 3
.L254:
	testb	%al, %al
	je	.L204
	movq	%rbx, %rdi
	call	__asan_report_load4
	.p2align 4,,10
	.p2align 3
.L256:
	cmpb	%cl, %dl
	jg	.L209
	call	__asan_report_store4
	.cfi_endproc
.LFE3:
	.size	handle_chld, .-handle_chld
	.section	.rodata
	.align 32
.LC12:
	.string	"out of memory copying a string"
	.zero	33
	.align 32
.LC13:
	.string	"%s: out of memory copying a string\n"
	.zero	60
	.text
	.p2align 4,,15
	.type	e_strdup, @function
e_strdup:
.LFB15:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	strdup
	testq	%rax, %rax
	je	.L260
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L260:
	.cfi_restore_state
	movl	$.LC12, %esi
	movl	$2, %edi
	call	syslog
	movq	stderr(%rip), %rdi
	movq	argv0(%rip), %rdx
	movl	$.LC13, %esi
	xorl	%eax, %eax
	call	fprintf
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
	.cfi_endproc
.LFE15:
	.size	e_strdup, .-e_strdup
	.section	.rodata.str1.1
.LC14:
	.string	"read_config 1 32 100 4 line "
	.section	.rodata
	.align 32
.LC15:
	.string	"r"
	.zero	62
	.align 32
.LC16:
	.string	" \t\n\r"
	.zero	59
	.align 32
.LC17:
	.string	"debug"
	.zero	58
	.align 32
.LC18:
	.string	"port"
	.zero	59
	.align 32
.LC19:
	.string	"dir"
	.zero	60
	.align 32
.LC20:
	.string	"chroot"
	.zero	57
	.align 32
.LC21:
	.string	"nochroot"
	.zero	55
	.align 32
.LC22:
	.string	"data_dir"
	.zero	55
	.align 32
.LC23:
	.string	"symlink"
	.zero	56
	.align 32
.LC24:
	.string	"nosymlink"
	.zero	54
	.align 32
.LC25:
	.string	"symlinks"
	.zero	55
	.align 32
.LC26:
	.string	"nosymlinks"
	.zero	53
	.align 32
.LC27:
	.string	"user"
	.zero	59
	.align 32
.LC28:
	.string	"cgipat"
	.zero	57
	.align 32
.LC29:
	.string	"cgilimit"
	.zero	55
	.align 32
.LC30:
	.string	"urlpat"
	.zero	57
	.align 32
.LC31:
	.string	"noemptyreferers"
	.zero	48
	.align 32
.LC32:
	.string	"localpat"
	.zero	55
	.align 32
.LC33:
	.string	"throttles"
	.zero	54
	.align 32
.LC34:
	.string	"host"
	.zero	59
	.align 32
.LC35:
	.string	"logfile"
	.zero	56
	.align 32
.LC36:
	.string	"vhost"
	.zero	58
	.align 32
.LC37:
	.string	"novhost"
	.zero	56
	.align 32
.LC38:
	.string	"globalpasswd"
	.zero	51
	.align 32
.LC39:
	.string	"noglobalpasswd"
	.zero	49
	.align 32
.LC40:
	.string	"pidfile"
	.zero	56
	.align 32
.LC41:
	.string	"charset"
	.zero	56
	.align 32
.LC42:
	.string	"p3p"
	.zero	60
	.align 32
.LC43:
	.string	"max_age"
	.zero	56
	.align 32
.LC44:
	.string	"%s: unknown config option '%s'\n"
	.zero	32
	.text
	.p2align 4,,15
	.type	read_config, @function
read_config:
.LFB12:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	movl	$.LC15, %esi
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	movq	%rdi, %rbx
	subq	$200, %rsp
	.cfi_def_cfa_offset 256
	movq	%rsp, %r12
	movq	$1102416563, (%rsp)
	movq	$.LC14, 8(%rsp)
	shrq	$3, %r12
	leaq	2147450880(%r12), %r13
	movl	$-235802127, 2147450880(%r12)
	movl	$-185273340, 16(%r13)
	movl	$-202116109, 20(%r13)
	call	fopen
	testq	%rax, %rax
	movq	%rax, %r14
	je	.L347
.L263:
	leaq	32(%rsp), %rdi
	movq	%r14, %rdx
	movl	$1000, %esi
	call	fgets
	testq	%rax, %rax
	je	.L348
	leaq	32(%rsp), %rdi
	movl	$35, %esi
	call	strchr
	testq	%rax, %rax
	je	.L264
	movq	%rax, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	jne	.L349
.L265:
	movb	$0, (%rax)
.L264:
	leaq	32(%rsp), %rdi
	movl	$.LC16, %esi
	call	strspn
	leaq	32(%rsp), %rcx
	leaq	(%rcx,%rax), %rbp
	movq	%rbp, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	jne	.L350
	.p2align 4,,10
	.p2align 3
.L266:
	cmpb	$0, 0(%rbp)
	je	.L263
	movl	$.LC16, %esi
	movq	%rbp, %rdi
	call	strcspn
	leaq	0(%rbp,%rax), %rbx
	jmp	.L269
	.p2align 4,,10
	.p2align 3
.L271:
	movb	$0, (%rbx)
	addq	$1, %rbx
.L269:
	movq	%rbx, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	jne	.L351
.L270:
	movzbl	(%rbx), %esi
	cmpb	$32, %sil
	je	.L271
	leal	-9(%rsi), %eax
	cmpb	$1, %al
	jbe	.L271
	cmpb	$13, %sil
	je	.L271
	movl	$61, %esi
	movq	%rbp, %rdi
	call	strchr
	testq	%rax, %rax
	je	.L306
	movq	%rax, %rdx
	leaq	1(%rax), %r15
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	jne	.L352
.L273:
	movb	$0, (%rax)
.L272:
	movl	$.LC17, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L353
	movl	$.LC18, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L354
	movl	$.LC19, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L355
	movl	$.LC20, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L356
	movl	$.LC21, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L357
	movl	$.LC22, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L358
	movl	$.LC23, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L345
	movl	$.LC24, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L346
	movl	$.LC25, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L345
	movl	$.LC26, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L346
	movl	$.LC27, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L359
	movl	$.LC28, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L360
	movl	$.LC29, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L361
	movl	$.LC30, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L362
	movl	$.LC31, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L363
	movl	$.LC32, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L364
	movl	$.LC33, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L365
	movl	$.LC34, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L366
	movl	$.LC35, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L367
	movl	$.LC36, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L368
	movl	$.LC37, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L369
	movl	$.LC38, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L370
	movl	$.LC39, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L371
	movl	$.LC40, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L372
	movl	$.LC41, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L373
	movl	$.LC42, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L374
	movl	$.LC43, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	jne	.L301
	movq	%r15, %rsi
	movq	%rbp, %rdi
	call	value_required
	movq	%r15, %rdi
	call	atoi
	movl	%eax, max_age(%rip)
	.p2align 4,,10
	.p2align 3
.L275:
	movl	$.LC16, %esi
	movq	%rbx, %rdi
	call	strspn
	leaq	(%rbx,%rax), %rbp
	movq	%rbp, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L266
	movq	%rbp, %rdx
	andl	$7, %edx
	cmpb	%dl, %al
	jg	.L266
	movq	%rbp, %rdi
	call	__asan_report_load1
	.p2align 4,,10
	.p2align 3
.L353:
	movq	%r15, %rsi
	movq	%rbp, %rdi
	call	no_value_required
	movl	$1, debug(%rip)
	jmp	.L275
.L354:
	movq	%r15, %rsi
	movq	%rbp, %rdi
	call	value_required
	movq	%r15, %rdi
	call	atoi
	movw	%ax, port(%rip)
	jmp	.L275
.L306:
	xorl	%r15d, %r15d
	jmp	.L272
.L355:
	movq	%r15, %rsi
	movq	%rbp, %rdi
	call	value_required
	movq	%r15, %rdi
	call	e_strdup
	movq	%rax, dir(%rip)
	jmp	.L275
.L356:
	movq	%r15, %rsi
	movq	%rbp, %rdi
	call	no_value_required
	movl	$1, do_chroot(%rip)
	movl	$1, no_symlink_check(%rip)
	jmp	.L275
.L357:
	movq	%r15, %rsi
	movq	%rbp, %rdi
	call	no_value_required
	movl	$0, do_chroot(%rip)
	movl	$0, no_symlink_check(%rip)
	jmp	.L275
.L345:
	movq	%r15, %rsi
	movq	%rbp, %rdi
	call	no_value_required
	movl	$0, no_symlink_check(%rip)
	jmp	.L275
.L358:
	movq	%r15, %rsi
	movq	%rbp, %rdi
	call	value_required
	movq	%r15, %rdi
	call	e_strdup
	movq	%rax, data_dir(%rip)
	jmp	.L275
.L346:
	movq	%r15, %rsi
	movq	%rbp, %rdi
	call	no_value_required
	movl	$1, no_symlink_check(%rip)
	jmp	.L275
.L351:
	movq	%rbx, %rdx
	andl	$7, %edx
	cmpb	%dl, %al
	jg	.L270
	movq	%rbx, %rdi
	call	__asan_report_load1
	.p2align 4,,10
	.p2align 3
.L359:
	movq	%r15, %rsi
	movq	%rbp, %rdi
	call	value_required
	movq	%r15, %rdi
	call	e_strdup
	movq	%rax, user(%rip)
	jmp	.L275
.L361:
	movq	%r15, %rsi
	movq	%rbp, %rdi
	call	value_required
	movq	%r15, %rdi
	call	atoi
	movl	%eax, cgi_limit(%rip)
	jmp	.L275
.L360:
	movq	%r15, %rsi
	movq	%rbp, %rdi
	call	value_required
	movq	%r15, %rdi
	call	e_strdup
	movq	%rax, cgi_pattern(%rip)
	jmp	.L275
.L348:
	movq	%r14, %rdi
	call	fclose
	movl	$0, 2147450880(%r12)
	movq	$0, 16(%r13)
	addq	$200, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
.L363:
	.cfi_restore_state
	movq	%r15, %rsi
	movq	%rbp, %rdi
	call	no_value_required
	movl	$1, no_empty_referers(%rip)
	jmp	.L275
.L362:
	movq	%r15, %rsi
	movq	%rbp, %rdi
	call	value_required
	movq	%r15, %rdi
	call	e_strdup
	movq	%rax, url_pattern(%rip)
	jmp	.L275
.L364:
	movq	%r15, %rsi
	movq	%rbp, %rdi
	call	value_required
	movq	%r15, %rdi
	call	e_strdup
	movq	%rax, local_pattern(%rip)
	jmp	.L275
.L365:
	movq	%r15, %rsi
	movq	%rbp, %rdi
	call	value_required
	movq	%r15, %rdi
	call	e_strdup
	movq	%rax, throttlefile(%rip)
	jmp	.L275
.L347:
	movq	%rbx, %rdi
	call	perror
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L349:
	movq	%rax, %rcx
	andl	$7, %ecx
	cmpb	%cl, %dl
	jg	.L265
	movq	%rax, %rdi
	call	__asan_report_store1
.L367:
	movq	%r15, %rsi
	movq	%rbp, %rdi
	call	value_required
	movq	%r15, %rdi
	call	e_strdup
	movq	%rax, logfile(%rip)
	jmp	.L275
.L366:
	movq	%r15, %rsi
	movq	%rbp, %rdi
	call	value_required
	movq	%r15, %rdi
	call	e_strdup
	movq	%rax, hostname(%rip)
	jmp	.L275
.L350:
	movq	%rbp, %rdx
	andl	$7, %edx
	cmpb	%dl, %al
	jg	.L266
	movq	%rbp, %rdi
	call	__asan_report_load1
.L352:
	movq	%rax, %rcx
	andl	$7, %ecx
	cmpb	%cl, %dl
	jg	.L273
	movq	%rax, %rdi
	call	__asan_report_store1
.L301:
	movq	stderr(%rip), %rdi
	movq	argv0(%rip), %rdx
	movq	%rbp, %rcx
	movl	$.LC44, %esi
	xorl	%eax, %eax
	call	fprintf
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L374:
	movq	%r15, %rsi
	movq	%rbp, %rdi
	call	value_required
	movq	%r15, %rdi
	call	e_strdup
	movq	%rax, p3p(%rip)
	jmp	.L275
.L373:
	movq	%r15, %rsi
	movq	%rbp, %rdi
	call	value_required
	movq	%r15, %rdi
	call	e_strdup
	movq	%rax, charset(%rip)
	jmp	.L275
.L372:
	movq	%r15, %rsi
	movq	%rbp, %rdi
	call	value_required
	movq	%r15, %rdi
	call	e_strdup
	movq	%rax, pidfile(%rip)
	jmp	.L275
.L371:
	movq	%r15, %rsi
	movq	%rbp, %rdi
	call	no_value_required
	movl	$0, do_global_passwd(%rip)
	jmp	.L275
.L370:
	movq	%r15, %rsi
	movq	%rbp, %rdi
	call	no_value_required
	movl	$1, do_global_passwd(%rip)
	jmp	.L275
.L369:
	movq	%r15, %rsi
	movq	%rbp, %rdi
	call	no_value_required
	movl	$0, do_vhost(%rip)
	jmp	.L275
.L368:
	movq	%r15, %rsi
	movq	%rbp, %rdi
	call	no_value_required
	movl	$1, do_vhost(%rip)
	jmp	.L275
	.cfi_endproc
.LFE12:
	.size	read_config, .-read_config
	.section	.rodata
	.align 32
.LC45:
	.string	"nobody"
	.zero	57
	.align 32
.LC46:
	.string	"iso-8859-1"
	.zero	53
	.align 32
.LC47:
	.string	""
	.zero	63
	.align 32
.LC48:
	.string	"-V"
	.zero	61
	.align 32
.LC49:
	.string	"thttpd/2.27.0 Oct 3, 2014"
	.zero	38
	.align 32
.LC50:
	.string	"-C"
	.zero	61
	.align 32
.LC51:
	.string	"-p"
	.zero	61
	.align 32
.LC52:
	.string	"-d"
	.zero	61
	.align 32
.LC53:
	.string	"-r"
	.zero	61
	.align 32
.LC54:
	.string	"-nor"
	.zero	59
	.align 32
.LC55:
	.string	"-dd"
	.zero	60
	.align 32
.LC56:
	.string	"-s"
	.zero	61
	.align 32
.LC57:
	.string	"-nos"
	.zero	59
	.align 32
.LC58:
	.string	"-u"
	.zero	61
	.align 32
.LC59:
	.string	"-c"
	.zero	61
	.align 32
.LC60:
	.string	"-t"
	.zero	61
	.align 32
.LC61:
	.string	"-h"
	.zero	61
	.align 32
.LC62:
	.string	"-l"
	.zero	61
	.align 32
.LC63:
	.string	"-v"
	.zero	61
	.align 32
.LC64:
	.string	"-nov"
	.zero	59
	.align 32
.LC65:
	.string	"-g"
	.zero	61
	.align 32
.LC66:
	.string	"-nog"
	.zero	59
	.align 32
.LC67:
	.string	"-i"
	.zero	61
	.align 32
.LC68:
	.string	"-T"
	.zero	61
	.align 32
.LC69:
	.string	"-P"
	.zero	61
	.align 32
.LC70:
	.string	"-M"
	.zero	61
	.align 32
.LC71:
	.string	"-D"
	.zero	61
	.text
	.p2align 4,,15
	.type	parse_args, @function
parse_args:
.LFB10:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	movl	$80, %eax
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	movl	%edi, %r14d
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$24, %rsp
	.cfi_def_cfa_offset 80
	cmpl	$1, %edi
	movl	$0, debug(%rip)
	movw	%ax, port(%rip)
	movq	$0, dir(%rip)
	movq	$0, data_dir(%rip)
	movl	$0, do_chroot(%rip)
	movl	$0, no_log(%rip)
	movl	$0, no_symlink_check(%rip)
	movl	$0, do_vhost(%rip)
	movl	$0, do_global_passwd(%rip)
	movq	$0, cgi_pattern(%rip)
	movl	$0, cgi_limit(%rip)
	movq	$0, url_pattern(%rip)
	movl	$0, no_empty_referers(%rip)
	movq	$0, local_pattern(%rip)
	movq	$0, throttlefile(%rip)
	movq	$0, hostname(%rip)
	movq	$0, logfile(%rip)
	movq	$0, pidfile(%rip)
	movq	$.LC45, user(%rip)
	movq	$.LC46, charset(%rip)
	movq	$.LC47, p3p(%rip)
	movl	$-1, max_age(%rip)
	jle	.L420
	leaq	8(%rsi), %rdi
	movq	%rsi, %r15
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L434
	movq	8(%rsi), %rbx
	movq	%rbx, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	jne	.L435
.L378:
	cmpb	$45, (%rbx)
	jne	.L416
	movl	$1, %ebp
	movl	$.LC48, %r13d
	movl	$3, %r12d
	jmp	.L419
	.p2align 4,,10
	.p2align 3
.L441:
	leal	1(%rbp), %edx
	cmpl	%edx, %r14d
	jle	.L384
	movslq	%edx, %rax
	leaq	(%r15,%rax,8), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L436
	movq	(%rdi), %rdi
	movl	%edx, 12(%rsp)
	call	atoi
	movl	12(%rsp), %edx
	movw	%ax, port(%rip)
	movl	%edx, %ebp
.L383:
	addl	$1, %ebp
	cmpl	%ebp, %r14d
	jle	.L376
.L443:
	movslq	%ebp, %rax
	leaq	(%r15,%rax,8), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L437
	movq	(%rdi), %rbx
	movq	%rbx, %rax
	movq	%rbx, %rdx
	shrq	$3, %rax
	andl	$7, %edx
	movzbl	2147450880(%rax), %eax
	cmpb	%dl, %al
	jle	.L438
.L418:
	cmpb	$45, (%rbx)
	jne	.L416
.L419:
	movq	%rbx, %rsi
	movq	%r13, %rdi
	movq	%r12, %rcx
	repz cmpsb
	je	.L439
	movl	$.LC50, %edi
	movq	%rbx, %rsi
	movq	%r12, %rcx
	repz cmpsb
	jne	.L381
	leal	1(%rbp), %eax
	cmpl	%eax, %r14d
	jg	.L440
.L381:
	movl	$.LC51, %edi
	movq	%rbx, %rsi
	movq	%r12, %rcx
	repz cmpsb
	je	.L441
.L384:
	movl	$.LC52, %edi
	movq	%rbx, %rsi
	movq	%r12, %rcx
	repz cmpsb
	jne	.L386
	leal	1(%rbp), %eax
	cmpl	%eax, %r14d
	jle	.L386
	movslq	%eax, %rdx
	leaq	(%r15,%rdx,8), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L442
	movq	(%rdi), %rdx
	movl	%eax, %ebp
	addl	$1, %ebp
	cmpl	%ebp, %r14d
	movq	%rdx, dir(%rip)
	jg	.L443
.L376:
	cmpl	%r14d, %ebp
	jne	.L416
	addq	$24, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L386:
	.cfi_restore_state
	movl	$.LC53, %edi
	movq	%rbx, %rsi
	movq	%r12, %rcx
	repz cmpsb
	jne	.L388
	movl	$1, do_chroot(%rip)
	movl	$1, no_symlink_check(%rip)
	jmp	.L383
	.p2align 4,,10
	.p2align 3
.L388:
	movl	$.LC54, %edi
	movl	$5, %ecx
	movq	%rbx, %rsi
	repz cmpsb
	jne	.L389
	movl	$0, do_chroot(%rip)
	movl	$0, no_symlink_check(%rip)
	jmp	.L383
	.p2align 4,,10
	.p2align 3
.L440:
	movslq	%eax, %rdx
	leaq	(%r15,%rdx,8), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L444
	movq	(%rdi), %rdi
	movl	%eax, 12(%rsp)
	call	read_config
	movl	12(%rsp), %eax
	movl	%eax, %ebp
	jmp	.L383
	.p2align 4,,10
	.p2align 3
.L389:
	movl	$.LC55, %edi
	movl	$4, %ecx
	movq	%rbx, %rsi
	repz cmpsb
	jne	.L390
	leal	1(%rbp), %eax
	cmpl	%eax, %r14d
	jle	.L390
	movslq	%eax, %rdx
	leaq	(%r15,%rdx,8), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L445
	movq	(%rdi), %rdx
	movl	%eax, %ebp
	movq	%rdx, data_dir(%rip)
	jmp	.L383
	.p2align 4,,10
	.p2align 3
.L390:
	movl	$.LC56, %edi
	movq	%rbx, %rsi
	movq	%r12, %rcx
	repz cmpsb
	jne	.L392
	movl	$0, no_symlink_check(%rip)
	jmp	.L383
	.p2align 4,,10
	.p2align 3
.L392:
	movl	$.LC57, %edi
	movl	$5, %ecx
	movq	%rbx, %rsi
	repz cmpsb
	je	.L446
	movl	$.LC58, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L394
	leal	1(%rbp), %eax
	cmpl	%eax, %r14d
	jle	.L394
	movslq	%eax, %rdx
	leaq	(%r15,%rdx,8), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L447
	movq	(%rdi), %rdx
	movl	%eax, %ebp
	movq	%rdx, user(%rip)
	jmp	.L383
.L446:
	movl	$1, no_symlink_check(%rip)
	jmp	.L383
.L394:
	movl	$.LC59, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L396
	leal	1(%rbp), %eax
	cmpl	%eax, %r14d
	jle	.L396
	movslq	%eax, %rdx
	leaq	(%r15,%rdx,8), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L448
	movq	(%rdi), %rdx
	movl	%eax, %ebp
	movq	%rdx, cgi_pattern(%rip)
	jmp	.L383
.L396:
	movl	$.LC60, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L398
	leal	1(%rbp), %eax
	cmpl	%eax, %r14d
	jle	.L398
	movslq	%eax, %rdx
	leaq	(%r15,%rdx,8), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L449
	movq	(%rdi), %rdx
	movl	%eax, %ebp
	movq	%rdx, throttlefile(%rip)
	jmp	.L383
.L398:
	movl	$.LC61, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L400
	leal	1(%rbp), %eax
	cmpl	%eax, %r14d
	jle	.L400
	movslq	%eax, %rdx
	leaq	(%r15,%rdx,8), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L450
	movq	(%rdi), %rdx
	movl	%eax, %ebp
	movq	%rdx, hostname(%rip)
	jmp	.L383
.L400:
	movl	$.LC62, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L402
	leal	1(%rbp), %eax
	cmpl	%eax, %r14d
	jle	.L402
	movslq	%eax, %rdx
	leaq	(%r15,%rdx,8), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L451
	movq	(%rdi), %rdx
	movl	%eax, %ebp
	movq	%rdx, logfile(%rip)
	jmp	.L383
.L402:
	movl	$.LC63, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L404
	movl	$1, do_vhost(%rip)
	jmp	.L383
.L404:
	movl	$.LC64, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	je	.L452
	movl	$.LC65, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L406
	movl	$1, do_global_passwd(%rip)
	jmp	.L383
.L452:
	movl	$0, do_vhost(%rip)
	jmp	.L383
.L420:
	movl	$1, %ebp
	jmp	.L376
.L406:
	movl	$.LC66, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L407
	movl	$0, do_global_passwd(%rip)
	jmp	.L383
.L438:
	testb	%al, %al
	je	.L418
	movq	%rbx, %rdi
	call	__asan_report_load1
.L439:
	movl	$.LC49, %edi
	call	puts
	call	__asan_handle_no_return
	xorl	%edi, %edi
	call	exit
.L407:
	movl	$.LC67, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L408
	leal	1(%rbp), %eax
	cmpl	%eax, %r14d
	jle	.L408
	movslq	%eax, %rdx
	leaq	(%r15,%rdx,8), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L453
	movq	(%rdi), %rdx
	movl	%eax, %ebp
	movq	%rdx, pidfile(%rip)
	jmp	.L383
.L408:
	movl	$.LC68, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L410
	leal	1(%rbp), %eax
	cmpl	%eax, %r14d
	jle	.L410
	movslq	%eax, %rdx
	leaq	(%r15,%rdx,8), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L454
	movq	(%rdi), %rdx
	movl	%eax, %ebp
	movq	%rdx, charset(%rip)
	jmp	.L383
.L410:
	movl	$.LC69, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L412
	leal	1(%rbp), %eax
	cmpl	%eax, %r14d
	jle	.L412
	movslq	%eax, %rdx
	leaq	(%r15,%rdx,8), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L455
	movq	(%rdi), %rdx
	movl	%eax, %ebp
	movq	%rdx, p3p(%rip)
	jmp	.L383
.L412:
	movl	$.LC70, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L414
	leal	1(%rbp), %edx
	cmpl	%edx, %r14d
	jle	.L414
	movslq	%edx, %rax
	leaq	(%r15,%rax,8), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L456
	movq	(%rdi), %rdi
	movl	%edx, 12(%rsp)
	call	atoi
	movl	12(%rsp), %edx
	movl	%eax, max_age(%rip)
	movl	%edx, %ebp
	jmp	.L383
.L414:
	movl	$.LC71, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L416
	movl	$1, debug(%rip)
	jmp	.L383
.L456:
	call	__asan_report_load8
.L449:
	call	__asan_report_load8
.L448:
	.p2align 4,,5
	call	__asan_report_load8
.L444:
	.p2align 4,,5
	call	__asan_report_load8
.L442:
	.p2align 4,,5
	call	__asan_report_load8
.L445:
	.p2align 4,,5
	call	__asan_report_load8
.L434:
	.p2align 4,,5
	call	__asan_report_load8
.L437:
	.p2align 4,,5
	call	__asan_report_load8
.L436:
	.p2align 4,,5
	call	__asan_report_load8
.L447:
	.p2align 4,,5
	call	__asan_report_load8
.L451:
	.p2align 4,,5
	call	__asan_report_load8
.L416:
	.p2align 4,,5
	call	__asan_handle_no_return
	.p2align 4,,5
	call	usage
.L435:
	movq	%rbx, %rdx
	andl	$7, %edx
	cmpb	%dl, %al
	jg	.L378
	movq	%rbx, %rdi
	call	__asan_report_load1
.L450:
	call	__asan_report_load8
.L453:
	call	__asan_report_load8
.L454:
	.p2align 4,,5
	call	__asan_report_load8
.L455:
	.p2align 4,,5
	call	__asan_report_load8
	.cfi_endproc
.LFE10:
	.size	parse_args, .-parse_args
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC72:
	.string	"read_throttlefile 5 32 8 9 max_limit 96 8 9 min_limit 160 16 2 tv 224 5000 3 buf 5280 5000 7 pattern "
	.section	.rodata
	.align 32
.LC73:
	.string	"%.80s - %m"
	.zero	53
	.align 32
.LC74:
	.string	" %4900[^ \t] %ld-%ld"
	.zero	44
	.align 32
.LC75:
	.string	" %4900[^ \t] %ld"
	.zero	48
	.align 32
.LC76:
	.string	"unparsable line in %.80s - %.80s"
	.zero	63
	.align 32
.LC77:
	.string	"%s: unparsable line in %.80s - %.80s\n"
	.zero	58
	.align 32
.LC78:
	.string	"|/"
	.zero	61
	.align 32
.LC79:
	.string	"out of memory allocating a throttletab"
	.zero	57
	.align 32
.LC80:
	.string	"%s: out of memory allocating a throttletab\n"
	.zero	52
	.text
	.p2align 4,,15
	.type	read_throttlefile, @function
read_throttlefile:
.LFB17:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	movl	$.LC15, %esi
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$10392, %rsp
	.cfi_def_cfa_offset 10448
	leaq	48(%rsp), %rax
	movq	%rdi, 32(%rsp)
	movq	$1102416563, 48(%rsp)
	movq	$.LC72, 56(%rsp)
	movq	%rax, 40(%rsp)
	shrq	$3, 40(%rsp)
	movq	40(%rsp), %rax
	leaq	2147450880(%rax), %r15
	movl	$-235802127, 2147450880(%rax)
	movl	$-185273344, 4(%r15)
	movl	$-218959118, 8(%r15)
	movl	$-185273344, 12(%r15)
	movl	$-218959118, 16(%r15)
	movl	$-185335808, 20(%r15)
	movl	$-218959118, 24(%r15)
	movl	$-185273344, 652(%r15)
	movl	$-218959118, 656(%r15)
	movl	$-185273344, 1284(%r15)
	movl	$-202116109, 1288(%r15)
	call	fopen
	testq	%rax, %rax
	movq	%rax, %r12
	je	.L554
	leaq	5328(%rsp), %rbp
	leaq	208(%rsp), %rdi
	xorl	%esi, %esi
	leaq	272(%rsp), %rbx
	call	gettimeofday
	movq	%rbp, %rax
	movq	%rbx, %r14
	movq	%rbx, %r13
	shrq	$3, %rax
	shrq	$3, %r14
	andl	$7, %r13d
	addq	$2147450880, %rax
	addq	$2147450880, %r14
	movq	%rax, 16(%rsp)
	movq	%rbp, %rax
	andl	$7, %eax
	movq	%rax, 24(%rsp)
	.p2align 4,,10
	.p2align 3
.L475:
	movq	%r12, %rdx
	movl	$5000, %esi
	movq	%rbx, %rdi
	call	fgets
	testq	%rax, %rax
	je	.L555
	movl	$35, %esi
	movq	%rbx, %rdi
	call	strchr
	testq	%rax, %rax
	je	.L460
	movq	%rax, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	jne	.L556
.L461:
	movb	$0, (%rax)
.L460:
	movzbl	(%r14), %eax
	cmpb	%r13b, %al
	jle	.L557
.L462:
	movq	%rbx, %rdx
.L463:
	movl	(%rdx), %ecx
	addq	$4, %rdx
	leal	-16843009(%rcx), %eax
	notl	%ecx
	andl	%ecx, %eax
	andl	$-2139062144, %eax
	je	.L463
	movl	%eax, %ecx
	shrl	$16, %ecx
	testl	$32896, %eax
	cmove	%ecx, %eax
	leaq	2(%rdx), %rcx
	cmove	%rcx, %rdx
	addb	%al, %al
	sbbq	$3, %rdx
	subq	%rbx, %rdx
	leaq	(%rbx,%rdx), %rdi
	movq	%rdi, %rax
	movq	%rdi, %rcx
	shrq	$3, %rax
	andl	$7, %ecx
	movzbl	2147450880(%rax), %eax
	cmpb	%cl, %al
	jle	.L558
.L465:
	cmpl	$0, %edx
	movl	%edx, %eax
	jle	.L466
	movslq	%edx, %rdx
	leaq	-1(%rbx,%rdx), %rdi
	jmp	.L467
	.p2align 4,,10
	.p2align 3
.L560:
	leal	-9(%rsi), %r10d
	cmpb	$1, %r10b
	jbe	.L471
	cmpb	$13, %sil
	jne	.L474
.L468:
	subq	$1, %rdi
	testl	%eax, %eax
	movb	$0, 272(%rsp,%rcx)
	je	.L475
.L467:
	movq	%rdi, %rdx
	subl	$1, %eax
	movq	%rdi, %r8
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	setne	%r9b
	andl	$7, %r8d
	cmpb	%r8b, %dl
	jle	.L559
.L470:
	movslq	%eax, %rcx
	movzbl	272(%rsp,%rcx), %esi
	cmpb	$32, %sil
	jne	.L560
.L471:
	cmpb	%r8b, %dl
	jg	.L468
	testb	%r9b, %r9b
	je	.L468
	.p2align 4,,5
	call	__asan_report_store1
	.p2align 4,,10
	.p2align 3
.L466:
	je	.L475
	.p2align 4,,10
	.p2align 3
.L474:
	leaq	80(%rsp), %r8
	leaq	144(%rsp), %rcx
	xorl	%eax, %eax
	movq	%rbp, %rdx
	movl	$.LC74, %esi
	movq	%rbx, %rdi
	call	__isoc99_sscanf
	cmpl	$3, %eax
	je	.L472
	leaq	80(%rsp), %rcx
	xorl	%eax, %eax
	movq	%rbp, %rdx
	movl	$.LC75, %esi
	movq	%rbx, %rdi
	call	__isoc99_sscanf
	cmpl	$2, %eax
	jne	.L476
	movq	$0, 144(%rsp)
.L472:
	movq	16(%rsp), %rax
	movzbl	(%rax), %eax
	cmpb	24(%rsp), %al
	jle	.L561
.L478:
	cmpb	$47, 5328(%rsp)
	jne	.L480
	jmp	.L569
	.p2align 4,,10
	.p2align 3
.L481:
	leaq	2(%rax), %rsi
	leaq	1(%rax), %rdi
	call	strcpy
.L480:
	movl	$.LC78, %esi
	movq	%rbp, %rdi
	call	strstr
	testq	%rax, %rax
	jne	.L481
	movslq	numthrottles(%rip), %rcx
	movl	maxthrottles(%rip), %eax
	cmpl	%eax, %ecx
	jl	.L482
	testl	%eax, %eax
	jne	.L483
	movl	$4800, %edi
	movl	$100, maxthrottles(%rip)
	call	malloc
	movq	%rax, throttles(%rip)
.L484:
	testq	%rax, %rax
	je	.L485
	movslq	numthrottles(%rip), %rcx
.L486:
	leaq	(%rcx,%rcx,2), %rdx
	movq	%rbp, %rdi
	salq	$4, %rdx
	addq	%rax, %rdx
	movq	%rdx, 8(%rsp)
	call	e_strdup
	movq	8(%rsp), %rdx
	movq	%rdx, %rcx
	shrq	$3, %rcx
	cmpb	$0, 2147450880(%rcx)
	jne	.L563
	movq	%rax, (%rdx)
	movl	numthrottles(%rip), %edx
	movq	80(%rsp), %rcx
	movslq	%edx, %rax
	leaq	(%rax,%rax,2), %rax
	salq	$4, %rax
	addq	throttles(%rip), %rax
	leaq	8(%rax), %rdi
	movq	%rdi, %rsi
	shrq	$3, %rsi
	cmpb	$0, 2147450880(%rsi)
	jne	.L564
	leaq	16(%rax), %rdi
	movq	%rcx, 8(%rax)
	movq	144(%rsp), %rcx
	movq	%rdi, %rsi
	shrq	$3, %rsi
	cmpb	$0, 2147450880(%rsi)
	jne	.L565
	leaq	24(%rax), %rdi
	movq	%rcx, 16(%rax)
	movq	%rdi, %rcx
	shrq	$3, %rcx
	cmpb	$0, 2147450880(%rcx)
	jne	.L566
	leaq	32(%rax), %rdi
	movq	$0, 24(%rax)
	movq	%rdi, %rcx
	shrq	$3, %rcx
	cmpb	$0, 2147450880(%rcx)
	jne	.L567
	leaq	40(%rax), %rdi
	movq	$0, 32(%rax)
	movq	%rdi, %rcx
	movq	%rdi, %rsi
	shrq	$3, %rcx
	andl	$7, %esi
	movzbl	2147450880(%rcx), %ecx
	addl	$3, %esi
	cmpb	%cl, %sil
	jge	.L568
.L492:
	addl	$1, %edx
	movl	$0, 40(%rax)
	movl	%edx, numthrottles(%rip)
	jmp	.L475
.L476:
	movq	32(%rsp), %rdx
	movq	%rbx, %rcx
	xorl	%eax, %eax
	movl	$.LC76, %esi
	movl	$2, %edi
	call	syslog
	movq	32(%rsp), %rcx
	movq	argv0(%rip), %rdx
	movq	%rbx, %r8
	movq	stderr(%rip), %rdi
	movl	$.LC77, %esi
	xorl	%eax, %eax
	call	fprintf
	jmp	.L475
.L483:
	addl	%eax, %eax
	movq	throttles(%rip), %rdi
	movl	%eax, maxthrottles(%rip)
	cltq
	leaq	(%rax,%rax,2), %rsi
	salq	$4, %rsi
	call	realloc
	movq	%rax, throttles(%rip)
	jmp	.L484
.L482:
	movq	throttles(%rip), %rax
	jmp	.L486
.L555:
	movq	%r12, %rdi
	call	fclose
	movq	40(%rsp), %rax
	movq	$0, 2147450880(%rax)
	movq	$0, 8(%r15)
	movq	$0, 16(%r15)
	movl	$0, 24(%r15)
	movq	$0, 652(%r15)
	movq	$0, 1284(%r15)
	addq	$10392, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
.L569:
	.cfi_restore_state
	leaq	1(%rbp), %rsi
	movq	%rbp, %rdi
	call	strcpy
	jmp	.L480
.L559:
	testb	%r9b, %r9b
	je	.L470
	.p2align 4,,8
	call	__asan_report_load1
.L554:
	movq	32(%rsp), %rbx
	movl	$.LC73, %esi
	xorl	%eax, %eax
	movl	$2, %edi
	movq	%rbx, %rdx
	call	syslog
	movq	%rbx, %rdi
	call	perror
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L568:
	testb	%cl, %cl
	je	.L492
	call	__asan_report_store4
.L567:
	.p2align 4,,6
	call	__asan_report_store8
.L566:
	.p2align 4,,5
	call	__asan_report_store8
.L557:
	testb	%al, %al
	.p2align 4,,3
	je	.L462
	movq	%rbx, %rdi
	call	__asan_report_load1
.L556:
	movq	%rax, %rcx
	andl	$7, %ecx
	cmpb	%cl, %dl
	jg	.L461
	movq	%rax, %rdi
	call	__asan_report_store1
.L558:
	testb	%al, %al
	je	.L465
	call	__asan_report_load1
.L561:
	testb	%al, %al
	.p2align 4,,4
	je	.L478
	movq	%rbp, %rdi
	call	__asan_report_load1
.L565:
	call	__asan_report_store8
.L564:
	call	__asan_report_store8
.L563:
	movq	%rdx, %rdi
	call	__asan_report_store8
.L485:
	movl	$.LC79, %esi
	movl	$2, %edi
	xorl	%eax, %eax
	call	syslog
	movq	stderr(%rip), %rdi
	movq	argv0(%rip), %rdx
	movl	$.LC80, %esi
	xorl	%eax, %eax
	call	fprintf
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
	.cfi_endproc
.LFE17:
	.size	read_throttlefile, .-read_throttlefile
	.section	.rodata
	.align 32
.LC81:
	.string	"-"
	.zero	62
	.align 32
.LC82:
	.string	"re-opening logfile"
	.zero	45
	.align 32
.LC83:
	.string	"a"
	.zero	62
	.align 32
.LC84:
	.string	"re-opening %.80s - %m"
	.zero	42
	.text
	.p2align 4,,15
	.type	re_open_logfile, @function
re_open_logfile:
.LFB8:
	.cfi_startproc
	movl	no_log(%rip), %eax
	testl	%eax, %eax
	jne	.L582
	cmpq	$0, hs(%rip)
	je	.L582
	movq	logfile(%rip), %rsi
	testq	%rsi, %rsi
	je	.L582
	movl	$.LC81, %edi
	movl	$2, %ecx
	repz cmpsb
	jne	.L583
.L582:
	rep ret
	.p2align 4,,10
	.p2align 3
.L583:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	xorl	%eax, %eax
	movl	$.LC82, %esi
	movl	$5, %edi
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	subq	$8, %rsp
	.cfi_def_cfa_offset 32
	call	syslog
	movq	logfile(%rip), %rdi
	movl	$.LC83, %esi
	call	fopen
	movq	logfile(%rip), %rbp
	movl	$384, %esi
	movq	%rax, %rbx
	movq	%rbp, %rdi
	call	chmod
	testl	%eax, %eax
	jne	.L574
	testq	%rbx, %rbx
	je	.L574
	movq	%rbx, %rdi
	call	fileno
	movl	$2, %esi
	movl	%eax, %edi
	movl	$1, %edx
	xorl	%eax, %eax
	call	fcntl
	movq	hs(%rip), %rdi
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	movq	%rbx, %rsi
	popq	%rbx
	.cfi_restore 3
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_restore 6
	.cfi_def_cfa_offset 8
	jmp	httpd_set_logfp
	.p2align 4,,10
	.p2align 3
.L574:
	.cfi_restore_state
	addq	$8, %rsp
	.cfi_def_cfa_offset 24
	movq	%rbp, %rdx
	movl	$.LC84, %esi
	popq	%rbx
	.cfi_restore 3
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_restore 6
	.cfi_def_cfa_offset 8
	movl	$2, %edi
	xorl	%eax, %eax
	jmp	syslog
	.cfi_endproc
.LFE8:
	.size	re_open_logfile, .-re_open_logfile
	.section	.rodata
	.align 32
.LC85:
	.string	"too many connections!"
	.zero	42
	.align 32
.LC86:
	.string	"the connects free list is messed up"
	.zero	60
	.align 32
.LC87:
	.string	"out of memory allocating an httpd_conn"
	.zero	57
	.text
	.p2align 4,,15
	.type	handle_newconnect, @function
handle_newconnect:
.LFB19:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	movq	%rdi, %rdx
	shrq	$3, %rdx
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	leaq	2147450880(%rdx), %rcx
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	movq	%rdi, %r13
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$24, %rsp
	.cfi_def_cfa_offset 80
	movl	num_connects(%rip), %eax
	movl	%esi, 4(%rsp)
	movq	%rcx, 8(%rsp)
.L610:
	cmpl	%eax, max_connects(%rip)
	jle	.L660
	movslq	first_free_connect(%rip), %rax
	cmpl	$-1, %eax
	je	.L587
	leaq	(%rax,%rax,8), %r15
	salq	$4, %r15
	addq	connects(%rip), %r15
	movq	%r15, %r12
	movq	%r15, %rbp
	shrq	$3, %r12
	andl	$7, %ebp
	movzbl	2147450880(%r12), %eax
	addl	$3, %ebp
	cmpb	%al, %bpl
	jge	.L661
.L588:
	movl	(%r15), %eax
	testl	%eax, %eax
	jne	.L587
	leaq	8(%r15), %r14
	movq	%r14, %rbx
	shrq	$3, %rbx
	cmpb	$0, 2147450880(%rbx)
	jne	.L662
	movq	8(%r15), %rdx
	testq	%rdx, %rdx
	je	.L663
.L591:
	movl	4(%rsp), %esi
	movq	hs(%rip), %rdi
	call	httpd_get_conn
	testl	%eax, %eax
	je	.L596
	cmpl	$2, %eax
	je	.L612
	movzbl	2147450880(%r12), %eax
	cmpb	%al, %bpl
	jge	.L664
.L597:
	leaq	4(%r15), %rdi
	movl	$1, (%r15)
	movq	%rdi, %rax
	movq	%rdi, %rdx
	shrq	$3, %rax
	andl	$7, %edx
	movzbl	2147450880(%rax), %eax
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L665
.L598:
	movl	4(%r15), %eax
	addl	$1, num_connects(%rip)
	movl	$-1, 4(%r15)
	movl	%eax, first_free_connect(%rip)
	movq	8(%rsp), %rax
	cmpb	$0, (%rax)
	jne	.L666
	leaq	88(%r15), %rdi
	movq	0(%r13), %rax
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L667
	leaq	96(%r15), %rdi
	movq	%rax, 88(%r15)
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L668
	leaq	104(%r15), %rdi
	movq	$0, 96(%r15)
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L669
	leaq	136(%r15), %rdi
	movq	$0, 104(%r15)
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L670
	leaq	56(%r15), %rdi
	movq	$0, 136(%r15)
	movq	%rdi, %rax
	movq	%rdi, %rdx
	shrq	$3, %rax
	andl	$7, %edx
	movzbl	2147450880(%rax), %eax
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L671
.L604:
	cmpb	$0, 2147450880(%rbx)
	movl	$0, 56(%r15)
	jne	.L672
	movq	8(%r15), %rax
	leaq	704(%rax), %rdi
	movq	%rdi, %rdx
	movq	%rdi, %rsi
	shrq	$3, %rdx
	andl	$7, %esi
	movzbl	2147450880(%rdx), %edx
	addl	$3, %esi
	cmpb	%dl, %sil
	jge	.L673
.L606:
	movl	704(%rax), %edi
	call	httpd_set_ndelay
	cmpb	$0, 2147450880(%rbx)
	jne	.L674
	movq	8(%r15), %rax
	leaq	704(%rax), %rdi
	movq	%rdi, %rdx
	movq	%rdi, %rsi
	shrq	$3, %rdx
	andl	$7, %esi
	movzbl	2147450880(%rdx), %edx
	addl	$3, %esi
	cmpb	%dl, %sil
	jge	.L675
.L608:
	movl	704(%rax), %edi
	xorl	%edx, %edx
	movq	%r15, %rsi
	call	fdwatch_add_fd
	addq	$1, stats_connections(%rip)
	movl	num_connects(%rip), %eax
	cmpl	stats_simultaneous(%rip), %eax
	jle	.L610
	movl	%eax, stats_simultaneous(%rip)
	jmp	.L610
	.p2align 4,,10
	.p2align 3
.L612:
	movl	$1, %eax
.L586:
	addq	$24, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L596:
	.cfi_restore_state
	movq	%r13, %rdi
	movl	%eax, 4(%rsp)
	call	tmr_run
	movl	4(%rsp), %eax
	addq	$24, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L663:
	.cfi_restore_state
	movl	$720, %edi
	call	malloc
	cmpb	$0, 2147450880(%rbx)
	jne	.L676
	testq	%rax, %rax
	movq	%rax, 8(%r15)
	je	.L677
	movq	%rax, %rdx
	movq	%rax, %rsi
	shrq	$3, %rdx
	andl	$7, %esi
	movzbl	2147450880(%rdx), %edx
	addl	$3, %esi
	cmpb	%dl, %sil
	jge	.L678
.L594:
	movl	$0, (%rax)
	addl	$1, httpd_conn_count(%rip)
	movq	%rax, %rdx
	jmp	.L591
	.p2align 4,,10
	.p2align 3
.L660:
	xorl	%eax, %eax
	movl	$.LC85, %esi
	movl	$4, %edi
	call	syslog
	movq	%r13, %rdi
	call	tmr_run
	xorl	%eax, %eax
	jmp	.L586
.L587:
	movl	$2, %edi
	movl	$.LC86, %esi
	xorl	%eax, %eax
	call	syslog
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L661:
	testb	%al, %al
	je	.L588
	movq	%r15, %rdi
	call	__asan_report_load4
.L673:
	testb	%dl, %dl
	je	.L606
	call	__asan_report_load4
.L677:
	movl	$2, %edi
	movl	$.LC87, %esi
	call	syslog
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L678:
	testb	%dl, %dl
	je	.L594
	movq	%rax, %rdi
	call	__asan_report_store4
.L675:
	testb	%dl, %dl
	je	.L608
	call	__asan_report_load4
.L664:
	testb	%al, %al
	.p2align 4,,4
	je	.L597
	movq	%r15, %rdi
	call	__asan_report_store4
.L665:
	testb	%al, %al
	je	.L598
	call	__asan_report_load4
.L671:
	testb	%al, %al
	.p2align 4,,4
	je	.L604
	.p2align 4,,6
	call	__asan_report_store4
.L669:
	.p2align 4,,6
	call	__asan_report_store8
.L670:
	.p2align 4,,5
	call	__asan_report_store8
.L672:
	movq	%r14, %rdi
	call	__asan_report_load8
.L674:
	movq	%r14, %rdi
	call	__asan_report_load8
.L666:
	movq	%r13, %rdi
	call	__asan_report_load8
.L676:
	movq	%r14, %rdi
	call	__asan_report_store8
.L667:
	call	__asan_report_store8
.L668:
	call	__asan_report_store8
.L662:
	movq	%r14, %rdi
	call	__asan_report_load8
	.cfi_endproc
.LFE19:
	.size	handle_newconnect, .-handle_newconnect
	.section	.rodata
	.align 32
.LC88:
	.string	"throttle sending count was negative - shouldn't happen!"
	.zero	40
	.text
	.p2align 4,,15
	.type	check_throttles, @function
check_throttles:
.LFB23:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	leaq	56(%rdi), %rax
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	movq	%rax, %r13
	andl	$7, %r13d
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	addl	$3, %r13d
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	movq	%rdi, %rbx
	subq	$72, %rsp
	.cfi_def_cfa_offset 128
	movq	%rax, 32(%rsp)
	shrq	$3, %rax
	leaq	2147450880(%rax), %r14
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	jne	.L759
.L680:
	leaq	72(%rbx), %rax
	movl	$0, 56(%rbx)
	movq	%rax, 40(%rsp)
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	leaq	2147450880(%rax), %rcx
	movq	%rcx, 16(%rsp)
	jne	.L760
	leaq	64(%rbx), %rax
	movq	$-1, 72(%rbx)
	movq	%rax, 48(%rsp)
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	leaq	2147450880(%rax), %rcx
	movq	%rcx, 24(%rsp)
	jne	.L761
	movl	numthrottles(%rip), %eax
	movq	$-1, 64(%rbx)
	testl	%eax, %eax
	jle	.L706
	leaq	8(%rbx), %rax
	xorl	%ebp, %ebp
	xorl	%r12d, %r12d
	movq	%rax, 56(%rsp)
	shrq	$3, %rax
	addq	$2147450880, %rax
	movq	%rax, 8(%rsp)
	jmp	.L708
	.p2align 4,,10
	.p2align 3
.L775:
	addl	$1, %r10d
	movslq	%r10d, %r9
.L694:
	movzbl	(%r14), %edx
	cmpb	%dl, %r13b
	jge	.L762
.L698:
	movslq	56(%rbx), %r8
	leal	1(%r8), %edx
	movl	%edx, 56(%rbx)
	leaq	16(%rbx,%r8,4), %rdx
	movq	%rdx, %r11
	movq	%rdx, %r15
	shrq	$3, %r11
	andl	$7, %r15d
	movzbl	2147450880(%r11), %r11d
	addl	$3, %r15d
	cmpb	%r11b, %r15b
	jge	.L763
.L699:
	movq	%rdi, %rdx
	movl	%r12d, 16(%rbx,%r8,4)
	movq	%rdi, %r8
	shrq	$3, %rdx
	andl	$7, %r8d
	movzbl	2147450880(%rdx), %edx
	addl	$3, %r8d
	cmpb	%dl, %r8b
	jge	.L764
.L700:
	movl	%r10d, 40(%rcx)
	movq	24(%rsp), %rcx
	cqto
	idivq	%r9
	cmpb	$0, (%rcx)
	jne	.L765
	movq	64(%rbx), %rdx
	cmpq	$-1, %rdx
	je	.L757
	cmpq	%rdx, %rax
	cmovg	%rdx, %rax
.L757:
	movq	%rax, 64(%rbx)
	movq	16(%rsp), %rax
	cmpb	$0, (%rax)
	jne	.L766
	movq	72(%rbx), %rax
	cmpq	$-1, %rax
	je	.L758
	cmpq	%rax, %rsi
	cmovl	%rax, %rsi
.L758:
	movq	%rsi, 72(%rbx)
.L688:
	addl	$1, %r12d
	cmpl	%r12d, numthrottles(%rip)
	jle	.L706
	movzbl	(%r14), %eax
	cmpb	%al, %r13b
	jge	.L767
.L707:
	addq	$48, %rbp
	cmpl	$9, 56(%rbx)
	jg	.L706
.L708:
	movq	8(%rsp), %rax
	cmpb	$0, (%rax)
	jne	.L768
	movq	8(%rbx), %rax
	leaq	240(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L769
	movq	%rbp, %rdi
	addq	throttles(%rip), %rdi
	movq	240(%rax), %rsi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L770
	movq	(%rdi), %rdi
	call	match
	testl	%eax, %eax
	je	.L688
	movq	%rbp, %rcx
	addq	throttles(%rip), %rcx
	leaq	24(%rcx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L771
	leaq	8(%rcx), %rdi
	movq	24(%rcx), %rdx
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L772
	movq	8(%rcx), %rax
	leaq	(%rax,%rax), %rsi
	cmpq	%rsi, %rdx
	jg	.L710
	leaq	16(%rcx), %rdi
	movq	%rdi, %rsi
	shrq	$3, %rsi
	cmpb	$0, 2147450880(%rsi)
	jne	.L773
	movq	16(%rcx), %rsi
	cmpq	%rsi, %rdx
	jl	.L710
	leaq	40(%rcx), %rdi
	movq	%rdi, %rdx
	movq	%rdi, %r8
	shrq	$3, %rdx
	andl	$7, %r8d
	movzbl	2147450880(%rdx), %edx
	addl	$3, %r8d
	cmpb	%dl, %r8b
	jge	.L774
.L692:
	movl	40(%rcx), %r10d
	testl	%r10d, %r10d
	jns	.L775
	xorl	%eax, %eax
	movl	$3, %edi
	movl	$.LC88, %esi
	call	syslog
	movq	%rbp, %rcx
	addq	throttles(%rip), %rcx
	leaq	40(%rcx), %rdi
	movq	%rdi, %rax
	movq	%rdi, %rdx
	shrq	$3, %rax
	andl	$7, %edx
	movzbl	2147450880(%rax), %eax
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L776
.L695:
	leaq	8(%rcx), %rax
	movl	$0, 40(%rcx)
	movq	%rax, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L777
	leaq	16(%rcx), %rdx
	movq	8(%rcx), %rax
	movq	%rdx, %rsi
	shrq	$3, %rsi
	cmpb	$0, 2147450880(%rsi)
	jne	.L778
	movq	16(%rcx), %rsi
	movl	$1, %r9d
	movl	$1, %r10d
	jmp	.L694
	.p2align 4,,10
	.p2align 3
.L706:
	addq	$72, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	movl	$1, %eax
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L710:
	.cfi_restore_state
	addq	$72, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	xorl	%eax, %eax
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
.L767:
	.cfi_restore_state
	testb	%al, %al
	je	.L707
	movq	32(%rsp), %rdi
	call	__asan_report_load4
	.p2align 4,,10
	.p2align 3
.L764:
	testb	%dl, %dl
	je	.L700
	call	__asan_report_store4
	.p2align 4,,10
	.p2align 3
.L763:
	testb	%r11b, %r11b
	je	.L699
	movq	%rdx, %rdi
	call	__asan_report_store4
	.p2align 4,,10
	.p2align 3
.L762:
	testb	%dl, %dl
	je	.L698
	movq	32(%rsp), %rdi
	call	__asan_report_load4
	.p2align 4,,10
	.p2align 3
.L774:
	testb	%dl, %dl
	je	.L692
	call	__asan_report_load4
.L772:
	.p2align 4,,6
	call	__asan_report_load8
.L766:
	movq	40(%rsp), %rdi
	call	__asan_report_load8
.L771:
	call	__asan_report_load8
.L770:
	call	__asan_report_load8
.L777:
	movq	%rax, %rdi
	call	__asan_report_load8
.L776:
	testb	%al, %al
	je	.L695
	call	__asan_report_store4
.L769:
	.p2align 4,,6
	call	__asan_report_load8
.L768:
	movq	56(%rsp), %rdi
	call	__asan_report_load8
.L761:
	movq	48(%rsp), %rdi
	call	__asan_report_store8
.L760:
	movq	40(%rsp), %rdi
	call	__asan_report_store8
.L759:
	cmpb	%al, %r13b
	jl	.L680
	movq	32(%rsp), %rdi
	call	__asan_report_store4
.L778:
	movq	%rdx, %rdi
	call	__asan_report_load8
.L765:
	movq	48(%rsp), %rdi
	call	__asan_report_load8
.L773:
	call	__asan_report_load8
	.cfi_endproc
.LFE23:
	.size	check_throttles, .-check_throttles
	.section	.rodata.str1.1
.LC89:
	.string	"shut_down 1 32 16 2 tv "
	.text
	.p2align 4,,15
	.type	shut_down, @function
shut_down:
.LFB18:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	xorl	%esi, %esi
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	xorl	%ebp, %ebp
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	xorl	%ebx, %ebx
	subq	$120, %rsp
	.cfi_def_cfa_offset 176
	leaq	16(%rsp), %r13
	leaq	48(%rsp), %rdi
	movq	$1102416563, 16(%rsp)
	movq	$.LC89, 24(%rsp)
	shrq	$3, %r13
	leaq	2147450880(%r13), %rax
	movq	%rax, 8(%rsp)
	movl	$-235802127, 2147450880(%r13)
	movl	$-185335808, 2147450884(%r13)
	movl	$-202116109, 2147450888(%r13)
	call	gettimeofday
	leaq	48(%rsp), %rdi
	call	logstats
	movl	max_connects(%rip), %ecx
	testl	%ecx, %ecx
	jg	.L817
	jmp	.L790
	.p2align 4,,10
	.p2align 3
.L784:
	leaq	8(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L829
	movq	8(%rax), %rdi
	testq	%rdi, %rdi
	je	.L787
	call	httpd_destroy_conn
	movq	%rbx, %r12
	addq	connects(%rip), %r12
	leaq	8(%r12), %r14
	movq	%r14, %r15
	shrq	$3, %r15
	cmpb	$0, 2147450880(%r15)
	jne	.L830
	movq	8(%r12), %rdi
	call	free
	subl	$1, httpd_conn_count(%rip)
	cmpb	$0, 2147450880(%r15)
	jne	.L831
	movq	$0, 8(%r12)
.L787:
	addl	$1, %ebp
	addq	$144, %rbx
	cmpl	%ebp, max_connects(%rip)
	jle	.L790
.L817:
	movq	%rbx, %rax
	addq	connects(%rip), %rax
	movq	%rax, %rdx
	movq	%rax, %rcx
	shrq	$3, %rdx
	andl	$7, %ecx
	movzbl	2147450880(%rdx), %edx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L832
.L783:
	movl	(%rax), %edx
	testl	%edx, %edx
	je	.L784
	leaq	8(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L833
	movq	8(%rax), %rdi
	leaq	48(%rsp), %rsi
	call	httpd_close_conn
	movq	%rbx, %rax
	addq	connects(%rip), %rax
	jmp	.L784
	.p2align 4,,10
	.p2align 3
.L790:
	movq	hs(%rip), %rbx
	testq	%rbx, %rbx
	je	.L782
	leaq	72(%rbx), %rdi
	movq	$0, hs(%rip)
	movq	%rdi, %rax
	movq	%rdi, %rdx
	shrq	$3, %rax
	andl	$7, %edx
	movzbl	2147450880(%rax), %eax
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L834
.L792:
	movl	72(%rbx), %edi
	cmpl	$-1, %edi
	je	.L793
	call	fdwatch_del_fd
.L793:
	leaq	76(%rbx), %rdi
	movq	%rdi, %rax
	movq	%rdi, %rdx
	shrq	$3, %rax
	andl	$7, %edx
	movzbl	2147450880(%rax), %eax
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L835
.L794:
	movl	76(%rbx), %edi
	cmpl	$-1, %edi
	je	.L795
	call	fdwatch_del_fd
.L795:
	movq	%rbx, %rdi
	call	httpd_terminate
.L782:
	call	mmc_destroy
	call	tmr_destroy
	movq	connects(%rip), %rdi
	call	free
	movq	throttles(%rip), %rdi
	testq	%rdi, %rdi
	je	.L779
	call	free
.L779:
	movq	8(%rsp), %rax
	movq	$0, 2147450880(%r13)
	movl	$0, 8(%rax)
	addq	$120, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
.L832:
	.cfi_restore_state
	testb	%dl, %dl
	je	.L783
	movq	%rax, %rdi
	call	__asan_report_load4
.L834:
	testb	%al, %al
	je	.L792
	call	__asan_report_load4
.L833:
	.p2align 4,,6
	call	__asan_report_load8
.L835:
	testb	%al, %al
	.p2align 4,,3
	je	.L794
	.p2align 4,,6
	call	__asan_report_load4
.L829:
	.p2align 4,,6
	call	__asan_report_load8
.L831:
	movq	%r14, %rdi
	call	__asan_report_store8
.L830:
	movq	%r14, %rdi
	call	__asan_report_load8
	.cfi_endproc
.LFE18:
	.size	shut_down, .-shut_down
	.section	.rodata
	.align 32
.LC90:
	.string	"exiting"
	.zero	56
	.text
	.p2align 4,,15
	.type	handle_usr1, @function
handle_usr1:
.LFB5:
	.cfi_startproc
	movl	num_connects(%rip), %edx
	testl	%edx, %edx
	je	.L839
	movl	$1, got_usr1(%rip)
	ret
.L839:
	pushq	%rax
	.cfi_def_cfa_offset 16
	call	shut_down
	movl	$5, %edi
	movl	$.LC90, %esi
	xorl	%eax, %eax
	call	syslog
	call	closelog
	call	__asan_handle_no_return
	xorl	%edi, %edi
	call	exit
	.cfi_endproc
.LFE5:
	.size	handle_usr1, .-handle_usr1
	.section	.rodata
	.align 32
.LC91:
	.string	"exiting due to signal %d"
	.zero	39
	.text
	.p2align 4,,15
	.type	handle_term, @function
handle_term:
.LFB2:
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movl	%edi, %ebx
	call	shut_down
	movl	$5, %edi
	movl	%ebx, %edx
	movl	$.LC91, %esi
	xorl	%eax, %eax
	call	syslog
	call	closelog
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
	.cfi_endproc
.LFE2:
	.size	handle_term, .-handle_term
	.p2align 4,,15
	.type	clear_throttles.isra.0, @function
clear_throttles.isra.0:
.LFB36:
	.cfi_startproc
	leaq	56(%rdi), %rax
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movq	%rax, %rdx
	movq	%rax, %rcx
	shrq	$3, %rdx
	andl	$7, %ecx
	movzbl	2147450880(%rdx), %edx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L868
.L843:
	movl	56(%rdi), %edx
	testl	%edx, %edx
	jle	.L842
	subl	$1, %edx
	movq	throttles(%rip), %r9
	leaq	16(%rdi), %rax
	leaq	20(%rdi,%rdx,4), %r8
	.p2align 4,,10
	.p2align 3
.L848:
	movq	%rax, %rdx
	movq	%rax, %rcx
	shrq	$3, %rdx
	andl	$7, %ecx
	movzbl	2147450880(%rdx), %edx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L869
.L845:
	movslq	(%rax), %rdx
	leaq	(%rdx,%rdx,2), %rdx
	salq	$4, %rdx
	addq	%r9, %rdx
	leaq	40(%rdx), %rdi
	movq	%rdi, %rcx
	movq	%rdi, %rsi
	shrq	$3, %rcx
	andl	$7, %esi
	movzbl	2147450880(%rcx), %ecx
	addl	$3, %esi
	cmpb	%cl, %sil
	jge	.L870
.L846:
	addq	$4, %rax
	subl	$1, 40(%rdx)
	cmpq	%r8, %rax
	jne	.L848
.L842:
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L869:
	.cfi_restore_state
	testb	%dl, %dl
	je	.L845
	movq	%rax, %rdi
	call	__asan_report_load4
	.p2align 4,,10
	.p2align 3
.L870:
	testb	%cl, %cl
	je	.L846
	call	__asan_report_load4
.L868:
	testb	%dl, %dl
	.p2align 4,,4
	je	.L843
	movq	%rax, %rdi
	call	__asan_report_load4
	.cfi_endproc
.LFE36:
	.size	clear_throttles.isra.0, .-clear_throttles.isra.0
	.p2align 4,,15
	.type	really_clear_connection, @function
really_clear_connection:
.LFB28:
	.cfi_startproc
	pushq	%r14
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	leaq	8(%rdi), %r14
	pushq	%r13
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
	movq	%r14, %r13
	shrq	$3, %r13
	pushq	%r12
	.cfi_def_cfa_offset 32
	.cfi_offset 12, -32
	pushq	%rbp
	.cfi_def_cfa_offset 40
	.cfi_offset 6, -40
	pushq	%rbx
	.cfi_def_cfa_offset 48
	.cfi_offset 3, -48
	movq	%rdi, %rbx
	subq	$16, %rsp
	.cfi_def_cfa_offset 64
	cmpb	$0, 2147450880(%r13)
	jne	.L911
	movq	8(%rdi), %rax
	leaq	200(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L912
	movq	%rbx, %r12
	movq	200(%rax), %rdx
	addq	%rdx, stats_bytes(%rip)
	shrq	$3, %r12
	movq	%rbx, %rbp
	movzbl	2147450880(%r12), %edx
	andl	$7, %ebp
	addl	$3, %ebp
	cmpb	%dl, %bpl
	jge	.L913
.L874:
	cmpl	$3, (%rbx)
	je	.L875
	leaq	704(%rax), %rdi
	movq	%rdi, %rdx
	movq	%rdi, %rcx
	shrq	$3, %rdx
	andl	$7, %ecx
	movzbl	2147450880(%rdx), %edx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L914
.L876:
	movl	704(%rax), %edi
	movq	%rsi, 8(%rsp)
	call	fdwatch_del_fd
	cmpb	$0, 2147450880(%r13)
	movq	8(%rsp), %rsi
	jne	.L915
	movq	8(%rbx), %rax
.L875:
	leaq	104(%rbx), %r14
	movq	%rax, %rdi
	call	httpd_close_conn
	movq	%r14, %r13
	movq	%rbx, %rdi
	shrq	$3, %r13
	call	clear_throttles.isra.0
	cmpb	$0, 2147450880(%r13)
	jne	.L916
	movq	104(%rbx), %rdi
	testq	%rdi, %rdi
	je	.L879
	call	tmr_cancel
	cmpb	$0, 2147450880(%r13)
	jne	.L917
	movq	$0, 104(%rbx)
.L879:
	movzbl	2147450880(%r12), %eax
	cmpb	%al, %bpl
	jge	.L918
.L881:
	leaq	4(%rbx), %rdi
	movl	$0, (%rbx)
	movl	first_free_connect(%rip), %edx
	movq	%rdi, %rax
	movq	%rdi, %rcx
	shrq	$3, %rax
	andl	$7, %ecx
	movzbl	2147450880(%rax), %eax
	addl	$3, %ecx
	cmpb	%al, %cl
	jge	.L919
.L882:
	movl	%edx, 4(%rbx)
	subq	connects(%rip), %rbx
	movabsq	$-8198552921648689607, %rax
	subl	$1, num_connects(%rip)
	sarq	$4, %rbx
	imulq	%rax, %rbx
	movl	%ebx, first_free_connect(%rip)
	addq	$16, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 48
	popq	%rbx
	.cfi_def_cfa_offset 40
	popq	%rbp
	.cfi_def_cfa_offset 32
	popq	%r12
	.cfi_def_cfa_offset 24
	popq	%r13
	.cfi_def_cfa_offset 16
	popq	%r14
	.cfi_def_cfa_offset 8
	ret
.L913:
	.cfi_restore_state
	testb	%dl, %dl
	je	.L874
	movq	%rbx, %rdi
	call	__asan_report_load4
.L919:
	testb	%al, %al
	je	.L882
	call	__asan_report_store4
.L918:
	testb	%al, %al
	.p2align 4,,4
	je	.L881
	movq	%rbx, %rdi
	call	__asan_report_store4
.L914:
	testb	%dl, %dl
	je	.L876
	call	__asan_report_load4
.L915:
	movq	%r14, %rdi
	call	__asan_report_load8
.L912:
	call	__asan_report_load8
.L911:
	movq	%r14, %rdi
	call	__asan_report_load8
.L917:
	movq	%r14, %rdi
	call	__asan_report_store8
.L916:
	movq	%r14, %rdi
	call	__asan_report_load8
	.cfi_endproc
.LFE28:
	.size	really_clear_connection, .-really_clear_connection
	.section	.rodata.str1.8
	.align 8
.LC92:
	.string	"clear_connection 1 32 8 11 client_data "
	.section	.rodata
	.align 32
.LC93:
	.string	"replacing non-null linger_timer!"
	.zero	63
	.align 32
.LC94:
	.string	"tmr_create(linger_clear_connection) failed"
	.zero	53
	.text
	.p2align 4,,15
	.type	clear_connection, @function
clear_connection:
.LFB27:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	leaq	96(%rdi), %r15
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	movq	%r15, %r14
	shrq	$3, %r14
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	movq	%rdi, %rbx
	subq	$120, %rsp
	.cfi_def_cfa_offset 176
	leaq	16(%rsp), %rbp
	movq	$1102416563, 16(%rsp)
	movq	$.LC92, 24(%rsp)
	shrq	$3, %rbp
	leaq	2147450880(%rbp), %r12
	movl	$-235802127, 2147450880(%rbp)
	movl	$-185273344, 4(%r12)
	movl	$-202116109, 8(%r12)
	cmpb	$0, 2147450880(%r14)
	jne	.L998
	movq	96(%rdi), %rdi
	movq	%rsi, %r13
	testq	%rdi, %rdi
	je	.L922
	call	tmr_cancel
	cmpb	$0, 2147450880(%r14)
	jne	.L999
	movq	$0, 96(%rbx)
.L922:
	movq	%rbx, %rsi
	movq	%rbx, %r15
	shrq	$3, %rsi
	andl	$7, %r15d
	movzbl	2147450880(%rsi), %ecx
	addl	$3, %r15d
	cmpb	%cl, %r15b
	jge	.L1000
.L924:
	cmpl	$4, (%rbx)
	je	.L925
	leaq	8(%rbx), %rax
	movq	%rax, %r14
	movq	%rax, (%rsp)
	shrq	$3, %r14
	cmpb	$0, 2147450880(%r14)
	jne	.L1001
	movq	8(%rbx), %rax
	leaq	556(%rax), %rdi
	movq	%rdi, %r8
	movq	%rdi, %r9
	shrq	$3, %r8
	andl	$7, %r9d
	movzbl	2147450880(%r8), %r8d
	addl	$3, %r9d
	cmpb	%r8b, %r9b
	jge	.L1002
.L927:
	movl	556(%rax), %edx
	testl	%edx, %edx
	je	.L929
	cmpb	%cl, %r15b
	jge	.L1003
.L934:
	cmpl	$3, (%rbx)
	je	.L935
	leaq	704(%rax), %rdi
	movq	%rdi, %rcx
	movq	%rdi, %r8
	shrq	$3, %rcx
	andl	$7, %r8d
	movzbl	2147450880(%rcx), %ecx
	addl	$3, %r8d
	cmpb	%cl, %r8b
	jge	.L1004
.L936:
	movl	704(%rax), %edi
	movq	%rsi, 8(%rsp)
	call	fdwatch_del_fd
	cmpb	$0, 2147450880(%r14)
	movq	8(%rsp), %rsi
	jne	.L1005
	movzbl	2147450880(%rsi), %ecx
	movq	8(%rbx), %rax
	cmpb	%cl, %r15b
	jge	.L1006
.L935:
	leaq	704(%rax), %rdi
	movl	$4, (%rbx)
	movq	%rdi, %rcx
	movq	%rdi, %rsi
	shrq	$3, %rcx
	andl	$7, %esi
	movzbl	2147450880(%rcx), %ecx
	addl	$3, %esi
	cmpb	%cl, %sil
	jge	.L1007
.L938:
	movl	704(%rax), %edi
	movl	$1, %esi
	call	shutdown
	cmpb	$0, 2147450880(%r14)
	jne	.L1008
	movq	8(%rbx), %rax
	leaq	704(%rax), %rdi
	movq	%rdi, %rdx
	movq	%rdi, %rcx
	shrq	$3, %rdx
	andl	$7, %ecx
	movzbl	2147450880(%rdx), %edx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L1009
.L940:
	movl	704(%rax), %edi
	xorl	%edx, %edx
	movq	%rbx, %rsi
	call	fdwatch_add_fd
	leaq	48(%rsp), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1010
	leaq	104(%rbx), %r15
	movq	%rbx, 48(%rsp)
	movq	%r15, %r14
	shrq	$3, %r14
	cmpb	$0, 2147450880(%r14)
	jne	.L1011
	cmpq	$0, 104(%rbx)
	je	.L943
	movl	$.LC93, %esi
	movl	$3, %edi
	xorl	%eax, %eax
	call	syslog
.L943:
	movq	48(%rsp), %rdx
	xorl	%r8d, %r8d
	movl	$500, %ecx
	movl	$linger_clear_connection, %esi
	movq	%r13, %rdi
	call	tmr_create
	cmpb	$0, 2147450880(%r14)
	jne	.L1012
	testq	%rax, %rax
	movq	%rax, 104(%rbx)
	je	.L1013
.L920:
	movq	$0, 2147450880(%rbp)
	movl	$0, 8(%r12)
	addq	$120, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L925:
	.cfi_restore_state
	leaq	104(%rbx), %r15
	movq	%r15, %r14
	shrq	$3, %r14
	cmpb	$0, 2147450880(%r14)
	jne	.L1014
	movq	104(%rbx), %rdi
	call	tmr_cancel
	cmpb	$0, 2147450880(%r14)
	jne	.L1015
	leaq	8(%rbx), %rdi
	movq	$0, 104(%rbx)
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1016
	movq	8(%rbx), %rax
	leaq	556(%rax), %rdi
	movq	%rdi, %rdx
	movq	%rdi, %rcx
	shrq	$3, %rdx
	andl	$7, %ecx
	movzbl	2147450880(%rdx), %edx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L1017
.L933:
	movl	$0, 556(%rax)
.L929:
	movq	%r13, %rsi
	movq	%rbx, %rdi
	call	really_clear_connection
	jmp	.L920
.L1006:
	testb	%cl, %cl
	je	.L935
	movq	%rbx, %rdi
	.p2align 4,,6
	call	__asan_report_store4
.L1000:
	testb	%cl, %cl
	je	.L924
	movq	%rbx, %rdi
	call	__asan_report_load4
.L1007:
	testb	%cl, %cl
	je	.L938
	call	__asan_report_load4
.L1013:
	movl	$2, %edi
	movl	$.LC94, %esi
	call	syslog
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L1009:
	testb	%dl, %dl
	je	.L940
	call	__asan_report_load4
.L1003:
	testb	%cl, %cl
	.p2align 4,,4
	je	.L934
	movq	%rbx, %rdi
	call	__asan_report_load4
.L1002:
	testb	%r8b, %r8b
	je	.L927
	call	__asan_report_load4
.L1017:
	testb	%dl, %dl
	.p2align 4,,3
	je	.L933
	.p2align 4,,6
	call	__asan_report_store4
.L1004:
	testb	%cl, %cl
	.p2align 4,,4
	je	.L936
	.p2align 4,,6
	call	__asan_report_load4
.L1012:
	movq	%r15, %rdi
	call	__asan_report_store8
.L998:
	movq	%r15, %rdi
	call	__asan_report_load8
.L1008:
	movq	(%rsp), %rdi
	call	__asan_report_load8
.L999:
	movq	%r15, %rdi
	call	__asan_report_store8
.L1016:
	call	__asan_report_load8
.L1015:
	movq	%r15, %rdi
	call	__asan_report_store8
.L1014:
	movq	%r15, %rdi
	call	__asan_report_load8
.L1001:
	movq	%rax, %rdi
	call	__asan_report_load8
.L1011:
	movq	%r15, %rdi
	call	__asan_report_load8
.L1010:
	call	__asan_report_store8
.L1005:
	movq	(%rsp), %rdi
	call	__asan_report_load8
	.cfi_endproc
.LFE27:
	.size	clear_connection, .-clear_connection
	.p2align 4,,15
	.type	finish_connection, @function
finish_connection:
.LFB26:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	movq	%rdi, %rbx
	leaq	8(%rdi), %rdi
	movq	%rdi, %rax
	subq	$8, %rsp
	.cfi_def_cfa_offset 32
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1021
	movq	8(%rbx), %rdi
	movq	%rsi, %rbp
	call	httpd_write_response
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	movq	%rbx, %rdi
	movq	%rbp, %rsi
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	jmp	clear_connection
.L1021:
	.cfi_restore_state
	call	__asan_report_load8
	.cfi_endproc
.LFE26:
	.size	finish_connection, .-finish_connection
	.p2align 4,,15
	.type	handle_read, @function
handle_read:
.LFB20:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	movq	%rdi, %rbx
	leaq	8(%rdi), %rdi
	movq	%rdi, %rax
	subq	$24, %rsp
	.cfi_def_cfa_offset 80
	shrq	$3, %rax
	movq	%rsi, (%rsp)
	cmpb	$0, 2147450880(%rax)
	jne	.L1133
	movq	8(%rbx), %rbp
	leaq	160(%rbp), %rax
	movq	%rax, %r12
	movq	%rax, 8(%rsp)
	shrq	$3, %r12
	cmpb	$0, 2147450880(%r12)
	jne	.L1134
	leaq	152(%rbp), %r13
	movq	160(%rbp), %rsi
	movq	%r13, %r14
	shrq	$3, %r14
	cmpb	$0, 2147450880(%r14)
	jne	.L1135
	movq	152(%rbp), %rdx
	cmpq	%rdx, %rsi
	jb	.L1075
	cmpq	$5000, %rdx
	ja	.L1131
	leaq	144(%rbp), %r15
	addq	$1000, %rdx
	movq	%r13, %rsi
	movq	%r15, %rdi
	call	httpd_realloc_str
	cmpb	$0, 2147450880(%r14)
	jne	.L1136
	cmpb	$0, 2147450880(%r12)
	movq	152(%rbp), %rdx
	jne	.L1137
	movq	160(%rbp), %rsi
.L1026:
	movq	%r15, %rax
	subq	%rsi, %rdx
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1138
	leaq	704(%rbp), %r13
	addq	144(%rbp), %rsi
	movq	%r13, %r15
	movq	%r13, %r14
	shrq	$3, %r15
	andl	$7, %r14d
	movzbl	2147450880(%r15), %eax
	addl	$3, %r14d
	cmpb	%al, %r14b
	jge	.L1139
.L1031:
	movl	704(%rbp), %edi
	call	read
	testl	%eax, %eax
	je	.L1131
	js	.L1140
	cmpb	$0, 2147450880(%r12)
	jne	.L1141
	movq	(%rsp), %r12
	cltq
	addq	%rax, 160(%rbp)
	shrq	$3, %r12
	cmpb	$0, 2147450880(%r12)
	jne	.L1142
	leaq	88(%rbx), %rdi
	movq	(%rsp), %rax
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movq	(%rax), %rax
	cmpb	$0, 2147450880(%rdx)
	jne	.L1143
	movq	%rax, 88(%rbx)
	movq	%rbp, %rdi
	call	httpd_got_request
	testl	%eax, %eax
	je	.L1022
	cmpl	$2, %eax
	je	.L1131
	movq	%rbp, %rdi
	call	httpd_parse_request
	testl	%eax, %eax
	js	.L1132
	movq	%rbx, %rdi
	call	check_throttles
	testl	%eax, %eax
	je	.L1144
	movq	(%rsp), %rsi
	movq	%rbp, %rdi
	call	httpd_start_request
	testl	%eax, %eax
	js	.L1132
	leaq	528(%rbp), %rdi
	movq	%rdi, %rax
	movq	%rdi, %rdx
	shrq	$3, %rax
	andl	$7, %edx
	movzbl	2147450880(%rax), %eax
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L1145
.L1045:
	movl	528(%rbp), %eax
	testl	%eax, %eax
	je	.L1046
	leaq	536(%rbp), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1146
	leaq	136(%rbx), %rdi
	movq	536(%rbp), %rax
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1147
	leaq	544(%rbp), %rdi
	movq	%rax, 136(%rbx)
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1148
	leaq	128(%rbx), %rdi
	movq	544(%rbp), %rax
	movq	%rdi, %rdx
	shrq	$3, %rdx
	addq	$1, %rax
	cmpb	$0, 2147450880(%rdx)
	jne	.L1149
.L1055:
	movq	%rax, 128(%rbx)
.L1051:
	leaq	712(%rbp), %rax
	movq	%rax, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1150
	cmpq	$0, 712(%rbp)
	je	.L1151
	leaq	136(%rbx), %rax
	movq	%rax, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1152
	movq	%rdi, %rdx
	movq	136(%rbx), %rax
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1153
	cmpq	128(%rbx), %rax
	jge	.L1132
	movq	%rbx, %rax
	movq	%rbx, %rdx
	shrq	$3, %rax
	andl	$7, %edx
	movzbl	2147450880(%rax), %eax
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L1154
.L1069:
	cmpb	$0, 2147450880(%r12)
	movl	$2, (%rbx)
	jne	.L1155
	leaq	80(%rbx), %rdi
	movq	(%rsp), %rax
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movq	(%rax), %rax
	cmpb	$0, 2147450880(%rdx)
	jne	.L1156
	leaq	112(%rbx), %rdi
	movq	%rax, 80(%rbx)
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1157
	movzbl	2147450880(%r15), %eax
	movq	$0, 112(%rbx)
	cmpb	%al, %r14b
	jge	.L1158
.L1073:
	movl	704(%rbp), %edi
	call	fdwatch_del_fd
	movzbl	2147450880(%r15), %eax
	cmpb	%al, %r14b
	jge	.L1159
.L1074:
	movl	704(%rbp), %edi
	addq	$24, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	movq	%rbx, %rsi
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	movl	$1, %edx
	jmp	fdwatch_add_fd
	.p2align 4,,10
	.p2align 3
.L1140:
	.cfi_restore_state
	call	__errno_location
	movq	%rax, %rdx
	movq	%rax, %rcx
	shrq	$3, %rdx
	andl	$7, %ecx
	movzbl	2147450880(%rdx), %edx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L1160
.L1034:
	movl	(%rax), %eax
	cmpl	$11, %eax
	je	.L1022
	cmpl	$4, %eax
	je	.L1022
	.p2align 4,,10
	.p2align 3
.L1131:
	movq	httpd_err400form(%rip), %r8
	movq	httpd_err400title(%rip), %rdx
	movl	$.LC47, %r9d
	movq	%r9, %rcx
	movl	$400, %esi
	movq	%rbp, %rdi
	call	httpd_send_err
.L1132:
	movq	(%rsp), %rsi
	addq	$24, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	movq	%rbx, %rdi
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	jmp	finish_connection
	.p2align 4,,10
	.p2align 3
.L1022:
	.cfi_restore_state
	addq	$24, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L1075:
	.cfi_restore_state
	leaq	144(%rbp), %r15
	jmp	.L1026
	.p2align 4,,10
	.p2align 3
.L1144:
	leaq	208(%rbp), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1161
	movq	208(%rbp), %r9
	movq	httpd_err503form(%rip), %r8
	movl	$.LC47, %ecx
	movq	httpd_err503title(%rip), %rdx
	movl	$503, %esi
	movq	%rbp, %rdi
	call	httpd_send_err
	jmp	.L1132
	.p2align 4,,10
	.p2align 3
.L1046:
	leaq	192(%rbp), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1162
	movq	192(%rbp), %rax
	leaq	128(%rbx), %rdi
	testq	%rax, %rax
	js	.L1163
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	je	.L1055
	call	__asan_report_store8
	.p2align 4,,10
	.p2align 3
.L1151:
	leaq	56(%rbx), %rdi
	movq	%rdi, %rax
	movq	%rdi, %rdx
	shrq	$3, %rax
	andl	$7, %edx
	movzbl	2147450880(%rax), %eax
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L1164
.L1058:
	movl	56(%rbx), %eax
	testl	%eax, %eax
	jle	.L1165
	leaq	200(%rbp), %rdi
	movq	throttles(%rip), %r8
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1166
	subl	$1, %eax
	movq	200(%rbp), %rsi
	leaq	16(%rbx), %rdi
	leaq	20(%rbx,%rax,4), %r9
	.p2align 4,,10
	.p2align 3
.L1065:
	movq	%rdi, %rax
	movq	%rdi, %rdx
	shrq	$3, %rax
	andl	$7, %edx
	movzbl	2147450880(%rax), %eax
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L1167
.L1063:
	movslq	(%rdi), %rax
	leaq	(%rax,%rax,2), %rax
	salq	$4, %rax
	addq	%r8, %rax
	leaq	32(%rax), %rdx
	movq	%rdx, %rcx
	shrq	$3, %rcx
	cmpb	$0, 2147450880(%rcx)
	jne	.L1168
	addq	$4, %rdi
	addq	%rsi, 32(%rax)
	cmpq	%r9, %rdi
	jne	.L1065
.L1061:
	leaq	136(%rbx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1169
	movq	%rsi, 136(%rbx)
	jmp	.L1132
.L1163:
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1170
	movq	$0, 128(%rbx)
	jmp	.L1051
.L1165:
	leaq	200(%rbp), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1171
	movq	200(%rbp), %rsi
	jmp	.L1061
.L1139:
	testb	%al, %al
	je	.L1031
	movq	%r13, %rdi
	call	__asan_report_load4
.L1160:
	testb	%dl, %dl
	je	.L1034
	movq	%rax, %rdi
	call	__asan_report_load4
.L1168:
	movq	%rdx, %rdi
	call	__asan_report_load8
.L1171:
	call	__asan_report_load8
.L1134:
	movq	%rax, %rdi
	call	__asan_report_load8
.L1141:
	movq	8(%rsp), %rdi
	call	__asan_report_load8
.L1138:
	movq	%r15, %rdi
	call	__asan_report_load8
.L1142:
	movq	(%rsp), %rdi
	call	__asan_report_load8
.L1143:
	call	__asan_report_store8
.L1135:
	movq	%r13, %rdi
	call	__asan_report_load8
.L1147:
	call	__asan_report_store8
.L1146:
	call	__asan_report_load8
.L1145:
	testb	%al, %al
	.p2align 4,,3
	je	.L1045
	.p2align 4,,6
	call	__asan_report_load4
.L1161:
	.p2align 4,,6
	call	__asan_report_load8
.L1149:
	.p2align 4,,5
	call	__asan_report_store8
.L1148:
	.p2align 4,,5
	call	__asan_report_load8
.L1162:
	.p2align 4,,5
	call	__asan_report_load8
.L1169:
	.p2align 4,,5
	call	__asan_report_store8
.L1159:
	testb	%al, %al
	.p2align 4,,3
	je	.L1074
	movq	%r13, %rdi
	call	__asan_report_load4
.L1158:
	testb	%al, %al
	je	.L1073
	movq	%r13, %rdi
	call	__asan_report_load4
.L1157:
	call	__asan_report_store8
.L1156:
	call	__asan_report_store8
.L1155:
	movq	(%rsp), %rdi
	call	__asan_report_load8
.L1154:
	testb	%al, %al
	je	.L1069
	movq	%rbx, %rdi
	call	__asan_report_store4
.L1153:
	call	__asan_report_load8
.L1152:
	movq	%rax, %rdi
	call	__asan_report_load8
.L1136:
	movq	%r13, %rdi
	call	__asan_report_load8
.L1137:
	movq	8(%rsp), %rdi
	call	__asan_report_load8
.L1133:
	call	__asan_report_load8
.L1150:
	movq	%rax, %rdi
	call	__asan_report_load8
.L1167:
	testb	%al, %al
	je	.L1063
	call	__asan_report_load4
.L1166:
	.p2align 4,,6
	call	__asan_report_load8
.L1164:
	testb	%al, %al
	.p2align 4,,3
	je	.L1058
	.p2align 4,,6
	call	__asan_report_load4
.L1170:
	.p2align 4,,6
	call	__asan_report_store8
	.cfi_endproc
.LFE20:
	.size	handle_read, .-handle_read
	.section	.rodata
	.align 32
.LC95:
	.string	"%.80s connection timed out reading"
	.zero	61
	.align 32
.LC96:
	.string	"%.80s connection timed out sending"
	.zero	61
	.text
	.p2align 4,,15
	.type	idle, @function
idle:
.LFB29:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	movq	%rsi, %r13
	shrq	$3, %r13
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	addq	$2147450880, %r13
	movq	%rsi, %r12
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	xorl	%ebp, %ebp
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$8, %rsp
	.cfi_def_cfa_offset 64
	movl	max_connects(%rip), %eax
	testl	%eax, %eax
	jg	.L1191
	jmp	.L1172
	.p2align 4,,10
	.p2align 3
.L1200:
	jl	.L1175
	cmpl	$3, %eax
	.p2align 4,,8
	jg	.L1175
	cmpb	$0, 0(%r13)
	.p2align 4,,3
	jne	.L1196
	leaq	88(%rbx), %rdi
	movq	(%r12), %rax
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1197
	subq	88(%rbx), %rax
	cmpq	$299, %rax
	jg	.L1198
.L1175:
	leal	1(%rbp), %eax
	addq	$1, %rbp
	cmpl	%eax, max_connects(%rip)
	jle	.L1172
.L1191:
	leaq	0(%rbp,%rbp,8), %rbx
	salq	$4, %rbx
	addq	connects(%rip), %rbx
	movq	%rbx, %rax
	movq	%rbx, %rdx
	shrq	$3, %rax
	andl	$7, %edx
	movzbl	2147450880(%rax), %eax
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L1199
.L1174:
	movl	(%rbx), %eax
	cmpl	$1, %eax
	jne	.L1200
	cmpb	$0, 0(%r13)
	jne	.L1201
	leaq	88(%rbx), %rdi
	movq	(%r12), %rax
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1202
	subq	88(%rbx), %rax
	cmpq	$59, %rax
	jle	.L1175
	leaq	8(%rbx), %r15
	movq	%r15, %r14
	shrq	$3, %r14
	cmpb	$0, 2147450880(%r14)
	jne	.L1203
	movq	8(%rbx), %rax
	leaq	16(%rax), %rdi
	call	httpd_ntoa
	movl	$.LC95, %esi
	movq	%rax, %rdx
	movl	$6, %edi
	xorl	%eax, %eax
	call	syslog
	cmpb	$0, 2147450880(%r14)
	movq	httpd_err408form(%rip), %r8
	movq	httpd_err408title(%rip), %rdx
	jne	.L1204
	movq	8(%rbx), %rdi
	movl	$.LC47, %r9d
	movl	$408, %esi
	movq	%r9, %rcx
	call	httpd_send_err
	movq	%r12, %rsi
	movq	%rbx, %rdi
	call	finish_connection
	leal	1(%rbp), %eax
	addq	$1, %rbp
	cmpl	%eax, max_connects(%rip)
	jg	.L1191
	.p2align 4,,10
	.p2align 3
.L1172:
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L1198:
	.cfi_restore_state
	leaq	8(%rbx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1205
	movq	8(%rbx), %rax
	leaq	16(%rax), %rdi
	call	httpd_ntoa
	movl	$.LC96, %esi
	movq	%rax, %rdx
	movl	$6, %edi
	xorl	%eax, %eax
	call	syslog
	movq	%r12, %rsi
	movq	%rbx, %rdi
	call	clear_connection
	jmp	.L1175
.L1199:
	testb	%al, %al
	je	.L1174
	movq	%rbx, %rdi
	.p2align 4,,6
	call	__asan_report_load4
.L1205:
	call	__asan_report_load8
.L1204:
	movq	%r15, %rdi
	call	__asan_report_load8
.L1203:
	movq	%r15, %rdi
	call	__asan_report_load8
.L1202:
	call	__asan_report_load8
.L1201:
	movq	%r12, %rdi
	call	__asan_report_load8
.L1197:
	call	__asan_report_load8
.L1196:
	movq	%r12, %rdi
	call	__asan_report_load8
	.cfi_endproc
.LFE29:
	.size	idle, .-idle
	.section	.rodata.str1.8
	.align 8
.LC97:
	.string	"handle_send 2 32 8 11 client_data 96 32 2 iv "
	.section	.rodata
	.align 32
.LC98:
	.string	"replacing non-null wakeup_timer!"
	.zero	63
	.align 32
.LC99:
	.string	"tmr_create(wakeup_connection) failed"
	.zero	59
	.align 32
.LC100:
	.string	"write - %m sending %.80s"
	.zero	39
	.text
	.p2align 4,,15
	.type	handle_send, @function
handle_send:
.LFB21:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	leaq	8(%rdi), %rax
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	movq	%rdi, %r14
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$248, %rsp
	.cfi_def_cfa_offset 304
	leaq	80(%rsp), %rbx
	movq	$1102416563, 80(%rsp)
	movq	$.LC97, 88(%rsp)
	movq	%rsi, (%rsp)
	shrq	$3, %rbx
	leaq	2147450880(%rbx), %rbp
	movl	$-235802127, 2147450880(%rbx)
	movl	$-185273344, 4(%rbp)
	movl	$-218959118, 8(%rbp)
	movl	$-202116109, 16(%rbp)
	movq	%rax, 48(%rsp)
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	movq	%rax, 8(%rsp)
	jne	.L1389
	leaq	64(%rdi), %rax
	movq	8(%rdi), %r12
	movq	%rax, 40(%rsp)
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	movq	%rax, 24(%rsp)
	jne	.L1390
	movq	64(%rdi), %rdx
	movl	$1000000000, %eax
	cmpq	$-1, %rdx
	je	.L1209
	leaq	3(%rdx), %rax
	testq	%rdx, %rdx
	cmovns	%rdx, %rax
	sarq	$2, %rax
.L1209:
	leaq	472(%r12), %rdx
	movq	%rdx, %r15
	movq	%rdx, 32(%rsp)
	shrq	$3, %r15
	cmpb	$0, 2147450880(%r15)
	jne	.L1391
	movq	472(%r12), %rdx
	testq	%rdx, %rdx
	jne	.L1211
	leaq	128(%r14), %rdx
	movq	%rdx, 16(%rsp)
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1392
	leaq	136(%r14), %r13
	movq	128(%r14), %rdx
	movq	%r13, %rcx
	shrq	$3, %rcx
	cmpb	$0, 2147450880(%rcx)
	jne	.L1393
	movq	136(%r14), %rsi
	leaq	712(%r12), %rdi
	subq	%rsi, %rdx
	cmpq	%rdx, %rax
	cmovbe	%rax, %rdx
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1394
	leaq	704(%r12), %r9
	addq	712(%r12), %rsi
	movq	%r9, %rax
	movq	%r9, %rcx
	shrq	$3, %rax
	andl	$7, %ecx
	movzbl	2147450880(%rax), %eax
	addl	$3, %ecx
	cmpb	%al, %cl
	jge	.L1395
.L1215:
	movl	704(%r12), %edi
	movq	%r9, 56(%rsp)
	call	write
	testl	%eax, %eax
	movq	56(%rsp), %r9
	js	.L1396
.L1226:
	je	.L1230
	movq	(%rsp), %r10
	shrq	$3, %r10
	cmpb	$0, 2147450880(%r10)
	jne	.L1397
	leaq	88(%r14), %rdi
	movq	(%rsp), %rdx
	movq	%rdi, %rcx
	shrq	$3, %rcx
	movq	(%rdx), %rdx
	cmpb	$0, 2147450880(%rcx)
	jne	.L1398
	cmpb	$0, 2147450880(%r15)
	movq	%rdx, 88(%r14)
	jne	.L1399
	movq	472(%r12), %rcx
	testq	%rcx, %rcx
	je	.L1388
	movslq	%eax, %rsi
	cmpq	%rsi, %rcx
	ja	.L1400
	subl	%ecx, %eax
	movq	$0, 472(%r12)
.L1388:
	movslq	%eax, %r11
.L1248:
	movq	%r13, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1401
	movq	8(%rsp), %rax
	movq	%r11, %rdx
	addq	136(%r14), %rdx
	cmpb	$0, 2147450880(%rax)
	movq	%rdx, 136(%r14)
	jne	.L1402
	movq	8(%r14), %rcx
	leaq	200(%rcx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1403
	movq	%r11, %rax
	addq	200(%rcx), %rax
	leaq	56(%r14), %rdi
	movq	%rdi, %rsi
	andl	$7, %esi
	movq	%rax, 200(%rcx)
	movq	%rdi, %rcx
	addl	$3, %esi
	shrq	$3, %rcx
	movzbl	2147450880(%rcx), %ecx
	cmpb	%cl, %sil
	jge	.L1404
.L1259:
	movl	56(%r14), %esi
	testl	%esi, %esi
	jle	.L1265
	subl	$1, %esi
	movq	throttles(%rip), %r15
	leaq	16(%r14), %rcx
	leaq	20(%r14,%rsi,4), %r13
	.p2align 4,,10
	.p2align 3
.L1266:
	movq	%rcx, %rsi
	movq	%rcx, %rdi
	shrq	$3, %rsi
	andl	$7, %edi
	movzbl	2147450880(%rsi), %esi
	addl	$3, %edi
	cmpb	%sil, %dil
	jge	.L1405
.L1263:
	movslq	(%rcx), %rsi
	leaq	(%rsi,%rsi,2), %rsi
	salq	$4, %rsi
	addq	%r15, %rsi
	leaq	32(%rsi), %rdi
	movq	%rdi, %r8
	shrq	$3, %r8
	cmpb	$0, 2147450880(%r8)
	jne	.L1406
	addq	$4, %rcx
	addq	%r11, 32(%rsi)
	cmpq	%r13, %rcx
	jne	.L1266
.L1265:
	movq	16(%rsp), %rcx
	shrq	$3, %rcx
	cmpb	$0, 2147450880(%rcx)
	jne	.L1407
	cmpq	128(%r14), %rdx
	jge	.L1408
	leaq	112(%r14), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1409
	movq	112(%r14), %rdx
	cmpq	$100, %rdx
	jg	.L1410
.L1269:
	movq	24(%rsp), %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1411
	movq	64(%r14), %rcx
	cmpq	$-1, %rcx
	je	.L1206
	cmpb	$0, 2147450880(%r10)
	jne	.L1412
	movq	(%rsp), %rdx
	leaq	80(%r14), %rdi
	movq	(%rdx), %r13
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1413
	subq	80(%r14), %r13
	movl	$1, %edx
	cmove	%rdx, %r13
	cqto
	idivq	%r13
	cmpq	%rax, %rcx
	jge	.L1206
	movq	%r14, %rax
	movq	%r14, %rdx
	shrq	$3, %rax
	andl	$7, %edx
	movzbl	2147450880(%rax), %eax
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L1414
.L1275:
	movq	%r9, %rax
	movq	%r9, %rdx
	movl	$3, (%r14)
	shrq	$3, %rax
	andl	$7, %edx
	movzbl	2147450880(%rax), %eax
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L1415
.L1276:
	movl	704(%r12), %edi
	call	fdwatch_del_fd
	movq	8(%rsp), %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1416
	movq	8(%r14), %rax
	leaq	200(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1417
	movq	24(%rsp), %rdx
	movq	200(%rax), %rax
	cmpb	$0, 2147450880(%rdx)
	jne	.L1418
	cqto
	leaq	112(%rsp), %rdi
	idivq	64(%r14)
	movl	%eax, %r15d
	movq	%rdi, %rax
	shrq	$3, %rax
	subl	%r13d, %r15d
	cmpb	$0, 2147450880(%rax)
	jne	.L1419
	leaq	96(%r14), %r13
	movq	%r14, 112(%rsp)
	movq	%r13, %r12
	shrq	$3, %r12
	cmpb	$0, 2147450880(%r12)
	jne	.L1420
	cmpq	$0, 96(%r14)
	je	.L1282
	movl	$.LC98, %esi
	movl	$3, %edi
	xorl	%eax, %eax
	call	syslog
.L1282:
	testl	%r15d, %r15d
	movl	$500, %ecx
	jle	.L1283
	movslq	%r15d, %rcx
	imulq	$1000, %rcx, %rcx
.L1283:
	movq	112(%rsp), %rdx
	movq	(%rsp), %rdi
	xorl	%r8d, %r8d
	movl	$wakeup_connection, %esi
	call	tmr_create
	cmpb	$0, 2147450880(%r12)
	je	.L1240
	movq	%r13, %rdi
	call	__asan_report_store8
	.p2align 4,,10
	.p2align 3
.L1211:
	leaq	368(%r12), %rdi
	movq	%rdi, %rcx
	shrq	$3, %rcx
	cmpb	$0, 2147450880(%rcx)
	jne	.L1421
	leaq	176(%rsp), %rsi
	movq	368(%r12), %rcx
	movq	%rsi, %rdi
	shrq	$3, %rdi
	cmpb	$0, 2147450880(%rdi)
	jne	.L1422
	leaq	8(%rsi), %rdi
	movq	%rcx, 176(%rsp)
	movq	%rdi, %rcx
	shrq	$3, %rcx
	cmpb	$0, 2147450880(%rcx)
	jne	.L1423
	leaq	712(%r12), %rdi
	movq	%rdx, 184(%rsp)
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1424
	leaq	136(%r14), %r13
	movq	712(%r12), %rcx
	movq	%r13, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1425
	leaq	16(%rsi), %rdi
	movq	136(%r14), %rdx
	movq	%rdi, %r8
	shrq	$3, %r8
	addq	%rdx, %rcx
	cmpb	$0, 2147450880(%r8)
	jne	.L1426
	movq	%rcx, 192(%rsp)
	leaq	128(%r14), %rcx
	movq	%rcx, 16(%rsp)
	shrq	$3, %rcx
	cmpb	$0, 2147450880(%rcx)
	jne	.L1427
	movq	128(%r14), %rcx
	leaq	24(%rsi), %rdi
	subq	%rdx, %rcx
	movq	%rdi, %rdx
	cmpq	%rcx, %rax
	cmova	%rcx, %rax
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1428
	leaq	704(%r12), %r9
	movq	%rax, 200(%rsp)
	movq	%r9, %rax
	movq	%r9, %rdx
	shrq	$3, %rax
	andl	$7, %edx
	movzbl	2147450880(%rax), %eax
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L1429
.L1225:
	movl	704(%r12), %edi
	movl	$2, %edx
	movq	%r9, 56(%rsp)
	call	writev
	testl	%eax, %eax
	movq	56(%rsp), %r9
	jns	.L1226
.L1396:
	movq	%r9, 8(%rsp)
	call	__errno_location
	movq	%rax, %rdx
	movq	%rax, %rcx
	movq	8(%rsp), %r9
	shrq	$3, %rdx
	andl	$7, %ecx
	movzbl	2147450880(%rdx), %edx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L1430
.L1227:
	movl	(%rax), %eax
	cmpl	$4, %eax
	je	.L1206
	cmpl	$11, %eax
	je	.L1230
	cmpl	$32, %eax
	je	.L1241
	cmpl	$22, %eax
	.p2align 4,,2
	je	.L1241
	cmpl	$104, %eax
	.p2align 4,,2
	je	.L1241
	leaq	208(%r12), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1431
	movq	208(%r12), %rdx
	movl	$.LC100, %esi
	movl	$3, %edi
	xorl	%eax, %eax
	call	syslog
.L1241:
	movq	(%rsp), %rsi
	movq	%r14, %rdi
	call	clear_connection
	jmp	.L1206
	.p2align 4,,10
	.p2align 3
.L1230:
	leaq	112(%r14), %r15
	movq	%r15, %r13
	shrq	$3, %r13
	cmpb	$0, 2147450880(%r13)
	jne	.L1432
	movq	%r14, %rax
	movq	%r14, %rdx
	addq	$100, 112(%r14)
	shrq	$3, %rax
	andl	$7, %edx
	movzbl	2147450880(%rax), %eax
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L1433
.L1234:
	movq	%r9, %rax
	movq	%r9, %rdx
	movl	$3, (%r14)
	shrq	$3, %rax
	andl	$7, %edx
	movzbl	2147450880(%rax), %eax
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L1434
.L1235:
	movl	704(%r12), %edi
	call	fdwatch_del_fd
	leaq	112(%rsp), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1435
	leaq	96(%r14), %rax
	movq	%r14, 112(%rsp)
	movq	%rax, %r12
	movq	%rax, 8(%rsp)
	shrq	$3, %r12
	cmpb	$0, 2147450880(%r12)
	jne	.L1436
	cmpq	$0, 96(%r14)
	je	.L1238
	movl	$.LC98, %esi
	movl	$3, %edi
	xorl	%eax, %eax
	call	syslog
.L1238:
	cmpb	$0, 2147450880(%r13)
	jne	.L1437
	movq	112(%r14), %rcx
	movq	112(%rsp), %rdx
	xorl	%r8d, %r8d
	movq	(%rsp), %rdi
	movl	$wakeup_connection, %esi
	call	tmr_create
	cmpb	$0, 2147450880(%r12)
	jne	.L1438
.L1240:
	testq	%rax, %rax
	movq	%rax, 96(%r14)
	je	.L1439
.L1206:
	movq	$0, 2147450880(%rbx)
	movl	$0, 8(%rbp)
	movl	$0, 16(%rbp)
	addq	$248, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L1410:
	.cfi_restore_state
	subq	$100, %rdx
	movq	%rdx, 112(%r14)
	jmp	.L1269
	.p2align 4,,10
	.p2align 3
.L1400:
	leaq	368(%r12), %rdi
	subl	%eax, %ecx
	movslq	%ecx, %rcx
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1440
	movq	368(%r12), %rdi
	addq	%rdi, %rsi
	testq	%rcx, %rcx
	je	.L1251
	movq	%rsi, %rax
	movq	%rsi, %rdx
	shrq	$3, %rax
	andl	$7, %edx
	movzbl	2147450880(%rax), %eax
	cmpb	%dl, %al
	setle	%r11b
	testb	%al, %al
	setne	%al
	andl	%eax, %r11d
	leaq	-1(%rcx), %rax
	leaq	(%rsi,%rax), %r8
	movq	%rax, 56(%rsp)
	movq	%r8, %rax
	movq	%r8, %rdx
	shrq	$3, %rax
	andl	$7, %edx
	movzbl	2147450880(%rax), %eax
	cmpb	%dl, %al
	jg	.L1252
	testb	%al, %al
	jne	.L1441
.L1252:
	testb	%r11b, %r11b
	jne	.L1442
	movq	%rdi, %rax
	movq	%rdi, %rdx
	movq	56(%rsp), %r8
	shrq	$3, %rax
	andl	$7, %edx
	movzbl	2147450880(%rax), %eax
	cmpb	%dl, %al
	setle	%r11b
	testb	%al, %al
	setne	%al
	addq	%rdi, %r8
	andl	%eax, %r11d
	movq	%r8, %rax
	movq	%r8, %rdx
	shrq	$3, %rax
	andl	$7, %edx
	movzbl	2147450880(%rax), %eax
	cmpb	%dl, %al
	jle	.L1443
.L1254:
	testb	%r11b, %r11b
	je	.L1251
	call	__asan_report_store1
	.p2align 4,,10
	.p2align 3
.L1408:
	movq	(%rsp), %rsi
	movq	%r14, %rdi
	call	finish_connection
	jmp	.L1206
.L1251:
	movq	%rcx, %rdx
	movq	%r9, 72(%rsp)
	movq	%r10, 64(%rsp)
	movq	%rcx, 56(%rsp)
	call	memmove
	cmpb	$0, 2147450880(%r15)
	movq	56(%rsp), %rcx
	movq	64(%rsp), %r10
	movq	72(%rsp), %r9
	jne	.L1444
	movq	%rcx, 472(%r12)
	xorl	%r11d, %r11d
	jmp	.L1248
.L1405:
	testb	%sil, %sil
	je	.L1263
	movq	%rcx, %rdi
	call	__asan_report_load4
.L1440:
	call	__asan_report_load8
.L1441:
	movq	%r8, %rdi
	call	__asan_report_load1
.L1443:
	testb	%al, %al
	je	.L1254
	movq	%r8, %rdi
	call	__asan_report_store1
.L1442:
	movq	%rsi, %rdi
	call	__asan_report_load1
.L1420:
	movq	%r13, %rdi
	call	__asan_report_load8
.L1419:
	call	__asan_report_store8
.L1418:
	movq	40(%rsp), %rdi
	call	__asan_report_load8
.L1417:
	call	__asan_report_load8
.L1416:
	movq	48(%rsp), %rdi
	call	__asan_report_load8
.L1415:
	testb	%al, %al
	je	.L1276
	movq	%r9, %rdi
	call	__asan_report_load4
.L1414:
	testb	%al, %al
	je	.L1275
	movq	%r14, %rdi
	call	__asan_report_store4
.L1395:
	testb	%al, %al
	je	.L1215
	movq	%r9, %rdi
	call	__asan_report_load4
.L1394:
	call	__asan_report_load8
.L1393:
	movq	%r13, %rdi
	call	__asan_report_load8
.L1392:
	movq	16(%rsp), %rdi
	call	__asan_report_load8
.L1391:
	movq	%rdx, %rdi
	call	__asan_report_load8
.L1390:
	movq	40(%rsp), %rdi
	call	__asan_report_load8
.L1389:
	movq	48(%rsp), %rdi
	call	__asan_report_load8
.L1429:
	testb	%al, %al
	je	.L1225
	movq	%r9, %rdi
	call	__asan_report_load4
.L1428:
	call	__asan_report_store8
.L1427:
	movq	16(%rsp), %rdi
	call	__asan_report_load8
.L1426:
	call	__asan_report_store8
.L1425:
	movq	%r13, %rdi
	call	__asan_report_load8
.L1424:
	call	__asan_report_load8
.L1423:
	call	__asan_report_store8
.L1422:
	movq	%rsi, %rdi
	call	__asan_report_store8
.L1421:
	call	__asan_report_load8
.L1435:
	call	__asan_report_store8
.L1436:
	movq	%rax, %rdi
	call	__asan_report_load8
.L1437:
	movq	%r15, %rdi
	call	__asan_report_load8
.L1438:
	movq	8(%rsp), %rdi
	call	__asan_report_store8
.L1439:
	movl	$2, %edi
	movl	$.LC99, %esi
	xorl	%eax, %eax
	call	syslog
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L1401:
	movq	%r13, %rdi
	call	__asan_report_load8
.L1402:
	movq	48(%rsp), %rdi
	call	__asan_report_load8
.L1403:
	call	__asan_report_load8
.L1433:
	testb	%al, %al
	je	.L1234
	movq	%r14, %rdi
	call	__asan_report_store4
.L1434:
	testb	%al, %al
	je	.L1235
	movq	%r9, %rdi
	call	__asan_report_load4
.L1432:
	movq	%r15, %rdi
	call	__asan_report_load8
.L1411:
	movq	40(%rsp), %rdi
	call	__asan_report_load8
.L1397:
	movq	(%rsp), %rdi
	call	__asan_report_load8
.L1398:
	call	__asan_report_store8
.L1399:
	movq	32(%rsp), %rdi
	call	__asan_report_load8
.L1430:
	testb	%dl, %dl
	je	.L1227
	movq	%rax, %rdi
	call	__asan_report_load4
.L1406:
	call	__asan_report_load8
.L1407:
	movq	16(%rsp), %rdi
	call	__asan_report_load8
.L1404:
	testb	%cl, %cl
	je	.L1259
	call	__asan_report_load4
.L1409:
	.p2align 4,,6
	call	__asan_report_load8
.L1412:
	movq	(%rsp), %rdi
	call	__asan_report_load8
.L1413:
	call	__asan_report_load8
.L1444:
	movq	32(%rsp), %rdi
	call	__asan_report_store8
.L1431:
	call	__asan_report_load8
	.cfi_endproc
.LFE21:
	.size	handle_send, .-handle_send
	.p2align 4,,15
	.type	linger_clear_connection, @function
linger_clear_connection:
.LFB31:
	.cfi_startproc
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	movq	%rsp, %rax
	movq	%rdi, (%rsp)
	movq	%rsp, %rdi
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1449
	movq	(%rsp), %rdi
	leaq	104(%rdi), %rax
	movq	%rax, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1450
	movq	$0, 104(%rdi)
	call	really_clear_connection
	addq	$24, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L1449:
	.cfi_restore_state
	call	__asan_report_load8
.L1450:
	movq	%rax, %rdi
	call	__asan_report_store8
	.cfi_endproc
.LFE31:
	.size	linger_clear_connection, .-linger_clear_connection
	.section	.rodata.str1.8
	.align 8
.LC101:
	.string	"handle_linger 1 32 4096 3 buf "
	.text
	.p2align 4,,15
	.type	handle_linger, @function
handle_linger:
.LFB22:
	.cfi_startproc
	pushq	%r13
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	pushq	%r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	pushq	%rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	movq	%rdi, %rbp
	leaq	8(%rdi), %rdi
	pushq	%rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	movq	%rdi, %rax
	shrq	$3, %rax
	subq	$4168, %rsp
	.cfi_def_cfa_offset 4208
	movq	%rsp, %rbx
	movq	$1102416563, (%rsp)
	movq	$.LC101, 8(%rsp)
	shrq	$3, %rbx
	leaq	2147450880(%rbx), %r12
	movl	$-235802127, 2147450880(%rbx)
	movl	$-202116109, 516(%r12)
	cmpb	$0, 2147450880(%rax)
	jne	.L1473
	movq	8(%rbp), %rax
	movq	%rsi, %r13
	leaq	704(%rax), %rdi
	movq	%rdi, %rdx
	movq	%rdi, %rcx
	shrq	$3, %rdx
	andl	$7, %ecx
	movzbl	2147450880(%rdx), %edx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L1474
.L1453:
	movl	704(%rax), %edi
	leaq	32(%rsp), %rsi
	movl	$4096, %edx
	call	read
	testl	%eax, %eax
	js	.L1475
	je	.L1457
.L1451:
	movl	$0, 2147450880(%rbx)
	movl	$0, 516(%r12)
	addq	$4168, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%rbp
	.cfi_def_cfa_offset 24
	popq	%r12
	.cfi_def_cfa_offset 16
	popq	%r13
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L1475:
	.cfi_restore_state
	call	__errno_location
	movq	%rax, %rdx
	movq	%rax, %rcx
	shrq	$3, %rdx
	andl	$7, %ecx
	movzbl	2147450880(%rdx), %edx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L1476
.L1455:
	movl	(%rax), %eax
	cmpl	$11, %eax
	je	.L1451
	cmpl	$4, %eax
	je	.L1451
.L1457:
	movq	%r13, %rsi
	movq	%rbp, %rdi
	call	really_clear_connection
	jmp	.L1451
.L1474:
	testb	%dl, %dl
	je	.L1453
	.p2align 4,,9
	call	__asan_report_load4
.L1476:
	testb	%dl, %dl
	.p2align 4,,4
	je	.L1455
	movq	%rax, %rdi
	call	__asan_report_load4
.L1473:
	call	__asan_report_load8
	.cfi_endproc
.LFE22:
	.size	handle_linger, .-handle_linger
	.section	.rodata.str1.8
	.align 8
.LC102:
	.string	"lookup_hostname.constprop.1 3 32 8 2 ai 96 10 7 portstr 160 48 5 hints "
	.section	.rodata
	.align 32
.LC103:
	.string	"%d"
	.zero	61
	.align 32
.LC104:
	.string	"getaddrinfo %.80s - %.80s"
	.zero	38
	.align 32
.LC105:
	.string	"%s: getaddrinfo %s - %s\n"
	.zero	39
	.align 32
.LC106:
	.string	"%.80s - sockaddr too small (%lu < %lu)"
	.zero	57
	.text
	.p2align 4,,15
	.type	lookup_hostname.constprop.1, @function
lookup_hostname.constprop.1:
.LFB37:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	movq	%rdx, %r10
	movq	%rdi, %r15
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	movq	%rcx, %r14
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	movq	%rsi, %r13
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$280, %rsp
	.cfi_def_cfa_offset 336
	leaq	16(%rsp), %r12
	leaq	176(%rsp), %rbx
	movq	$1102416563, 16(%rsp)
	movq	$.LC102, 24(%rsp)
	shrq	$3, %r12
	movq	%rbx, %rax
	leaq	2147450880(%r12), %rbp
	shrq	$3, %rax
	movl	$-235802127, 2147450880(%r12)
	movl	$-185273344, 4(%rbp)
	movl	$-218959118, 8(%rbp)
	movl	$-185335296, 12(%rbp)
	movl	$-218959118, 16(%rbp)
	movl	$-185335808, 24(%rbp)
	movl	$-202116109, 28(%rbp)
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	jne	.L1704
.L1478:
	leaq	47(%rbx), %rdi
	movq	%rdi, %rax
	movq	%rdi, %rdx
	shrq	$3, %rax
	andl	$7, %edx
	movzbl	2147450880(%rax), %eax
	cmpb	%dl, %al
	jle	.L1705
.L1479:
	xorl	%eax, %eax
	movl	$6, %ecx
	movq	%rbx, %rdi
	rep stosq
	movq	%rbx, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	cmpb	$3, %al
	jle	.L1706
.L1480:
	leaq	8(%rbx), %rdi
	movl	$1, 176(%rsp)
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	cmpb	$3, %al
	jle	.L1707
.L1481:
	movzwl	port(%rip), %ecx
	leaq	112(%rsp), %rdi
	movl	$.LC103, %edx
	movl	$10, %esi
	xorl	%eax, %eax
	movq	%r10, 8(%rsp)
	movl	$1, 184(%rsp)
	call	snprintf
	movq	hostname(%rip), %rdi
	leaq	48(%rsp), %rcx
	leaq	112(%rsp), %rsi
	movq	%rbx, %rdx
	call	getaddrinfo
	testl	%eax, %eax
	movl	%eax, %ebx
	movq	8(%rsp), %r10
	jne	.L1708
	movq	48(%rsp), %rax
	testq	%rax, %rax
	je	.L1483
	xorl	%ebx, %ebx
	xorl	%r9d, %r9d
	jmp	.L1490
	.p2align 4,,10
	.p2align 3
.L1712:
	cmpl	$10, %edx
	jne	.L1485
	testq	%r9, %r9
	cmove	%rax, %r9
.L1485:
	leaq	40(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1709
	movq	40(%rax), %rax
	testq	%rax, %rax
	je	.L1710
.L1490:
	leaq	4(%rax), %rdi
	movq	%rdi, %rdx
	movq	%rdi, %rcx
	shrq	$3, %rdx
	andl	$7, %ecx
	movzbl	2147450880(%rdx), %edx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L1711
.L1484:
	movl	4(%rax), %edx
	cmpl	$2, %edx
	jne	.L1712
	testq	%rbx, %rbx
	cmove	%rax, %rbx
	jmp	.L1485
	.p2align 4,,10
	.p2align 3
.L1710:
	testq	%r9, %r9
	je	.L1713
	leaq	16(%r9), %r8
	movq	%r8, %r11
	movq	%r8, %rdx
	shrq	$3, %r11
	andl	$7, %edx
	movzbl	2147450880(%r11), %eax
	leal	3(%rdx), %esi
	cmpb	%al, %sil
	jge	.L1714
.L1494:
	movl	16(%r9), %eax
	cmpq	$128, %rax
	ja	.L1715
	movq	%r10, %rax
	movq	%r10, %rdx
	shrq	$3, %rax
	andl	$7, %edx
	movzbl	2147450880(%rax), %eax
	cmpb	%dl, %al
	jle	.L1716
.L1496:
	leaq	127(%r10), %rdi
	movq	%rdi, %rax
	movq	%rdi, %rdx
	shrq	$3, %rax
	andl	$7, %edx
	movzbl	2147450880(%rax), %eax
	cmpb	%dl, %al
	jle	.L1717
.L1497:
	testb	$1, %r10b
	movq	%r10, %rdi
	movl	$128, %edx
	jne	.L1718
.L1498:
	testb	$2, %dil
	jne	.L1719
.L1499:
	testb	$4, %dil
	jne	.L1720
.L1500:
	movl	%edx, %ecx
	xorl	%eax, %eax
	shrl	$3, %ecx
	testb	$4, %dl
	rep stosq
	jne	.L1721
.L1501:
	testb	$2, %dl
	jne	.L1722
.L1502:
	andl	$1, %edx
	jne	.L1723
.L1503:
	movzbl	2147450880(%r11), %eax
	cmpb	%al, %sil
	jge	.L1724
.L1504:
	leaq	24(%r9), %rdi
	movl	16(%r9), %edx
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1725
	testq	%rdx, %rdx
	movq	24(%r9), %rsi
	je	.L1506
	movq	%rsi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %ecx
	movq	%rsi, %rax
	andl	$7, %eax
	cmpb	%al, %cl
	setle	%al
	testb	%cl, %cl
	setne	%cl
	andl	%ecx, %eax
	leaq	-1(%rdx), %rcx
	leaq	(%rsi,%rcx), %rdi
	movq	%rdi, %r8
	movq	%rdi, %r9
	shrq	$3, %r8
	andl	$7, %r9d
	movzbl	2147450880(%r8), %r8d
	cmpb	%r9b, %r8b
	jg	.L1507
	testb	%r8b, %r8b
	jne	.L1726
.L1507:
	testb	%al, %al
	jne	.L1727
	leaq	(%r10,%rcx), %rdi
	movq	%rdi, %rax
	movq	%rdi, %rcx
	shrq	$3, %rax
	andl	$7, %ecx
	movzbl	2147450880(%rax), %eax
	cmpb	%cl, %al
	jg	.L1506
	testb	%al, %al
	je	.L1506
	call	__asan_report_store1
	.p2align 4,,10
	.p2align 3
.L1506:
	movq	%r10, %rdi
	call	memmove
	movq	%r14, %rax
	movq	%r14, %rdx
	shrq	$3, %rax
	andl	$7, %edx
	movzbl	2147450880(%rax), %eax
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L1728
.L1509:
	movl	$1, (%r14)
.L1493:
	testq	%rbx, %rbx
	je	.L1729
	leaq	16(%rbx), %rsi
	movq	%rsi, %r10
	movq	%rsi, %r9
	shrq	$3, %r10
	andl	$7, %r9d
	movzbl	2147450880(%r10), %eax
	addl	$3, %r9d
	cmpb	%al, %r9b
	jge	.L1730
.L1513:
	movl	16(%rbx), %r8d
	cmpq	$128, %r8
	ja	.L1703
	movq	%r15, %rax
	movq	%r15, %rdx
	shrq	$3, %rax
	andl	$7, %edx
	movzbl	2147450880(%rax), %eax
	cmpb	%dl, %al
	jle	.L1731
.L1515:
	leaq	127(%r15), %rdi
	movq	%rdi, %rax
	movq	%rdi, %rdx
	shrq	$3, %rax
	andl	$7, %edx
	movzbl	2147450880(%rax), %eax
	cmpb	%dl, %al
	jle	.L1732
.L1516:
	testb	$1, %r15b
	movq	%r15, %rdi
	movl	$128, %edx
	jne	.L1733
.L1517:
	testb	$2, %dil
	jne	.L1734
.L1518:
	testb	$4, %dil
	jne	.L1735
.L1519:
	movl	%edx, %ecx
	xorl	%eax, %eax
	shrl	$3, %ecx
	testb	$4, %dl
	rep stosq
	jne	.L1736
.L1520:
	testb	$2, %dl
	jne	.L1737
.L1521:
	andl	$1, %edx
	jne	.L1738
.L1522:
	movzbl	2147450880(%r10), %eax
	cmpb	%al, %r9b
	jge	.L1739
.L1523:
	leaq	24(%rbx), %rdi
	movl	16(%rbx), %edx
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1740
	testq	%rdx, %rdx
	movq	24(%rbx), %rsi
	je	.L1525
	movq	%rsi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %ecx
	movq	%rsi, %rax
	andl	$7, %eax
	cmpb	%al, %cl
	setle	%al
	testb	%cl, %cl
	setne	%cl
	andl	%ecx, %eax
	leaq	-1(%rdx), %rcx
	leaq	(%rsi,%rcx), %rdi
	movq	%rdi, %r8
	movq	%rdi, %r9
	shrq	$3, %r8
	andl	$7, %r9d
	movzbl	2147450880(%r8), %r8d
	cmpb	%r9b, %r8b
	jg	.L1526
	testb	%r8b, %r8b
	jne	.L1741
.L1526:
	testb	%al, %al
	jne	.L1742
	leaq	(%r15,%rcx), %rdi
	movq	%rdi, %rax
	movq	%rdi, %rcx
	shrq	$3, %rax
	andl	$7, %ecx
	movzbl	2147450880(%rax), %eax
	cmpb	%cl, %al
	jg	.L1525
	testb	%al, %al
	je	.L1525
	call	__asan_report_store1
	.p2align 4,,10
	.p2align 3
.L1525:
	movq	%r15, %rdi
	call	memmove
	movq	%r13, %rax
	movq	%r13, %rdx
	shrq	$3, %rax
	andl	$7, %edx
	movzbl	2147450880(%rax), %eax
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L1743
.L1528:
	movl	$1, 0(%r13)
.L1512:
	movq	48(%rsp), %rdi
	call	freeaddrinfo
	movq	$0, 2147450880(%r12)
	movq	$0, 8(%rbp)
	movl	$0, 16(%rbp)
	movq	$0, 24(%rbp)
	addq	$280, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
.L1738:
	.cfi_restore_state
	movb	$0, (%rdi)
	jmp	.L1522
.L1737:
	movw	$0, (%rdi)
	addq	$2, %rdi
	jmp	.L1521
.L1736:
	movl	$0, (%rdi)
	addq	$4, %rdi
	jmp	.L1520
.L1723:
	movb	$0, (%rdi)
	jmp	.L1503
.L1722:
	movw	$0, (%rdi)
	addq	$2, %rdi
	jmp	.L1502
.L1721:
	movl	$0, (%rdi)
	addq	$4, %rdi
	jmp	.L1501
.L1713:
	movq	%rbx, %rax
.L1483:
	movq	%r14, %rdx
	movq	%r14, %rcx
	shrq	$3, %rdx
	andl	$7, %ecx
	movzbl	2147450880(%rdx), %edx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L1744
.L1492:
	movl	$0, (%r14)
	movq	%rax, %rbx
	jmp	.L1493
.L1729:
	movq	%r13, %rax
	movq	%r13, %rdx
	shrq	$3, %rax
	andl	$7, %edx
	movzbl	2147450880(%rax), %eax
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L1745
.L1511:
	movl	$0, 0(%r13)
	jmp	.L1512
.L1734:
	movw	$0, (%rdi)
	subl	$2, %edx
	addq	$2, %rdi
	jmp	.L1518
.L1735:
	movl	$0, (%rdi)
	subl	$4, %edx
	addq	$4, %rdi
	jmp	.L1519
.L1733:
	movb	$0, (%r15)
	leaq	1(%r15), %rdi
	movb	$127, %dl
	jmp	.L1517
.L1718:
	movb	$0, (%r10)
	leaq	1(%r10), %rdi
	movb	$127, %dl
	jmp	.L1498
.L1719:
	movw	$0, (%rdi)
	subl	$2, %edx
	addq	$2, %rdi
	jmp	.L1499
.L1720:
	movl	$0, (%rdi)
	subl	$4, %edx
	addq	$4, %rdi
	jmp	.L1500
.L1711:
	testb	%dl, %dl
	je	.L1484
	call	__asan_report_load4
.L1745:
	testb	%al, %al
	.p2align 4,,4
	je	.L1511
	movq	%r13, %rdi
	call	__asan_report_store4
.L1744:
	testb	%dl, %dl
	je	.L1492
	movq	%r14, %rdi
	call	__asan_report_store4
.L1724:
	testb	%al, %al
	je	.L1504
	movq	%r8, %rdi
	call	__asan_report_load4
.L1717:
	testb	%al, %al
	je	.L1497
	call	__asan_report_store1
.L1716:
	testb	%al, %al
	.p2align 4,,4
	je	.L1496
	movq	%r10, %rdi
	call	__asan_report_store1
.L1715:
	movq	%rax, %r8
.L1703:
	movq	hostname(%rip), %rdx
	movl	$2, %edi
	movl	$128, %ecx
	movl	$.LC106, %esi
	xorl	%eax, %eax
	call	syslog
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L1714:
	testb	%al, %al
	je	.L1494
	movq	%r8, %rdi
	call	__asan_report_load4
.L1732:
	testb	%al, %al
	je	.L1516
	call	__asan_report_store1
.L1731:
	testb	%al, %al
	.p2align 4,,4
	je	.L1515
	movq	%r15, %rdi
	call	__asan_report_store1
.L1708:
	movl	%eax, %edi
	call	gai_strerror
	movq	hostname(%rip), %rdx
	movq	%rax, %rcx
	movl	$.LC104, %esi
	movl	$2, %edi
	xorl	%eax, %eax
	call	syslog
	movl	%ebx, %edi
	call	gai_strerror
	movq	stderr(%rip), %rdi
	movq	hostname(%rip), %rcx
	movq	%rax, %r8
	movq	argv0(%rip), %rdx
	movl	$.LC105, %esi
	xorl	%eax, %eax
	call	fprintf
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L1707:
	testb	%al, %al
	je	.L1481
	call	__asan_report_store4
.L1706:
	testb	%al, %al
	.p2align 4,,4
	je	.L1480
	movq	%rbx, %rdi
	call	__asan_report_store4
.L1705:
	testb	%al, %al
	je	.L1479
	call	__asan_report_store1
.L1704:
	cmpb	$0, %al
	.p2align 4,,4
	jg	.L1478
	movq	%rbx, %rdi
	call	__asan_report_store1
.L1743:
	testb	%al, %al
	je	.L1528
	movq	%r13, %rdi
	call	__asan_report_store4
.L1740:
	call	__asan_report_load8
.L1741:
	call	__asan_report_load1
.L1742:
	movq	%rsi, %rdi
	call	__asan_report_load1
.L1730:
	testb	%al, %al
	je	.L1513
	movq	%rsi, %rdi
	call	__asan_report_load4
.L1726:
	call	__asan_report_load1
.L1728:
	testb	%al, %al
	je	.L1509
	movq	%r14, %rdi
	call	__asan_report_store4
.L1725:
	call	__asan_report_load8
.L1727:
	movq	%rsi, %rdi
	call	__asan_report_load1
.L1709:
	call	__asan_report_load8
.L1739:
	testb	%al, %al
	je	.L1523
	movq	%rsi, %rdi
	call	__asan_report_load4
	.cfi_endproc
.LFE37:
	.size	lookup_hostname.constprop.1, .-lookup_hostname.constprop.1
	.section	.rodata.str1.8
	.align 8
.LC107:
	.string	"main 6 32 4 5 gotv4 96 4 5 gotv6 160 16 2 tv 224 128 3 sa4 384 128 3 sa6 544 4097 3 cwd "
	.section	.rodata
	.align 32
.LC108:
	.string	"can't find any valid address"
	.zero	35
	.align 32
.LC109:
	.string	"%s: can't find any valid address\n"
	.zero	62
	.align 32
.LC110:
	.string	"unknown user - '%.80s'"
	.zero	41
	.align 32
.LC111:
	.string	"%s: unknown user - '%s'\n"
	.zero	39
	.align 32
.LC112:
	.string	"/dev/null"
	.zero	54
	.align 32
.LC113:
	.string	"logfile is not an absolute path, you may not be able to re-open it"
	.zero	61
	.align 32
.LC114:
	.string	"%s: logfile is not an absolute path, you may not be able to re-open it\n"
	.zero	56
	.align 32
.LC115:
	.string	"fchown logfile - %m"
	.zero	44
	.align 32
.LC116:
	.string	"fchown logfile"
	.zero	49
	.align 32
.LC117:
	.string	"chdir - %m"
	.zero	53
	.align 32
.LC118:
	.string	"chdir"
	.zero	58
	.align 32
.LC119:
	.string	"/"
	.zero	62
	.align 32
.LC120:
	.string	"daemon - %m"
	.zero	52
	.align 32
.LC121:
	.string	"w"
	.zero	62
	.align 32
.LC122:
	.string	"%d\n"
	.zero	60
	.align 32
.LC123:
	.string	"fdwatch initialization failure"
	.zero	33
	.align 32
.LC124:
	.string	"chroot - %m"
	.zero	52
	.align 32
.LC125:
	.string	"logfile is not within the chroot tree, you will not be able to re-open it"
	.zero	54
	.align 32
.LC126:
	.string	"%s: logfile is not within the chroot tree, you will not be able to re-open it\n"
	.zero	49
	.align 32
.LC127:
	.string	"chroot chdir - %m"
	.zero	46
	.align 32
.LC128:
	.string	"chroot chdir"
	.zero	51
	.align 32
.LC129:
	.string	"data_dir chdir - %m"
	.zero	44
	.align 32
.LC130:
	.string	"data_dir chdir"
	.zero	49
	.align 32
.LC131:
	.string	"tmr_create(occasional) failed"
	.zero	34
	.align 32
.LC132:
	.string	"tmr_create(idle) failed"
	.zero	40
	.align 32
.LC133:
	.string	"tmr_create(update_throttles) failed"
	.zero	60
	.align 32
.LC134:
	.string	"tmr_create(show_stats) failed"
	.zero	34
	.align 32
.LC135:
	.string	"setgroups - %m"
	.zero	49
	.align 32
.LC136:
	.string	"setgid - %m"
	.zero	52
	.align 32
.LC137:
	.string	"initgroups - %m"
	.zero	48
	.align 32
.LC138:
	.string	"setuid - %m"
	.zero	52
	.align 32
.LC139:
	.string	"started as root without requesting chroot(), warning only"
	.zero	38
	.align 32
.LC140:
	.string	"out of memory allocating a connecttab"
	.zero	58
	.align 32
.LC141:
	.string	"fdwatch - %m"
	.zero	51
	.section	.text.startup,"ax",@progbits
	.p2align 4,,15
	.globl	main
	.type	main, @function
main:
.LFB9:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	movq	%rsi, %rax
	shrq	$3, %rax
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	movq	%rsi, %rbp
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$4824, %rsp
	.cfi_def_cfa_offset 4880
	leaq	112(%rsp), %rdx
	movq	$1102416563, 112(%rsp)
	movq	$.LC107, 120(%rsp)
	shrq	$3, %rdx
	movl	$-235802127, 2147450880(%rdx)
	movl	$-185273340, 2147450884(%rdx)
	movl	$-218959118, 2147450888(%rdx)
	movl	$-185273340, 2147450892(%rdx)
	movl	$-218959118, 2147450896(%rdx)
	movl	$-185335808, 2147450900(%rdx)
	movl	$-218959118, 2147450904(%rdx)
	movl	$-218959118, 2147450924(%rdx)
	movl	$-218959118, 2147450944(%rdx)
	movl	$-185273343, 2147451460(%rdx)
	movl	$-202116109, 2147451464(%rdx)
	cmpb	$0, 2147450880(%rax)
	jne	.L2096
	movq	(%rsi), %rbx
	movl	%edi, %r12d
	movl	$47, %esi
	movq	%rbx, %rdi
	movq	%rbx, argv0(%rip)
	call	strrchr
	leaq	1(%rax), %rdx
	testq	%rax, %rax
	movl	$9, %esi
	cmovne	%rdx, %rbx
	movl	$24, %edx
	movq	%rbx, %rdi
	call	openlog
	movq	%rbp, %rsi
	movl	%r12d, %edi
	leaq	336(%rsp), %rbp
	leaq	496(%rsp), %r12
	call	parse_args
	call	tzset
	leaq	208(%rsp), %rcx
	leaq	144(%rsp), %rsi
	movq	%r12, %rdx
	movq	%rbp, %rdi
	call	lookup_hostname.constprop.1
	movl	144(%rsp), %ecx
	testl	%ecx, %ecx
	jne	.L1749
	cmpl	$0, 208(%rsp)
	je	.L2097
.L1749:
	movq	throttlefile(%rip), %rdi
	movl	$0, numthrottles(%rip)
	movl	$0, maxthrottles(%rip)
	movq	$0, throttles(%rip)
	testq	%rdi, %rdi
	je	.L1750
	call	read_throttlefile
.L1750:
	call	getuid
	testl	%eax, %eax
	movl	$32767, 96(%rsp)
	movl	$32767, 100(%rsp)
	je	.L2098
.L1751:
	movq	logfile(%rip), %rbx
	testq	%rbx, %rbx
	je	.L1856
	movl	$.LC112, %edi
	movl	$10, %ecx
	movq	%rbx, %rsi
	repz cmpsb
	je	.L2099
	movl	$.LC81, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L1757
	movq	stdout(%rip), %r14
.L1755:
	movq	dir(%rip), %rdi
	testq	%rdi, %rdi
	je	.L1762
	call	chdir
	testl	%eax, %eax
	js	.L2100
.L1762:
	leaq	656(%rsp), %rbx
	movl	$4096, %esi
	movq	%rbx, %r15
	movq	%rbx, %rdi
	shrq	$3, %r15
	call	getcwd
	movzbl	2147450880(%r15), %eax
	xorl	%ecx, %ecx
	cmpb	%al, %cl
	jge	.L2101
.L1763:
	movq	%rbx, %rdx
.L1764:
	movl	(%rdx), %ecx
	addq	$4, %rdx
	leal	-16843009(%rcx), %eax
	notl	%ecx
	andl	%ecx, %eax
	andl	$-2139062144, %eax
	je	.L1764
	movl	%eax, %ecx
	shrl	$16, %ecx
	testl	$32896, %eax
	cmove	%ecx, %eax
	leaq	2(%rdx), %rcx
	cmove	%rcx, %rdx
	addb	%al, %al
	sbbq	$3, %rdx
	subq	%rbx, %rdx
	leaq	(%rbx,%rdx), %rdi
	movq	%rdi, %rax
	movq	%rdi, %r10
	shrq	$3, %rax
	movzbl	2147450880(%rax), %r8d
	testb	%r8b, %r8b
	setne	%r9b
	andl	$7, %r10d
	cmpb	%r10b, %r8b
	jle	.L2102
.L1766:
	subq	$1, %rdx
	leaq	(%rbx,%rdx), %rax
	movq	%rax, %rcx
	movq	%rax, %rsi
	shrq	$3, %rcx
	andl	$7, %esi
	movzbl	2147450880(%rcx), %ecx
	cmpb	%sil, %cl
	jle	.L2103
.L1767:
	cmpb	$47, 656(%rsp,%rdx)
	je	.L1768
	movl	$.LC119, %eax
	movq	%rax, %rdx
	andl	$7, %eax
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	cmpb	%al, %dl
	jle	.L2104
.L1769:
	movl	$.LC119+1, %eax
	movq	%rax, %rdx
	andl	$7, %eax
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	cmpb	%al, %dl
	jle	.L2105
.L1770:
	testb	%r9b, %r9b
	jne	.L2106
.L1771:
	leaq	1(%rdi), %rax
	movq	%rax, %rdx
	movq	%rax, %rcx
	shrq	$3, %rdx
	andl	$7, %ecx
	movzbl	2147450880(%rdx), %edx
	cmpb	%cl, %dl
	jle	.L2107
.L1772:
	movw	$47, (%rdi)
.L1768:
	movl	debug(%rip), %edx
	testl	%edx, %edx
	jne	.L1773
	movq	stdin(%rip), %rdi
	call	fclose
	movq	stdout(%rip), %rdi
	cmpq	%rdi, %r14
	je	.L1774
	call	fclose
.L1774:
	movq	stderr(%rip), %rdi
	call	fclose
	movl	$1, %esi
	movl	$1, %edi
	call	daemon
	testl	%eax, %eax
	movl	$.LC120, %esi
	js	.L2092
.L1775:
	movq	pidfile(%rip), %rdi
	testq	%rdi, %rdi
	je	.L1776
	movl	$.LC121, %esi
	call	fopen
	testq	%rax, %rax
	movq	%rax, %r13
	je	.L2108
	call	getpid
	movq	%r13, %rdi
	movl	%eax, %edx
	movl	$.LC122, %esi
	xorl	%eax, %eax
	call	fprintf
	movq	%r13, %rdi
	call	fclose
.L1776:
	call	fdwatch_get_nfiles
	testl	%eax, %eax
	movl	%eax, max_connects(%rip)
	js	.L2109
	subl	$10, %eax
	cmpl	$0, do_chroot(%rip)
	movl	%eax, max_connects(%rip)
	jne	.L2110
.L1779:
	movq	data_dir(%rip), %rdi
	testq	%rdi, %rdi
	je	.L1789
	call	chdir
	testl	%eax, %eax
	js	.L2111
.L1789:
	movl	$handle_term, %esi
	movl	$15, %edi
	xorl	%eax, %eax
	call	sigset
	movl	$handle_term, %esi
	movl	$2, %edi
	xorl	%eax, %eax
	call	sigset
	movl	$handle_chld, %esi
	movl	$17, %edi
	xorl	%eax, %eax
	call	sigset
	movl	$1, %esi
	movl	$13, %edi
	xorl	%eax, %eax
	call	sigset
	movl	$handle_hup, %esi
	movl	$1, %edi
	xorl	%eax, %eax
	call	sigset
	movl	$handle_usr1, %esi
	movl	$10, %edi
	xorl	%eax, %eax
	call	sigset
	movl	$handle_usr2, %esi
	movl	$12, %edi
	xorl	%eax, %eax
	call	sigset
	movl	$handle_alrm, %esi
	movl	$14, %edi
	xorl	%eax, %eax
	call	sigset
	movl	$360, %edi
	movl	$0, got_hup(%rip)
	movl	$0, got_usr1(%rip)
	movl	$0, watchdog_flag(%rip)
	call	alarm
	call	tmr_init
	movl	no_empty_referers(%rip), %eax
	xorl	%esi, %esi
	cmpl	$0, 208(%rsp)
	movq	%r12, %rdx
	movzwl	port(%rip), %ecx
	movl	cgi_limit(%rip), %r9d
	movq	cgi_pattern(%rip), %r8
	movq	hostname(%rip), %rdi
	movl	%eax, 88(%rsp)
	movq	local_pattern(%rip), %rax
	cmove	%rsi, %rdx
	cmpl	$0, 144(%rsp)
	movq	%r14, 40(%rsp)
	movq	%rbx, 24(%rsp)
	movq	%rax, 80(%rsp)
	movq	url_pattern(%rip), %rax
	cmovne	%rbp, %rsi
	movq	%rax, 72(%rsp)
	movl	do_global_passwd(%rip), %eax
	movl	%eax, 64(%rsp)
	movl	do_vhost(%rip), %eax
	movl	%eax, 56(%rsp)
	movl	no_symlink_check(%rip), %eax
	movl	%eax, 48(%rsp)
	movl	no_log(%rip), %eax
	movl	%eax, 32(%rsp)
	movl	max_age(%rip), %eax
	movl	%eax, 16(%rsp)
	movq	p3p(%rip), %rax
	movq	%rax, 8(%rsp)
	movq	charset(%rip), %rax
	movq	%rax, (%rsp)
	call	httpd_initialize
	testq	%rax, %rax
	movq	%rax, hs(%rip)
	je	.L2093
	movq	JunkClientData(%rip), %rdx
	movl	$occasional, %esi
	xorl	%edi, %edi
	movl	$1, %r8d
	movl	$120000, %ecx
	call	tmr_create
	testq	%rax, %rax
	movl	$.LC131, %esi
	je	.L2094
	movq	JunkClientData(%rip), %rdx
	xorl	%edi, %edi
	movl	$1, %r8d
	movl	$5000, %ecx
	movl	$idle, %esi
	call	tmr_create
	testq	%rax, %rax
	je	.L2112
	cmpl	$0, numthrottles(%rip)
	jle	.L1795
	movq	JunkClientData(%rip), %rdx
	movl	$update_throttles, %esi
	xorl	%edi, %edi
	movl	$1, %r8d
	movl	$2000, %ecx
	call	tmr_create
	testq	%rax, %rax
	movl	$.LC133, %esi
	je	.L2094
.L1795:
	movq	JunkClientData(%rip), %rdx
	movl	$show_stats, %esi
	xorl	%edi, %edi
	movl	$1, %r8d
	movl	$3600000, %ecx
	call	tmr_create
	testq	%rax, %rax
	movl	$.LC134, %esi
	je	.L2094
	xorl	%edi, %edi
	call	time
	movq	$0, stats_connections(%rip)
	movq	%rax, stats_time(%rip)
	movq	%rax, start_time(%rip)
	movq	$0, stats_bytes(%rip)
	movl	$0, stats_simultaneous(%rip)
	call	getuid
	testl	%eax, %eax
	je	.L2113
.L1798:
	movl	max_connects(%rip), %ebx
	movslq	%ebx, %rbp
	imulq	$144, %rbp, %rbp
	movq	%rbp, %rdi
	call	malloc
	testq	%rax, %rax
	movq	%rax, connects(%rip)
	je	.L1804
	xorl	%ecx, %ecx
	testl	%ebx, %ebx
	movq	%rax, %rdx
	jle	.L1812
	.p2align 4,,10
	.p2align 3
.L2013:
	movq	%rdx, %rsi
	movq	%rdx, %rdi
	shrq	$3, %rsi
	andl	$7, %edi
	movzbl	2147450880(%rsi), %esi
	addl	$3, %edi
	cmpb	%sil, %dil
	jge	.L2114
.L1809:
	leaq	4(%rdx), %rdi
	addl	$1, %ecx
	movl	$0, (%rdx)
	movq	%rdi, %rsi
	movq	%rdi, %r8
	shrq	$3, %rsi
	andl	$7, %r8d
	movzbl	2147450880(%rsi), %esi
	addl	$3, %r8d
	cmpb	%sil, %r8b
	jge	.L2115
.L1810:
	leaq	8(%rdx), %rdi
	movl	%ecx, 4(%rdx)
	movq	%rdi, %rsi
	shrq	$3, %rsi
	cmpb	$0, 2147450880(%rsi)
	jne	.L2116
	movq	$0, 8(%rdx)
	addq	$144, %rdx
	cmpl	%ebx, %ecx
	jne	.L2013
.L1812:
	leaq	-144(%rax,%rbp), %rax
	leaq	4(%rax), %rdi
	movq	%rdi, %rdx
	movq	%rdi, %rcx
	shrq	$3, %rdx
	andl	$7, %ecx
	movzbl	2147450880(%rdx), %edx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L2117
.L1808:
	movl	$-1, 4(%rax)
	movq	hs(%rip), %rax
	movl	$0, first_free_connect(%rip)
	movl	$0, num_connects(%rip)
	movl	$0, httpd_conn_count(%rip)
	testq	%rax, %rax
	je	.L1815
	leaq	72(%rax), %rdi
	movq	%rdi, %rdx
	movq	%rdi, %rcx
	shrq	$3, %rdx
	andl	$7, %ecx
	movzbl	2147450880(%rdx), %edx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L2118
.L1816:
	movl	72(%rax), %edi
	cmpl	$-1, %edi
	je	.L1817
	xorl	%edx, %edx
	xorl	%esi, %esi
	call	fdwatch_add_fd
	movq	hs(%rip), %rax
.L1817:
	leaq	76(%rax), %rdi
	movq	%rdi, %rdx
	movq	%rdi, %rcx
	shrq	$3, %rdx
	andl	$7, %ecx
	movzbl	2147450880(%rdx), %edx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L2119
.L1818:
	movl	76(%rax), %edi
	cmpl	$-1, %edi
	je	.L1815
	xorl	%edx, %edx
	xorl	%esi, %esi
	call	fdwatch_add_fd
.L1815:
	leaq	272(%rsp), %rdi
	call	tmr_prepare_timeval
	.p2align 4,,10
	.p2align 3
.L1820:
	movl	terminate(%rip), %eax
	testl	%eax, %eax
	je	.L1854
	cmpl	$0, num_connects(%rip)
	jle	.L2120
.L1854:
	movl	got_hup(%rip), %eax
	testl	%eax, %eax
	jne	.L2121
.L1821:
	leaq	272(%rsp), %rdi
	call	tmr_mstimeout
	movq	%rax, %rdi
	call	fdwatch
	testl	%eax, %eax
	movl	%eax, %ebx
	js	.L2122
	leaq	272(%rsp), %rdi
	call	tmr_prepare_timeval
	testl	%ebx, %ebx
	je	.L2123
	movq	hs(%rip), %rax
	testq	%rax, %rax
	je	.L1840
	leaq	76(%rax), %rdi
	movq	%rdi, %rdx
	movq	%rdi, %rcx
	shrq	$3, %rdx
	andl	$7, %ecx
	movzbl	2147450880(%rdx), %edx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L2124
.L1830:
	movl	76(%rax), %edi
	cmpl	$-1, %edi
	je	.L1831
	call	fdwatch_check_fd
	testl	%eax, %eax
	jne	.L1832
.L1836:
	movq	hs(%rip), %rax
	testq	%rax, %rax
	je	.L1840
.L1831:
	leaq	72(%rax), %rdi
	movq	%rdi, %rdx
	movq	%rdi, %rcx
	shrq	$3, %rdx
	andl	$7, %ecx
	movzbl	2147450880(%rdx), %edx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L2125
.L1837:
	movl	72(%rax), %edi
	cmpl	$-1, %edi
	je	.L1840
	call	fdwatch_check_fd
	testl	%eax, %eax
	jne	.L2126
	.p2align 4,,10
	.p2align 3
.L1840:
	call	fdwatch_get_next_client_data
	cmpq	$-1, %rax
	movq	%rax, %rbx
	je	.L2127
	testq	%rbx, %rbx
	je	.L1840
	leaq	8(%rbx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L2128
	movq	8(%rbx), %rax
	leaq	704(%rax), %rdi
	movq	%rdi, %rdx
	movq	%rdi, %rcx
	shrq	$3, %rdx
	andl	$7, %ecx
	movzbl	2147450880(%rdx), %edx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L2129
.L1842:
	movl	704(%rax), %edi
	call	fdwatch_check_fd
	testl	%eax, %eax
	je	.L2130
	movq	%rbx, %rax
	movq	%rbx, %rdx
	shrq	$3, %rax
	andl	$7, %edx
	movzbl	2147450880(%rax), %eax
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L2131
.L1845:
	movl	(%rbx), %eax
	cmpl	$2, %eax
	je	.L1846
	cmpl	$4, %eax
	je	.L1847
	cmpl	$1, %eax
	jne	.L1840
	leaq	272(%rsp), %rsi
	movq	%rbx, %rdi
	call	handle_read
	jmp	.L1840
.L2099:
	movl	$1, no_log(%rip)
	xorl	%r14d, %r14d
	jmp	.L1755
.L2122:
	call	__errno_location
	movq	%rax, %rdx
	movq	%rax, %rcx
	shrq	$3, %rdx
	andl	$7, %ecx
	movzbl	2147450880(%rdx), %edx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L2132
.L1823:
	movl	(%rax), %eax
	cmpl	$11, %eax
	je	.L1820
	cmpl	$4, %eax
	je	.L1820
	movl	$.LC141, %esi
	movl	$3, %edi
.L2095:
	xorl	%eax, %eax
	call	syslog
.L2093:
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L1773:
	call	setsid
	jmp	.L1775
.L2098:
	movq	user(%rip), %rdi
	call	getpwnam
	testq	%rax, %rax
	je	.L2133
	leaq	16(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	jne	.L2134
.L1753:
	leaq	20(%rax), %rdi
	movl	16(%rax), %ebx
	movq	%rdi, %rdx
	movq	%rdi, %rcx
	shrq	$3, %rdx
	andl	$7, %ecx
	movl	%ebx, 100(%rsp)
	movzbl	2147450880(%rdx), %edx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L2135
.L1754:
	movl	20(%rax), %eax
	movl	%eax, 96(%rsp)
	jmp	.L1751
.L2097:
	movl	$.LC108, %esi
	movl	$3, %edi
	xorl	%eax, %eax
	call	syslog
	movq	stderr(%rip), %rdi
	movq	argv0(%rip), %rdx
	movl	$.LC109, %esi
	xorl	%eax, %eax
	call	fprintf
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L2113:
	xorl	%esi, %esi
	xorl	%edi, %edi
	call	setgroups
	testl	%eax, %eax
	movl	$.LC135, %esi
	js	.L2092
	movl	96(%rsp), %edi
	call	setgid
	testl	%eax, %eax
	movl	$.LC136, %esi
	js	.L2092
	movl	96(%rsp), %esi
	movq	user(%rip), %rdi
	call	initgroups
	testl	%eax, %eax
	js	.L2136
.L1801:
	movl	100(%rsp), %edi
	call	setuid
	testl	%eax, %eax
	movl	$.LC138, %esi
	js	.L2092
	cmpl	$0, do_chroot(%rip)
	jne	.L1798
	movl	$.LC139, %esi
	movl	$4, %edi
	xorl	%eax, %eax
	call	syslog
	jmp	.L1798
.L2112:
	movl	$.LC132, %esi
.L2094:
	movl	$2, %edi
	call	syslog
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L2130:
	leaq	272(%rsp), %rsi
	movq	%rbx, %rdi
	call	clear_connection
	jmp	.L1840
.L1847:
	leaq	272(%rsp), %rsi
	movq	%rbx, %rdi
	call	handle_linger
	jmp	.L1840
.L1846:
	leaq	272(%rsp), %rsi
	movq	%rbx, %rdi
	call	handle_send
	jmp	.L1840
.L2127:
	leaq	272(%rsp), %rdi
	call	tmr_run
	movl	got_usr1(%rip), %eax
	testl	%eax, %eax
	je	.L1820
	cmpl	$0, terminate(%rip)
	jne	.L1820
	movq	hs(%rip), %rax
	movl	$1, terminate(%rip)
	testq	%rax, %rax
	je	.L1820
	leaq	72(%rax), %rdi
	movq	%rdi, %rdx
	movq	%rdi, %rcx
	shrq	$3, %rdx
	andl	$7, %ecx
	movzbl	2147450880(%rdx), %edx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L2137
.L1850:
	movl	72(%rax), %edi
	cmpl	$-1, %edi
	je	.L1851
	call	fdwatch_del_fd
	movq	hs(%rip), %rax
.L1851:
	leaq	76(%rax), %rdi
	movq	%rdi, %rdx
	movq	%rdi, %rcx
	shrq	$3, %rdx
	andl	$7, %ecx
	movzbl	2147450880(%rdx), %edx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L2138
.L1852:
	movl	76(%rax), %edi
	cmpl	$-1, %edi
	je	.L1853
	call	fdwatch_del_fd
.L1853:
	movq	hs(%rip), %rdi
	call	httpd_unlisten
	jmp	.L1820
.L2121:
	call	re_open_logfile
	movl	$0, got_hup(%rip)
	jmp	.L1821
.L2109:
	movl	$.LC123, %esi
.L2092:
	movl	$2, %edi
	jmp	.L2095
.L2123:
	leaq	272(%rsp), %rdi
	call	tmr_run
	jmp	.L1820
.L2110:
	movq	%rbx, %rdi
	call	chroot
	testl	%eax, %eax
	.p2align 4,,3
	js	.L2139
	movq	logfile(%rip), %r13
	testq	%r13, %r13
	je	.L1781
	movl	$.LC81, %esi
	movq	%r13, %rdi
	call	strcmp
	testl	%eax, %eax
	je	.L1781
	movzbl	2147450880(%r15), %eax
	xorl	%ecx, %ecx
	cmpb	%al, %cl
	jge	.L2140
.L1782:
	xorl	%eax, %eax
	orq	$-1, %rcx
	movq	%rbx, %rdi
	repnz scasb
	notq	%rcx
	subq	$1, %rcx
	leaq	(%rbx,%rcx), %rdi
	movq	%rdi, %rax
	movq	%rdi, %rdx
	shrq	$3, %rax
	andl	$7, %edx
	movzbl	2147450880(%rax), %eax
	cmpb	%dl, %al
	jle	.L2141
.L1783:
	movq	%rcx, %rdx
	movq	%rbx, %rsi
	movq	%r13, %rdi
	movq	%rcx, 104(%rsp)
	call	strncmp
	testl	%eax, %eax
	movq	104(%rsp), %rcx
	jne	.L1784
	leaq	-1(%r13,%rcx), %rsi
	movq	%r13, %rdi
	call	strcpy
.L1781:
	movl	$.LC119, %eax
	movq	%rax, %rdx
	andl	$7, %eax
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	cmpb	%al, %dl
	jle	.L2142
.L1785:
	movl	$.LC119+1, %eax
	movq	%rax, %rdx
	andl	$7, %eax
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	cmpb	%al, %dl
	jle	.L2143
.L1786:
	movzbl	2147450880(%r15), %eax
	xorl	%ecx, %ecx
	cmpb	%al, %cl
	jge	.L2144
.L1787:
	leaq	1(%rbx), %rdi
	movq	%rdi, %rax
	movq	%rdi, %rdx
	shrq	$3, %rax
	andl	$7, %edx
	movzbl	2147450880(%rax), %eax
	cmpb	%dl, %al
	jle	.L2145
.L1788:
	movq	%rbx, %rdi
	movw	$47, 656(%rsp)
	call	chdir
	testl	%eax, %eax
	jns	.L1779
	movl	$.LC127, %esi
	xorl	%eax, %eax
	movl	$2, %edi
	call	syslog
	movl	$.LC128, %edi
	call	perror
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L1856:
	xorl	%r14d, %r14d
	jmp	.L1755
.L1757:
	movq	%rbx, %rdi
	movl	$.LC83, %esi
	call	fopen
	movq	logfile(%rip), %rbx
	movl	$384, %esi
	movq	%rax, %r14
	movq	%rbx, %rdi
	call	chmod
	testl	%eax, %eax
	jne	.L1859
	testq	%r14, %r14
	je	.L1859
	movq	%rbx, %rax
	movq	%rbx, %rdx
	shrq	$3, %rax
	andl	$7, %edx
	movzbl	2147450880(%rax), %eax
	cmpb	%dl, %al
	jle	.L2146
.L1760:
	cmpb	$47, (%rbx)
	je	.L1761
	movl	$.LC113, %esi
	movl	$4, %edi
	xorl	%eax, %eax
	call	syslog
	movq	argv0(%rip), %rdx
	movq	stderr(%rip), %rdi
	movl	$.LC114, %esi
	xorl	%eax, %eax
	call	fprintf
.L1761:
	movq	%r14, %rdi
	call	fileno
	movl	$1, %edx
	movl	%eax, %edi
	movl	$2, %esi
	xorl	%eax, %eax
	call	fcntl
	call	getuid
	testl	%eax, %eax
	jne	.L1755
	movq	%r14, %rdi
	call	fileno
	movl	96(%rsp), %edx
	movl	100(%rsp), %esi
	movl	%eax, %edi
	call	fchown
	testl	%eax, %eax
	jns	.L1755
	movl	$.LC115, %esi
	movl	$4, %edi
	xorl	%eax, %eax
	call	syslog
	movl	$.LC116, %edi
	call	perror
	jmp	.L1755
.L2100:
	movl	$.LC117, %esi
	xorl	%eax, %eax
	movl	$2, %edi
	call	syslog
	movl	$.LC118, %edi
	call	perror
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L2108:
	movq	pidfile(%rip), %rdx
	movl	$2, %edi
	movl	$.LC73, %esi
	xorl	%eax, %eax
	call	syslog
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L2111:
	movl	$.LC129, %esi
	xorl	%eax, %eax
	movl	$2, %edi
	call	syslog
	movl	$.LC130, %edi
	call	perror
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L1784:
	xorl	%eax, %eax
	movl	$.LC125, %esi
	movl	$4, %edi
	call	syslog
	movq	argv0(%rip), %rdx
	movq	stderr(%rip), %rdi
	movl	$.LC126, %esi
	xorl	%eax, %eax
	call	fprintf
	jmp	.L1781
.L1832:
	movq	hs(%rip), %rax
	leaq	76(%rax), %rdi
	movq	%rdi, %rdx
	movq	%rdi, %rcx
	shrq	$3, %rdx
	andl	$7, %ecx
	movzbl	2147450880(%rdx), %edx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L2147
.L1834:
	movl	76(%rax), %esi
	leaq	272(%rsp), %rdi
	call	handle_newconnect
	testl	%eax, %eax
	jne	.L1820
	jmp	.L1836
.L2126:
	movq	hs(%rip), %rax
	leaq	72(%rax), %rdi
	movq	%rdi, %rdx
	movq	%rdi, %rcx
	shrq	$3, %rdx
	andl	$7, %ecx
	movzbl	2147450880(%rdx), %edx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L2148
.L1838:
	movl	72(%rax), %esi
	leaq	272(%rsp), %rdi
	call	handle_newconnect
	testl	%eax, %eax
	jne	.L1820
	jmp	.L1840
.L1859:
	movq	%rbx, %rdx
	movl	$.LC73, %esi
	xorl	%eax, %eax
	movl	$2, %edi
	call	syslog
	movq	logfile(%rip), %rdi
	call	perror
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L2120:
	call	shut_down
	movl	$5, %edi
	movl	$.LC90, %esi
	xorl	%eax, %eax
	call	syslog
	call	closelog
	call	__asan_handle_no_return
	xorl	%edi, %edi
	call	exit
.L2139:
	movl	$.LC124, %esi
	xorl	%eax, %eax
	movl	$2, %edi
	call	syslog
	movl	$.LC20, %edi
	call	perror
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L2133:
	movq	user(%rip), %rdx
	movl	$.LC110, %esi
	movl	$2, %edi
	call	syslog
	movq	stderr(%rip), %rdi
	movq	user(%rip), %rcx
	movl	$.LC111, %esi
	movq	argv0(%rip), %rdx
	xorl	%eax, %eax
	call	fprintf
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L1804:
	movl	$.LC140, %esi
	jmp	.L2092
.L2136:
	movl	$.LC137, %esi
	movl	$4, %edi
	xorl	%eax, %eax
	call	syslog
	jmp	.L1801
.L2129:
	testb	%dl, %dl
	je	.L1842
	.p2align 4,,9
	call	__asan_report_load4
.L2131:
	testb	%al, %al
	.p2align 4,,4
	je	.L1845
	movq	%rbx, %rdi
	call	__asan_report_load4
.L2115:
	testb	%sil, %sil
	je	.L1810
	call	__asan_report_store4
.L2114:
	testb	%sil, %sil
	.p2align 4,,2
	je	.L1809
	movq	%rdx, %rdi
	call	__asan_report_store4
.L2132:
	testb	%dl, %dl
	je	.L1823
	movq	%rax, %rdi
	call	__asan_report_load4
.L2101:
	testb	%al, %al
	je	.L1763
	movq	%rbx, %rdi
	call	__asan_report_load1
.L2103:
	testb	%cl, %cl
	je	.L1767
	movq	%rax, %rdi
	call	__asan_report_load1
.L2128:
	call	__asan_report_load8
.L2147:
	testb	%dl, %dl
	je	.L1834
	.p2align 4,,6
	call	__asan_report_load4
.L2138:
	testb	%dl, %dl
	.p2align 4,,4
	je	.L1852
	.p2align 4,,6
	call	__asan_report_load4
.L2146:
	testb	%al, %al
	.p2align 4,,4
	je	.L1760
	movq	%rbx, %rdi
	call	__asan_report_load1
.L2141:
	testb	%al, %al
	je	.L1783
	call	__asan_report_load1
.L2140:
	testb	%al, %al
	.p2align 4,,4
	je	.L1782
	movq	%rbx, %rdi
	call	__asan_report_load1
.L2145:
	testb	%al, %al
	je	.L1788
	call	__asan_report_store1
.L2144:
	testb	%al, %al
	.p2align 4,,4
	je	.L1787
	movq	%rbx, %rdi
	call	__asan_report_store1
.L2143:
	testb	%dl, %dl
	je	.L1786
	movl	$.LC119+1, %edi
	call	__asan_report_load1
.L2142:
	testb	%dl, %dl
	je	.L1785
	movl	$.LC119, %edi
	call	__asan_report_load1
.L2096:
	movq	%rsi, %rdi
	call	__asan_report_load8
.L2134:
	movq	%rdi, %rcx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jl	.L1753
	call	__asan_report_load4
.L2105:
	testb	%dl, %dl
	je	.L1770
	movl	$.LC119+1, %edi
	call	__asan_report_load1
.L2102:
	testb	%r9b, %r9b
	je	.L1766
	call	__asan_report_load1
.L2119:
	testb	%dl, %dl
	.p2align 4,,3
	je	.L1818
	.p2align 4,,6
	call	__asan_report_load4
.L2118:
	testb	%dl, %dl
	.p2align 4,,4
	je	.L1816
	.p2align 4,,6
	call	__asan_report_load4
.L2117:
	testb	%dl, %dl
	.p2align 4,,4
	je	.L1808
	.p2align 4,,6
	call	__asan_report_store4
.L2116:
	.p2align 4,,6
	call	__asan_report_store8
.L2148:
	testb	%dl, %dl
	.p2align 4,,3
	je	.L1838
	.p2align 4,,6
	call	__asan_report_load4
.L2137:
	testb	%dl, %dl
	.p2align 4,,4
	je	.L1850
	.p2align 4,,6
	call	__asan_report_load4
.L2125:
	testb	%dl, %dl
	.p2align 4,,4
	je	.L1837
	.p2align 4,,6
	call	__asan_report_load4
.L2124:
	testb	%dl, %dl
	.p2align 4,,4
	je	.L1830
	.p2align 4,,6
	call	__asan_report_load4
.L2135:
	testb	%dl, %dl
	.p2align 4,,4
	je	.L1754
	.p2align 4,,6
	call	__asan_report_load4
.L2106:
	cmpb	%r10b, %r8b
	.p2align 4,,3
	jg	.L1771
	.p2align 4,,5
	call	__asan_report_store1
.L2107:
	testb	%dl, %dl
	.p2align 4,,3
	je	.L1772
	movq	%rax, %rdi
	call	__asan_report_store1
.L2104:
	testb	%dl, %dl
	je	.L1769
	movl	$.LC119, %edi
	call	__asan_report_load1
	.cfi_endproc
.LFE9:
	.size	main, .-main
	.bss
	.align 32
	.type	watchdog_flag, @object
	.size	watchdog_flag, 4
watchdog_flag:
	.zero	64
	.align 32
	.type	got_usr1, @object
	.size	got_usr1, 4
got_usr1:
	.zero	64
	.align 32
	.type	got_hup, @object
	.size	got_hup, 4
got_hup:
	.zero	64
	.comm	stats_simultaneous,4,4
	.comm	stats_bytes,8,8
	.comm	stats_connections,8,8
	.comm	stats_time,8,8
	.comm	start_time,8,8
	.globl	terminate
	.align 32
	.type	terminate, @object
	.size	terminate, 4
terminate:
	.zero	64
	.align 32
	.type	hs, @object
	.size	hs, 8
hs:
	.zero	64
	.align 32
	.type	httpd_conn_count, @object
	.size	httpd_conn_count, 4
httpd_conn_count:
	.zero	64
	.align 32
	.type	first_free_connect, @object
	.size	first_free_connect, 4
first_free_connect:
	.zero	64
	.align 32
	.type	max_connects, @object
	.size	max_connects, 4
max_connects:
	.zero	64
	.align 32
	.type	num_connects, @object
	.size	num_connects, 4
num_connects:
	.zero	64
	.align 32
	.type	connects, @object
	.size	connects, 8
connects:
	.zero	64
	.align 32
	.type	maxthrottles, @object
	.size	maxthrottles, 4
maxthrottles:
	.zero	64
	.align 32
	.type	numthrottles, @object
	.size	numthrottles, 4
numthrottles:
	.zero	64
	.align 32
	.type	throttles, @object
	.size	throttles, 8
throttles:
	.zero	64
	.align 32
	.type	max_age, @object
	.size	max_age, 4
max_age:
	.zero	64
	.align 32
	.type	p3p, @object
	.size	p3p, 8
p3p:
	.zero	64
	.align 32
	.type	charset, @object
	.size	charset, 8
charset:
	.zero	64
	.align 32
	.type	user, @object
	.size	user, 8
user:
	.zero	64
	.align 32
	.type	pidfile, @object
	.size	pidfile, 8
pidfile:
	.zero	64
	.align 32
	.type	hostname, @object
	.size	hostname, 8
hostname:
	.zero	64
	.align 32
	.type	throttlefile, @object
	.size	throttlefile, 8
throttlefile:
	.zero	64
	.align 32
	.type	logfile, @object
	.size	logfile, 8
logfile:
	.zero	64
	.align 32
	.type	local_pattern, @object
	.size	local_pattern, 8
local_pattern:
	.zero	64
	.align 32
	.type	no_empty_referers, @object
	.size	no_empty_referers, 4
no_empty_referers:
	.zero	64
	.align 32
	.type	url_pattern, @object
	.size	url_pattern, 8
url_pattern:
	.zero	64
	.align 32
	.type	cgi_limit, @object
	.size	cgi_limit, 4
cgi_limit:
	.zero	64
	.align 32
	.type	cgi_pattern, @object
	.size	cgi_pattern, 8
cgi_pattern:
	.zero	64
	.align 32
	.type	do_global_passwd, @object
	.size	do_global_passwd, 4
do_global_passwd:
	.zero	64
	.align 32
	.type	do_vhost, @object
	.size	do_vhost, 4
do_vhost:
	.zero	64
	.align 32
	.type	no_symlink_check, @object
	.size	no_symlink_check, 4
no_symlink_check:
	.zero	64
	.align 32
	.type	no_log, @object
	.size	no_log, 4
no_log:
	.zero	64
	.align 32
	.type	do_chroot, @object
	.size	do_chroot, 4
do_chroot:
	.zero	64
	.align 32
	.type	data_dir, @object
	.size	data_dir, 8
data_dir:
	.zero	64
	.align 32
	.type	dir, @object
	.size	dir, 8
dir:
	.zero	64
	.align 32
	.type	port, @object
	.size	port, 2
port:
	.zero	64
	.align 32
	.type	debug, @object
	.size	debug, 4
debug:
	.zero	64
	.align 32
	.type	argv0, @object
	.size	argv0, 8
argv0:
	.zero	64
	.section	.rodata.str1.1
.LC142:
	.string	"watchdog_flag (thttpd.c)"
.LC143:
	.string	"got_usr1 (thttpd.c)"
.LC144:
	.string	"got_hup (thttpd.c)"
.LC145:
	.string	"terminate (thttpd.c)"
.LC146:
	.string	"hs (thttpd.c)"
.LC147:
	.string	"httpd_conn_count (thttpd.c)"
.LC148:
	.string	"first_free_connect (thttpd.c)"
.LC149:
	.string	"max_connects (thttpd.c)"
.LC150:
	.string	"num_connects (thttpd.c)"
.LC151:
	.string	"connects (thttpd.c)"
.LC152:
	.string	"maxthrottles (thttpd.c)"
.LC153:
	.string	"numthrottles (thttpd.c)"
.LC154:
	.string	"throttles (thttpd.c)"
.LC155:
	.string	"max_age (thttpd.c)"
.LC156:
	.string	"p3p (thttpd.c)"
.LC157:
	.string	"charset (thttpd.c)"
.LC158:
	.string	"user (thttpd.c)"
.LC159:
	.string	"pidfile (thttpd.c)"
.LC160:
	.string	"hostname (thttpd.c)"
.LC161:
	.string	"throttlefile (thttpd.c)"
.LC162:
	.string	"logfile (thttpd.c)"
.LC163:
	.string	"local_pattern (thttpd.c)"
.LC164:
	.string	"no_empty_referers (thttpd.c)"
.LC165:
	.string	"url_pattern (thttpd.c)"
.LC166:
	.string	"cgi_limit (thttpd.c)"
.LC167:
	.string	"cgi_pattern (thttpd.c)"
.LC168:
	.string	"do_global_passwd (thttpd.c)"
.LC169:
	.string	"do_vhost (thttpd.c)"
.LC170:
	.string	"no_symlink_check (thttpd.c)"
.LC171:
	.string	"no_log (thttpd.c)"
.LC172:
	.string	"do_chroot (thttpd.c)"
.LC173:
	.string	"data_dir (thttpd.c)"
.LC174:
	.string	"dir (thttpd.c)"
.LC175:
	.string	"port (thttpd.c)"
.LC176:
	.string	"debug (thttpd.c)"
.LC177:
	.string	"argv0 (thttpd.c)"
.LC178:
	.string	"*.LC96 (thttpd.c)"
.LC179:
	.string	"*.LC117 (thttpd.c)"
.LC180:
	.string	"*.LC38 (thttpd.c)"
.LC181:
	.string	"*.LC82 (thttpd.c)"
.LC182:
	.string	"*.LC137 (thttpd.c)"
.LC183:
	.string	"*.LC78 (thttpd.c)"
.LC184:
	.string	"*.LC79 (thttpd.c)"
.LC185:
	.string	"*.LC1 (thttpd.c)"
.LC186:
	.string	"*.LC129 (thttpd.c)"
.LC187:
	.string	"*.LC132 (thttpd.c)"
.LC188:
	.string	"*.LC68 (thttpd.c)"
.LC189:
	.string	"*.LC34 (thttpd.c)"
.LC190:
	.string	"*.LC59 (thttpd.c)"
.LC191:
	.string	"*.LC75 (thttpd.c)"
.LC192:
	.string	"*.LC61 (thttpd.c)"
.LC193:
	.string	"*.LC81 (thttpd.c)"
.LC194:
	.string	"*.LC53 (thttpd.c)"
.LC195:
	.string	"*.LC124 (thttpd.c)"
.LC196:
	.string	"*.LC130 (thttpd.c)"
.LC197:
	.string	"*.LC35 (thttpd.c)"
.LC198:
	.string	"*.LC20 (thttpd.c)"
.LC199:
	.string	"*.LC31 (thttpd.c)"
.LC200:
	.string	"*.LC136 (thttpd.c)"
.LC201:
	.string	"*.LC54 (thttpd.c)"
.LC202:
	.string	"*.LC44 (thttpd.c)"
.LC203:
	.string	"*.LC104 (thttpd.c)"
.LC204:
	.string	"*.LC28 (thttpd.c)"
.LC205:
	.string	"*.LC6 (thttpd.c)"
.LC206:
	.string	"*.LC3 (thttpd.c)"
.LC207:
	.string	"*.LC108 (thttpd.c)"
.LC208:
	.string	"*.LC106 (thttpd.c)"
.LC209:
	.string	"*.LC74 (thttpd.c)"
.LC210:
	.string	"*.LC76 (thttpd.c)"
.LC211:
	.string	"*.LC116 (thttpd.c)"
.LC212:
	.string	"*.LC30 (thttpd.c)"
.LC213:
	.string	"*.LC39 (thttpd.c)"
.LC214:
	.string	"*.LC48 (thttpd.c)"
.LC215:
	.string	"*.LC55 (thttpd.c)"
.LC216:
	.string	"*.LC40 (thttpd.c)"
.LC217:
	.string	"*.LC119 (thttpd.c)"
.LC218:
	.string	"*.LC60 (thttpd.c)"
.LC219:
	.string	"*.LC29 (thttpd.c)"
.LC220:
	.string	"*.LC0 (thttpd.c)"
.LC221:
	.string	"*.LC83 (thttpd.c)"
.LC222:
	.string	"*.LC138 (thttpd.c)"
.LC223:
	.string	"*.LC122 (thttpd.c)"
.LC224:
	.string	"*.LC11 (thttpd.c)"
.LC225:
	.string	"*.LC135 (thttpd.c)"
.LC226:
	.string	"*.LC45 (thttpd.c)"
.LC227:
	.string	"*.LC46 (thttpd.c)"
.LC228:
	.string	"*.LC103 (thttpd.c)"
.LC229:
	.string	"*.LC128 (thttpd.c)"
.LC230:
	.string	"*.LC42 (thttpd.c)"
.LC231:
	.string	"*.LC99 (thttpd.c)"
.LC232:
	.string	"*.LC18 (thttpd.c)"
.LC233:
	.string	"*.LC24 (thttpd.c)"
.LC234:
	.string	"*.LC127 (thttpd.c)"
.LC235:
	.string	"*.LC110 (thttpd.c)"
.LC236:
	.string	"*.LC111 (thttpd.c)"
.LC237:
	.string	"*.LC141 (thttpd.c)"
.LC238:
	.string	"*.LC19 (thttpd.c)"
.LC239:
	.string	"*.LC49 (thttpd.c)"
.LC240:
	.string	"*.LC71 (thttpd.c)"
.LC241:
	.string	"*.LC87 (thttpd.c)"
.LC242:
	.string	"*.LC65 (thttpd.c)"
.LC243:
	.string	"*.LC62 (thttpd.c)"
.LC244:
	.string	"*.LC63 (thttpd.c)"
.LC245:
	.string	"*.LC114 (thttpd.c)"
.LC246:
	.string	"*.LC15 (thttpd.c)"
.LC247:
	.string	"*.LC121 (thttpd.c)"
.LC248:
	.string	"*.LC120 (thttpd.c)"
.LC249:
	.string	"*.LC77 (thttpd.c)"
.LC250:
	.string	"*.LC123 (thttpd.c)"
.LC251:
	.string	"*.LC4 (thttpd.c)"
.LC252:
	.string	"*.LC125 (thttpd.c)"
.LC253:
	.string	"*.LC16 (thttpd.c)"
.LC254:
	.string	"*.LC66 (thttpd.c)"
.LC255:
	.string	"*.LC21 (thttpd.c)"
.LC256:
	.string	"*.LC41 (thttpd.c)"
.LC257:
	.string	"*.LC64 (thttpd.c)"
.LC258:
	.string	"*.LC25 (thttpd.c)"
.LC259:
	.string	"*.LC84 (thttpd.c)"
.LC260:
	.string	"*.LC32 (thttpd.c)"
.LC261:
	.string	"*.LC47 (thttpd.c)"
.LC262:
	.string	"*.LC118 (thttpd.c)"
.LC263:
	.string	"*.LC126 (thttpd.c)"
.LC264:
	.string	"*.LC105 (thttpd.c)"
.LC265:
	.string	"*.LC100 (thttpd.c)"
.LC266:
	.string	"*.LC139 (thttpd.c)"
.LC267:
	.string	"*.LC95 (thttpd.c)"
.LC268:
	.string	"*.LC73 (thttpd.c)"
.LC269:
	.string	"*.LC8 (thttpd.c)"
.LC270:
	.string	"*.LC134 (thttpd.c)"
.LC271:
	.string	"*.LC69 (thttpd.c)"
.LC272:
	.string	"*.LC80 (thttpd.c)"
.LC273:
	.string	"*.LC52 (thttpd.c)"
.LC274:
	.string	"*.LC67 (thttpd.c)"
.LC275:
	.string	"*.LC56 (thttpd.c)"
.LC276:
	.string	"*.LC88 (thttpd.c)"
.LC277:
	.string	"*.LC140 (thttpd.c)"
.LC278:
	.string	"*.LC2 (thttpd.c)"
.LC279:
	.string	"*.LC93 (thttpd.c)"
.LC280:
	.string	"*.LC5 (thttpd.c)"
.LC281:
	.string	"*.LC94 (thttpd.c)"
.LC282:
	.string	"*.LC133 (thttpd.c)"
.LC283:
	.string	"*.LC98 (thttpd.c)"
.LC284:
	.string	"*.LC90 (thttpd.c)"
.LC285:
	.string	"*.LC22 (thttpd.c)"
.LC286:
	.string	"*.LC57 (thttpd.c)"
.LC287:
	.string	"*.LC9 (thttpd.c)"
.LC288:
	.string	"*.LC115 (thttpd.c)"
.LC289:
	.string	"*.LC112 (thttpd.c)"
.LC290:
	.string	"*.LC85 (thttpd.c)"
.LC291:
	.string	"*.LC33 (thttpd.c)"
.LC292:
	.string	"*.LC131 (thttpd.c)"
.LC293:
	.string	"*.LC43 (thttpd.c)"
.LC294:
	.string	"*.LC26 (thttpd.c)"
.LC295:
	.string	"*.LC86 (thttpd.c)"
.LC296:
	.string	"*.LC91 (thttpd.c)"
.LC297:
	.string	"*.LC50 (thttpd.c)"
.LC298:
	.string	"*.LC70 (thttpd.c)"
.LC299:
	.string	"*.LC37 (thttpd.c)"
.LC300:
	.string	"*.LC51 (thttpd.c)"
.LC301:
	.string	"*.LC58 (thttpd.c)"
.LC302:
	.string	"*.LC36 (thttpd.c)"
.LC303:
	.string	"*.LC27 (thttpd.c)"
.LC304:
	.string	"*.LC12 (thttpd.c)"
.LC305:
	.string	"*.LC13 (thttpd.c)"
.LC306:
	.string	"*.LC109 (thttpd.c)"
.LC307:
	.string	"*.LC23 (thttpd.c)"
.LC308:
	.string	"*.LC113 (thttpd.c)"
.LC309:
	.string	"*.LC17 (thttpd.c)"
	.data
	.align 32
	.type	.LASAN0, @object
	.size	.LASAN0, 6720
.LASAN0:
	.quad	watchdog_flag
	.quad	4
	.quad	64
	.quad	.LC142
	.quad	0
	.quad	got_usr1
	.quad	4
	.quad	64
	.quad	.LC143
	.quad	0
	.quad	got_hup
	.quad	4
	.quad	64
	.quad	.LC144
	.quad	0
	.quad	terminate
	.quad	4
	.quad	64
	.quad	.LC145
	.quad	0
	.quad	hs
	.quad	8
	.quad	64
	.quad	.LC146
	.quad	0
	.quad	httpd_conn_count
	.quad	4
	.quad	64
	.quad	.LC147
	.quad	0
	.quad	first_free_connect
	.quad	4
	.quad	64
	.quad	.LC148
	.quad	0
	.quad	max_connects
	.quad	4
	.quad	64
	.quad	.LC149
	.quad	0
	.quad	num_connects
	.quad	4
	.quad	64
	.quad	.LC150
	.quad	0
	.quad	connects
	.quad	8
	.quad	64
	.quad	.LC151
	.quad	0
	.quad	maxthrottles
	.quad	4
	.quad	64
	.quad	.LC152
	.quad	0
	.quad	numthrottles
	.quad	4
	.quad	64
	.quad	.LC153
	.quad	0
	.quad	throttles
	.quad	8
	.quad	64
	.quad	.LC154
	.quad	0
	.quad	max_age
	.quad	4
	.quad	64
	.quad	.LC155
	.quad	0
	.quad	p3p
	.quad	8
	.quad	64
	.quad	.LC156
	.quad	0
	.quad	charset
	.quad	8
	.quad	64
	.quad	.LC157
	.quad	0
	.quad	user
	.quad	8
	.quad	64
	.quad	.LC158
	.quad	0
	.quad	pidfile
	.quad	8
	.quad	64
	.quad	.LC159
	.quad	0
	.quad	hostname
	.quad	8
	.quad	64
	.quad	.LC160
	.quad	0
	.quad	throttlefile
	.quad	8
	.quad	64
	.quad	.LC161
	.quad	0
	.quad	logfile
	.quad	8
	.quad	64
	.quad	.LC162
	.quad	0
	.quad	local_pattern
	.quad	8
	.quad	64
	.quad	.LC163
	.quad	0
	.quad	no_empty_referers
	.quad	4
	.quad	64
	.quad	.LC164
	.quad	0
	.quad	url_pattern
	.quad	8
	.quad	64
	.quad	.LC165
	.quad	0
	.quad	cgi_limit
	.quad	4
	.quad	64
	.quad	.LC166
	.quad	0
	.quad	cgi_pattern
	.quad	8
	.quad	64
	.quad	.LC167
	.quad	0
	.quad	do_global_passwd
	.quad	4
	.quad	64
	.quad	.LC168
	.quad	0
	.quad	do_vhost
	.quad	4
	.quad	64
	.quad	.LC169
	.quad	0
	.quad	no_symlink_check
	.quad	4
	.quad	64
	.quad	.LC170
	.quad	0
	.quad	no_log
	.quad	4
	.quad	64
	.quad	.LC171
	.quad	0
	.quad	do_chroot
	.quad	4
	.quad	64
	.quad	.LC172
	.quad	0
	.quad	data_dir
	.quad	8
	.quad	64
	.quad	.LC173
	.quad	0
	.quad	dir
	.quad	8
	.quad	64
	.quad	.LC174
	.quad	0
	.quad	port
	.quad	2
	.quad	64
	.quad	.LC175
	.quad	0
	.quad	debug
	.quad	4
	.quad	64
	.quad	.LC176
	.quad	0
	.quad	argv0
	.quad	8
	.quad	64
	.quad	.LC177
	.quad	0
	.quad	.LC96
	.quad	35
	.quad	96
	.quad	.LC178
	.quad	0
	.quad	.LC117
	.quad	11
	.quad	64
	.quad	.LC179
	.quad	0
	.quad	.LC38
	.quad	13
	.quad	64
	.quad	.LC180
	.quad	0
	.quad	.LC82
	.quad	19
	.quad	64
	.quad	.LC181
	.quad	0
	.quad	.LC137
	.quad	16
	.quad	64
	.quad	.LC182
	.quad	0
	.quad	.LC78
	.quad	3
	.quad	64
	.quad	.LC183
	.quad	0
	.quad	.LC79
	.quad	39
	.quad	96
	.quad	.LC184
	.quad	0
	.quad	.LC1
	.quad	70
	.quad	128
	.quad	.LC185
	.quad	0
	.quad	.LC129
	.quad	20
	.quad	64
	.quad	.LC186
	.quad	0
	.quad	.LC132
	.quad	24
	.quad	64
	.quad	.LC187
	.quad	0
	.quad	.LC68
	.quad	3
	.quad	64
	.quad	.LC188
	.quad	0
	.quad	.LC34
	.quad	5
	.quad	64
	.quad	.LC189
	.quad	0
	.quad	.LC59
	.quad	3
	.quad	64
	.quad	.LC190
	.quad	0
	.quad	.LC75
	.quad	16
	.quad	64
	.quad	.LC191
	.quad	0
	.quad	.LC61
	.quad	3
	.quad	64
	.quad	.LC192
	.quad	0
	.quad	.LC81
	.quad	2
	.quad	64
	.quad	.LC193
	.quad	0
	.quad	.LC53
	.quad	3
	.quad	64
	.quad	.LC194
	.quad	0
	.quad	.LC124
	.quad	12
	.quad	64
	.quad	.LC195
	.quad	0
	.quad	.LC130
	.quad	15
	.quad	64
	.quad	.LC196
	.quad	0
	.quad	.LC35
	.quad	8
	.quad	64
	.quad	.LC197
	.quad	0
	.quad	.LC20
	.quad	7
	.quad	64
	.quad	.LC198
	.quad	0
	.quad	.LC31
	.quad	16
	.quad	64
	.quad	.LC199
	.quad	0
	.quad	.LC136
	.quad	12
	.quad	64
	.quad	.LC200
	.quad	0
	.quad	.LC54
	.quad	5
	.quad	64
	.quad	.LC201
	.quad	0
	.quad	.LC44
	.quad	32
	.quad	64
	.quad	.LC202
	.quad	0
	.quad	.LC104
	.quad	26
	.quad	64
	.quad	.LC203
	.quad	0
	.quad	.LC28
	.quad	7
	.quad	64
	.quad	.LC204
	.quad	0
	.quad	.LC6
	.quad	219
	.quad	256
	.quad	.LC205
	.quad	0
	.quad	.LC3
	.quad	65
	.quad	128
	.quad	.LC206
	.quad	0
	.quad	.LC108
	.quad	29
	.quad	64
	.quad	.LC207
	.quad	0
	.quad	.LC106
	.quad	39
	.quad	96
	.quad	.LC208
	.quad	0
	.quad	.LC74
	.quad	20
	.quad	64
	.quad	.LC209
	.quad	0
	.quad	.LC76
	.quad	33
	.quad	96
	.quad	.LC210
	.quad	0
	.quad	.LC116
	.quad	15
	.quad	64
	.quad	.LC211
	.quad	0
	.quad	.LC30
	.quad	7
	.quad	64
	.quad	.LC212
	.quad	0
	.quad	.LC39
	.quad	15
	.quad	64
	.quad	.LC213
	.quad	0
	.quad	.LC48
	.quad	3
	.quad	64
	.quad	.LC214
	.quad	0
	.quad	.LC55
	.quad	4
	.quad	64
	.quad	.LC215
	.quad	0
	.quad	.LC40
	.quad	8
	.quad	64
	.quad	.LC216
	.quad	0
	.quad	.LC119
	.quad	2
	.quad	64
	.quad	.LC217
	.quad	0
	.quad	.LC60
	.quad	3
	.quad	64
	.quad	.LC218
	.quad	0
	.quad	.LC29
	.quad	9
	.quad	64
	.quad	.LC219
	.quad	0
	.quad	.LC0
	.quad	104
	.quad	160
	.quad	.LC220
	.quad	0
	.quad	.LC83
	.quad	2
	.quad	64
	.quad	.LC221
	.quad	0
	.quad	.LC138
	.quad	12
	.quad	64
	.quad	.LC222
	.quad	0
	.quad	.LC122
	.quad	4
	.quad	64
	.quad	.LC223
	.quad	0
	.quad	.LC11
	.quad	16
	.quad	64
	.quad	.LC224
	.quad	0
	.quad	.LC135
	.quad	15
	.quad	64
	.quad	.LC225
	.quad	0
	.quad	.LC45
	.quad	7
	.quad	64
	.quad	.LC226
	.quad	0
	.quad	.LC46
	.quad	11
	.quad	64
	.quad	.LC227
	.quad	0
	.quad	.LC103
	.quad	3
	.quad	64
	.quad	.LC228
	.quad	0
	.quad	.LC128
	.quad	13
	.quad	64
	.quad	.LC229
	.quad	0
	.quad	.LC42
	.quad	4
	.quad	64
	.quad	.LC230
	.quad	0
	.quad	.LC99
	.quad	37
	.quad	96
	.quad	.LC231
	.quad	0
	.quad	.LC18
	.quad	5
	.quad	64
	.quad	.LC232
	.quad	0
	.quad	.LC24
	.quad	10
	.quad	64
	.quad	.LC233
	.quad	0
	.quad	.LC127
	.quad	18
	.quad	64
	.quad	.LC234
	.quad	0
	.quad	.LC110
	.quad	23
	.quad	64
	.quad	.LC235
	.quad	0
	.quad	.LC111
	.quad	25
	.quad	64
	.quad	.LC236
	.quad	0
	.quad	.LC141
	.quad	13
	.quad	64
	.quad	.LC237
	.quad	0
	.quad	.LC19
	.quad	4
	.quad	64
	.quad	.LC238
	.quad	0
	.quad	.LC49
	.quad	26
	.quad	64
	.quad	.LC239
	.quad	0
	.quad	.LC71
	.quad	3
	.quad	64
	.quad	.LC240
	.quad	0
	.quad	.LC87
	.quad	39
	.quad	96
	.quad	.LC241
	.quad	0
	.quad	.LC65
	.quad	3
	.quad	64
	.quad	.LC242
	.quad	0
	.quad	.LC62
	.quad	3
	.quad	64
	.quad	.LC243
	.quad	0
	.quad	.LC63
	.quad	3
	.quad	64
	.quad	.LC244
	.quad	0
	.quad	.LC114
	.quad	72
	.quad	128
	.quad	.LC245
	.quad	0
	.quad	.LC15
	.quad	2
	.quad	64
	.quad	.LC246
	.quad	0
	.quad	.LC121
	.quad	2
	.quad	64
	.quad	.LC247
	.quad	0
	.quad	.LC120
	.quad	12
	.quad	64
	.quad	.LC248
	.quad	0
	.quad	.LC77
	.quad	38
	.quad	96
	.quad	.LC249
	.quad	0
	.quad	.LC123
	.quad	31
	.quad	64
	.quad	.LC250
	.quad	0
	.quad	.LC4
	.quad	37
	.quad	96
	.quad	.LC251
	.quad	0
	.quad	.LC125
	.quad	74
	.quad	128
	.quad	.LC252
	.quad	0
	.quad	.LC16
	.quad	5
	.quad	64
	.quad	.LC253
	.quad	0
	.quad	.LC66
	.quad	5
	.quad	64
	.quad	.LC254
	.quad	0
	.quad	.LC21
	.quad	9
	.quad	64
	.quad	.LC255
	.quad	0
	.quad	.LC41
	.quad	8
	.quad	64
	.quad	.LC256
	.quad	0
	.quad	.LC64
	.quad	5
	.quad	64
	.quad	.LC257
	.quad	0
	.quad	.LC25
	.quad	9
	.quad	64
	.quad	.LC258
	.quad	0
	.quad	.LC84
	.quad	22
	.quad	64
	.quad	.LC259
	.quad	0
	.quad	.LC32
	.quad	9
	.quad	64
	.quad	.LC260
	.quad	0
	.quad	.LC47
	.quad	1
	.quad	64
	.quad	.LC261
	.quad	0
	.quad	.LC118
	.quad	6
	.quad	64
	.quad	.LC262
	.quad	0
	.quad	.LC126
	.quad	79
	.quad	128
	.quad	.LC263
	.quad	0
	.quad	.LC105
	.quad	25
	.quad	64
	.quad	.LC264
	.quad	0
	.quad	.LC100
	.quad	25
	.quad	64
	.quad	.LC265
	.quad	0
	.quad	.LC139
	.quad	58
	.quad	96
	.quad	.LC266
	.quad	0
	.quad	.LC95
	.quad	35
	.quad	96
	.quad	.LC267
	.quad	0
	.quad	.LC73
	.quad	11
	.quad	64
	.quad	.LC268
	.quad	0
	.quad	.LC8
	.quad	39
	.quad	96
	.quad	.LC269
	.quad	0
	.quad	.LC134
	.quad	30
	.quad	64
	.quad	.LC270
	.quad	0
	.quad	.LC69
	.quad	3
	.quad	64
	.quad	.LC271
	.quad	0
	.quad	.LC80
	.quad	44
	.quad	96
	.quad	.LC272
	.quad	0
	.quad	.LC52
	.quad	3
	.quad	64
	.quad	.LC273
	.quad	0
	.quad	.LC67
	.quad	3
	.quad	64
	.quad	.LC274
	.quad	0
	.quad	.LC56
	.quad	3
	.quad	64
	.quad	.LC275
	.quad	0
	.quad	.LC88
	.quad	56
	.quad	96
	.quad	.LC276
	.quad	0
	.quad	.LC140
	.quad	38
	.quad	96
	.quad	.LC277
	.quad	0
	.quad	.LC2
	.quad	62
	.quad	96
	.quad	.LC278
	.quad	0
	.quad	.LC93
	.quad	33
	.quad	96
	.quad	.LC279
	.quad	0
	.quad	.LC5
	.quad	34
	.quad	96
	.quad	.LC280
	.quad	0
	.quad	.LC94
	.quad	43
	.quad	96
	.quad	.LC281
	.quad	0
	.quad	.LC133
	.quad	36
	.quad	96
	.quad	.LC282
	.quad	0
	.quad	.LC98
	.quad	33
	.quad	96
	.quad	.LC283
	.quad	0
	.quad	.LC90
	.quad	8
	.quad	64
	.quad	.LC284
	.quad	0
	.quad	.LC22
	.quad	9
	.quad	64
	.quad	.LC285
	.quad	0
	.quad	.LC57
	.quad	5
	.quad	64
	.quad	.LC286
	.quad	0
	.quad	.LC9
	.quad	5
	.quad	64
	.quad	.LC287
	.quad	0
	.quad	.LC115
	.quad	20
	.quad	64
	.quad	.LC288
	.quad	0
	.quad	.LC112
	.quad	10
	.quad	64
	.quad	.LC289
	.quad	0
	.quad	.LC85
	.quad	22
	.quad	64
	.quad	.LC290
	.quad	0
	.quad	.LC33
	.quad	10
	.quad	64
	.quad	.LC291
	.quad	0
	.quad	.LC131
	.quad	30
	.quad	64
	.quad	.LC292
	.quad	0
	.quad	.LC43
	.quad	8
	.quad	64
	.quad	.LC293
	.quad	0
	.quad	.LC26
	.quad	11
	.quad	64
	.quad	.LC294
	.quad	0
	.quad	.LC86
	.quad	36
	.quad	96
	.quad	.LC295
	.quad	0
	.quad	.LC91
	.quad	25
	.quad	64
	.quad	.LC296
	.quad	0
	.quad	.LC50
	.quad	3
	.quad	64
	.quad	.LC297
	.quad	0
	.quad	.LC70
	.quad	3
	.quad	64
	.quad	.LC298
	.quad	0
	.quad	.LC37
	.quad	8
	.quad	64
	.quad	.LC299
	.quad	0
	.quad	.LC51
	.quad	3
	.quad	64
	.quad	.LC300
	.quad	0
	.quad	.LC58
	.quad	3
	.quad	64
	.quad	.LC301
	.quad	0
	.quad	.LC36
	.quad	6
	.quad	64
	.quad	.LC302
	.quad	0
	.quad	.LC27
	.quad	5
	.quad	64
	.quad	.LC303
	.quad	0
	.quad	.LC12
	.quad	31
	.quad	64
	.quad	.LC304
	.quad	0
	.quad	.LC13
	.quad	36
	.quad	96
	.quad	.LC305
	.quad	0
	.quad	.LC109
	.quad	34
	.quad	96
	.quad	.LC306
	.quad	0
	.quad	.LC23
	.quad	8
	.quad	64
	.quad	.LC307
	.quad	0
	.quad	.LC113
	.quad	67
	.quad	128
	.quad	.LC308
	.quad	0
	.quad	.LC17
	.quad	6
	.quad	64
	.quad	.LC309
	.quad	0
	.section	.text.exit,"ax",@progbits
	.p2align 4,,15
	.type	_GLOBAL__sub_D_00099_0_terminate, @function
_GLOBAL__sub_D_00099_0_terminate:
.LFB38:
	.cfi_startproc
	movl	$168, %esi
	movl	$.LASAN0, %edi
	jmp	__asan_unregister_globals
	.cfi_endproc
.LFE38:
	.size	_GLOBAL__sub_D_00099_0_terminate, .-_GLOBAL__sub_D_00099_0_terminate
	.section	.fini_array.00099,"aw"
	.align 8
	.quad	_GLOBAL__sub_D_00099_0_terminate
	.section	.text.startup
	.p2align 4,,15
	.type	_GLOBAL__sub_I_00099_1_terminate, @function
_GLOBAL__sub_I_00099_1_terminate:
.LFB39:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	__asan_init_v1
	movl	$168, %esi
	movl	$.LASAN0, %edi
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	jmp	__asan_register_globals
	.cfi_endproc
.LFE39:
	.size	_GLOBAL__sub_I_00099_1_terminate, .-_GLOBAL__sub_I_00099_1_terminate
	.section	.init_array.00099,"aw"
	.align 8
	.quad	_GLOBAL__sub_I_00099_1_terminate
	.ident	"GCC: (GNU) 4.8.5 20150623 (Red Hat 4.8.5-16)"
	.section	.note.GNU-stack,"",@progbits
