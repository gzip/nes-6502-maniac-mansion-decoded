; patch tiles table to point to new uncompressed tiles

.PATCH $3DC05
.data $01, $62, $00, $80 ; tiles entry $00
.data $01, $9E, $20, $86 ; tiles entry $01
.data $01, $9E, $00, $90 ; tiles entry $02
.data $01, $9E, $E0, $99 ; tiles entry $03
.data $01, $9E, $C0, $A3 ; tiles entry $04
.data $01, $9E, $A0, $AD ; tiles entry $05
.data $02, $9E, $00, $80 ; tiles entry $06
.data $02, $9E, $E0, $89 ; tiles entry $07
.data $02, $9E, $C0, $93 ; tiles entry $08
.data $02, $9E, $A0, $9D ; tiles entry $09
.data $02, $9E, $80, $A7 ; tiles entry $0A
.data $02, $9E, $60, $B1 ; tiles entry $0B
.data $03, $9E, $00, $80 ; tiles entry $0C
.data $03, $9E, $E0, $89 ; tiles entry $0D
.data $03, $9E, $C0, $93 ; tiles entry $0E
.data $03, $9E, $A0, $9D ; tiles entry $0F
.data $03, $9E, $80, $A7 ; tiles entry $10
.data $03, $9E, $60, $B1 ; tiles entry $11
.data $04, $9E, $00, $80 ; tiles entry $12
.data $04, $9E, $E0, $89 ; tiles entry $13
.data $04, $9E, $C0, $93 ; tiles entry $14
.data $04, $9E, $A0, $9D ; tiles entry $15
.data $04, $9E, $80, $A7 ; tiles entry $16
.data $04, $9E, $60, $B1 ; tiles entry $17
.data $05, $9E, $00, $80 ; tiles entry $18
.data $05, $9E, $E0, $89 ; tiles entry $19
.data $05, $9E, $C0, $93 ; tiles entry $1A
.data $05, $9E, $A0, $9D ; tiles entry $1B
.data $05, $9E, $80, $A7 ; tiles entry $1C
.data $05, $9E, $60, $B1 ; tiles entry $1D
.data $06, $9E, $00, $80 ; tiles entry $1E
.data $06, $9E, $E0, $89 ; tiles entry $1F
.data $06, $9E, $C0, $93 ; tiles entry $20
.data $06, $9E, $A0, $9D ; tiles entry $21
.data $06, $9E, $80, $A7 ; tiles entry $22
.data $06, $9E, $60, $B1 ; tiles entry $23
.data $07, $9E, $00, $80 ; tiles entry $24
.data $07, $9E, $E0, $89 ; tiles entry $25
.data $07, $9E, $C0, $93 ; tiles entry $26
.data $07, $9E, $A0, $9D ; tiles entry $27

.PATCH $3DD95
.data $07, $00, $80, $A7 ; sprites entry $64
.data $08, $00, $00, $80 ; sprites entry $65