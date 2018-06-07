import datetime, sys
from time import sleep
from com.android.monkeyrunner import MonkeyRunner, MonkeyDevice, MonkeyView

device = MonkeyRunner.waitForConnection()
screenwidth = int(sys.argv[1])
screenheight = int(sys.argv[2])


for j in range(32):
	if (j > 1):
		device.touch(int(screenwidth*0.664), int(screenheight*0.728), MonkeyDevice.DOWN_AND_UP)
		sleep(1)
	for i in range(50):
		device.touch(int(screenwidth*0.278), int(screenheight*0.49), MonkeyDevice.DOWN_AND_UP)
		device.touch(int(screenwidth*0.74), int(screenheight*0.49), MonkeyDevice.DOWN_AND_UP)
	sleep(1)
	result = device.takeSnapshot()
	result.writeToFile(datetime.datetime.now().strftime('data/%Y-%m-%d_%H-%M-%S') + '.png', 'png')
