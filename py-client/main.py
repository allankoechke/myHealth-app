import random
import machine
import pyb
from random import choice, seed, randint
from time import sleep

# Set the default values to seed from
bodyTemperatureArray = [35.5, 35.6, 35.7, 35.8, 35.9, 36.0, 36.1, 36.2,
                        36.3, 36.4, 36.5, 36.6, 36.7, 36.8, 37.0, 37.1, 37.2, 37.3, 37.4]
respirationRateArray = [i for i in range(12,31)]
spo2Array = [i for i in range(92,101)]
heartBeatArray = [i for i in range(60,101)]
systolicPressureArray = [i for i in range(80,121)]
diastolicPressureArray = [i for i in range(60,80)]

# Randomize the seed
random.shuffle(bodyTemperatureArray)
random.shuffle(respirationRateArray)
random.shuffle(spo2Array)
random.shuffle(heartBeatArray)
random.shuffle(systolicPressureArray)
random.shuffle(diastolicPressureArray)



seed(1)

def getVitals():
    try:
        
        while True:
            temperature = choice(bodyTemperatureArray)
            rr = choice(respirationRateArray)
            spo2 = choice(spo2Array)
            hb = choice(heartBeatArray)
            syst = choice(systolicPressureArray)
            diast = choice(diastolicPressureArray)

            stringToSend = f"{temperature}:{rr}:{hb}:{spo2}:{syst}:{diast}"
            print(f"{stringToSend}\r\n")

            sleep(5)

    except:
        # recreate the socket and reconnect
        pass
        
if __name__=="__main__":
    getVitals()
    
    
    
