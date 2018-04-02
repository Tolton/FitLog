CIS 4500 Project
Jack Tolton
0888750
April 1, 2018

FitLog app

This is a fitness tracker app in which a user can register and login in order to track their food eaten, weight and fitness, measured in steps. The user will be able to view graphs of each metric in order to see trends, with a length of the past 30 days.

I ended up using the Firebase as my backend database with authentication.
Swift Charts was used for the graphing.
The food database at https://developer.edamam.com/ was used for food searches and calories. 


Looking back/forward I would definitely get rid of this food database as it was awful to work with, and was more based on recipes and ingredients rather than actual items.

Username: tolton@mail.com
Password: toltjac

This user has been setup with some data populated. 
As it will not be marked on the day of submission, it will show 0 values for that day. 
You can click on the text views on the home screen or click the log weight/add steps buttons to get to their respective graphs, which will update upon adding steps or changing your weight logged for the day. 
Calories will also update when food is added to the log.

I was not able to get table views working, so I only displayed the foods searched as well as the food log into text views. 
After clicking the search button, the update button will need to be clicked in order to display the results of the search. 
Adding a food will only add the top food in the search to the food log. 
The food log displays the food name and the calories, but no quantity, as the food database was not helpful in this regard.