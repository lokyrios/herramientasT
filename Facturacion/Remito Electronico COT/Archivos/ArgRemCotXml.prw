#INCLUDE "PROTHEUS.CH"
#INCLUDE "PARMTYPE.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma  ณNfdsXml001ณ Autor ณ Roberto Souza         ณ Data ณ21/05/2009ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณExemplo de geracao da Nota Fiscal Digital de Servi็os       ณฑฑ
ฑฑณ          ณ                                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณXml para envio                                              ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณExpC1: Tipo da NF                                           ณฑฑ
ฑฑณ          ณ       [0] Entrada                                          ณฑฑ
ฑฑณ          ณ       [1] Saida                                            ณฑฑ
ฑฑณ          ณExpC2: Serie da NF                                          ณฑฑ
ฑฑณ          ณExpC3: Numero da nota fiscal                                ณฑฑ
ฑฑณ          ณExpC4: Codigo do cliente ou fornecedor                      ณฑฑ
ฑฑณ          ณExpC5: Loja do cliente ou fornecedor                        ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ   DATA   ณ Programador   ณManutencao efetuada                         ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ          ณ               ณ                                            ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function ArgRemCotXml(cTipo,cSerie,cNota,cClieFor,cLoja)

Local cString    	:= ""
Local cWhere	 	:= ""
Local cMVREPROD	:= Alltrim(GetNewPar("MV_REPROD","B1_COD"))
Local cCampo		:= ""
Local cCodUnProd	:= ""
Local cCodUm		:= ""
Local cCodTransp	:= ""
Local cAx_END		:= ""
Local nX        	:= 0

Local lQuery    	:= .F.
Local lConsFin 		:= .F.
Local lTransPed		:= .F.

Local aNota     	:= {}
Local aDest     	:= {}
Local aEntrega  	:= {}
Local aProd     	:= {}
Local acabNF 		:= {}
Local aInfRemto	:= {}
Local aInfDstari	:= {}
Local aInfDest	:= {}
Local aInfOrig	:= {}
Local aInfRecor	:= {}             
Local aMVREUN 	:=  &( GetNewPar("MV_REUN",'{ {"KG","1"},{"L","2"},{"UN","3"},{"M2","4"},{"MT","5"},{"M3","6"},{"P","7"}}') )
Local aEndDest	:= {}
Local aEndOrig	:= {}

Local cDestCGC := ""
Local cDestNome := ""
Local cDestCepE := ""
Local cDestMunE := ""
Local cAx_END := ""
Local cDestEstE := ""
			
Private aColIB	:={}
Private aColIVA	:={}
Private aIB:={}
Private aIVA:={}
Private _cSerie := ""

DEFAULT cTipo   := PARAMIXB[1]
DEFAULT cSerie  := PARAMIXB[2]
DEFAULT cNota   := PARAMIXB[3]
DEFAULT cClieFor:= PARAMIXB[4]
DEFAULT cLoja   := PARAMIXB[5]

