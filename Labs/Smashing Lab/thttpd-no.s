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
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC0:
	.string	"  thttpd - %ld connections (%g/sec), %d max simultaneous, %lld bytes (%g/sec), %d httpd_conns allocated"
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
	.section	.rodata.str1.8
	.align 8
.LC1:
	.string	"throttle #%d '%.80s' rate %ld greatly exceeding limit %ld; %d sending"
	.align 8
.LC2:
	.string	"throttle #%d '%.80s' rate %ld exceeding limit %ld; %d sending"
	.align 8
.LC3:
	.string	"throttle #%d '%.80s' rate %ld lower than minimum %ld; %d sending"
	.text
	.p2align 4,,15
	.type	update_throttles, @function
update_throttles:
.LFB25:
	.cfi_startproc
	pushq	%r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	movabsq	$6148914691236517206, %r12
	pushq	%rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	xorl	%ebp, %ebp
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
	xorl	%ebx, %ebx
	subq	$16, %rsp
	.cfi_def_cfa_offset 48
	movl	numthrottles(%rip), %eax
	testl	%eax, %eax
	jg	.L28
	jmp	.L13
	.p2align 4,,10
	.p2align 3
.L12:
	addl	$1, %ebx
	addq	$48, %rbp
	cmpl	%ebx, numthrottles(%rip)
	jle	.L13
.L28:
	movq	%rbp, %rcx
	addq	throttles(%rip), %rcx
	movq	32(%rcx), %rax
	movq	24(%rcx), %rdx
	movq	8(%rcx), %r9
	movq	$0, 32(%rcx)
	movq	%rax, %rsi
	shrq	$63, %rsi
	addq	%rsi, %rax
	sarq	%rax
	leaq	(%rax,%rdx,2), %rsi
	movq	%rsi, %rax
	sarq	$63, %rsi
	imulq	%r12
	movq	%rdx, %r8
	subq	%rsi, %r8
	cmpq	%r9, %r8
	movq	%r8, 24(%rcx)
	jle	.L10
	movl	40(%rcx), %eax
	testl	%eax, %eax
	je	.L10
	leaq	(%r9,%r9), %rdx
	movl	%eax, (%rsp)
	movq	(%rcx), %rcx
	cmpq	%rdx, %r8
	movl	%ebx, %edx
	jle	.L11
	movl	$.LC1, %esi
	movl	$5, %edi
.L30:
	xorl	%eax, %eax
	call	syslog
	movq	%rbp, %rcx
	addq	throttles(%rip), %rcx
	movq	24(%rcx), %r8
.L10:
	movq	16(%rcx), %r9
	cmpq	%r8, %r9
	jle	.L12
	movl	40(%rcx), %eax
	testl	%eax, %eax
	je	.L12
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
	jg	.L28
	.p2align 4,,10
	.p2align 3
.L13:
	movl	max_connects(%rip), %eax
	testl	%eax, %eax
	jle	.L6
	movq	connects(%rip), %r8
	subl	$1, %eax
	movq	throttles(%rip), %rbx
	leaq	(%rax,%rax,8), %rbp
	leaq	144(%r8), %r10
	salq	$4, %rbp
	addq	%r10, %rbp
	jmp	.L21
	.p2align 4,,10
	.p2align 3
.L17:
	cmpq	%rbp, %r10
	movq	%r10, %r8
	je	.L6
.L16:
	addq	$144, %r10
.L21:
	movl	(%r8), %eax
	subl	$2, %eax
	cmpl	$1, %eax
	ja	.L17
	movl	56(%r8), %eax
	movq	$-1, 64(%r8)
	testl	%eax, %eax
	jle	.L17
	subl	$1, %eax
	movq	%r8, %rcx
	movq	$-1, %rdi
	leaq	4(%r8,%rax,4), %r11
	jmp	.L20
	.p2align 4,,10
	.p2align 3
.L33:
	movq	64(%r8), %rdi
.L20:
	movslq	16(%rcx), %rax
	leaq	(%rax,%rax,2), %rsi
	salq	$4, %rsi
	addq	%rbx, %rsi
	movq	8(%rsi), %rax
	movslq	40(%rsi), %r9
	cqto
	idivq	%r9
	cmpq	$-1, %rdi
	je	.L31
	cmpq	%rax, %rdi
	cmovle	%rdi, %rax
.L31:
	addq	$4, %rcx
	movq	%rax, 64(%r8)
	cmpq	%r11, %rcx
	jne	.L33
	cmpq	%rbp, %r10
	movq	%r10, %r8
	jne	.L16
.L6:
	addq	$16, %rsp
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
.L11:
	.cfi_restore_state
	movl	$.LC2, %esi
	movl	$6, %edi
	jmp	.L30
	.cfi_endproc
.LFE25:
	.size	update_throttles, .-update_throttles
	.section	.rodata.str1.8
	.align 8
.LC4:
	.string	"%s: no value required for %s option\n"
	.text
	.p2align 4,,15
	.type	no_value_required, @function
no_value_required:
.LFB14:
	.cfi_startproc
	testq	%rsi, %rsi
	jne	.L38
	rep ret
.L38:
	movq	%rdi, %rcx
	pushq	%rax
	.cfi_def_cfa_offset 16
	movq	stderr(%rip), %rdi
	movq	argv0(%rip), %rdx
	movl	$.LC4, %esi
	xorl	%eax, %eax
	call	fprintf
	movl	$1, %edi
	call	exit
	.cfi_endproc
.LFE14:
	.size	no_value_required, .-no_value_required
	.section	.rodata.str1.8
	.align 8
.LC5:
	.string	"%s: value required for %s option\n"
	.text
	.p2align 4,,15
	.type	value_required, @function
value_required:
.LFB13:
	.cfi_startproc
	testq	%rsi, %rsi
	je	.L43
	rep ret
.L43:
	movq	%rdi, %rcx
	pushq	%rax
	.cfi_def_cfa_offset 16
	movq	stderr(%rip), %rdi
	movq	argv0(%rip), %rdx
	movl	$.LC5, %esi
	xorl	%eax, %eax
	call	fprintf
	movl	$1, %edi
	call	exit
	.cfi_endproc
.LFE13:
	.size	value_required, .-value_required
	.section	.rodata.str1.8
	.align 8
.LC6:
	.string	"usage:  %s [-C configfile] [-p port] [-d dir] [-r|-nor] [-dd data_dir] [-s|-nos] [-v|-nov] [-g|-nog] [-u user] [-c cgipat] [-t throttles] [-h host] [-l logfile] [-i pidfile] [-T charset] [-P P3P] [-M maxage] [-V] [-D]\n"
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
	cmpl	$3, (%rdi)
	movq	$0, 96(%rdi)
	je	.L48
	rep ret
	.p2align 4,,10
	.p2align 3
.L48:
	movq	8(%rdi), %rax
	movl	$2, (%rdi)
	movq	%rdi, %rsi
	movl	$1, %edx
	movl	704(%rax), %eax
	movl	%eax, %edi
	jmp	fdwatch_add_fd
	.cfi_endproc
.LFE30:
	.size	wakeup_connection, .-wakeup_connection
	.section	.rodata.str1.8
	.align 8
.LC7:
	.string	"up %ld seconds, stats for %ld seconds:"
	.text
	.p2align 4,,15
	.type	logstats, @function
logstats:
.LFB34:
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	subq	$16, %rsp
	.cfi_def_cfa_offset 32
	testq	%rdi, %rdi
	je	.L54
.L50:
	movq	(%rdi), %rax
	movl	$1, %ecx
	movl	$.LC7, %esi
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
	addq	$16, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 16
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L54:
	.cfi_restore_state
	movq	%rsp, %rdi
	xorl	%esi, %esi
	call	gettimeofday
	movq	%rsp, %rdi
	jmp	.L50
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
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	subq	$8, %rsp
	.cfi_def_cfa_offset 32
	call	__errno_location
	movl	(%rax), %ebp
	movq	%rax, %rbx
	xorl	%edi, %edi
	call	logstats
	movl	%ebp, (%rbx)
	addq	$8, %rsp
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
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
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC8:
	.string	"/tmp"
	.text
	.p2align 4,,15
	.type	handle_alrm, @function
handle_alrm:
.LFB7:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	subq	$8, %rsp
	.cfi_def_cfa_offset 32
	call	__errno_location
	movq	%rax, %rbx
	movl	(%rax), %ebp
	movl	watchdog_flag(%rip), %eax
	testl	%eax, %eax
	je	.L63
	movl	$360, %edi
	movl	$0, watchdog_flag(%rip)
	call	alarm
	movl	%ebp, (%rbx)
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
.L63:
	.cfi_restore_state
	movl	$.LC8, %edi
	call	chdir
	call	abort
	.cfi_endproc
.LFE7:
	.size	handle_alrm, .-handle_alrm
	.section	.rodata.str1.1
.LC9:
	.string	"child wait - %m"
	.text
	.p2align 4,,15
	.type	handle_chld, @function
handle_chld:
.LFB3:
	.cfi_startproc
	pushq	%r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	pushq	%rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	xorl	%ebp, %ebp
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
	subq	$16, %rsp
	.cfi_def_cfa_offset 48
	call	__errno_location
	movl	(%rax), %r12d
	movq	%rax, %rbx
	.p2align 4,,10
	.p2align 3
.L65:
	leaq	12(%rsp), %rsi
	movl	$1, %edx
	movl	$-1, %edi
	call	waitpid
	testl	%eax, %eax
	je	.L66
	js	.L81
	movq	hs(%rip), %rdx
	testq	%rdx, %rdx
	je	.L65
	movl	36(%rdx), %ecx
	subl	$1, %ecx
	cmovs	%ebp, %ecx
	movl	%ecx, 36(%rdx)
	jmp	.L65
	.p2align 4,,10
	.p2align 3
.L81:
	movl	(%rbx), %eax
	cmpl	$11, %eax
	je	.L65
	cmpl	$4, %eax
	je	.L65
	cmpl	$10, %eax
	je	.L66
	movl	$.LC9, %esi
	movl	$3, %edi
	xorl	%eax, %eax
	call	syslog
.L66:
	movl	%r12d, (%rbx)
	addq	$16, %rsp
	.cfi_def_cfa_offset 32
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE3:
	.size	handle_chld, .-handle_chld
	.section	.rodata.str1.8
	.align 8
.LC10:
	.string	"out of memory copying a string"
	.align 8
.LC11:
	.string	"%s: out of memory copying a string\n"
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
	je	.L85
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L85:
	.cfi_restore_state
	movl	$.LC10, %esi
	movl	$2, %edi
	call	syslog
	movq	stderr(%rip), %rdi
	movq	argv0(%rip), %rdx
	movl	$.LC11, %esi
	xorl	%eax, %eax
	call	fprintf
	movl	$1, %edi
	call	exit
	.cfi_endproc
.LFE15:
	.size	e_strdup, .-e_strdup
	.section	.rodata.str1.1
.LC12:
	.string	"r"
.LC13:
	.string	" \t\n\r"
.LC14:
	.string	"debug"
.LC15:
	.string	"port"
.LC16:
	.string	"dir"
.LC17:
	.string	"chroot"
.LC18:
	.string	"nochroot"
.LC19:
	.string	"data_dir"
.LC20:
	.string	"symlink"
.LC21:
	.string	"nosymlink"
.LC22:
	.string	"symlinks"
.LC23:
	.string	"nosymlinks"
.LC24:
	.string	"user"
.LC25:
	.string	"cgipat"
.LC26:
	.string	"cgilimit"
.LC27:
	.string	"urlpat"
.LC28:
	.string	"noemptyreferers"
.LC29:
	.string	"localpat"
.LC30:
	.string	"throttles"
.LC31:
	.string	"host"
.LC32:
	.string	"logfile"
.LC33:
	.string	"vhost"
.LC34:
	.string	"novhost"
.LC35:
	.string	"globalpasswd"
.LC36:
	.string	"noglobalpasswd"
.LC37:
	.string	"pidfile"
.LC38:
	.string	"charset"
.LC39:
	.string	"p3p"
.LC40:
	.string	"max_age"
	.section	.rodata.str1.8
	.align 8
.LC41:
	.string	"%s: unknown config option '%s'\n"
	.text
	.p2align 4,,15
	.type	read_config, @function
