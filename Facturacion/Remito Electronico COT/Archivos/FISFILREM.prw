User Function FISFILREM()

Local cAdvPLQry := ""
Local cOpcFlt := Left(MV_PAR01,1)
Local aTmp := StrToKArr(GetMV("MK_COTEST",.F.,"BA,SF"),",")
Local cStrFil := ""
Local nTmp := 0

cAdvPLQry := "F2_FILIAL == '" + xFilial("SF2") + "' .AND. Alltrim(F2_TIPODOC) >= '50' "

If !Empty(MV_PAR02)
	cAdvPLQry += ".AND.F2_SERIE == '" + MV_PAR02 + "' "
EndIf

If cOpcFlt <> '4'
	cAdvPLQry += ".AND. F2_FLREMEL == '" + If(cOpcFlt == '1','E',If(cOpcFlt == '2','M',' ')) + "' "
EndIf

CCO->(DbSetOrder(1))
CCO->(DbGoTop())
For nTmp := 1 To Len(aTmp)

	If CCO->(DbSeek(xFilial("CCO") + ATmp[nTmp])) .AND. CCO->(FieldPos("CCO_PESCOT")) > 0 .AND. CCO->(FieldPos("CCO_MONCOT")) > 0 
		cStrFil += "((SM0->M0_ESTENT == '" + CCO->CCO_CODPRO + "' .OR. F2_PROVENT == '" + CCO->CCO_CODPRO + "') .AND. "
		cStrFil += "(F2_PLIQUI >= " + AllTrim(Str(CCO->CCO_PESCOT)) + " .OR. F2_VALBRUT >= " + AllTrim(Str(CCO->CCO_MONCOT)) + "))" 
		If nTmp < Len(aTmp)
			cStrFil += " .OR. "
		EndIf
	EndIf
		
Next nTmp

If !Empty(cStrFil)
	cAdvPLQry += ".AND. (" + cStrFil + ")"
EndIf

Return(cAdvPLQry)