; Apple clock is 1020484.32 hz
; 85040.36 cycles per frame for 12fps
; max 442.92 cycles per line
; max 11 cycles per byte.

; Addresses for slot 1
SlinkyAddr := $C090
SlinkyData := $C093

LineFlags := $C0
LoadPage  := $FF
TempCounter := $FE

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
@1:	sta	$2000,y		; hi-res page 1
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


@2:	sta	$4000,y		; hi-res page 2
	sta	$4100,y
	sta	$4200,y
	sta	$4300,y
	sta	$4400,y
	sta	$4500,y
	sta	$4600,y
	sta	$4700,y
	sta	$4800,y
	sta	$4900,y
	sta	$4a00,y
	sta	$4b00,y
	sta	$4c00,y
	sta	$4d00,y
	sta	$4e00,y
	sta	$4f00,y
	sta	$5000,y
	sta	$5100,y
	sta	$5200,y
	sta	$5300,y
	sta	$5400,y
	sta	$5500,y
	sta	$5600,y
	sta	$5700,y
	sta	$5800,y
	sta	$5900,y
	sta	$5a00,y
	sta	$5b00,y
	sta	$5c00,y
	sta	$5d00,y
	sta	$5e00,y
	sta	$5f00,y
	iny
	bne	@2


; Also clear the bottom 4 lines of both text pages
; and set up "PAUSED!" message

@3:	ldy	#40
	lda	Message1,y
	sta	$0750,y	
	sta	$0B50,y	

	lda	Message2,y
	sta	$0780,y	
	sta	$0B80,y	

	lda	Message3,y
	sta	$07A8,y	
	sta	$0BA8,y	

	lda	Message4,y
	sta	$07D0,y
	sta	$0BD0,y	

	dey	
	bpl	@3


SetHGR:
	sta	SwGraph
	sta	SwHGR
	sta	SwFullScrn
	sta	SwPage2		; display pg2 since drawing on pg1 first

	lda	#$20		; get ready to load pg 1
	sta	LoadPage

NextFrame:
	; First two bytes of frame are lenth
	; $FFFF = end of file
	
	; 13 cycles to check for EOF

	lda	SlinkyData	; check for two $FF = EOF 	4
	and	SlinkyData	; 4
	cmp	#$ff		; 2
	bne	@1		; 2/3

	; got length $FFFF = end of file, exit
	rts			; 6


	; load 24 flag bytes from card
	; 7 cycles per byte * 24 = 168 cycles	
@1:	lda	SlinkyData	; 4
	sta	LineFlags	; 3	
	lda	SlinkyData	; 4
	sta	LineFlags+1	; 3	
	lda	SlinkyData	; 4
	sta	LineFlags+2	; 3	
	lda	SlinkyData	; 4
	sta	LineFlags+3	; 3	
	lda	SlinkyData	; 4
	sta	LineFlags+4	; 3	
	lda	SlinkyData	; 4
	sta	LineFlags+5	; 3	
	lda	SlinkyData	; 4
	sta	LineFlags+6	; 3	
	lda	SlinkyData	; 4
	sta	LineFlags+7	; 3	
	lda	SlinkyData	; 4
	sta	LineFlags+8	; 3	
	lda	SlinkyData	; 4
	sta	LineFlags+9	; 3	
	lda	SlinkyData	; 4
	sta	LineFlags+10	; 3	
	lda	SlinkyData	; 4
	sta	LineFlags+11	; 3	
	lda	SlinkyData	; 4
	sta	LineFlags+12	; 3	
	lda	SlinkyData	; 4
	sta	LineFlags+13	; 3	
	lda	SlinkyData	; 4
	sta	LineFlags+14	; 3	
	lda	SlinkyData	; 4
	sta	LineFlags+15	; 3	
	lda	SlinkyData	; 4
	sta	LineFlags+16	; 3	
	lda	SlinkyData	; 4
	sta	LineFlags+17	; 3	
	lda	SlinkyData	; 4
	sta	LineFlags+18	; 3	
	lda	SlinkyData	; 4
	sta	LineFlags+19	; 3	
	lda	SlinkyData	; 4
	sta	LineFlags+20	; 3	
	lda	SlinkyData	; 4
	sta	LineFlags+21	; 3	
	lda	SlinkyData	; 4
	sta	LineFlags+22	; 3	
	lda	SlinkyData	; 4
	sta	LineFlags+23	; 3	


	; now start moving data

	; 14 cycles per line + 37 every 24 lines
	; 2984 cycles per frame = 15.5 cycles per line
	; unrolled 
	; now 2688 cycles; saved 296 = 14 cycles per line

