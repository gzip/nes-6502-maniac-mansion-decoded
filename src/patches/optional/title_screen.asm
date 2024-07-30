
; tiles
.PATCH $2650
  .incbin title_screen.chr

; nametable
.PATCH $3555
  .incbin title_screen.nam

; attribute table
.PATCH $391A
  .incbin title_screen.attr

; palettes
.PATCH $395B
  .data $1F, $0D, $16, $30
  .data $1F, $27, $30, $0F
  .data $1F, $0D, $16, $28
  .data $1F, $0D, $18, $30
