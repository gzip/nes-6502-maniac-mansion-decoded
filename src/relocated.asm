Src_Addr                = $26
Dest_Addr               = $2C
Room_Layout_Metadata    = $63B5
Outer_Bank_Num          = $63D7
Tiles_Table_Index       = $6D3E
Buffer_Index            = $6D3F
Bank_Num                = $6F04
Title_Screen_Write_Byte = $A039
Inc_Addr_F0             = $A164
Tiles_Table             = $DBF5
Get_Bank_Num            = $DF76
Check_If_New_Bank       = $DF85
Load_Tile_Buffer        = $E5A1
Bank_Switch             = $FFA0
Set_MMC1_Control        = $FFB8

;.PATCH 00:9DF0
;Check_For_Outer_Bank:
;  ; check if the second title screen is loading
;  CPX #$04
;  BNE +
;    JSR Set_Outer_Bank_1   ; and switch outer bank if so
;+ LDA $A439,X              ; run hijacked code
;  RTS

;.PATCH 00:9F38               ; in Title_Screen_Set_Base_Addr
;  JSR Check_For_Outer_Bank

;.PATCH 00:9FDD               ; in Title_Screen_Load_Byte
;  JSR Title_Screen_Write_Byte; was BMI Title_Screen_Run
;  JSR Inc_Addr_F0
;  RTS
;  NOP

.PATCH 0F:C1FD               ; in Set_Room_Layout_Addrs:Set_Nametable_Src_Addr
  LDA Room_Layout_Metadata+4
  STA $59
  LDA Room_Layout_Metadata+5
  STA $5A
  NOP
  NOP
  NOP

.PATCH 0F:C20A               ; in Set_Room_Layout_Addrs:Set_Attr_Table_Src_Addr
  LDA Room_Layout_Metadata+8
  STA $5B
  LDA Room_Layout_Metadata+9
  STA $5C
  NOP
  NOP
  NOP
  NOP
  NOP

.PATCH 0F:D851               ; about to setup nmi
  JSR Store_Bank_And_Switch_Outer

.PATCH 0F:DF95
  JSR Safe_Bank_Switch       ; in Switch_to_New_Bank

.PATCH 0F:DF9F
  JSR Safe_Bank_Switch       ; in Switch_to_New_Bank

.PATCH 0F:E367               ; in nmi
  JMP Reset_Outer_For_Nmi
  Return_To_Nmi:

;.PATCH 0F:E389
;  JSR Safe_Bank_Switch       ; in nmi

;.PATCH 0F:E392
;  JSR Safe_Bank_Switch       ; in nmi

;.PATCH 0F:E3EF
;  JSR Safe_Bank_Switch       ; in nmi

;.PATCH 0F:E3F8
;  JSR Safe_Bank_Switch       ; in nmi

.PATCH 0F:E40C               ; in nmi
  JMP Restore_Outer_After_Nmi; was PHA TAX PHA

.PATCH 0F:E4EF               ; in Load_Nametable_Buffer
  JSR Get_Tables_Bank_Num    ; was Get_Bank_Num

;.PATCH 0F:E547
;  JSR Set_Outer_And_Check_Bank ; was JSR Check_If_New_Bank

; in loadCostumeSet
;.PATCH 0F:EE1A
;  JSR Set_Outer_And_Inner_Banks_Then_Set_Table_Index ; was JSR Check_If_New_Bank

; move the number of tiles into the unused byte in the tiles table
; that way we avoid funny offsets in the tiles data that would complicated editing
;.PATCH 0F:E54F
;  NOP                        ; was LDY #$00
;  LDA Tiles_Table+1,X        ; was LDA (Src_Addr+0),Y

;.PATCH 0F:E589
;  JSR Load_Tile_Buffer_And_Reset_Outer ; was JSR Load_Tile_Buffer

;.PATCH 0F:E597
;  JSR Load_Tile_Buffer_And_Reset_Outer ; was JSR Load_Tile_Buffer

;.PATCH 0F:E511
;  JSR Load_Raw_Byte          ; was Load_RLE_Byte

;.PATCH 0F:E5A1
;  NOP                        ; was LDY #$00
;  JSR Load_Tiles_Count       ; was LDA (Src_Addr+0),Y

; avoid src_addr increment that was needed to bypass tile count (which is now relocated)
;.PATCH 0F:E5AF
;  NOP
;  NOP
;  NOP
;  NOP
;  NOP
;  NOP
;  NOP
;  NOP

;.PATCH 0F:E5D2               ; in Load_Tile_Buffer
;  JSR Load_Raw_Byte          ; was Load_RLE_Byte

;.PATCH 0F:E60F               ; in Load_Tile_Buffer
;  JSR Load_Raw_Byte          ; was Load_RLE_Byte