MainLoop:
	ldy	#$00		;2
	rol	LineFlags+0	;5	
	jsr	MoveLine	;6

;	ldy	#$28		;2
	rol	LineFlags+0	;5	
	jsr	MoveLine	;6

;	ldy	#$50		;2
	rol	LineFlags+0	;5	
	jsr	MoveLine	;6

	ldy	#$80		;2
	rol	LineFlags+0	;5	
	jsr	MoveLine	;6

;	ldy	#$a8		;2
	rol	LineFlags+0	;5	
	jsr	MoveLine	;6

;	ldy	#$d0		;2
	rol	LineFlags+0	;5	
	jsr	MoveLine	;6

	jsr	NextPage	;6

	ldy	#$00		;2
	rol	LineFlags+0	;5	
	jsr	MoveLine	;6

;	ldy	#$28		;2
	rol	LineFlags+0	;5	
	jsr	MoveLine	;6

;	ldy	#$50		;2
	rol	LineFlags+1	;5	
	jsr	MoveLine	;6

	ldy	#$80		;2
	rol	LineFlags+1	;5	
	jsr	MoveLine	;6

;	ldy	#$a8		;2
	rol	LineFlags+1	;5	
	jsr	MoveLine	;6

;	ldy	#$d0		;2
	rol	LineFlags+1	;5	
	jsr	MoveLine	;6

	jsr	NextPage	;6

	ldy	#$00		;2
	rol	LineFlags+1	;5	
	jsr	MoveLine	;6

;	ldy	#$28		;2
	rol	LineFlags+1	;5	
	jsr	MoveLine	;6

;	ldy	#$50		;2
	rol	LineFlags+1	;5	
	jsr	MoveLine	;6

	ldy	#$80		;2
	rol	LineFlags+1	;5	
	jsr	MoveLine	;6

;	ldy	#$a8		;2
	rol	LineFlags+2	;5	
	jsr	MoveLine	;6

;	ldy	#$d0		;2
	rol	LineFlags+2	;5	
	jsr	MoveLine	;6

	jsr	NextPage	;6

	ldy	#$00		;2
	rol	LineFlags+2	;5	
	jsr	MoveLine	;6

;	ldy	#$28		;2
	rol	LineFlags+2	;5	
	jsr	MoveLine	;6

;	ldy	#$50		;2
	rol	LineFlags+2	;5	
	jsr	MoveLine	;6

	ldy	#$80		;2
	rol	LineFlags+2	;5	
	jsr	MoveLine	;6

;	ldy	#$a8		;2
	rol	LineFlags+2	;5	
	jsr	MoveLine	;6

;	ldy	#$d0		;2
	rol	LineFlags+2	;5	
	jsr	MoveLine	;6

	jsr	NextPage	;6


	ldy	#$00		;2
	rol	LineFlags+3	;5	
	jsr	MoveLine	;6

;	ldy	#$28		;2
	rol	LineFlags+3	;5	
	jsr	MoveLine	;6

;	ldy	#$50		;2
	rol	LineFlags+3	;5	
	jsr	MoveLine	;6

	ldy	#$80		;2
	rol	LineFlags+3	;5	
	jsr	MoveLine	;6

