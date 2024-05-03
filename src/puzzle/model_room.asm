.include scumm_codes.asm
.include object_ids.asm

; initial object states
.PATCH $2CBF8 ; ($2CA21 + $1D7, $660A + $1D7 = $67E1 RAM)
  .data $0F, $0F, $0F, $0F, $0F, $0F, $0F ; objects $01D7-$01DD

; patch room table
.PATCH 0F:DD69 ; 3DD59
  .data $0C, $00, model_room

; clear out the existing room data
.PATCH 0B:853A
  .dsb $0170, $FF

; AT-AT Model room:
.PATCH 0C:8010 ; $30020 (was 0B:853A 2C54A)
model_room:
.base $00
.data end_room_data      ; size in bytes of room data
.data $00, $F9           ; unknown/mmdecoded
.data $1C, $00           ; room width
.data $10                ; room height (was 2 bytes)
.data $03                ; layout bank number (modified for mmdecoded)
.data $A0, $89           ; unknown/nametable address [$C9B0]
.data tile_index_offset  ; tile index offset (+1 starts palettes) should be
.data $C0, $01           ; unknown/attr table offset
.data mask_flag          ; mask flag offset
.data $00, $00           ; unknown
.data $00, $00           ; unknown
.data $07                ; num objects
.data <num_boxes_offset  ; num boxes offset, should be $54
.data $00                ; num sounds (always 0)
.data $00                ; num scripts
.data exit_script        ; exit script offset
.data entry_script       ; entry script offset
                         ; object nametable/attr_table offsets
.data object_at_at_tables, object_at_at_head_tables
.data object_snowspeeder_tables, object_luke_tables, object_tauntaun_tables
.data object_door_left_tables, object_door_right_tables
                         ; object offsets
                         ; luke must come before the at_at to be in front
.data object_snowspeeder, object_luke, object_tauntaun
.data object_at_at, object_at_at_head
.data object_door_left, object_door_right
.data $00, $00, $00, $00 ; unknown
num_boxes_offset:
.data $03                ; num boxes

                         ; boxes (x in tiles, y in pixels)
     ;(uy, ly,  ulx, urx, llx, lrx, mask, flags)
.data $38, $40, $02, $09, $01, $09, $00, $00
.data $3D, $3F, $0A, $16, $0A, $16, $00, $00
.data $38, $3F, $16, $19, $16, $1B, $00, $00
.data $00, $03, $06      ; box matrix offsets
.data $00, $01, $01      ; box matrix
.data $00, $01, $02
.data $01, $01, $02
tile_index_offset:
.data $26                ; tiles entry index
.data $31, $10, $00, $0F ; bg palettes
.data $31, $0D, $11, $21
.data $31, $0D, $17, $28
.data $31, $0D, $18, $30

mask_flag:
.data $00

; object nametable / attribute table updates
object_at_at_tables:
.data $08, $F0, $08, $F0, $08, $F0, $08, $F0, $08, $F0, $08, $F0
.data $08, $F0, $08, $F0, $08, $F0, $08, $F0, $08, $F0, $08, $F0
.data $00, $00, $00, $00, $00, $00
object_at_at_head_tables:
.data $85, $15, $16, $17, $18, $19,  $85, $1A, $1B, $1C, $1D, $1E,  $85, $1F, $20, $21, $22, $23,  $00
object_snowspeeder_tables:
.data $84, $15, $16, $17, $18,  $84, $19, $1A, $1B, $1C,  $00
object_luke_tables:
.data $81, $15, $81, $16,  $00
object_tauntaun_tables:
.data $83, $15, $16, $17,  $83, $18, $19,  $00
object_door_left_tables:
object_door_right_tables:
.data $00


; object AT-AT Model
object_at_at:
               ; size in bytes of object
.data end_object_at_at - object_at_at
.data $00, $00 ; unknown
.data $01D7    ; object number
.data $00      ; unknown
.data $0C      ; x position
.data $03      ; y position + parent state
.data $08      ; width
.data $00      ; parent
.data $10      ; walk to x
.data $10      ; walk to y
               ; height + actor facing dir (0xHHHHHDDD)
.data ($0C << 3) | ACTOR_BACK
               ; offset to object name
.data <(at_at_name - object_at_at)
               ; object script offsets
