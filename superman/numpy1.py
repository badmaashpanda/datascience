import numpy as np
import pandas as pd

x=np.array([0,1,2,3,4,5])
# check if all elements are > 2
print(np.all(x>2))

# check if all elements are > 0
print(np.all(x))

x=np.array([0,1,2,np.nan,4,5])
print(x)
print(np.inf(x))