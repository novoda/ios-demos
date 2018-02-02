# Rick-and-Morty

This is a project to be used for pairing sessions. 
The application is basically a TabViewController with 2 different tabs: Rick and Morty. 
Each tab implement a CollectionViewController with an hardcoded data source. 

The implementation is really basic and the simplest possible code has been written so 
that there are a lot of possible areas of refactor.

I recommend to ask the candidate to start by creating a generic data source for the 2 CollectionView

## Possible Areas of improvement
This questions are here to help you answer what you thought of a candidate. You do not need to follow all of them.

- Model (ricks and mortys) are on controller are hardcoded
- FlowLayout with static width
- Failing auto test
- Did candidate check storyboard? What do they say about them?
- Hardcoded string cell
- Configure cell outside of controller

Extra points to take into account:

- Did they try to use abstractions?
- Get the code logic out of the controller?
- Did they create a view model as well as a model (what architecture did they choose and how did they justify it)
- Did they mention Dependency injection?
