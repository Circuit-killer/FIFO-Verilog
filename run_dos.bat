SET veridir=C:\iverilog\bin
IF EXIST a.out (DEL a.out)
%veridir%\iverilog.exe %*
%veridir%\vvp a.out