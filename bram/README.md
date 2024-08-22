# BRAM Controller
## Introduction
FPGA 의 BRAM 을 Control 하는 모듈을 설계해 보았음.

### BRAM Structure
<img src= "https://github.com/goeun-oh/Verilog/blob/main/bram/bram.png" width="400" hegith = "400" />
single-port RAM 을 control 하는 모듈임

<img src= "https://github.com/goeun-oh/Verilog/blob/main/bram/inoutput.png" width="700" hegith = "400" />

single-port RAM의 in/output signals



### spbram module
- DWIDTH는 memory의 width bits 를 의미.
- AWIDTH는 Address를 나타낼 수 있는 비트 수를 의미함
> 원래 4095 까지 available하나 3840 주소까지 사용하기로 함. 따라서 MEM_SIZE 라는 parameter를 하나 더 생성.

- we0 == 1 이면 write mode, 0 이면 read mode 임
- d0은 read mode일때 받는 data, q0은 write mode 일때 내보내는 data 임

- reg [DWDITH-1:0] ram [0:MEM_SIZE-1] 는 c 언어로 치면 ram[MEM_SIZE-1][DWIDTH-1] 배열임

- we0이 enable 된 후 1 cycle 뒤에 data가 나옴 (이건 simulation을 통해 확인해볼 예정)


