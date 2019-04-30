# -*- coding: utf-8 -*-
# Finds focus point of a parabola and plots it

import matplotlib as mpl
import numpy as np

nb_values = 9000

x = np.linspace(-10,10,nb_values)
y = x**2

mpl.pyplot.plot(x,y)

for i in range(1,nb_values-1,int(nb_values/10)):
    y2c = ((y[i-1]-y[i+1])/(x[i-1]-x[i+1]))
    y2 = y2c*x
    
    y3c = np.tan(2*np.arctan(y2c)-np.pi/2)
    y3 = y3c*x + y[i]-y3c*x[i]
    if abs(y3c) < 10:
        mpl.pyplot.plot(x,y3)