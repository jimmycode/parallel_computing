#!/usr/bin/python
#import matplotlib
import os
import commands
import csv

os.system("nvcc -o prime_sieve prime_sieve.cu")
csvfile = file("result.csv", "wb")
writer = csv.writer(csvfile)

for n in [100, 10000, 1000000]:
    for p in range(1, 33, 2):
        for c in range(10, 110, 10):
            time_sum = 0
            for i in range(20):
                command = "./prime_sieve " + str(n) + " " + str(p) + " " + str(c)
                output = commands.getstatusoutput(command)
                time_sum += int(output[1])
            time = time_sum / 20;
            writer.writerow((n, p, c, time))
            print(n, p, c, time)

# Large n
csvfile_large = file("result_large.csv", "wb")
writer_large = csv.writer(csvfile_large)
n = 10000000
for p in range(1, 33, 2):
    for c in range(10, 110, 10):
        time_sum = 0
        for i in range(10):
            command = "./prime_sieve " + str(n) + " " + str(p) + " " + str(c)
            output = commands.getstatusoutput(command)
            time_sum += int(output[1])
        time = time_sum / 10;
        writer_large.writerow((n, p, c, time))
        print(n, p, c, time)
