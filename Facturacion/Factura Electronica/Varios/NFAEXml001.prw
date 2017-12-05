#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TBICONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �NfdsXml001� Autor � Roberto Souza         � Data �21/05/2009���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Exemplo de geracao da Nota Fiscal Digital de Servi�os       ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Xml para envio                                              ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpC1: Tipo da NF                                           ���
���          �       [0] Entrada                                          ���
���          �       [1] Saida                                            ���
���          �ExpC2: Serie da NF                                          ���
���          �ExpC3: Numero da nota fiscal                                ���
���          �ExpC4: Codigo do cliente ou fornecedor                      ���
���          �ExpC5: Loja do cliente ou fornecedor                        ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function NFAEXml001(cTipo,cSerie,cNota,cClieFor,cLoja,nUltId,cTipoNF)

Local nX        := 0
Local cString    := ""
Local cAliasSD1  := "SD1"
Local cAliasSD2  := "SD2"
Local cMensCli   := ""
Local cMensFis   := ""
Local cNFe       := ""
Local cWhere	 := ""
Local lQuery    := .F.
Local aNota     := {}
Local aDest     := {}
Local aEntrega  := {}
Local aProd     := {}
Local acabNF :={}
Local aPed :={}             
Local aNfVinc:={}       
Local cCodUM:=""
Local lPedido :=""                                                                    
Local cUltId:= AllTrim(str(PARAMIXB[6])) 
Local nIB:=0
Local nIV:=0
Private aColIB	:={}
Private aColIVA	:={}
Private aIB:={}
Private aIVA:={}
Private _cSerie := ""
Private DocTipo := "80"
DEFAULT cTipo   := PARAMIXB[1]
DEFAULT cSerie  := PARAMIXB[2]
DEFAULT cNota   := PARAMIXB[3]
DEFAULT cClieFor:= PARAMIXB[4]
DEFAULT cLoja   := PARAMIXB[5]
DEFAULT cTipoNF := PARAMIXB[7]


If cTipo == "1"
	//������������������������������������������������������������������������Ŀ
	//�Posiciona NF                                                            �
	//��������������������������������������������������������������������������
	dbSelectArea("SF2")
	dbSetOrder(1)
	DbGoTop()
	If DbSeek(xFilial("SF2")+cNota+cSerie+cClieFor+cLoja)	
		aadd(aCabNF,SF2->F2_EMISSAO)
		aadd(aCabNF,Subs(SF2->F2_DOC,1,4))
		aadd(aCabNF,Subs(SF2->F2_DOC,5,8))                  
		aadd(aCabNF,SF2->F2_TXMOEDA)  
		aadd(aCabNF,SF2->F2_VALBRUT)  // Criar campo no cadastro de clientes ou no pedido		          
//		aadd(aCabNF,SF2->F2_VALFAT)  // Criar campo no cadastro de clientes ou no pedido		          
		// inicio agregado I Factura Nacional 
		Impostos()
		nVlIb:=0
		For nIB := 1 To Len(aColIB)
		    If &("SF2->F2_VALIMP"+aColIB[nIB][1]) > 0
				aadd(aIB,{&("SF2->F2_VALIMP"+aColIB[nIB][1]),;                    
								&("SF2->F2_BASIMP"+aColIB[nIB][1]),;              
									aColIB[nIB][2],;                              
									aColIB[nIB][3],;                              
									aColIB[nIB][4],;                              
									})
			EndIf						
			nVlIb:= nVlIb + &("SF2->F2_VALIMP"+aColIB[nIB][1])		
		Next				
			
		nVlIv:=0
		For nIV := 1 To Len(aColIVA)
			nVlIv:= nVlIv + &("SF2->F2_VALIMP"+aColIVA[nIV][1])
			If  &("SF2->F2_VALIMP"+aColIVA[nIV][1]) > 0
				aadd(aIVA,{&("SF2->F2_VALIMP"+aColIVA[nIV][1]),;
							&("SF2->F2_BASIMP"+aColIVA[nIV][1]),;
								aColIVA[nIV][2],;
								aColIVA[nIV][3],;
								aColIVA[nIV][4],;								
								})
			EndIf					
		Next		
		aadd(aCabNF,nVlIb)  
		aadd(aCabNF,nVlIv)  
		aadd(aCabNF,SF2->F2_FRETE+SF2->F2_DESPESA+SF2->F2_SEGURO)  
		aadd(aCabNF,SF2->F2_SERIE)
		aadd(aCabNF,SF2->F2_ESPECIE)
		aadd(aCabNF,SF2->F2_VALMERC)  
		
		_cSerie		:= SF2->F2_SERIE 
						
		//������������������������������������������������������������������������Ŀ
		//�Posiciona cliente ou fornecedor                                         �
		//��������������������������������������������������������������������������	
		If Alltrim(SF2->F2_ESPECIE)=="NDI"  
			dbSelectArea("SA2")
			dbSetOrder(1)
			DbSeek(xFilial("SA2")+SF2->F2_CLIENTE+SF2->F2_LOJA)
			aadd(aDest,AllTrim(SA2->A2_PAIS))
			aadd(aDest,SA2->A2_NOME)
			aadd(aDest,AllTrim(SA2->A2_CGC))
			aadd(aDest,MyGetEnd(SA2->A2_END,"SA2")[1])
		
		Else
			dbSelectArea("SA1")
			dbSetOrder(1)
			DbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA)
			aadd(aDest,AllTrim(SA1->A1_PAIS))
			aadd(aDest,SA1->A1_NOME)
			if !empty(SA1->A1_AFIP) //si tiene codigo de documento, tomar ese, sino 80 por default
				DocTipo := Tabela("OC",Alltrim(SA1->A1_AFIP), .F. ) // 80 = CUIT 
        		DocTipo := Left(DocTipo,Max(At('|',DocTipo),1)-1)
    		else
    			DocTipo := "80" // Si no tiene A1_AFIP
    		endif
    		if DocTipo $ "80|86" //si es 80/86 tomar el CUIT/CUIL, sino, tomar el DNI
				aadd(aDest,AllTrim(SA1->A1_CGC))
			Else
				aadd(aDest,AllTrim(SA1->A1_RG))				
			EndIf
				aadd(aDest,MyGetEnd(SA1->A1_END,"SA1")[1])
		EndIf
		
		//������������������������������������������������������������������������Ŀ
		//�Posiciona cliente ou fornecedor                                         �
		//��������������������������������������������������������������������������	
		If Alltrim(SF2->F2_ESPECIE)=="NDI"  
			dbSelectArea("SA2")
			dbSetOrder(1)
			DbSeek(xFilial("SA2")+SF2->F2_CLIENTE+SF2->F2_LOJA)
			aadd(aDest,AllTrim(SA2->A2_PAIS))
			aadd(aDest,SA2->A2_NOME)
			aadd(aDest,AllTrim(SA2->A2_CGC))
			aadd(aDest,MyGetEnd(SA2->A2_END,"SA2")[1])
		
		Else
			dbSelectArea("SA1")
			dbSetOrder(1)
			DbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA)
			aadd(aDest,AllTrim(SA1->A1_PAIS))
			aadd(aDest,SA1->A1_NOME)
			if !empty(SA1->A1_AFIP) 
				DocTipo := Tabela("OC",Alltrim(SA1->A1_AFIP), .F. ) // 80 = CUIT 
        		DocTipo := Left(DocTipo,Max(At('|',DocTipo),1)-1)
    		else
    			DocTipo := "80"
    		endif
    		if DocTipo $ "80|86" //si es 80, tomar el CUIT, sino, tomar el DI
				aadd(aDest,AllTrim(SA1->A1_CGC))
			Else
				aadd(aDest,AllTrim(SA1->A1_RG))				
			EndIf
				aadd(aDest,MyGetEnd(SA1->A1_END,"SA1")[1])
		EndIf
		
		dbSelectArea("SF2")
		//������������������������������������������������������������������������Ŀ
		//�Pesquisa itens de nota                                                  �
		//��������������������������������������������������������������������������	
		dbSelectArea("SD2")
		dbSetOrder(3)	
		#IFDEF TOP
			lQuery  := .T.
			cAliasSD2 := GetNextAlias()
			BeginSql Alias cAliasSD2
				SELECT * FROM %Table:SD2% SD2
				WHERE
				SD2.D2_FILIAL = %xFilial:SD2% AND
				SD2.D2_SERIE = %Exp:SF2->F2_SERIE% AND 
				SD2.D2_DOC = %Exp:SF2->F2_DOC% AND 
				SD2.D2_CLIENTE = %Exp:SF2->F2_CLIENTE% AND 
				SD2.D2_LOJA = %Exp:SF2->F2_LOJA% AND 
				SD2.%NotDel%
				ORDER BY %Order:SD2%
			EndSql
				
		#ELSE
			DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)
		#ENDIF 
		dbSelectArea(cAliasSD2)
		While !Eof() .And. xFilial("SD2") == (cAliasSD2)->D2_FILIAL .And.;
			SF2->F2_SERIE == (cAliasSD2)->D2_SERIE .And.;
			SF2->F2_DOC == (cAliasSD2)->D2_DOC
			//������������������������������������������������������������������������Ŀ
			//�Verifica as notas vinculadas                                            �
			//��������������������������������������������������������������������������
			If !Empty((cAliasSD2)->D2_NFORI) 
				If (cAliasSD2)->D2_TIPO $ "DBN"
					dbSelectArea("SD1")
					dbSetOrder(1)
					If DbSeek(xFilial("SD1")+(cAliasSD2)->D2_NFORI+(cAliasSD2)->D2_SERIORI+(cAliasSD2)->D2_CLIENTE+(cAliasSD2)->D2_LOJA+(cAliasSD2)->D2_COD+(cAliasSD2)->D2_ITEMORI)
						dbSelectArea("SF1")
						dbSetOrder(1)
						DbSeek(xFilial("SF1")+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_TIPO)
						If SD1->D1_TIPO $ "DB"
							dbSelectArea("SA1")
							dbSetOrder(1)
							DbSeek(xFilial("SA1")+SD1->D1_FORNECE+SD1->D1_LOJA)
						Else
							dbSelectArea("SA2")
							dbSetOrder(1)
							DbSeek(xFilial("SA2")+SD1->D1_FORNECE+SD1->D1_LOJA)
						EndIf
						
						aadd(aNfVinc,{SD1->D1_EMISSAO,SD1->D1_SERIE,SD1->D1_DOC,IIF(SD1->D1_TIPO $ "DB",IIF(SD1->D1_FORMUL=="S",SM0->M0_CGC,SA1->A1_CGC),IIF(SD1->D1_FORMUL=="S",SM0->M0_CGC,SA2->A2_CGC)),SM0->M0_ESTCOB,SF1->F1_ESPECIE})
					EndIf
				Else
					aOldReg  := SD2->(GetArea())
					aOldReg2 := SF2->(GetArea())
					dbSelectArea("SD2")
					dbSetOrder(3)
					If DbSeek(xFilial("SD2")+(cAliasSD2)->D2_NFORI+(cAliasSD2)->D2_SERIORI+(cAliasSD2)->D2_CLIENTE+(cAliasSD2)->D2_LOJA+(cAliasSD2)->D2_COD+(cAliasSD2)->D2_ITEMORI)
						dbSelectArea("SF2")
						dbSetOrder(1)
						DbSeek(xFilial("SF2")+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA)
						If !SD2->D2_TIPO $ "DB"
							dbSelectArea("SA1")
							dbSetOrder(1)
							DbSeek(xFilial("SA1")+SD2->D2_CLIENTE+SD2->D2_LOJA)
						Else
							dbSelectArea("SA2")
							dbSetOrder(1)
							DbSeek(xFilial("SA2")+SD2->D2_CLIENTE+SD2->D2_LOJA)
						EndIf
						
						aadd(aNfVinc,{SF2->F2_EMISSAO,SD2->D2_SERIE,SD2->D2_DOC,SM0->M0_CGC,SM0->M0_ESTCOB,SF2->F2_ESPECIE})
					EndIf
					RestArea(aOldReg)
					RestArea(aOldReg2)
				EndIf
			EndIf
			//������������������������������������������������������������������������Ŀ
			//�Obtem os dados do produto                                               �
			//��������������������������������������������������������������������������			
			dbSelectArea("SB1")
			dbSetOrder(1)
			DbSeek(xFilial("SB1")+(cAliasSD2)->D2_COD)
						
			cMensFis:=""
			lPedido:=.F.
			If !Empty((cAliasSD2)->D2_PEDIDO)
				dbSelectArea("SC5")
				dbSetOrder(1)
				DbSeek(xFilial("SC5")+(cAliasSD2)->D2_PEDIDO)
			
				dbSelectArea("SC6")
				dbSetOrder(1)
				DbSeek(xFilial("SC6")+(cAliasSD2)->D2_PEDIDO+(cAliasSD2)->D2_ITEMPV+(cAliasSD2)->D2_COD)
			
				If !AllTrim(SC5->C5_MENNOTA) $ cMensCli
					cMensCli += AllTrim(SC5->C5_MENNOTA)
				EndIf
				If !Empty(SC5->C5_MENPAD) .And. !AllTrim(FORMULA(SC5->C5_MENPAD)) $ cMensFis
					cMensFis += AllTrim(FORMULA(SC5->C5_MENPAD))
				EndIf
				lPedido:=.T.
			EndIf     
			 
			
			If lPedido
					aadd(aPed,SC5->C5_TPVENT)
			
			Else
					aadd(aPed,SF2->F2_TPVENT)
			EndiF 

			aadd(aPed,SF2->F2_ESPECIE) 		
			aadd(aPed,AllTrim(SA1->A1_CGC)) 
			aadd(aPed,AllTrim(SA1->A1_PAIS))
			aadd(aPed,MyGetEnd(SA1->A1_ENDENT,"SA2")[1])
			aadd(aPed,cMensFis)                         
			
			If lPedido            
				aadd(aPed,Alltrim(SC5->C5_INCOTER))  
				aadd(aPed,SC5->C5_PERMISSO)
				aadd(aPed,Iif(SYA->(Dbseek(xFilial("SYA")+ SC5->C5_PAISENT)),SYA->YA_SISEXP, SC5->C5_PAISENT) )
			Else
				aadd(aPed,Alltrim(SF2->F2_INCOTER))	 
				aadd(aPed,SF2->F2_PERMISSO)     
				aadd(aPed,Iif(SYA->(Dbseek(xFilial("SYA")+ SF2->F2_PAISENT)),SYA->YA_SISEXP, SF2->F2_PAISENT) )
            EndIf
            
         				
				cMoeda:='GetMV("MV_SIMB'+Alltrim(str(SF2->F2_MOEDA))+'")'
				If(SYF->(Dbseek(xFilial("SYF")+&cMoeda)) )
					aadd(aPed,SYF->YF_COD_GI)      
				Else
					aadd(aPed,"01")   
				EndIf                      
				
				If lPedido            
					aadd(aPed,SC5->C5_IDIOMA)
				 	aadd(aPed,Iif(SE4->(Dbseek(xFilial("SE4")+SC5->C5_CONDPAG)),SE4->E4_FMPAGEX,"")) 
				Else
					aadd(aPed,SF2->F2_IDIOMA)
					aadd(aPed,Iif(SE4->(Dbseek(xFilial("SE4")+SF2->F2_COND)),SE4->E4_FMPAGEX,"")    )  
				EndIf	
				aadd(aPed,SF2->F2_VALMERC)   
				
					
			dbSelectArea(cAliasSD2)	
			While !Eof() .And. xFilial("SD2") == (cAliasSD2)->D2_FILIAL .And.;
				SF2->F2_SERIE == (cAliasSD2)->D2_SERIE .And.;
				SF2->F2_DOC == (cAliasSD2)->D2_DOC
						
			//������������������������������������������������������������������������Ŀ
			//�Obtem os dados do produto                                               �
			//��������������������������������������������������������������������������			
				
				dbSelectArea("SAH")
				dbSetOrder(1)
		         If SAH->(DbSeek(xFilial("SAH")+(cAliasSD2)->D2_UM)   )
		        	 cCodUM:=AH_CODUMFE
				Else  
					cCodUM	:=	"98"   
				EndIf				
				
				dbSelectArea("SB1")
				dbSetOrder(1)
				DbSeek(xFilial("SB1")+(cAliasSD2)->D2_COD) 				
				
		 		aadd(aProd,	{Len(aProd)+1,;
							(cAliasSD2)->D2_COD,;
							SB1->B1_DESC,;
							(cAliasSD2)->D2_QUANT,;
							cCodUM,;
							(cAliasSD2)->D2_PRCVEN,;
							(cAliasSD2)->D2_TOTAL,;							
							Substr(SB1->B1_CODBAR,1,13),;
							(cAliasSD2)->D2_DESCON})							
							
				For nX:=1 to Len(aColIB)
					If &(cAliasSD2+"->D2_BASIMP"+aColIB[nX][1])>0
						If Len(aColIB[nX][2])>0
							nY:=AScan( aColIB[nX][2], { |y| y[1] == &(cAliasSD2+"->D2_ALQIMP"+aColIB[nX][1])} )
							If  nY==0			 
