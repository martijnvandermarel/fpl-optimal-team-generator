# FPL Optimal Team Generator
Scrapes data from FPL website and calculates optimal team using Linear Programming.
The fpl_data_scraper python script gets data from the FPL website API and saves it in fpl_scraped_data.csv.
The MATLAB script loads the csv file and calculates the optimal team based on some metric you choose.

**IMPORTANT:** The team built is only as good as the metric you use! Know the limits of the metric before you draw conclusions!

## Requirements
### Python packages
- pandas
- requests

## MATLAB
- CVX
- Gurobi solver