If cTipo == "1"
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณPosiciona Remito                                                            ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	SF2->( dbSetOrder(1) )
	SF2->( DbGoTop() )
	If SF2->( DbSeek(xFilial("SF2")+cNota+cSerie+cClieFor+cLoja) )	
		
		//Dados do grupo infremito
		aadd(aInfRemto,SF2->F2_EMISSAO) //fecha_emision
		aadd(aInfRemto,"91 "+Left(Alltrim(SF2->F2_SERIE),1)+SF2->F2_DOC)//codigo_unico
		aadd(aInfRemto,dDataBase)//fecha_salida_transporte
		aadd(aInfRemto,"")//hora_salida_transporte
		aadd(aInfRemto,"E")//sujeto_generador
		
		//Dados do grupo infdestinatario		
		If AllTrim(SF2->F2_ESPECIE) == 'RTS'
			SA2->(dbSetOrder(1))
			SA2->(dbSeek(xFilial("SA2")+SF2->F2_CLIENTE+SF2->F2_LOJA))
			if alltrim(SA2->A2_TIPO) == 'F'
				lConsFin := .T.
			EndIf 
			cDestCGC := AllTrim(SA2->A2_CGC)
			cDestNome := AllTrim(SA2->A2_NOME)
			cDestCepE := AllTrim(SA2->A2_CEP)
			cDestMunE := AllTrim(SA2->A2_MUN)
			cAx_END := AllTrim(SA2->A2_END)
			cDestEstE := AllTrim(SA2->A2_EST)
		Else
			SA1->(dbSetOrder(1))
			SA1->(dbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA))
			if alltrim(SA1->A1_TIPO) == 'F'
				lConsFin := .T.
			EndIf
			cDestCGC := AllTrim(SA1->A1_CGC)
			cDestNome := AllTrim(SA1->A1_NOME)
			cDestCepE := AllTrim(Iif(!Empty(SA1->A1_CEPE),SA1->A1_CEPE,SA1->A1_CEP))
			cDestMunE := AllTrim(Iif(!Empty(SA1->A1_MUNE),SA1->A1_MUNE,SA1->A1_MUN))
			cAx_END := AllTrim(Iif(!Empty(SA1->A1_ENDENT),SA1->A1_ENDENT,SA1->A1_END))
			cDestEstE := AllTrim(Iif(!Empty(SA1->A1_ESTE),SA1->A1_ESTE,SA1->A1_EST)) 
		EndIf		

		cDestEndE := IIf(RAt(' ',cAx_END) > 0,Left(cAx_END,RAt(' ',cAx_END)),cAx_END)
		cDestEnNE := IIf(RAt(' ',cAx_END) > 0,Right(cAx_END,Max(Len(cAx_END) - RAt(' ',cAx_END),0)),'0000')
		
		aadd(aInfDstari,iif(lConsFin,"1","2")) //destinatario_consumidor_final	
		aadd(aInfDstari,"") //destinatario_tipo_documento
		aadd(aInfDstari,"") //destinatario_documento	
		aadd(aInfDstari,iif( lConsFin,"",cDestCGC)) //destinatario_cuit
		aadd(aInfDstari,iif( lConsFin,"",cDestNome)) //destinatario_razon_social
		aadd(aInfDstari,iif( lConsFin,"2","1") ) //destinatario_tenedor
		
		//Dados do grupo de infdestino
		aadd(aInfDest,cDestEndE) //destino_domicilio_calle
		aadd(aInfDest,cDestEnNE) //destino_domicilio_numero
		aadd(aInfDest,"") //destino_domicilio_comple
		aadd(aInfDest,"") //destino_domicilio_piso
		aadd(aInfDest,"") //destino_domicilio_dto
		aadd(aInfDest,"") //destino_domicilio_barrio
		aadd(aInfDest,cDestCepE) //destino_domicilio_codigopostal
		aadd(aInfDest,cDEstMunE) //destino_domicilio_localidad
		aadd(aInfDest,CodEstCOT(cDestEstE)) //destino_domicilio_provincia
		aadd(aInfDest,"") //proprio_destino_domicilio_codigo
		
		//Dados do grupo inforigem
		aEndOrig := MyGetEnd(SM0->M0_ENDENT,"SM0")
		
		aadd(aInfOrig,iif(cDEstMunE $ SM0->M0_CIDENT,"1","2")) //entrega_domicilio_origen
		aadd(aInfOrig,StrZero(Val(SM0->M0_CGC),11)) //origen_cuit
		aadd(aInfOrig,AllTrim(SM0->M0_NOMECOM)) //origen_razon_social
		aadd(aInfOrig,"1") //emisor_tenedor
		aadd(aInfOrig,aEndOrig[1]) //origen_domicilio_calle
		aadd(aInfOrig,aEndOrig[2]) //origen_domicilio_numero
		aadd(aInfOrig,"") //origen_domicilio_comple
		aadd(aInfOrig,"") //origen_domicilio_piso
		aadd(aInfOrig,"") //origen_domicilio_dto
		aadd(aInfOrig,SM0->M0_BAIRENT) //origen_domicilio_barrio
		aadd(aInfOrig,AllTrim(SM0->M0_CEPENT)) //origen_domicilio_codigopostal
		aadd(aInfOrig,AllTrim(SM0->M0_CIDENT)) //origen_domicilio_localidad
		aadd(aInfOrig,CodEstCOT(SM0->M0_ESTENT)) //origen_domicilio_provincia
		
		//Dados do grupo infrecorrido	
		if !empty(SF2->F2_TRANSP)
			SA4->(dbSetorder(1))
			if SA4->(dbSeek(xFilial("SA4")+SF2->F2_TRANSP))
				aadd(aInfRecor,StrZero(Val(SA4->A4_CGC),11)) //transportista_cuit			
			else
				aadd(aInfRecor,"") //transportista_cuit
			endif
		else
			lTransPed := .T.                 
			aadd(aInfRecor,"")
		endif								
		
		aadd(aInfRecor,"") //tipo_recorrido 
		aadd(aInfRecor,"") //recorrido_localidad 
		aadd(aInfRecor,"") //recorrido_calle 
		aadd(aInfRecor,"") //recorrido_ruta
		// Si CUIT Origen = CUIT transportista (transporte propio)
		If aInfRecor[1] = aInfOrig[2] 
			aadd(aInfRecor,SA4->A4_XPATENT) //patente_vehiculo 
		Else
			aadd(aInfRecor,"") //patente_vehiculo 
		EndIf
		aadd(aInfRecor,"") //patente_acoplado 		
		aadd(aInfRecor,"2") //producto_no_term_dev
		aadd(aInfRecor,SF2->F2_VALMERC * Iif(SF2->F2_MOEDA == 1,1,SF2->F2_TXMOEDA)) //importe 		

		//Dados do grupo infprod
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
				
		(cAliasSD2)->(dbgotop())
		
		While (cAliasSD2)->(!EOF()) .And. SF2->(F2_FILIAL+F2_SERIE+F2_DOC) == (cAliasSD2)->(D2_FILIAL+D2_SERIE+D2_DOC)

			//codigo_unico_producto
			if Left(cMVREPROD,2) == "B5" 
			
				if SB5->(FieldPos(cMVREPROD)) > 0
					cCodUnPrd := Left(Posicione("SB5",1,xFilial("SB5")+(cAliasSD2)->D2_COD,cMVREPROD),6)
				else
					CodUnPrd := Left(Posicione("SB1",1,xFilial("SB1")+(cAliasSD2)->D2_COD,"B1_COD"),6)
				endif	
			
			else
				
				if SB1->(FieldPos(cMVREPROD)) > 0
					cCodUnPrd := Left(Posicione("SB1",1,xFilial("SB1")+(cAliasSD2)->D2_COD,cMVREPROD),6)
				else
					CodUnPrd := Left(Posicione("SB1",1,xFilial("SB1")+(cAliasSD2)->D2_COD,"B1_COD"),6)
				endif				
				
			endif
			
			//rentas_codigo_unidad_medida
			SB1->(dbSetOrder(1))
			SB1->(dbSeek(xFilial("SB1")+(cAliasSD2)->D2_COD))

			If ( nX := aScan(aMVREUN,{|x| Alltrim(x[1])==SB1->B1_UM})  ) > 0
				cCodUm	:= 	aMVREUN[nX][2]
			else
				cCodUm	:= 	SB1->B1_UM
			endif
			
			//proprio_descripcion_unidad_medida
			SAH->(dbSetOrder(1))
			SAH->(dbSeek(xFilial("SAH")+(cAliasSD2)->D2_UM))
			cDescUm := SAH->AH_DESCES

			//Adiciona no Array de pordutos											
			aadd( aProd,{Len(aProd)+1 ,; 
                         cCodUnPrd,; //codigo_unico_producto
                         cCodUm,;//rentas_codigo_unidad_medida
                         (cAliasSD2)->D2_QUANT,;//cantidad
                         (cAliasSD2)->D2_COD,;//proprio_codigo_producto
                         SB1->B1_DESC,;//proprio_descripcion_producto
                         cDescUm,;//proprio_descripcion_unidad_medida
                         (cAliasSD2)->D2_QUANT})//cantidad_ajustada
			
			//Pega o codigo da transportadora
			if lTransPed
				SC5->(dbSetOrder(1))
				if SC5->(dbSeek(xFilial("SC5")+(cAliasSD2)->D2_PEDIDO)) .and. !empty(SC5->C5_TRANSP)
					cCodTransp := SC5->C5_TRANSP
				endif				
			endif
			
		(cAliasSD2)->(dbSkip())
		
		Enddo		
		(cAliasSD2)->(dbCloseArea())		
	
		If lTransPed .and. !empty(cCodTransp)
			SA4->(dbSetorder(1))
			if SA4->(dbSeek(xFilial("SA4")+cCodTransp))
				aInfRecor[1] := StrZero(Val(SA4->A4_CGC),11) //transportista_cuit			
			EndIf
			// Si CUIT Origen = CUIT transportista (transporte propio)
			If aInfRecor[1] = aInfOrig[2] 
				aInfRecor[6] := SA4->A4_XPATENT //patente_vehiculo 
			EndIf
		endif					
	
		aErro := {}
	
		If Empty(aInfRecor[1]) .OR. aInfRecor[1] == '00000000000'
			aAdd(aErro,"CUIT de transportista invแlido: '" + aInfRecor[1] + "'")
		EndIf
	
		If Empty(aInfOrig[2]) .OR. aInfOrig[2] == '00000000000'
			aAdd(aErro,"CUIT de lugar origen invแlido: '" + aInfOrig[2] + "'")
		EndIf
	
		If (aInfRecor[1] = aInfOrig[2]) .AND. Empty(aInfRecor[6])
			aAdd(aErro,"Patente de transportista propio vacํa")
		EndIf	
	
		If Empty(aInfDstari[1]) .OR. aInfDstari[1] == '00000000000'
			aAdd(aErro,"CUIT de destinatario invแlido: '" + aInfDstari[4] + "'")
		EndIf
		
		If Len(aErro) > 0 
			cTxtAviso := "El documento " + cSerie + '/' + cNota + " del cliente " + cClieFor + '/' + cLoja
			cTxtAviso += " contiene errores que rechazarแn la aprobacion de COT:" + Chr(13) + Chr(10)
	
			For nX := 1 To Len(aErro)
				cTxtAviso += aErro[nX] + Chr(13)
			Next nX
	
			//Aviso(Procname(0),cTxtAviso,{"Continuar"},2)
		EndIf
		
	EndIf

