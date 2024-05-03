.include scumm_codes.asm
.include object_ids.asm

.PATCH 05:ADB0 ; 16DC0
; object Rotted Stairs
object_chainsaw:
               ; size in bytes of object
.data end_object_chainsaw - object_chainsaw
.data $00, $00 ; unknown
               ; object number
.data OBJ_CHAINSAW_ID
.data $00      ; unknown
.data $18      ; x position
.data $06      ; y position + parent state
.data $02      ; width
.data $00      ; parent
.data $19      ; walk to x
.data $6F      ; walk to y
               ; height + actor facing dir (0xHHHHHDDD)
.data ($04 << 3) | ACTOR_BACK
               ; offset to object name
.data <(chainsaw_name - object_chainsaw)
               ; object script offsets

.data VERB_TURN_ON,  <(chainsaw_use - object_chainsaw)
.data VERB_USE,      <(chainsaw_use - object_chainsaw)
.data VERB_GET,      <(chainsaw_get - object_chainsaw)
.data END_VERBS
               ; object name
chainsaw_name:
.data "chainsaw", END_STRING

chainsaw_get:
.data PICKUP_OBJECT, VAR_ACTIVE_OBJECT1, END_SCRIPT

chainsaw_use:
.data IF_NOT_STATE_08, <(OBJ_CHAINSAW_ID), (endif_chainsaw_notstate08 - if_chainsaw_notstate08)
if_chainsaw_notstate08:
  .data IF_EQ, VAR_ACTIVE_OBJECT2, OBJ_GASTANK_ID, (endif_gastank - if_gastank)
  if_gastank:
    .data SET_STATE_08|$80, <OBJ_CHAINSAW_ID
    .data ACTOR_SAY, "I finally found some gas!", NEW_LINE, "the tank is full now.", END_STRING
    .data SET_OWNER_OF, OBJ_GASTANK_ID, VAR_NO_ONE
    .data END_SCRIPT
  endif_gastank:
  .data IF_EQ, VAR_EGO, ACTOR_SYD, (endif_syd - if_syd)
  if_syd:
    .data ACTOR_SAY, "Let's go find some gas!", END_STRING
    .data END_SCRIPT
  endif_syd:
  .data ACTOR_SAY, "I think it's out of gas.", END_STRING
  .data END_SCRIPT
endif_chainsaw_notstate08:

.data IF_EQ, VAR_ACTIVE_OBJECT2, OBJ_ROTTED_STAIRS_ID, (endif_rotted_stairs - if_rotted_stairs)
if_rotted_stairs:
  .data IF_STATE_08, OBJ_ROTTED_STAIRS_ID, (else_rotted_stairs_state08 - if_rotted_stairs_state08)
  if_rotted_stairs_state08:
    .data ACTOR_SAY, "I already removed the rotted", LINE_BREAK, "wood.", END_STRING
    .data END_SCRIPT
  else_rotted_stairs_state08:
    .data SET_STATE_08, OBJ_ROTTED_STAIRS_ID
    .data ACTOR_SAY, "Die rot! Die!", END_STRING
    .data START_SOUND, $1B
  endif_rotted_stairs_state08:
  .data END_SCRIPT
endif_rotted_stairs:

.data IF_EQ, VAR_ACTIVE_OBJECT2, OBJ_BOARDED_WINDOW_ID, (endif_boarded_window - if_boarded_window)
if_boarded_window:
  .data IF_STATE_08, OBJ_BOARDED_WINDOW_ID, (else_boarded_window_state08 - if_boarded_window_state08)
  if_boarded_window_state08:
    .data ACTOR_SAY, "I already have all I need.", END_STRING
    .data END_SCRIPT
  else_boarded_window_state08:
    .data ACTOR_SAY, "This should do the trick.", END_STRING
    .data SET_STATE_08, OBJ_BOARDED_WINDOW_ID
    .data PICK_UP, OBJ_BOARDS_ID
    .data START_SOUND, $1B
  endif_boarded_window_state08:
  .data END_SCRIPT
endif_boarded_window:

.data ACTOR_SAY, "I don't think that needs", LINE_BREAK, "chainsawing.", END_STRING
.data END_SCRIPT

end_object_chainsaw:
