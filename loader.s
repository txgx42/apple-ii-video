; $C080+slot * 16  low byte of RAM address
; $C081+slot * 16  middle byte of RAM address
; $C082+slot * 16  high byte of RAM address
; $C083+slot * 16  data at addressed location
; $C08F+slot * 16  Firmware Bank Select

; Addresses for slot 1
SlinkyAddr := $C090
SlinkyData := $C093

Buffer 	:=	$6000

BuffPtr	:= 	$FE
LenPtr	:= 	$FC

SlinkySetup:
	lda	#0
	sta	SlinkyAddr
	sta	SlinkyAddr+1
	sta	SlinkyAddr+2
	
	rts

LoadFrame:	
	ldx	#<Buffer
	stx	BuffPtr
	ldx	#>Buffer
	stx	BuffPtr+1


	ldy	#0
	lda	(BuffPtr),y
	sta	LenPtr
	dec	LenPtr
	sta	SlinkyData
	inc	BuffPtr

	lda	(BuffPtr),y
	sta	LenPtr+1
	sta	SlinkyData
	inc	BuffPtr


@1:	lda	(BuffPtr),y
	sta	SlinkyData
	inc	BuffPtr
	bne	@2
	inc	BuffPtr+1
@2:	dec	LenPtr
	ldx	LenPtr
	inx
	bne	@1

	; lo byte is 0, decrement hi bite
	dec	LenPtr+1
	ldx	LenPtr+1
	inx	
	bne	@1
	
	rts	; hibyte is also 0, done


