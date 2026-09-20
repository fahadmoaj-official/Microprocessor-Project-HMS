


org 100h


; ============================================================
;        HEALTHCARE MANAGEMENT SYSTEM
;        8086 Assembly Language - EMU8086
; ============================================================
;
; Maximum records:
;   Patients      = 10
;   Doctors       = 10
;   Appointments  = 10
;   Medicines     = 10
;
; Uses:
;   INT 21H
;   AH=01H  Character input
;   AH=09H  String output
;   AH=0AH  Buffered string input
;   AH=4CH  Program termination
;
; ============================================================

.MODEL SMALL
.STACK 100H

.DATA

; ------------------------------------------------------------
; GENERAL MESSAGES
; ------------------------------------------------------------

welcome1       DB 13,10,'========================================$'
welcome2       DB 13,10,'      HEALTHCARE MANAGEMENT SYSTEM     $'
welcome3       DB 13,10,'========================================$'
welcome4       DB 13,10,'Welcome to Healthcare Management System$'
pressMsg       DB 13,10,'Press any key to continue...$'

mainTitle      DB 13,10,'========================================$'
mainTitle2     DB 13,10,'              MAIN MENU$'
mainTitle3     DB 13,10,'========================================$'

invalidMsg     DB 13,10,'Invalid Choice! Please try again.$'
notFoundMsg    DB 13,10,'Record Not Found!$'
patientNF      DB 13,10,'Patient Not Found.$'
doctorNF       DB 13,10,'Doctor Not Found.$'
appointmentNF  DB 13,10,'Appointment Not Found.$'
medicineNF     DB 13,10,'Medicine Not Found.$'

successAdd     DB 13,10,'Successfully Added!$'
successUpdate  DB 13,10,'Successfully Updated!$'
successDelete  DB 13,10,'Successfully Deleted!$'

noPatient      DB 13,10,'No Patient Record Found.$'
noDoctor       DB 13,10,'No Doctor Record Found.$'
noAppointment  DB 13,10,'No Appointment Record Found.$'
noMedicine     DB 13,10,'No Medicine Record Found.$'

fullMsg        DB 13,10,'Maximum record limit reached.$'

idPrompt       DB 13,10,'Enter ID: $'
namePrompt     DB 13,10,'Enter Name: $'
agePrompt      DB 13,10,'Enter Age: $'
genderPrompt   DB 13,10,'Enter Gender (M/F): $'
phonePrompt    DB 13,10,'Enter Phone Number: $'

doctorNamePr   DB 13,10,'Enter Doctor Name: $'
specialPr      DB 13,10,'Enter Specialization: $'
availabilityPr DB 13,10,'Enter Availability (1=Available, 0=Not Available): $'

appointmentIdPr DB 13,10,'Enter Appointment ID: $'
patientIdPr     DB 13,10,'Enter Patient ID: $'
doctorIdPr      DB 13,10,'Enter Doctor ID: $'
datePr          DB 13,10,'Enter Date: $'

medicineIdPr   DB 13,10,'Enter Medicine ID: $'
medicineNamePr DB 13,10,'Enter Medicine Name: $'
quantityPr     DB 13,10,'Enter Quantity: $'
pricePr        DB 13,10,'Enter Price: $'

; ------------------------------------------------------------
; INPUT BUFFER
; ------------------------------------------------------------

inputBuf       DB 40
               DB 0
               DB 40 DUP(0)

; ------------------------------------------------------------
; PATIENT DATA
; ------------------------------------------------------------

patientCount   DW 0

patientActive  DB 10 DUP(0)
patientID      DW 10 DUP(0)
patientAge     DW 10 DUP(0)
patientGender  DB 10 DUP(0)

patientNames   DB 200 DUP('$')     ; 10 * 20
patientPhones  DB 150 DUP('$')     ; 10 * 15

; ------------------------------------------------------------
; DOCTOR DATA
; ------------------------------------------------------------

doctorCount    DW 0

doctorActive   DB 10 DUP(0)
doctorID       DW 10 DUP(0)
doctorAvail    DB 10 DUP(0)

doctorNames    DB 200 DUP('$')     ; 10 * 20
doctorSpecial  DB 200 DUP('$')     ; 10 * 20

; ------------------------------------------------------------
; APPOINTMENT DATA
; ------------------------------------------------------------

appointmentCount  DW 0

appointmentActive DB 10 DUP(0)
appointmentID     DW 10 DUP(0)
appointmentPatient DW 10 DUP(0)
appointmentDoctor  DW 10 DUP(0)
appointmentStatus  DB 10 DUP(0)

appointmentDates  DB 150 DUP('$')  ; 10 * 15

; Status:
; 1 = Pending
; 2 = Confirmed
; 3 = Completed
; 4 = Cancelled

; ------------------------------------------------------------
; PHARMACY DATA
; ------------------------------------------------------------

medicineCount  DW 0

medicineActive DB 10 DUP(0)
medicineID     DW 10 DUP(0)
medicineQty    DW 10 DUP(0)
medicinePrice  DW 10 DUP(0)

medicineNames  DB 200 DUP('$')     ; 10 * 20

; ------------------------------------------------------------
; TEMPORARY VARIABLES
; ------------------------------------------------------------

tempID         DW 0
tempIndex      DW 0

.CODE

; ============================================================
; MAIN
; ============================================================

MAIN PROC

    MOV AX,@DATA
    MOV DS,AX

    CALL WELCOME_SCREEN

MAIN_LOOP:

    CALL MAIN_MENU

    CMP AL,'1'
    JE OPEN_PATIENT

    CMP AL,'2'
    JE OPEN_DOCTOR

    CMP AL,'3'
    JE OPEN_APPOINTMENT

    CMP AL,'4'
    JE OPEN_PHARMACY

    CMP AL,'5'
    JE EXIT_PROGRAM

    LEA DX,invalidMsg
    CALL PRINT_STRING
    CALL NEW_LINE
    JMP MAIN_LOOP

OPEN_PATIENT:

    CALL PATIENT_MENU
    JMP MAIN_LOOP

OPEN_DOCTOR:

    CALL DOCTOR_MENU
    JMP MAIN_LOOP

OPEN_APPOINTMENT:

    CALL APPOINTMENT_MENU
    JMP MAIN_LOOP

OPEN_PHARMACY:

    CALL PHARMACY_MENU
    JMP MAIN_LOOP

EXIT_PROGRAM:

    MOV AH,4CH
    INT 21H

MAIN ENDP


; ============================================================
; GENERAL PROCEDURES
; ============================================================

WELCOME_SCREEN PROC

    LEA DX,welcome1
    CALL PRINT_STRING

    LEA DX,welcome2
    CALL PRINT_STRING

    LEA DX,welcome3
    CALL PRINT_STRING

    LEA DX,welcome4
    CALL PRINT_STRING

    LEA DX,pressMsg
    CALL PRINT_STRING

    CALL WAIT_KEY

    RET

