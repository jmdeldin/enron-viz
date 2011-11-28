import matplotlib.pyplot as plt
from mpl_toolkits.axes_grid.axislines import Subplot

import csv
from datetime import datetime, timedelta

dates = []
emails = []

reader = csv.reader(open('dasovich-dates.csv', 'r'))
reader.next() # skip header

for row in reader:
    dates.append(datetime.strptime(row[0], '%Y-%m'))
    # dates.append(row[0])
    emails.append(float(row[1]))

# PLOT
fig = plt.figure()

ax = Subplot(fig, 111)
fig.add_subplot(ax)

ax.axis["right"].set_visible(False)
ax.axis["top"].set_visible(False)

plt.plot_date(dates, emails, xdate=True, ydate=False, linestyle='-', color='#333333')
ax.grid(which='major', color='#999999')
plt.xticks(rotation='vertical')

plt.title('Monthly Email History for Jeff Dasovich')
plt.ylabel('Number of Emails')


plt.savefig('foo.pdf', transparent=True)



