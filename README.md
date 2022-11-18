# Код для ПЛИС

Папка [verilog](https://github.com/alexmangushev/OV7670_FPGA_Ethernet/tree/Verilog/verilog) 
содержит файлы проекта на языке Verilog. 

Файлы с припиской **_for_testbench.v** добавляют к модулям память и используются в тестбенчах.
В папке [testbench](https://github.com/alexmangushev/OV7670_FPGA_Ethernet/tree/Verilog/testbench) 
находятся тестбенчи для основных модулей проекта.

Папка [pll](https://github.com/alexmangushev/OV7670_FPGA_Ethernet/tree/Verilog/pll) 
содержит модуль ФАПЧ с делителем 1/5000. 

Папка [OV7670](https://github.com/alexmangushev/OV7670_FPGA_Ethernet/tree/Verilog/verilog/OV7670) 
содержит файлы, реализующие взаимодействие с камерой. Код взят с https://github.com/westonb/OV7670-Verilog. 

Главный файл проекта [cycloneIV_ethernet.v](https://github.com/alexmangushev/OV7670_FPGA_Ethernet/blob/Verilog/verilog/cycloneIV_ethernet.v)