EndIf

//Faz a chamado das fun็๕es que gera o XML Padrใo TSS do COT
//Lembrando que este XML serแ convertindo no TSS no Arquivo .TXT 
//aceito pelo portal do COT.

cString := '<remito>'

cString += XmlInfRemito(aInfRemto)	                                                          
cString += XmlInfDstario(aInfDstari)
cString += XmlInfDestino(aInfDest)
cString += XmlInfOrigem(aInfOrig)
cString += XmlInfRecorri(aInfRecor)

cString += '<productos>'

For nX := 1 to Len(aProd)			
	cString += XmlInfProd(aProd[nX])
Next nX

cString += '</productos>'

cString += '</remito>'

Return(cString)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXmlInfRemito บAutor  ณRafael Iaquinto  บ Data ณ  09/01/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera string com conte๚do XML, com os dados principais do   บฑฑ
ฑฑบ          ณ Remito                                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Remito Eletronico da Argentia - COT                		    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function XmlInfRemito(aInfRemto)

local cString    := ""

local dFchEmiss		:= aInfRemto[1] //fecha_emision
local cChvRem 		:= aInfRemto[2] //codigo_unico
local dFchSaida		:= aInfRemto[3] //fecha_salida_transporte
local chrSaida		:= aInfRemto[4] //hora_salida_transporte
local cGerador		:= aInfRemto[5] //sujeto_generador