;	ldy	#$a8		;2
	rol	LineFlags+3	;5	
	jsr	MoveLine	;6

;	ldy	#$d0		;2
	rol	LineFlags+3	;5	
	jsr	MoveLine	;6

	jsr	NextPage	;6

	ldy	#$00		;2
	rol	LineFlags+3	;5	
	jsr	MoveLine	;6

;	ldy	#$28		;2
	rol	LineFlags+3	;5	
	jsr	MoveLine	;6

;	ldy	#$50		;2
	rol	LineFlags+4	;5	
	jsr	MoveLine	;6

	ldy	#$80		;2
	rol	LineFlags+4	;5	
	jsr	MoveLine	;6

;	ldy	#$a8		;2
	rol	LineFlags+4	;5	
	jsr	MoveLine	;6

;	ldy	#$d0		;2
	rol	LineFlags+4	;5	
	jsr	MoveLine	;6

	jsr	NextPage	;6

	ldy	#$00		;2
	rol	LineFlags+4	;5	
	jsr	MoveLine	;6

;	ldy	#$28		;2
	rol	LineFlags+4	;5	
	jsr	MoveLine	;6

;	ldy	#$50		;2
	rol	LineFlags+4	;5	
	jsr	MoveLine	;6

	ldy	#$80		;2
	rol	LineFlags+4	;5	
	jsr	MoveLine	;6

;	ldy	#$a8		;2
	rol	LineFlags+5	;5	
	jsr	MoveLine	;6

;	ldy	#$d0		;2
	rol	LineFlags+5	;5	
	jsr	MoveLine	;6

	jsr	NextPage	;6

	ldy	#$00		;2
	rol	LineFlags+5	;5	
	jsr	MoveLine	;6

;	ldy	#$28		;2
	rol	LineFlags+5	;5	
	jsr	MoveLine	;6

;	ldy	#$50		;2
	rol	LineFlags+5	;5	
	jsr	MoveLine	;6

	ldy	#$80		;2
	rol	LineFlags+5	;5	
	jsr	MoveLine	;6

;	ldy	#$a8		;2
	rol	LineFlags+5	;5	
	jsr	MoveLine	;6

;	ldy	#$d0		;2
	rol	LineFlags+5	;5	
	jsr	MoveLine	;6

	jsr	NextPage	;6

	ldy	#$00		;2
	rol	LineFlags+6	;5	
	jsr	MoveLine	;6

;	ldy	#$28		;2
	rol	LineFlags+6	;5	
	jsr	MoveLine	;6

;	ldy	#$50		;2
	rol	LineFlags+6	;5	
	jsr	MoveLine	;6

	ldy	#$80		;2
	rol	LineFlags+6	;5	
	jsr	MoveLine	;6

;	ldy	#$a8		;2
	rol	LineFlags+6	;5	
	jsr	MoveLine	;6

;	ldy	#$d0		;2
	rol	LineFlags+6	;5	
	jsr	MoveLine	;6

	jsr	NextPage	;6

	ldy	#$00		;2
	rol	LineFlags+6	;5	
	jsr	MoveLine	;6

;	ldy	#$28		;2
	rol	LineFlags+6	;5	
	jsr	MoveLine	;6

;	ldy	#$50		;2
	rol	LineFlags+7	;5	
	jsr	MoveLine	;6

	ldy	#$80		;2
	rol	LineFlags+7	;5	
	jsr	MoveLine	;6

;	ldy	#$a8		;2
	rol	LineFlags+7	;5	
	jsr	MoveLine	;6

;	ldy	#$d0		;2
	rol	LineFlags+7	;5	
	jsr	MoveLine	;6

	jsr	NextPage	;6

	ldy	#$00		;2
	rol	LineFlags+7	;5	
	jsr	MoveLine	;6

;	ldy	#$28		;2
	rol	LineFlags+7	;5	
	jsr	MoveLine	;6

