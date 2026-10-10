
 
.MODEL SMALL
.STACK 100H
 

PRINT MACRO msg
    PUSH AX
    PUSH DX
    LEA  DX, msg
    MOV  AH, 09H
    INT  21H
    POP  DX
    POP  AX
ENDM
 
PUTC MACRO ch
    PUSH AX
    PUSH DX
    MOV  DL, ch
    MOV  AH, 02H
    INT  21H
    POP  DX
    POP  AX
ENDM
 
NL MACRO
    PUSH AX
    PUSH DX
    MOV  DL, 13
    MOV  AH, 02H
    INT  21H
    MOV  DL, 10
    INT  21H
    POP  DX
    POP  AX
ENDM
 

.DATA
 
;banners & prompts
banner       DB 13,10,'=============================================='
             DB 13,10,'        CRICKET SCOREBOARD - EMU8086          '
             DB 13,10,'           by Mehedi | Junaed | Shakib        '
             DB 13,10,'==============================================',13,10,'$'
 
ask_teamA_nm DB 13,10,'Enter Team A name (max 10 chars): $'
ask_teamB_nm DB 13,10,'Enter Team B name (max 10 chars): $'
ask_nplayers DB 13,10,'Number of players per team (2-11), then Enter: $'
ask_overs    DB 13,10,'Overs per innings (1-9): $'
ask_toss     DB 13,10,'Who bats first? (A or B): $'
ask_pname    DB 13,10,'  Player name: $'
lbl_teamA_p  DB 13,10,'--- Enter TEAM A players ---',13,10,'$'
lbl_teamB_p  DB 13,10,'--- Enter TEAM B players ---',13,10,'$'
teamA_first  DB 13,10,'>> TEAM A bats first',13,10,'$'
teamB_first  DB 13,10,'>> TEAM B bats first',13,10,'$'
inv_ball     DB 13,10,'   [!] Invalid key. Use: 0-6 = runs, W = wicket, X = wide, N = no-ball',13,10,'$'
inv_range    DB 13,10,'   [!] Out of range. Try again: $'
 
ask_next_bat DB 13,10,'  >> Send next batsman (index): $'
ask_bowler   DB 13,10,'  >> Choose bowler for next over (index): $'
ask_ball     DB 13,10,'Ball: $'
 
;profile labels
prof_bat_hdr DB 13,10,'---- BATSMAN PROFILE ----',13,10,'  Name         : $'
prof_runs    DB 13,10,'  Career Runs  : $'
prof_bwl_hdr DB 13,10,'---- BOWLER  PROFILE ----',13,10,'  Name         : $'
prof_wkts    DB 13,10,'  Career Wkts  : $'
prof_end     DB 13,10,'-------------------------',13,10,'$'
 
; live mini scoreboard
mini_lbr     DB 13,10,'   >> $'
mini_score   DB ' Score: $'
mini_slash   DB '/$'
mini_ov      DB ' (',' $'
mini_ovend   DB ')  Bat: $'
mini_bracket DB '(',' $'
mini_close   DB ')  Bwl: $'
mini_dash    DB '-$'
mini_dot     DB '.$'
 
over_done    DB 13,10,'   -- Over complete --',13,10,'$'
inn_over_msg DB 13,10,'============ INNINGS OVER ============',13,10,'$'
match_over   DB 13,10,'============ MATCH  OVER  ============',13,10,'$'
 
; card labels 
card_hdr     DB 13,10,'====== INNINGS SCORECARD ======',13,10
             DB 'Player            R    B   4s   6s   St',13,10,'$'
card_out     DB '  [OUT]$'
card_bat     DB '  [NO ]$'
card_dnb     DB '  [DNB]$'
bwl_hdr      DB 13,10,'--- Bowling ---',13,10
             DB 'Bowler            O     R     W',13,10,'$'
total_lbl    DB 13,10,'TOTAL: $'
wkts_lbl     DB '/$'
overs_lbl    DB '  in $'
ov_str       DB ' overs',13,10,'$'
target_lbl   DB 13,10,'Target: $'
need_lbl     DB 13,10,'Need $'
from_lbl     DB ' runs from $'
balls_lbl    DB ' balls',13,10,'$'
 