cString    += '<infremito>'
cString    += '<fecha_emision>'+ConvType(dFchEmiss)+'</fecha_emision>'
cString    += '<codigo_unico>'+cChvRem+'</codigo_unico>'
cString    += '<fecha_salida_transporte>'+ConvType(dFchSaida)+'</fecha_salida_transporte>'
cString    += NfeTag('<hora_salida_transporte>',ConvType(chrSaida,10) )
cString    += '<sujeto_generador>'+cGerador+'</sujeto_generador>'
cString    += '</infremito>'

Return cString 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXmlInfDstario  ณAutor Rafae Iaquinto  บData ณ  09/01/12     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGera string com conte๚do do XML, com os dados do            บฑฑ
ฑฑบ          ณdestinatario                                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Remito Eletronico da Argentia - COT                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function XmlInfDstario(aInfDstari)

Local cString := ""
local cConsFinal		:= aInfDstari[1] //destinatario_consumidor_final
local cTpDoc 			:= aInfDstari[2] //destinatario_tipo_documento
local cDocumento 		:= aInfDstari[3] //destinatario_documento
local cCuit   		:= aInfDstari[4] //destinatario_cuit
local cRazao  		:= aInfDstari[5] //destinatario_razon_social
local cTenedor		:= aInfDstari[6] //destinatario_tenedor

