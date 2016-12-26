# Schwifty-Chat
CST 495 Final Project

Requirements
Description	Points
Has a storyboard with 4 meaningful view controllers connected by segues	40
        • View for user login
                ○ Segues to Chat view
        • Chat view displays chat messages
                ○ Segues to message detail on touch of chat message
                ○ Segues to image view on touch of images
        • Chat Message Detail View for displaying more information about chat message
        • Image View for displaying image
Has Login Screen that authenticates user (does not have to be to server)	5
        • Login screen authenticates user signup through Firebase
Uses GCD for multi-threaded operations	10
        • Alerts displayed with GCD async
Uses Alert pattern	5
        • UIAlertAction used in signout confirmation
Uses UITableView or UICollectionView to display array of data	10
        • TableView manages chat data
Uses UIScrollView	5
        • Image Detail view utilizes ScrollView to navigate image
Extra Credit
Uses pods for external libraries	5
        • Pods used for Firebase framework
Uses server to support application	10
        • Firebase used for managing user auth
        • Firebase used for chat database 
Uses Camera	5
        • Add image button toggles image picker or camera
