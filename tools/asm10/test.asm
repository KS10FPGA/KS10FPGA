	jrst	.+1		; clear
	subi	7,20
	move	3,[1234]		;
	sub	3,[-3]
	sub	3,[0,,-3]
zap:	add @-1			; another
	LOC	30000
	;;  start with a comment
	;;  and another

	;;  a blank line
	cai	foo+3
	1,,2			; comment
	baz,,-bar
	addi 5+3
	add 1,[4,,5]			; another
baz:	subi @200
	addi 17,@300(16)
	setz (4)
	jrst 4,bar
	addi 1,baz
foo:	sub 77
	add 3
add:	add 4,5
	andca 45(3)
bar:	halt .+1
	jump
	START	foo
	