read_config:
.LFB12:
	.cfi_startproc
	pushq	%r13
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	movl	$.LC12, %esi
	pushq	%r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	pushq	%rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	pushq	%rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	movq	%rdi, %rbx
	subq	$120, %rsp
	.cfi_def_cfa_offset 160
	call	fopen
	testq	%rax, %rax
	movq	%rax, %r12
	je	.L137
.L88:
	movq	%r12, %rdx
	movl	$1000, %esi
	movq	%rsp, %rdi
	call	fgets
	testq	%rax, %rax
	je	.L138
	movl	$35, %esi
	movq	%rsp, %rdi
	call	strchr
	testq	%rax, %rax
	je	.L89
	movb	$0, (%rax)
.L89:
	movl	$.LC13, %esi
	movq	%rsp, %rdi
	call	strspn
	leaq	(%rsp,%rax), %rbp
	cmpb	$0, 0(%rbp)
	je	.L88
	.p2align 4,,10
	.p2align 3
.L131:
	movl	$.LC13, %esi
	movq	%rbp, %rdi
	call	strcspn
	leaq	0(%rbp,%rax), %rbx
	jmp	.L92
	.p2align 4,,10
	.p2align 3
.L93:
	addq	$1, %rbx
	movb	$0, -1(%rbx)
.L92:
	movzbl	(%rbx), %esi
	cmpb	$32, %sil
	je	.L93
	leal	-9(%rsi), %r8d
	cmpb	$1, %r8b
	jbe	.L93
	cmpb	$13, %sil
	je	.L93
	movl	$61, %esi
	movq	%rbp, %rdi
	call	strchr
	testq	%rax, %rax
	je	.L126
	leaq	1(%rax), %r13
	movb	$0, (%rax)
.L94:
	movl	$.LC14, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L139
	movl	$.LC15, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L140
	movl	$.LC16, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L141
	movl	$.LC17, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L142
	movl	$.LC18, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L143
	movl	$.LC19, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L144
	movl	$.LC20, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L135
	movl	$.LC21, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L136
	movl	$.LC22, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L135
	movl	$.LC23, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L136
	movl	$.LC24, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L145
	movl	$.LC25, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L146
	movl	$.LC26, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L147
	movl	$.LC27, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L148
	movl	$.LC28, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L149
	movl	$.LC29, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L150
	movl	$.LC30, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L151
	movl	$.LC31, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L152
	movl	$.LC32, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L153
	movl	$.LC33, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L154
	movl	$.LC34, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L155
	movl	$.LC35, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L156
	movl	$.LC36, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L157
	movl	$.LC37, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L158
	movl	$.LC38, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L159
	movl	$.LC39, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L160
	movl	$.LC40, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	jne	.L122
	movq	%r13, %rsi
	movq	%rbp, %rdi
	call	value_required
	movq	%r13, %rdi
	call	atoi
	movl	%eax, max_age(%rip)
	.p2align 4,,10
	.p2align 3
.L96:
	movl	$.LC13, %esi
	movq	%rbx, %rdi
	call	strspn
	leaq	(%rbx,%rax), %rbp
	cmpb	$0, 0(%rbp)
	jne	.L131
	jmp	.L88
.L139:
	movq	%r13, %rsi
	movq	%rbp, %rdi
	call	no_value_required
	movl	$1, debug(%rip)
	jmp	.L96
.L140:
	movq	%r13, %rsi
	movq	%rbp, %rdi
	call	value_required
	movq	%r13, %rdi
	call	atoi
	movw	%ax, port(%rip)
	jmp	.L96
.L126:
	xorl	%r13d, %r13d
	jmp	.L94
.L141:
	movq	%r13, %rsi
	movq	%rbp, %rdi
	call	value_required
	movq	%r13, %rdi
	call	e_strdup
	movq	%rax, dir(%rip)
	jmp	.L96
.L142:
	movq	%r13, %rsi
	movq	%rbp, %rdi
	call	no_value_required
	movl	$1, do_chroot(%rip)
	movl	$1, no_symlink_check(%rip)
	jmp	.L96
.L143:
	movq	%r13, %rsi
	movq	%rbp, %rdi
	call	no_value_required
	movl	$0, do_chroot(%rip)
	movl	$0, no_symlink_check(%rip)
	jmp	.L96
.L135:
	movq	%r13, %rsi
	movq	%rbp, %rdi
	call	no_value_required
	movl	$0, no_symlink_check(%rip)
	jmp	.L96
.L144:
	movq	%r13, %rsi
	movq	%rbp, %rdi
	call	value_required
	movq	%r13, %rdi
	call	e_strdup
	movq	%rax, data_dir(%rip)
	jmp	.L96
.L136:
	movq	%r13, %rsi
	movq	%rbp, %rdi
	call	no_value_required
	movl	$1, no_symlink_check(%rip)
	jmp	.L96
.L145:
	movq	%r13, %rsi
	movq	%rbp, %rdi
	call	value_required
	movq	%r13, %rdi
	call	e_strdup
	movq	%rax, user(%rip)
	jmp	.L96
.L147:
	movq	%r13, %rsi
	movq	%rbp, %rdi
	call	value_required
	movq	%r13, %rdi
	call	atoi
	movl	%eax, cgi_limit(%rip)
	jmp	.L96
.L146:
	movq	%r13, %rsi
	movq	%rbp, %rdi
	call	value_required
	movq	%r13, %rdi
	call	e_strdup
	movq	%rax, cgi_pattern(%rip)
	jmp	.L96
.L138:
	movq	%r12, %rdi
	call	fclose
	addq	$120, %rsp
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
.L149:
	.cfi_restore_state
	movq	%r13, %rsi
	movq	%rbp, %rdi
	call	no_value_required
	movl	$1, no_empty_referers(%rip)
	jmp	.L96
.L148:
	movq	%r13, %rsi
	movq	%rbp, %rdi
	call	value_required
	movq	%r13, %rdi
	call	e_strdup
	movq	%rax, url_pattern(%rip)
	jmp	.L96
.L150:
	movq	%r13, %rsi
	movq	%rbp, %rdi
	call	value_required
	movq	%r13, %rdi
	call	e_strdup
	movq	%rax, local_pattern(%rip)
	jmp	.L96
.L137:
	movq	%rbx, %rdi
	call	perror
	movl	$1, %edi
	call	exit
.L151:
	movq	%r13, %rsi
	movq	%rbp, %rdi
	call	value_required
	movq	%r13, %rdi
	call	e_strdup
	movq	%rax, throttlefile(%rip)
	jmp	.L96
.L153:
	movq	%r13, %rsi
	movq	%rbp, %rdi
	call	value_required
	movq	%r13, %rdi
	call	e_strdup
	movq	%rax, logfile(%rip)
	jmp	.L96
.L152:
	movq	%r13, %rsi
	movq	%rbp, %rdi
	call	value_required
	movq	%r13, %rdi
	call	e_strdup
	movq	%rax, hostname(%rip)
	jmp	.L96
.L122:
	movq	stderr(%rip), %rdi
	movq	argv0(%rip), %rdx
	movq	%rbp, %rcx
	movl	$.LC41, %esi
	xorl	%eax, %eax
	call	fprintf
	movl	$1, %edi
	call	exit
.L160:
	movq	%r13, %rsi
	movq	%rbp, %rdi
	call	value_required
	movq	%r13, %rdi
	call	e_strdup
	movq	%rax, p3p(%rip)
	jmp	.L96
.L159:
	movq	%r13, %rsi
	movq	%rbp, %rdi
	call	value_required
	movq	%r13, %rdi
	call	e_strdup
	movq	%rax, charset(%rip)
	jmp	.L96
.L158:
	movq	%r13, %rsi
	movq	%rbp, %rdi
	call	value_required
	movq	%r13, %rdi
	call	e_strdup
	movq	%rax, pidfile(%rip)
	jmp	.L96
.L157:
	movq	%r13, %rsi
	movq	%rbp, %rdi
	call	no_value_required
	movl	$0, do_global_passwd(%rip)
	jmp	.L96
.L156:
	movq	%r13, %rsi
	movq	%rbp, %rdi
	call	no_value_required
	movl	$1, do_global_passwd(%rip)
	jmp	.L96
.L155:
	movq	%r13, %rsi
	movq	%rbp, %rdi
	call	no_value_required
	movl	$0, do_vhost(%rip)
	jmp	.L96
.L154:
	movq	%r13, %rsi
	movq	%rbp, %rdi
	call	no_value_required
	movl	$1, do_vhost(%rip)
	jmp	.L96
	.cfi_endproc
.LFE12:
	.size	read_config, .-read_config
	.section	.rodata.str1.1
.LC42:
	.string	"nobody"
.LC43:
	.string	"iso-8859-1"
.LC44:
	.string	""
.LC45:
	.string	"-V"
.LC46:
	.string	"thttpd/2.27.0 Oct 3, 2014"
.LC47:
	.string	"-C"
.LC48:
	.string	"-p"
.LC49:
	.string	"-d"
.LC50:
	.string	"-r"
.LC51:
	.string	"-nor"
.LC52:
	.string	"-dd"
.LC53:
	.string	"-s"
.LC54:
	.string	"-nos"
.LC55:
	.string	"-u"
.LC56:
	.string	"-c"
.LC57:
	.string	"-t"
.LC58:
	.string	"-h"
.LC59:
	.string	"-l"
.LC60:
	.string	"-v"
.LC61:
	.string	"-nov"
.LC62:
	.string	"-g"
.LC63:
	.string	"-nog"
.LC64:
	.string	"-i"
.LC65:
	.string	"-T"
.LC66:
	.string	"-P"
.LC67:
	.string	"-M"
.LC68:
	.string	"-D"
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
	movq	$.LC42, user(%rip)
	movq	$.LC43, charset(%rip)
	movq	$.LC44, p3p(%rip)
	movl	$-1, max_age(%rip)
	jle	.L189
	movq	8(%rsi), %rbx
	movq	%rsi, %r15
	cmpb	$45, (%rbx)
	jne	.L187
	movl	$1, %ebp
	movl	$.LC45, %r13d
	movl	$3, %r12d
	jmp	.L188
	.p2align 4,,10
	.p2align 3
.L193:
	leal	1(%rbp), %edx
	cmpl	%edx, %r14d
	jle	.L167
	movslq	%edx, %rax
	movl	%edx, 12(%rsp)
	movq	(%r15,%rax,8), %rdi
	call	atoi
	movl	12(%rsp), %edx
	movw	%ax, port(%rip)
	movl	%edx, %ebp
.L166:
	addl	$1, %ebp
	cmpl	%ebp, %r14d
	jle	.L162
.L194:
	movslq	%ebp, %rax
	movq	(%r15,%rax,8), %rbx
	cmpb	$45, (%rbx)
	jne	.L187
.L188:
	movq	%rbx, %rsi
	movq	%r13, %rdi
	movq	%r12, %rcx
	repz cmpsb
	je	.L191
	movl	$.LC47, %edi
	movq	%rbx, %rsi
	movq	%r12, %rcx
	repz cmpsb
	jne	.L165
	leal	1(%rbp), %eax
	cmpl	%eax, %r14d
	jg	.L192
.L165:
	movl	$.LC48, %edi
	movq	%rbx, %rsi
	movq	%r12, %rcx
	repz cmpsb
	je	.L193
.L167:
	movl	$.LC49, %edi
	movq	%rbx, %rsi
	movq	%r12, %rcx
	repz cmpsb
	jne	.L168
	leal	1(%rbp), %eax
	cmpl	%eax, %r14d
	jle	.L168
	movslq	%eax, %rdx
	movl	%eax, %ebp
	movq	(%r15,%rdx,8), %rdx
	addl	$1, %ebp
	cmpl	%ebp, %r14d
	movq	%rdx, dir(%rip)
	jg	.L194
.L162:
	cmpl	%r14d, %ebp
	jne	.L187
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
.L168:
	.cfi_restore_state
	movl	$.LC50, %edi
	movq	%rbx, %rsi
	movq	%r12, %rcx
	repz cmpsb
	jne	.L169
	movl	$1, do_chroot(%rip)
	movl	$1, no_symlink_check(%rip)
	jmp	.L166
	.p2align 4,,10
	.p2align 3
