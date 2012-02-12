## What the app does
This app is a response to a code challenge from a company. It lets user log in by facebook and pick any of their friends to see their wall posts and see the most frequent commenters.

## Design approach
Facebook Graph API provides convenient methods to access wall posts information. The key is to add read-stream in the scope for oauth login. Otherwise, you will only see a subset of all wall posts. I have added most of the API call methods in user model so as to follow the thin-controller-fat-model practice. 

I have decided not to persist any data in the database because the purpose of this app calls for processing of the latest feeds. Working with stored data would require merging of existing data and new data, which is an overkill. Also, there is no important use of data to warrant storage.


## Improvements to be made
Caching: Because loading and processing each user can take some time especially if the user has lots of posts. It would be helpful to page caching so if the user checks the same user again, he would not have to wait that long again. 