//								AADD(aColIB[nX][2],{&(cAliasSD2+"->D2_ALQIMP"+aColIB[nX][1]),&(cAliasSD2+"->D2_VALIMP"+aColIB[nX][1]),&(cAliasSD2+"->D2_BASIMP"+aColIB[nX][1]),&(cAliasSD2+"->D2_DESGR"+aColIB[nX][1])})
								AADD(aColIB[nX][2],{&(cAliasSD2+"->D2_ALQIMP"+aColIB[nX][1]),(&(cAliasSD2+"->D2_BASIMP"+aColIB[nX][1]) * &(cAliasSD2+"->D2_ALQIMP"+aColIB[nX][1]) * 0.01),&(cAliasSD2+"->D2_BASIMP"+aColIB[nX][1]),&(cAliasSD2+"->D2_DESGR"+aColIB[nX][1])})
					   		Else
					    		aColIB[nX][2][nY][2]:=aColIB[nX][2][nY][2] + (&(cAliasSD2+"->D2_BASIMP"+aColIB[nX][1]) * &(cAliasSD2+"->D2_ALQIMP"+aColIB[nX][1]) * 0.01)
					    		aColIB[nX][2][nY][3]:=aColIB[nX][2][nY][3] + &(cAliasSD2+"->D2_BASIMP" +aColIB[nX][1])
					    	EndIf
					    Else
					    	AADD(aColIB[nX][2],{&(cAliasSD2+"->D2_ALQIMP"+aColIB[nX][1]),(&(cAliasSD2+"->D2_BASIMP"+aColIB[nX][1]) * &(cAliasSD2+"->D2_ALQIMP"+aColIB[nX][1]) * 0.01),&(cAliasSD2+"->D2_BASIMP"+aColIB[nX][1]),&(cAliasSD2+"->D2_DESGR"+aColIB[nX][1])})	
				    	EndIf
				    EndIf	
                Next          
                
                For nX:=1 to Len(aColIVA)
                	If &(cAliasSD2+"->D2_BASIMP"+aColIVA[nX][1]) >0
                		If cTipoNf $ "1|3|4"
                			aadd(aProd[Len(aProd)],aColIVA[nX][3]) 
                		EndIF					
						If Len(aColIVA[nX][2])>0
							nY:=AScan( aColIVA[nX][2], { |y| y[1] == &(cAliasSD2+"->D2_ALQIMP"+aColIVA[nX][1])} )

				 			If  nY==0
				 				AADD(aColIVA[nX][2],{&(cAliasSD2+"->D2_ALQIMP"+aColIVA[nX][1]),&((cAliasSD2+"->D2_BASIMP"+aColIVA[nX][1]) * &(cAliasSD2+"->D2_ALQIMP"+aColIVA[nX][1]) * 0.01),&(cAliasSD2+"->D2_BASIMP"+aColIVA[nX][1]),&(cAliasSD2+"->D2_DESGR"+aColIVA[nX][1])})
			   				Else
			   					If cTipoNf $ "1|3|4" 
			   						aadd(aProd[Len(aProd)],(&(cAliasSD2+"->D2_BASIMP"+aColIVA[nX][1]) * &(cAliasSD2+"->D2_ALQIMP"+aColIVA[nX][1]) * 0.01)) 
			    					aadd(aProd[Len(aProd)],&(cAliasSD2+"->D2_ALQIMP"+aColIVA[nX][1])) 
									aadd(aProd[Len(aProd)],&(cAliasSD2+"->D2_BASIMP"+aColIVA[nX][1])) 
									aadd(aProd[Len(aProd)],&(cAliasSD2+"->D2_DESGR"+aColIVA[nX][1])) 
			    				EndIf	
			    				
			    				aColIVA[nX][2][nY][2]:=aColIVA[nX][2][nY][2] + (&(cAliasSD2+"->D2_BASIMP"+aColIVA[nX][1]) * &(cAliasSD2+"->D2_ALQIMP"+aColIVA[nX][1]) * 0.01)
			    				aColIVA[nX][2][nY][3]:=aColIVA[nX][2][nY][3] + &(cAliasSD2+"->D2_BASIMP"+aColIVA[nX][1])
		    					//aColIVA[nX][2][nY][4]:=aColIVA[nX][2][nY][4] + &(cAliasSD1+"->D1_ALQIMP"+aColIVA[nX][1])
			    				aColIVA[nX][2][nY][4]:=aColIVA[nX][2][nY][4] + &(cAliasSD2+"->D2_DESGR"+aColIVA[nX][1])			    					    				
			    			EndIf 
			    	    Else						
		    	    		AADD(aColIVA[nX][2],{&(cAliasSD2+"->D2_ALQIMP"+aColIVA[nX][1]),(&(cAliasSD2+"->D2_BASIMP"+aColIVA[nX][1]) * &(cAliasSD2+"->D2_ALQIMP"+aColIVA[nX][1]) * 0.01),&(cAliasSD2+"->D2_BASIMP"+aColIVA[nX][1]),&(cAliasSD2+"->D2_DESGR"+aColIVA[nX][1])})
		    	    		If cTipoNf $ "1|3|4"
			    				aadd(aProd[Len(aProd)],aColIVA[nX][2][1][2]) 
			    				aadd(aProd[Len(aProd)],aColIVA[nX][2][1][1]) 
			    				aadd(aProd[Len(aProd)],aColIVA[nX][2][1][3]) 
			    				aadd(aProd[Len(aProd)],aColIVA[nX][2][1][4]) 
			    			EndIf		
			    		EndIf
			    	EndIf
			    
                Next
                
                //���������������������������������������������������������������������������������������������Ŀ
				//�Adiciono elementos em branco quando n�o tem IVA, para n�o estourar o array na montagem do XML�
				//�����������������������������������������������������������������������������������������������                
                If Len(aProd[Len(aProd)]) < 10 .and. (cTipoNf $ "1|3|4") 
               		aadd(aProd[Len(aProd)],"2") 
            		aadd(aProd[Len(aProd)],0) 
           			aadd(aProd[Len(aProd)],0) 
       				aadd(aProd[Len(aProd)],0) 
   					aadd(aProd[Len(aProd)],0) 
			    EndIf
			    			    
			    aadd(aProd[Len(aProd)],SB1->B1_POSIPI)
			    	         
                
				dbSelectArea(cAliasSD2)
				dbSkip()
			EndDo	
	    EndDo
	    
	    If lQuery
	    	dbSelectArea(cAliasSD2)
	    	dbCloseArea()
	    	dbSelectArea("SD2")
	    EndIf
	
	EndIf
