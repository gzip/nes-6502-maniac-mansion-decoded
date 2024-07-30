
; family portrait nametable
.PATCH $83F4
  .data $36, $39, $39, $39, $39, $39, $37
.PATCH $8410
  .data $3B, $B4, $B5, $B6, $B7, $B8, $40
.PATCH $842C
  .data $3B, $B9, $BA, $BB, $BC, $BD, $40
.PATCH $8448
  .data $3B, $BE, $BF, $C0, $C1, $C2, $40
.PATCH $8464
  .data $3B, $C3, $C4, $C5, $C6, $C7, $40
.PATCH $8480
  .data $3B, $C8, $C9, $CA, $CB, $CC, $40
.PATCH $849C
  .data $CD, $CE, $CE, $CE, $CE, $CE, $CF
.PATCH $84B8
  .data $D0, $D1, $D1, $D1, $D1, $D1, $D2

; attic portrait tiles
.PATCH $49E70
  .incbin fred_painting.chr

; fred portrait tiles
.PATCH $4DF00
  .incbin fred_portrait.chr

; edna portrait tiles
.PATCH $4E450
  .incbin edna_portrait.chr

; family portrait tiles
.PATCH $518F0
  .incbin family_portrait.chr
