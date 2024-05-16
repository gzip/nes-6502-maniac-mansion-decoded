.PATCH $40010                ; empty bank 17
  .dsb $4000, $FF

.PATCH $7C010                ; empty bank 31
  .dsb $4000, $FF

;.PATCH $44010                ; start at bank 31
;  .incbin "empty_banks.dat"  ; 14 banks worth of $FF
