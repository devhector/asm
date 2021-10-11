# Escreva um programa que conte com três subrotinas capazes de calcular a área da
# circunferência (π*r^2), do triângulo (b*a/2) e do retângulo (b*a). Inicialmente,
# pergunte ao usuário (use syscall) qual forma geométrica ele deseja (armazenando no
# registrador $t0) e depois solicite as medidas necessárias para calcular a área de cada
# forma (armazenar para circunferência o valor r em $t0, triângulo e retângulo
# armazenar valor de a e b em $t0 e $t1, respectivamente). Ao final, imprima a área
# desejada. Respeite as convenções de uso dos registradores.

.data
	string: .asciiz "Calculadora de area\n"
	options: .asciiz "0 - sair | 1 - circunferencia | 2 - triangulo | 3 - retangulo\n"
	cir_op: .asciiz "Digite o valor do raio: "
	a_op: .asciiz "Digite o valor da altura: "
	b_op: .asciiz "Digite o valor da base: "
	p_area: .asciiz "\nA area e: "
	jump_line: .asciiz "\n\n"
	type_it: .asciiz "Digite: "
	
.text
	main:
		# setando os valores para usar nas opcoes
		ori $t1, $zero, 1			# atribui 1 a t1
		ori $t2, $zero, 2			# atribui 2 a t2
		ori $t3, $zero, 3			# atribui 3 a t3
		
		# imprimindo a primeira parte
		la $a0, string				#carrega o end. de string
		jal print				#chama a subrotina print
		
		#imprimindos as opcoes
		la $a0, options
		jal print
		
		la $a0, type_it
		jal print
		
		#lendo o valor das opcoes
		jal read
		move $t0, $v0
		
		#verificando se eh opcao valida
		slt $t4, $t0, $zero			# se valor recebido é menor que 0
		beq $t4, $t1, main			# se t4 = 1
		
		slti $t4, $t0, 4			# se valor recebido é maior que 3
		beq $t4, $zero, main			# se t4 < 4
		
		
		#verificando opcoes
		beq $t0, $zero, finish			#finaliza se escolher 0
		beq $t0, $t1, circle			#opcao 1
		beq $t0, $t2, triangle			#opcao 2
		beq $t0, $t3, rectangle			#opcao 3
		
		
	print:						#funcao para imprimir string
		li $v0, 4				#carregamento imediato de 4 -> string
		syscall
		jr $ra
	
	print_i: 					#funcao para imprimir inteiro
		li $v0, 1
		syscall
		jr $ra
	
	read:						#funcao para ler inteiro
		li $v0, 5
		syscall
		jr $ra

	circle:
							# circunferência (π*r^2)
		ori $t2, 3				#atribuindo 3 a t2 para usar na operação
		
		la $a0, cir_op				#carregando o end. "Digite o valor do raio: "
		jal print
		
		jal read				#chamando a func p ler 
		move $t0, $v0				#setando t0 com o valor de retorno da read
		
		multu $t0, $t0				# valorLido * valorLido
		mflo $t0				# recebe o valor multiplicado
		
		multu $t0, $t2				#multiplica valorLido^2 * 3
		mflo $t2
		
		la $a0, p_area				#carrega "\nA area e: "
		jal print
		
		move $a0, $t2				#set como parametro o valor da operação
		jal print_i

		la $a0, jump_line			#printa um pulo de linha
		jal print

		jal main				#volta pra main
	
	triangle:
	
		ori $t2, 2
		
		la $a0, a_op
		jal print
		
		jal read
		move $t0, $v0
		
		la $a0, b_op
		jal print
		
		jal read
		move $t1, $v0
		
		multu $t0, $t1
		mflo $t0
		
		div $t0, $t2
		mflo $t2
		
		la $a0, p_area
		jal print
		
		move $a0, $t2
		jal print_i

		la $a0, jump_line
		jal print

		jal main

	rectangle:
	
		la $a0, a_op
		jal print
		
		jal read
		move $t0, $v0
		
		la $a0, b_op
		jal print
		
		jal read
		move $t1, $v0
		
		multu $t0, $t1
		mflo $t2
		
		la $a0, p_area
		jal print
		
		move $a0, $t2
		jal print_i

		la $a0, jump_line
		jal print

		jal main
		
	finish: 
		li, $v0, 10
		syscall 