cString := '<infdestinatario>'
cString += '<destinatario_consumidor_final>'+cConsFinal+'</destinatario_consumidor_final>'
cString += NfeTag( '<destinatario_tipo_documento>',ConvType(cTpDoc,3) )
cString += NfeTag( '<destinatario_documento>',ConvType(cDocumento,11) )
cString += NfeTag( '<destinatario_cuit>',cCuit)
cString += NfeTag( '<destinatario_razon_social>',ConvType(cRazao,50) )
cString += NfeTag( '<destinatario_tenedor>',cTenedor )
cString += '</infdestinatario>'

Return(cString)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXmlInfDestino  ณAutor Rafae Iaquinto  บData ณ  09/01/12     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGera string com conte๚do do XML, com os dados do            บฑฑ
ฑฑบ          ณdestinatario                                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Remito Eletronico da Argentia - COT                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function XmlInfDestino(aInfDest)

local cString := ""

local cCalle		:= aInfDest[1] //destino_domicilio_calle
local cNum	 		:= aInfDest[2] //destino_domicilio_numero
local cCpl	 		:= aInfDest[3] //destino_domicilio_comple
local cPiso 		:= aInfDest[4] //destino_domicilio_piso
local cDto  		:= aInfDest[5] //destino_domicilio_dto
local cBarrio		:= aInfDest[6] //destino_domicilio_barrio
local cCodPost	:= aInfDest[7] //destino_domicilio_codigopostal
local cLocalidad	:= aInfDest[8] //destino_domicilio_localidad
local cProvinc	:= aInfDest[9] //destino_domicilio_provincia
local cPropCod	:= aInfDest[10] //proprio_destino_domicilio_codigo

cString := '<infdestino>'
cString += '<destino_domicilio_calle>'+ConvType(cCalle,40)+'</destino_domicilio_calle>'
cString += Nfetag('<destino_domicilio_numero>',ConvType(cNum,5),.T.)
cString += Nfetag('<destino_domicilio_comple>',ConvType(cCpl,5))
cString += NfeTag('<destino_domicilio_piso>',ConvType(cPiso,3))
cString += NfeTag('<destino_domicilio_dto>',ConvType(cDto,4))
cString += NfeTag('<destino_domicilio_barrio>',ConvType(cBarrio,30))
cString += NfeTag('<destino_domicilio_codigopostal>',ConvType(cCodPost,8))
cString += NfeTag('<destino_domicilio_localidad>',ConvType(cLocalidad,50))
cString += NfeTag('<destino_domicilio_provincia>',ConvType(cProvinc,1))
cString += NfeTag('<proprio_destino_domicilio_codigo>',ConvType(cPropCod,20))
cString += '</infdestino>'

Return(cString)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXmlInfOrigem  ณAutor Rafae Iaquinto  บData ณ  09/01/12     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGera string com conte๚do do XML, com os dados da Origem     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Remito Eletronico da Argentia - COT                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function XmlInfOrigem(aInfOrig)

Local cString := ""
local cEntOrigen	:= aInfOrig[1] //entrega_domicilio_origen
local cOrigCuit	:= aInfOrig[2] //origen_cuit
local cRazon 		:= aInfOrig[3] //origen_razon_social
local cEmiTenedor	:= aInfOrig[4] //emisor_tenedor
local cCalle  	:= aInfOrig[5] //origen_domicilio_calle
local cNum  		:= aInfOrig[6] //origen_domicilio_numero
local cCpl			:= aInfOrig[7] //origen_domicilio_comple
local cPiso		:= aInfOrig[8] //origen_domicilio_piso
local cDto			:= aInfOrig[9] //origen_domicilio_dto
local cBarrio		:= aInfOrig[10] //origen_domicilio_barrio                                         			
local cCodPost	:= aInfOrig[11] //origen_domicilio_codigopostal
local cLocalidad	:= aInfOrig[12] //origen_domicilio_localidad
local cProvinc	:= aInfOrig[13] //origen_domicilio_provincia

