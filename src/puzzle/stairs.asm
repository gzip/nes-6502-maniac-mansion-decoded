.include scumm_codes.asm
.include object_ids.asm

.PATCH 05:A460 ; 16470
; object Rotted Stairs
object_rotted_stairs:
               ; size in bytes of object
.data end_object_rotted_stairs - object_rotted_stairs
.data $00, $00 ; unknown
               ; object number
.data OBJ_ROTTED_STAIRS_ID
.data $00      ; unknown
.data $19      ; x position
.data $0B      ; y position + parent state
.data $05      ; width
.data $00      ; parent
.data $1C      ; walk to x
.data $0E      ; walk to y
               ; height + actor facing dir (0xHHHHHDDD)
.data ($03 << 3) | ACTOR_BACK
               ; offset to object name
.data <(rotted_stairs_name - object_rotted_stairs)
               ; object script offsets

.data VERB_PULL,    <(rotted_stairs_pull - object_rotted_stairs)
.data VERB_USE,     <(rotted_stairs_use  - object_rotted_stairs)
.data END_VERBS
               ; object name
rotted_stairs_name:
.data "rotted stairs", END_STRING

rotted_stairs_pull:
.data ACTOR_SAY, "I don't want to hurt myself.", END_STRING, END_SCRIPT

rotted_stairs_use:
.data IF_EQ, VAR_ACTIVE_OBJECT2, OBJ_TOOLS_ID, (endif_is_tools - if_is_tools)
if_is_tools:
  .data ACTOR_SAY, "I don't have the right tool.", END_STRING
  .data END_SCRIPT
endif_is_tools:

.data IF_EQ, VAR_ACTIVE_OBJECT2, OBJ_BOARDS_ID, (endif_is_boards - if_is_boards)
if_is_boards:
  .data IF_STATE_08, OBJ_ROTTED_STAIRS_ID, (endif_boards_state08 - if_boards_state08)
  if_boards_state08:
    .data START_SCRIPT, $06
    .data END_SCRIPT
  endif_boards_state08:
  .data ACTOR_SAY, "I need to remove the rotted", LINE_BREAK, "wood first.", END_STRING
  .data END_SCRIPT
endif_is_boards:

.data ACTOR_SAY, "That won't work.", END_STRING
.data END_SCRIPT

end_object_rotted_stairs:


.PATCH 05:A570 ; 16580
; object Fixed Stairs
object_fixed_stairs:
               ; size in bytes of object
.data end_object_fixed_stairs - object_fixed_stairs
.data $00, $00 ; unknown
               ; object number
.data OBJ_FIXED_STAIRS_ID
.data $00      ; unknown
.data $19      ; x position
.data $0B      ; y position + parent state
.data $05      ; width
.data $00      ; parent
.data $1C      ; walk to x
.data $01      ; walk to y
               ; height + actor facing dir (0xHHHHHDDD)
.data ($03 << 3) | ACTOR_BACK
               ; offset to object name
.data <(fixed_stairs_name - object_fixed_stairs)
               ; object script offsets

.data VERB_WALK_TO,     <(fixed_stairs_walk_to  - object_fixed_stairs)
.data END_VERBS
               ; object name
fixed_stairs_name:
.data "fixed stairs", END_STRING

fixed_stairs_walk_to:
.data LOAD_ROOM_WITH_EGO, OBJ_MODEL_ROOM_ENTRY_ID, ROOM_MODEL_ID, $80, $00
.data END_SCRIPT

end_object_fixed_stairs:


.PATCH 05:A5B0 ; 165C0
; object Top of Stairs
object_top_of_stairs:
               ; size in bytes of object
.data end_object_top_of_stairs - object_top_of_stairs
.data $00, $00 ; unknown
               ; object number
.data OBJ_TOP_OF_STAIRS_ID
.data $00      ; unknown
.data $17      ; x position
.data $00      ; y position + parent state
.data $06      ; width
.data $00      ; parent
.data $1C      ; walk to x
.data $01      ; walk to y
               ; height + actor facing dir (0xHHHHHDDD)
.data ($01 << 3) | ACTOR_BACK
               ; offset to object name
.data <(top_of_stairs_name - object_top_of_stairs)
               ; object script offsets

.data VERB_WALK_TO,     <(top_of_stairs_walk_to  - object_top_of_stairs)
.data END_VERBS
               ; object name
top_of_stairs_name:
.data "top of stairs", END_STRING

top_of_stairs_walk_to:
.data LOAD_ROOM_WITH_EGO, OBJ_MODEL_ROOM_ENTRY_ID, ROOM_MODEL_ID, $80, $00
.data END_SCRIPT
end_object_top_of_stairs:


.PATCH 05:A670 ; 16680
fix_stairs_script:
.data end_fix_stairs_script - fix_stairs_script
.data $00, $00 ; unknown

.data CUTSCENE
.data START_SOUND, $2E
; hide sign and rotted stairs and show fixed stairs
.data SET_STATE_02, OBJ_SIGN_ID
.data SET_STATE_08, OBJ_SIGN_ID
.data SET_OWNER_OF, OBJ_BOARDS_ID, VAR_NO_ONE
.data DELAY, $A5, $FF, $FF

.data PUT_ACTOR,  VAR_EGO, $1B, $3A
.data FACE_ACTOR, VAR_EGO, $0087 ; door
.data DELAY, $95, $FF, $FF

.data PUT_ACTOR,  VAR_EGO, $1D, $3A
.data FACE_ACTOR, VAR_EGO,  $0088 ; phone
.data DELAY, $75, $FF, $FF

.data PUT_ACTOR,  VAR_EGO, $1D, $3D
.data FACE_ACTOR, VAR_EGO, $00, $00
.data DELAY, $A5, $FF, $FF

; hide rotted stairs and show fixed stairs
.data CLEAR_STATE_08, OBJ_ROTTED_STAIRS_ID
.data SET_STATE_02, OBJ_ROTTED_STAIRS_ID
.data SET_STATE_08, OBJ_FIXED_STAIRS_ID
.data CLEAR_STATE_02, OBJ_TOP_OF_STAIRS_ID

.data PUT_ACTOR,  VAR_EGO, $1C, $3A
.data DELAY, $75, $FF, $FF

.data SET_BOX_FLAGS, $01, $00
.data FACE_ACTOR, VAR_EGO, $00, $00
.data ACTOR_SAY, "Perfect fit!", END_STRING

.data END_CUTSCENE
.data END_SCRIPT
end_fix_stairs_script:


; patch data for script 6 which was unused
.PATCH $3EA61
.data $05 ; bank

.PATCH $3EB14
.data <fix_stairs_script

.PATCH $3EBC7
.data >fix_stairs_script