; results 
res_A_wins   DB 13,10,'*** TEAM A WINS by $'
res_B_wins   DB 13,10,'*** TEAM B WINS by $'
res_runs     DB ' runs ***',13,10,'$'
res_wkts     DB ' wickets ***',13,10,'$'
res_tie      DB 13,10,'*** MATCH TIED ***',13,10,'$'
res_mom      DB 13,10,'Man of the Match: $'
 
;storage: names (12 bytes each 
teamA_name   DB 12 DUP('$')
teamB_name   DB 12 DUP('$')
 
; 11 players * 12 bytes per team
teamA_pnames DB 132 DUP('$')
teamB_pnames DB 132 DUP('$')
 
;career stats: 11 slots per team
teamA_cRuns  DW 1250,  980,  340,  205,  510, 1400,  75, 2100,   50,   90,  620
teamA_cWkts  DB   15,   42,   88,    3,    5,    9,  40,    2,   77,   28,   11
teamB_cRuns  DW 1500,  210,  760, 1100,  330,  180,  95,  610,  260, 1800,   40
teamB_cWkts  DB    8,   65,   30,   14,    1,   50,   6,   12,   90,    4,   33
 
;live innings stats: 2 innings * 11 players = 22 slots
bat_runs     DW 22 DUP(0)
bat_balls    DB 22 DUP(0)
bat_4s       DB 22 DUP(0)
bat_6s       DB 22 DUP(0)
bat_status   DB 22 DUP(0) ; 0=DNB, 1=batting, 2=OUT
 
bwl_balls    DB 22 DUP(0)
bwl_runs     DW 22 DUP(0)
bwl_wkts     DB 22 DUP(0)
 
; match state
n_players    DB 3
overs_max    DB 2
batting_1st  DB 0   ; 0 = Team A, 1 = Team B
cur_inn      DB 0
bat_team     DB 0              ; which team is batting now (0=A,1=B)
tot_runs     DW 0
tot_wkts     DB 0
balls_done   DB 0
striker      DB 0
bowler       DB 0
target       DW 0
first_score  DW 0
first_wkts   DB 0
 
;input buffer 
input_buf    DB 14, 0, 14 DUP('$')
 

.CODE
MAIN PROC FAR
    MOV AX, @DATA
    MOV DS, AX
 
    PRINT banner
 
    CALL SETUP_MATCH
 
    ; INNINGS 1
    MOV BYTE PTR [cur_inn], 0
    MOV AL, [batting_1st]
    MOV [bat_team], AL
    CALL PRINT_TOSS_MSG
    CALL PLAY_INNINGS
 
    MOV AX, [tot_runs]
    MOV [first_score], AX
    INC AX     ; target = first innings score + 1
    MOV [target], AX
    MOV AL, [tot_wkts]
    MOV [first_wkts], AL
 
    PRINT inn_over_msg
    CALL SHOW_INNINGS_CARD
 
    ; INNINGS 2
    MOV BYTE PTR [cur_inn], 1
    MOV AL, [batting_1st]
    XOR AL, 1
    MOV [bat_team], AL
    MOV WORD PTR [tot_runs], 0
    MOV BYTE PTR [tot_wkts], 0
    MOV BYTE PTR [balls_done], 0
    CALL PLAY_INNINGS
 
    PRINT inn_over_msg
    CALL SHOW_INNINGS_CARD
 
    ; RESULT
    PRINT match_over
    CALL SHOW_RESULT
 
    MOV AX, 4C00H
    INT 21H
MAIN ENDP
 

;  SETUP  

SETUP_MATCH PROC NEAR
    PRINT ask_teamA_nm
    LEA BX, teamA_name
    CALL READ_NAME10
 
    PRINT ask_teamB_nm
    LEA BX, teamB_name
    CALL READ_NAME10
 
   
sp_ask_n:
    PRINT ask_nplayers
    CALL READ_NUM             ; AX = number
    CMP AX, 2
    JB  sp_bad_n
    CMP AX, 11
    JA  sp_bad_n
    MOV [n_players], AL
    JMP sp_ov
sp_bad_n:
    PRINT inv_range
    JMP sp_ask_n
 
sp_ov:
    PRINT ask_overs
    CALL READ_NUM
    CMP AX, 1
    JB  sp_def_ov
    CMP AX, 9
    JA  sp_def_ov
    MOV [overs_max], AL
    JMP sp_pA
sp_def_ov:
    MOV BYTE PTR [overs_max], 2
 
sp_pA:
    PRINT lbl_teamA_p
    MOV CL, [n_players]
    MOV CH, 0
    LEA SI, teamA_pnames
sp_pA_lp:
    PRINT ask_pname
    MOV BX, SI
    CALL READ_NAME10
    ADD SI, 12
    LOOP sp_pA_lp
 
    PRINT lbl_teamB_p
    MOV CL, [n_players]
    MOV CH, 0
    LEA SI, teamB_pnames
sp_pB_lp:
    PRINT ask_pname
    MOV BX, SI
    CALL READ_NAME10
    ADD SI, 12
    LOOP sp_pB_lp
 

sp_toss:
    PRINT ask_toss
    CALL READ_UPCHAR         
    CMP AL, 'A'
    JE sp_A_first
    CMP AL, 'B'
    JE sp_B_first
    JMP sp_toss
sp_A_first:
    MOV BYTE PTR [batting_1st], 0
    RET
sp_B_first:
    MOV BYTE PTR [batting_1st], 1
    RET
SETUP_MATCH ENDP
 
PRINT_TOSS_MSG PROC NEAR
    CMP BYTE PTR [batting_1st], 0
    JNE ptm_B
    PRINT teamA_first
    RET
ptm_B:
    PRINT teamB_first
    RET
PRINT_TOSS_MSG ENDP
 

;PLAY ONE INNINGS

PLAY_INNINGS PROC NEAR
    MOV BYTE PTR [striker], 0
    CALL MARK_STRIKER_IN
    CALL SHOW_BATSMAN_PROFILE
 
over_outer:
    
    MOV AL, [overs_max]
    MOV BL, 6
    MUL BL                    ; AX = balls_max
    CMP BYTE PTR [balls_done], AL
    JAE inn_done
 
    ; all-out = wickets = n_players - 1
    MOV AL, [n_players]
    DEC AL
    CMP [tot_wkts], AL
    JAE inn_done
 
    ; 2nd innings target reached
    CMP BYTE PTR [cur_inn], 1
    JNE oo_ask_bwl
    MOV AX, [tot_runs]
    CMP AX, [target]
    JAE inn_done
 
oo_ask_bwl:
    CALL PICK_BOWLER
    CALL SHOW_BOWLER_PROFILE
 
    MOV CX, 6                 ; 6 legal balls
ball_lp:
   
    MOV AL, [n_players]
    DEC AL
    CMP [tot_wkts], AL
    JAE over_done_lbl
 
    CMP BYTE PTR [cur_inn], 1
    JNE bl_do
    MOV AX, [tot_runs]
    CMP AX, [target]
    JAE over_done_lbl
 
bl_do:
    CALL PROCESS_ONE_BALL     
    CMP DH, 1
    JE  bl_illegal
    INC BYTE PTR [balls_done]
    CALL SHOW_LIVE
    LOOP ball_lp
    JMP over_done_lbl
 
bl_illegal:
    CALL SHOW_LIVE
    JMP ball_lp
 
over_done_lbl:
    PRINT over_done
    JMP over_outer
 
inn_done:
    RET
PLAY_INNINGS ENDP
 

; ball input, validation, and delivery update
; DH = 0 for a legal ball, 1 for a wide/no-ball.

PROCESS_ONE_BALL PROC NEAR
    MOV DH, 0
pb_read:
    PRINT ask_ball
    CALL READ_UPCHAR    
 
    
    CMP AL, 13
    JE  pb_read
    CMP AL, 10
    JE  pb_read
 
    CMP AL, 'W'
    JE  pb_wicket
    CMP AL, 'X'
    JE  pb_extra
    CMP AL, 'N'
    JE  pb_extra
    CMP AL, '0'
    JB  pb_invalid
    CMP AL, '6'
    JA  pb_invalid
 
    
    SUB AL, '0'
    MOV DL, AL                ; DL = runs
    CALL INC_STRIKER_BALL
    CALL INC_BOWLER_BALL
    MOV AL, DL
    CALL ADD_STRIKER_RUNS
    MOV AL, DL
    CALL ADD_BOWLER_RUNS
    MOV AL, DL
    MOV AH, 0
    ADD [tot_runs], AX
    CMP DL, 4
    JNE pb_not4
    CALL INC_STRIKER_4
pb_not4:
    CMP DL, 6
    JNE pb_not6
    CALL INC_STRIKER_6
pb_not6:
    RET
 
pb_extra:                      
    INC WORD PTR [tot_runs]
    CALL INC_BOWLER_RUN1
    MOV DH, 1
    RET
 
pb_wicket:
    CALL INC_STRIKER_BALL
    CALL INC_BOWLER_BALL
    CALL MARK_STRIKER_OUT
    CALL INC_BOWLER_WKT
    INC BYTE PTR [tot_wkts]
    
    MOV AL, [n_players]
    DEC AL
    CMP [tot_wkts], AL
    JAE pb_wk_done
    CALL PICK_BATSMAN
    CALL MARK_STRIKER_IN
    CALL SHOW_BATSMAN_PROFILE
pb_wk_done:
    RET
 
pb_invalid:
    PRINT inv_ball
    JMP pb_read
PROCESS_ONE_BALL ENDP
 

;  Healpers stat updates

 
; BAT_INDEX: returns BX = cur_inn * 11 + striker 
BAT_INDEX PROC NEAR
    PUSH AX
    MOV AL, [cur_inn]
    MOV BL, 11
    MUL BL
    ADD AL, [striker]
    MOV BL, AL
    MOV BH, 0
    POP AX
    RET
BAT_INDEX ENDP
 
; BWL_INDEX: returns BX = cur_inn * 11 + bowler
BWL_INDEX PROC NEAR
    PUSH AX
    MOV AL, [cur_inn]
    MOV BL, 11
    MUL BL
    ADD AL, [bowler]
    MOV BL, AL
    MOV BH, 0
    POP AX
    RET
BWL_INDEX ENDP
 
; BAT_INDEX_OF: input DL = player idx, returns BX = cur_inn*11+DL
BAT_INDEX_OF PROC NEAR
    PUSH AX
    MOV AL, [cur_inn]
    MOV BL, 11
    MUL BL
    ADD AL, DL
    MOV BL, AL
    MOV BH, 0
    POP AX
    RET
BAT_INDEX_OF ENDP
 
INC_STRIKER_BALL PROC NEAR
    PUSH BX
    CALL BAT_INDEX
    INC BYTE PTR bat_balls[BX]
    POP BX
    RET
INC_STRIKER_BALL ENDP
 
INC_STRIKER_4 PROC NEAR
    PUSH BX
    CALL BAT_INDEX
    INC BYTE PTR bat_4s[BX]
    POP BX
    RET
INC_STRIKER_4 ENDP
 
INC_STRIKER_6 PROC NEAR
    PUSH BX
    CALL BAT_INDEX
    INC BYTE PTR bat_6s[BX]
    POP BX
    RET
INC_STRIKER_6 ENDP
 
ADD_STRIKER_RUNS PROC NEAR  ; AL = runs to add
    PUSH BX
    PUSH AX
    CALL BAT_INDEX
    SHL BX, 1     ; word offset
    POP AX
    MOV AH, 0
    ADD bat_runs[BX], AX
    POP BX
    RET
ADD_STRIKER_RUNS ENDP
 
MARK_STRIKER_IN PROC NEAR
    PUSH BX
    CALL BAT_INDEX
    MOV BYTE PTR bat_status[BX], 1
    POP BX
    RET
MARK_STRIKER_IN ENDP
 
MARK_STRIKER_OUT PROC NEAR
    PUSH BX
    CALL BAT_INDEX
    MOV BYTE PTR bat_status[BX], 2
    POP BX
    RET
MARK_STRIKER_OUT ENDP
 
INC_BOWLER_BALL PROC NEAR
    PUSH BX
    CALL BWL_INDEX
    INC BYTE PTR bwl_balls[BX]
    POP BX
    RET
INC_BOWLER_BALL ENDP
 
INC_BOWLER_WKT PROC NEAR
    PUSH BX
    CALL BWL_INDEX
    INC BYTE PTR bwl_wkts[BX]
    POP BX
    RET
INC_BOWLER_WKT ENDP
 
INC_BOWLER_RUN1 PROC NEAR  ; +1 run to bowler (wide/no-ball)
    PUSH BX
    CALL BWL_INDEX
    SHL BX, 1
    INC WORD PTR bwl_runs[BX]
    POP BX
    RET
INC_BOWLER_RUN1 ENDP
 
ADD_BOWLER_RUNS PROC NEAR  ; AL = runs
    PUSH BX
    PUSH AX
    CALL BWL_INDEX
    SHL BX, 1
    POP AX
    MOV AH, 0
    ADD bwl_runs[BX], AX
    POP BX
    RET
ADD_BOWLER_RUNS ENDP
 

;  SHOW BATSMAN CAREER PROFILE 

SHOW_BATSMAN_PROFILE PROC NEAR
    PRINT prof_bat_hdr
    CALL GET_BAT_NAMES_SI  ; SI = base of batting team names
    CALL GET_BAT_CAREER_DI ; DI = base of batting team career runs (word)
 
    ; SI + striker*12 -> name
    MOV AL, [striker]
    CALL PRINT_NAME_AT
 
    PRINT prof_runs
    MOV AL, [striker]
    SHL AL, 1                 ; word offset
    MOV AH, 0
    ADD DI, AX
    MOV AX, [DI]
    CALL PRINT_DEC
    PRINT prof_end
    RET
SHOW_BATSMAN_PROFILE ENDP
 

;  SHOW BOWLER CAREER PROFILE 

SHOW_BOWLER_PROFILE PROC NEAR
    PRINT prof_bwl_hdr
    CALL GET_BWL_NAMES_SI
    CALL GET_BWL_CAREER_DI
 
    MOV AL, [bowler]
    CALL PRINT_NAME_AT
 
    PRINT prof_wkts
    MOV AL, [bowler]
    MOV AH, 0
    ADD DI, AX
    MOV AL, [DI]
    MOV AH, 0
    CALL PRINT_DEC
    PRINT prof_end
    RET
SHOW_BOWLER_PROFILE ENDP
 

PRINT_NAME_AT PROC NEAR
    MOV BL, 12
    MUL BL
    ADD SI, AX
    MOV DX, SI
    MOV AH, 09H
    INT 21H
    RET
PRINT_NAME_AT ENDP


GET_BAT_NAMES_SI PROC NEAR  ; returns SI
    CMP BYTE PTR [bat_team], 0
    JE  gbn_A
    LEA SI, teamB_pnames
    RET
gbn_A:
    LEA SI, teamA_pnames
    RET
GET_BAT_NAMES_SI ENDP
 
GET_BWL_NAMES_SI PROC NEAR
    CMP BYTE PTR [bat_team], 0
    JE  gbo_A
    LEA SI, teamA_pnames
    RET
gbo_A:
    LEA SI, teamB_pnames
    RET
GET_BWL_NAMES_SI ENDP
 
GET_BAT_CAREER_DI PROC NEAR  ; career RUNS base
    CMP BYTE PTR [bat_team], 0
    JE  gbc_A
    LEA DI, teamB_cRuns
    RET
gbc_A:
    LEA DI, teamA_cRuns
    RET
GET_BAT_CAREER_DI ENDP
 
GET_BWL_CAREER_DI PROC NEAR ; career WICKETS base
    CMP BYTE PTR [bat_team], 0
    JE  gwc_A
    LEA DI, teamA_cWkts
    RET
gwc_A:
    LEA DI, teamB_cWkts
    RET
GET_BWL_CAREER_DI ENDP
 

;LIVE MINI SCOREBOARD  
;Score: R/W (O.B)  Bat: name RUNS(B)  Bwl: name O.B-R-W

SHOW_LIVE PROC NEAR
    PRINT mini_lbr
    PRINT mini_score
 
    ; runs/wkts
    MOV AX, [tot_runs]
    CALL PRINT_DEC
    PRINT mini_slash
    MOV AL, [tot_wkts]
    MOV AH, 0
    CALL PRINT_DEC
 
    ; overs O.B
    PUTC ' '
    PUTC '('
    MOV AL, [balls_done]
    CALL PRINT_OVERS
    PUTC ')'
 
    ; striker snippet
    PUTC ' '
    PUTC 'B'
    PUTC 'a'
    PUTC 't'
    PUTC ':'
    PUTC ' '
    ; name
    CALL GET_BAT_NAMES_SI
    MOV AL, [striker]
    CALL PRINT_NAME_AT
    ; runs
    CALL BAT_INDEX
    PUSH BX
    SHL BX, 1
    MOV AX, bat_runs[BX]
    CALL PRINT_DEC
    PUTC '('
    POP BX
    MOV AL, bat_balls[BX]
    MOV AH, 0
    CALL PRINT_DEC
    PUTC ')'
 
    ; bowler snippet
    PUTC ' '
    PUTC 'B'
    PUTC 'w'
    PUTC 'l'
    PUTC ':'
    PUTC ' '
    CALL GET_BWL_NAMES_SI
    MOV AL, [bowler]
    CALL PRINT_NAME_AT
    ; O.B - R - W
    CALL BWL_INDEX
    MOV AL, bwl_balls[BX]
    CALL PRINT_OVERS
    PUTC '-'
    PUSH BX
    SHL BX, 1
    MOV AX, bwl_runs[BX]
    CALL PRINT_DEC
    PUTC '-'
    POP BX
    MOV AL, bwl_wkts[BX]
    MOV AH, 0
    CALL PRINT_DEC
    RET
SHOW_LIVE ENDP
 

; FULL INNINGS SCORECARD 

SHOW_INNINGS_CARD PROC NEAR
    PRINT card_hdr
 
  
    MOV CL, [n_players]
    MOV CH, 0
    MOV DL, 0 ; player idx
sc_lp:
    PUSH CX
    PUSH DX
 
    ; print name
    CALL GET_BAT_NAMES_SI
    MOV AL, DL
    CALL PRINT_NAME_AT
    PUTC ' '
    PUTC ' '
 
    POP DX
    PUSH DX
    CALL BAT_INDEX_OF ; BX = slot
    PUSH BX
    SHL BX, 1
    MOV AX, bat_runs[BX]
    CALL PRINT_DEC
    PUTC ' '
    PUTC ' '
    POP BX
    PUSH BX
    MOV AL, bat_balls[BX]
    MOV AH, 0
    CALL PRINT_DEC
    PUTC ' '
    PUTC ' '
    POP BX
    PUSH BX
    MOV AL, bat_4s[BX]
    MOV AH, 0
    CALL PRINT_DEC
    PUTC ' '
    PUTC ' '
    POP BX
    PUSH BX
    MOV AL, bat_6s[BX]
    MOV AH, 0
    CALL PRINT_DEC
    POP BX
    MOV AL, bat_status[BX]
    CMP AL, 2
    JE  scst_out
    CMP AL, 1
    JE  scst_bat
    PRINT card_dnb
    JMP scst_end
scst_out:
    PRINT card_out
    JMP scst_end
scst_bat:
    PRINT card_bat
scst_end:
    NL
    POP DX
    POP CX
    INC DL
    LOOP sc_lp
 
    ; totals line
    PRINT total_lbl
    MOV AX, [tot_runs]
    CALL PRINT_DEC
    PRINT wkts_lbl
    MOV AL, [tot_wkts]
    MOV AH, 0
    CALL PRINT_DEC
    PRINT overs_lbl
    MOV AL, [balls_done]
    CALL PRINT_OVERS
    PRINT ov_str
 
    ; 2nd innings extras
    CMP BYTE PTR [cur_inn], 1
    JNE sc_nobwl_target
    PRINT target_lbl
    MOV AX, [target]
    CALL PRINT_DEC
    NL
sc_nobwl_target:
 
    ; bowling table
    PRINT bwl_hdr
    MOV CL, [n_players]
    MOV CH, 0
    MOV DL, 0
bc_lp:
    PUSH CX
    PUSH DX
 
    CALL GET_BWL_NAMES_SI
    MOV AL, DL
    CALL PRINT_NAME_AT
    PUTC ' '
    PUTC ' '
 
    POP DX
    PUSH DX
    CALL BAT_INDEX_OF   
 
    ; overs O.B
    MOV AL, bwl_balls[BX]
    CALL PRINT_OVERS
    PUTC ' '
    PUTC ' '
    PUSH BX
    SHL BX, 1
    MOV AX, bwl_runs[BX]
    CALL PRINT_DEC
    PUTC ' '
    PUTC ' '
    POP BX
    MOV AL, bwl_wkts[BX]
    MOV AH, 0
    CALL PRINT_DEC
    NL
 
    POP DX
    POP CX
    INC DL
    LOOP bc_lp
 
    RET
SHOW_INNINGS_CARD ENDP
 

; RESULT + MoM 

SHOW_RESULT PROC NEAR
    
;   if batting_1st==0: A=first_score, B=tot_runs
;   else:B=first_score, A=tot_runs 

    MOV AL, [batting_1st]
    CMP AL, 0
    JNE r_B1st
    MOV AX, [first_score]     ; A
    MOV BX, [tot_runs]        ; B
    JMP r_cmp
r_B1st:
    MOV BX, [first_score]     ; B
    MOV AX, [tot_runs]        ; A
r_cmp:
    CMP AX, BX
    JE r_tie
    JB r_Bwins
    ; A wins
    PRINT res_A_wins
    SUB AX, BX ; margin in runs

    CMP BYTE PTR [batting_1st], 0
    JE r_A_by_runs
    ; A batted second, by wickets
    MOV AL, [n_players]
    DEC AL
    SUB AL, [tot_wkts]
    MOV AH, 0
    CALL PRINT_DEC
    PRINT res_wkts
    JMP r_mom
r_A_by_runs:
    CALL PRINT_DEC
    PRINT res_runs
    JMP r_mom
 
r_Bwins:
    PRINT res_B_wins
   
    XCHG AX, BX
    SUB AX, BX  
    CMP BYTE PTR [batting_1st], 1
    JE r_B_by_runs
    ; B batted second, by wickets
    MOV AL, [n_players]
    DEC AL
    SUB AL, [tot_wkts]
    MOV AH, 0
    CALL PRINT_DEC
    PRINT res_wkts
    JMP r_mom
r_B_by_runs:
    CALL PRINT_DEC
    PRINT res_runs
    JMP r_mom
 
r_tie:
    PRINT res_tie
 
r_mom:
    
    MOV CX, 22
    XOR SI, SI
    MOV DX, 0 ; best runs
    MOV DI, 0 ; best index
mom_lp:
    MOV BX, SI
    SHL BX, 1
    MOV AX, bat_runs[BX]
    CMP AX, DX
    JBE mom_next
    MOV DX, AX
    MOV DI, SI
mom_next:
    INC SI
    LOOP mom_lp
 
    PRINT res_mom
 
    MOV AX, DI
    MOV BL, 11
    DIV BL      ; AL = innings (0/1), AH = player idx
    MOV BL, AH  ; BL = player idx
    ; team:
    CMP AL, 0
    JE  mom_inn0
    ; inn 1, opposite
    MOV AL, [batting_1st]
    XOR AL, 1
    JMP mom_pick
mom_inn0:
    MOV AL, [batting_1st]
mom_pick:
    ; AL = team (0=A,1=B), BL = player index
    CMP AL, 0
    JNE mom_teamB
    LEA SI, teamA_pnames
    JMP mom_print
mom_teamB:
    LEA SI, teamB_pnames
mom_print:
    MOV AL, BL
    MOV BL, 12
    MUL BL
    ADD SI, AX
    MOV DX, SI
    MOV AH, 09H
    INT 21H
    NL
    RET
SHOW_RESULT ENDP
 

;   PICK_BOWLER / PICK_BATSMAN

PICK_BOWLER PROC NEAR
ab_ask:
    PRINT ask_bowler
    CALL READ_NUM
    CMP AX, 1
    JB  ab_bad
    MOV BL, [n_players]
    MOV BH, 0
    CMP AX, BX
    JA  ab_bad
    DEC AX
    MOV [bowler], AL
    RET
ab_bad:
    PRINT inv_range
    JMP ab_ask
PICK_BOWLER ENDP
 
PICK_BATSMAN PROC NEAR
anb_ask:
    PRINT ask_next_bat
    CALL READ_NUM
    CMP AX, 1
    JB  anb_bad
    MOV BL, [n_players]
    MOV BH, 0
    CMP AX, BX
    JA  anb_bad
    DEC AX
    MOV [striker], AL
    RET
anb_bad:
    PRINT inv_range
    JMP anb_ask
PICK_BATSMAN ENDP
 

;     I/O Helpers

 

READ_UPCHAR PROC NEAR
    MOV AH, 01H
    INT 21H
    CMP AL, 'a'
    JB  ru_done
    CMP AL, 'z'
    JA  ru_done
    SUB AL, 32
ru_done:
    RET
READ_UPCHAR ENDP
 

READ_NUM PROC NEAR
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI
    LEA DX, input_buf
    MOV AH, 0AH
    INT 21H
    LEA SI, input_buf
    INC SI              
    MOV CL, [SI]        
    INC SI             
    MOV CH, 0
    XOR BX, BX          
    JCXZ rn_end
rn_lp:
    MOV AL, [SI]
    CMP AL, '0'
    JB  rn_skip
    CMP AL, '9'
    JA  rn_skip
    SUB AL, '0'
    MOV AH, 0
    ; BX = BX*10 + AL
    PUSH AX
    MOV AX, BX
    MOV DX, 10
    MUL DX              
    MOV BX, AX
    POP AX
    ADD BX, AX
rn_skip:
    INC SI
    DEC CL
    JNZ rn_lp
rn_end:
    MOV AX, BX
    ; newline for readability
    NL
    POP SI
    POP DX
    POP CX
    POP BX
    RET
READ_NUM ENDP
 

READ_NAME10 PROC NEAR
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI
    PUSH DI
 
    MOV DI, BX          ; DI = destination
    LEA DX, input_buf
    MOV AH, 0AH
    INT 21H
 
    LEA SI, input_buf
    INC SI              
    MOV CL, [SI]
    INC SI              
    MOV CH, 0
 
    CMP CL, 10
    JBE rn10_ok
    MOV CL, 10
rn10_ok:
    MOV BL, CL         
    ; copy
    JCXZ rn10_nc
rn10_cp:
    MOV AL, [SI]
    MOV [DI], AL
    INC SI
    INC DI
    LOOP rn10_cp
rn10_nc:
    ; pad with spaces
    MOV CL, 10
    SUB CL, BL
    CMP CL, 0
    JE rn10_end
rn10_pad:
    MOV BYTE PTR [DI], ' '
    INC DI
    DEC CL
    JNZ rn10_pad
rn10_end:
    MOV BYTE PTR [DI], '$'
    INC DI
    MOV BYTE PTR [DI], '$'  
 
    POP DI
    POP SI
    POP DX
    POP CX
    POP BX
    POP AX
    RET
READ_NAME10 ENDP
 
; Print AL legal balls as cricket overs: O.B.
PRINT_OVERS PROC NEAR
    PUSH AX
    PUSH BX
    PUSH DX
    MOV AH, 0
    MOV BL, 6
    DIV BL
    MOV DL, AH
    MOV AH, 0
    CALL PRINT_DEC
    PUTC '.'
    MOV AL, DL
    MOV AH, 0
    CALL PRINT_DEC
    POP DX
    POP BX
    POP AX
    RET
PRINT_OVERS ENDP

; Print AX as decimal.
PRINT_DEC PROC NEAR
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    MOV CX, 0
    MOV BX, 10
pd_div:
    XOR DX, DX
    DIV BX
    PUSH DX
    INC CX
    CMP AX, 0
    JNE pd_div
pd_out:
    POP DX
    ADD DL, '0'
    MOV AH, 02H
    INT 21H
    LOOP pd_out
    POP DX
    POP CX
    POP BX
    POP AX
    RET
PRINT_DEC ENDP
 
END MAIN
   
   
 ;;;;