cString := '<inforigen>'
cString += '<entrega_domicilio_origen>'+cEntOrigen+'</entrega_domicilio_origen>'
cString += '<origen_cuit>'+cOrigCuit+'</origen_cuit>'
cString += '<origen_razon_social>'+ConvType(cRazon,50)+'</origen_razon_social>'
cString += '<emisor_tenedor>'+cEmiTenedor+'</emisor_tenedor>'
cString += '<origen_domicilio_calle>'+ConvType(cCalle,40)+'</origen_domicilio_calle>'
cString += NfeTag('<origen_domicilio_numero>',ConvType(cNum,5),.T.)
cString += NfeTag('<origen_domicilio_comple>',ConvType(cCpl,5))
cString += NfeTag('<origen_domicilio_piso>',ConvType(cPiso,3))
cString += NfeTag('<origen_domicilio_dto>',ConvType(cDto,4))
cString += NfeTag('<origen_domicilio_barrio>',ConvType(cBarrio,30))
cString += '<origen_domicilio_codigopostal>'+cCodPost+'</origen_domicilio_codigopostal>'
cString += '<origen_domicilio_localidad>'+ConvType(cLocalidad,50)+'</origen_domicilio_localidad>'
cString += '<origen_domicilio_provincia>'+cProvinc+'</origen_domicilio_provincia>'
cString += '</inforigen>'

Return(cString)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXmlInfRecorri  ณAutor Rafae Iaquinto  บData ณ  09/01/12     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGera string com conte๚do do XML, com os dados do Recorrido  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Remito Eletronico da Argentia - COT                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function XmlInfRecorri(aInfRecor)

Local cString := ""
local cTransCuit	:= aInfRecor[1] //transportista_cuit
local cTpRecorri	:= aInfRecor[2] //tipo_recorrido
local cLocalidad	:= aInfRecor[3] //recorrido_localidad
local cCalle		:= aInfRecor[4] //recorrido_calle
local cRuta  		:= aInfRecor[5] //recorrido_ruta
local cVeicPatent	:= aInfRecor[6] //patente_vehiculo
local cAcopPatent	:= aInfRecor[7] //patente_acoplado
local cPrdNoTerm	:= aInfRecor[8] //producto_no_term_dev
local nImport		:= aInfRecor[9] //importe

cString := '<infrecorrido>'
cString += '<transportista_cuit>'+Convtype(cTransCuit)+'</transportista_cuit>'
cString += NfeTag('<tipo_recorrido>',ConvType(cTpRecorri))
cString += NfeTag('<recorrido_localidad>',ConvType(cLocalidad,50))
cString += NfeTag('<recorrido_calle>',ConvType(cCalle,40))
cString += NfeTag('<recorrido_ruta>',ConvType(cRuta,40))
cString += NfeTag('<patente_vehiculo>',ConvType(cVeicPatent,6))
cString += NfeTag('<patente_acoplado>',ConvType(cAcopPatent,6))
cString += '<producto_no_term_dev>'+cPrdNoTerm+'</producto_no_term_dev>'
cString += NfeTag('<importe>',Alltrim(ConvType(nImport,10,2)))
cString += '</infrecorrido>'

Return(cString)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXmlInfProd  ณAutor Rafae Iaquinto  บData ณ  09/01/12        บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGera string com conte๚do do XML, com os dados do Produto    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Remito Eletronico da Argentia - COT                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function XmlInfProd(aProd)

Local cString := ""
local cCdUniProd	:= aProd[2] //codigo_unico_producto
local cUnidMed  	:= aProd[3] //rentas_codigo_unidad_medida
local nCantidad 	:= aProd[4] //cantidad
local cPropCdPrd	:= aProd[5] //proprio_codigo_producto
local cDescProd 	:= aProd[6] //proprio_descripcion_producto
local cPrpDescUM	:= aProd[7] //proprio_descripcion_unidad_medida
local nCtdAjust	:= aProd[8] //cantidad_ajustada

cString := '<producto>'
cString += '<codigo_unico_producto>'+ConvType(cCdUniProd,6)+'</codigo_unico_producto>'
cString += '<rentas_codigo_unidad_medida>'+ConvType(cUnidMed,1)+'</rentas_codigo_unidad_medida>'
cString += '<cantidad>'+Alltrim(ConvType(nCantidad,13,2))+'</cantidad>'
cString += '<proprio_codigo_producto>'+ConvType(cPropCdPrd,25)+'</proprio_codigo_producto>'
cString += '<proprio_descripcion_producto>'+ConvType(cDescProd,40)+'</proprio_descripcion_producto>'
cString += '<proprio_descripcion_unidad_medida>'+ConvType(cPrpDescUM,20)+'</proprio_descripcion_unidad_medida>'
cString += '<cantidad_ajustada>'+Alltrim(ConvType(nCtdAjust,13,2))+'</cantidad_ajustada>'
cString += '</producto>'

