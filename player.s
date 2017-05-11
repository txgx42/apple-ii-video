; Apple clock is 1020484.32 hz
; 85040.36 cycles per frame for 12fps
; max 442.92 cycles per line
; max 11 cycles per byte.

; Addresses for slot 1
SlinkyAddr := $C090
SlinkyData := $C093

LineFlags := $C0
LoadPage  := $FF

SwGraph := $C050
SwText := $C051
SwHGR := $C057
SwFullScrn := $C052
SwSplitScrn := $C053 
SwPage1	:= $C054
SwPage2 := $C055

SlinkySetup:
	lda	#0
	sta	SlinkyAddr
	sta	SlinkyAddr+1
	sta	SlinkyAddr+2

ClrScreen:
	lda	#0
	tay	
@1:	sta	$2000,y
	sta	$2100,y
	sta	$2200,y
	sta	$2300,y
	sta	$2400,y
	sta	$2500,y
	sta	$2600,y
	sta	$2700,y
	sta	$2800,y
	sta	$2900,y
	sta	$2a00,y
	sta	$2b00,y
	sta	$2c00,y
	sta	$2d00,y
	sta	$2e00,y
	sta	$2f00,y
	sta	$3000,y
	sta	$3100,y
	sta	$3200,y
	sta	$3300,y
	sta	$3400,y
	sta	$3500,y
	sta	$3600,y
	sta	$3700,y
	sta	$3800,y
	sta	$3900,y
	sta	$3a00,y
	sta	$3b00,y
	sta	$3c00,y
	sta	$3d00,y
	sta	$3e00,y
	sta	$3f00,y
	iny
	bne	@1


SetHGR:
	sta	SwGraph
	sta	SwHGR
	sta	SwFullScrn
	sta	SwPage1


NextFrame:
	lda	SlinkyData
	cmp	#$ff
	bne	@1
	lda	SlinkyData
	cmp	#$ff
	bne	@1
	; got length $FFFF = end of file here
	rts
@1:	ldx	#0
@2:	lda	SlinkyData
	sta	LineFlags,x
	inx
	cpx	#24	
	bne	@2
	jsr	MoveLines
	jmp	NextFrame


;MoveLines:
;	lda	LineFlags,x
;	ror	a		;2
;	bcc	@1		;2/3
;	lda	#$00		;2
;	pha			;3	
;	lda	<MoveLine0	;2
;	pha			;3
;	lda	>MoveLine0	;2
;	pha			;3
;@1:	ror	a		;2
;	bcc	@2
;	lda	#$28
;	pha
;	lda	<MoveLine0	;2
;	pha			;3
;	lda	>MoveLine0	;2
;	pha			;3


	
MoveLines:
	lda	#$1f
	sta	LoadPage
	jsr	NextPage	
	ldx	#0
@0:	lda	LineFlags,x
	rol	a
	bcc	@1
	jsr	MoveLine0
@1:	rol	a
	bcc	@2
	jsr	MoveLine1
@2:	rol	a
	bcc	@3
	jsr	MoveLine2
@3:	rol	a
	bcc	@4
	jsr	MoveLine3
@4:	rol	a
	bcc	@5
	jsr	MoveLine4
@5:	rol	a
	bcc	@6
	jsr	MoveLine5
@6:	jsr	NextPage
	rol	a
	bcc	@7
	jsr	MoveLine0
@7:	rol	a
	bcc	@8
	jsr	MoveLine1
@8:	inx
	lda	LineFlags,x
	rol	a
	bcc	@9
	jsr	MoveLine2
@9:	rol	a
	bcc	@10
	jsr	MoveLine3
@10:	rol	a
	bcc	@11
	jsr	MoveLine4
@11:	rol	a
	bcc	@12
	jsr	MoveLine5
@12:	jsr	NextPage
	rol	a
	bcc	@13
	jsr	MoveLine0
@13:	rol	a
	bcc	@14
	jsr	MoveLine1
@14:	rol	a
	bcc	@15
	jsr	MoveLine2