.data VERB_OPEN,    <(at_at_open - object_at_at)
.data VERB_PUSH,    <(at_at_open - object_at_at)
.data VERB_PULL,    <(at_at_open - object_at_at)
.data VERB_GET,     <(at_at_get  - object_at_at)
.data VERB_WALK_TO, <(at_at_walk - object_at_at)
.data END_VERBS
               ; object name
at_at_name:
.data "AT-AT Model", END_STRING

at_at_open:
.data ACTOR_SAY, "I don't want to break it.", END_STRING, END_SCRIPT

at_at_get:
.data ACTOR_SAY, "I can't fit it in my pocket.", END_STRING, END_SCRIPT

at_at_walk:
.data ACTOR_SAY, "Wow, it's an incredible", LINE_BREAK, "1 to 16 scale model AT-AT!", NEW_LINE, "Someone must really like", LINE_BREAK, "Star Wars!", END_STRING, END_SCRIPT

end_object_at_at:


; object AT-AT Head
object_at_at_head:
               ; size in bytes of object
.data end_object_at_at_head - object_at_at_head
.data $00, $00 ; unknown
.data $01D8    ; object number
.data $00      ; unknown
.data $07      ; x position
.data $05      ; y position + parent state
.data $05      ; width
.data $00      ; parent
.data $09      ; walk to x
.data $0F      ; walk to y
               ; height + actor facing dir (0xHHHHHDDD)
.data ($03 << 3) | ACTOR_BACK
               ; offset to object name
.data <(at_at_head_name - object_at_at_head)
               ; object script offsets
.data VERB_PUSH,     <(at_at_head_get  - object_at_at_head)
.data VERB_PULL,     <(at_at_head_get  - object_at_at_head)
.data VERB_GET,      <(at_at_head_get  - object_at_at_head)
.data VERB_WALK_TO,  <(at_at_head_walk - object_at_at_head)
.data END_VERBS
               ; object name
at_at_head_name:
.data "AT-AT Head", END_STRING

at_at_head_get:
.data ACTOR_SAY, "I can't reach it.", END_STRING, END_SCRIPT

at_at_head_walk:
.data ACTOR_SAY, "I feel like it's looking", LINE_BREAK ,"right at me.", END_STRING, END_SCRIPT

end_object_at_at_head:


; object Snowspeeder
object_snowspeeder:
               ; size in bytes of object
.data end_object_snowspeeder - object_snowspeeder
.data $00, $00 ; unknown
.data $01D9    ; object number
.data $00      ; unknown
.data $05      ; x position
.data $03      ; y position + parent state
.data $04      ; width
.data $00      ; parent
.data $06      ; walk to x
.data $0F      ; walk to y
               ; height + actor facing dir (0xHHHHHDDD)
.data ($02 << 3) | ACTOR_BACK
               ; offset to object name
.data <(object_snowspeeder_name - object_snowspeeder)
               ; object script offsets
.data VERB_PUSH,     <(object_snowspeeder_get  - object_snowspeeder)
.data VERB_PULL,     <(object_snowspeeder_get  - object_snowspeeder)
.data VERB_GET,      <(object_snowspeeder_get  - object_snowspeeder)
.data VERB_WALK_TO,  <(object_snowspeeder_walk - object_snowspeeder)
.data END_VERBS
               ; object name
object_snowspeeder_name:
.data "Snowspeeder", END_STRING

object_snowspeeder_get:
.data ACTOR_SAY, "I wish.", END_STRING, END_SCRIPT

object_snowspeeder_walk:
.data ACTOR_SAY, "One of my favorites!", END_STRING, END_SCRIPT

end_object_snowspeeder:


; object Luke
object_luke:
               ; size in bytes of object
.data end_object_luke - object_luke
.data $00, $00 ; unknown
.data $01DA    ; object number
.data $00      ; unknown
.data $0F      ; x position
.data $0A      ; y position + parent state
.data $01      ; width
.data $00      ; parent
.data $0F      ; walk to x
.data $0F      ; walk to y
               ; height + actor facing dir (0xHHHHHDDD)
.data ($02 << 3) | ACTOR_BACK
               ; offset to object name
.data <(object_luke_name - object_luke)
               ; object script offsets
.data VERB_PUSH,     <(object_luke_get  - object_luke)
.data VERB_PULL,     <(object_luke_get  - object_luke)
.data VERB_GET,      <(object_luke_get  - object_luke)
.data VERB_WALK_TO,  <(object_luke_walk - object_luke)
.data END_VERBS
               ; object name