.L169:
	movl	$.LC51, %edi
	movl	$5, %ecx
	movq	%rbx, %rsi
	repz cmpsb
	jne	.L170
	movl	$0, do_chroot(%rip)
	movl	$0, no_symlink_check(%rip)
	jmp	.L166
	.p2align 4,,10
	.p2align 3
.L192:
	movslq	%eax, %rdx
	movl	%eax, 12(%rsp)
	movq	(%r15,%rdx,8), %rdi
	call	read_config
	movl	12(%rsp), %eax
	movl	%eax, %ebp
	jmp	.L166
	.p2align 4,,10
	.p2align 3
.L170:
	movl	$.LC52, %edi
	movl	$4, %ecx
	movq	%rbx, %rsi
	repz cmpsb
	jne	.L171
	leal	1(%rbp), %eax
	cmpl	%eax, %r14d
	jle	.L171
	movslq	%eax, %rdx
	movl	%eax, %ebp
	movq	(%r15,%rdx,8), %rdx
	movq	%rdx, data_dir(%rip)
	jmp	.L166
	.p2align 4,,10
	.p2align 3
.L171:
	movl	$.LC53, %edi
	movq	%rbx, %rsi
	movq	%r12, %rcx
	repz cmpsb
	jne	.L172
	movl	$0, no_symlink_check(%rip)
	jmp	.L166
	.p2align 4,,10
	.p2align 3
.L172:
	movl	$.LC54, %edi
	movl	$5, %ecx
	movq	%rbx, %rsi
	repz cmpsb
	je	.L195
	movl	$.LC55, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L174
	leal	1(%rbp), %eax
	cmpl	%eax, %r14d
	jle	.L174
	movslq	%eax, %rdx
	movl	%eax, %ebp
	movq	(%r15,%rdx,8), %rdx
	movq	%rdx, user(%rip)
	jmp	.L166
.L195:
	movl	$1, no_symlink_check(%rip)
	jmp	.L166
.L174:
	movl	$.LC56, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L175
	leal	1(%rbp), %eax
	cmpl	%eax, %r14d
	jle	.L175
	movslq	%eax, %rdx
	movl	%eax, %ebp
	movq	(%r15,%rdx,8), %rdx
	movq	%rdx, cgi_pattern(%rip)
	jmp	.L166
.L175:
	movl	$.LC57, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L176
	leal	1(%rbp), %eax
	cmpl	%eax, %r14d
	jle	.L176
	movslq	%eax, %rdx
	movl	%eax, %ebp
	movq	(%r15,%rdx,8), %rdx
	movq	%rdx, throttlefile(%rip)
	jmp	.L166
.L176:
	movl	$.LC58, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L177
	leal	1(%rbp), %eax
	cmpl	%eax, %r14d
	jle	.L177
	movslq	%eax, %rdx
	movl	%eax, %ebp
	movq	(%r15,%rdx,8), %rdx
	movq	%rdx, hostname(%rip)
	jmp	.L166
.L177:
	movl	$.LC59, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L178
	leal	1(%rbp), %eax
	cmpl	%eax, %r14d
	jg	.L196
.L178:
	movl	$.LC60, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L179
	movl	$1, do_vhost(%rip)
	jmp	.L166
.L179:
	movl	$.LC61, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	je	.L197
	movl	$.LC62, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L181
	movl	$1, do_global_passwd(%rip)
	jmp	.L166
.L196:
	movslq	%eax, %rdx
	movl	%eax, %ebp
	movq	(%r15,%rdx,8), %rdx
	movq	%rdx, logfile(%rip)
	jmp	.L166
.L197:
	movl	$0, do_vhost(%rip)
	jmp	.L166
.L189:
	movl	$1, %ebp
	jmp	.L162
.L181:
	movl	$.LC63, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L182
	movl	$0, do_global_passwd(%rip)
	jmp	.L166
.L191:
	movl	$.LC46, %edi
	call	puts
	xorl	%edi, %edi
	call	exit
.L182:
	movl	$.LC64, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L183
	leal	1(%rbp), %eax
	cmpl	%eax, %r14d
	jle	.L183
	movslq	%eax, %rdx
	movl	%eax, %ebp
	movq	(%r15,%rdx,8), %rdx
	movq	%rdx, pidfile(%rip)
	jmp	.L166
.L183:
	movl	$.LC65, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L184
	leal	1(%rbp), %eax
	cmpl	%eax, %r14d
	jle	.L184
	movslq	%eax, %rdx
	movl	%eax, %ebp
	movq	(%r15,%rdx,8), %rdx
	movq	%rdx, charset(%rip)
	jmp	.L166
.L184:
	movl	$.LC66, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L185
	leal	1(%rbp), %eax
	cmpl	%eax, %r14d
	jle	.L185
	movslq	%eax, %rdx
	movl	%eax, %ebp
	movq	(%r15,%rdx,8), %rdx
	movq	%rdx, p3p(%rip)
	jmp	.L166
.L185:
	movl	$.LC67, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L186
	leal	1(%rbp), %edx
	cmpl	%edx, %r14d
	jle	.L186
	movslq	%edx, %rax
	movl	%edx, 12(%rsp)
	movq	(%r15,%rax,8), %rdi
	call	atoi
	movl	12(%rsp), %edx
	movl	%eax, max_age(%rip)
	movl	%edx, %ebp
	jmp	.L166
.L186:
	movl	$.LC68, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L187
	movl	$1, debug(%rip)
	jmp	.L166
.L187:
	call	usage
	.cfi_endproc
.LFE10:
	.size	parse_args, .-parse_args
	.section	.rodata.str1.1
.LC69:
	.string	"%.80s - %m"
.LC70:
	.string	" %4900[^ \t] %ld-%ld"
.LC71:
	.string	" %4900[^ \t] %ld"
	.section	.rodata.str1.8
	.align 8
.LC72:
	.string	"unparsable line in %.80s - %.80s"
	.align 8
.LC73:
	.string	"%s: unparsable line in %.80s - %.80s\n"
	.section	.rodata.str1.1
.LC74:
	.string	"|/"
	.section	.rodata.str1.8
	.align 8
.LC75:
	.string	"out of memory allocating a throttletab"
	.align 8
.LC76:
	.string	"%s: out of memory allocating a throttletab\n"
	.text
	.p2align 4,,15
	.type	read_throttlefile, @function
read_throttlefile:
.LFB17:
	.cfi_startproc
	pushq	%r14
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	movl	$.LC12, %esi
	pushq	%r13
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
	pushq	%r12
	.cfi_def_cfa_offset 32
	.cfi_offset 12, -32
	movq	%rdi, %r12
	pushq	%rbp
	.cfi_def_cfa_offset 40
	.cfi_offset 6, -40
	pushq	%rbx
	.cfi_def_cfa_offset 48
	.cfi_offset 3, -48
	subq	$10048, %rsp
	.cfi_def_cfa_offset 10096
	call	fopen
	testq	%rax, %rax
	movq	%rax, %rbp
	je	.L239
	leaq	16(%rsp), %rdi
	leaq	32(%rsp), %rbx
	leaq	5041(%rsp), %r13
	xorl	%esi, %esi
	call	gettimeofday
	.p2align 4,,10
	.p2align 3
.L211:
	movq	%rbp, %rdx
	movl	$5000, %esi
	movq	%rbx, %rdi
	call	fgets
	testq	%rax, %rax
	je	.L240
	movl	$35, %esi
	movq	%rbx, %rdi
	call	strchr
	testq	%rax, %rax
	je	.L201
	movb	$0, (%rax)
.L201:
	movq	%rbx, %rdx
.L202:
	movl	(%rdx), %ecx
	addq	$4, %rdx
	leal	-16843009(%rcx), %eax
	notl	%ecx
	andl	%ecx, %eax
	andl	$-2139062144, %eax
	je	.L202
	movl	%eax, %ecx
	shrl	$16, %ecx
	testl	$32896, %eax
	cmove	%ecx, %eax
	leaq	2(%rdx), %rcx
	cmove	%rcx, %rdx
	addb	%al, %al
	sbbq	$3, %rdx
	subq	%rbx, %rdx
	cmpl	$0, %edx
	movl	%edx, %r9d
	jg	.L205
	jmp	.L243
	.p2align 4,,10
	.p2align 3
.L207:
	testl	%r9d, %r9d
	movb	$0, 32(%rsp,%r10)
	je	.L211
.L205:
	subl	$1, %r9d
	movslq	%r9d, %r10
	movzbl	32(%rsp,%r10), %eax
	cmpb	$32, %al
	je	.L207
	leal	-9(%rax), %edx
	cmpb	$1, %dl
	jbe	.L207
	cmpb	$13, %al
	je	.L207
.L210:
	leaq	8(%rsp), %rcx
	leaq	5040(%rsp), %rdx
	xorl	%eax, %eax
	movq	%rsp, %r8
	movl	$.LC70, %esi
	movq	%rbx, %rdi
	call	__isoc99_sscanf
	cmpl	$3, %eax
	je	.L208
	leaq	5040(%rsp), %rdx
	xorl	%eax, %eax
	movq	%rsp, %rcx
	movl	$.LC71, %esi
	movq	%rbx, %rdi
	call	__isoc99_sscanf
	cmpl	$2, %eax
	jne	.L212
	movq	$0, 8(%rsp)
.L208:
	cmpb	$47, 5040(%rsp)
	jne	.L215
	jmp	.L244
	.p2align 4,,10
	.p2align 3
.L216:
	leaq	2(%rax), %rsi
	leaq	1(%rax), %rdi
	call	strcpy
.L215:
	leaq	5040(%rsp), %rdi
	movl	$.LC74, %esi
	call	strstr
	testq	%rax, %rax
	jne	.L216
	movslq	numthrottles(%rip), %rdx
	movl	maxthrottles(%rip), %eax
	cmpl	%eax, %edx
	jl	.L217
	testl	%eax, %eax
	jne	.L218
	movl	$4800, %edi
	movl	$100, maxthrottles(%rip)
	call	malloc
	movq	%rax, throttles(%rip)
.L219:
	testq	%rax, %rax
	je	.L220
	movslq	numthrottles(%rip), %rdx
.L221:
	leaq	(%rdx,%rdx,2), %rdx
	leaq	5040(%rsp), %rdi
	salq	$4, %rdx
	leaq	(%rax,%rdx), %r14
	call	e_strdup
	movl	numthrottles(%rip), %edx
	movq	%rax, (%r14)
	movq	(%rsp), %rcx
	movslq	%edx, %rax
	addl	$1, %edx
	leaq	(%rax,%rax,2), %rax
	movl	%edx, numthrottles(%rip)
	salq	$4, %rax
	addq	throttles(%rip), %rax
	movq	%rcx, 8(%rax)
	movq	8(%rsp), %rcx
	movq	$0, 24(%rax)
	movq	$0, 32(%rax)
	movl	$0, 40(%rax)
	movq	%rcx, 16(%rax)
	jmp	.L211
.L212:
	movq	%rbx, %rcx
	movq	%r12, %rdx
	xorl	%eax, %eax
	movl	$.LC72, %esi
	movl	$2, %edi
	call	syslog
	movq	argv0(%rip), %rdx
	movq	stderr(%rip), %rdi
	movq	%rbx, %r8
	movq	%r12, %rcx
	movl	$.LC73, %esi
	xorl	%eax, %eax
	call	fprintf
	jmp	.L211
.L218:
	addl	%eax, %eax
	movq	throttles(%rip), %rdi
	movl	%eax, maxthrottles(%rip)
	cltq
	leaq	(%rax,%rax,2), %rsi
	salq	$4, %rsi
	call	realloc
	movq	%rax, throttles(%rip)
	jmp	.L219
.L217:
	movq	throttles(%rip), %rax
	jmp	.L221
.L240:
	movq	%rbp, %rdi
	call	fclose
	addq	$10048, %rsp
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
.L243:
	.cfi_restore_state
	jne	.L210
	jmp	.L211
.L244:
	leaq	5040(%rsp), %rdi
	movq	%r13, %rsi
	call	strcpy
	jmp	.L215
.L239:
	movq	%r12, %rdx
	movl	$.LC69, %esi
	movl	$2, %edi
	xorl	%eax, %eax
	call	syslog
	movq	%r12, %rdi
	call	perror
	movl	$1, %edi
	call	exit