WELCOME_SCREEN ENDP


; ------------------------------------------------------------
; PRINT STRING
; DX = address of $ terminated string
; ------------------------------------------------------------

PRINT_STRING PROC

    MOV AH,09H
    INT 21H

    RET

PRINT_STRING ENDP


; ------------------------------------------------------------
; NEW LINE
; ------------------------------------------------------------

NEW_LINE PROC

    MOV DL,13
    MOV AH,02H
    INT 21H

    MOV DL,10
    MOV AH,02H
    INT 21H

    RET

NEW_LINE ENDP


; ------------------------------------------------------------
; WAIT FOR KEY
; ------------------------------------------------------------

WAIT_KEY PROC

    MOV AH,08H
    INT 21H

    RET

WAIT_KEY ENDP


; ------------------------------------------------------------
; READ CHARACTER
; Returns AL
; ------------------------------------------------------------

READ_CHAR PROC

    MOV AH,01H
    INT 21H

    RET

READ_CHAR ENDP


; ------------------------------------------------------------
; READ STRING
; Uses DOS buffered input
; ------------------------------------------------------------

READ_STRING PROC

    LEA DX,inputBuf
    MOV AH,0AH
    INT 21H

    RET

READ_STRING ENDP


; ------------------------------------------------------------
; STORE INPUT STRING
;
; Input:
;   DI = destination
;   CX = maximum slot size
;
; Data:
;   inputBuf+1 = number of characters
;   inputBuf+2 = characters
;
; Remaining space is filled with '$'
; ------------------------------------------------------------

STORE_STRING PROC

    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI

    MOV SI,OFFSET inputBuf
    INC SI
    MOV BL,[SI]          ; character count
    XOR BH,BH

    INC SI
    PUSH CX

COPY_STRING_LOOP:

    CMP BX,0
    JE FILL_STRING

    MOV AL,[SI]
    MOV [DI],AL

    INC SI
    INC DI
    DEC BX
    LOOP COPY_STRING_LOOP

    POP CX
    JMP STORE_STRING_DONE


FILL_STRING:

    POP CX

FILL_LOOP:

    MOV BYTE PTR [DI],'$'
    INC DI
    LOOP FILL_LOOP

STORE_STRING_DONE:

    POP SI
    POP DX
    POP CX
    POP BX
    POP AX

    RET

STORE_STRING ENDP


; ------------------------------------------------------------
; READ NUMBER
;
; Returns AX
; ------------------------------------------------------------

READ_NUMBER PROC

    CALL READ_STRING

    XOR AX,AX

    MOV SI,OFFSET inputBuf
    MOV CL,[SI+1]
    XOR CH,CH

    CMP CX,0
    JE READ_NUMBER_DONE

    ADD SI,2

NUMBER_LOOP:

    XOR DX,DX
    MOV DL,[SI]
    SUB DL,'0'

    PUSH DX

    MOV BX,10
    MUL BX

    POP DX

    ADD AX,DX

    INC SI

    LOOP NUMBER_LOOP

READ_NUMBER_DONE:

    RET

READ_NUMBER ENDP


; ------------------------------------------------------------
; PRINT NUMBER
; AX = number
; ------------------------------------------------------------

PRINT_NUMBER PROC

    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX

    CMP AX,0
    JNE PRINT_NUMBER_START

    MOV DL,'0'
    MOV AH,02H
    INT 21H
    JMP PRINT_NUMBER_DONE


PRINT_NUMBER_START:

    XOR CX,CX
    MOV BX,10

PRINT_DIVIDE:

    XOR DX,DX
    DIV BX

    PUSH DX
    INC CX

    CMP AX,0
    JNE PRINT_DIVIDE


PRINT_DIGITS:

    POP DX
    ADD DL,'0'

    MOV AH,02H
    INT 21H

    LOOP PRINT_DIGITS


PRINT_NUMBER_DONE:

    POP DX
    POP CX
    POP BX
    POP AX

    RET

PRINT_NUMBER ENDP


; ============================================================
; MAIN MENU
; ============================================================

MAIN_MENU PROC

    CALL NEW_LINE

    LEA DX,mainTitle
    CALL PRINT_STRING

    LEA DX,mainTitle2
    CALL PRINT_STRING

    LEA DX,mainTitle3
    CALL PRINT_STRING

    LEA DX,menu1
    CALL PRINT_STRING

    LEA DX,menu2
    CALL PRINT_STRING

    LEA DX,menu3
    CALL PRINT_STRING

    LEA DX,menu4
    CALL PRINT_STRING

    LEA DX,menu5
    CALL PRINT_STRING

    LEA DX,choiceMsg
    CALL PRINT_STRING

    CALL READ_CHAR

    RET

MAIN_MENU ENDP


menu1       DB 13,10,'1. Patient Management$'
menu2       DB 13,10,'2. Doctor Management$'
menu3       DB 13,10,'3. Appointment Management$'
menu4       DB 13,10,'4. Pharmacy Management$'
menu5       DB 13,10,'5. Exit$'
choiceMsg   DB 13,10,'Enter your choice: $'


; ============================================================
; PATIENT MANAGEMENT MENU
; ============================================================

PATIENT_MENU PROC

PATIENT_MENU_LOOP:

    CALL NEW_LINE

    LEA DX,patientTitle
    CALL PRINT_STRING

    LEA DX,patientMenu1
    CALL PRINT_STRING

    LEA DX,patientMenu2
    CALL PRINT_STRING

    LEA DX,patientMenu3
    CALL PRINT_STRING

    LEA DX,patientMenu4
    CALL PRINT_STRING

    LEA DX,patientMenu5
    CALL PRINT_STRING

    LEA DX,backMenu
    CALL PRINT_STRING

    LEA DX,choiceMsg
    CALL PRINT_STRING

    CALL READ_CHAR

    CMP AL,'1'
    JE PM_ADD

    CMP AL,'2'
    JE PM_VIEW

    CMP AL,'3'
    JE PM_SEARCH

    CMP AL,'4'
    JE PM_UPDATE

    CMP AL,'5'
    JE PM_DELETE

    CMP AL,'6'
    JE PM_BACK

    LEA DX,invalidMsg
    CALL PRINT_STRING
    CALL WAIT_KEY
    JMP PATIENT_MENU_LOOP


PM_ADD:

    CALL ADD_PATIENT
    CALL WAIT_KEY
    JMP PATIENT_MENU_LOOP


PM_VIEW:

    CALL VIEW_PATIENTS
    CALL WAIT_KEY
    JMP PATIENT_MENU_LOOP