object_luke_name:
.data "Luke", END_STRING

object_luke_get:
.data ACTOR_SAY, "He'll probably fall off.", END_STRING, END_SCRIPT

object_luke_walk:
.data ACTOR_SAY, "He's about to blow that", LINE_BREAK ,"thing up!", END_STRING, END_SCRIPT

end_object_luke:


; object Tauntaun
object_tauntaun:
               ; size in bytes of object
.data end_object_tauntaun - object_tauntaun
.data $00, $00 ; unknown
.data $01DB    ; object number
.data $00      ; unknown
.data $06      ; x position
.data $0B      ; y position + parent state
.data $03      ; width
.data $00      ; parent
.data $07      ; walk to x
.data $0F      ; walk to y
               ; height + actor facing dir (0xHHHHHDDD)
.data ($03 << 3) | ACTOR_BACK
               ; offset to object name
.data <(object_tauntaun_name - object_tauntaun)
               ; object script offsets
.data VERB_PUSH,     <(object_tauntaun_get  - object_tauntaun)
.data VERB_PULL,     <(object_tauntaun_get  - object_tauntaun)
.data VERB_GET,      <(object_tauntaun_get  - object_tauntaun)
.data VERB_WALK_TO,  <(object_tauntaun_walk - object_tauntaun)
.data END_VERBS
               ; object name
object_tauntaun_name:
.data "Tauntaun", END_STRING

object_tauntaun_get:
.data ACTOR_SAY, "He's firmly attached to the", LINE_BREAK ,"floor.", END_STRING, END_SCRIPT

object_tauntaun_walk:
.data ACTOR_SAY, "Tauntauns are so cool!", END_STRING, END_SCRIPT

end_object_tauntaun:


; object Door Left
object_door_left:
               ; size in bytes of object
.data end_object_door_left - object_door_left
.data $00, $00 ; unknown
.data $01DC    ; object number
.data $00      ; unknown
.data $01      ; x position
.data $05      ; y position + parent state
.data $02      ; width
.data $00      ; parent
.data $02      ; walk to x
.data $0E      ; walk to y
               ; height + actor facing dir (0xHHHHHDDD)
.data ($09 << 3) | ACTOR_LEFT
               ; offset to object name
.data <(door_left_name - object_door_left)
               ; object script offsets
.data VERB_OPEN,     <(door_left_open - object_door_left)
.data VERB_CLOSE,    <(door_left_open - object_door_left)
.data VERB_WALK_TO,  <(door_left_walk - object_door_left)
.data END_VERBS
               ; object name
door_left_name:
.data "doorway", END_STRING

door_left_open:
.data ACTOR_SAY, "There's no door.", END_STRING, END_SCRIPT

door_left_walk:
.data PUT_ACTOR_AT_OBJECT, VAR_EGO, $01DD
.data DELAY, $F0, $FF, $FF
.data ACTOR_SAY, "Woah, full on wormhole.", END_STRING, END_SCRIPT

end_object_door_left:


; object Door Right
object_door_right:
               ; size in bytes of object
.data end_object_door_right - object_door_right
.data $00, $00 ; unknown
               ; object number
.data OBJ_MODEL_ROOM_ENTRY_ID
.data $00      ; unknown
.data $19      ; x position
.data $05      ; y position + parent state
.data $02      ; width
.data $00      ; parent
.data $19      ; walk to x
.data $0E      ; walk to y
               ; height + actor facing dir (0xHHHHHDDD)
.data ($09 << 3) | ACTOR_RIGHT
               ; offset to object name
.data <(door_right_name - object_door_right)
               ; object script offsets
.data VERB_OPEN,     <(door_right_open - object_door_right)
.data VERB_CLOSE,     <(door_right_open - object_door_right)
.data VERB_WALK_TO,  <(door_right_walk - object_door_right)
.data END_VERBS
               ; object name
door_right_name:
.data "doorway", END_STRING

door_right_open:
.data ACTOR_SAY, "There's no door.", END_STRING, END_SCRIPT

door_right_walk:
.data LOAD_ROOM_WITH_EGO, OBJ_FIXED_STAIRS_ID, ROOM_LIBRARY_ID, $80, $00

end_object_door_right:


; room scripts
entry_script:
;.data WALK_TO, VAR_EGO, $10, $0E
.data END_SCRIPT

exit_script:
.data END_SCRIPT

end_room_data:
