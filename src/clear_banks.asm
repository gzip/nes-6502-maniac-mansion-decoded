.PATCH $04
  .byte $20                  ; 32 banks SUROM, was 16 SNROM

.PATCH $44010                ; start at bank 17
  .incbin "empty_banks.dat"  ; 14 banks worth of $FF