@15:	rol	a
	bcc	@16
	jsr	MoveLine3
@16:	inx
	lda	LineFlags,x
	rol	a
	bcc	@17
	jsr	MoveLine4
@17:	rol	a
	bcc	@18
	jsr	MoveLine5
@18:	jsr	NextPage
	rol	a
	bcc	@19
	jsr	MoveLine0
@19:	rol	a
	bcc	@20
	jsr	MoveLine1
@20:	rol	a
	bcc	@21
	jsr	MoveLine2
@21:	rol	a
	bcc	@22
	jsr	MoveLine3
@22:	rol	a
	bcc	@23
	jsr	MoveLine4
@23:	rol	a
	bcc	@24
	jsr	MoveLine5
@24:	jsr	NextPage
	inx
	cpx	#24	
	beq	@25
	jmp	@0
@25:	rts


;MoveLine0:
;	pha = 3
;	ldy immed = 2
;
;	loop * 5 = 415
;		lda abs = 4 * 8 = 32
;		sta abs,y = 5 * 8 = 40
;		tya/adc/tay/cpy = 8
;		bne = 3
;
;	bne = 2
;	pla = 4
;	rts = 6

;	pha			;3
;	txa			;2
;	pha			;3
;	ldy	#0		;2
;@1:	lda	SlinkyData	;4
;	sta	$2000,y		;5
;	lda	SlinkyData	;4
;	sta	$2001,y		;5
;	lda	SlinkyData	;4
;	sta	$2002,y		;5
;	lda	SlinkyData	;4
;	sta	$2003,y		;5
;	lda	SlinkyData	;4
;	sta	$2004,y		;5
;	lda	SlinkyData	;4
;	sta	$2005,y		;5
;	lda	SlinkyData	;4
;	sta	$2006,y		;5
;	lda	SlinkyData	;4
;	sta	$2007,y		;5
;	tya			;2
;	adc	#8		;2
;	tay			;2
;	cpy	#40		;2
;	bne	@1		;3
;	pla			;4
;	tax			;2 	
;	pla			;4
;	rts			;6

;CopyLine:
;	pha = 3
;	ldy immed = 2
;
;	loop * 5 = 415
;		lda abs = 4 * 8 = 32
;		sta abs,y = 5 * 8 = 40
;		tya/adc/tay/cpy = 8
;		bne = 3
;
;	bne = 2
;	pla = 4
;	rts = 6

;	pha			;3
;	txa			;2
;	pha			;3
;	ldy	#0		;2
;@1:	lda	$4000,y		;4	
;	sta	$2000,y		;5
;	lda	$4001,y		;4
;	sta	$2001,y		;5
;	lda	$4002.y		;4
;	sta	$2002,y		;5
;	lda	$4003,y		;4
;	sta	$2003,y		;5
;	lda	$4004,y		;4
;	sta	$2004,y		;5
;	lda	$4005,y		;4
;	sta	$2005,y		;5
;	lda	$4006,y		;4
;	sta	$2006,y		;5
;	lda	$4007,y		;4
;	sta	$2007,y		;5
;	tya			;2
;	adc	#8		;2
;	tay			;2
;	cpy	#40		;2
;	bne	@1		;3
;	pla			;4
;	tax			;2 	
;	pla			;4
;	rts			;6


;Delay:		
;	443 cycle delay
;	ldy	#15
;@1:	jsr	@2		;12
;	jsr	@2		;12
;	dey			;2
;	bne 	@1		;3
;@2:	rts			;6

