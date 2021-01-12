# git_it_done-project2 Created by: git_it_done Team
## The Game of Set

#### How to Set-up:
1. Make sure you have the 'gosu' Ruby Gem installed. If not, do the following (for Linux systems):
  - `sudo apt-get install build-essential libsdl2-dev libgl1-mesa-dev libopenal-dev \
                     libsndfile-dev libmpg123-dev libgmp-dev libfontconfig1-dev`
  - `gem install gosu`
2. Navigate to the folder called 'project2' using cd project2 (assuming you are in 'git_it_done-project2')
3. Use the following command to run the game:
  - `ruby game.rb`
#### How to Play:
The Game of Set is played by matching sets of 3 cards. Each card has four attributes: shape, color, number and shading. Three cards each match if for each attribute, all three match or if none of the three match.
The player selects a set of three cards by clicking on cards that form a set, and races an AI to be the first to find 7 sets.
#### Job Breakdown:
- Annie Kempton & Sujan Kakumanu - Worked on the "mathematical model" for the game. This includes setting up the deck of cards, drawing cards, and checking if cards form a set. 
- Joseph Dandrea & Bianca Dizon - Worked on the GUI so that users can interact with the game without using text or the console. Edited the mathematical model so that the GUI word work with it.
- Ben Hus - Worked on the AI player that a human user would compete against to form a set. The AI will try to form sets faster than the user.
#### Additional Notes:
- The N button in the top right-hand corner starts a new game.
- Pausing the game is a good way to cheat against the AI.
- There cannot be more than 21 cards out on the table at a time.
