
import time
import numpy as np

NUM_ENTRY = 64
NUM_ROW = 30
TRACE_SIZE = 300

RFM_TH = 8

if __name__ == '__main__':

  #np.random.seed(777)
  np.random.seed(int(time.time()))

  trace = np.random.randint(NUM_ROW, size=TRACE_SIZE)
  np.savetxt('trace.txt', trace, fmt = '%d')
#  trace = np.loadtxt('trace.txt', dtype = 'int')

  table = []
  for _ in range(NUM_ENTRY):
    table.append([262143,0])
  len_table = 0  

  spcnt = 0

  act_cnt = 0

  for act_row in trace:
    act_cnt += 1
    print("////////  ACT{:>4d} ////////".format(act_cnt))
    print("ACT Address :{:>7d}".format(act_row))
    act_row = act_row
    if len_table < NUM_ENTRY:
      exist = False
      for i, row in enumerate(table):
        if row[0] == act_row:
          row[1] += 1
          exist = True
      if not exist:
        table[len_table] = [act_row, 1]
        len_table += 1
    else:
      exist = False
      for i, row in enumerate(table):
        if row[0] == act_row:
          row[1] += 1
          exist = True
      if not exist:
        min_cnt = table[0][1]
        for i, row in enumerate(table):
          if min_cnt > row[1]:
            min_cnt = row[1]
        if min_cnt == spcnt:
          for i, row in enumerate(table):
            if row[1] == spcnt:
              row[0] = act_row
              row[1] = spcnt + 1
              break
        else:
          spcnt += 1
    
    if act_cnt % RFM_TH == 0:
      max_cnt = table[0][1]
      for i, row in enumerate(table):
        if max_cnt < row[1]:
          max_cnt = row[1]
      for i, row in enumerate(table):
        if row[1] == max_cnt:
          row[1] = spcnt
          break

    for i, row in enumerate(table):
      print("{:>11d}: {:>6d}, {:>10d}".format(i, row[0], row[1]))
    print("\n")
