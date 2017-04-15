c x;Giorgos Mademlis 7467 Antonis Platis 7512


.include "m16def.inc" ; Include the microcontroler atMega16
aem_table1:.db $37,$34,$36,$37  ;Save in Program memory the 1st 4-digit Number
aem_table2:.db $37,$35,$31,$32  ;Save in Program memory the 2nd 4-digit Number
.def temp1=r16      ;voithikikoi kataxwrhtes pou xrhsimopoioume sto programma         
.def temp2=r17                  
.def counter=r18     ;Index of the digit which is different between the 2 4-dight numbers
.def zero=r19     ;Register to represent 0 value
.def temp=r20   ;Register to represent the output value for LEDS


clr counter  ;Set zero values to the counters
clr zero

loop:
   ldi zl,low(aem_table1)  ;Load in Z index the 1st number
   ldi zh,high(aem_table1)
   lsl zl
   rol zh

   add zl,counter ;add counter into Z to index the correct digit
   adc zh,zero
   lpm temp1,z 

   ldi zl,low(aem_table2) ;Load in Z the 2nd number
   ldi zh,high(aem_table2)
   lsl zl
   rol zh

   add zl,counter ;Add counter into z z
   adc zh,zero
   lpm temp2,z
   
   inc counter 
   cp temp1,temp2 ;Compare the 2 digits  
   breq loop ;If the are equal, chech next
   brsh gr_aem1 ;If number1>number2 goto the corresponding label
gr_aem2: ;If not, number1<number2
   set  ;T=1 means Number2 is greater
   ldi zl,low(aem_table2) ;Load in Z first digit of Number2
   ldi zh,high(aem_table2)
   lsl zl
   rol zh
   adiw zl,2
   lpm temp2,z
   subi temp2,$30
   swap temp2
   adiw zl,1
   lpm temp1,z
   subi temp1,$30
   add temp2,temp1
   ser temp
   out DDRB,temp
   com temp2
   out PORTB,temp2
   lpm temp1,z
   subi temp1,$30 ;Convert from ASCII to Binary
   andi temp1,1 ;Check if it is odd or even
   breq gr_zyg ;If it is 0, it means it is even, so we go to the corresponding label
   jmp gr_per ;Otherwise, it means it is odd
   
gr_aem1: Number1>Number2
   clt ;T=0 means Number1>Number2
   ldi zl,low(aem_table1) ;Load in Z the first digit of Number 1
   ldi zh,high(aem_table1)
   lsl zl
   rol zh
   adiw zl,2 ;We isolate the 3rd digit 
   lpm temp2,z ;And load it in temp2
   subi temp2,$30 ;Convert it into binary
   swap temp2 ;By swapping we transfer the 3rd digit in the high nibble of temp2
   adiw zl,1 ;We isolate the 4th deget
   lpm temp1,z ;Load it in temp 1 and convert it to binary
   subi temp1,$30
   add temp2,temp1 ;By adding temp2 in temp we have in temp2 the last 2 digits of Number1
   ser temp
   out DDRB,temp ;We define PORTB (LEDS) as output 
   com temp2 ;We take the complement of temp2 because LEDS have negative logic
   out PORTB,temp2 ;We light up LEDS showing the last 2 digits of Number1 
   lpm temp1,z ;We load in temp1 the last digit, convert it into binary, check if it is even or odd from andi
   subi temp1,$30
   andi temp1,1
   breq gr_zyg ;If it is even we go to the corresponding label, if not we continue, meaning it is odd
   
gr_per:
   brtc load2 ;Through this command by checking T flag, we know which is smaller number, so we load in Z the smaller one 
load1:
   ldi zl,low(aem_table1)  ;Through loads we load in Z the the smaller Number
   ldi zh,high(aem_table1)
   lsl zl
   rol zh
   adiw zl,3
   lpm temp1,z
   jmp continue1
load2:
   ldi zl,low(aem_table2)
   ldi zh,high(aem_table2)
   lsl zl
   rol zh
   adiw zl,3
   lpm temp1,z
continue1:   
   subi temp1,$30 ;We convert it into binary and check if it is odd or even
   andi temp1,1
   breq GrPerLoZyg ;If even, we go to the label, if not, we continue
GrPerLoPer:
   ser temp ;Here we know that the Bigger Number is odd and the smaller as well, we make the corresponding  output
   andi temp,$FF
   out PORTB,temp
   jmp loop2
GrPerLoZyg:
   ser temp ;Here we know that the Bigger Number is odd and the smaller is even, we make the corresponding  output
   andi temp,$FE
   out PORTB,temp
   jmp loop2
gr_zyg:
   brtc load4 ;Like above we load in Z the smaller
load3:
   ldi zl,low(aem_table1)
   ldi zh,high(aem_table1)
   lsl zl
   rol zh
   adiw zl,3
   lpm temp1,z
   jmp continue2
load4:
   ldi zl,low(aem_table2)
   ldi zh,high(aem_table2)
   lsl zl
   rol zh
   adiw zl,3
   lpm temp1,z
continue2:
   subi temp1,$30 ;We check if it is odd or even
   andi temp1,1
   breq GrZygLoZyg
GrZygLoPer:
   ser temp ;Here we know that the Bigger Number is even and the smaller is odd, we make the corresponding LED output
   andi temp,$FD
   out PORTB,temp
   jmp loop2
GrZygLoZyg:
   ser temp ;Here we know that the Bigger Number is even and the smaller is even as well, we make the corresponding LED output
   andi temp,$FC
   out PORTB,temp
   jmp loop2

loop2:
   nop ;Never-ending loop so that the LEDS output can be seen by the human eye
   jmp loop2
  


   