PM_SEARCH:

    CALL SEARCH_PATIENT
    CALL WAIT_KEY
    JMP PATIENT_MENU_LOOP


PM_UPDATE:

    CALL UPDATE_PATIENT
    CALL WAIT_KEY
    JMP PATIENT_MENU_LOOP


PM_DELETE:

    CALL DELETE_PATIENT
    CALL WAIT_KEY
    JMP PATIENT_MENU_LOOP


PM_BACK:

    RET

PATIENT_MENU ENDP


patientTitle DB 13,10,'========================================'
             DB 13,10,'         PATIENT MANAGEMENT'
             DB 13,10,'========================================$'

patientMenu1 DB 13,10,'1. Add Patient$'
patientMenu2 DB 13,10,'2. View Patient$'
patientMenu3 DB 13,10,'3. Search Patient$'
patientMenu4 DB 13,10,'4. Update Patient$'
patientMenu5 DB 13,10,'5. Delete Patient$'
backMenu     DB 13,10,'6. Back to Main Menu$'


; ============================================================
; ADD PATIENT
; ============================================================

ADD_PATIENT PROC

    CMP patientCount,10
    JB ADD_PATIENT_SPACE

    LEA DX,fullMsg
    CALL PRINT_STRING
    RET


ADD_PATIENT_SPACE:

    ; Find first inactive slot
    XOR BX,BX

FIND_PATIENT_SLOT:

    CMP BYTE PTR patientActive[BX],0
    JE PATIENT_SLOT_FOUND

    INC BX
    CMP BX,10
    JB FIND_PATIENT_SLOT

    LEA DX,fullMsg
    CALL PRINT_STRING
    RET


PATIENT_SLOT_FOUND:

    MOV tempIndex,BX

    CALL NEW_LINE

    LEA DX,idPrompt
    CALL PRINT_STRING
    CALL READ_NUMBER

    MOV BX,tempIndex
    MOV patientID[BX*2],AX

    LEA DX,namePrompt
    CALL PRINT_STRING
    CALL READ_STRING

    MOV AX,tempIndex
    MOV BX,20
    MUL BX

    MOV DI,OFFSET patientNames
    ADD DI,AX

    MOV CX,20
    CALL STORE_STRING

    LEA DX,agePrompt
    CALL PRINT_STRING
    CALL READ_NUMBER

    MOV BX,tempIndex
    MOV patientAge[BX*2],AX

    LEA DX,genderPrompt
    CALL PRINT_STRING
    CALL READ_CHAR
    MOV BX,tempIndex
    MOV patientGender[BX],AL

    CALL NEW_LINE

    LEA DX,phonePrompt
    CALL PRINT_STRING
    CALL READ_STRING

    MOV AX,tempIndex
    MOV BX,15
    MUL BX

    MOV DI,OFFSET patientPhones
    ADD DI,AX

    MOV CX,15
    CALL STORE_STRING

    MOV BX,tempIndex
    MOV BYTE PTR patientActive[BX],1

    INC patientCount

    LEA DX,successAdd
    CALL PRINT_STRING

    RET

ADD_PATIENT ENDP


; ============================================================
; VIEW PATIENTS
; ============================================================

VIEW_PATIENTS PROC

    CMP patientCount,0
    JNE VIEW_PATIENT_START

    LEA DX,noPatient
    CALL PRINT_STRING
    RET


VIEW_PATIENT_START:

    XOR BX,BX

VIEW_PATIENT_LOOP:

    CMP BYTE PTR patientActive[BX],1
    JNE NEXT_PATIENT

    CALL DISPLAY_PATIENT_BY_INDEX


NEXT_PATIENT:

    INC BX
    CMP BX,10
    JB VIEW_PATIENT_LOOP

    RET

VIEW_PATIENTS ENDP


; ============================================================
; DISPLAY PATIENT
; BX = index
; ============================================================

DISPLAY_PATIENT_BY_INDEX PROC

    PUSH BX

    CALL NEW_LINE

    LEA DX,patientIDMsg
    CALL PRINT_STRING

    MOV AX,patientID[BX*2]
    CALL PRINT_NUMBER

    LEA DX,nameMsg
    CALL PRINT_STRING

    MOV AX,BX
    MOV DX,20
    MUL DX

    MOV SI,OFFSET patientNames
    ADD SI,AX

    MOV DX,SI
    CALL PRINT_STRING

    LEA DX,ageMsg
    CALL PRINT_STRING

    MOV AX,BX
    MOV SI,AX
    MOV AX,patientAge[SI*2]
    CALL PRINT_NUMBER

    LEA DX,genderMsg
    CALL PRINT_STRING

    MOV AL,patientGender[BX]

    CMP AL,'M'
    JE DISPLAY_MALE

    CMP AL,'m'
    JE DISPLAY_MALE

    LEA DX,femaleMsg
    CALL PRINT_STRING
    JMP DISPLAY_PHONE


DISPLAY_MALE:

    LEA DX,maleMsg
    CALL PRINT_STRING


DISPLAY_PHONE:

    LEA DX,phoneMsg
    CALL PRINT_STRING

    MOV AX,BX
    MOV DX,15
    MUL DX

    MOV SI,OFFSET patientPhones
    ADD SI,AX

    MOV DX,SI
    CALL PRINT_STRING

    CALL NEW_LINE

    POP BX

    RET

DISPLAY_PATIENT_BY_INDEX ENDP


patientIDMsg DB 13,10,'Patient ID : $'
nameMsg      DB 13,10,'Name       : $'
ageMsg       DB 13,10,'Age        : $'
genderMsg    DB 13,10,'Gender     : $'
phoneMsg     DB 13,10,'Phone      : $'
maleMsg      DB 'Male$'
femaleMsg    DB 'Female$'


; ============================================================
; SEARCH PATIENT
; ============================================================

SEARCH_PATIENT PROC

    LEA DX,idPrompt
    CALL PRINT_STRING
    CALL READ_NUMBER

    MOV tempID,AX

    XOR BX,BX

SEARCH_PATIENT_LOOP:

    CMP BYTE PTR patientActive[BX],1
    JNE SEARCH_PATIENT_NEXT

    MOV AX,patientID[BX*2]

    CMP AX,tempID
    JE SEARCH_PATIENT_FOUND


SEARCH_PATIENT_NEXT:

    INC BX
    CMP BX,10
    JB SEARCH_PATIENT_LOOP

    LEA DX,patientNF
    CALL PRINT_STRING

    RET


SEARCH_PATIENT_FOUND:

    LEA DX,patientFoundMsg
    CALL PRINT_STRING

    CALL DISPLAY_PATIENT_BY_INDEX

    RET

SEARCH_PATIENT ENDP


patientFoundMsg DB 13,10,'Patient Found!$'


; ============================================================
; UPDATE PATIENT
; ============================================================