;	ldy	#$50		;2
	rol	LineFlags+7	;5	
	jsr	MoveLine	;6

	ldy	#$80		;2
	rol	LineFlags+7	;5	
	jsr	MoveLine	;6

;	ldy	#$a8		;2
	rol	LineFlags+8	;5	
	jsr	MoveLine	;6

;	ldy	#$d0		;2
	rol	LineFlags+8	;5	
	jsr	MoveLine	;6

	jsr	NextPage	;6

	ldy	#$00		;2
	rol	LineFlags+8	;5	
	jsr	MoveLine	;6

;	ldy	#$28		;2
	rol	LineFlags+8	;5	
	jsr	MoveLine	;6

;	ldy	#$50		;2
	rol	LineFlags+8	;5	
	jsr	MoveLine	;6

	ldy	#$80		;2
	rol	LineFlags+8	;5	
	jsr	MoveLine	;6

;	ldy	#$a8		;2
	rol	LineFlags+8	;5	
	jsr	MoveLine	;6

;	ldy	#$d0		;2
	rol	LineFlags+8	;5	
	jsr	MoveLine	;6

	jsr	NextPage	;6

	ldy	#$00		;2
	rol	LineFlags+9	;5	
	jsr	MoveLine	;6

;	ldy	#$28		;2
	rol	LineFlags+9	;5	
	jsr	MoveLine	;6

;	ldy	#$50		;2
	rol	LineFlags+9	;5	
	jsr	MoveLine	;6

	ldy	#$80		;2
	rol	LineFlags+9	;5	
	jsr	MoveLine	;6

;	ldy	#$a8		;2
	rol	LineFlags+9	;5	
	jsr	MoveLine	;6

;	ldy	#$d0		;2
	rol	LineFlags+9	;5	
	jsr	MoveLine	;6

	jsr	NextPage	;6

	ldy	#$00		;2
	rol	LineFlags+9	;5	
	jsr	MoveLine	;6

;	ldy	#$28		;2
	rol	LineFlags+9	;5	
	jsr	MoveLine	;6

;	ldy	#$50		;2
	rol	LineFlags+10	;5	
	jsr	MoveLine	;6

	ldy	#$80		;2
	rol	LineFlags+10	;5	
	jsr	MoveLine	;6

;	ldy	#$a8		;2
	rol	LineFlags+10	;5	
	jsr	MoveLine	;6

;	ldy	#$d0		;2
	rol	LineFlags+10	;5	
	jsr	MoveLine	;6

	jsr	NextPage	;6

	ldy	#$00		;2
	rol	LineFlags+10	;5	
	jsr	MoveLine	;6

;	ldy	#$28		;2
	rol	LineFlags+10	;5	
	jsr	MoveLine	;6

;	ldy	#$50		;2
	rol	LineFlags+10	;5	
	jsr	MoveLine	;6

	ldy	#$80		;2
	rol	LineFlags+10	;5	
	jsr	MoveLine	;6

;	ldy	#$a8		;2
	rol	LineFlags+11	;5	
	jsr	MoveLine	;6

;	ldy	#$d0		;2
	rol	LineFlags+11	;5	
	jsr	MoveLine	;6

	jsr	NextPage	;6

	ldy	#$00		;2
	rol	LineFlags+11	;5	
	jsr	MoveLine	;6

;	ldy	#$28		;2
	rol	LineFlags+11	;5	
	jsr	MoveLine	;6

;	ldy	#$50		;2
	rol	LineFlags+11	;5	
	jsr	MoveLine	;6

	ldy	#$80		;2
	rol	LineFlags+11	;5	
	jsr	MoveLine	;6

;	ldy	#$a8		;2
	rol	LineFlags+11	;5	
	jsr	MoveLine	;6

;	ldy	#$d0		;2
	rol	LineFlags+11	;5	
	jsr	MoveLine	;6

	jsr	NextPage	;6

	ldy	#$00		;2
	rol	LineFlags+12	;5	
	jsr	MoveLine	;6