MoveLine0:
	;	ldy absolute = 4 cycles * 40 = 160
	;	sty absolute = 4 cycles	* 40 = 160
	;	rts = 6 cycles
	; 	total 326 cycles (116 spare)
	ldy	SlinkyData
	sty	$2000
	ldy	SlinkyData
	sty	$2001
	ldy	SlinkyData
	sty	$2002
	ldy	SlinkyData
	sty	$2003
	ldy	SlinkyData
	sty	$2004
	ldy	SlinkyData
	sty	$2005
	ldy	SlinkyData
	sty	$2006
	ldy	SlinkyData
	sty	$2007
	ldy	SlinkyData
	sty	$2008
	ldy	SlinkyData
	sty	$2009
	ldy	SlinkyData
	sty	$200a
	ldy	SlinkyData
	sty	$200b
	ldy	SlinkyData
	sty	$200c
	ldy	SlinkyData
	sty	$200d
	ldy	SlinkyData
	sty	$200e
	ldy	SlinkyData
	sty	$200f
	ldy	SlinkyData
	sty	$2010
	ldy	SlinkyData
	sty	$2011
	ldy	SlinkyData
	sty	$2012
	ldy	SlinkyData
	sty	$2013
	ldy	SlinkyData
	sty	$2014
	ldy	SlinkyData
	sty	$2015
	ldy	SlinkyData
	sty	$2016
	ldy	SlinkyData
	sty	$2017
	ldy	SlinkyData
	sty	$2018
	ldy	SlinkyData
	sty	$2019
	ldy	SlinkyData
	sty	$201a
	ldy	SlinkyData
	sty	$201b
	ldy	SlinkyData
	sty	$201c
	ldy	SlinkyData
	sty	$201d
	ldy	SlinkyData
	sty	$201e
	ldy	SlinkyData
	sty	$201f
	ldy	SlinkyData
	sty	$2020
	ldy	SlinkyData
	sty	$2021
	ldy	SlinkyData
	sty	$2022
	ldy	SlinkyData
	sty	$2023
	ldy	SlinkyData
	sty	$2024
	ldy	SlinkyData
	sty	$2025
	ldy	SlinkyData
	sty	$2026
	ldy	SlinkyData
	sty	$2027
	rts

MoveLine1:
	ldy	SlinkyData
	sty	$2028
	ldy	SlinkyData
	sty	$2029
	ldy	SlinkyData
	sty	$202a
	ldy	SlinkyData
	sty	$202b
	ldy	SlinkyData
	sty	$202c
	ldy	SlinkyData
	sty	$202d
	ldy	SlinkyData
	sty	$202e
	ldy	SlinkyData
	sty	$202f
	ldy	SlinkyData
	sty	$2030
	ldy	SlinkyData
	sty	$2031
	ldy	SlinkyData
	sty	$2032
	ldy	SlinkyData
	sty	$2033
	ldy	SlinkyData
	sty	$2034
	ldy	SlinkyData
	sty	$2035
	ldy	SlinkyData
	sty	$2036
	ldy	SlinkyData
	sty	$2037
	ldy	SlinkyData
	sty	$2038
	ldy	SlinkyData
	sty	$2039
	ldy	SlinkyData
	sty	$203a
	ldy	SlinkyData
	sty	$203b
	ldy	SlinkyData
	sty	$203c
	ldy	SlinkyData
	sty	$203d
	ldy	SlinkyData
	sty	$203e
	ldy	SlinkyData
	sty	$203f
	ldy	SlinkyData
	sty	$2040
	ldy	SlinkyData
	sty	$2041
	ldy	SlinkyData
	sty	$2042
	ldy	SlinkyData
	sty	$2043
	ldy	SlinkyData
	sty	$2044
	ldy	SlinkyData
	sty	$2045
	ldy	SlinkyData
	sty	$2046
	ldy	SlinkyData
	sty	$2047
	ldy	SlinkyData
	sty	$2048
	ldy	SlinkyData
	sty	$2049
	ldy	SlinkyData
	sty	$204a
	ldy	SlinkyData
	sty	$204b
	ldy	SlinkyData
	sty	$204c
	ldy	SlinkyData
	sty	$204d
	ldy	SlinkyData
	sty	$204e
	ldy	SlinkyData
	sty	$204f
	rts


