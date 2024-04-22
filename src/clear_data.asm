; clear out compressed graphics data

.PATCH 01:8001 ; tiles entry $00
  .dsb $03C9, $FF

.PATCH 01:83CA ; tiles entry $01
  .dsb $069E, $FF

.PATCH 01:8A68 ; tiles entry $02
  .dsb $0327, $FF

.PATCH 01:8D8F ; tiles entry $03
  .dsb $053B, $FF

.PATCH 01:92CA ; tiles entry $04
  .dsb $06BE, $FF

.PATCH 01:9988 ; tiles entry $05
  .dsb $0682, $FF

.PATCH 01:A00A ; tiles entry $06
  .dsb $0778, $FF

.PATCH 01:A782 ; tiles entry $07
  .dsb $0517, $FF

.PATCH 01:AC99 ; tiles entry $08
  .dsb $07FB, $FF

.PATCH 01:B494 ; tiles entry $09
  .dsb $07BE, $FF

.PATCH 02:8001 ; tiles entry $0A
  .dsb $07A5, $FF

.PATCH 02:87A6 ; tiles entry $0B
  .dsb $06DD, $FF

.PATCH 02:8E83 ; tiles entry $0C
  .dsb $04EA, $FF

.PATCH 02:936D ; tiles entry $0D
  .dsb $0846, $FF

.PATCH 02:9BB3 ; tiles entry $0E
  .dsb $08C8, $FF

.PATCH 02:A47B ; tiles entry $0F
  .dsb $0844, $FF

.PATCH 02:ACBF ; tiles entry $10
  .dsb $0515, $FF

.PATCH 02:B1D4 ; tiles entry $11
  .dsb $0799, $FF

.PATCH 02:B96D ; tiles entry $12
  .dsb $04BB, $FF

.PATCH 01:BC52 ; tiles entry $13
  .dsb $0319, $FF

.PATCH 03:8001 ; tiles entry $14
  .dsb $0464, $FF

.PATCH 03:8465 ; tiles entry $15
  .dsb $076D, $FF

.PATCH 03:8BD2 ; tiles entry $16
  .dsb $0827, $FF

.PATCH 03:93F9 ; tiles entry $17
  .dsb $0515, $FF

.PATCH 03:990E ; tiles entry $18
  .dsb $064E, $FF

.PATCH 03:9F5C ; tiles entry $19
  .dsb $0775, $FF

.PATCH 03:A6D1 ; tiles entry $1A
  .dsb $06DD, $FF

.PATCH 03:ADAE ; tiles entry $1B
  .dsb $0376, $FF

.PATCH 03:B124 ; tiles entry $1C
  .dsb $05F7, $FF

.PATCH 03:B71B ; tiles entry $1D
  .dsb $0787, $FF

.PATCH 04:8001 ; tiles entry $1E
  .dsb $02D6, $FF

.PATCH 04:82D7 ; tiles entry $1F
  .dsb $06A3, $FF

.PATCH 04:897A ; tiles entry $20
  .dsb $099F, $FF

.PATCH 04:9319 ; tiles entry $21
  .dsb $0361, $FF

.PATCH 04:967A ; tiles entry $22
  .dsb $0489, $FF

.PATCH 04:9B03 ; tiles entry $23
  .dsb $0437, $FF

.PATCH 04:9F3A ; tiles entry $24
  .dsb $084D, $FF

.PATCH 02:BE28 ; tiles entry $25
  .dsb $0199, $FF

.PATCH 04:A787 ; tiles entry $26
  .dsb $09A7, $FF

.PATCH 04:B12E ; tiles entry $27
  .dsb $037A, $FF

.PATCH 0C:8001 ; tiles entry $28
  .dsb $0EB8, $FF

.PATCH 0B:B9F1 ; tiles entry $29
  .dsb $0340, $FF

.PATCH 00:A701 ; tiles entry $2A
  .dsb $0968, $FF

.PATCH 00:B24D ; tiles entry $2B
  .dsb $0899, $FF


 ; clear out nametable and attribute table data

.PATCH $14132 ; room entry $01
  .dsb $02D9, $FF

.PATCH $13550 ; room entry $02
  .dsb $0164, $FF

.PATCH $15454 ; room entry $03
  .dsb $0262, $FF