UPDATE_PATIENT PROC

    LEA DX,idPrompt
    CALL PRINT_STRING
    CALL READ_NUMBER

    MOV tempID,AX

    XOR BX,BX

UPDATE_PATIENT_SEARCH:

    CMP BYTE PTR patientActive[BX],1
    JNE UPDATE_PATIENT_NEXT

    MOV AX,patientID[BX*2]

    CMP AX,tempID
    JE UPDATE_PATIENT_FOUND


UPDATE_PATIENT_NEXT:

    INC BX
    CMP BX,10
    JB UPDATE_PATIENT_SEARCH

    LEA DX,patientNF
    CALL PRINT_STRING
    RET


UPDATE_PATIENT_FOUND:

    MOV tempIndex,BX

    LEA DX,namePrompt
    CALL PRINT_STRING
    CALL READ_STRING

    MOV AX,tempIndex
    MOV BX,20
    MUL BX

    MOV DI,OFFSET patientNames
    ADD DI,AX

    MOV CX,20
    CALL STORE_STRING

    LEA DX,agePrompt
    CALL PRINT_STRING
    CALL READ_NUMBER

    MOV BX,tempIndex
    MOV patientAge[BX*2],AX

    LEA DX,genderPrompt
    CALL PRINT_STRING
    CALL READ_CHAR

    MOV BX,tempIndex
    MOV patientGender[BX],AL

    CALL NEW_LINE

    LEA DX,phonePrompt
    CALL PRINT_STRING
    CALL READ_STRING

    MOV AX,tempIndex
    MOV BX,15
    MUL BX

    MOV DI,OFFSET patientPhones
    ADD DI,AX

    MOV CX,15
    CALL STORE_STRING

    LEA DX,successUpdate
    CALL PRINT_STRING

    RET

UPDATE_PATIENT ENDP


; ============================================================
; DELETE PATIENT
; ============================================================

DELETE_PATIENT PROC

    LEA DX,idPrompt
    CALL PRINT_STRING
    CALL READ_NUMBER

    MOV tempID,AX

    XOR BX,BX

DELETE_PATIENT_SEARCH:

    CMP BYTE PTR patientActive[BX],1
    JNE DELETE_PATIENT_NEXT

    MOV AX,patientID[BX*2]

    CMP AX,tempID
    JE DELETE_PATIENT_FOUND


DELETE_PATIENT_NEXT:

    INC BX
    CMP BX,10
    JB DELETE_PATIENT_SEARCH

    LEA DX,patientNF
    CALL PRINT_STRING
    RET


DELETE_PATIENT_FOUND:

    MOV BYTE PTR patientActive[BX],0
    DEC patientCount

    LEA DX,successDelete
    CALL PRINT_STRING

    RET

DELETE_PATIENT ENDP


; ============================================================
; DOCTOR MENU
; ============================================================

DOCTOR_MENU PROC

DOCTOR_MENU_LOOP:

    CALL NEW_LINE

    LEA DX,doctorTitle
    CALL PRINT_STRING

    LEA DX,doctorMenu1
    CALL PRINT_STRING

    LEA DX,doctorMenu2
    CALL PRINT_STRING

    LEA DX,doctorMenu3
    CALL PRINT_STRING

    LEA DX,doctorMenu4
    CALL PRINT_STRING

    LEA DX,doctorMenu5
    CALL PRINT_STRING

    LEA DX,backMenu
    CALL PRINT_STRING

    LEA DX,choiceMsg
    CALL PRINT_STRING

    CALL READ_CHAR

    CMP AL,'1'
    JE DM_ADD

    CMP AL,'2'
    JE DM_VIEW

    CMP AL,'3'
    JE DM_SEARCH

    CMP AL,'4'
    JE DM_SPECIAL

    CMP AL,'5'
    JE DM_AVAIL

    CMP AL,'6'
    JE DM_BACK

    LEA DX,invalidMsg
    CALL PRINT_STRING
    CALL WAIT_KEY
    JMP DOCTOR_MENU_LOOP


DM_ADD:

    CALL ADD_DOCTOR
    CALL WAIT_KEY
    JMP DOCTOR_MENU_LOOP

DM_VIEW:

    CALL VIEW_DOCTORS
    CALL WAIT_KEY
    JMP DOCTOR_MENU_LOOP

DM_SEARCH:

    CALL SEARCH_DOCTOR
    CALL WAIT_KEY
    JMP DOCTOR_MENU_LOOP

DM_SPECIAL:

    CALL SPECIALIZATION
    CALL WAIT_KEY
    JMP DOCTOR_MENU_LOOP

DM_AVAIL:

    CALL AVAILABILITY
    CALL WAIT_KEY
    JMP DOCTOR_MENU_LOOP

DM_BACK:

    RET

DOCTOR_MENU ENDP


doctorTitle DB 13,10,'========================================'
            DB 13,10,'          DOCTOR MANAGEMENT'
            DB 13,10,'========================================$'

doctorMenu1 DB 13,10,'1. Add Doctor$'
doctorMenu2 DB 13,10,'2. View Doctors$'
doctorMenu3 DB 13,10,'3. Search Doctor$'
doctorMenu4 DB 13,10,'4. Doctor Specialization$'
doctorMenu5 DB 13,10,'5. Doctor Availability$'


; ============================================================
; ADD DOCTOR
; ============================================================

ADD_DOCTOR PROC

    CMP doctorCount,10
    JB ADD_DOCTOR_SPACE

    LEA DX,fullMsg
    CALL PRINT_STRING
    RET


ADD_DOCTOR_SPACE:

    XOR BX,BX

FIND_DOCTOR_SLOT:

    CMP BYTE PTR doctorActive[BX],0
    JE DOCTOR_SLOT_FOUND

    INC BX
    CMP BX,10
    JB FIND_DOCTOR_SLOT

    RET


DOCTOR_SLOT_FOUND:

    MOV tempIndex,BX

    LEA DX,idPrompt
    CALL PRINT_STRING
    CALL READ_NUMBER

    MOV BX,tempIndex
    MOV doctorID[BX*2],AX

    LEA DX,doctorNamePr
    CALL PRINT_STRING
    CALL READ_STRING

    MOV AX,tempIndex
    MOV BX,20
    MUL BX

    MOV DI,OFFSET doctorNames
    ADD DI,AX

    MOV CX,20
    CALL STORE_STRING

    LEA DX,specialPr
    CALL PRINT_STRING
    CALL READ_STRING

    MOV AX,tempIndex
    MOV BX,20
    MUL BX

    MOV DI,OFFSET doctorSpecial
    ADD DI,AX

    MOV CX,20
    CALL STORE_STRING

    LEA DX,availabilityPr
    CALL PRINT_STRING
    CALL READ_CHAR

    MOV BX,tempIndex
    SUB AL,'0'
    MOV doctorAvail[BX],AL

    MOV BYTE PTR doctorActive[BX],1
    INC doctorCount

    LEA DX,successAdd
    CALL PRINT_STRING

    RET

