# transpiler demonstration

import time

def hello(name):
    if name == "Dave":
        print("hello")
    elif name == "Egg":
        print("close enough")
    else:
        print("you arent dave")

print(time.time())
for i in range(5):
    print("thonkening")
    time.sleep(0.2)

# comment demo
hello("Dave")
hello("Egg")
hello("Philipe")