Else
	dbSelectArea("SF1")
	dbSetOrder(1)
	If DbSeek(xFilial("SF1")+cNota+cSerie+cClieFor+cLoja)
		aadd(aCabNF,SF1->F1_EMISSAO)
		aadd(aCabNF,Subs(SF1->F1_DOC,1,4))
		aadd(aCabNF,Subs(SF1->F1_DOC,5,8))
		aadd(aCabNF,SF1->F1_TXMOEDA)  
		aadd(aCabNF,SF1->F1_VALBRUT) 		
		cTipoCond:=Iif(SE4->(Dbseek(xFilial("SE4")+SF1->F1_COND)),SE4->E4_FMPAGEX,"")  
		If cTipoNF <> "1"
			aadd(aCabNF,cTipoCond)
		EndIf
		
		Impostos()
		nVlIb:=0
		For nIB := 1 To Len(aColIB)
		    If &("SF1->F1_VALIMP"+aColIB[nIB][1]) > 0
				aadd(aIB,{&("SF1->F1_VALIMP"+aColIB[nIB][1]),;                    
								&("SF1->F1_BASIMP"+aColIB[nIB][1]),;              
									aColIB[nIB][2],;                              
									aColIB[nIB][3],;                              
									aColIB[nIB][4],;                              
									})
			EndIf						
			nVlIb:= nVlIb + &("SF1->F1_VALIMP"+aColIB[nIB][1])
		Next				
			
		nVlIv:=0
		For nIV := 1 To Len(aColIVA)
			nVlIv:= nVlIv + &("SF1->F1_VALIMP"+aColIVA[nIV][1])
			If  &("SF1->F1_VALIMP"+aColIVA[nIV][1]) > 0
				aadd(aIVA,{&("SF1->F1_VALIMP"+aColIVA[nIV][1]),;
							&("SF1->F1_BASIMP"+aColIVA[nIV][1]),;
								aColIVA[nIV][2],;
								aColIVA[nIV][3],;
								aColIVA[nIV][4],;
								})
			EndIf					
		Next		
		aadd(aCabNF,nVlIb)  
		aadd(aCabNF,nVlIv)  
		aadd(aCabNF,SF1->F1_FRETE+SF1->F1_DESPESA+SF1->F1_SEGURO)  
		aadd(aCabNF,SF1->F1_SERIE)
		aadd(aCabNF,SF1->F1_ESPECIE)
		aadd(aCabNF,SF1->F1_VALMERC)  
		aadd(aCabNF,SF1->F1_DESCONT) 
		
		_cSerie		:= SF1->F1_SERIE 
		
		//������������������������������������������������������������������������Ŀ
		//�Posiciona cliente ou fornecedor                                         �
		//��������������������������������������������������������������������������	
		
			If SF1->F1_TIPO $ "DB"  .Or. Alltrim(SF1->F1_ESPECIE)=="NCI"
			    If Alltrim(SF1->F1_ESPECIE)=="NCI"
				    dbSelectArea("SA2")
					dbSetOrder(1)
					DbSeek(xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA)
					aadd(aDest,AllTrim(SA2->A2_PAIS))
					aadd(aDest,SA2->A2_NOME)
					aadd(aDest,AllTrim(SA2->A2_CGC))
					aadd(aDest,MyGetEnd(SA2->A2_END,"SA1")[1])
					
			   Else		
					dbSelectArea("SA1")
					dbSetOrder(1)
					DbSeek(xFilial("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA)
					aadd(aDest,AllTrim(SA1->A1_PAIS))
					aadd(aDest,SA1->A1_NOME)
					
					if !empty(SA1->A1_AFIP) //si tiene codigo de documento, tomar ese, sino 80 por default
						DocTipo := Tabela("OC",Alltrim(SA1->A1_AFIP), .F. ) // 80 = CUIT 
		        		DocTipo := Left(DocTipo,Max(At('|',DocTipo),1)-1)
		    		else
		    			DocTipo := "80"
		    		endif
		    		
		    		if DocTipo $ "80|86" //si es 80, tomar el CUIT, sino, tomar el DI
						aadd(aDest,AllTrim(SA1->A1_CGC))
					Else
						aadd(aDest,AllTrim(SA1->A1_RG))				
					EndIf
					
					aadd(aDest,AllTrim(SA1->A1_CGC))
					aadd(aDest,MyGetEnd(SA1->A1_END,"SA1")[1])
				
				EndIf	
			    	
				dbSelectArea("SD1")
				dbSetOrder(1)	
				#IFDEF TOP
					lQuery  := .T.
					cAliasSD1 := GetNextAlias()
					BeginSql Alias cAliasSD1
					SELECT * FROM %Table:SD1% SD1
					WHERE
					SD1.D1_FILIAL = %xFilial:SD1% AND
					SD1.D1_SERIE = %Exp:SF1->F1_SERIE% AND 
					SD1.D1_DOC = %Exp:SF1->F1_DOC% AND 
					SD1.D1_FORNECE = %Exp:SF1->F1_FORNECE% AND 
					SD1.D1_LOJA = %Exp:SF1->F1_LOJA% AND 
					SD1.D1_FORMUL = 'S' AND 
					SD1.%NotDel%
					ORDER BY %Order:SD1%
				EndSql
					
			#ELSE
				DbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
			#ENDIF
			While !Eof() .And. xFilial("SD1") == (cAliasSD1)->D1_FILIAL .And.;
				SF1->F1_SERIE == (cAliasSD1)->D1_SERIE .And.;
				SF1->F1_DOC == (cAliasSD1)->D1_DOC .And.;
				SF1->F1_FORNECE == (cAliasSD1)->D1_FORNECE .And.;
				SF1->F1_LOJA ==  (cAliasSD1)->D1_LOJA				
	
				//������������������������������������������������������������������������Ŀ
				//�Verifica as notas vinculadas                                            �
				//��������������������������������������������������������������������������			
				If !Empty((cAliasSD1)->D1_NFORI) 
					If !(cAliasSD1)->D1_TIPO $ "DBN"
						aOldReg  := SD1->(GetArea())
						aOldReg2 := SF1->(GetArea())
						dbSelectArea("SD1")
						dbSetOrder(1)
						If DbSeek(xFilial("SD1")+(cAliasSD1)->D1_NFORI+(cAliasSD1)->D1_SERIORI+(cAliasSD1)->D1_FORNECE+(cAliasSD1)->D1_LOJA+(cAliasSD1)->D1_COD+(cAliasSD1)->D1_ITEMORI)
							dbSelectArea("SF1")
							dbSetOrder(1)
							DbSeek(xFilial("SF1")+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_TIPO)
							If SD1->D1_TIPO $ "DB"
								dbSelectArea("SA1")
								dbSetOrder(1)
								DbSeek(xFilial("SA1")+SD1->D1_FORNECE+SD1->D1_LOJA)
							Else
								dbSelectArea("SA2")
								dbSetOrder(1)
								DbSeek(xFilial("SA2")+SD1->D1_FORNECE+SD1->D1_LOJA)
							EndIf
							
							aadd(aNfVinc,{SD1->D1_EMISSAO,SD1->D1_SERIE,SD1->D1_DOC,IIF(SD1->D1_TIPO $ "DB",IIF(SD1->D1_FORMUL=="S",SM0->M0_CGC,SA1->A1_CGC),IIF(SD1->D1_FORMUL=="S",SM0->M0_CGC,SA2->A2_CGC)),SM0->M0_ESTCOB,SF1->F1_ESPECIE})
						EndIf
						RestArea(aOldReg)
						RestArea(aOldReg2)
					Else					
						dbSelectArea("SD2")
						dbSetOrder(3)
						If DbSeek(xFilial("SD2")+(cAliasSD1)->D1_NFORI+(cAliasSD1)->D1_SERIORI+(cAliasSD1)->D1_FORNECE+(cAliasSD1)->D1_LOJA+(cAliasSD1)->D1_COD+(cAliasSD1)->D1_ITEMORI)
							dbSelectArea("SF2")
							dbSetOrder(1)
							DbSeek(xFilial("SF2")+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA)
							If !SD2->D2_TIPO $ "DB"
								dbSelectArea("SA1")
								dbSetOrder(1)
								DbSeek(xFilial("SA1")+SD2->D2_CLIENTE+SD2->D2_LOJA)    
							Else
								dbSelectArea("SA2")
								dbSetOrder(1)
								DbSeek(xFilial("SA2")+SD2->D2_CLIENTE+SD2->D2_LOJA)
							EndIf							
							aadd(aNfVinc,{SD2->D2_EMISSAO,SD2->D2_SERIE,SD2->D2_DOC,SM0->M0_CGC,SM0->M0_ESTCOB,SF2->F2_ESPECIE})							
						EndIf
					EndIf				
				EndIf			 				

				aadd(aPed,SF1->F1_TPVENT) 								
				aadd(aPed,SF1->F1_ESPECIE)					 			
				aadd(aPed,AllTrim(SA1->A1_CGC))                
				aadd(aPed,AllTrim(SA1->A1_PAIS))               
				aadd(aPed,MyGetEnd(SA1->A1_ENDENT,"SA2")[1])   
				aadd(aPed,cMensFis)                            
			

				aadd(aPed,SF1->F1_INCOTER)	 
				aadd(aPed,SF1->F1_PERMISSO)     
				aadd(aPed,Iif(SYA->(Dbseek(xFilial("SYA")+ SF1->F1_PAISENT)),SYA->YA_SISEXP,SF1->F1_PAISENT) )

				cMoeda:='GetMV("MV_SIMB'+Alltrim(str(SF1->F1_MOEDA))+'")'
				If(SYF->(Dbseek(xFilial("SYF")+&cMoeda)) )
					aadd(aPed,SYF->YF_COD_GI)       
				Else
					aadd(aPed,"01")                 
				EndIf
				aadd(aPed,SF1->F1_IDIOMA)
				aadd(aPed,Iif(SE4->(Dbseek(xFilial("SE4")+SF1->F1_COND)),SE4->E4_FMPAGEX,"")    )  
				aadd(aPed,SF1->F1_VALMERC)   
				
				//������������������������������������������������������������������������Ŀ
				//�Obtem os dados do produto                                               �
				//��������������������������������������������������������������������������			
				dbSelectArea("SAH")
				dbSetOrder(1)
		        If SAH->(DbSeek(xFilial("SAH")+(cAliasSD1)->D1_UM) )
		        	 cCodUM:=AH_CODUMFEX
				Else  				
					cCodUM	:=	"98"    
				EndIf
		
				dbSelectArea("SB1")
				dbSetOrder(1)
				DbSeek(xFilial("SB1")+(cAliasSD1)->D1_COD)
							
				aadd(aProd,	{Len(aProd)+1,;
							(cAliasSD1)->D1_COD,;
							SB1->B1_DESC,;
							(cAliasSD1)->D1_QUANT,;
							 cCodUM,;
							(cAliasSD1)->D1_VUNIT,;
							(cAliasSD1)->D1_TOTAL,;							
							Substr(SB1->B1_CODBAR,1,13),;
							((cAliasSD1)->D1_TOTAL*((cAliasSD1)->D1_DESC/100))})
					
				For nX:=1 to Len(aColIB)
					If &(cAliasSD1+"->D1_BASIMP"+aColIB[nX][1])>0
						If Len(aColIB[nX][2])>0
							nY:=AScan( aColIB[nX][2], { |y| y[1] == &(cAliasSD1+"->D1_ALQIMP"+aColIB[nX][1])} )
							If  nY==0			 
								AADD(aColIB[nX][2],{&(cAliasSD1+"->D1_ALQIMP"+aColIB[nX][1]),(&(cAliasSD1+"->D1_BASIMP"+aColIB[nX][1]) * &(cAliasSD1+"->D1_ALQIMP"+aColIB[nX][1]) * 0.01),&(cAliasSD1+"->D1_BASIMP"+aColIB[nX][1]),&(cAliasSD1+"->D1_DESGR"+aColIB[nX][1])})
					   		Else
					    		aColIB[nX][2][nY][2]:=aColIB[nX][2][nY][2] + (&(cAliasSD1+"->D1_BASIMP"+aColIB[nX][1]) * &(cAliasSD1+"->D1_ALQIMP"+aColIB[nX][1]) * 0.01)
					    		aColIB[nX][2][nY][3]:=aColIB[nX][2][nY][3] + &(cAliasSD1+"->D1_BASIMP" +aColIB[nX][1])
					    	EndIf
					    Else
					    	AADD(aColIB[nX][2],{&(cAliasSD1+"->D1_ALQIMP"+aColIB[nX][1]),(&(cAliasSD1+"->D1_BASIMP"+aColIB[nX][1]) * &(cAliasSD1+"->D1_ALQIMP"+aColIB[nX][1]) * 0.01),&(cAliasSD1+"->D1_BASIMP"+aColIB[nX][1]),&(cAliasSD1+"->D1_DESGR"+aColIB[nX][1])})	
				    	EndIf
				    EndIf	
                Next          
                
                For nX:=1 to Len(aColIVA)
                	If &(cAliasSD1+"->D1_BASIMP"+aColIVA[nX][1]) >0
                		If cTipoNf $ "1|3|4"
                			aadd(aProd[Len(aProd)],aColIVA[nX][3]) 
                		EndIF					
						If Len(aColIVA[nX][2])>0
							nY:=AScan( aColIVA[nX][2], { |y| y[1] == &(cAliasSD1+"->D1_ALQIMP"+aColIVA[nX][1])} )

				 			If  nY==0
				 				AADD(aColIVA[nX][2],{&(cAliasSD1+"->D1_ALQIMP"+aColIVA[nX][1]),&(cAliasSD1+"->D1_VALIMP"+aColIVA[nX][1]),&(cAliasSD1+"->D1_BASIMP"+aColIVA[nX][1]),&(cAliasSD1+"->D1_DESGR"+aColIVA[nX][1])})
			   				 Else
			   				 	If cTipoNf $ "1|3|4"
			    					aadd(aProd[Len(aProd)],(&(cAliasSD1+"->D1_BASIMP"+aColIVA[nX][1]) * &(cAliasSD1+"->D1_ALQIMP"+aColIVA[nX][1]) * 0.01)) 
			    					aadd(aProd[Len(aProd)],&(cAliasSD1+"->D1_ALQIMP"+aColIVA[nX][1])) 
									aadd(aProd[Len(aProd)],&(cAliasSD1+"->D1_BASIMP"+aColIVA[nX][1])) 
									aadd(aProd[Len(aProd)],&(cAliasSD1+"->D1_DESGR"+aColIVA[nX][1])) 
			    				EndIf
			    				aColIVA[nX][2][nY][2]:=aColIVA[nX][2][nY][2] + (&(cAliasSD1+"->D1_BASIMP"+aColIVA[nX][1]) * &(cAliasSD1+"->D1_ALQIMP"+aColIVA[nX][1]) * 0.01)
			    				aColIVA[nX][2][nY][3]:=aColIVA[nX][2][nY][3] + &(cAliasSD1+"->D1_BASIMP"+aColIVA[nX][1])
			    				//aColIVA[nX][2][nY][4]:=aColIVA[nX][2][nY][4] + &(cAliasSD1+"->D1_ALQIMP"+aColIVA[nX][1])
			    				aColIVA[nX][2][nY][4]:=aColIVA[nX][2][nY][4] + &(cAliasSD1+"->D1_DESGR"+aColIVA[nX][1])
			    				
			    			EndIf 
			    	    Else			    	    						
		    	    		AADD(aColIVA[nX][2],{&(cAliasSD1+"->D1_ALQIMP"+aColIVA[nX][1]),(&(cAliasSD1+"->D1_BASIMP"+aColIVA[nX][1]) * &(cAliasSD1+"->D1_ALQIMP"+aColIVA[nX][1]) * 0.01),&(cAliasSD1+"->D1_BASIMP"+aColIVA[nX][1]),&(cAliasSD1+"->D1_DESGR"+aColIVA[nX][1])})
		    	       		If cTipoNf $ "1|3|4"
			    				aadd(aProd[Len(aProd)],aColIVA[nX][2][1][2]) 
			    				aadd(aProd[Len(aProd)],aColIVA[nX][2][1][1]) 
			    				aadd(aProd[Len(aProd)],aColIVA[nX][2][1][3]) 
			    				aadd(aProd[Len(aProd)],aColIVA[nX][2][1][4]) 
			    			EndIf		
			    	   	Endif	
			    	EndIf	
                Next          

				//���������������������������������������������������������������������������������������������Ŀ
				//�Adiciono elementos em branco quando n�o tem IVA, para n�o estourar o array na montagem do XML�
				//�����������������������������������������������������������������������������������������������
				
				If Len(aProd[Len(aProd)]) < 10 .and. (cTipoNf $ "1|3|4") 
               		aadd(aProd[Len(aProd)],"2") 
            		aadd(aProd[Len(aProd)],0) 
           			aadd(aProd[Len(aProd)],0) 
       				aadd(aProd[Len(aProd)],0) 
   					aadd(aProd[Len(aProd)],0) 
			    EndIf
	    	    
	    	    aadd(aProd[Len(aProd)],SB1->B1_POSIPI)
					
				dbSelectArea(cAliasSD1)
				dbSkip()
			EndDo
		    If lQuery
		    	dbSelectArea(cAliasSD1)
		    	dbCloseArea()
		    	dbSelectArea("SD1")
		    EndIf
		EndIf
	EndIf
EndIf

If !Empty(aCabNF)
	If cTipoNF == "1" //nacional
		cString += NFSECabN(aCabNf,aDest,aPed,aProd,aNfVinc,cUltId)	                                                          
	ElseIf cTipoNF == "2"  //exportacao
		cString += NfseCab(aCabNf,aDest,aPed,aProd,aNfVinc,cUltId)
	Elseif cTipoNF == "3"  // reg. nominac
		cString += NfseCabR(aCabNf,aDest,aPed,aProd,aNfVinc,cUltId,cTipo)
	Else //bono
		cString += NfseCabB(aCabNf,aDest,aPed,aProd,aNfVinc,cUltId,cTipo)	
	EndIf	
		
EndIf
//Controles aplicados antes de realizar el retorno del XML
cAvisos	:= "Controles de NF-e"
lxRet	:=	.F.
cxAmpos	:= ""

	If Empty(aDest[3]) // Verifica que este cargado el DNI/CUIT/CUIL segun tipo de cliente
		IF DocTipo $ "80|86"
			MSGINFO("No se realizara la transmisi�n debido a que el campo CUIT/CUIL esta incompleto" + chr(10) + chr(13) +;
					"Numero de documento:"+cSerie+"/"+cNota + chr(10) + chr(13) +;
					"Cliente:"+Alltrim(Posicione("SA1",1,xfilial("SA1")+cClieFor+cLoja,"A1_NOME")) + chr(10) + chr(13) +;
					"Campos involucrados: (A1_CGC) maestro de clientes",cAvisos)
		Else
			MSGINFO("No se realizara la transmisi�n debido a que el campo DNI esta incompleto" + chr(10) + chr(13) +;
					"Numero de documento:"+cSerie+"/"+cNota + chr(10) + chr(13) +;
					"Cliente:"+Alltrim(Posicione("SA1",1,xfilial("SA1")+cClieFor+cLoja,"A1_NOME")) + chr(10) + chr(13) +;
					"Campos involucrados: (A1_RG) maestro de clientes",cAvisos)
		EndIF
		Return(Nil)
	EndIF
	IF Alltrim(aPed[1])$"S|A|2|4" 
		If cTipo == "1" 
			dbSelectArea("SF2")
			dbSetOrder(1)
			DbSeek(xFilial("SF2")+cNota+cSerie+cClieFor+cLoja)
			If	Empty(SF2->F2_FECDSE) .OR. Empty(SF2->F2_FECHSE)
				lxRet:=	.T.
				cxAmpos:= "(F2_FECDSE/F2_FECHSE) encabezado doc. de salida"
			EndIF
		Else
			dbSelectArea("SF1")
			dbSetOrder(1)
			DbSeek(xFilial("SF1")+cNota+cSerie+cClieFor+cLoja)
			If	Empty(SF1->F1_FECDSE) .OR. Empty(SF1->F1_FECHSE)
				lxRet:=	.T.
				cxAmpos:= "(F1_FECDSE/F1_FECHSE) encabezado doc. de entrada"
			EndIF
		EndIf
		If lxRet
			MSGINFO("No se realizara la transmisi�n debido a que el campo Tipo de venta " + chr(10) + chr(13) +; 
					"fue declarado como un servicio y no estan completado el periodo de servicio"+ chr(10) + chr(13) +;
					"Numero de documento:"+cSerie+"/"+cNota + chr(10) + chr(13) +;
					"Cliente:"+Alltrim(Posicione("SA1",1,xfilial("SA1")+cClieFor+cLoja,"A1_NOME")) + chr(10) + chr(13) +;
					"Campos involucrados: " + cxAmpos,cAvisos)
			Return(Nil)
		EndIF
	ElseIf Empty(Alltrim(aPed[1]))
		If cTipo == "1" 
			If lPedido
				lxRet:=	.T.
				cxAmpos:= "(C5_TPVENT) encabezado doc. de salida"
			Else
				lxRet:=	.T.
				cxAmpos:= "(F2_TPVENT) encabezado doc. de salida"
			EndIF
		Else
			dbSelectArea("SF1")
			dbSetOrder(1)
			DbSeek(xFilial("SF1")+cNota+cSerie+cClieFor+cLoja)
			If	Empty(SF1->F1_TPVENT)
				lxRet:=	.T.
				cxAmpos:= "(F1_TPVENT) encabezado doc. de entrada"
			EndIF
		EndIf
		If lxRet
			MSGINFO("No se realizara la transmisi�n debido a que el campo Tipo de venta " + chr(10) + chr(13) +; 
					"no esta completado en el documento"+ chr(10) + chr(13) +;
					IIf(lPedido, "Numero de Pedido:"+SC5->C5_NUM, "Numero de documento:"+cSerie+"/"+cNota) + chr(10) + chr(13) +;
					"Cliente:"+Alltrim(Posicione("SA1",1,xfilial("SA1")+cClieFor+cLoja,"A1_NOME")) + chr(10) + chr(13) +;
					"Campos involucrados: " + cxAmpos,cAvisos)
					Return(Nil)
		EndIF
	EndIF
	If cTipoNF == "2"  // Si es factura electronica de exportaci�n
		If Empty(aPed[11])
			If cTipo == "1" 
				If lPedido
					lxRet:=	.T.
					cxAmpos:= "(C5_IDIOMA) encabezado doc. de salida"
				Else
					lxRet:=	.T.
					cxAmpos:= "(F2_IDIOMA) encabezado doc. de salida"
				EndIF
			Else
				dbSelectArea("SF1")
				dbSetOrder(1)
				DbSeek(xFilial("SF1")+cNota+cSerie+cClieFor+cLoja)
				If	Empty(SF1->F1_TPVENT)
					lxRet:=	.T.
					cxAmpos:= "(F1_IDIOMA) encabezado doc. de entrada"
				EndIF
			EndIf
			If lxRet
				MSGINFO("No se realizara la transmisi�n debido a que el campo Idioma " + chr(10) + chr(13) +; 
						"no esta completado en el documento"+ chr(10) + chr(13) +;
						IIf(lPedido, "Numero de Pedido:"+SC5->C5_NUM, "Numero de documento:"+cSerie+"/"+cNota) + chr(10) + chr(13) +;
						"Cliente:"+Alltrim(Posicione("SA1",1,xfilial("SA1")+cClieFor+cLoja,"A1_NOME")) + chr(10) + chr(13) +;
						"Campos involucrados: " + cxAmpos,cAvisos)
						Return(Nil)
			EndIF
		EndIF
		If Empty(aPed[7])
			If cTipo == "1" 
				If lPedido
					lxRet:=	.T.
					cxAmpos:= "(C5_INCOTER) encabezado doc. de salida"
				Else
					lxRet:=	.T.
					cxAmpos:= "(F2_INCOTER) encabezado doc. de salida"
				EndIF
			Else
				dbSelectArea("SF1")
				dbSetOrder(1)
				DbSeek(xFilial("SF1")+cNota+cSerie+cClieFor+cLoja)
				If	Empty(SF1->F1_TPVENT)
					lxRet:=	.T.
					cxAmpos:= "(F1_INCOTER) encabezado doc. de entrada"
				EndIF
			EndIf
			If lxRet
				MSGINFO("No se realizara la transmisi�n debido a que el campo Incoterms " + chr(10) + chr(13) +; 
						"no esta completado en el documento"+ chr(10) + chr(13) +;
						IIf(lPedido, "Numero de Pedido:"+SC5->C5_NUM, "Numero de documento:"+cSerie+"/"+cNota) + chr(10) + chr(13) +;
						"Cliente:"+Alltrim(Posicione("SA1",1,xfilial("SA1")+cClieFor+cLoja,"A1_NOME")) + chr(10) + chr(13) +;
						"Campos involucrados: " + cxAmpos,cAvisos)
						Return(Nil)
			EndIF
		EndIF
		If Empty(aPed[9])
			If cTipo == "1" 
				If lPedido
					lxRet:=	.T.
					cxAmpos:= "(C5_PAISENT) encabezado doc. de salida"
				Else
					lxRet:=	.T.
					cxAmpos:= "(F2_PAISENT) encabezado doc. de salida"
				EndIF
			Else
				dbSelectArea("SF1")
				dbSetOrder(1)
				DbSeek(xFilial("SF1")+cNota+cSerie+cClieFor+cLoja)
				If	Empty(SF1->F1_TPVENT)
					lxRet:=	.T.
					cxAmpos:= "(F1_PAISENT) encabezado doc. de entrada"
				EndIF
			EndIf
			If lxRet
				MSGINFO("No se realizara la transmisi�n debido a que el campo Pais de entrega " + chr(10) + chr(13) +; 
						"no esta completado en el documento"+ chr(10) + chr(13) +;
						IIf(lPedido, "Numero de Pedido:"+SC5->C5_NUM, "Numero de documento:"+cSerie+"/"+cNota) + chr(10) + chr(13) +;
						"Cliente:"+Alltrim(Posicione("SA1",1,xfilial("SA1")+cClieFor+cLoja,"A1_NOME")) + chr(10) + chr(13) +;
						"Campos involucrados: " + cxAmpos,cAvisos)
						Return(Nil)
			EndIF
		EndIF
	EndIF
Return(cString)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NfseCabR �Autor  �Camila Janu�rio      � Data �  19/07/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Gera string com conte�do XML                               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Nota Fiscal Elet. Argentina - Reg. Nominaci�n     		  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function NfseCabR(aCabNf,aDest,aPed,aProd,aNfVinc,cUltId, cTipo)

Local cString    := ""
Local Nx 		 := 0
Local cTpExp 	 := ""
Local nIb		 := 0
Local nIv		 := 0
Local nIBs		 := 0
local nIVa		 := 0
Local nExento	 := 0
Local nBasIva	 := 0
Local nImpSub 	 := 0
Local cCompVinc  := ""
Local nBasNoGrv	 := 0
Local nImpOTrib  := 0
Local nVlDesgr   := 0 

//�������������������������������������������Ŀ
//�Verifica o tipo de venda (bens serv, ambos)�
//���������������������������������������������
	
If Alltrim(aPed[1]) $ "B|1" 
	cTpExp:="1"  //produtos
ElseIf Alltrim(aPed[1])$"S|2" 
	cTpExp:="2" //servicos
ElseIf Alltrim(aPed[1])$"A|4" //ambos	
	cTpExp:="3"
Else 
	cTpExp:="4"
EndIf

//���������������������������������������������8�
//�Faz a busca do valor exento no livro fiscal �
//���������������������������������������������8�

If Alias()$ ("SD1|SF1")
	nExento:= 0
   	SF3->(DbSetOrder(4))
   	If SF3->(DbSeek(xFilial("SF3")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_DOC+SF1->F1_SERIE))
	 	While SF3->(!EOF()) .And. xFilial("SF3")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_DOC+SF1->F1_SERIE ==;
  			SF3->F3_FILIAL+SF3->F3_CLIEFOR+SF3->F3_LOJA+SF3->F3_NFISCAL+SF3->F3_SERIE
		  	nExento:=nExento + SF3->F3_EXENTAS
			SF3->(dbSkip())
		EndDo	
	EndIf		
Else
	nExento:= 0
   	SF3->(DbSetOrder(4))
   	If SF3->(DbSeek(xFilial("SF3")+SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_DOC+SF2->F2_SERIE))
	 	While SF3->(!EOF()) .And. xFilial("SF3")+SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_DOC+SF2->F2_SERIE ==;
  			SF3->F3_FILIAL+SF3->F3_CLIEFOR+SF3->F3_LOJA+SF3->F3_NFISCAL+SF3->F3_SERIE
		  	nExento:=nExento + SF3->F3_EXENTAS
			SF3->(dbSkip())
		EndDo	
	EndIf	
EndIf	

//��������������������������������������������������Ŀ
//�Converte o valor de exento para a moeda da factura�
//����������������������������������������������������
If aCabNF[4] <> 1
	nExento:=nExento / aCabNF[4]
Endif 

//�������������������������������������������������Ŀ
//�Acumula valores de IVA e de Importe N�o Gravado  �
//���������������������������������������������������
nBasIva:=0
For nIv:=1 to Len(aIVA)
	nBasIva:= nBasIva + aIVA[nIv][2]
	If aIVA[nIv][4] == "1"
		nBasNoGrv += nBasIva
	EndIf
Next

//��������������������������������������Ŀ
//�Acumula valores de IB - Otros Tributos�
//����������������������������������������
nImpOTrib:=0
For nIb:=1 to Len(aIB)
	nImpOTrib +=aIB[nIb][1] 
Next


nVlDesgr := ValDesgr(aIva,aColIVa)

nImpSub := nBasIva+nExento+nBasNoGrv 

cString += '<comprobanteCAERequest>'
cString += '<codigoTipoComprobante>'+CodComp(aCabNf)+'</codigoTipoComprobante>' 
cString += '<numeroPuntoVenta>'+aCabNF[2]+'</numeroPuntoVenta>'
cString += '<numeroComprobante>'+aCabNF[3]+'</numeroComprobante>'
cString += '<fechaEmision>'+alltrim(str(year(aCabNF[1])))+"-"+strzero(month(aCabNF[1]),2)+"-"+alltrim(str(day(aCabNF[1])))+'</fechaEmision>'
cString += '<codigoTipoDocumento>'+DocTipo+'</codigoTipoDocumento>'
cString += '<numeroDocumento>'+aDest[3]+'</numeroDocumento>'
If cTipo == "1" 
	cString += '<importeGravado>'+ConvType(aCabNf[11]-(nVlDesgr+nExento),15,2)+'</importeGravado>' 
Else
	cString += '<importeGravado>'+ConvType(aCabNf[12]-(nVlDesgr+nExento),15,2)+'</importeGravado>' 
EndIf
cString += '<importeNoGravado>'+ConvType(nBasNoGrv,15,2)+'</importeNoGravado>'
cString += '<importeExento>'+ConvType(nExento+nVlDesgr,15,2)+'</importeExento>'
cString += '<importeSubtotal>'+ConvType(nImpSub,15,2)+'</importeSubtotal>'
If Len(aIB) > 0
	cString += '<importeOtrosTributos>'+ConvType(nImpOTrib,15,2)+'</importeOtrosTributos>'  
EndIF	
cString += '<importeTotal>'+ConvType(aCabNF[5],15,2)+'</importeTotal>'
cString += '<codigoMoneda>'+ConvType(aPed[10],3,0)+'</codigoMoneda>'

If Alltrim(aPed[10]) == "PES"
	cString += '<cotizacionMoneda>'+"1"+'</cotizacionMoneda>'	
Else
	cString += '<cotizacionMoneda>'+Alltrim(STR(aCabNF[4]))+'</cotizacionMoneda>'
EndIf	

//������������������������������Ŀ
//�Observacoes de pedido de venda�
//��������������������������������
If !Empty(aPed[6])
	cString += '<observaciones>'+aPed[6]+'</observaciones>'
EndIf   

cString += '<codigoConcepto>'+cTpExp+'</codigoConcepto>'

//���������������������������������������������������������������������������������Ŀ
//�Datas de in�cio e fim do servi�o s�o gerados se a nota for do tipo servi�o/ambos�
//�����������������������������������������������������������������������������������
If Alltrim(aPed[1])$"S|A|2|4" .And. Alias()$ ("SD2|SF2")
	cString += '<fechaServicioDesde>'+alltrim(str(year(SF2->F2_FECDSE)))+"-"+strzero(month(SF2->F2_FECDSE),2)+"-"+alltrim(strzero(day(SF2->F2_FECDSE),2))+'</fechaServicioDesde>' 	
	cString += '<fechaServicioHasta>'+alltrim(str(year(SF2->F2_FECHSE)))+"-"+strzero(month(SF2->F2_FECHSE),2)+"-"+alltrim(strzero(day(SF2->F2_FECHSE),2))+'</fechaServicioHasta>' 
    
	cPrefixo	:= 	Iif (Empty (SF2->F2_PREFIXO), &(SuperGetMV ("MV_1DUPREF")), SF2->F2_PREFIXO)
	SE1->(dbSetOrder(2))
	If Alias()$"SF2|SD2" .And. SE1->(MsSeek(xFilial("SE1")+SF2->F2_CLIENTE+SF2->F2_LOJA+cPrefixo+SF2->F2_DOC)) 
    	cString += '<fechaVencimientoPago>'+alltrim(str(year(SE1->E1_VENCREA)))+"-"+strzero(month(SE1->E1_VENCREA),2)+"-"+alltrim(strzero(day(SE1->E1_VENCREA),2))+'</fechaVencimientoPago>'
	Else
		cString += '<fechaVencimientoPago>'+alltrim(str(year(aCabNF[1])))+"-"+strzero(month(aCabNF[1]),2)+"-"+alltrim(strzero(day(aCabNF[1]),2))+'</fechaVencimientoPago>'
	EndIf
EndIf	
	
//����������������������������������Ŀ        
//�Considera notas de cr�dito/entrada�
//������������������������������������	
If Alltrim(aPed[1])$"S|A|2|4" .And. Alias()$ ("SD1|SF1")
	cString += '<fechaServicioDesde>'+alltrim(str(year(SF1->F1_FECDSE)))+"-"+strzero(month(SF1->F1_FECDSE),2)+"-"+alltrim(strzero(day(SF1->F1_FECDSE),2))+'</fechaServicioDesde>' 
	cString += '<fechaServicioHasta>'+alltrim(str(year(SF1->F1_FECHSE)))+"-"+strzero(month(SF1->F1_FECHSE),2)+"-"+alltrim(strzero(day(SF1->F1_FECHSE),2))+'</fechaServicioHasta>' 
    
	cPrefixo	:= 	Iif (Empty (SF1->F1_PREFIXO), &(SuperGetMV ("MV_2DUPREF")), SF1->F1_PREFIXO)
	SE1->(dbSetOrder(2))
	If Alias()$"SF1|SD1" .And. SE1->(MsSeek(xFilial("SE1")+SF1->F1_FORNECE+SF1->F1_LOJA+cPrefixo+SF1->F1_DOC)) 
    	cString += '<fechaVencimientoPago>'+alltrim(str(year(SE1->E1_VENCREA)))+"-"+strzero(month(SE1->E1_VENCREA),2)+"-"+alltrim(strzero(day(SE1->E1_VENCREA),2))+'</fechaVencimientoPago>'
	Else
		cString += '<fechaVencimientoPago>'+alltrim(str(year(aCabNF[1])))+"-"+strzero(month(aCabNF[1]),2)+"-"+alltrim(strzero(day(aCabNF[1]),2))+'</fechaVencimientoPago>'
	EndIf
EndIf

//�������������������������������������������������������������Ŀ
//�Dados de comprovantes associados (notas de credito e debito) �
//���������������������������������������������������������������                                   
//����������������������Ŀ
//�1 � Factura A         �
//�2 � Nota de D�bito A  �
//�3 � Nota de Cr�dito A �
//�6 � Factura B         �
//�7 � Nota de D�bito B  �
//�8 � Nota de Cr�dito B �
//������������������������  

If (CodComp(aCabNf)) $ "2|3|7|8"	
	If Len(aNfVinc)>0
		cString += '<arrayComprobantesAsociados>'
			For Nx := 1 to Len(aNfVinc)			
				If (SUBS(Alltrim(aNfVinc[Nx][2]),1,1) == "A")
					If(Alltrim(aNfVinc[Nx][6]) == "NF")
						cCompVinc := "1"	
					Else
					    If (Alltrim(aNfVinc[Nx][6]) $ "NDC|NDP|NDE|NDI")
					    	cCompVinc := "2"
					    Else
					        cCompVinc := "3"
					    EndIf    		
					EndIf
				Else
					If(Alltrim(aNfVinc[Nx][6]) == "NF")
						cCompVinc := "6"	
					Else
					    If (Alltrim(aNfVinc[Nx][6]) $ "NDC|NDP|NDE|NDI")
					    	cCompVinc := "7"
					    Else
					        cCompVinc := "8"
					    EndIf    		
					EndIf				
				EndIf				
				cString += '<comprobanteAsociado>'
				cString += '<codigoTipoComprobante>'+cCompVinc+'</codigoTipoComprobante>'
				cString += '<numeroPuntoVenta>'+SUBS(aNfVinc[Nx][3],1,4)+'</numeroPuntoVenta>'
				cString += '<numeroComprobante>'+SUBS(aNfVinc[Nx][3],5,8)+'</numeroComprobante>'
				cString += '</comprobanteAsociado>'		
			Next	
		cString += '</arrayComprobantesAsociados>'
	EndIf
EndIF	
//����������������������������������Ŀ
//�Dados de impostos Ingresos Brutos �
//������������������������������������  
If Len(aIB) > 0
   	lPrim:=.T.
	For nIb:=1 to Len(aColIB)
           If Len(aColIB[nIB][2])>0
			If lPrim
			  	cString += '<arrayOtrosTributos>' 
	  	    EndIf   
	  	    lPrim:=.F.
	  		For nIBs:=1 to Len(aColIB[nIB][2])
		  		cString += '<otroTributo>' 
		 		cString += '<codigo>'+aColIB[nIB][3]+'</codigo>'
		 		If aColIB[nIB][3] <> "99"
		    		cString += '<descripcion>'+ConvType(aColIB[nIB][4],15,2)+'</descripcion>'
		    	EndIf
	    		cString += '<baseImponible>'+ConvType((aColIB[nIB][2][nIBs][3]*(1-(aColIB[nIB][2][nIBs][4]/100))),15,2)+'</baseImponible>' 	
	    		cString += '<importe>'+ConvType(aColIB[nIB][2][nIBs][2],15,2)+'</importe>'
	    		cString += '</otroTributo>' 
	    	Next	
	    EndIf	
	Next 
	If !lPrim	 
	   	cString += '</arrayOtrosTributos>'	
	EndIf
EndIf		

//�����������������Ŀ
//�Itens da factura �
//�������������������
cString += '<arrayItems>'
For Nx := 1 to Len(aProd)
		cString += '<item>'			
			If (Alltrim(aProd[Nx][05]) <> "99" .or. Alltrim(aProd[Nx][05]) <> "97")
				cString += '<unidadesMtx>'+"1"+'</unidadesMtx>'
			   	cString += '<codigoMtx>'+Alltrim(aProd[Nx][08])+'</codigoMtx>' 
			EndIF
			cString += '<codigo>'+Alltrim(aProd[Nx][02])+'</codigo>'
			cString += '<descripcion>'+ConvType(Alltrim(aProd[Nx][03]))+'</descripcion>'
			cString += '<cantidad>'+ConvType(aProd[Nx][04],15,2)+'</cantidad>'		
			cString += '<codigoUnidadMedida>'+Alltrim(aProd[Nx][05])+'</codigoUnidadMedida>'
		   	
		   	If cTipo == "1" //saida
				If substr(_cSerie,1,1) == 'B' 
					cString += '<precioUnitario>'+ConvType((aProd[Nx][07]+aProd[Nx][11])/aProd[Nx][04],15,4)+'</precioUnitario>'	//somo o desconto e vejo se tem desgravacao ** Dante 4 decimales						
				else
					cString += '<precioUnitario>'+ConvType((aProd[Nx][06]+aProd[Nx][09])*(1-(aProd[Nx][14]/100)),15,2)+'</precioUnitario>' 
				Endif	
			Else
				If substr(_cSerie,1,1) == 'B' 
					cString += '<precioUnitario>'+ConvType((aProd[Nx][07]+aProd[Nx][11])/aProd[Nx][04],15,4)+'</precioUnitario>'	//somo o desconto e vejo se tem desgravacao ** Dante 4 decimales						
				else				
					cString += '<precioUnitario>'+ConvType(aProd[Nx][06]*(1-(aProd[Nx][14]/100)),15,2)+'</precioUnitario>' 
				endif	
			EndIf  			
			If (Alltrim(aProd[Nx][05]) <> "99" .or. Alltrim(aProd[Nx][05]) <> "97") 					
				cString += '<importeBonificacion>'+ConvType(aProd[Nx][09],15,2)+'</importeBonificacion>'				
			EndIF			
			cString += '<codigoCondicionIVA>'+aProd[Nx][10]+'</codigoCondicionIVA>'			
			If (Alltrim(aProd[Nx][05]) <> "99" .or. Alltrim(aProd[Nx][05]) <> "97") 
				If substr(_cSerie,1,1) <> 'B' 
					If (aProd[Nx][10] $ "4|5|6")
						cString += '<importeIVA>'+ConvType(aProd[Nx][11],15,2)+'</importeIVA>' //valimp
					Else
						cString += '<importeIVA>'+ConvType(0,15,2)+'</importeIVA>'
					EndIf
				EndIf		
			EndIf				
			If aProd[Nx][13] > 0		
				cString += '<importeItem>'+ConvType((aProd[Nx][13]*(1-(aProd[Nx][14]/100)))+aProd[Nx][11],15,2)+'</importeItem>'	//basimp-desgrav+valimp
			Else
				cString += '<importeItem>'+ConvType(aProd[Nx][6],15,2)+'</importeItem>' //isento de iva
			Endif			
		
		cString += '</item>' 		

		//���������������������������������������������Ĥ[�
		//�Item que representa a desgrava��o de impostos�
		//���������������������������������������������Ĥ[�		
		IF	aProd[Nx][14] > 0
			cString += '<item>'			
				If (Alltrim(aProd[Nx][05]) <> "99" .or. Alltrim(aProd[Nx][05]) <> "97")
					cString += '<unidadesMtx>'+"1"+'</unidadesMtx>'
				   	cString += '<codigoMtx>'+Alltrim(aProd[Nx][08])+'</codigoMtx>' 
				EndIF
				cString += '<codigo>'+Alltrim(aProd[Nx][02])+'</codigo>'
				cString += '<descripcion>'+ConvType(Alltrim(aProd[Nx][03]))+'</descripcion>'
				cString += '<cantidad>'+ConvType(aProd[Nx][04],15,2)+'</cantidad>'		
				cString += '<codigoUnidadMedida>'+Alltrim(aProd[Nx][05])+'</codigoUnidadMedida>'
				
				If cTipo == "1" 
					If substr(_cSerie,1,1) == 'B' 
						cString += '<precioUnitario>'+ConvType((aProd[Nx][07]+aProd[Nx][11])/aProd[Nx][04],15,4)+'</precioUnitario>'	//somo o desconto e vejo se tem desgravacao ** Dante 4 decimales						
					else
						cString += '<precioUnitario>'+ConvType((aProd[Nx][06]+aProd[Nx][09])*(1-(aProd[Nx][14]/100)),15,2)+'</precioUnitario>' 
					Endif	
				Else
					If substr(_cSerie,1,1) == 'B' 
						cString += '<precioUnitario>'+ConvType((aProd[Nx][07]+aProd[Nx][11])/aProd[Nx][04],15,4)+'</precioUnitario>'	//somo o desconto e vejo se tem desgravacao ** Dante 4 decimales						
					else				
						cString += '<precioUnitario>'+ConvType(aProd[Nx][06]*(1-(aProd[Nx][14]/100)),15,2)+'</precioUnitario>' 
					endif	
				EndIf  						
				If (Alltrim(aProd[Nx][05]) <> "99" .or. Alltrim(aProd[Nx][05]) <> "97") 					
					cString += '<importeBonificacion>'+ConvType(aProd[Nx][09],15,2)+'</importeBonificacion>'				
				EndIF
				cString += '<codigoCondicionIVA>'+"2"+'</codigoCondicionIVA>' //exento				
				If (Alltrim(aProd[Nx][05]) <> "99" .or. Alltrim(aProd[Nx][05]) <> "97") 				
					cString += '<importeIVA>'+ConvType(0,15,2)+'</importeIVA>' //valimp				
				EndIf				
				cString += '<importeItem>'+ConvType((aProd[Nx][06]+aProd[Nx][09])*(aProd[Nx][14]/100),15,2)+'</importeItem>'
	   		cString += '</item>'		
		EndIf
					
Next
cString += '</arrayItems>'	

//��������������������� �
//�Dados de imposto IVA�
//��������������������� �
If Len(aColIVA)  >0
	lPrim:=.T.
	For nIv:=1 to Len(aColIVA)		
    	If Len(aColIVA[nIv][2])>0
			If lPrim
				cString += '<arraySubtotalesIVA>'
			EndIf
			lPrim:=.F.
			For nIVa:=1 To Len(aColIVA[nIv][2])
				cString += '<subtotalIVA>'
				cString += '<codigo>'+aColIVA[nIv][3]+'</codigo>'
				cString += '<importe>'+ConvType(aColIVA[nIv][2][nIVa][2],15,2)+'</importe>'      
		 		cString += '</subtotalIVA>'
			Next			
		EndIf	
	Next
	If !lPrim
		cString += '</arraySubtotalesIVA>'
	EndIf
EndIf
cString += '<\comprobanteCAERequest>'

Return cString 
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NfseCab�Autor  �Microsiga           � Data �                ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Nota fiscal eletr. Argentina - Exporta��o                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
    
Static Function NfseCab(aCabNf,aDest,aPed,aProd,aNfVinc,cUltId)
Local cString := ""
Local Nx :=0
Local cTpExp:=""
cString +='<Cmp>'
cString +='<Id>'+cUltId+'</Id>'
cString +='<fecha_cbte>'+alltrim(str(year(aCabNF[1])))+strzero(month(aCabNF[1]),2)+alltrim(str(day(aCabNF[1])))+'</fecha_cbte>'
if alltrim(aPed[2])=='NCC'
	cString += '<Tipo_cbte>21</Tipo_cbte>'
elseif alltrim(aPed[2])=='NDC'
	cString += '<Tipo_cbte>20</Tipo_cbte>'
elseif (alltrim(aPed[2])<>'NCC' .and. alltrim(aPed[2])<>'NDC')
	cString += '<Tipo_cbte>19</Tipo_cbte>'
endif
cString += '<Punto_vta>'+Alltrim(STR(Val(aCabNF[2])))+'</Punto_vta>'
cString += '<Cbte_nro>'+aCabNF[3]+'</Cbte_nro>'

if aPed[1]$"1|2|4"
	cTpExp:=aPed[1]
Else
	If Alltrim(aPed[1])$"B|1" 
		cTpExp:="1"
	ElseIf Alltrim(aPed[1])$"S|2" 
		cTpExp:="2"
	Else
		cTpExp:="4"
	EndIf	

EndIf
cString += '<Tipo_expo>'+cTpExp+'</Tipo_expo>'

If (alltrim(aPed[2]) == "NDC" 	.Or. alltrim(aPed[2]) == "NCC") .Or. (alltrim(aPed[2]) == "NF" .And. cTpExp <> "1") 
	cString += '<Permiso_existente></Permiso_existente>'      
Else 
	cString += '<Permiso_existente>'+IiF(alltrim(aPed[2])=="NF" .and. cTpExp=="1",IIF(!Empty(aPed[8]),"S","N"),"")+'</Permiso_existente>'      
	If !Empty(aPed[8]) .and. cTpExp=="1"       
		cString += '<Permisos>'        
		cString += '<Permiso>'
			cString += '<Id_permiso>'+IIF(cTpExp=="1",aPed[8],"")+'</Id_permiso>'  
			cString += '<Dst_merc>'+IIF(cTpExp=="1",aPed[9],"")+'</Dst_merc>'    
		cString += '</Permiso>'      
		cString += '</Permisos> '    		
	EndIf	
Endif		
cString += '<Dst_cmp>'+aPed[9]+'</Dst_cmp>'
cString += '<Cliente>'+ConvType(aDest[2])+'</Cliente>'
cString += '<Cuit_pais_cliente>'+aDest[3]+'</Cuit_pais_cliente>'
cString += '<Domicilio_cliente>'+aDest[4]+'</Domicilio_cliente>'
cString += '<Moneda_Id>'+ConvType(aPed[10],3,0)+'</Moneda_Id>'
cString += '<Moneda_ctz>'+ConvType(aCabNF[4],10,6)+'</Moneda_ctz>'
If !Empty(aPed[6])
	cString += '<Obs_comerciales>'+aPed[6]+'</Obs_comerciales>'
EndIf
cString += '<Imp_total>'+ConvType(aCabNF[5],15,2)+'</Imp_total>'
cString += '<Forma_pago>'+aPed[12]+'</Forma_pago>'
cString += '<Incoterms>'+Alltrim(aPed[7])+'</Incoterms>'
cString += '<Idioma_cbte>'+aPed[11]+'</Idioma_cbte>'

cString += '<Items>'

For Nx := 1 to Len(aProd)
	cString+= '<Item>'   
   cString += '<Pro_codigo>'+aProd[Nx][02]+'</Pro_codigo>'	
	cString += '<Pro_ds>'+ConvType(aProd[Nx][03])+'</Pro_ds>'
	cString += '<Pro_qty>'+ConvType(aProd[Nx][04],12,2)+'</Pro_qty>'
	cString+= '<Pro_umed>'+aProd[Nx][05]+'</Pro_umed>'
	cString += '<Pro_precio_uni>'+ConvType(aProd[Nx][06],12,3)+'</Pro_precio_uni>'
	cString += '<Pro_total_item>'+ConvType(aProd[Nx][07],14,3)+'</Pro_total_item>'
	cString += '</Item>'
Next
cString += '</Items>'
cString +='</Cmp>'

Return(cString)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ConvType �Autor  �Microsiga           � Data �              ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Converte tipos                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ConvType(xValor,nTam,nDec)
Local cNovo := ""
DEFAULT nDec := 0
Do Case
	Case ValType(xValor)=="N"
		If xValor <> 0
			cNovo := AllTrim(Str(xValor,nTam,nDec))
			cNovo := StrTran(cNovo,",",".")
		Else
			cNovo := "0"
		EndIf
	Case ValType(xValor)=="D"
		cNovo := FsDateConv(xValor,"YYYYMMDD")
		cNovo := SubStr(cNovo,1,4)+"-"+SubStr(cNovo,5,2)+"-"+SubStr(cNovo,7)
	Case ValType(xValor)=="C"
		If nTam==Nil
			xValor := AllTrim(xValor)
		EndIf
		DEFAULT nTam := 60
		cNovo := AllTrim(EnCodeUtf8(NoAcento(SubStr(xValor,1,nTam))))
EndCase
Return(cNovo)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NoAcento �Autor  �Microsiga           � Data �              ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Valida acentos                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static FUNCTION NoAcento(cString)
Local cChar  := ""
Local nX     := 0 
Local nY     := 0
Local cVogal := "aeiouAEIOU"
Local cAgudo := "�����"+"�����"
Local cCircu := "�����"+"�����"
Local cTrema := "�����"+"�����"
Local cCrase := "�����"+"�����" 
Local cTio   := "��"
Local cCecid := "��"
Local cEComer:= "&"

For nX:= 1 To Len(cString)
	cChar:=SubStr(cString, nX, 1)
	IF cChar$cAgudo+cCircu+cTrema+cCecid+cTio+cCrase+cEComer
		nY:= At(cChar,cAgudo)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cCircu)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cTrema)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cCrase)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf		
		nY:= At(cChar,cTio)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr("ao",nY,1))
		EndIf		
		nY:= At(cChar,cCecid)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr("cC",nY,1))
		EndIf
	 	nY:= At(cChar,cEComer)
	 	If nY > 0
			cString := StrTran(cString,cChar,SubStr("y",nY,1))
		EndIf
	Endif