ADD_DOCTOR ENDP


; ============================================================
; VIEW DOCTORS
; ============================================================

VIEW_DOCTORS PROC

    CMP doctorCount,0
    JNE VIEW_DOCTORS_START

    LEA DX,noDoctor
    CALL PRINT_STRING
    RET


VIEW_DOCTORS_START:

    XOR BX,BX

VIEW_DOCTORS_LOOP:

    CMP BYTE PTR doctorActive[BX],1
    JNE VIEW_DOCTORS_NEXT

    CALL DISPLAY_DOCTOR


VIEW_DOCTORS_NEXT:

    INC BX
    CMP BX,10
    JB VIEW_DOCTORS_LOOP

    RET

VIEW_DOCTORS ENDP


; ============================================================
; DISPLAY DOCTOR
; BX = index
; ============================================================

DISPLAY_DOCTOR PROC

    PUSH BX

    CALL NEW_LINE

    LEA DX,doctorIDMsg
    CALL PRINT_STRING

    MOV AX,doctorID[BX*2]
    CALL PRINT_NUMBER

    LEA DX,doctorNameMsg
    CALL PRINT_STRING

    MOV AX,BX
    MOV DX,20
    MUL DX

    MOV SI,OFFSET doctorNames
    ADD SI,AX

    MOV DX,SI
    CALL PRINT_STRING

    LEA DX,specialMsg
    CALL PRINT_STRING

    MOV AX,BX
    MOV DX,20
    MUL DX

    MOV SI,OFFSET doctorSpecial
    ADD SI,AX

    MOV DX,SI
    CALL PRINT_STRING

    LEA DX,availabilityMsg
    CALL PRINT_STRING

    MOV AL,doctorAvail[BX]

    CMP AL,1
    JE DOCTOR_AVAILABLE

    LEA DX,notAvailableMsg
    CALL PRINT_STRING
    JMP DOCTOR_DISPLAY_DONE


DOCTOR_AVAILABLE:

    LEA DX,availableMsg
    CALL PRINT_STRING


DOCTOR_DISPLAY_DONE:

    CALL NEW_LINE

    POP BX

    RET

DISPLAY_DOCTOR ENDP


doctorIDMsg       DB 13,10,'Doctor ID       : $'
doctorNameMsg     DB 13,10,'Doctor Name     : $'
specialMsg        DB 13,10,'Specialization  : $'
availabilityMsg   DB 13,10,'Availability    : $'
availableMsg      DB 'Available$'
notAvailableMsg   DB 'Not Available$'


; ============================================================
; SEARCH DOCTOR
; ============================================================

SEARCH_DOCTOR PROC

    LEA DX,idPrompt
    CALL PRINT_STRING
    CALL READ_NUMBER

    MOV tempID,AX

    XOR BX,BX

SEARCH_DOCTOR_LOOP:

    CMP BYTE PTR doctorActive[BX],1
    JNE SEARCH_DOCTOR_NEXT

    MOV AX,doctorID[BX*2]

    CMP AX,tempID
    JE SEARCH_DOCTOR_FOUND


SEARCH_DOCTOR_NEXT:

    INC BX
    CMP BX,10
    JB SEARCH_DOCTOR_LOOP

    LEA DX,doctorNF
    CALL PRINT_STRING
    RET


SEARCH_DOCTOR_FOUND:

    LEA DX,doctorFoundMsg
    CALL PRINT_STRING

    CALL DISPLAY_DOCTOR

    RET

SEARCH_DOCTOR ENDP


doctorFoundMsg DB 13,10,'Doctor Found!$'


; ============================================================
; SPECIALIZATION
; ============================================================

SPECIALIZATION PROC

    CALL NEW_LINE

    LEA DX,specialTitle
    CALL PRINT_STRING

    LEA DX,special1
    CALL PRINT_STRING

    LEA DX,special2
    CALL PRINT_STRING

    LEA DX,special3
    CALL PRINT_STRING

    LEA DX,special4
    CALL PRINT_STRING

    RET

SPECIALIZATION ENDP


specialTitle DB 13,10,'Available Specializations:$'
special1 DB 13,10,'1. Cardiology$'
special2 DB 13,10,'2. Medicine$'
special3 DB 13,10,'3. Neurology$'
special4 DB 13,10,'4. Dermatology$'


; ============================================================
; AVAILABILITY
; ============================================================

AVAILABILITY PROC

    CMP doctorCount,0
    JNE AVAIL_START

    LEA DX,noDoctor
    CALL PRINT_STRING
    RET


AVAIL_START:

    XOR BX,BX

AVAIL_LOOP:

    CMP BYTE PTR doctorActive[BX],1
    JNE AVAIL_NEXT

    MOV AX,BX
    MOV DX,20
    MUL DX

    MOV SI,OFFSET doctorNames
    ADD SI,AX

    MOV DX,SI
    CALL PRINT_STRING

    LEA DX,dashMsg
    CALL PRINT_STRING

    MOV AL,doctorAvail[BX]

    CMP AL,1
    JE AVAIL_YES

    LEA DX,notAvailableMsg
    CALL PRINT_STRING
    JMP AVAIL_NEXT


AVAIL_YES:

    LEA DX,availableMsg
    CALL PRINT_STRING


AVAIL_NEXT:

    CALL NEW_LINE

    INC BX
    CMP BX,10
    JB AVAIL_LOOP

    RET

AVAILABILITY ENDP


dashMsg DB ' - $'


; ============================================================
; APPOINTMENT MENU
; ============================================================

APPOINTMENT_MENU PROC

APPOINTMENT_MENU_LOOP:

    CALL NEW_LINE

    LEA DX,appointmentTitle
    CALL PRINT_STRING

    LEA DX,appointmentMenu1
    CALL PRINT_STRING

    LEA DX,appointmentMenu2
    CALL PRINT_STRING

    LEA DX,appointmentMenu3
    CALL PRINT_STRING

    LEA DX,appointmentMenu4
    CALL PRINT_STRING

    LEA DX,appointmentMenu5
    CALL PRINT_STRING

    LEA DX,backMenu
    CALL PRINT_STRING

    LEA DX,choiceMsg
    CALL PRINT_STRING

    CALL READ_CHAR

    CMP AL,'1'
    JE AM_BOOK

    CMP AL,'2'
    JE AM_VIEW

    CMP AL,'3'
    JE AM_SEARCH

    CMP AL,'4'
    JE AM_CANCEL

    CMP AL,'5'
    JE AM_STATUS

    CMP AL,'6'
    JE AM_BACK

    LEA DX,invalidMsg
    CALL PRINT_STRING
    CALL WAIT_KEY
    JMP APPOINTMENT_MENU_LOOP


