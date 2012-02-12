### What the app does
This app lets user log in by facebook and pick any of their friends to see their wall posts and see the most frequent commenters. 

**demo:** http://wildfireben.heroku.com

### Design approach
####Layout 
I have decided to display user information and top commenters on the left panel and wall posts on the right side, with friend-picker placed on top in the center. This follows the modern conventions and allows user to quickly navigate the site. I have decided against multiple controller actions because the app is very simple and putting everything on the same page will provide a more consistent experience. 

####API Access
Facebook Graph API provides convenient methods to access wall posts information. The key is to add read-stream in the scope for oauth login. Otherwise, you will only see a subset of all wall posts. I have added most of the API call methods in user model so as to follow the thin-controller-fat-model practice. 

####Data Non-Persistence
I have decided not to persist any data in the database because the purpose of this app calls for processing of the latest feeds. Working with stored data would require merging of existing data and new data, which is an overkill. Also, there is no important use of data to warrant storage.


### Improvements to be made
####Caching
Because loading and processing each user can take some time especially if the user has lots of posts. It would be helpful to do page caching so when the user checks the same friend again, he would not have to wait for re-processing. 

####Batching Processing
Facebook Graph API supports batching call. That would allow us to retrieve photo, name and lastest wall feed all at once. 

