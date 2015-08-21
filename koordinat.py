import math
import numpy as np
import sys

# WGS84 ellipsoid parameters
a = 6378137.000    
b = 6356752.3141
r = b/a 

if len(sys.argv) < 5:
	print "argument number is not enough" 
		# B1 = np.deg2rad(float(input('Sol ust enlem B1:  ')))
		# L1 = np.deg2rad(float(input('Sol ust boylam L1:  ')))
		# B2 = np.deg2rad(float(input('Sol alt enlem B2:  ')))
		# L2 = np.deg2rad(float(input('Sol alt boylam L2:  ')))
	
else:
	
	file = str(sys.argv[0])
	B1 = np.deg2rad(float(sys.argv[1]))  #upper left latitude
	L1 = np.deg2rad(float(sys.argv[2]))  #upper left longitude
	B2 = np.deg2rad(float(sys.argv[3]))  #bottom left latitude
	L2 = np.deg2rad(float(sys.argv[4]))  #bottom left longitude
	


distance = a * math.sqrt( (((np.cos(L2))/math.sqrt(1 + ((r) * np.tan(B2))**2))-((np.cos(L1))/math.sqrt(1 + ((r) * np.tan(B1))**2)))**2 + 
                           (((np.sin(L2))/math.sqrt(1 + ((r) * np.tan(B2))**2))-((np.sin(L1))/math.sqrt(1 + ((r) * np.tan(B1))**2)))**2 +
                (r ** 4) * (((np.tan(B2))/math.sqrt(1 + ((r) * np.tan(B2))**2))-((np.tan(B1))/math.sqrt(1 + ((r) * np.tan(B1))**2)))**2 )


print distance

#print B1
#print B2
#print L1
#print L2