Next
For nX:=1 To Len(cString)
	cChar:=SubStr(cString, nX, 1)
	If Asc(cChar) < 32 .Or. Asc(cChar) > 123 
		cString:=StrTran(cString,cChar,".")
	Endif
Next nX
cString := _NoTags(cString)
Return cString

/*����������������������������������������������������������������������������������
������������������������������������������������������������������������������������
��������������������������������������������������������������������������������Ŀ��
���Fun��o    �MyGetEnd  � Autor � Liber De Esteban             � Data � 19/03/09 ���
��������������������������������������������������������������������������������Ĵ��
���Descri��o � Verifica se o participante e do DF, ou se tem um tipo de endereco ���
���          � que nao se enquadra na regra padrao de preenchimento de endereco  ���
���          � por exemplo: Enderecos de Area Rural (essa verific��o e feita     ���
���          � atraves do campo ENDNOT).                                         ���
���          � Caso seja do DF, ou ENDNOT = 'S', somente ira retornar o campo    ���
���          � Endereco (sem numero ou complemento). Caso contrario ira retornar ���
���          � o padrao do FisGetEnd                                             ���
��������������������������������������������������������������������������������Ĵ��
��� Obs.     � Esta funcao so pode ser usada quando ha um posicionamento de      ���
���          � registro, pois ser� verificado o ENDNOT do registro corrente      ���
��������������������������������������������������������������������������������Ĵ��
��� Uso      � SIGAFIS                                                           ���
���������������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������������
����������������������������������������������������������������������������������*/
Static Function MyGetEnd(cEndereco,cAlias)