AM_BOOK:

    CALL BOOK_APPOINTMENT
    CALL WAIT_KEY
    JMP APPOINTMENT_MENU_LOOP


AM_VIEW:

    CALL VIEW_APPOINTMENTS
    CALL WAIT_KEY
    JMP APPOINTMENT_MENU_LOOP


AM_SEARCH:

    CALL SEARCH_APPOINTMENT
    CALL WAIT_KEY
    JMP APPOINTMENT_MENU_LOOP


AM_CANCEL:

    CALL CANCEL_APPOINTMENT
    CALL WAIT_KEY
    JMP APPOINTMENT_MENU_LOOP


AM_STATUS:

    CALL APPOINTMENT_STATUS
    CALL WAIT_KEY
    JMP APPOINTMENT_MENU_LOOP


AM_BACK:

    RET

APPOINTMENT_MENU ENDP


appointmentTitle DB 13,10,'========================================'
                 DB 13,10,'       APPOINTMENT MANAGEMENT'
                 DB 13,10,'========================================$'

appointmentMenu1 DB 13,10,'1. Book Appointment$'
appointmentMenu2 DB 13,10,'2. View Appointment$'
appointmentMenu3 DB 13,10,'3. Search Appointment$'
appointmentMenu4 DB 13,10,'4. Cancel Appointment$'
appointmentMenu5 DB 13,10,'5. Appointment Status$'


; ============================================================
; BOOK APPOINTMENT
; ============================================================

BOOK_APPOINTMENT PROC

    CMP appointmentCount,10
    JB BOOK_SPACE

    LEA DX,fullMsg
    CALL PRINT_STRING
    RET


BOOK_SPACE:

    XOR BX,BX

FIND_APPOINTMENT_SLOT:

    CMP BYTE PTR appointmentActive[BX],0
    JE APPOINTMENT_SLOT_FOUND

    INC BX
    CMP BX,10
    JB FIND_APPOINTMENT_SLOT

    RET


APPOINTMENT_SLOT_FOUND:

    MOV tempIndex,BX

    LEA DX,appointmentIdPr
    CALL PRINT_STRING
    CALL READ_NUMBER

    MOV BX,tempIndex
    MOV appointmentID[BX*2],AX

    LEA DX,patientIdPr
    CALL PRINT_STRING
    CALL READ_NUMBER

    MOV BX,tempIndex
    MOV appointmentPatient[BX*2],AX

    LEA DX,doctorIdPr
    CALL PRINT_STRING
    CALL READ_NUMBER

    MOV BX,tempIndex
    MOV appointmentDoctor[BX*2],AX

    LEA DX,datePr
    CALL PRINT_STRING
    CALL READ_STRING

    MOV AX,tempIndex
    MOV BX,15
    MUL BX

    MOV DI,OFFSET appointmentDates
    ADD DI,AX

    MOV CX,15
    CALL STORE_STRING

    MOV BX,tempIndex

    ; Default status = Confirmed
    MOV BYTE PTR appointmentStatus[BX],2

    MOV BYTE PTR appointmentActive[BX],1

    INC appointmentCount

    LEA DX,appointmentBookedMsg
    CALL PRINT_STRING

    RET

BOOK_APPOINTMENT ENDP


appointmentBookedMsg DB 13,10,'Appointment Booked Successfully!$'


; ============================================================
; VIEW APPOINTMENTS
; ============================================================

VIEW_APPOINTMENTS PROC

    CMP appointmentCount,0
    JNE VIEW_APPOINTMENT_START

    LEA DX,noAppointment
    CALL PRINT_STRING
    RET


VIEW_APPOINTMENT_START:

    XOR BX,BX

VIEW_APPOINTMENT_LOOP:

    CMP BYTE PTR appointmentActive[BX],1
    JNE VIEW_APPOINTMENT_NEXT

    CALL DISPLAY_APPOINTMENT


VIEW_APPOINTMENT_NEXT:

    INC BX
    CMP BX,10
    JB VIEW_APPOINTMENT_LOOP

    RET

VIEW_APPOINTMENTS ENDP


; ============================================================
; DISPLAY APPOINTMENT
; BX = index
; ============================================================

DISPLAY_APPOINTMENT PROC

    PUSH BX

    CALL NEW_LINE

    LEA DX,appointmentIDMsg
    CALL PRINT_STRING

    MOV AX,appointmentID[BX*2]
    CALL PRINT_NUMBER

    LEA DX,appointmentPatientMsg
    CALL PRINT_STRING

    MOV AX,appointmentPatient[BX*2]
    CALL PRINT_NUMBER

    LEA DX,appointmentDoctorMsg
    CALL PRINT_STRING

    MOV AX,appointmentDoctor[BX*2]
    CALL PRINT_NUMBER

    LEA DX,appointmentDateMsg
    CALL PRINT_STRING

    MOV AX,BX
    MOV DX,15
    MUL DX

    MOV SI,OFFSET appointmentDates
    ADD SI,AX

    MOV DX,SI
    CALL PRINT_STRING

    LEA DX,statusMsg
    CALL PRINT_STRING

    MOV AL,appointmentStatus[BX]

    CMP AL,1
    JE STATUS_PENDING

    CMP AL,2
    JE STATUS_CONFIRMED

    CMP AL,3
    JE STATUS_COMPLETED

    LEA DX,statusCancelled
    CALL PRINT_STRING
    JMP DISPLAY_APPOINTMENT_DONE


STATUS_PENDING:

    LEA DX,statusPending
    CALL PRINT_STRING
    JMP DISPLAY_APPOINTMENT_DONE


STATUS_CONFIRMED:

    LEA DX,statusConfirmed
    CALL PRINT_STRING
    JMP DISPLAY_APPOINTMENT_DONE


STATUS_COMPLETED:

    LEA DX,statusCompleted
    CALL PRINT_STRING


DISPLAY_APPOINTMENT_DONE:

    CALL NEW_LINE

    POP BX

    RET

DISPLAY_APPOINTMENT ENDP


appointmentIDMsg      DB 13,10,'Appointment ID : $'
appointmentPatientMsg DB 13,10,'Patient ID     : $'
appointmentDoctorMsg  DB 13,10,'Doctor ID      : $'
appointmentDateMsg    DB 13,10,'Date           : $'
statusMsg             DB 13,10,'Status         : $'

statusPending   DB 'Pending$'
statusConfirmed DB 'Confirmed$'
statusCompleted DB 'Completed$'
statusCancelled DB 'Cancelled$'


; ============================================================
; SEARCH APPOINTMENT
; ============================================================

