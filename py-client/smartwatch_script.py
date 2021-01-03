import random
from random import choice, seed, randint
from time import sleep
import socket

HOST = '127.0.0.1'
PORT = 9999

# Set the default values to seed from
bodyTemperatureArray = [35.5, 35.6, 35.7, 35.8, 35.9, 36.0, 36.1, 36.2,
                        36.3, 36.4, 36.5, 36.6, 36.7, 36.8, 37.0, 37.1, 37.2, 37.3, 37.4]
respirationRateArray = [*range(12, 30, 1)]
spo2Array = [*range(92, 100, 1)]
heartBeatArray = [*range(60, 100, 1)]
systolicPressureArray = [*range(80, 121, 1)]
diastolicPressureArray = [*range(60, 81, 1)]

# Randomize the seed
random.shuffle(bodyTemperatureArray)
random.shuffle(respirationRateArray)
random.shuffle(spo2Array)
random.shuffle(heartBeatArray)
random.shuffle(systolicPressureArray)
random.shuffle(diastolicPressureArray)


seed(1)

print("\n\nWaiting for connection at port ", PORT, " ...")
with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    try:
        s.connect((HOST, PORT))
        # s.sendall(b'Connection to client established ...\r\n')
        # sleep(3)
        
        while True:
            temperature = choice(bodyTemperatureArray)
            rr = choice(respirationRateArray)
            spo2 = choice(spo2Array)
            hb = choice(heartBeatArray)
            syst = choice(systolicPressureArray)
            diast = choice(diastolicPressureArray)

            stringToSend = f"{temperature}:{rr}:{hb}:{spo2}:{syst}:{diast}"
            print(f"Selected Values => {stringToSend}")

            s.sendall(str.encode(stringToSend))
            sleep(20)

    except:
        # recreate the socket and reconnect
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        s.connect(HOST, PORT)