Local cCmpEndN	:= SubStr(cAlias,2,2)+"_ENDNOT"
Local cCmpEst	:= SubStr(cAlias,2,2)+"_EST"
Local aRet		:= {"",0,"",""}   
Local nIb		:=0
Local nIv		:=0

//Campo ENDNOT indica que endereco participante mao esta no formato <logradouro>, <numero> <complemento>
//Se tiver com 'S' somente o campo de logradouro sera atualizado (numero sera SN)
If (&(cAlias+"->"+cCmpEst) == "DF") .Or. ((cAlias)->(FieldPos(cCmpEndN)) > 0 .And. &(cAlias+"->"+cCmpEndN) == "1")
	aRet[1] := cEndereco
	aRet[3] := "SN"
Else
	aRet := FisGetEnd(cEndereco)
EndIf

Return aRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NfseCabN �Autor  �Microsiga           � Data �              ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Nota fiscal eletr. Argentina - Nacional                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function NfseCabN(aCabNf,aDest,aPed,aProd,aNfVinc,cUltId)
Local cString := ""
Local cTpExp:=""
Local nIb	:=0
Local nIv	:=0
Local nIBs	:=0
local nIVa	:=0
Local nExento:= 0
Local nBasIva:= 0
Local nVlDesgr := 0

If Alltrim(aPed[1])$"B|1"
	cTpExp:="1"  //produtos