.L220:
	movl	$.LC75, %esi
	movl	$2, %edi
	xorl	%eax, %eax
	call	syslog
	movq	stderr(%rip), %rdi
	movq	argv0(%rip), %rdx
	movl	$.LC76, %esi
	xorl	%eax, %eax
	call	fprintf
	movl	$1, %edi
	call	exit
	.cfi_endproc
.LFE17:
	.size	read_throttlefile, .-read_throttlefile
	.section	.rodata.str1.1
.LC77:
	.string	"-"
.LC78:
	.string	"re-opening logfile"
.LC79:
	.string	"a"
.LC80:
	.string	"re-opening %.80s - %m"
	.text
	.p2align 4,,15
	.type	re_open_logfile, @function
re_open_logfile:
.LFB8:
	.cfi_startproc
	movl	no_log(%rip), %eax
	testl	%eax, %eax
	jne	.L257
	cmpq	$0, hs(%rip)
	je	.L257
	movq	logfile(%rip), %rsi
	testq	%rsi, %rsi
	je	.L257
	movl	$.LC77, %edi
	movl	$2, %ecx
	repz cmpsb
	jne	.L258
.L257:
	rep ret
	.p2align 4,,10
	.p2align 3
.L258:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	xorl	%eax, %eax
	movl	$.LC78, %esi
	movl	$5, %edi
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	subq	$8, %rsp
	.cfi_def_cfa_offset 32
	call	syslog
	movq	logfile(%rip), %rdi
	movl	$.LC79, %esi
	call	fopen
	movq	logfile(%rip), %rbp
	movl	$384, %esi
	movq	%rax, %rbx
	movq	%rbp, %rdi
	call	chmod
	testl	%eax, %eax
	jne	.L249
	testq	%rbx, %rbx
	je	.L249
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
.L249:
	.cfi_restore_state
	addq	$8, %rsp
	.cfi_def_cfa_offset 24
	movq	%rbp, %rdx
	movl	$.LC80, %esi
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
	.section	.rodata.str1.1
.LC81:
	.string	"too many connections!"
	.section	.rodata.str1.8
	.align 8
.LC82:
	.string	"the connects free list is messed up"
	.align 8
.LC83:
	.string	"out of memory allocating an httpd_conn"
	.text
	.p2align 4,,15
	.type	handle_newconnect, @function
handle_newconnect:
.LFB19:
	.cfi_startproc
	pushq	%r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	movq	%rdi, %r12
	pushq	%rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	movl	%esi, %ebp
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
	subq	$16, %rsp
	.cfi_def_cfa_offset 48
	movl	num_connects(%rip), %eax
.L269:
	cmpl	%eax, max_connects(%rip)
	jle	.L277
	movslq	first_free_connect(%rip), %rax
	cmpl	$-1, %eax
	je	.L262
	leaq	(%rax,%rax,8), %rbx
	salq	$4, %rbx
	addq	connects(%rip), %rbx
	movl	(%rbx), %eax
	testl	%eax, %eax
	jne	.L262
	movq	8(%rbx), %rdx
	testq	%rdx, %rdx
	je	.L278
.L264:
	movq	hs(%rip), %rdi
	movl	%ebp, %esi
	call	httpd_get_conn
	testl	%eax, %eax
	je	.L267
	cmpl	$2, %eax
	jne	.L279
	movl	$1, %eax
.L261:
	addq	$16, %rsp
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
.L279:
	.cfi_restore_state
	movl	4(%rbx), %eax
	movl	$1, (%rbx)
	movl	$-1, 4(%rbx)
	addl	$1, num_connects(%rip)
	movl	%eax, first_free_connect(%rip)
	movq	(%r12), %rax
	movq	$0, 96(%rbx)
	movq	$0, 104(%rbx)
	movq	%rax, 88(%rbx)
	movq	8(%rbx), %rax
	movq	$0, 136(%rbx)
	movl	$0, 56(%rbx)
	movl	704(%rax), %edi
	call	httpd_set_ndelay
	movq	8(%rbx), %rax
	xorl	%edx, %edx
	movq	%rbx, %rsi
	movl	704(%rax), %edi
	call	fdwatch_add_fd
	addq	$1, stats_connections(%rip)
	movl	num_connects(%rip), %eax
	cmpl	stats_simultaneous(%rip), %eax
	jle	.L269
	movl	%eax, stats_simultaneous(%rip)
	jmp	.L269
	.p2align 4,,10
	.p2align 3
.L267:
	movq	%r12, %rdi
	movl	%eax, 12(%rsp)
	call	tmr_run
	movl	12(%rsp), %eax
	addq	$16, %rsp
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
.L278:
	.cfi_restore_state
	movl	$720, %edi
	call	malloc
	testq	%rax, %rax
	movq	%rax, 8(%rbx)
	je	.L280
	movl	$0, (%rax)
	addl	$1, httpd_conn_count(%rip)
	movq	%rax, %rdx
	jmp	.L264
	.p2align 4,,10
	.p2align 3
.L277:
	xorl	%eax, %eax
	movl	$.LC81, %esi
	movl	$4, %edi
	call	syslog
	movq	%r12, %rdi
	call	tmr_run
	xorl	%eax, %eax
	jmp	.L261
.L262:
	movl	$2, %edi
	movl	$.LC82, %esi
	xorl	%eax, %eax
	call	syslog
	movl	$1, %edi
	call	exit
.L280:
	movl	$2, %edi
	movl	$.LC83, %esi
	call	syslog
	movl	$1, %edi
	call	exit
	.cfi_endproc
.LFE19:
	.size	handle_newconnect, .-handle_newconnect
	.section	.rodata.str1.8
	.align 8
.LC84:
	.string	"throttle sending count was negative - shouldn't happen!"
	.text
	.p2align 4,,15
	.type	check_throttles, @function
check_throttles:
.LFB23:
	.cfi_startproc
	pushq	%r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	movl	numthrottles(%rip), %eax
	xorl	%r12d, %r12d
	pushq	%rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	xorl	%ebp, %ebp
	testl	%eax, %eax
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
	movq	%rdi, %rbx
	movl	$0, 56(%rdi)
	movq	$-1, 72(%rdi)
	movq	$-1, 64(%rdi)
	jg	.L296
	jmp	.L290
	.p2align 4,,10
	.p2align 3
.L301:
	leal	1(%rdx), %r8d
	movslq	%r8d, %rdi
.L286:
	movslq	56(%rbx), %rdx
	leal	1(%rdx), %r9d
	movl	%r9d, 56(%rbx)
	movl	%r12d, 16(%rbx,%rdx,4)
	cqto
	idivq	%rdi
	movq	64(%rbx), %rdx
	movl	%r8d, 40(%rcx)
	cmpq	$-1, %rdx
	je	.L299
	cmpq	%rdx, %rax
	cmovg	%rdx, %rax
.L299:
	movq	%rax, 64(%rbx)
	movq	72(%rbx), %rax
	cmpq	$-1, %rax
	je	.L300
	cmpq	%rax, %rsi
	cmovl	%rax, %rsi
.L300:
	movq	%rsi, 72(%rbx)
.L284:
	addl	$1, %r12d
	cmpl	%r12d, numthrottles(%rip)
	jle	.L290
	addq	$48, %rbp
	cmpl	$9, 56(%rbx)
	jg	.L290
.L296:
	movq	8(%rbx), %rax
	movq	240(%rax), %rsi
	movq	throttles(%rip), %rax
	movq	(%rax,%rbp), %rdi
	call	match
	testl	%eax, %eax
	je	.L284
	movq	%rbp, %rcx
	addq	throttles(%rip), %rcx
	movq	8(%rcx), %rax
	movq	24(%rcx), %rdx
	leaq	(%rax,%rax), %rsi
	cmpq	%rsi, %rdx
	jg	.L293
	movq	16(%rcx), %rsi
	cmpq	%rsi, %rdx
	jl	.L293
	movl	40(%rcx), %edx
	testl	%edx, %edx
	jns	.L301
	movl	$.LC84, %esi
	movl	$3, %edi
	xorl	%eax, %eax
	call	syslog
	movq	%rbp, %rcx
	addq	throttles(%rip), %rcx
	movl	$1, %edi
	movl	$1, %r8d
	movl	$0, 40(%rcx)
	movq	8(%rcx), %rax
	movq	16(%rcx), %rsi
	jmp	.L286
	.p2align 4,,10
	.p2align 3
.L290:
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	movl	$1, %eax
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L293:
	.cfi_restore_state
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	xorl	%eax, %eax
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE23:
	.size	check_throttles, .-check_throttles
	.p2align 4,,15
	.type	shut_down, @function
shut_down:
.LFB18:
	.cfi_startproc
	pushq	%r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	xorl	%esi, %esi
	pushq	%rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	xorl	%ebp, %ebp
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
	xorl	%ebx, %ebx
	subq	$16, %rsp
	.cfi_def_cfa_offset 48
	movq	%rsp, %rdi
	call	gettimeofday
	movq	%rsp, %rdi
	call	logstats
	movl	max_connects(%rip), %ecx
	testl	%ecx, %ecx
	jg	.L321
	jmp	.L308
	.p2align 4,,10
	.p2align 3
.L306:
	movq	8(%rax), %rdi
	testq	%rdi, %rdi
	je	.L307
	call	httpd_destroy_conn
	movq	%rbx, %r12
	addq	connects(%rip), %r12
	movq	8(%r12), %rdi
	call	free
	subl	$1, httpd_conn_count(%rip)
	movq	$0, 8(%r12)
.L307:
	addl	$1, %ebp
	addq	$144, %rbx
	cmpl	%ebp, max_connects(%rip)
	jle	.L308
.L321:
	movq	%rbx, %rax
	addq	connects(%rip), %rax
	movl	(%rax), %edx
	testl	%edx, %edx
	je	.L306
	movq	8(%rax), %rdi
	movq	%rsp, %rsi
	call	httpd_close_conn
	movq	%rbx, %rax
	addq	connects(%rip), %rax
	jmp	.L306
	.p2align 4,,10
	.p2align 3
.L308:
	movq	hs(%rip), %rbx
	testq	%rbx, %rbx
	je	.L305
	movl	72(%rbx), %edi
	movq	$0, hs(%rip)
	cmpl	$-1, %edi
	je	.L310
	call	fdwatch_del_fd
.L310:
	movl	76(%rbx), %edi
	cmpl	$-1, %edi
	je	.L311
	call	fdwatch_del_fd
.L311:
	movq	%rbx, %rdi
	call	httpd_terminate
.L305:
	call	mmc_destroy
	call	tmr_destroy
	movq	connects(%rip), %rdi
	call	free
	movq	throttles(%rip), %rdi
	testq	%rdi, %rdi
	je	.L302
	call	free
.L302:
	addq	$16, %rsp
	.cfi_def_cfa_offset 32
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE18:
	.size	shut_down, .-shut_down
	.section	.rodata.str1.1
.LC85:
	.string	"exiting"
	.text
	.p2align 4,,15
	.type	handle_usr1, @function
handle_usr1:
.LFB5:
	.cfi_startproc
	movl	num_connects(%rip), %edx
	testl	%edx, %edx
	je	.L330
	movl	$1, got_usr1(%rip)
	ret
.L330:
	pushq	%rax
	.cfi_def_cfa_offset 16
	call	shut_down
	movl	$5, %edi
	movl	$.LC85, %esi
	xorl	%eax, %eax
	call	syslog
	call	closelog
	xorl	%edi, %edi
	call	exit
	.cfi_endproc
.LFE5:
	.size	handle_usr1, .-handle_usr1
	.section	.rodata.str1.1
.LC86:
	.string	"exiting due to signal %d"
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
	movl	$.LC86, %esi
	xorl	%eax, %eax
	call	syslog
	call	closelog
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
	movl	56(%rdi), %eax
	testl	%eax, %eax
	jle	.L333
	subl	$1, %eax
	movq	throttles(%rip), %rdx
	leaq	4(%rdi,%rax,4), %rcx
	.p2align 4,,10
	.p2align 3
.L336:
	movslq	16(%rdi), %rax
	addq	$4, %rdi
	leaq	(%rax,%rax,2), %rax
	salq	$4, %rax
	subl	$1, 40(%rdx,%rax)
	cmpq	%rcx, %rdi
	jne	.L336
.L333:
	rep ret
	.cfi_endproc
.LFE36:
	.size	clear_throttles.isra.0, .-clear_throttles.isra.0
	.p2align 4,,15
	.type	really_clear_connection, @function
