# OV7670_FPGA_Ethernet

## Описание проекта

Данный проект реализует передачу данных с камеры OV7670 через ПЛИС по Ethernet. 
В текущей реализации скорость передачи ограничена 1 fps, что связано с особенностями передачи данных.
В дальнейшем планируется применить DRAM, раположенную на отладочной плате для ускорения передачи данных.
Данные передаются по протоколу UDP, но все поля, необходимые для работы этого и нижележащих протоколов
заполнены заранее, что экономит место в ПЛИС, позволяя оставить больше места под логику обработки. 
На оталдочной плате расположена микросхема физического уровня Ethernet 88E1111, общение с которой 
производится по интерфейсу MII.

Для запуска проекта была выбрана отладочная плата DE2-115 от компании Altera.

![](https://github.com/alexmangushev/OV7670_FPGA_Ethernet/blob/master/img/dev_board.jpg)
 
На ней располагается ПЛИС CycloneIV EP4CE115F29C7. Камера подключается к GPIO.

![](https://github.com/alexmangushev/OV7670_FPGA_Ethernet/blob/master/img/dev_board_2.jpg)

Пример изображения, полученного с камеры

![](https://github.com/alexmangushev/OV7670_FPGA_Ethernet/blob/master/img/frame.jpg)

### Схема подключения камеры:

| 	ПЛИС  	| 	КАМЕРА	|
| ----------|:---------:|
| GPIO[35]  | SCL |
| GPIO[34]  | SDA |
| GPIO[33]  | VSYNC |
| GPIO[32]  | HREF |
| GPIO[31]  | PCLK |
| GPIO[30]  | XCLK |
| GPIO[29..22]  | D7 - D0 |

## Структура репозитория

В репозитории содержится три ветки:
* [master](https://github.com/alexmangushev/OV7670_FPGA_Ethernet/tree/master) содержит общее описание проекта.
* [Verilog](https://github.com/alexmangushev/OV7670_FPGA_Ethernet/tree/Verilog) содержит код для ПЛИС.
* [Python](https://github.com/alexmangushev/OV7670_FPGA_Ethernet/tree/Python) содержит код приложения для отображения данных, получаемых с камеры.

Все необходимые пояснения содержатся в соответствующих ветках.