ElseIf Alltrim(aPed[1])$"S|2"
	cTpExp:="2" //servicos
ElseIf Alltrim(aPed[1])$"A|4" //ambos	
	cTpExp:="3"
Else 
	cTpExp:="4"
EndIf

	nVlDesgr := ValDesgr(aIva,aColIVa)
	
	cString +='<FECAEDetRequest>'		
	cString += '<Concepto>'+cTpExp+'</Concepto>' 
	cString += '<DocTipo>'+DocTipo+'</DocTipo>'
	cString += '<DocNro>'+aDest[3]+'</DocNro>'
	cString += '<CbteDesde>'+Alltrim(str(Val(aCabNF[3])))+'</CbteDesde>'
	cString += '<CbteHasta>'+Alltrim(str(Val(aCabNF[3])))+'</CbteHasta>
	cString += '<CbteFch>'+alltrim(str(year(aCabNF[1])))+strzero(month(aCabNF[1]),2)+alltrim(strzero(day(aCabNF[1]),2))+'</CbteFch>'
	cString += '<ImpTotal>'+ConvType(aCabNF[5],15,2)+'</ImpTotal>'
	
	If Alias()$ ("SD1|SF1")
		nExento:= 0
	   	SF3->(DbSetOrder(4))
	   	If SF3->(DbSeek(xFilial("SF3")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_DOC+SF1->F1_SERIE))
  		 	While SF3->(!EOF()) .And. xFilial("SF3")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_DOC+SF1->F1_SERIE ==;
 	  			SF3->F3_FILIAL+SF3->F3_CLIEFOR+SF3->F3_LOJA+SF3->F3_NFISCAL+SF3->F3_SERIE
   			  	nExento:=nExento + SF3->F3_EXENTAS
				SF3->(dbSkip())
   			EndDo	
		EndIf
		
	Else
		nExento:= 0
	   	SF3->(DbSetOrder(4))
	   	If SF3->(DbSeek(xFilial("SF3")+SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_DOC+SF2->F2_SERIE))
  		 	While SF3->(!EOF()) .And. xFilial("SF3")+SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_DOC+SF2->F2_SERIE ==;
 	  			SF3->F3_FILIAL+SF3->F3_CLIEFOR+SF3->F3_LOJA+SF3->F3_NFISCAL+SF3->F3_SERIE
   			  	nExento:=nExento + SF3->F3_EXENTAS
				SF3->(dbSkip())
   			EndDo	
		EndIf	
	EndIf	

	If aCabNF[4] <> 1
		nExento:=nExento / aCabNF[4]
	Endif                                                     

	nBasIva:=0
	For nIv:=1 to Len(aIVA)
		nBasIva:= nBasIva + aIVA[nIv][2]
	Next  
		
	cString += '<ImpTotConc>'+ConvType(nExento+nVlDesgr,15,2)+ '</ImpTotConc>'
	If Len(aIVA)  >0
		cString += '<ImpNeto>'+ConvType(nBasIva-nVlDesgr,15,2)+'</ImpNeto> '
	Else
		cString += '<ImpNeto>'+ConvType(0,15,2)+'</ImpNeto> '		
	EndIf      
	If Alias()$ ("SD2|SF2")
		cString += '<ImpOpEx>'+ConvType(SF2->F2_VALMERC-(nBasIva+nExento),15,2)+'</ImpOpEx>' 
    Else
    	if cVersao $ 'P12' .and. upper(GETMV("MV_DESCSAI"))$'S|1'
    	cString += '<ImpOpEx>'+ConvType((SF1->F1_VALMERC)-(nBasIva+nExento),15,2)+'</ImpOpEx>'
    	else
		cString += '<ImpOpEx>'+ConvType((SF1->F1_VALMERC-SF1->F1_DESCONT)-(nBasIva+nExento),15,2)+'</ImpOpEx>'
		endif     
	Endif
	
	cString += '<ImpTrib>'+ConvType(aCabNF[6],15,2)+'</ImpTrib>' 
	cString += '<ImpIVA>'+ConvType(aCabNF[7],15,2)+'</ImpIVA> '
	
	If Alltrim(aPed[1])$"S|A|2|4" .And. Alias()$ ("SD2|SF2")
		cString += '<FchServDesde>'+alltrim(str(year(SF2->F2_FECDSE)))+strzero(month(SF2->F2_FECDSE),2)+alltrim(strzero(day(SF2->F2_FECDSE),2))+'</FchServDesde>' 
		cString += '<FchServHasta>'+alltrim(str(year(SF2->F2_FECHSE)))+strzero(month(SF2->F2_FECHSE),2)+alltrim(strzero(day(SF2->F2_FECHSE),2))+'</FchServHasta>' 
	    
		cPrefixo	:= 	Iif (Empty (SF2->F2_PREFIXO), &(SuperGetMV ("MV_1DUPREF")), SF2->F2_PREFIXO)	//Verifica o Prefixo correto da Nota fiscal
		SE1->(dbSetOrder(2))
		If Alias()$"SF2|SD2" .And. SE1->(MsSeek(xFilial("SE1")+SF2->F2_CLIENTE+SF2->F2_LOJA+cPrefixo+SF2->F2_DOC)) 
	    	cString += '<FchVtoPago>'+alltrim(str(year(SE1->E1_VENCREA)))+strzero(month(SE1->E1_VENCREA),2)+alltrim(strzero(day(SE1->E1_VENCREA),2))+'</FchVtoPago>'
		Else
			cString += '<FchVtoPago>'+alltrim(str(year(aCabNF[1])))+strzero(month(aCabNF[1]),2)+alltrim(strzero(day(aCabNF[1]),2))+'</FchVtoPago>'
		EndIf
	EndIf	
	
	//����������������������������������Ŀ        
	//�Considera notas de cr�dito/entrada�
	//������������������������������������	
	If Alltrim(aPed[1])$"S|A|2|4" .And. Alias()$ ("SD1|SF1")
		cString += '<FchServDesde>'+alltrim(str(year(SF1->F1_FECDSE)))+strzero(month(SF1->F1_FECDSE),2)+alltrim(strzero(day(SF1->F1_FECDSE),2))+'</FchServDesde>' 
		cString += '<FchServHasta>'+alltrim(str(year(SF1->F1_FECHSE)))+strzero(month(SF1->F1_FECHSE),2)+alltrim(strzero(day(SF1->F1_FECHSE),2))+'</FchServHasta>' 
	    
		cPrefixo	:= 	Iif (Empty (SF1->F1_PREFIXO), &(SuperGetMV ("MV_2DUPREF")), SF1->F1_PREFIXO)	//Verifica o Prefixo correto da Nota fiscal
		SE1->(dbSetOrder(2))
		If Alias()$"SF1|SD1" .And. SE1->(MsSeek(xFilial("SE1")+SF1->F1_FORNECE+SF1->F1_LOJA+cPrefixo+SF1->F1_DOC)) 
	    	cString += '<FchVtoPago>'+alltrim(str(year(SE1->E1_VENCREA)))+strzero(month(SE1->E1_VENCREA),2)+alltrim(strzero(day(SE1->E1_VENCREA),2))+'</FchVtoPago>'
		Else
			cString += '<FchVtoPago>'+alltrim(str(year(aCabNF[1])))+strzero(month(aCabNF[1]),2)+alltrim(strzero(day(aCabNF[1]),2))+'</FchVtoPago>'
		EndIf
	EndIf
	
	
	cString += '<MonId>'+ConvType(aPed[10],3,0)+'</MonId>'
	cString += '<MonCotiz>'+ConvType(aCabNF[4],10,6)+'</MonCotiz>'			
	If Len(aIB)  >0
      	lPrim:=.T.
		For nIb:=1 to Len(aColIB)
            If Len(aColIB[nIB][2])>0
				If lPrim
				  	cString += '<Tributos>'
		  	    EndIf   
		  	    lPrim:=.F.
		  		For nIBs:=1 to Len(aColIB[nIB][2])
			  		cString += '<Tributo>'
			 		cString += '<Id>'+aColIB[nIB][3]+'</Id>'
			    	cString += '<Desc>'+ConvType(aColIB[nIB][4],15,2)+'</Desc>'
		    		cString += '<BaseImp>'+ConvType(aColIB[nIB][2][nIBs][3]*(1-(aColIB[nIB][2][nIBs][4]/100)),15,2)+'</BaseImp>'
			    	cString += '<Alic>'   +ConvType(aColIB[nIB][2][nIBs][1],15,2)+'</Alic>'
		    		cString += '<Importe>'+ConvType(aColIB[nIB][2][nIBs][2],15,2)+'</Importe>'
		    		cString += '</Tributo>'
		    	Next	
		    EndIf	
		Next 
		If !lPrim	 
		   	cString += '</Tributos>'
		EndIf
	EndIf
	If Len(aColIVA)  >0
		lPrim:=.T.
		For nIv:=1 to Len(aColIVA) 
             If Len(aColIVA[nIv][2])>0
				If lPrim
					cString += '<Iva>'
				EndIf
				lPrim:=.F.
				For nIVa:=1 To Len(aColIVA[nIv][2])
		   			cString += '<AlicIva>'
					cString += '<Id>'+aColIVA[nIv][3]+'</Id>'
					cString += '<BaseImp>'+ConvType(aColIVA[nIv][2][nIVa][3]*(1-(aColIva[nIv][2][nIVa][4]/100)),15,2)+'</BaseImp>'
					cString += '<Importe>'+ConvType(aColIVA[nIv][2][nIVa][2],15,2)+'</Importe>'      
		 			cString += '</AlicIva>'
				Next		
			
			EndIf	
		Next
		If !lPrim
			cString += '</Iva>'
		EndIf
	EndIf	