;	ldy	#$28		;2
	rol	LineFlags+12	;5	
	jsr	MoveLine	;6

;	ldy	#$50		;2
	rol	LineFlags+12	;5	
	jsr	MoveLine	;6

	ldy	#$80		;2
	rol	LineFlags+12	;5	
	jsr	MoveLine	;6

;	ldy	#$a8		;2
	rol	LineFlags+12	;5	
	jsr	MoveLine	;6

;	ldy	#$d0		;2
	rol	LineFlags+12	;5	
	jsr	MoveLine	;6

	jsr	NextPage	;6

	ldy	#$00		;2
	rol	LineFlags+12	;5	
	jsr	MoveLine	;6

;	ldy	#$28		;2
	rol	LineFlags+12	;5	
	jsr	MoveLine	;6

;	ldy	#$50		;2
	rol	LineFlags+13	;5	
	jsr	MoveLine	;6

	ldy	#$80		;2
	rol	LineFlags+13	;5	
	jsr	MoveLine	;6

;	ldy	#$a8		;2
	rol	LineFlags+13	;5	
	jsr	MoveLine	;6

;	ldy	#$d0		;2
	rol	LineFlags+13	;5	
	jsr	MoveLine	;6

	jsr	NextPage	;6

	ldy	#$00		;2
	rol	LineFlags+13	;5	
	jsr	MoveLine	;6

;	ldy	#$28		;2
	rol	LineFlags+13	;5	
	jsr	MoveLine	;6

;	ldy	#$50		;2
	rol	LineFlags+13	;5	
	jsr	MoveLine	;6

	ldy	#$80		;2
	rol	LineFlags+13	;5	
	jsr	MoveLine	;6

;	ldy	#$a8		;2
	rol	LineFlags+14	;5	
	jsr	MoveLine	;6

;	ldy	#$d0		;2
	rol	LineFlags+14	;5	
	jsr	MoveLine	;6

	jsr	NextPage	;6

	ldy	#$00		;2
	rol	LineFlags+14	;5	
	jsr	MoveLine	;6

;	ldy	#$28		;2
	rol	LineFlags+14	;5	
	jsr	MoveLine	;6

;	ldy	#$50		;2
	rol	LineFlags+14	;5	
	jsr	MoveLine	;6

	ldy	#$80		;2
	rol	LineFlags+14	;5	
	jsr	MoveLine	;6

;	ldy	#$a8		;2
	rol	LineFlags+14	;5	
	jsr	MoveLine	;6

;	ldy	#$d0		;2
	rol	LineFlags+14	;5	
	jsr	MoveLine	;6

	jsr	NextPage	;6

	ldy	#$00		;2
	rol	LineFlags+15	;5	
	jsr	MoveLine	;6

;	ldy	#$28		;2
	rol	LineFlags+15	;5	
	jsr	MoveLine	;6

;	ldy	#$50		;2
	rol	LineFlags+15	;5	
	jsr	MoveLine	;6

	ldy	#$80		;2
	rol	LineFlags+15	;5	
	jsr	MoveLine	;6

;	ldy	#$a8		;2
	rol	LineFlags+15	;5	
	jsr	MoveLine	;6

;	ldy	#$d0		;2
	rol	LineFlags+15	;5	
	jsr	MoveLine	;6

	jsr	NextPage	;6

	ldy	#$00		;2
	rol	LineFlags+15	;5	
	jsr	MoveLine	;6

;	ldy	#$28		;2
	rol	LineFlags+15	;5	
	jsr	MoveLine	;6

;	ldy	#$50		;2
	rol	LineFlags+16	;5	
	jsr	MoveLine	;6

	ldy	#$80		;2
	rol	LineFlags+16	;5	
	jsr	MoveLine	;6

;	ldy	#$a8		;2
	rol	LineFlags+16	;5	
	jsr	MoveLine	;6