MoveLine2:
	ldy	SlinkyData
	sty	$2050
	ldy	SlinkyData
	sty	$2051
	ldy	SlinkyData
	sty	$2052
	ldy	SlinkyData
	sty	$2053
	ldy	SlinkyData
	sty	$2054
	ldy	SlinkyData
	sty	$2055
	ldy	SlinkyData
	sty	$2056
	ldy	SlinkyData
	sty	$2057
	ldy	SlinkyData
	sty	$2058
	ldy	SlinkyData
	sty	$2059
	ldy	SlinkyData
	sty	$205a
	ldy	SlinkyData
	sty	$205b
	ldy	SlinkyData
	sty	$205c
	ldy	SlinkyData
	sty	$205d
	ldy	SlinkyData
	sty	$205e
	ldy	SlinkyData
	sty	$205f
	ldy	SlinkyData
	sty	$2060
	ldy	SlinkyData
	sty	$2061
	ldy	SlinkyData
	sty	$2062
	ldy	SlinkyData
	sty	$2063
	ldy	SlinkyData
	sty	$2064
	ldy	SlinkyData
	sty	$2065
	ldy	SlinkyData
	sty	$2066
	ldy	SlinkyData
	sty	$2067
	ldy	SlinkyData
	sty	$2068
	ldy	SlinkyData
	sty	$2069
	ldy	SlinkyData
	sty	$206a
	ldy	SlinkyData
	sty	$206b
	ldy	SlinkyData
	sty	$206c
	ldy	SlinkyData
	sty	$206d
	ldy	SlinkyData
	sty	$206e
	ldy	SlinkyData
	sty	$206f
	ldy	SlinkyData
	sty	$2070
	ldy	SlinkyData
	sty	$2071
	ldy	SlinkyData
	sty	$2072
	ldy	SlinkyData
	sty	$2073
	ldy	SlinkyData
	sty	$2074
	ldy	SlinkyData
	sty	$2075
	ldy	SlinkyData
	sty	$2076
	ldy	SlinkyData
	sty	$2077
	rts


MoveLine3:
	ldy	SlinkyData
	sty	$2080
	ldy	SlinkyData
	sty	$2081
	ldy	SlinkyData
	sty	$2082
	ldy	SlinkyData
	sty	$2083
	ldy	SlinkyData
	sty	$2084
	ldy	SlinkyData
	sty	$2085
	ldy	SlinkyData
	sty	$2086
	ldy	SlinkyData
	sty	$2087
	ldy	SlinkyData
	sty	$2088
	ldy	SlinkyData
	sty	$2089
	ldy	SlinkyData
	sty	$208a
	ldy	SlinkyData
	sty	$208b
	ldy	SlinkyData
	sty	$208c
	ldy	SlinkyData
	sty	$208d
	ldy	SlinkyData
	sty	$208e
	ldy	SlinkyData
	sty	$208f
	ldy	SlinkyData
	sty	$2090
	ldy	SlinkyData
	sty	$2091
	ldy	SlinkyData
	sty	$2092
	ldy	SlinkyData
	sty	$2093
	ldy	SlinkyData
	sty	$2094
	ldy	SlinkyData
	sty	$2095
	ldy	SlinkyData
	sty	$2096
	ldy	SlinkyData
	sty	$2097
	ldy	SlinkyData
	sty	$2098
	ldy	SlinkyData
	sty	$2099
	ldy	SlinkyData
	sty	$209a
	ldy	SlinkyData
	sty	$209b
	ldy	SlinkyData
	sty	$209c
	ldy	SlinkyData
	sty	$209d
	ldy	SlinkyData
	sty	$209e
	ldy	SlinkyData
	sty	$209f
	ldy	SlinkyData
	sty	$20a0
	ldy	SlinkyData
	sty	$20a1
	ldy	SlinkyData
	sty	$20a2
	ldy	SlinkyData
	sty	$20a3
	ldy	SlinkyData
	sty	$20a4
	ldy	SlinkyData
	sty	$20a5
	ldy	SlinkyData
	sty	$20a6
	ldy	SlinkyData
	sty	$20a7
	rts

