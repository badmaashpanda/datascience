# Most Profitable Companies
# Find the 3 most profitable companies in the entire world.
# Output the result along with the corresponding company name.
# Sort the result based on profits in descending order.

# Import your libraries
import pandas as pd

# Start writing code
forbes_global_2010_2014.sort_values(by='profits',ascending=False).head(3)[['company','profits']]
