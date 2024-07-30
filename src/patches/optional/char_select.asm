
; tiles $FA thru $FE
.PATCH $59D50
  .incbin "corners.chr"

.PATCH $B690
  .data $FA

.PATCH $B6AB
  .data $FB

.PATCH $B834
  .data $FC

.PATCH $B84F
  .data $FD

.PATCH $295E7
  .data $FE