;	ldy	#$d0		;2
	rol	LineFlags+16	;5	
	jsr	MoveLine	;6

	jsr	NextPage	;6

	ldy	#$00		;2
	rol	LineFlags+16	;5	
	jsr	MoveLine	;6

;	ldy	#$28		;2
	rol	LineFlags+16	;5	
	jsr	MoveLine	;6

;	ldy	#$50		;2
	rol	LineFlags+16	;5	
	jsr	MoveLine	;6

	ldy	#$80		;2
	rol	LineFlags+16	;5	
	jsr	MoveLine	;6

;	ldy	#$a8		;2
	rol	LineFlags+17	;5	
	jsr	MoveLine	;6

;	ldy	#$d0		;2
	rol	LineFlags+17	;5	
	jsr	MoveLine	;6

	jsr	NextPage	;6

	ldy	#$00		;2
	rol	LineFlags+17	;5	
	jsr	MoveLine	;6

;	ldy	#$28		;2
	rol	LineFlags+17	;5	
	jsr	MoveLine	;6

;	ldy	#$50		;2
	rol	LineFlags+17	;5	
	jsr	MoveLine	;6

	ldy	#$80		;2
	rol	LineFlags+17	;5	
	jsr	MoveLine	;6

;	ldy	#$a8		;2
	rol	LineFlags+17	;5	
	jsr	MoveLine	;6

;	ldy	#$d0		;2
	rol	LineFlags+17	;5	
	jsr	MoveLine	;6

	jsr	NextPage	;6

	ldy	#$00		;2
	rol	LineFlags+18	;5	
	jsr	MoveLine	;6

;	ldy	#$28		;2
	rol	LineFlags+18	;5	
	jsr	MoveLine	;6

;	ldy	#$50		;2
	rol	LineFlags+18	;5	
	jsr	MoveLine	;6

	ldy	#$80		;2
	rol	LineFlags+18	;5	
	jsr	MoveLine	;6

;	ldy	#$a8		;2
	rol	LineFlags+18	;5	
	jsr	MoveLine	;6

;	ldy	#$d0		;2
	rol	LineFlags+18	;5	
	jsr	MoveLine	;6

	jsr	NextPage	;6

	ldy	#$00		;2
	rol	LineFlags+18	;5	
	jsr	MoveLine	;6

;	ldy	#$28		;2
	rol	LineFlags+18	;5	
	jsr	MoveLine	;6

;	ldy	#$50		;2
	rol	LineFlags+19	;5	
	jsr	MoveLine	;6

	ldy	#$80		;2
	rol	LineFlags+19	;5	
	jsr	MoveLine	;6

;	ldy	#$a8		;2
	rol	LineFlags+19	;5	
	jsr	MoveLine	;6

;	ldy	#$d0		;2
	rol	LineFlags+19	;5	
	jsr	MoveLine	;6

	jsr	NextPage	;6

	ldy	#$00		;2
	rol	LineFlags+19	;5	
	jsr	MoveLine	;6

;	ldy	#$28		;2
	rol	LineFlags+19	;5	
	jsr	MoveLine	;6

;	ldy	#$50		;2
	rol	LineFlags+19	;5	
	jsr	MoveLine	;6

	ldy	#$80		;2
	rol	LineFlags+19	;5	
	jsr	MoveLine	;6

;	ldy	#$a8		;2
	rol	LineFlags+20	;5	
	jsr	MoveLine	;6

;	ldy	#$d0		;2
	rol	LineFlags+20	;5	
	jsr	MoveLine	;6

	jsr	NextPage	;6

	ldy	#$00		;2
	rol	LineFlags+20	;5	
	jsr	MoveLine	;6

;	ldy	#$28		;2
	rol	LineFlags+20	;5	
	jsr	MoveLine	;6

;	ldy	#$50		;2
	rol	LineFlags+20	;5	
	jsr	MoveLine	;6

	ldy	#$80		;2
	rol	LineFlags+20	;5	
	jsr	MoveLine	;6