SEARCH_APPOINTMENT PROC

    LEA DX,appointmentIdPr
    CALL PRINT_STRING
    CALL READ_NUMBER

    MOV tempID,AX

    XOR BX,BX

SEARCH_APPOINTMENT_LOOP:

    CMP BYTE PTR appointmentActive[BX],1
    JNE SEARCH_APPOINTMENT_NEXT

    MOV AX,appointmentID[BX*2]

    CMP AX,tempID
    JE SEARCH_APPOINTMENT_FOUND


SEARCH_APPOINTMENT_NEXT:

    INC BX
    CMP BX,10
    JB SEARCH_APPOINTMENT_LOOP

    LEA DX,appointmentNF
    CALL PRINT_STRING
    RET


SEARCH_APPOINTMENT_FOUND:

    LEA DX,appointmentFoundMsg
    CALL PRINT_STRING

    CALL DISPLAY_APPOINTMENT

    RET

SEARCH_APPOINTMENT ENDP


appointmentFoundMsg DB 13,10,'Appointment Found!$'


; ============================================================
; CANCEL APPOINTMENT
; ============================================================

CANCEL_APPOINTMENT PROC

    LEA DX,appointmentIdPr
    CALL PRINT_STRING
    CALL READ_NUMBER

    MOV tempID,AX

    XOR BX,BX

CANCEL_SEARCH:

    CMP BYTE PTR appointmentActive[BX],1
    JNE CANCEL_NEXT

    MOV AX,appointmentID[BX*2]

    CMP AX,tempID
    JE CANCEL_FOUND


CANCEL_NEXT:

    INC BX
    CMP BX,10
    JB CANCEL_SEARCH

    LEA DX,appointmentNF
    CALL PRINT_STRING
    RET


CANCEL_FOUND:

    MOV BYTE PTR appointmentStatus[BX],4

    LEA DX,appointmentCancelledMsg
    CALL PRINT_STRING

    RET

CANCEL_APPOINTMENT ENDP


appointmentCancelledMsg DB 13,10,'Appointment Cancelled Successfully!$'


; ============================================================
; APPOINTMENT STATUS
; ============================================================

APPOINTMENT_STATUS PROC

    LEA DX,appointmentIdPr
    CALL PRINT_STRING
    CALL READ_NUMBER

    MOV tempID,AX

    XOR BX,BX

STATUS_SEARCH:

    CMP BYTE PTR appointmentActive[BX],1
    JNE STATUS_NEXT

    MOV AX,appointmentID[BX*2]

    CMP AX,tempID
    JE STATUS_FOUND


STATUS_NEXT:

    INC BX
    CMP BX,10
    JB STATUS_SEARCH

    LEA DX,appointmentNF
    CALL PRINT_STRING
    RET


STATUS_FOUND:

    LEA DX,statusMsg
    CALL PRINT_STRING

    MOV AL,appointmentStatus[BX]

    CMP AL,1
    JE STATUS_PENDING_2

    CMP AL,2
    JE STATUS_CONFIRMED_2

    CMP AL,3
    JE STATUS_COMPLETED_2

    LEA DX,statusCancelled
    CALL PRINT_STRING
    RET


STATUS_PENDING_2:

    LEA DX,statusPending
    CALL PRINT_STRING
    RET


STATUS_CONFIRMED_2:

    LEA DX,statusConfirmed
    CALL PRINT_STRING
    RET


STATUS_COMPLETED_2:

    LEA DX,statusCompleted
    CALL PRINT_STRING
    RET

APPOINTMENT_STATUS ENDP


; ============================================================
; PHARMACY MENU
; ============================================================

PHARMACY_MENU PROC

PHARMACY_MENU_LOOP:

    CALL NEW_LINE

    LEA DX,pharmacyTitle
    CALL PRINT_STRING

    LEA DX,pharmacyMenu1
    CALL PRINT_STRING

    LEA DX,pharmacyMenu2
    CALL PRINT_STRING

    LEA DX,pharmacyMenu3
    CALL PRINT_STRING

    LEA DX,pharmacyMenu4
    CALL PRINT_STRING

    LEA DX,pharmacyMenu5
    CALL PRINT_STRING

    LEA DX,backMenu
    CALL PRINT_STRING

    LEA DX,choiceMsg
    CALL PRINT_STRING

    CALL READ_CHAR

    CMP AL,'1'
    JE PH_ADD

    CMP AL,'2'
    JE PH_VIEW

    CMP AL,'3'
    JE PH_SEARCH

    CMP AL,'4'
    JE PH_STOCK

    CMP AL,'5'
    JE PH_PRICE

    CMP AL,'6'
    JE PH_BACK

    LEA DX,invalidMsg
    CALL PRINT_STRING
    CALL WAIT_KEY
    JMP PHARMACY_MENU_LOOP


PH_ADD:

    CALL ADD_MEDICINE
    CALL WAIT_KEY
    JMP PHARMACY_MENU_LOOP


PH_VIEW:

    CALL VIEW_MEDICINES
    CALL WAIT_KEY
    JMP PHARMACY_MENU_LOOP


PH_SEARCH:

    CALL SEARCH_MEDICINE
    CALL WAIT_KEY
    JMP PHARMACY_MENU_LOOP


PH_STOCK:

    CALL CHECK_STOCK
    CALL WAIT_KEY
    JMP PHARMACY_MENU_LOOP


PH_PRICE:

    CALL MEDICINE_PRICE
    CALL WAIT_KEY
    JMP PHARMACY_MENU_LOOP


PH_BACK:

    RET

PHARMACY_MENU ENDP


pharmacyTitle DB 13,10,'========================================'
              DB 13,10,'          PHARMACY MANAGEMENT'
              DB 13,10,'========================================$'

pharmacyMenu1 DB 13,10,'1. Add Medicine$'
pharmacyMenu2 DB 13,10,'2. View Medicines$'
pharmacyMenu3 DB 13,10,'3. Search Medicine$'
pharmacyMenu4 DB 13,10,'4. Check Stock$'
pharmacyMenu5 DB 13,10,'5. Medicine Price$'


; ============================================================
; ADD MEDICINE
; ============================================================

ADD_MEDICINE PROC

    CMP medicineCount,10
    JB ADD_MEDICINE_SPACE

    LEA DX,fullMsg
    CALL PRINT_STRING
    RET


ADD_MEDICINE_SPACE:

    XOR BX,BX

FIND_MEDICINE_SLOT:

    CMP BYTE PTR medicineActive[BX],0
    JE MEDICINE_SLOT_FOUND

    INC BX
    CMP BX,10
    JB FIND_MEDICINE_SLOT

    RET