.PATCH 0F:E632               ; in Load_Room_Palette_Buffer
  JSR Reset_Outer_Get_Bank   ; was Get_Bank_Num

.PATCH 0F:E663               ; in Load_128_Byte_Buffer
  JSR Reset_Outer_Get_Bank   ; was Get_Bank_Num

.PATCH 0F:E6C5               ; in Load_Attribute_Table_Buffer
  JSR Get_Tables_Bank_Num    ; was Get_Bank_Num

;.PATCH 0F:E6F0               ; in Load_Attribute_Table_Buffer
;  JSR Load_Raw_Byte          ; was Load_RLE_Byte

.PATCH 0F:E91D               ; this is all as-is untouched, used for reference
Load_RLE_Byte:
  LDY #$00
  LDA (Src_Addr+0),Y
  BMI Write_RLE_Run
  TAX
  JSR Inc_RLE_Src_Addr
Write_RLE_Repeat:
  LDY #$00
  LDA (Src_Addr+0),Y
  JSR Write_Decompressed_Byte_To_RAM
  DEX
  BNE Write_RLE_Repeat
  JSR Inc_RLE_Src_Addr
  RTS
Write_RLE_Run:
  AND #$7F
  TAX
- JSR Inc_RLE_Src_Addr
  LDY #$00
  LDA (Src_Addr+0),Y
  JSR Write_Decompressed_Byte_To_RAM
  DEX
  BNE -
  JSR Inc_RLE_Src_Addr
  RTS
Write_Decompressed_Byte_To_RAM:
  LDY #$00
  STA (Dest_Addr+0),Y
  INC Dest_Addr+0
  BNE +
  INC Dest_Addr+1
+ INC Buffer_Index
  RTS
Inc_RLE_Src_Addr:
  INC Src_Addr+0
  BNE +
  INC Src_Addr+1
+ RTS

.PATCH 0F:FBCD
;  Load_Raw_Byte:
;    LDY #$00
;    LDA (Src_Addr+0),Y
;    JSR Write_Decompressed_Byte_To_RAM
;    JSR Inc_RLE_Src_Addr
;    RTS
;  Load_Tiles_Count:
;    LDA Room_Layout_Metadata+15
;    RTS
;  Set_Outer_And_Inner_Banks_Then_Set_Table_Index:
;    JSR Set_Outer_And_Check_Bank
;    ; force an index which will write all 256 tiles
;    LDA #$68
;    STA Tiles_Table_Index    ; ends up #$00
;    RTS
  Set_Outer_And_Check_Bank:
    JSR Check_If_New_Bank
    JMP Set_Outer_Bank_1
  Set_Outer_Bank:
    STA Outer_Bank_Num
  Set_Outer_Bank_No_Store:
    JSR Set_CHR_Bank_0
    JMP Set_CHR_Bank_1
  Set_Outer_Bank_0:
    LDA #$00
    JMP Set_Outer_Bank
  Set_Outer_Bank_1:
    LDA #$10
    JMP Set_Outer_Bank
  Set_CHR_Bank_1:
    JSR Clear_Bank_Shift_Register
    STA $C000
    LSR A
    STA $C000
    LSR A
    STA $C000
    LSR A
    STA $C000
    LSR A
    STA $C000
    RTS
;  Load_Tile_Buffer_And_Reset_Outer:
;    JSR Load_Tile_Buffer
;    JMP Set_Outer_Bank_0
  Get_Tables_Bank_Num:
    LDA Room_Layout_Metadata+14
    JMP Set_Outer_And_Check_Bank
  Store_Bank_And_Switch_Outer:
    STA Bank_Num
    JMP Set_Outer_Bank_0
  Reset_Outer_For_Nmi:
    PHA                      ; run hijacked code
    TYA
    PHA
    LDA Outer_Bank_Num
    BEQ +
      LDA #$00
      JSR Set_Outer_Bank_No_Store
  + JMP Return_To_Nmi
  Restore_Outer_After_Nmi:
    LDA Outer_Bank_Num
    BEQ +
      JSR Set_Outer_Bank_No_Store
  + PLA
    TAX
    PLA
    RTI
  Reset_Outer_Get_Bank:
    JSR Set_Outer_Bank_0
    JMP Get_Bank_Num
  Clear_Bank_Shift_Register:
    PHA
    LDA #$80
    STA $C000
    PLA
    RTS
  Safe_Bank_Switch:
    JSR Clear_Bank_Shift_Register
    JMP Bank_Switch

.PATCH 0F:FFD0
  LDA #$FF
  STA $8000
  LDA #$0E
  JSR Set_MMC1_Control
  NOP
  NOP
  NOP
  NOP
  NOP
  NOP
  LDA #$00
  JSR Set_Outer_Bank
  Set_CHR_Bank_0: