INVULNERABILITY_FRAMES  = 120 ; default: 50

CURRENT_BUTTON_PRESSES  = $ff047e
LAST_BUTTON_PRESSES     = $fffff0
BIT_BUTTON_JUMP         = 5
JUMP_FLAG               = $ff069c

    org 0
    incbin "mickeymania.md"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; change number of invulnerability frames
    org $007b58
            move.w  #INVULNERABILITY_FRAMES, $ff06c0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; don't lose marbles after losing a life
    org $0058c2
            bra     $0058f0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; don't lose marbles after continuing
    org $004ee8
            nop
            nop
            nop
            nop
    org $00552e
            nop
            nop
            nop
            nop

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; disable turbo jumping
    org $001214
            jmp     jump_routine
    org $001edc
            jmp     landing_routine
    org $1e7000
landing_routine:
            ; replace original instruction
            move.w  #5, $ff06e8
            move.w  #0, JUMP_FLAG
            jmp     $001ee4
jump_routine:
            move.b  CURRENT_BUTTON_PRESSES, d3
            move.b  LAST_BUTTON_PRESSES, d0
            move.b  d3, LAST_BUTTON_PRESSES
.check_for_held_jump_button_press
            btst    #BIT_BUTTON_JUMP, d3
            bne     .no_jump
.check_for_jump_flag
            move.b  d0, d3
            move.w  JUMP_FLAG, d0
            bne     .continue_jump
.check_for_new_jump_button_press
            btst    #BIT_BUTTON_JUMP, d3
            beq     .no_jump
.start_jump
            jmp     $001232
.continue_jump
            jmp     $001228
.no_jump
            jmp     $00123c
