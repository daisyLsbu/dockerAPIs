from random import randint
import os

def startservice():
        for epoch in range(10):
            cpu = randint(1, 5)
            io = randint(1, 3)
            mem = randint(1, 10)
            vm = randint(100, 300)

            cmd = f"""
                stress -c {cpu} -i {io} -m {mem} --vm-bytes {vm}M -t 10s
                """
            os.system(cmd)
            #stress -c 2 -i 1 -m 1 --vm-bytes 128M -t 10s

if __name__ == '__main__':
    startservice()