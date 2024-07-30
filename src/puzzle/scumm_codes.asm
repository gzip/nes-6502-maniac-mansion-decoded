VERB_OPEN     = $01
VERB_CLOSE    = $02
VERB_GIVE     = $03
VERB_TURN_ON  = $04
VERB_TURN_OFF = $05
VERB_FIX      = $06
VERB_NEW_KID  = $07
VERB_UNLOCK   = $08
VERB_PUSH     = $09
VERB_PULL     = $0A
VERB_USE      = $0B
VERB_READ     = $0C
VERB_WALK_TO  = $0D
VERB_GET      = $0E
VERB_WHAT_IS  = $0F
VERB_ALL      = $FF

END_VERBS     = $00
END_SCRIPT    = $00

END_STRING    = $00
LINE_BREAK    = $01
NEW_LINE      = $03

PREP_IN       = %00100000
PREP_WITH     = %01000000
PREP_ON       = %01100000
PREP_TO       = %10000000

ACTOR_LEFT    = %100
ACTOR_RIGHT   = %101
ACTOR_FRONT   = %110
ACTOR_BACK    = %111

SET_STATE_08        = $07
CLEAR_STATE_02      = $17
JUMP                = $18
START_SOUND         = $1C
LOAD_ROOM_WITH_EGO  = $24
SET_OWNER_OF        = $29
DELAY               = $2E
SET_BOX_FLAGS       = $30
STOP_SOUND          = $3C
CUTSCENE            = $40
START_SCRIPT        = $42
CLEAR_STATE_08      = $47
IF_EQ               = $48
IF_STATE_08         = $4F
PICK_UP             = $50
SET_STATE_02        = $57
PUT_ACTOR           = $81
FACE_ACTOR          = $89
PUT_ACTOR_AT_OBJECT = $8E
IF_NOT_STATE_08     = $8F
WALK_TO             = $9E
WAIT_FOR_ACTOR      = $BB
END_CUTSCENE        = $C0
PICKUP_OBJECT       = $D0
ACTOR_SAY           = $D8

VAR_ACTIVE_OBJECT1  = $09
VAR_ACTIVE_OBJECT2  = $0A
VAR_NO_ONE          = $00
VAR_EGO             = $00