really_clear_connection:
.LFB28:
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rdi, %rbx
	subq	$16, %rsp
	.cfi_def_cfa_offset 32
	movq	8(%rdi), %rdi
	movq	200(%rdi), %rax
	addq	%rax, stats_bytes(%rip)
	cmpl	$3, (%rbx)
	je	.L338
	movl	704(%rdi), %edi
	movq	%rsi, 8(%rsp)
	call	fdwatch_del_fd
	movq	8(%rbx), %rdi
	movq	8(%rsp), %rsi
.L338:
	call	httpd_close_conn
	movq	%rbx, %rdi
	call	clear_throttles.isra.0
	movq	104(%rbx), %rdi
	testq	%rdi, %rdi
	je	.L339
	call	tmr_cancel
	movq	$0, 104(%rbx)
.L339:
	movl	first_free_connect(%rip), %eax
	movl	$0, (%rbx)
	subl	$1, num_connects(%rip)
	movl	%eax, 4(%rbx)
	subq	connects(%rip), %rbx
	movabsq	$-8198552921648689607, %rax
	sarq	$4, %rbx
	imulq	%rax, %rbx
	movl	%ebx, first_free_connect(%rip)
	addq	$16, %rsp
	.cfi_def_cfa_offset 16
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE28:
	.size	really_clear_connection, .-really_clear_connection
	.section	.rodata.str1.8
	.align 8
.LC87:
	.string	"replacing non-null linger_timer!"
	.align 8
.LC88:
	.string	"tmr_create(linger_clear_connection) failed"
	.text
	.p2align 4,,15
	.type	clear_connection, @function
clear_connection:
.LFB27:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsi, %rbp
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	movq	%rdi, %rbx
	subq	$8, %rsp
	.cfi_def_cfa_offset 32
	movq	96(%rdi), %rdi
	testq	%rdi, %rdi
	je	.L345
	call	tmr_cancel
	movq	$0, 96(%rbx)
.L345:
	cmpl	$4, (%rbx)
	je	.L346
	movq	8(%rbx), %rax
	movl	556(%rax), %edx
	testl	%edx, %edx
	je	.L348
	cmpl	$3, (%rbx)
	je	.L349
	movl	704(%rax), %edi
	call	fdwatch_del_fd
	movq	8(%rbx), %rax
.L349:
	movl	704(%rax), %edi
	movl	$1, %esi
	movl	$4, (%rbx)
	call	shutdown
	movq	8(%rbx), %rax
	xorl	%edx, %edx
	movq	%rbx, %rsi
	movl	704(%rax), %edi
	call	fdwatch_add_fd
	cmpq	$0, 104(%rbx)
	je	.L350
	movl	$.LC87, %esi
	movl	$3, %edi
	xorl	%eax, %eax
	call	syslog
.L350:
	xorl	%r8d, %r8d
	movl	$500, %ecx
	movq	%rbx, %rdx
	movl	$linger_clear_connection, %esi
	movq	%rbp, %rdi
	call	tmr_create
	testq	%rax, %rax
	movq	%rax, 104(%rbx)
	je	.L356
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L346:
	.cfi_restore_state
	movq	104(%rbx), %rdi
	call	tmr_cancel
	movq	8(%rbx), %rax
	movq	$0, 104(%rbx)
	movl	$0, 556(%rax)
.L348:
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	movq	%rbx, %rdi
	movq	%rbp, %rsi
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	jmp	really_clear_connection
.L356:
	.cfi_restore_state
	movl	$2, %edi
	movl	$.LC88, %esi
	call	syslog
	movl	$1, %edi
	call	exit
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
	movq	%rsi, %rbp
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	movq	%rdi, %rbx
	subq	$8, %rsp
	.cfi_def_cfa_offset 32
	movq	8(%rdi), %rdi
	call	httpd_write_response
	addq	$8, %rsp
	.cfi_def_cfa_offset 24
	movq	%rbx, %rdi
	movq	%rbp, %rsi
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	jmp	clear_connection
	.cfi_endproc
.LFE26:
	.size	finish_connection, .-finish_connection
	.p2align 4,,15
	.type	handle_read, @function
handle_read:
.LFB20:
	.cfi_startproc
	pushq	%r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	movq	%rsi, %r12
	pushq	%rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	movq	%rdi, %rbp
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
	movq	8(%rdi), %rbx
	movq	160(%rbx), %rax
	movq	152(%rbx), %rdx
	cmpq	%rdx, %rax
	jb	.L360
	cmpq	$5000, %rdx
	jbe	.L361
.L386:
	movq	httpd_err400form(%rip), %r8
	movq	httpd_err400title(%rip), %rdx
	movl	$.LC44, %r9d
	movq	%r9, %rcx
	movl	$400, %esi
	movq	%rbx, %rdi
	call	httpd_send_err
.L385:
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	movq	%rbp, %rdi
	movq	%r12, %rsi
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	jmp	finish_connection
	.p2align 4,,10
	.p2align 3
.L361:
	.cfi_restore_state
	leaq	152(%rbx), %rsi
	leaq	144(%rbx), %rdi
	addq	$1000, %rdx
	call	httpd_realloc_str
	movq	152(%rbx), %rdx
	movq	160(%rbx), %rax
.L360:
	subq	%rax, %rdx
	addq	144(%rbx), %rax
	movl	704(%rbx), %edi
	movq	%rax, %rsi
	call	read
	testl	%eax, %eax
	je	.L386
	js	.L387
	cltq
	addq	%rax, 160(%rbx)
	movq	(%r12), %rax
	movq	%rbx, %rdi
	movq	%rax, 88(%rbp)
	call	httpd_got_request
	testl	%eax, %eax
	je	.L359
	cmpl	$2, %eax
	je	.L386
	movq	%rbx, %rdi
	call	httpd_parse_request
	testl	%eax, %eax
	js	.L385
	movq	%rbp, %rdi
	call	check_throttles
	testl	%eax, %eax
	je	.L388
	movq	%r12, %rsi
	movq	%rbx, %rdi
	call	httpd_start_request
	testl	%eax, %eax
	js	.L385
	movl	528(%rbx), %eax
	testl	%eax, %eax
	je	.L370
	movq	536(%rbx), %rax
	movq	%rax, 136(%rbp)
	movq	544(%rbx), %rax
	addq	$1, %rax
	movq	%rax, 128(%rbp)
.L371:
	cmpq	$0, 712(%rbx)
	je	.L389
	movq	128(%rbp), %rax
	cmpq	%rax, 136(%rbp)
	jge	.L385
	movq	(%r12), %rax
	movl	704(%rbx), %edi
	movl	$2, 0(%rbp)
	movq	$0, 112(%rbp)
	movq	%rax, 80(%rbp)
	call	fdwatch_del_fd
	movl	704(%rbx), %edi
	movq	%rbp, %rsi
	movl	$1, %edx
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	jmp	fdwatch_add_fd
	.p2align 4,,10
	.p2align 3
.L387:
	.cfi_restore_state
	call	__errno_location
	movl	(%rax), %eax
	cmpl	$11, %eax
	jne	.L390
.L359:
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L390:
	.cfi_restore_state
	cmpl	$4, %eax
	je	.L359
	.p2align 4,,5
	jmp	.L386
	.p2align 4,,10
	.p2align 3
.L388:
	movq	208(%rbx), %r9
	movq	httpd_err503form(%rip), %r8
	movl	$.LC44, %ecx
	movq	httpd_err503title(%rip), %rdx
	movl	$503, %esi
	movq	%rbx, %rdi
	call	httpd_send_err
	jmp	.L385
	.p2align 4,,10
	.p2align 3
.L370:
	movq	192(%rbx), %rdx
	xorl	%eax, %eax
	testq	%rdx, %rdx
	cmovns	%rdx, %rax
	movq	%rax, 128(%rbp)
	jmp	.L371
.L389:
	movl	56(%rbp), %eax
	testl	%eax, %eax
	jle	.L391
	subl	$1, %eax
	movq	throttles(%rip), %rcx
	movq	200(%rbx), %rsi
	leaq	4(%rbp,%rax,4), %rdi
	movq	%rbp, %rdx
	.p2align 4,,10
	.p2align 3
.L376:
	movslq	16(%rdx), %rax
	addq	$4, %rdx
	leaq	(%rax,%rax,2), %rax
	salq	$4, %rax
	addq	%rsi, 32(%rcx,%rax)
	cmpq	%rdi, %rdx
	jne	.L376
.L375:
	movq	%rsi, 136(%rbp)
	jmp	.L385
.L391:
	movq	200(%rbx), %rsi
	jmp	.L375
	.cfi_endproc
.LFE20:
	.size	handle_read, .-handle_read
	.section	.rodata.str1.8
	.align 8
.LC89:
	.string	"%.80s connection timed out reading"
	.align 8
.LC90:
	.string	"%.80s connection timed out sending"
	.text
	.p2align 4,,15
	.type	idle, @function
idle:
.LFB29:
	.cfi_startproc
	pushq	%r13
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	movq	%rsi, %r13
	pushq	%r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	xorl	%r12d, %r12d
	pushq	%rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	xorl	%ebp, %ebp
	pushq	%rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	subq	$8, %rsp
	.cfi_def_cfa_offset 48
	movl	max_connects(%rip), %eax
	testl	%eax, %eax
	jg	.L399
	jmp	.L392
	.p2align 4,,10
	.p2align 3
.L403:
	jl	.L394
	cmpl	$3, %eax
	.p2align 4,,8
	jg	.L394
	movq	0(%r13), %rax
	subq	88(%rbx), %rax
	cmpq	$299, %rax
	jg	.L402
.L394:
	addl	$1, %r12d
	addq	$144, %rbp
	cmpl	%r12d, max_connects(%rip)
	jle	.L392
.L399:
	movq	%rbp, %rbx
	addq	connects(%rip), %rbx
	movl	(%rbx), %eax
	cmpl	$1, %eax
	jne	.L403
	movq	0(%r13), %rax
	subq	88(%rbx), %rax
	cmpq	$59, %rax
	jle	.L394
	movq	8(%rbx), %rax
	leaq	16(%rax), %rdi
	call	httpd_ntoa
	movl	$.LC89, %esi
	movq	%rax, %rdx
	movl	$6, %edi
	xorl	%eax, %eax
	call	syslog
	movq	8(%rbx), %rdi
	movq	httpd_err408form(%rip), %r8
	movl	$.LC44, %r9d
	movq	httpd_err408title(%rip), %rdx
	movq	%r9, %rcx
	movl	$408, %esi
	call	httpd_send_err
	movq	%r13, %rsi
	movq	%rbx, %rdi
	call	finish_connection
	jmp	.L394
	.p2align 4,,10
	.p2align 3
.L392:
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
	.p2align 4,,10
	.p2align 3
.L402:
	.cfi_restore_state
	movq	8(%rbx), %rax
	leaq	16(%rax), %rdi
	call	httpd_ntoa
	movl	$.LC90, %esi
	movq	%rax, %rdx
	movl	$6, %edi
	xorl	%eax, %eax
	call	syslog
	movq	%r13, %rsi
	movq	%rbx, %rdi
	call	clear_connection
	jmp	.L394
	.cfi_endproc
.LFE29:
	.size	idle, .-idle
	.section	.rodata.str1.8
	.align 8
.LC91:
	.string	"replacing non-null wakeup_timer!"
	.align 8
.LC92:
	.string	"tmr_create(wakeup_connection) failed"
	.section	.rodata.str1.1
.LC93:
	.string	"write - %m sending %.80s"
	.text
	.p2align 4,,15
	.type	handle_send, @function
handle_send:
.LFB21:
	.cfi_startproc
	pushq	%r13
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	movl	$1000000000, %eax
	pushq	%r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	pushq	%rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	movq	%rsi, %rbp
	pushq	%rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	movq	%rdi, %rbx
	subq	$40, %rsp
	.cfi_def_cfa_offset 80
	movq	64(%rdi), %rdx
	movq	8(%rdi), %r12
	cmpq	$-1, %rdx
	je	.L405
	leaq	3(%rdx), %rax
	testq	%rdx, %rdx
	cmovns	%rdx, %rax
	sarq	$2, %rax
.L405:
	movq	472(%r12), %rdx
	testq	%rdx, %rdx
	jne	.L406
	movq	136(%rbx), %rsi
	movq	128(%rbx), %rdx
	movl	704(%r12), %edi
	subq	%rsi, %rdx
	cmpq	%rdx, %rax
	cmovbe	%rax, %rdx
	addq	712(%r12), %rsi
	call	write
	testl	%eax, %eax
	js	.L463
.L408:
	je	.L411
	movq	0(%rbp), %rdx
	movq	%rdx, 88(%rbx)
	movq	472(%r12), %rdx
	testq	%rdx, %rdx
	je	.L462
	movslq	%eax, %rcx
	cmpq	%rcx, %rdx
	ja	.L464
	subl	%edx, %eax
	movq	$0, 472(%r12)
.L462:
	movslq	%eax, %rsi
.L418:
	movq	8(%rbx), %rcx
	movq	%rsi, %rdx
	movq	%rsi, %rax
	addq	136(%rbx), %rdx
	addq	200(%rcx), %rax
	movq	%rdx, 136(%rbx)
	movq	%rax, 200(%rcx)
	movl	56(%rbx), %ecx
	testl	%ecx, %ecx
	jle	.L423
	subl	$1, %ecx
	movq	throttles(%rip), %r9
	movq	%rbx, %r8
	leaq	4(%rbx,%rcx,4), %rdi
	.p2align 4,,10
	.p2align 3
.L424:
	movslq	16(%r8), %rcx
	addq	$4, %r8
	leaq	(%rcx,%rcx,2), %rcx
	salq	$4, %rcx
	addq	%rsi, 32(%r9,%rcx)
	cmpq	%rdi, %r8
	jne	.L424
.L423:
	cmpq	128(%rbx), %rdx
	jge	.L465
	movq	112(%rbx), %rdx
	cmpq	$100, %rdx
	jg	.L466
.L425:
	movq	64(%rbx), %rcx
	cmpq	$-1, %rcx
	je	.L404
	movq	0(%rbp), %r13
	subq	80(%rbx), %r13
	movl	$1, %edx
	cmove	%rdx, %r13
	cqto
	idivq	%r13
	cmpq	%rax, %rcx
	jge	.L404
	movl	704(%r12), %edi
	movl	$3, (%rbx)
	call	fdwatch_del_fd
	movq	8(%rbx), %rax
	movq	200(%rax), %rax
	cqto
	idivq	64(%rbx)
	movl	%eax, %r12d
	subl	%r13d, %r12d
	cmpq	$0, 96(%rbx)
	je	.L428
	movl	$.LC91, %esi
	movl	$3, %edi
	xorl	%eax, %eax
	call	syslog
.L428:
	testl	%r12d, %r12d
	movl	$500, %ecx
	jle	.L461
	movslq	%r12d, %rcx
	imulq	$1000, %rcx, %rcx
	jmp	.L461
	.p2align 4,,10
	.p2align 3
.L406:
	movq	368(%r12), %rcx
	movq	%rdx, 8(%rsp)
	movq	%rsp, %rsi
	movl	704(%r12), %edi
	movq	%rcx, (%rsp)
	movq	136(%rbx), %rcx
	movq	%rcx, %rdx
	addq	712(%r12), %rdx
	movq	%rdx, 16(%rsp)
	movq	128(%rbx), %rdx
	subq	%rcx, %rdx
	cmpq	%rdx, %rax
	cmova	%rdx, %rax
	movl	$2, %edx
	movq	%rax, 24(%rsp)
	call	writev
	testl	%eax, %eax
	jns	.L408
.L463:
	call	__errno_location
	movl	(%rax), %eax
	cmpl	$4, %eax
	je	.L404
	cmpl	$11, %eax
	je	.L411
	cmpl	$32, %eax
	je	.L415
	cmpl	$22, %eax
	.p2align 4,,2
	je	.L415
	cmpl	$104, %eax
	.p2align 4,,2
	je	.L415
	movq	208(%r12), %rdx
	movl	$.LC93, %esi
	movl	$3, %edi
	xorl	%eax, %eax
	call	syslog
.L415:
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	clear_connection
	addq	$40, %rsp
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
.L411:
	.cfi_restore_state
	addq	$100, 112(%rbx)
	movl	704(%r12), %edi
	movl	$3, (%rbx)
	call	fdwatch_del_fd
	cmpq	$0, 96(%rbx)
	je	.L414
	movl	$.LC91, %esi
	movl	$3, %edi
	xorl	%eax, %eax
	call	syslog
.L414:
	movq	112(%rbx), %rcx
.L461:
	xorl	%r8d, %r8d
	movq	%rbx, %rdx
	movl	$wakeup_connection, %esi
	movq	%rbp, %rdi
	call	tmr_create
	testq	%rax, %rax
	movq	%rax, 96(%rbx)
	je	.L467
.L404:
	addq	$40, %rsp
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
.L466:
	.cfi_restore_state
	subq	$100, %rdx
	movq	%rdx, 112(%rbx)
	jmp	.L425
	.p2align 4,,10
	.p2align 3
.L464:
	movq	368(%r12), %rdi
	subl	%eax, %edx
	movslq	%edx, %r13
	movq	%r13, %rdx
	leaq	(%rdi,%rcx), %rsi
	call	memmove
	movq	%r13, 472(%r12)
	xorl	%esi, %esi
	jmp	.L418
	.p2align 4,,10
	.p2align 3
.L465:
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	finish_connection
	addq	$40, %rsp
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
.L467:
	.cfi_restore_state
	movl	$2, %edi
	movl	$.LC92, %esi
	xorl	%eax, %eax
	call	syslog
	movl	$1, %edi
	call	exit
	.cfi_endproc
.LFE21:
	.size	handle_send, .-handle_send
	.p2align 4,,15
	.type	linger_clear_connection, @function
linger_clear_connection:
.LFB31:
	.cfi_startproc
	movq	$0, 104(%rdi)
	jmp	really_clear_connection
	.cfi_endproc
.LFE31:
	.size	linger_clear_connection, .-linger_clear_connection
	.p2align 4,,15
	.type	handle_linger, @function
handle_linger:
.LFB22:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movl	$4096, %edx
	movq	%rsi, %rbp
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	movq	%rdi, %rbx
	subq	$4104, %rsp
	.cfi_def_cfa_offset 4128
	movq	8(%rdi), %rax
	movq	%rsp, %rsi
	movl	704(%rax), %edi
	call	read
	testl	%eax, %eax
	js	.L476
	je	.L472
.L469:
	addq	$4104, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L476:
	.cfi_restore_state
	call	__errno_location
	movl	(%rax), %eax
	cmpl	$11, %eax
	je	.L469
	cmpl	$4, %eax
	je	.L469
.L472:
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	really_clear_connection
	addq	$4104, %rsp
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE22:
	.size	handle_linger, .-handle_linger
	.section	.rodata.str1.1
.LC94:
	.string	"%d"
.LC95:
	.string	"getaddrinfo %.80s - %.80s"
.LC96:
	.string	"%s: getaddrinfo %s - %s\n"
	.section	.rodata.str1.8
	.align 8
.LC97:
	.string	"%.80s - sockaddr too small (%lu < %lu)"
	.text
	.p2align 4,,15
	.type	lookup_hostname.constprop.1, @function
lookup_hostname.constprop.1:
.LFB37:
	.cfi_startproc
	pushq	%r14
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	xorl	%eax, %eax
	movq	%rdx, %r14
	movl	$.LC94, %edx
	pushq	%r13
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
	movq	%rcx, %r13
	movl	$6, %ecx
	pushq	%r12
	.cfi_def_cfa_offset 32
	.cfi_offset 12, -32
	movq	%rsi, %r12
	movl	$10, %esi
	pushq	%rbp
	.cfi_def_cfa_offset 40
	.cfi_offset 6, -40
	movq	%rdi, %rbp
	pushq	%rbx
	.cfi_def_cfa_offset 48
	.cfi_offset 3, -48
	subq	$80, %rsp
	.cfi_def_cfa_offset 128
	leaq	32(%rsp), %rbx
	movq	%rbx, %rdi
	rep stosq
	movzwl	port(%rip), %ecx
	leaq	16(%rsp), %rdi
	movl	$1, 32(%rsp)
	movl	$1, 40(%rsp)
	call	snprintf
	movq	hostname(%rip), %rdi
	leaq	8(%rsp), %rcx
	leaq	16(%rsp), %rsi
	movq	%rbx, %rdx
	call	getaddrinfo
	testl	%eax, %eax
	movl	%eax, %ebx
	jne	.L546
	movq	8(%rsp), %rax
	testq	%rax, %rax
	je	.L479
	xorl	%ebx, %ebx
	xorl	%esi, %esi
	jmp	.L484
	.p2align 4,,10
	.p2align 3
.L548:
	cmpl	$10, %r8d
	jne	.L480
	testq	%rsi, %rsi
	cmove	%rax, %rsi
.L480:
	movq	40(%rax), %rax
	testq	%rax, %rax
	je	.L547
.L484:
	movl	4(%rax), %r8d
	cmpl	$2, %r8d
	jne	.L548
	testq	%rbx, %rbx
	cmove	%rax, %rbx
	movq	40(%rax), %rax
	testq	%rax, %rax
	jne	.L484
.L547:
	testq	%rsi, %rsi
	je	.L549
	movl	16(%rsi), %r8d
	cmpq	$128, %r8
	ja	.L545
	testb	$1, %r14b
	movq	%r14, %rdi
	movl	$128, %r8d
	jne	.L550
.L488:
	testb	$2, %dil
	jne	.L551
.L489:
	testb	$4, %dil
	jne	.L552
.L490:
	movl	%r8d, %ecx
	xorl	%eax, %eax
	shrl	$3, %ecx
	testb	$4, %r8b
	rep stosq
	jne	.L553
.L491:
	testb	$2, %r8b
	jne	.L554
.L492:
	andl	$1, %r8d
	jne	.L555
.L493:
	movl	16(%rsi), %edx
	movq	24(%rsi), %rsi
	movq	%r14, %rdi
	call	memmove
	movl	$1, 0(%r13)
.L486:
	testq	%rbx, %rbx
	je	.L556
	movl	16(%rbx), %r8d
	cmpq	$128, %r8
	ja	.L545
	testb	$1, %bpl
	movq	%rbp, %rdi
	movl	$128, %edx
	jne	.L557
.L497:
	testb	$2, %dil
	jne	.L558
.L498:
	testb	$4, %dil
	jne	.L559
.L499:
	movl	%edx, %ecx
	xorl	%eax, %eax
	shrl	$3, %ecx
	testb	$4, %dl
	rep stosq
	jne	.L560
.L500:
	testb	$2, %dl
	jne	.L561
.L501:
	andl	$1, %edx
	jne	.L562
.L502:
	movl	16(%rbx), %edx
	movq	24(%rbx), %rsi
	movq	%rbp, %rdi
	call	memmove
	movl	$1, (%r12)
.L495:
	movq	8(%rsp), %rdi
	call	freeaddrinfo
	addq	$80, %rsp
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
.L562:
	.cfi_restore_state
	movb	$0, (%rdi)
	jmp	.L502
.L561:
	movw	$0, (%rdi)
	addq	$2, %rdi
	jmp	.L501
.L560:
	movl	$0, (%rdi)
	addq	$4, %rdi
	jmp	.L500
.L555:
	movb	$0, (%rdi)
	jmp	.L493
.L554:
	movw	$0, (%rdi)
	addq	$2, %rdi
	jmp	.L492
.L553:
	movl	$0, (%rdi)
	addq	$4, %rdi
	jmp	.L491
.L549:
	movq	%rbx, %rax
.L479:
	movl	$0, 0(%r13)
	movq	%rax, %rbx
	jmp	.L486
.L556:
	movl	$0, (%r12)
	jmp	.L495
.L557:
	movb	$0, 0(%rbp)
	leaq	1(%rbp), %rdi
	movb	$127, %dl
	jmp	.L497
.L558:
	movw	$0, (%rdi)
	subl	$2, %edx
	addq	$2, %rdi
	jmp	.L498
.L559:
	movl	$0, (%rdi)
	subl	$4, %edx
	addq	$4, %rdi
	jmp	.L499
.L552:
	movl	$0, (%rdi)
	subl	$4, %r8d
	addq	$4, %rdi
	jmp	.L490