MoveLine4:
	ldy	SlinkyData
	sty	$20b8
	ldy	SlinkyData
	sty	$20b9
	ldy	SlinkyData
	sty	$20ba
	ldy	SlinkyData
	sty	$20bb
	ldy	SlinkyData
	sty	$20bc
	ldy	SlinkyData
	sty	$20bd
	ldy	SlinkyData
	sty	$20be
	ldy	SlinkyData
	sty	$20bf
	ldy	SlinkyData
	sty	$20b0
	ldy	SlinkyData
	sty	$20b1
	ldy	SlinkyData
	sty	$20b2
	ldy	SlinkyData
	sty	$20b3
	ldy	SlinkyData
	sty	$20b4
	ldy	SlinkyData
	sty	$20b5
	ldy	SlinkyData
	sty	$20b6
	ldy	SlinkyData
	sty	$20b7
	ldy	SlinkyData
	sty	$20b8
	ldy	SlinkyData
	sty	$20b9
	ldy	SlinkyData
	sty	$20ba
	ldy	SlinkyData
	sty	$20bb
	ldy	SlinkyData
	sty	$20bc
	ldy	SlinkyData
	sty	$20bd
	ldy	SlinkyData
	sty	$20be
	ldy	SlinkyData
	sty	$20bf
	ldy	SlinkyData
	sty	$20c0
	ldy	SlinkyData
	sty	$20c1
	ldy	SlinkyData
	sty	$20c2
	ldy	SlinkyData
	sty	$20c3
	ldy	SlinkyData
	sty	$20c4
	ldy	SlinkyData
	sty	$20c5
	ldy	SlinkyData
	sty	$20c6
	ldy	SlinkyData
	sty	$20c7
	ldy	SlinkyData
	sty	$20c8
	ldy	SlinkyData
	sty	$20c9
	ldy	SlinkyData
	sty	$20ca
	ldy	SlinkyData
	sty	$20cb
	ldy	SlinkyData
	sty	$20cc
	ldy	SlinkyData
	sty	$20cd
	ldy	SlinkyData
	sty	$20ce
	ldy	SlinkyData
	sty	$20cf
	rts


MoveLine5:
	ldy	SlinkyData
	sty	$20d0
	ldy	SlinkyData
	sty	$20d1
	ldy	SlinkyData
	sty	$20d2
	ldy	SlinkyData
	sty	$20d3
	ldy	SlinkyData
	sty	$20d4
	ldy	SlinkyData
	sty	$20d5
	ldy	SlinkyData
	sty	$20d6
	ldy	SlinkyData
	sty	$20d7
	ldy	SlinkyData
	sty	$20d8
	ldy	SlinkyData
	sty	$20d9
	ldy	SlinkyData
	sty	$20da
	ldy	SlinkyData
	sty	$20db
	ldy	SlinkyData
	sty	$20dc
	ldy	SlinkyData
	sty	$20dd
	ldy	SlinkyData
	sty	$20de
	ldy	SlinkyData
	sty	$20df
	ldy	SlinkyData
	sty	$20d0
	ldy	SlinkyData
	sty	$20d1
	ldy	SlinkyData
	sty	$20d2
	ldy	SlinkyData
	sty	$20d3
	ldy	SlinkyData
	sty	$20d4
	ldy	SlinkyData
	sty	$20d5
	ldy	SlinkyData
	sty	$20d6
	ldy	SlinkyData
	sty	$20d7
	ldy	SlinkyData
	sty	$20d8
	ldy	SlinkyData
	sty	$20d9
	ldy	SlinkyData
	sty	$20da
	ldy	SlinkyData
	sty	$20db
	ldy	SlinkyData
	sty	$20dc
	ldy	SlinkyData
	sty	$20dd
	ldy	SlinkyData
	sty	$20de
	ldy	SlinkyData
	sty	$20df
	ldy	SlinkyData
	sty	$20d0
	ldy	SlinkyData
	sty	$20d1
	ldy	SlinkyData
	sty	$20d2
	ldy	SlinkyData
	sty	$20d3
	ldy	SlinkyData
	sty	$20d4
	ldy	SlinkyData
	sty	$20d5
	ldy	SlinkyData
	sty	$20d6
	ldy	SlinkyData
	sty	$20d7
	rts