;	ldy	#$a8		;2
	rol	LineFlags+20	;5	
	jsr	MoveLine	;6

;	ldy	#$d0		;2
	rol	LineFlags+20	;5	
	jsr	MoveLine	;6

	jsr	NextPage	;6

	ldy	#$00		;2
	rol	LineFlags+21	;5	
	jsr	MoveLine	;6

;	ldy	#$28		;2
	rol	LineFlags+21	;5	
	jsr	MoveLine	;6

;	ldy	#$50		;2
	rol	LineFlags+21	;5	
	jsr	MoveLine	;6

	ldy	#$80		;2
	rol	LineFlags+21	;5	
	jsr	MoveLine	;6

;	ldy	#$a8		;2
	rol	LineFlags+21	;5	
	jsr	MoveLine	;6

;	ldy	#$d0		;2
	rol	LineFlags+21	;5	
	jsr	MoveLine	;6

	jsr	NextPage	;6

	ldy	#$00		;2
	rol	LineFlags+21	;5	
	jsr	MoveLine	;6

;	ldy	#$28		;2
	rol	LineFlags+21	;5	
	jsr	MoveLine	;6

;	ldy	#$50		;2
	rol	LineFlags+22	;5	
	jsr	MoveLine	;6

	ldy	#$80		;2
	rol	LineFlags+22	;5	
	jsr	MoveLine	;6

;	ldy	#$a8		;2
	rol	LineFlags+22	;5	
	jsr	MoveLine	;6

;	ldy	#$d0		;2
	rol	LineFlags+22	;5	
	jsr	MoveLine	;6

	jsr	NextPage	;6

	ldy	#$00		;2
	rol	LineFlags+22	;5	
	jsr	MoveLine	;6

;	ldy	#$28		;2
	rol	LineFlags+22	;5	
	jsr	MoveLine	;6

;	ldy	#$50		;2
	rol	LineFlags+22	;5	
	jsr	MoveLine	;6

	ldy	#$80		;2
	rol	LineFlags+22	;5	
	jsr	MoveLine	;6

;	ldy	#$a8		;2
	rol	LineFlags+23	;5	
	jsr	MoveLine	;6

;	ldy	#$d0		;2
	rol	LineFlags+23	;5	
	jsr	MoveLine	;6

	jsr	NextPage	;6

	ldy	#$00		;2
	rol	LineFlags+23	;5	
	jsr	MoveLine	;6

;	ldy	#$28		;2
	rol	LineFlags+23	;5	
	jsr	MoveLine	;6

;	ldy	#$50		;2
	rol	LineFlags+23	;5	
	jsr	MoveLine	;6

	ldy	#$80		;2
	rol	LineFlags+23	;5	
	jsr	MoveLine	;6

;	ldy	#$a8		;2
	rol	LineFlags+23	;5	
	jsr	MoveLine	;6

;	ldy	#$d0		;2
	rol	LineFlags+23	;5	
	jsr	MoveLine	;6

	jsr	NextPage	;6





; Done drawing frame; flip pages and set up for next frame
;
; 2->1 = 14 cycles
; 1->2 = 15 cycles

	lda	LoadPage	;3
	cmp	#$40		;2
	bne	@2		;2/3
	sta	SwPage1		;4
	jmp	NextFrame	;3
@2:	sta	SwPage2		;4
	jmp	NextFrame	;3


; Load line from slinky memory
; 	enter with lo bite of line addr in Y
;	Carry set to load, clear to copy 
;
; 	101 per loop * 4 = 404 + 14 = 418 per line
;	
MoveLine:
	bcc	CopyLine	;2/3
	clc			;2
	
	ldx	#4		;2
MoveLoop:
	lda	SlinkyData	;4
MoveSta1:
	sta	$2000,y		;5
	lda	SlinkyData	;4
MoveSta2:
	sta	$2001,y		;5
	lda	SlinkyData	;4
