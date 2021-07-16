programa
{
	inclua biblioteca Util
	inclua biblioteca Teclado  --> t
	inclua biblioteca Graficos --> g
	inclua biblioteca Sons --> s
	funcao inicio()
	{
	     inteiro imagem = g.carregar_imagem("mario.png"), imagem2 = g.carregar_imagem("moeda_mario.png")
		inteiro imagem3 = g.carregar_imagem("estrela.png"), imagem4 = g.carregar_imagem("final.png")
		inteiro imagem5 = g.carregar_imagem("super_mario.png")
		inteiro mario [5] = {imagem, 30, 1, 60, 75} 
		inteiro obstaculos[6][4] = {{1,100,300,50},{150,250,50,250},{450,300,50,300},{700,400,300,50},{650,200,200,50},{600,1,50,250}}
		inteiro fim [5] = {imagem3,800,50,50,50}, final [5] = {imagem4, 0, 0, 1066, 600}, comeco [5] = {imagem5, 1, 70, 1000, 467}
		inteiro x[20], y[20], moedas [20][5] 
		inteiro recolhe = 0, pontos = 0
		inteiro somMoeda = s.carregar_som("efeito_sonoro_moeda.mp3") 
		inteiro somColisao = s.carregar_som("efeito_sonoro_colisao.mp3")
		//inteiro somJogo = s.carregar_som("musica_mario.mp3") 
		//inteiro somFim = s.carregar_som("musica_fim.mp3")		
		g.iniciar_modo_grafico(verdadeiro)
		g.definir_dimensoes_janela(1000,600)		
		fundoBranco()
		desenhaInicio(comeco)		
	     g.renderizar()	
	     Util.aguarde(3000)
		enquanto (verdadeiro) {			
			//sortear poesição x e y das moedas e guardar nos vetores 
			para(inteiro i=0; i<Util.numero_elementos(x); i++) {
				x[i] = (sorteiaNumX())
				y[i] = (sorteiaNumY())
			}
			//guardar valores na matriz
			matrizMoedas(moedas, x, y, imagem2)
			//verificar se as moedas estão nas mesma posição que outras moedas, obstaculos, mario e estrela(fim)			
			para(inteiro i=0; i < Util.numero_linhas(moedas); i++) {
		    		se((verificaAreaMoeda(moedas,i)) ou (verificaAreaTotal (moedas, i, obstaculos, fim, mario))) {
		        		x[i] = (sorteiaNumX())
		        		y[i] = (sorteiaNumY())
		        		moedas[i][1] = x[i]
		        		moedas[i][2] = y[i]
		        		i--		        
		    		}
			}			
			enquanto (nao chegouFinal(mario,fim)) {			
				//s.reproduzir_som(somJogo,verdadeiro)	
				fundoBranco()
				desenhaMario(mario)			
				desenhaObstaculos(obstaculos)			
				desenhaFim(fim)						
				desenhaMoedas(moedas, recolhe)	
				cadeia textoPontos = "Pontuação atual: " 		
				//"recolher" as moedas: 1) verificar a posição de mario e das moedas 
				// 2) quando verdadeiro trocar o valor do elemento "i" para o o último elemento da matriz
				// 3) trocar valor do elemento seguinte de "i" para 1 á esquerda e assim sucetivamente até o último				
				para(inteiro i = 0; i < (Util.numero_linhas(moedas) - recolhe); i++) {
					se(recolherMoeda(mario,moedas,i)) {												               
		               	trocaMoedas (i,moedas)		               	
		               	pontos++
		             		s.reproduzir_som(somMoeda,falso)
		             		recolhe++		                		
					}
				}			
				se(pontos < 0 ) {
			    		pontos = 0
				}	
				textoPontos = textoPontos + pontos			
		   		desenhaPontos(pontos, textoPontos)
				g.renderizar()           
               	logico abaixo = t.tecla_pressionada(t.TECLA_SETA_ABAIXO)
               	logico acima = t.tecla_pressionada(t.TECLA_SETA_ACIMA)
               	logico direita = t.tecla_pressionada(t.TECLA_SETA_DIREITA)
               	logico esquerda = t.tecla_pressionada(t.TECLA_SETA_ESQUERDA)              
               	se(abaixo e mario[2] < g.altura_janela()-mario[4]) {              	
                   		mario[2]++
                   		se(colisao(mario,obstaculos)) {
                   			mario[2]--    
                   			s.reproduzir_som(somColisao,falso)	
                   			pontos--          
                    	}                  
               	}             
               	se(acima e mario[2] > 0) {
                   		mario[2]--	
                   		se(colisao(mario,obstaculos)) {
                   			mario[2]++    
                   			s.reproduzir_som(somColisao,falso)	
                   			pontos--        
                    	}                      
               	}
         			se(direita e mario[1] < g.largura_janela()-mario[3]) {
                   		mario[1]++
                   		se(colisao(mario,obstaculos)) {
                   			mario[1]--     
                   			s.reproduzir_som(somColisao,falso)	 
                   			pontos--      
                   		}
              	 	}
               	se(esquerda e mario[1] > 0) {
               		mario[1]--
               		se(colisao(mario,obstaculos)) {
                   			mario[1]++  
                   			s.reproduzir_som(somColisao,falso)	 
                   			pontos--           
                    	}
               	}             
				Util.aguarde(5)					    
	     	}		
	     	// quando verdadeiro quebra o segundo laço de enquanto
	     	enquanto (chegouFinal(mario,fim)) {
	         		desenhaFinal(final,pontos)
	         		g.renderizar()	
	         		logico enter = t.tecla_pressionada(t.TECLA_ENTER)                       
              		// quando verdadeiro entra/volta ao segundo laço de enquanto 
              		se(enter) {
                  		mario[1] = 0
                  		mario[2] = 0
                  		pontos = 0
                  		recolhe = 0
              		}
	     	}
	     } 	     
	}        	
	funcao inteiro sorteiaNumX() {
	    inteiro numeroX = 0
	    numeroX = Util.sorteia(1, g.largura_janela()-30)	         	
	    retorne numeroX 		    		 
	}
	funcao inteiro sorteiaNumY() {
	    inteiro numeroY = 0
	    numeroY = Util.sorteia(1, g.altura_janela()-29)	         	
	    retorne numeroY 		    		 
	}
	funcao vazio matrizMoedas (inteiro moedas[][], inteiro numX[], inteiro numY[], inteiro imagem) {
	    para(inteiro i=0; i<Util.numero_linhas(moedas); i++) {
		    moedas[i][0] = imagem
		    moedas[i][1] = numX[i]
		    moedas[i][2] = numY[i]
		    moedas[i][3] = 30
		    moedas[i][4] = 29
		}	
	}
	funcao vazio fundoBranco () {
	    g.definir_cor(g.COR_BRANCO)
	    g.desenhar_retangulo(0, 0, g.largura_janela(), g.altura_janela(), falso, verdadeiro)
	}
	funcao vazio desenhaMario (inteiro imagem[]) {
	    g.desenhar_imagem(imagem[1], imagem[2], imagem[0])
	}
	funcao vazio desenhaObstaculos (inteiro el [][]) {
	    g.definir_cor(g.COR_PRETO)
	    para(inteiro i = 0; i < 6; i++) {
	        g.desenhar_retangulo(el[i][0], el[i][1], el[i][2], el[i][3], falso, verdadeiro)	
	    }
	}
	funcao vazio desenhaMoedas (inteiro moeda[][], inteiro y) {
	    para(inteiro i=0; i < (Util.numero_linhas(moeda) - y); i++) {
	        g.desenhar_imagem(moeda[i][1], moeda[i][2], moeda[i][0])	
	    }	
	}
	funcao vazio desenhaFim (inteiro fim[]) {
	    g.desenhar_imagem(fim[1], fim[2], fim[0])	    
	}
	funcao logico colisao(inteiro ma[], inteiro obs[][]) {
         logico colidiu = falso         
         para(inteiro i = 0; i < Util.numero_linhas(obs); i++) {
             se(ma[1]+ma[3]>=obs[i][0] e ma[2]+ma[4]>=obs[i][1] e ma[2]<=obs[i][1]+obs[i][3] e ma[1]<=obs[i][0]+obs[i][2]) {
        	       colidiu = verdadeiro
             }  	
         } retorne colidiu
	}	
	funcao logico chegouFinal (inteiro ma[], inteiro fim[]) {
	    logico retorno = falso 
	    se(ma[1]+ma[3]>=fim[1] e ma[2]+ma[4]>=fim[2] e ma[2]<=fim[2]+fim[4] e ma[1]<=fim[1]+fim[3]) {
	        retorno = verdadeiro 
	    }
	    retorne retorno 	
	}
	funcao logico verificaAreaMoeda (inteiro m[][], inteiro i) {
	    logico retorno =  falso 
	    // primeiro "para" verifica até o elemento "i"
	    para (inteiro x = 0; x < i; x++){	    		                              
             se(m[i][1]+m[i][3]>=m[x][1] e m[i][2]+m[i][4]>=m[x][2] e m[i][2]<=m[x][2]+m[x][4] e m[i][1]<=m[x][1]+m[x][3]) {             
        	       retorno = verdadeiro
             }                             	                                   	                                                         		
	    } 
	    // segundo "para" verifica depois do elemento "i"
	    para (inteiro x = (i+1); x < 20; x++) {	    		                                        
             se(m[i][1]+m[i][3]>=m[x][1] e m[i][2]+m[i][4]>=m[x][2] e m[i][2]<=m[x][2]+m[x][4] e m[i][1]<=m[x][1]+m[x][3]) {             
        	       retorno = verdadeiro
             }                        	                                   	                                                         		
	    } retorne retorno 
	}
	funcao logico verificaAreaTotal (inteiro m[][], inteiro i ,inteiro obs[][], inteiro fim[], inteiro ma[]) {
	    logico retorno =  falso 
	    para(inteiro x = 0; x < Util.numero_linhas(obs); x++) {	    		                              
             se(m[i][1]+m[i][3]>=obs[x][0] e m[i][2]+m[i][4]>=obs[x][1] e m[i][2]<=obs[x][1]+obs[x][3] e m[i][1]<=obs[x][0]+obs[x][2]
                ou m[i][1]+m[i][3]>=fim[1] e m[i][2]+m[i][4]>=fim[2] e m[i][2]<=fim[2]+fim[4] e m[i][1]<=fim[1]+fim[3] 
            	 ou m[i][1]+m[i][3]>=ma[1] e m[i][2]+m[i][4]>=ma[2] e m[i][2]<=ma[2]+ma[4] e m[i][1]<=ma[1]+ma[3]) {
        	          retorno = verdadeiro
             }           	                                   	                                                         			               	                                   	                                                         		
	    } retorne retorno 	   
	}
	// "recolher" moedas: 1)
	funcao logico recolherMoeda (inteiro ma[], inteiro moe[][], inteiro i) {
	    logico retorno = falso		
	    se(ma[1]+ma[3]>=moe[i][1] e ma[2]+ma[4]>=moe[i][2] e ma[2]<=moe[i][2]+moe[i][4] e ma[1]<=moe[i][1]+moe[i][3]) {
             retorno = verdadeiro
         } retorne retorno 			 			         
	}	
	funcao vazio trocaMoedas (inteiro i, inteiro moeda[][]) { 
	    inteiro reserva [5], x = i, y = Util.numero_linhas(moeda) 
	    // "recolher" moedas: 2)
	    para(inteiro r=0; r<Util.numero_elementos(reserva); r++) {
	        reserva [r] = moeda [i][r]
	    }
	     // "recolher" moedas: 3)
	    para(x = i; x < (y - 1); x++) {		    	
	        para(inteiro m=0; m<Util.numero_colunas(moeda); m++) { 
		       moeda [x][m] = moeda [(x+1)][m]
		   }		    
	    } 
	     // "recolher" moedas: 2)
	    para(inteiro r=0; r<Util.numero_elementos(reserva); r++) {
	        moeda [(y-1)][r] = reserva [r]	       
	    }	
	}
	funcao vazio desenhaPontos (inteiro pontos, cadeia textoPontos) {				
	    g.definir_cor(g.COR_PRETO)
	    g.definir_estilo_texto(falso, verdadeiro, falso)
	    g.definir_tamanho_texto(18.0)
	    g.desenhar_texto(350, 1, textoPontos)
	}
	funcao vazio desenhaFinal (inteiro imagem[],inteiro pontos) {
	    cadeia texto = "Pontuação final: " + pontos 
	    cadeia texto2 = "PARABÉNS!!", texto3 = "VOCÊ GANHOU"
	    cadeia texto4 = "* Para jogar novamente aperte a tecla ENTER *"
	    g.desenhar_imagem(imagem[1], imagem[2], imagem[0])
	   // s.reproduzir_som(somFim, verdadeiro)
	    g.definir_tamanho_texto(36.0)
	    g.definir_cor(g.COR_PRETO)
	    g.desenhar_texto(345, 350, texto)
	    g.desenhar_texto(400, 200, texto2)
	    g.desenhar_texto(380, 250, texto3)
	    g.definir_tamanho_texto(16.0)
	    g.desenhar_texto(315, 50, texto4)
	}
	funcao vazio desenhaInicio (inteiro imagem[]) {
	    g.desenhar_imagem(imagem[1], imagem[2], imagem[0])
	}
}
/* $$$ Portugol Studio $$$ 
 * 
 * Esta seção do arquivo guarda informações do Portugol Studio.
 * Você pode apagá-la se estiver utilizando outro editor.
 * 
 * @POSICAO-CURSOR = 2005; 
 * @PONTOS-DE-PARADA = ;
 * @SIMBOLOS-INSPECIONADOS = ;
 * @FILTRO-ARVORE-TIPOS-DE-DADO = inteiro, real, logico, cadeia, caracter, vazio;
 * @FILTRO-ARVORE-TIPOS-DE-SIMBOLO = variavel, vetor, matriz, funcao;
 */