Return(cString)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณConvType บAutor  ณMicrosiga           บ Data ณ              บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Converte tipos                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNoAcento บAutor  ณMicrosiga           บ Data ณ              บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Valida acentos                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static FUNCTION NoAcento(cString)

Local cChar  := ""
Local nX     := 0 
Local nY     := 0
Local cVogal := "aeiouAEIOU"
Local cAgudo := "แ้ํ๓๚"+"มษอำฺ"
Local cCircu := "โ๊๎๔๛"+"ยสฮิÛ"
Local cTrema := "ไ๋๏๖ü"+"ฤหฯึÜ"
Local cCrase := "เ่์๒๙"+"ภศฬาู" 
Local cTio   := "ใ๕"
Local cCecid := "็ว"
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

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณMyGetEnd  ณ Autor ณ Liber De Esteban             ณ Data ณ 19/03/09 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Verifica se o participante e do DF, ou se tem um tipo de endereco ณฑฑ
ฑฑณ          ณ que nao se enquadra na regra padrao de preenchimento de endereco  ณฑฑ
ฑฑณ          ณ por exemplo: Enderecos de Area Rural (essa verific็ใo e feita     ณฑฑ
ฑฑณ          ณ atraves do campo ENDNOT).                                         ณฑฑ
ฑฑณ          ณ Caso seja do DF, ou ENDNOT = 'S', somente ira retornar o campo    ณฑฑ
ฑฑณ          ณ Endereco (sem numero ou complemento). Caso contrario ira retornar ณฑฑ
ฑฑณ          ณ o padrao do FisGetEnd                                             ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Obs.     ณ Esta funcao so pode ser usada quando ha um posicionamento de      ณฑฑ
ฑฑณ          ณ registro, pois serแ verificado o ENDNOT do registro corrente      ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ SIGAFIS                                                           ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function MyGetEnd(cEndereco,cAlias)

Local cCmpEndN	:= SubStr(cAlias,2,2)+"_ENDNOT"
Local cCmpEst	:= SubStr(cAlias,2,2)+"_EST"
Local aRet		:= {"",0,"",""}   
Local nIb		:=0
Local nIv		:=0

if cAlias == "SM0"
	cCmpEst	:= SubStr(cAlias,2,2)+"_ESTENT"
endif

//Campo ENDNOT indica que endereco participante mao esta no formato <logradouro>, <numero> <complemento>
//Se tiver com 'S' somente o campo de logradouro sera atualizado (numero sera SN)
If (&(cAlias+"->"+cCmpEst) == "DF") .Or. ((cAlias)->(FieldPos(cCmpEndN)) > 0 .And. &(cAlias+"->"+cCmpEndN) == "1")
	aRet[1] := cEndereco
	aRet[3] := "SN"
Else
	aRet := FisGetEnd(cEndereco)
EndIf

Return aRet

Static Function NfeTag(cTag,cConteudo,lBranco)

Local cRetorno := ""
DEFAULT lbranco := .F.

If (!Empty(AllTrim(cConteudo)) .And. IsAlpha(AllTrim(cConteudo))) .Or. Val(AllTrim(cConteudo))<>0 .Or. lBranco
	cRetorno := cTag+AllTrim(cConteudo)+SubStr(cTag,1,1)+"/"+SubStr(cTag,2)
EndIf

Return(cRetorno)

Static Function CodEstCOT(cProvent)

Local aProvs := {{'SA','A'},{'BA','B'},{'CF','C'},{'SL','D'},{'ER','E'},{'LR','F'},{'SE','G'},{'CH','H'},;
				 {'SJ','J'},{'CA','K'},{'LP','L'},{'ME','M'},{'MI','N'},{'FO','P'},{'NE','Q'},{'RN','R'},;
				 {'SF','S'},{'TU','T'},{'CB','U'},{'TF','V'},{'CR','W'},{'CO','X'},{'JU','Y'},{'SC','Z'}}
Local cCod := 'B'
Local nPosCod := aScan(aProvs,{|x| Alltrim(x[1]) == AllTrim(cProvEnt)})

If nPosCod > 0
	cCod := aProvs[nPosCod][2]
EndIf

Return(cCod)