.L550:
	movb	$0, (%r14)
	leaq	1(%r14), %rdi
	movb	$127, %r8b
	jmp	.L488
.L551:
	movw	$0, (%rdi)
	subl	$2, %r8d
	addq	$2, %rdi
	jmp	.L489
.L545:
	movq	hostname(%rip), %rdx
	movl	$2, %edi
	movl	$128, %ecx
	movl	$.LC97, %esi
	xorl	%eax, %eax
	call	syslog
	movl	$1, %edi
	call	exit
.L546:
	movl	%eax, %edi
	call	gai_strerror
	movq	hostname(%rip), %rdx
	movq	%rax, %rcx
	movl	$.LC95, %esi
	movl	$2, %edi
	xorl	%eax, %eax
	call	syslog
	movl	%ebx, %edi
	call	gai_strerror
	movq	stderr(%rip), %rdi
	movq	hostname(%rip), %rcx
	movq	%rax, %r8
	movq	argv0(%rip), %rdx
	movl	$.LC96, %esi
	xorl	%eax, %eax
	call	fprintf
	movl	$1, %edi
	call	exit
	.cfi_endproc
.LFE37:
	.size	lookup_hostname.constprop.1, .-lookup_hostname.constprop.1
	.section	.rodata.str1.1
.LC98:
	.string	"can't find any valid address"
	.section	.rodata.str1.8
	.align 8
.LC99:
	.string	"%s: can't find any valid address\n"
	.section	.rodata.str1.1
.LC100:
	.string	"unknown user - '%.80s'"
.LC101:
	.string	"%s: unknown user - '%s'\n"
.LC102:
	.string	"/dev/null"
	.section	.rodata.str1.8
	.align 8
.LC103:
	.string	"logfile is not an absolute path, you may not be able to re-open it"
	.align 8
.LC104:
	.string	"%s: logfile is not an absolute path, you may not be able to re-open it\n"
	.section	.rodata.str1.1
.LC105:
	.string	"fchown logfile - %m"
.LC106:
	.string	"fchown logfile"
.LC107:
	.string	"chdir - %m"
.LC108:
	.string	"chdir"
.LC109:
	.string	"daemon - %m"
.LC110:
	.string	"w"
.LC111:
	.string	"%d\n"
	.section	.rodata.str1.8
	.align 8
.LC112:
	.string	"fdwatch initialization failure"
	.section	.rodata.str1.1
.LC113:
	.string	"chroot - %m"
	.section	.rodata.str1.8
	.align 8
.LC114:
	.string	"logfile is not within the chroot tree, you will not be able to re-open it"
	.align 8
.LC115:
	.string	"%s: logfile is not within the chroot tree, you will not be able to re-open it\n"
	.section	.rodata.str1.1
.LC116:
	.string	"chroot chdir - %m"
.LC117:
	.string	"chroot chdir"
.LC118:
	.string	"data_dir chdir - %m"
.LC119:
	.string	"data_dir chdir"
.LC120:
	.string	"tmr_create(occasional) failed"
.LC121:
	.string	"tmr_create(idle) failed"
	.section	.rodata.str1.8
	.align 8
.LC122:
	.string	"tmr_create(update_throttles) failed"
	.section	.rodata.str1.1
.LC123:
	.string	"tmr_create(show_stats) failed"
.LC124:
	.string	"setgroups - %m"
.LC125:
	.string	"setgid - %m"
.LC126:
	.string	"initgroups - %m"
.LC127:
	.string	"setuid - %m"
	.section	.rodata.str1.8
	.align 8
.LC128:
	.string	"started as root without requesting chroot(), warning only"
	.align 8
.LC129:
	.string	"out of memory allocating a connecttab"
	.section	.rodata.str1.1
.LC130:
	.string	"fdwatch - %m"
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
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	movl	%edi, %r12d
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	movq	%rsi, %rbp
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$4520, %rsp
	.cfi_def_cfa_offset 4576
	movq	(%rsi), %rbx
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
	leaq	144(%rsp), %rbp
	leaq	272(%rsp), %r12
	call	parse_args
	call	tzset
	leaq	124(%rsp), %rcx
	leaq	120(%rsp), %rsi
	movq	%r12, %rdx
	movq	%rbp, %rdi
	call	lookup_hostname.constprop.1
	movl	120(%rsp), %ecx
	testl	%ecx, %ecx
	jne	.L565
	cmpl	$0, 124(%rsp)
	je	.L698
.L565:
	movq	throttlefile(%rip), %rdi
	movl	$0, numthrottles(%rip)
	movl	$0, maxthrottles(%rip)
	movq	$0, throttles(%rip)
	testq	%rdi, %rdi
	je	.L566
	call	read_throttlefile
.L566:
	call	getuid
	testl	%eax, %eax
	movl	$32767, %r15d
	movl	$32767, 100(%rsp)
	je	.L699
.L567:
	movq	logfile(%rip), %rbx
	testq	%rbx, %rbx
	je	.L638
	movl	$.LC102, %edi
	movl	$10, %ecx
	movq	%rbx, %rsi
	repz cmpsb
	je	.L700
	movl	$.LC77, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L571
	movq	stdout(%rip), %r14
.L569:
	movq	dir(%rip), %rdi
	testq	%rdi, %rdi
	je	.L575
	call	chdir
	testl	%eax, %eax
	js	.L701
.L575:
	leaq	400(%rsp), %rbx
	movl	$4096, %esi
	movq	%rbx, %rdi
	call	getcwd
	movq	%rbx, %rdx
.L576:
	movl	(%rdx), %ecx
	addq	$4, %rdx
	leal	-16843009(%rcx), %eax
	notl	%ecx
	andl	%ecx, %eax
	andl	$-2139062144, %eax
	je	.L576
	movl	%eax, %ecx
	shrl	$16, %ecx
	testl	$32896, %eax
	cmove	%ecx, %eax
	leaq	2(%rdx), %rcx
	cmove	%rcx, %rdx
	addb	%al, %al
	sbbq	$3, %rdx
	subq	%rbx, %rdx
	cmpb	$47, 399(%rsp,%rdx)
	je	.L578
	movw	$47, (%rbx,%rdx)
.L578:
	movl	debug(%rip), %edx
	testl	%edx, %edx
	jne	.L579
	movq	stdin(%rip), %rdi
	call	fclose
	movq	stdout(%rip), %rdi
	cmpq	%rdi, %r14
	je	.L580
	call	fclose
.L580:
	movq	stderr(%rip), %rdi
	call	fclose
	movl	$1, %esi
	movl	$1, %edi
	call	daemon
	testl	%eax, %eax
	movl	$.LC109, %esi
	js	.L696
.L581:
	movq	pidfile(%rip), %rdi
	testq	%rdi, %rdi
	je	.L582
	movl	$.LC110, %esi
	call	fopen
	testq	%rax, %rax
	movq	%rax, %r13
	je	.L702
	call	getpid
	movq	%r13, %rdi
	movl	%eax, %edx
	movl	$.LC111, %esi
	xorl	%eax, %eax
	call	fprintf
	movq	%r13, %rdi
	call	fclose
.L582:
	call	fdwatch_get_nfiles
	testl	%eax, %eax
	movl	%eax, max_connects(%rip)
	js	.L703
	subl	$10, %eax
	cmpl	$0, do_chroot(%rip)
	movl	%eax, max_connects(%rip)
	jne	.L704
.L585:
	movq	data_dir(%rip), %rdi
	testq	%rdi, %rdi
	je	.L589
	call	chdir
	testl	%eax, %eax
	js	.L705
.L589:
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
	cmpl	$0, 124(%rsp)
	movq	%r12, %rdx
	movzwl	port(%rip), %ecx
	movl	cgi_limit(%rip), %r9d
	movq	cgi_pattern(%rip), %r8
	movq	hostname(%rip), %rdi
	movl	%eax, 88(%rsp)
	movq	local_pattern(%rip), %rax
	cmove	%rsi, %rdx
	cmpl	$0, 120(%rsp)
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
	je	.L697
	movq	JunkClientData(%rip), %rdx
	xorl	%edi, %edi
	movl	$1, %r8d
	movl	$120000, %ecx
	movl	$occasional, %esi
	call	tmr_create
	testq	%rax, %rax
	je	.L706
	movq	JunkClientData(%rip), %rdx
	xorl	%edi, %edi
	movl	$1, %r8d
	movl	$5000, %ecx
	movl	$idle, %esi
	call	tmr_create
	testq	%rax, %rax
	je	.L707
	cmpl	$0, numthrottles(%rip)
	jle	.L595
	movq	JunkClientData(%rip), %rdx
	xorl	%edi, %edi
	movl	$1, %r8d
	movl	$2000, %ecx
	movl	$update_throttles, %esi
	call	tmr_create
	testq	%rax, %rax
	je	.L708
.L595:
	movq	JunkClientData(%rip), %rdx
	xorl	%edi, %edi
	movl	$1, %r8d
	movl	$3600000, %ecx
	movl	$show_stats, %esi
	call	tmr_create
	testq	%rax, %rax
	je	.L709
	xorl	%edi, %edi
	call	time
	movq	$0, stats_connections(%rip)
	movq	%rax, stats_time(%rip)
	movq	%rax, start_time(%rip)
	movq	$0, stats_bytes(%rip)
	movl	$0, stats_simultaneous(%rip)
	call	getuid
	testl	%eax, %eax
	jne	.L598
	xorl	%esi, %esi
	xorl	%edi, %edi
	call	setgroups
	testl	%eax, %eax
	movl	$.LC124, %esi
	js	.L696
	movl	%r15d, %edi
	call	setgid
	testl	%eax, %eax
	movl	$.LC125, %esi
	js	.L696
	movq	user(%rip), %rdi
	movl	%r15d, %esi
	call	initgroups
	testl	%eax, %eax
	js	.L710
.L601:
	movl	100(%rsp), %edi
	call	setuid
	testl	%eax, %eax
	movl	$.LC127, %esi
	js	.L696
	cmpl	$0, do_chroot(%rip)
	je	.L711
.L598:
	movl	max_connects(%rip), %ebx
	movslq	%ebx, %rbp
	imulq	$144, %rbp, %rbp
	movq	%rbp, %rdi
	call	malloc
	testq	%rax, %rax
	movq	%rax, connects(%rip)
	je	.L604
	xorl	%ecx, %ecx
	testl	%ebx, %ebx
	movq	%rax, %rdx
	jle	.L608
	.p2align 4,,10
	.p2align 3
.L677:
	addl	$1, %ecx
	movl	$0, (%rdx)
	movq	$0, 8(%rdx)
	movl	%ecx, 4(%rdx)
	addq	$144, %rdx
	cmpl	%ebx, %ecx
	jne	.L677
.L608:
	movl	$-1, -140(%rax,%rbp)
	movq	hs(%rip), %rax
	movl	$0, first_free_connect(%rip)
	movl	$0, num_connects(%rip)
	movl	$0, httpd_conn_count(%rip)
	testq	%rax, %rax
	je	.L610
	movl	72(%rax), %edi
	cmpl	$-1, %edi
	je	.L611
	xorl	%edx, %edx
	xorl	%esi, %esi
	call	fdwatch_add_fd
	movq	hs(%rip), %rax
.L611:
	movl	76(%rax), %edi
	cmpl	$-1, %edi
	je	.L610
	xorl	%edx, %edx
	xorl	%esi, %esi
	call	fdwatch_add_fd
.L610:
	leaq	128(%rsp), %rdi
	call	tmr_prepare_timeval
	.p2align 4,,10
	.p2align 3
.L612:
	movl	terminate(%rip), %eax
	testl	%eax, %eax
	je	.L636
	cmpl	$0, num_connects(%rip)
	jle	.L712
.L636:
	movl	got_hup(%rip), %eax
	testl	%eax, %eax
	jne	.L713
.L613:
	leaq	128(%rsp), %rdi
	call	tmr_mstimeout
	movq	%rax, %rdi
	call	fdwatch
	testl	%eax, %eax
	movl	%eax, %ebx
	js	.L714
	leaq	128(%rsp), %rdi
	call	tmr_prepare_timeval
	testl	%ebx, %ebx
	je	.L715
	movq	hs(%rip), %rax
	testq	%rax, %rax
	je	.L627
	movl	76(%rax), %edi
	cmpl	$-1, %edi
	je	.L621
	call	fdwatch_check_fd
	testl	%eax, %eax
	jne	.L622