MoveSta3:
	sta	$2002,y		;5
	lda	SlinkyData	;4
MoveSta4:
	sta	$2003,y		;5
	lda	SlinkyData	;4
MoveSta5:
	sta	$2004,y		;5
	lda	SlinkyData	;4
MoveSta6:
	sta	$2005,y		;5
	lda	SlinkyData	;4
MoveSta7:
	sta	$2006,y		;5
	lda	SlinkyData	;4
MoveSta8:
	sta	$2007,y		;5
	lda	SlinkyData	;4
MoveSta9:
	sta	$2008,y		;5
	lda	SlinkyData	;4
MoveSta10:
	sta	$2009,y		;5
	tya			;2
	adc	#10		;2
	tay			;2
	dex			;2
	bne	MoveLoop	;3

	rts			;6

; Copy line from other graphics page
; 101 per loop * 4 = 404 + 13 = 413 per line
CopyLine:
	ldx	#4		;2
CopyLoop:
CopyLda1:
	lda	$4000,y		;4	
CopySta1:
	sta	$2000,y		;5
CopyLda2:
	lda	$4001,y		;4
CopySta2:
	sta	$2001,y		;5
CopyLda3:
	lda	$4002,y		;4
CopySta3:
	sta	$2002,y		;5
CopyLda4:
	lda	$4003,y		;4
CopySta4:
	sta	$2003,y		;5
CopyLda5:
	lda	$4004,y		;4
CopySta5:
	sta	$2004,y		;5
CopyLda6:
	lda	$4005,y		;4
CopySta6:
	sta	$2005,y		;5
CopyLda7:
	lda	$4006,y		;4
CopySta7:
	sta	$2006,y		;5
CopyLda8:
	lda	$4007,y		;4
CopySta8:
	sta	$2007,y		;5
CopyLda9:
	lda	$4008,y		;4
CopySta9:
	sta	$2008,y		;5
CopyLda10:
	lda	$4009,y		;4
CopySta10:
	sta	$2009,y		;5
	tya			;2
	adc	#10		;2
	tay			;2
	dex			;2
	bne	CopyLoop	;3
	rts			;6


; Patch addresses in MoveLine for next memory page
; 142/143 cycles every 6 lines = ~24 cycles per line
NextPage:
	lda	LoadPage	;2
	clc			;2
	adc	#1		;2

	cmp	#$60		;2
	bne	@1		;2/3
	lda	#$20		;2

@1:	sta	LoadPage	;3

	sta	MoveSta1+2	;4
	sta	MoveSta2+2	;4
	sta	MoveSta3+2	;4
	sta	MoveSta4+2	;4
	sta	MoveSta5+2	;4
	sta	MoveSta6+2	;4
	sta	MoveSta7+2	;4
	sta	MoveSta8+2	;4
	sta	MoveSta9+2	;4
	sta	MoveSta10+2	;4

	sta	CopySta1+2	;4
	sta	CopySta2+2	;4
	sta	CopySta3+2	;4
	sta	CopySta4+2	;4
	sta	CopySta5+2	;4
	sta	CopySta6+2	;4
	sta	CopySta7+2	;4
	sta	CopySta8+2	;4
	sta	CopySta9+2	;4
	sta	CopySta10+2	;4

	eor	#$60		;2

	sta	CopyLda1+2	;4
	sta	CopyLda2+2	;4
	sta	CopyLda3+2	;4
	sta	CopyLda4+2	;4
	sta	CopyLda5+2	;4
	sta	CopyLda6+2	;4
	sta	CopyLda7+2	;4
	sta	CopyLda8+2	;4
	sta	CopyLda9+2	;4
	sta	CopyLda10+2	;4
		
	rts			;6





Message1:
	.byte "                                        "
Message2:
	.byte "            *** PAUSED! ***             "
Message3:
	.byte "                                        "
Message4:
	.byte " SPACE: PLAY/PAUSE            ESC: EXIT "


