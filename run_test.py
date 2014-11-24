#!/usr/bin/python
#import matplotlib
import os
import commands
import csv

os.system("nvcc -o prime_sieve prime_sieve.cu")
csvfile = file("result.csv", "wb")
writer = csv.writer(csvfile )

for n in [100, 1000, 10000, 100000, 1000000, 10000000]:
    for p in range(1, 33):
        for c in range(10, 110, 10):
            time_sum = 0
            for i in range(10):
                command = "./prime_sieve " + str(n) + " " + str(p) + " " + str(c)
                output = commands.getstatusoutput(command)
                time_sum += int(output[1])
            time = time_sum / 10;
            writer.writerow((n, p, c, time))

writer.close()
