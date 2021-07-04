# Life Cycle
## Widget Life Cycle

-   `createState ()` : When we build a new StatefulWidget, this one calls createState() right away and this override method must exist
-   `initState()` :it is the first method called after the Widget is created.This is our equivalent to onCreate() and viewDidLoad()
-   `didChangeDependencies()` : This method is called immediately after initState() on the first time the widget is built
-   `build()` : called right after didChangeDependencies(). All the GUI is render here and will be called every single time the UI needs to be render
-   `didUpdateWidget()` : it’ll be called once the parent Widget did a change and needs to redraw the UI
-   `deactivate()` : framework calls this method whenever it removes this State object from the tree
-   `dispose()` :is called when this object and its State is removed from the tree permanently and will never build again.

## App Life Cycle

-   `inactive` - The application is in an inactive state and is not receiving user input.  **iOS only**    
-   `paused` - The application is not currently visible to the user, not responding to user input, and running in the background.
-   `resumed` - The application is visible and responding to user input.
-  `suspending` - The application will be suspended momentarily.  **Android only**