cString +='</FECAEDetRequest>


Return(cString)  

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NfseCabB�Autor  �Camila Janu�rio       � Data �  02/05/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Gera string com conte�do XML                               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Nota Fiscal Elet. Argentina - Reg. Bienes de Capital - Bono���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function NfseCabB(aCabNf,aDest,aPed,aProd,aNfVinc,cUltId, cTipo)

Local cString    := ""
Local Nx 		 := 0
Local cTpExp 	 := ""
Local nIb		 := 0
Local nIv		 := 0
Local nIBs		 := 0
local nIVa		 := 0
Local nExento	 := 0
Local nBasIva	 := 0
Local nImpSub 	 := 0
Local cCompVinc  := ""
Local nBasNoGrv	 := 0
Local nImpOTrib  := 0
Local nVlDesgr   := 0
Local aNfeImp 	 := {}

//���������������������������������������������8�
//�Faz a busca do valor exento no livro fiscal �
//���������������������������������������������8�
If Alias()$ ("SD1|SF1")
	nExento:= 0
   	SF3->(DbSetOrder(4))
   	If SF3->(DbSeek(xFilial("SF3")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_DOC+SF1->F1_SERIE))
	 	While SF3->(!EOF()) .And. xFilial("SF3")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_DOC+SF1->F1_SERIE ==;
  			SF3->F3_FILIAL+SF3->F3_CLIEFOR+SF3->F3_LOJA+SF3->F3_NFISCAL+SF3->F3_SERIE
		  	nExento:=nExento + SF3->F3_EXENTAS
			SF3->(dbSkip())
		EndDo	
	EndIf		
Else
	nExento:= 0
   	SF3->(DbSetOrder(4))
   	If SF3->(DbSeek(xFilial("SF3")+SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_DOC+SF2->F2_SERIE))
	 	While SF3->(!EOF()) .And. xFilial("SF3")+SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_DOC+SF2->F2_SERIE ==;
  			SF3->F3_FILIAL+SF3->F3_CLIEFOR+SF3->F3_LOJA+SF3->F3_NFISCAL+SF3->F3_SERIE
		  	nExento:=nExento + SF3->F3_EXENTAS
			SF3->(dbSkip())
		EndDo	
	EndIf	
EndIf	

//��������������������������������������������������Ŀ
//�Converte o valor de exento para a moeda da factura�
//����������������������������������������������������
If aCabNF[4] <> 1
	nExento:=nExento / aCabNF[4]
Endif 

//�������������������������������������������������Ŀ
//�Acumula valores de IVA e de Importe N�o Gravado  �
//���������������������������������������������������
nBasIva:=0
For nIv:=1 to Len(aIVA)
	nBasIva:= nBasIva + aIVA[nIv][2]
	If aIVA[nIv][4] == "1"
		nBasNoGrv += nBasIva
	EndIf
Next

//��������������������������������������Ŀ
//�Acumula valores de IB - Otros Tributos�
//����������������������������������������
nImpOTrib:=0
For nIb:=1 to Len(aIB)
	nImpOTrib +=aIB[nIb][1] //importe
Next

//�����������������������������������Ŀ
//�Busca valores de desgrava��o do IVA�
//�������������������������������������
nVlDesgr := ValDesgr(aIva,aColIVa)

//��������������������������������������������������������������������H�
//�Busca valores de impostos: Nacionais, Internos, Municipais, 		   �
//�Ganancias, IIB e IVA 
// Retorno:	aRet(nImpLiq,nImpLiqRNI,nImpPerc,nImpIIBB,nImpMun,nImpInt) �
//��������������������������������������������������������������������H�
aNfeImp := NfeTotImp(cTipo)

//�����������������������������(�
//�Cabe�alho e dados da factura�
//�����������������������������(�
cString += '<Cmp>'
cString += '<Id>'+Str(nLastID+1)+'</Id>'
cString += '<Tipo_doc>'+DocTipo+'</Tipo_doc>'
cString += '<Nro_doc>'+aDest[3]+'</Nro_doc>'
cString += '<Zona>'+"1"+'</Zona>'
cString += '<Tipo_cbte>'+RetTpCbte(aCabNF)+'</Tipo_cbte>'
cString += '<Punto_vta>'+aCabNF[2]+'</Punto_vta>'
cString += '<Cbte_nro>'+aCabNF[3]+'</Cbte_nro>'
cString += '<Imp_total>'+ConvType(aCabNF[5],15,2)+'</Imp_total>' 
cString += '<Imp_tot_conc>'+ConvType(nExento+nVlDesgr,15,2)+'</Imp_tot_conc>'  
If Len(aIVA)  >0 
	cString += '<Imp_neto>'+ConvType(nBasIva-nVlDesgr,15,2)+'</Imp_neto>' 
Else
	cString += '<Imp_neto>'+ConvType(0,15,2)+'</Imp_neto>' 
Endif
cString += '<Impto_liq>'+ConvType(aNfeImp[1],15,2)+'</Impto_liq>' 
cString += '<Impto_liq_rni>'+ConvType(aNfeImp[2],15,2)+'</Impto_liq_rni>' 
cString += '<Imp_op_ex>'+ConvType(nExento+nVlDesgr,15,2)+'</Imp_op_ex>' 
cString += '<Imp_perc>'+ConvType(aNfeImp[3],15,2)+'</Imp_perc>' 
cString += '<Imp_iibb>'+ConvType(aNfeImp[4],15,2)+'</Imp_iibb>'
cString += '<Imp_perc_mun>'+ConvType(aNfeImp[5],15,2)+'</Imp_perc_mun>'
cString += '<Imp_internos>'+ConvType(aNfeImp[6],15,2)+'</Imp_internos>'

cString += '<Imp_moneda_Id>'+ConvType(aPed[10],3,0)+'</Imp_moneda_Id>'
If Alltrim(aPed[10]) == "PES"
	cString += '<Imp_moneda_ctz>'+"1"+'</Imp_moneda_ctz>'
Else
    cString += '<Imp_moneda_ctz>'+Alltrim(STR(aCabNF[4]))+'</Imp_moneda_ctz>'
Endif
cString += '<Fecha_cbte>'+alltrim(str(year(aCabNF[1])))+strzero(month(aCabNF[1]),2)+alltrim(strzero(day(aCabNF[1]),2))+'</Fecha_cbte>'

//����������������Ŀ
//�Itens da factura�
//������������������
cString += '<Items>'
For Nx := 1 to Len(aProd)
	cString += '<Item>'	
		cString += '<Pro_codigo_ncm>'+Alltrim(aProd[Nx][15])+'</Pro_codigo_ncm>'		
		cString += '<Pro_ds>'+ConvType(Alltrim(aProd[Nx][03]))+'</Pro_ds>'
		cString += '<Pro_qty>'+ConvType(aProd[Nx][04],15,2)+'</Pro_qty>'
		cString += '<Pro_umed>'+Alltrim(aProd[Nx][05])+'</Pro_umed>'
		If cTipo == "1" 
			cString += '<Pro_precio_uni>'+ConvType((aProd[Nx][06]+aProd[Nx][09])*(1-(aProd[Nx][14]/100)),15,2)+'</Pro_precio_uni>'
		Else  
			cString += '<Pro_precio_uni>'+ConvType(aProd[Nx][06]*(1-(aProd[Nx][14]/100)),15,2)+'</Pro_precio_uni>'
		Endif	
		cString += '<Imp_bonif>'+ConvType(aProd[Nx][09],15,2)+'</Imp_bonif>'
		cString += '<Imp_total>'+ConvType((aProd[Nx][13]*(1-(aProd[Nx][14]/100)))+aProd[Nx][11],15,2)+'</Imp_total>'
		cString += '<Iva_id>'+aProd[Nx][10]+'</Iva_id>'
	cString += '</Item>'
	
	//���������������������������������������������Ĥ[�
	//�Item que representa a desgrava��o de impostos�
	//���������������������������������������������Ĥ[�		
	IF	aProd[Nx][14] > 0
		cString += '<Item>'	
			cString += '<Pro_codigo_ncm>'+Alltrim(aProd[Nx][15])+'</Pro_codigo_ncm>'		
			cString += '<Pro_ds>'+ConvType(Alltrim(aProd[Nx][03]))+'</Pro_ds>'
			cString += '<Pro_qty>'+ConvType(aProd[Nx][04],15,2)+'</Pro_qty>'
			cString += '<Pro_umed>'+Alltrim(aProd[Nx][05])+'</Pro_umed>'
			If cTipo == "1" 
				cString += '<Pro_precio_uni>'+ConvType((aProd[Nx][06]+aProd[Nx][09])*(1-(aProd[Nx][14]/100)),15,2)+'</Pro_precio_uni>'
			Else
				cString += '<Pro_precio_uni>'+ConvType(aProd[Nx][06]*(1-(aProd[Nx][14]/100)),15,2)+'</Pro_precio_uni>'
			Endif	
			cString += '<Imp_bonif>'+ConvType(aProd[Nx][09],15,2)+'</Imp_bonif>'
			cString += '<Imp_total>'+ConvType((aProd[Nx][06]+aProd[Nx][09])*(aProd[Nx][14]/100),15,2)+'</Imp_total>'
			cString += '<Iva_id>'+aProd[Nx][10]+'</Iva_id>'
   		cString += '</Item>'		
	EndIf