MEDICINE_SLOT_FOUND:

    MOV tempIndex,BX

    LEA DX,medicineIdPr
    CALL PRINT_STRING
    CALL READ_NUMBER

    MOV BX,tempIndex
    MOV medicineID[BX*2],AX

    LEA DX,medicineNamePr
    CALL PRINT_STRING
    CALL READ_STRING

    MOV AX,tempIndex
    MOV BX,20
    MUL BX

    MOV DI,OFFSET medicineNames
    ADD DI,AX

    MOV CX,20
    CALL STORE_STRING

    LEA DX,quantityPr
    CALL PRINT_STRING
    CALL READ_NUMBER

    MOV BX,tempIndex
    MOV medicineQty[BX*2],AX

    LEA DX,pricePr
    CALL PRINT_STRING
    CALL READ_NUMBER

    MOV BX,tempIndex
    MOV medicinePrice[BX*2],AX

    MOV BYTE PTR medicineActive[BX],1

    INC medicineCount

    LEA DX,successAdd
    CALL PRINT_STRING

    RET

ADD_MEDICINE ENDP


; ============================================================
; VIEW MEDICINES
; ============================================================

VIEW_MEDICINES PROC

    CMP medicineCount,0
    JNE VIEW_MEDICINE_START

    LEA DX,noMedicine
    CALL PRINT_STRING
    RET


VIEW_MEDICINE_START:

    XOR BX,BX

VIEW_MEDICINE_LOOP:

    CMP BYTE PTR medicineActive[BX],1
    JNE VIEW_MEDICINE_NEXT

    CALL DISPLAY_MEDICINE


VIEW_MEDICINE_NEXT:

    INC BX
    CMP BX,10
    JB VIEW_MEDICINE_LOOP

    RET

VIEW_MEDICINES ENDP


; ============================================================
; DISPLAY MEDICINE
; BX = index
; ============================================================

DISPLAY_MEDICINE PROC

    PUSH BX

    CALL NEW_LINE

    LEA DX,medicineIDMsg
    CALL PRINT_STRING

    MOV AX,medicineID[BX*2]
    CALL PRINT_NUMBER

    LEA DX,medicineNameMsg
    CALL PRINT_STRING

    MOV AX,BX
    MOV DX,20
    MUL DX

    MOV SI,OFFSET medicineNames
    ADD SI,AX

    MOV DX,SI
    CALL PRINT_STRING

    LEA DX,medicineStockMsg
    CALL PRINT_STRING

    MOV AX,BX
    MOV SI,AX
    MOV AX,medicineQty[SI*2]
    CALL PRINT_NUMBER

    LEA DX,medicinePriceMsg
    CALL PRINT_STRING

    MOV AX,BX
    MOV SI,AX
    MOV AX,medicinePrice[SI*2]
    CALL PRINT_NUMBER

    CALL NEW_LINE

    POP BX

    RET

DISPLAY_MEDICINE ENDP


medicineIDMsg    DB 13,10,'Medicine ID : $'
medicineNameMsg  DB 13,10,'Medicine    : $'
medicineStockMsg DB 13,10,'Stock       : $'
medicinePriceMsg DB 13,10,'Price       : $'


; ============================================================
; SEARCH MEDICINE
; ============================================================

SEARCH_MEDICINE PROC

    LEA DX,medicineIdPr
    CALL PRINT_STRING
    CALL READ_NUMBER

    MOV tempID,AX

    XOR BX,BX

SEARCH_MEDICINE_LOOP:

    CMP BYTE PTR medicineActive[BX],1
    JNE SEARCH_MEDICINE_NEXT

    MOV AX,medicineID[BX*2]

    CMP AX,tempID
    JE SEARCH_MEDICINE_FOUND


SEARCH_MEDICINE_NEXT:

    INC BX
    CMP BX,10
    JB SEARCH_MEDICINE_LOOP

    LEA DX,medicineNF
    CALL PRINT_STRING
    RET


SEARCH_MEDICINE_FOUND:

    LEA DX,medicineFoundMsg
    CALL PRINT_STRING

    CALL DISPLAY_MEDICINE

    RET

SEARCH_MEDICINE ENDP


medicineFoundMsg DB 13,10,'Medicine Found!$'


; ============================================================
; CHECK STOCK
; ============================================================

CHECK_STOCK PROC

    LEA DX,medicineIdPr
    CALL PRINT_STRING
    CALL READ_NUMBER

    MOV tempID,AX

    XOR BX,BX

CHECK_STOCK_SEARCH:

    CMP BYTE PTR medicineActive[BX],1
    JNE CHECK_STOCK_NEXT

    MOV AX,medicineID[BX*2]

    CMP AX,tempID
    JE CHECK_STOCK_FOUND


CHECK_STOCK_NEXT:

    INC BX
    CMP BX,10
    JB CHECK_STOCK_SEARCH

    LEA DX,medicineNF
    CALL PRINT_STRING
    RET


CHECK_STOCK_FOUND:

    CALL NEW_LINE

    LEA DX,medicineNameMsg
    CALL PRINT_STRING

    MOV AX,BX
    MOV DX,20
    MUL DX

    MOV SI,OFFSET medicineNames
    ADD SI,AX

    MOV DX,SI
    CALL PRINT_STRING

    LEA DX,medicineStockMsg
    CALL PRINT_STRING

    MOV AX,BX
    MOV SI,AX
    MOV AX,medicineQty[SI*2]
    CALL PRINT_NUMBER

    LEA DX,stockStatusMsg
    CALL PRINT_STRING

    MOV AX,BX
    MOV SI,AX
    MOV AX,medicineQty[SI*2]

    CMP AX,0
    JE STOCK_EMPTY

    LEA DX,stockAvailable
    CALL PRINT_STRING
    RET


STOCK_EMPTY:

    LEA DX,stockEmpty
    CALL PRINT_STRING

    RET

CHECK_STOCK ENDP


stockStatusMsg DB 13,10,'Status      : $'
stockAvailable DB 'Available$'
stockEmpty     DB 'Out of Stock$'


; ============================================================
; MEDICINE PRICE
; ============================================================

MEDICINE_PRICE PROC

    LEA DX,medicineIdPr
    CALL PRINT_STRING
    CALL READ_NUMBER

    MOV tempID,AX

    XOR BX,BX

PRICE_SEARCH:

    CMP BYTE PTR medicineActive[BX],1
    JNE PRICE_NEXT

    MOV AX,medicineID[BX*2]

    CMP AX,tempID
    JE PRICE_FOUND


PRICE_NEXT:

    INC BX
    CMP BX,10
    JB PRICE_SEARCH

    LEA DX,medicineNF
    CALL PRINT_STRING
    RET


PRICE_FOUND:

    LEA DX,medicinePriceMsg
    CALL PRINT_STRING

    MOV AX,medicinePrice[BX*2]
    CALL PRINT_NUMBER

    RET

MEDICINE_PRICE ENDP


; ============================================================
; END OF PROGRAM
; ============================================================

END MAIN





