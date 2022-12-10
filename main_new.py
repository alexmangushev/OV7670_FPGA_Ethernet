import time

import cv2 as cv
import numpy as np
from threading import Thread
from scapy.all import *
from scapy.layers.inet import UDP

# frame size
width = 640
height = 480

# IP и порт получателя
ip, dst_port = '169.254.163.161', 20001

img = np.zeros((height, width, 3), np.uint8)
cnt = 0

show = 0
read = 1

def show_img():
    global show, read
    while True:
        while show != 1:
            time.sleep(0.001)
        show = 0

        cv.imshow("img", img)
        cv.waitKey(1)
        read = 1

        while show != 1:
            time.sleep(0.001)
        cv.destroyAllWindows()


def get_data():
    global show, read
    while True:

        while read != 1:
            time.sleep(0.001)

        show = 0
        read = 0
        #  Прием пакетов в количестве count=964 для хоста с заданным IP-адреом и портом
        rec_packets = sniff(filter=f"port {dst_port}", iface="Ethernet", count=964)
        # номер пакета с началом кадра
        num = 0

        # Обработка принятых пакетов
        for i in range(len(rec_packets)):
            data = str(rec_packets[i][UDP].payload)[2:18]

            if (data == 'start_of_frameve'):
                num = i
                break

        # Начало кадра
        print(num)
        start_pos = num

        raw = 0
        column = 0

        for i in range(1, height):

            s = bytes(rec_packets[i + start_pos][UDP].payload)

            for k in range(0, width * 2, 2):

                tmp = s[k]
                tmp <<= 8
                tmp += s[k + 1]

                r = ((tmp >> 11) & 31) * 8
                g = ((tmp >> 5) & 63) * 4
                b = (tmp & 31) * 8
                raw = i - 1
                column = k // 2
                img[raw, column] = (b, g, r)  # (B, G, R)

        show = 1

        #name = str(cnt)
        #name += ".png"
        #cnt+=1

        #cv.imshow("img", img)
        #cv.waitKey(2000)
        #cv.imwrite(name, img)
        #cv.destroyAllWindows()

runData = Thread(target=get_data, args=())
runShow = Thread(target=show_img, args=())

runData.start()
runShow.start()
