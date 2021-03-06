# Computer Architecture Final - NES Audio Processing Unit
This website is a description of Nathaniel Tan and Noah Rivkin's Computer Architecture final project.

The goal of this project was to replicate the audio processing unit(APU) found in the Nintendo Entertainment System using verilog. Although the initial goal of the project was to be able to process original NES music file on our APU to be played, we had to scale back due to time constraints. Our APU implements two pulse channels and a triangle channel. While all of our channels work, the NES architecture converts music files to channel inputs within the CPU, which we did not replicate. Instead, the output of our APU goes into a python script which converts the digital amplitudes into an analog signal which is then converted to a .wav file by Sound eXchange(SoX), an audio processing software.

To demonstrate the ability of our hardware, we successfully played the well known children’s song Hot Cross Buns. The .wav file output can be found on our github repository and can be played by most audio playback software.

APU High Level Diagram: 
![APU Diagram](apu.png "APU Diagram")

## Clock Generator
Inputs:
1 bit 21.47 MHz clk

Outputs:
1 bit 240 Hz clk
1 bit 120 Hz clk

The clock generator takes in the apu clock (21.47 MHz) and outputs 240 Hz and 120 Hz clock signals to be used in other components.

The code for the clock divider module can be found in frameSequencer.v

## Important Components

### Clock Divider
Inputs:  
1 bit clk  
17 bit N  

Outputs:  
1 bit newClk

The clock divider takes in a base clock and and a 17 bit array N. The clock divider outputs a new clock signal which has a period N times the period of the base clock signal.

The code for the clock divider module can be found in commonComponents.v


### Timer
Inputs:  
1 bit 21.47 Mhz clk  
11 bit t  

Outputs:  
1 bit pulse


The timer controls the frequency of a channel’s output. It takes in an 11 bit array t. After a new value of t is loaded, an internal counter counts from t to 0. When the counter reaches 0 the timer emits a pulse and resets the counter to t.

The following is an equation for channel frequency output based on t.  
F = fCPU/(32*(t+1))  
The following is an equation for what t should be set to for a desired frequency f.  
T = fCPU/(32*f-1)  

The code for the timer module can be found in commonComponents.v

### Linear Counter
Inputs:  
1 bit 240 Hz clk  
1 bit controlFlag  
7 bit counterReloadValue  

Outputs:  
7 bit outValue


The linear counter is a second duration counter for the triangle channel. It is more accurate than the length counter because it is clocked at twice the frequency as the length counter. In addition to the inputs listed, the linear counter contains an internal haltFlag. The linear counter loads the counterReloadValue to the outValue and then counts that down to zero.

The code for the linear counter module can be found in triangleChannel.v

### Length Counter
Inputs:  
1 bit 120 Hz clk  
1 bit haltFlag  
5 bit counterLoad  

Outputs:  
7 bit outValue  

When counterLoad changes, its value is inputted to a lookup table which maps the input to a counter value. That counter value is then loaded and used to count down to zero. The following table shows all of the mappings based on the 5 bit counterLoad input. The table is taken from the following reference document: http://nesdev.com/apu_ref.txt.
   
       
    ----------------
    bits    bit 3
    4-1     0    1 
    ----------------
    | 0 |  $0A| $FE|
    | 1 |  $14| $02|
    | 2 |  $28| $04|
    | 3 |  $50| $06|
    | 4 |  $A0| $08|
    | 5 |  $3C| $0A|
    | 6 |  $0E| $0C|
    | 7 |  $1A| $0E|
    | 8 |  $0C| $10|
    | 9 |  $18| $12|
    | A |  $30| $14|
    | B |  $60| $16|
    | C |  $C0| $18|
    | D |  $48| $1A|
    | E |  $10| $1C|
    | F |  $20| $1E|
The code for the linear counter module can be found in commonComponents.v

### Sweep Unit
Inputs:
1 bit 120 Hz clk
3 bit sweepPeriod
3 bit shift
1 bit negate
1 bit enable
11 bit timerPeriod

Outputs:
11 bit outValue

The sweep unit controls the frequency of the pulse channel. When the enable flag is low it outputs timerPeriod. When enable is high it updates the period of the pulse channel. It contains a counter incremented by the 120 Hz clk. Whenever the couner reaches sweepPeriod the outValue is either increased or decreased, depending on the negate flag. The new period is determined using the logic below.

negateFlag is low:   
new period = outValue + (outValue >> sweepShift)   
negateFlag is high:  
new period = outValue - (outValue >> sweepShift)   

The code for the swwep unit can be found in frequency.v

### Envelope Generator
Inputs:
1 bit 240 Hz clk
1 bit loop
1 bit disable
17 bit period

Outputs:
4 bit outValue

The envelope generator controls the volume of the pulse wave. When disabel is high it outputs a constant volume. When disable is low it generates a decreasing saw envelope. The decay rate of the volume depends on the period.

The code for the envelope generator can be found in commonComponents.v

### Rectangle Generator
Inputs:
1 bit 21.47 Mhz clk  
2 bit duty cycle mode
1 bit enable

Outputs:
1 bit outValue

The when enable is high the rectangle generator produces a wave with a duty cycle determined by the duty cycle mode. When enable is low outValue is low. The duty cycle is determined by a look up table.

| Mode | duty cycle |
|------|------------|
| 0    | 12.5%      |
| 1    |   25%      |
| 2    |   50%      |
| 3    |   75%      |

When a periodic signal with a much longer period than the rectangle generators clock controls enable this produces a rectangle wave with the period of the input signal and a duty cycle determined by the mode.

The code for the rectangle generator can be found in rectangle.v

## Pulse Channel
Inputs:
1 bit 21.47 Mhz clk  
1 bit 240 Hz clk  
1 bit 120 Hz clk  
8 bit register $4000    
8 bit register $4001     
8 bit register $4002    
8 bit register $4003    

Outputs:
4 bit wave

The pulse channel consists of a sweep unit, a recangle generator, an envelope generator, and a length counter.

The channel outpus a 4 bit wave a period determined by the sweep unit, an amplitude determined by the envelope generator, and a duty cycle determined by the rectangle generator. The length cunter will silence the channle if it outputs 0.

The code for the pulse channel can be found in pulseChannel.v

## Triangle Channel
The triangle channel consists of a timer, triangle sequencer, linear counter and length counter.

The triangle sequencer when clocked by the timer outputs a rising and falling sequence of 0-15 to produce a triangle wave. The linear counter and length counter are redudent to each other and silence the channel when either of them output 0.

![Triangle Channel](triangleChannel.png)

## How to Run Demo
Demo requirements:  
Ability to run linux commands in terminal  
Have the SoX package installed  

To run the demo, run the following commands in a linux terminal while in the project repository:  
iverilog apu.v  
./mkaudio.sh a.out  
Play audio.wav

## References
This project wouldn't have been possible without the NES dev wiki which contains very detailed specifications on how the NES APU works (http://wiki.nesdev.com). If you wish to replicate this project, please use this source to find more details on the channel specificaitons.
## Reflection
While the APU technically works, we had to sacrifice a lot of the functionality we originally wanted due to time constraints. If we were to work on this further, we would add a noise channel which would act as percussion while playing music. We would also try to get the verilog towork on an FPGA and use the onboard DAC and audio codec to output the music through the audio port.

We came into this project thinking that the scope was too small for a four person team so we chose to work on it as a two person team. However looking back it was very difficult to do what we wanted to with two people.
