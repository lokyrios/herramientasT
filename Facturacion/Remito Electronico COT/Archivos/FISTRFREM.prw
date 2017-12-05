User Function FISTRFREM
                              
Local nPos := aScan(aRotina,{|x| AllTrim(x[2]) = 'ARGNVisualDoc'})

If nPos > 0 
  aRotina[nPos][2] := "U_VerRemEl"
EndIf

Return(nil)


User Function VerRemEl()

If AllTrim(SF2->F2_ESPECIE) == 'RFN'
  LocxNf(50,,,2,'ARGNFE',,2)
ElseIf AllTrim(SF2->F2_ESPECIE) == 'RTS'
  LocxNf(54,,,2,'ARGNFE',,2)
EndIf

Return(nil)