Next				
cString += '</Items>'
cString += '</Cmp>'

Return cString

                                                       
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Impostos�Autor  �Microsiga           � Data �               ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function Impostos()  
Local nAliq:= 0

DbSelectArea("SFB") 
SFB->(DBGOTOP()) 
While !SFB->(EOF()) 
	If SFB->FB_FILIAL+SFB->FB_CLASSIF+SFB->FB_CLASSE==xFilial("SFB")+"1P" ;//IB
	.Or. SFB->FB_FILIAL+SFB->FB_CLASSIF+SFB->FB_CLASSE==xFilial("SFB")+"2I"; //Imp. Interno
	.Or. SFB->FB_FILIAL+SFB->FB_CLASSIF+SFB->FB_CLASSE==xFilial("SFB")+"3P" //Imp IVA
		If SFB->FB_CLASSE<>"R" 
			cColIB    :=SFB->FB_CPOLVRO 
			IF(LEN(SFB->FB_CPOLVRO)<>0) 
				nAliq:=SFB->FB_ALIQ
				If Len(aColIB)<>0 
					If  AScan( aColIB, { |x| x[1] == SFB->FB_CPOLVRO } ) ==0   
						AADD(aColIB,{SFB->FB_CPOLVRO,{},ALLTRIM(SFB->FB_CODAFIP),SFB->FB_DESCR,SFB->FB_TIPO,SFB->FB_CLASSE,SFB->FB_CLASSIF}) 
			        EndIf
				Else 
					AADD(aColIB,{SFB->FB_CPOLVRO,{},ALLTRIM(SFB->FB_CODAFIP),SFB->FB_DESCR,SFB->FB_TIPO,SFB->FB_CLASSE,SFB->FB_CLASSIF}) 
				EndIf
			Endif  
		Endif 
	ElseIf SFB->FB_FILIAL+SFB->FB_CLASSIF+SFB->FB_CLASSE==xFilial("SFB")+"3I"  //IVA 
		cColIVA   :=SFB->FB_CPOLVRO 
		IF(LEN(SFB->FB_CPOLVRO)<>0)         
			If Len(aColIVA)<>0 
				If  AScan( aColIVA, { |x| x[1] == SFB->FB_CPOLVRO } ) ==0   
					AADD(aColIVA,{SFB->FB_CPOLVRO,{},ALLTRIM(SFB->FB_CODAFIP),SFB->FB_DESCR,SFB->FB_TIPO,SFB->FB_CLASSE,SFB->FB_CLASSIF}) 
		        EndIf
			Else 
				AADD(aColIVA,{SFB->FB_CPOLVRO,{},ALLTRIM(SFB->FB_CODAFIP),SFB->FB_DESCR,SFB->FB_TIPO,SFB->FB_CLASSE,SFB->FB_CLASSIF}) 
			EndIf
		Endif              
	Endif 
	SFB->(DBSkip()) 
Enddo 
Return()


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CodComp�Autor  �Camila Janu�rio     � Data �  21/07/11      ���
�������������������������������������������������������������������������͹��
���Desc.     � Verifica o c�digo do comprovante v�lido pela AFIP          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Nota Fiscal Eletr. Reg. Nominaci�n                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function CodComp(aNF)

//����������������������Ŀ
//�1 � Factura A         �
//�2 � Nota de D�bito A  �
//�3 � Nota de Cr�dito A �
//�6 � Factura B         �
//�7 � Nota de D�bito B  �
//�8 � Nota de Cr�dito B �
//������������������������
Local cCod := "" 

	If (Alltrim(aNF[10]) == "NF") .OR. (Alltrim(aNF[11]) == "NF")  
		If (SUBS(Alltrim(aNF[9]),1,1)== "A") .OR. (SUBS(Alltrim(aNF[10]),1,1)== "A")  
		    cCod := "1"
		Else
			cCod := "6"	
		EndIf
	Else
		If (SUBS(Alltrim(aNF[9]),1,1) == "A") .OR. (SUBS(Alltrim(aNF[10]),1,1) == "A")		
			If (Alltrim(aNF[11]) $ "NDC|NDP|NDE|NDI") .OR. (Alltrim(aNF[10]) $ "NDC|NDP|NDE|NDI")
				cCod := "2"
			Else
				cCod := "3"
			EndIf
		Else
			If (Alltrim(aNF[11]) $ "NDC|NDP|NDE|NDI") .OR. (Alltrim(aNF[10]) $ "NDC|NDP|NDE|NDI")
				cCod := "7"
			Else
				cCod := "8"	
			EndIF		
		EndIf	
	EndIf

Return cCod

                 
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ValDesgr �Autor  �Camila Janu�rio      � Data �  01/12/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Calcula valor de isento quando h� desgrava��o de impostos  ���
���          �                                                   		  ���
�������������������������������������������������������������������������͹��
���Uso       � Nota Fiscal Eletr�nica - Argentina                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ValDesgr(aIva,aColIVa)

Local nDesgr := 0
Local nIv
Local nIva 

//������������������������������������������������������������������P�
//�Obtem valor de desgrava��o de IVA caso D2/D1_DESGR for maior que 0    �
//������������������������������������������������������������������P�
If Len(aColIVA)  > 0
	For nIv:=1 to Len(aColIVA) 
	    If Len(aColIVA[nIv][2])>0		
			For nIVa:=1 To Len(aColIVA[nIv][2])
            	If aColIVA[nIv][2][nIVa][4] > 0
	  				nDesgr += aColIVA[nIv][2][nIVa][3]-(aColIVA[nIv][2][nIVa][3]*(1-(aColIVA[nIv][2][nIVa][4]/100)))
            	EndIf
			Next				
		EndIf	
	Next
EndIf                                         

Return nDesgr


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RetTpCbte�Autor  �Camila Janu�rio      � Data �  09/05/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Retorna o tipo de comprovante                              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Nfe Argentina                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function RetTpCbte(aNF)
Local cCbte := "" 

//�������������������������������������������������������������Ŀ
//�Retorno os tipos de comprovantes com seus codigos respectivos�
//�aceitos pela AFIP                                            �
//��������������������������������������������������������������� 
If (Subs(Alltrim(aNF[9]),1,1)== "A") .OR. (Subs(Alltrim(aNF[10]),1,1)== "A") //serie A 

	If ((Alltrim(aNF[10]) == "NF") .OR. (Alltrim(aNF[11]) == "NF")) 
		cCbte := "01"
	Elseif ((Alltrim(aNF[10]) $ "NDC|NDI") .OR. (Alltrim(aNF[11]) $ "NDC|NDI")) 
			cCbte := "02"		
    Elseif ((Alltrim(aNF[10]) $ "NCC|NCI") .OR. (Alltrim(aNF[11]) $ "NCC|NCI"))  
    		cCbte := "03"  	
    Else
    	cCbte := "39"
    Endif
Elseif (Subs(Alltrim(aNF[9]),1,1)== "B") .OR. (Subs(Alltrim(aNF[10]),1,1)== "B") //serie B

	If ((Alltrim(aNF[10]) == "NF") .OR. (Alltrim(aNF[11]) == "NF")) 
		cCbte := "06"
	Elseif ((Alltrim(aNF[10]) $ "NDC|NDI") .OR. (Alltrim(aNF[11]) $ "NDC|NDI")) 
			cCbte := "07"		
	Elseif ((Alltrim(aNF[10]) $ "NCC|NCI") .OR. (Alltrim(aNF[11]) $ "NCC|NCI")) 
	  		cCbte := "08"
	Else
	   	cCbte := "40"
	Endif	
Endif

Return cCbte 


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NfeTotImp�Autor  �Camila Janu�rio      � Data �  15/05/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Busca totais de impostos Municipais, Internos, Ganancias,  ���
���          � Iva, Ingresos Brutos                                       ���
�������������������������������������������������������������������������͹��
���Uso       � Factura eletr�nica                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static function NfeTotImp(cTip)

Local aRet := {}
Local nImpLiq:=nImpLiqRNI:=nImpPerc:=nImpIIBB:=nImpMun:=nImpInt:=0
Local aImpIVA := {}
Local aImpGAN := {}
Local aImpIIBB := {}
Local aImpMUN  := {}
Local aImpINT  := {} 
Local lCliente := IIF(cTip=="1",.T.,.F.)
Local cAlias := IIF(cTip=="1","SF2->F2","SF1->F1")
Local aArea := GetArea()

DbSelectArea("SFB") 
SFB->(DBGOTOP()) 
While !SFB->(EOF())
	//�����������������������������������Ŀ
	//�Impto_Liq = Nacional, Imposto e IVA�
	//������������������������������������� 	 
	If SFB->FB_FILIAL+SFB->FB_TIPO+SFB->FB_CLASSE+SFB->FB_CLASSIF==xFilial("SFB")+"NI3" 
	   	IF (LEN(SFB->FB_CPOLVRO)<>0)
	   		cCpoLvr:= SFB->FB_CPOLVRO	   		
			nImpLiq += &(cAlias+"_VALIMP"+cCpoLvr)				
		Endif		
	Endif
	
	//����������������������������������������Ŀ
	//�Impto_Liq_RNI = Nacional, Percep e IVA  �
	//������������������������������������������
	If SFB->FB_FILIAL+SFB->FB_TIPO+SFB->FB_CLASSE+SFB->FB_CLASSIF==xFilial("SFB")+"NP3" 
	   	IF(LEN(SFB->FB_CPOLVRO)<>0)
	   		cCpoLvr:= SFB->FB_CPOLVRO
            If lCliente
	            DbSelectArea("SA1")
	            DbSetOrder(1)
	            If Dbseek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA)
					If SA1->A1_TIPO == "S"
						nImpLiqRNI +=  &(cAlias+"_VALIMP"+cCpoLvr)
					Endif				
				Endif
			Endif	
		Endif		
	Endif
	
	//��������������������������������������������������Ŀ
	//�Imp_Perc = Nacional, Percep e IVA ou Ganancias	 �
	//����������������������������������������������������	 	
	If SFB->FB_FILIAL+SFB->FB_TIPO+SFB->FB_CLASSE+SFB->FB_CLASSIF==xFilial("SFB")+"NP3" ;	   	
		.OR. SFB->FB_FILIAL+SFB->FB_TIPO+SFB->FB_CLASSE+SFB->FB_CLASSIF==xFilial("SFB")+"NP4" 
	   	IF(LEN(SFB->FB_CPOLVRO)<>0)
	   		cCpoLvr:= SFB->FB_CPOLVRO
            If lCliente
	            DbSelectArea("SA1")
	            DbSetOrder(1)
	            If Dbseek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA)
					If SA1->A1_TIPO <> "S"
						nImpPerc +=  &(cAlias+"_VALIMP"+cCpoLvr)
					Endif				
				Endif
			Else
			    DbSelectArea("SA2")
	            DbSetOrder(1)
	            If Dbseek(xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA)
					If SA2->A2_TIPO <> "S"
						nImpPerc +=  &(cAlias+"_VALIMP"+cCpoLvr)
					Endif				
				Endif	
						
			Endif	
		Endif		
	Endif
	
	//��������������������������������������������������Ŀ
	//�Imp_IIBB = Provincia, Percep e Ingresos Brutos	 �
	//����������������������������������������������������	 
	If SFB->FB_FILIAL+SFB->FB_TIPO+SFB->FB_CLASSE+SFB->FB_CLASSIF==xFilial("SFB")+"PP1" 
	   	IF(LEN(SFB->FB_CPOLVRO)<>0)
	   		cCpoLvr:= SFB->FB_CPOLVRO	   		
			nImpIIBB += &(cAlias+"_VALIMP"+cCpoLvr)				
		Endif		
	Endif
	
	//��������������������������������������������������Ŀ
	//�Imp_perc_mun = Municipal, Percep e Municipais	 �
	//����������������������������������������������������	 	
	If SFB->FB_FILIAL+SFB->FB_TIPO+SFB->FB_CLASSE+SFB->FB_CLASSIF==xFilial("SFB")+"MP5" 
	   	IF(LEN(SFB->FB_CPOLVRO)<>0)
	   		cCpoLvr:= SFB->FB_CPOLVRO	   		
			nImpMun += &(cAlias+"_VALIMP"+cCpoLvr)				
		Endif		
	Endif
	
	//��������������������������������������������������Ŀ
	//�Imp_perc_mun = Nacional, Imposto e Interno		 �
	//����������������������������������������������������	 
	If SFB->FB_FILIAL+SFB->FB_TIPO+SFB->FB_CLASSE+SFB->FB_CLASSIF==xFilial("SFB")+"NI2" 
	   	IF(LEN(SFB->FB_CPOLVRO)<>0)
	   		cCpoLvr:= SFB->FB_CPOLVRO	   		
			nImpInt += &(cAlias+"_VALIMP"+cCpoLvr)				
		Endif		
	Endif
	SFB->(DBSkip()) 
Enddo										

aadd(aRet,nImpLiq)
aadd(aRet,nImpLiqRNI)
aadd(aRet,nImpPerc)
aadd(aRet,nImpIIBB)
aadd(aRet,nImpMun)
aadd(aRet,nImpInt)

RestArea(aArea) 

Return aRet