NextPage:
	; inc zp = 5 cycles
	; ldy zp = 3 cycles
	; sty abs = 4 cycles * 40 = 960
	; rts = 6 cycles
	; total 974

	inc	LoadPage
	ldy	LoadPage
	sty	MoveLine0+5
	sty	MoveLine0+11
	sty	MoveLine0+17
	sty	MoveLine0+23
	sty	MoveLine0+29
	sty	MoveLine0+35
	sty	MoveLine0+41
	sty	MoveLine0+47
	sty	MoveLine0+53
	sty	MoveLine0+59
	sty	MoveLine0+65
	sty	MoveLine0+71
	sty	MoveLine0+77
	sty	MoveLine0+83
	sty	MoveLine0+89
	sty	MoveLine0+95
	sty	MoveLine0+101
	sty	MoveLine0+107
	sty	MoveLine0+113
	sty	MoveLine0+119
	sty	MoveLine0+125
	sty	MoveLine0+131
	sty	MoveLine0+137
	sty	MoveLine0+143
	sty	MoveLine0+149
	sty	MoveLine0+155
	sty	MoveLine0+161
	sty	MoveLine0+167
	sty	MoveLine0+173
	sty	MoveLine0+179
	sty	MoveLine0+185
	sty	MoveLine0+191
	sty	MoveLine0+197
	sty	MoveLine0+203
	sty	MoveLine0+209
	sty	MoveLine0+215
	sty	MoveLine0+221
	sty	MoveLine0+227
	sty	MoveLine0+233
	sty	MoveLine0+239

	sty	MoveLine1+5
	sty	MoveLine1+11
	sty	MoveLine1+17
	sty	MoveLine1+23
	sty	MoveLine1+29
	sty	MoveLine1+35
	sty	MoveLine1+41
	sty	MoveLine1+47
	sty	MoveLine1+53
	sty	MoveLine1+59
	sty	MoveLine1+65
	sty	MoveLine1+71
	sty	MoveLine1+77
	sty	MoveLine1+83
	sty	MoveLine1+89
	sty	MoveLine1+95
	sty	MoveLine1+101
	sty	MoveLine1+107
	sty	MoveLine1+113
	sty	MoveLine1+119
	sty	MoveLine1+125
	sty	MoveLine1+131
	sty	MoveLine1+137
	sty	MoveLine1+143
	sty	MoveLine1+149
	sty	MoveLine1+155
	sty	MoveLine1+161
	sty	MoveLine1+167
	sty	MoveLine1+173
	sty	MoveLine1+179
	sty	MoveLine1+185
	sty	MoveLine1+191
	sty	MoveLine1+197
	sty	MoveLine1+203
	sty	MoveLine1+209
	sty	MoveLine1+215
	sty	MoveLine1+221
	sty	MoveLine1+227
	sty	MoveLine1+233
	sty	MoveLine1+239

	sty	MoveLine2+5
	sty	MoveLine2+11
	sty	MoveLine2+17
	sty	MoveLine2+23
	sty	MoveLine2+29
	sty	MoveLine2+35
	sty	MoveLine2+41
	sty	MoveLine2+47
	sty	MoveLine2+53
	sty	MoveLine2+59
	sty	MoveLine2+65
	sty	MoveLine2+71
	sty	MoveLine2+77
	sty	MoveLine2+83
	sty	MoveLine2+89
	sty	MoveLine2+95
	sty	MoveLine2+101
	sty	MoveLine2+107
	sty	MoveLine2+113
	sty	MoveLine2+119
	sty	MoveLine2+125
	sty	MoveLine2+131
	sty	MoveLine2+137
	sty	MoveLine2+143
	sty	MoveLine2+149
	sty	MoveLine2+155
	sty	MoveLine2+161
	sty	MoveLine2+167
	sty	MoveLine2+173
	sty	MoveLine2+179
	sty	MoveLine2+185
	sty	MoveLine2+191
	sty	MoveLine2+197
	sty	MoveLine2+203
	sty	MoveLine2+209
	sty	MoveLine2+215
	sty	MoveLine2+221
	sty	MoveLine2+227
	sty	MoveLine2+233
	sty	MoveLine2+239

	sty	MoveLine3+5
	sty	MoveLine3+11
	sty	MoveLine3+17
	sty	MoveLine3+23
	sty	MoveLine3+29
	sty	MoveLine3+35
	sty	MoveLine3+41
	sty	MoveLine3+47
	sty	MoveLine3+53
	sty	MoveLine3+59
	sty	MoveLine3+65
	sty	MoveLine3+71
	sty	MoveLine3+77
	sty	MoveLine3+83
	sty	MoveLine3+89
	sty	MoveLine3+95
	sty	MoveLine3+101
	sty	MoveLine3+107
	sty	MoveLine3+113
	sty	MoveLine3+119
	sty	MoveLine3+125
	sty	MoveLine3+131
	sty	MoveLine3+137
	sty	MoveLine3+143
	sty	MoveLine3+149
	sty	MoveLine3+155
	sty	MoveLine3+161
	sty	MoveLine3+167
	sty	MoveLine3+173
	sty	MoveLine3+179
	sty	MoveLine3+185
	sty	MoveLine3+191
	sty	MoveLine3+197
	sty	MoveLine3+203
	sty	MoveLine3+209
	sty	MoveLine3+215
	sty	MoveLine3+221
	sty	MoveLine3+227
	sty	MoveLine3+233
	sty	MoveLine3+239

	sty	MoveLine4+5
	sty	MoveLine4+11
	sty	MoveLine4+17
	sty	MoveLine4+23
	sty	MoveLine4+29
	sty	MoveLine4+35
	sty	MoveLine4+41
	sty	MoveLine4+47
	sty	MoveLine4+53
	sty	MoveLine4+59
	sty	MoveLine4+65
	sty	MoveLine4+71
	sty	MoveLine4+77
	sty	MoveLine4+83
	sty	MoveLine4+89
	sty	MoveLine4+95
	sty	MoveLine4+101
	sty	MoveLine4+107
	sty	MoveLine4+113
	sty	MoveLine4+119
	sty	MoveLine4+125
	sty	MoveLine4+131
	sty	MoveLine4+137
	sty	MoveLine4+143
	sty	MoveLine4+149
	sty	MoveLine4+155
	sty	MoveLine4+161
	sty	MoveLine4+167
	sty	MoveLine4+173
	sty	MoveLine4+179
	sty	MoveLine4+185
	sty	MoveLine4+191
	sty	MoveLine4+197
	sty	MoveLine4+203
	sty	MoveLine4+209
	sty	MoveLine4+215
	sty	MoveLine4+221
	sty	MoveLine4+227
	sty	MoveLine4+233
	sty	MoveLine4+239

	sty	MoveLine5+5
	sty	MoveLine5+11
	sty	MoveLine5+17
	sty	MoveLine5+23
	sty	MoveLine5+29
	sty	MoveLine5+35
	sty	MoveLine5+41
	sty	MoveLine5+47
	sty	MoveLine5+53
	sty	MoveLine5+59
	sty	MoveLine5+65
	sty	MoveLine5+71
	sty	MoveLine5+77
	sty	MoveLine5+83
	sty	MoveLine5+89
	sty	MoveLine5+95
	sty	MoveLine5+101
	sty	MoveLine5+107
	sty	MoveLine5+113
	sty	MoveLine5+119
	sty	MoveLine5+125
	sty	MoveLine5+131
	sty	MoveLine5+137
	sty	MoveLine5+143
	sty	MoveLine5+149
	sty	MoveLine5+155
	sty	MoveLine5+161
	sty	MoveLine5+167
	sty	MoveLine5+173
	sty	MoveLine5+179
	sty	MoveLine5+185
	sty	MoveLine5+191
	sty	MoveLine5+197
	sty	MoveLine5+203
	sty	MoveLine5+209
	sty	MoveLine5+215
	sty	MoveLine5+221
	sty	MoveLine5+227
	sty	MoveLine5+233
	sty	MoveLine5+239

	rts