.L625:
	movq	hs(%rip), %rax
	testq	%rax, %rax
	je	.L627
.L621:
	movl	72(%rax), %edi
	cmpl	$-1, %edi
	je	.L627
	call	fdwatch_check_fd
	testl	%eax, %eax
	jne	.L716
	.p2align 4,,10
	.p2align 3
.L627:
	call	fdwatch_get_next_client_data
	cmpq	$-1, %rax
	movq	%rax, %rbx
	je	.L717
	testq	%rbx, %rbx
	je	.L627
	movq	8(%rbx), %rax
	movl	704(%rax), %edi
	call	fdwatch_check_fd
	testl	%eax, %eax
	je	.L718
	movl	(%rbx), %eax
	cmpl	$2, %eax
	je	.L630
	cmpl	$4, %eax
	je	.L631
	cmpl	$1, %eax
	jne	.L627
	leaq	128(%rsp), %rsi
	movq	%rbx, %rdi
	call	handle_read
	jmp	.L627
.L700:
	movl	$1, no_log(%rip)
	xorl	%r14d, %r14d
	jmp	.L569
.L579:
	call	setsid
	jmp	.L581
.L703:
	movl	$.LC112, %esi
.L696:
	movl	$2, %edi
	xorl	%eax, %eax
	call	syslog
.L697:
	movl	$1, %edi
	call	exit
.L699:
	movq	user(%rip), %rdi
	call	getpwnam
	testq	%rax, %rax
	je	.L719
	movl	16(%rax), %ecx
	movl	20(%rax), %r15d
	movl	%ecx, 100(%rsp)
	jmp	.L567
.L698:
	movl	$.LC98, %esi
	movl	$3, %edi
	xorl	%eax, %eax
	call	syslog
	movq	stderr(%rip), %rdi
	movq	argv0(%rip), %rdx
	movl	$.LC99, %esi
	xorl	%eax, %eax
	call	fprintf
	movl	$1, %edi
	call	exit
.L718:
	leaq	128(%rsp), %rsi
	movq	%rbx, %rdi
	call	clear_connection
	jmp	.L627
.L714:
	call	__errno_location
	movl	(%rax), %eax
	cmpl	$11, %eax
	.p2align 4,,3
	je	.L612
	cmpl	$4, %eax
	je	.L612
	movl	$3, %edi
	movl	$.LC130, %esi
	xorl	%eax, %eax
	call	syslog
	movl	$1, %edi
	call	exit
.L631:
	leaq	128(%rsp), %rsi
	movq	%rbx, %rdi
	call	handle_linger
	jmp	.L627
.L630:
	leaq	128(%rsp), %rsi
	movq	%rbx, %rdi
	call	handle_send
	jmp	.L627
.L717:
	leaq	128(%rsp), %rdi
	call	tmr_run
	movl	got_usr1(%rip), %eax
	testl	%eax, %eax
	je	.L612
	cmpl	$0, terminate(%rip)
	jne	.L612
	movq	hs(%rip), %rax
	movl	$1, terminate(%rip)
	testq	%rax, %rax
	je	.L612
	movl	72(%rax), %edi
	cmpl	$-1, %edi
	je	.L634
	call	fdwatch_del_fd
	movq	hs(%rip), %rax
.L634:
	movl	76(%rax), %edi
	cmpl	$-1, %edi
	je	.L635
	call	fdwatch_del_fd
.L635:
	movq	hs(%rip), %rdi
	call	httpd_unlisten
	jmp	.L612
.L713:
	call	re_open_logfile
	movl	$0, got_hup(%rip)
	jmp	.L613
.L715:
	leaq	128(%rsp), %rdi
	call	tmr_run
	jmp	.L612
.L704:
	movq	%rbx, %rdi
	call	chroot
	testl	%eax, %eax
	.p2align 4,,3
	js	.L720
	movq	logfile(%rip), %r13
	testq	%r13, %r13
	je	.L587
	movl	$.LC77, %esi
	movq	%r13, %rdi
	call	strcmp
	testl	%eax, %eax
	je	.L587
	xorl	%eax, %eax
	orq	$-1, %rcx
	movq	%rbx, %rdi
	repnz scasb
	movq	%rbx, %rsi
	movq	%r13, %rdi
	notq	%rcx
	leaq	-1(%rcx), %rdx
	movq	%rcx, 104(%rsp)
	call	strncmp
	testl	%eax, %eax
	movq	104(%rsp), %rcx
	jne	.L588
	leaq	-2(%r13,%rcx), %rsi
	movq	%r13, %rdi
	call	strcpy
.L587:
	movq	%rbx, %rdi
	movw	$47, 400(%rsp)
	call	chdir
	testl	%eax, %eax
	jns	.L585
	movl	$.LC116, %esi
	movl	$2, %edi
	xorl	%eax, %eax
	call	syslog
	movl	$.LC117, %edi
	call	perror
	movl	$1, %edi
	call	exit
.L638:
	xorl	%r14d, %r14d
	jmp	.L569
.L571:
	movq	%rbx, %rdi
	movl	$.LC79, %esi
	call	fopen
	movq	logfile(%rip), %rbx
	movl	$384, %esi
	movq	%rax, %r14
	movq	%rbx, %rdi
	call	chmod
	testl	%eax, %eax
	jne	.L641
	testq	%r14, %r14
	je	.L641
	cmpb	$47, (%rbx)
	.p2align 4,,3
	je	.L574
	movl	$.LC103, %esi
	movl	$4, %edi
	xorl	%eax, %eax
	call	syslog
	movq	argv0(%rip), %rdx
	movq	stderr(%rip), %rdi
	movl	$.LC104, %esi
	xorl	%eax, %eax
	call	fprintf
.L574:
	movq	%r14, %rdi
	call	fileno
	movl	$1, %edx
	movl	%eax, %edi
	movl	$2, %esi
	xorl	%eax, %eax
	call	fcntl
	call	getuid
	testl	%eax, %eax
	jne	.L569
	movq	%r14, %rdi
	call	fileno
	movl	100(%rsp), %esi
	movl	%r15d, %edx
	movl	%eax, %edi
	call	fchown
	testl	%eax, %eax
	jns	.L569
	movl	$.LC105, %esi
	movl	$4, %edi
	xorl	%eax, %eax
	call	syslog
	movl	$.LC106, %edi
	call	perror
	jmp	.L569
.L701:
	movl	$.LC107, %esi
	movl	$2, %edi
	xorl	%eax, %eax
	call	syslog
	movl	$.LC108, %edi
	call	perror
	movl	$1, %edi
	call	exit
.L702:
	movq	pidfile(%rip), %rdx
	movl	$2, %edi
	movl	$.LC69, %esi
	xorl	%eax, %eax
	call	syslog
	movl	$1, %edi
	call	exit
.L706:
	movl	$2, %edi
	movl	$.LC120, %esi
	call	syslog
	movl	$1, %edi
	call	exit
.L705:
	movl	$.LC118, %esi
	movl	$2, %edi
	xorl	%eax, %eax
	call	syslog
	movl	$.LC119, %edi
	call	perror
	movl	$1, %edi
	call	exit
.L588:
	xorl	%eax, %eax
	movl	$.LC114, %esi
	movl	$4, %edi
	call	syslog
	movq	argv0(%rip), %rdx
	movq	stderr(%rip), %rdi
	movl	$.LC115, %esi
	xorl	%eax, %eax
	call	fprintf
	jmp	.L587
.L711:
	movl	$.LC128, %esi
	movl	$4, %edi
	xorl	%eax, %eax
	call	syslog
	jmp	.L598
.L708:
	movl	$2, %edi
	movl	$.LC122, %esi
	call	syslog
	movl	$1, %edi
	call	exit
.L622:
	movq	hs(%rip), %rax
	leaq	128(%rsp), %rdi
	movl	76(%rax), %esi
	call	handle_newconnect
	testl	%eax, %eax
	jne	.L612
	jmp	.L625
.L716:
	movq	hs(%rip), %rax
	leaq	128(%rsp), %rdi
	movl	72(%rax), %esi
	call	handle_newconnect
	testl	%eax, %eax
	jne	.L612
	jmp	.L627
.L709:
	movl	$2, %edi
	movl	$.LC123, %esi
	call	syslog
	movl	$1, %edi
	call	exit
.L641:
	movq	%rbx, %rdx
	movl	$.LC69, %esi
	movl	$2, %edi
	xorl	%eax, %eax
	call	syslog
	movq	logfile(%rip), %rdi
	call	perror
	movl	$1, %edi
	call	exit
.L712:
	call	shut_down
	movl	$5, %edi
	movl	$.LC85, %esi
	xorl	%eax, %eax
	call	syslog
	call	closelog
	xorl	%edi, %edi
	call	exit
.L707:
	movl	$2, %edi
	movl	$.LC121, %esi
	call	syslog
	movl	$1, %edi
	call	exit
.L720:
	movl	$.LC113, %esi
	movl	$2, %edi
	xorl	%eax, %eax
	call	syslog
	movl	$.LC17, %edi
	call	perror
	movl	$1, %edi
	call	exit
.L719:
	movq	user(%rip), %rdx
	movl	$.LC100, %esi
	movl	$2, %edi
	call	syslog
	movq	stderr(%rip), %rdi
	movq	user(%rip), %rcx
	movl	$.LC101, %esi
	movq	argv0(%rip), %rdx
	xorl	%eax, %eax
	call	fprintf
	movl	$1, %edi
	call	exit
.L604:
	movl	$.LC129, %esi
	jmp	.L696
.L710:
	movl	$.LC126, %esi
	movl	$4, %edi
	xorl	%eax, %eax
	call	syslog
	jmp	.L601
	.cfi_endproc
.LFE9:
	.size	main, .-main
	.local	watchdog_flag
	.comm	watchdog_flag,4,4
	.local	got_usr1
	.comm	got_usr1,4,4
	.local	got_hup
	.comm	got_hup,4,4
	.comm	stats_simultaneous,4,4
	.comm	stats_bytes,8,8
	.comm	stats_connections,8,8
	.comm	stats_time,8,8
	.comm	start_time,8,8
	.globl	terminate
	.bss
	.align 4
	.type	terminate, @object
	.size	terminate, 4
terminate:
	.zero	4
	.local	hs
	.comm	hs,8,8
	.local	httpd_conn_count
	.comm	httpd_conn_count,4,4
	.local	first_free_connect
	.comm	first_free_connect,4,4
	.local	max_connects
	.comm	max_connects,4,4
	.local	num_connects
	.comm	num_connects,4,4
	.local	connects
	.comm	connects,8,8
	.local	maxthrottles
	.comm	maxthrottles,4,4
	.local	numthrottles
	.comm	numthrottles,4,4
	.local	throttles
	.comm	throttles,8,8
	.local	max_age
	.comm	max_age,4,4
	.local	p3p
	.comm	p3p,8,8
	.local	charset
	.comm	charset,8,8
	.local	user
	.comm	user,8,8
	.local	pidfile
	.comm	pidfile,8,8
	.local	hostname
	.comm	hostname,8,8
	.local	throttlefile
	.comm	throttlefile,8,8
	.local	logfile
	.comm	logfile,8,8
	.local	local_pattern
	.comm	local_pattern,8,8
	.local	no_empty_referers
	.comm	no_empty_referers,4,4
	.local	url_pattern
	.comm	url_pattern,8,8
	.local	cgi_limit
	.comm	cgi_limit,4,4
	.local	cgi_pattern
	.comm	cgi_pattern,8,8
	.local	do_global_passwd
	.comm	do_global_passwd,4,4
	.local	do_vhost
	.comm	do_vhost,4,4
	.local	no_symlink_check
	.comm	no_symlink_check,4,4
	.local	no_log
	.comm	no_log,4,4
	.local	do_chroot
	.comm	do_chroot,4,4
	.local	data_dir
	.comm	data_dir,8,8
	.local	dir
	.comm	dir,8,8
	.local	port
	.comm	port,2,2
	.local	debug
	.comm	debug,4,4
	.local	argv0
	.comm	argv0,8,8
	.ident	"GCC: (GNU) 4.8.5 20150623 (Red Hat 4.8.5-16)"
	.section	.note.GNU-stack,"",@progbits