.PATCH $15CDE ; room entry $04
  .dsb $025C, $FF

.PATCH $16445 ; room entry $05
  .dsb $030B, $FF

.PATCH $13A13 ; room entry $06
  .dsb $0158, $FF

.PATCH $16D9A ; room entry $07
  .dsb $0274, $FF

.PATCH $180A9 ; room entry $08
  .dsb $02E6, $FF

.PATCH $17B7B ; room entry $09
  .dsb $012C, $FF

.PATCH $18CCA ; room entry $0A
  .dsb $02AB, $FF

.PATCH $19330 ; room entry $0B
  .dsb $016E, $FF

.PATCH $19AE4 ; room entry $0C
  .dsb $0198, $FF

.PATCH $1A1BA ; room entry $0D
  .dsb $0266, $FF

.PATCH $1A6FF ; room entry $0E
  .dsb $0192, $FF

.PATCH $1AB25 ; room entry $0F
  .dsb $0166, $FF

.PATCH $1AF11 ; room entry $10
  .dsb $0121, $FF

.PATCH $1B738 ; room entry $11
  .dsb $0161, $FF

.PATCH $1C0CF ; room entry $12
  .dsb $014F, $FF

.PATCH $1CDD9 ; room entry $13
  .dsb $0187, $FF

.PATCH $1D554 ; room entry $14
  .dsb $0155, $FF

.PATCH $1E003 ; room entry $15
  .dsb $016E, $FF

.PATCH $1E9C6 ; room entry $16
  .dsb $017B, $FF

.PATCH $1EFEF ; room entry $17
  .dsb $0166, $FF

.PATCH $1F6B6 ; room entry $18
  .dsb $017D, $FF

.PATCH $20088 ; room entry $19
  .dsb $014A, $FF

.PATCH $205B7 ; room entry $1A
  .dsb $016D, $FF

.PATCH $21716 ; room entry $1B
  .dsb $0156, $FF

.PATCH $21E56 ; room entry $1C
  .dsb $0195, $FF

.PATCH $22348 ; room entry $1D
  .dsb $0270, $FF

.PATCH $2288A ; room entry $1E
  .dsb $038E, $FF

.PATCH $24077 ; room entry $1F
  .dsb $019A, $FF

.PATCH $23C2B ; room entry $20
  .dsb $032E, $FF

.PATCH $2492D ; room entry $21
  .dsb $02D8, $FF

.PATCH $25B3B ; room entry $22
  .dsb $021A, $FF

.PATCH $1BE09 ; room entry $23
  .dsb $0130, $FF

.PATCH $25E8D ; room entry $24
  .dsb $0151, $FF

.PATCH $262F6 ; room entry $25
  .dsb $030E, $FF

.PATCH $268B7 ; room entry $26
  .dsb $02B2, $FF

.PATCH $1FDCA ; room entry $27
  .dsb $0141, $FF

.PATCH $273E6 ; room entry $28
  .dsb $0161, $FF

.PATCH $276C9 ; room entry $29
  .dsb $0148, $FF

.PATCH $28049 ; room entry $2A
  .dsb $02B6, $FF

.PATCH $2857F ; room entry $2B
  .dsb $C8, $FF

.PATCH $28A29 ; room entry $2C
  .dsb $0159, $FF

.PATCH $2944A ; room entry $2D
  .dsb $014E, $FF

.PATCH $27BAD ; room entry $2E
  .dsb $0176, $FF

.PATCH $2AE29 ; room entry $2F
  .dsb $016B, $FF

.PATCH $2B385 ; room entry $30
  .dsb $01A6, $FF

.PATCH $2B57D ; room entry $31
  .dsb $026B, $FF

.PATCH $2B83E ; room entry $32
  .dsb $017A, $FF

.PATCH $2C077 ; room entry $33
  .dsb $019C, $FF

.PATCH $2BC0C ; room entry $34
  .dsb $015D, $FF

.PATCH $2C582 ; room entry $35
  .dsb $0137, $FF

.PATCH $13E8A ; room entry $36
  .dsb $012A, $FF

.PATCH $3082 ; title entry $37
  .dsb $01E9, $FF

.PATCH $3AFF ; title entry $38
  .dsb $013B, $FF