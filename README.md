# Welcome to reflorestar repository

Final project of the Computer Engineering Bachelor's degree: Application to simulate a reforestation plan using Artificial Reality for iOS devices. Final Score: 19/20.

“ReforestAR” is a native augmented reality mobile application for iOS and Android devices, which allows the user to place virtual trees on horizontal surfaces and, with that, simulate a real experience of a reforestation plan. This behavior is achieved through an algorithm that respects several minimum distances between trees. The application also allows users to customize the experience with specific options, such as modifying the scale, type, and quantity of trees to be placed. It even has functionalities to save and load the progress of a reforestation session. “Reforestar” was implemented as a final project of the degree course, later published as a scientific article and in the process of being submitted on the AppStore.

The iOS version was developed my myself while the Android version by my colleague Enrico.

Along with my colleague, we wrote “ReforestAR – An Augmented Reality Mobile app for Reforest Purposes", a paper presented at the B-ranked conference, "VISIGRAPP: 17th International Joint Conference on Computer Vision, Imaging and Computer Graphics Theory and Applications" on February 6, 2022. Published by INSTICC through its SciTePress digital library. Available for free download at: https://www.scitepress.org/Papers/2022/108332/108332.pdf


# Introduction
ReforestAR is a project to raise awareness to environmental damages by immersing users into a real-time reforestation experience using Augmented Reality (AR), by allowing users to virtually place 3D models of trees on a real surface, using their own mobile phones, helping in planning and visualize the replanting process.
To accomplish this purpose, the creation of an augmented reality mobile app, for both iOS and Android platforms. The app, named “ReforestAR”, let users place virtual trees on detected surfaces, and with this, simulating a reforestation planning experience. This behavior was achieved by the usage of an algorithm that acknowledges the minimum distance between trees. The application also enables users to personalize the experience with specific options such as scale modification, quantity of placed trees, and the type of tree that is being placed. Saving, loading, and sharing reforestation projects is also possible.

# Installation Instructions
Clone the repo to your local computer and open XCode, select the option “Open Existing Project” and select the file “reforestar.xcworkspace”. To test the app, you need to run the app on any iOS device which OS version is at least 14.1. (Will not work on a simulator because of the ARKit features that require connection to the camera’s device).

# Usage Examples
Video of the app in use:

[VIDEO]

# Full List of Features of the App
The users can:

•	Select different types of trees and the number to be placed one a single time.

•	Select the size of the trees that will be placed.

•	Save the progress of a session and load back the progress to continue working.

•	Switch between “Reforestation Plan” mode, allowing the user realistic experience of a reforestation plan, with rules like spacing between trees and specific locations placement.

•	Navigate through the application with the help of a bottom navigation bar.

•	Create objects by touching the screen on a desired point through the camera’s device.

•	Activate a mode to only be able to plant trees within a specific area using geolocation.

•	Store AR items placed for future use, even when application is closed.

•	Select different tree species to position in the AR chamber.

•	Change the size interval of the trees 3D models they want to place.

•	View a tree's species catalog that includes information about the flora of the regions known by the application.

•	Search specific species of trees within the catalog using a search engine.

•	View specific information about a selected tree's specie from the species catalog.

•	View a map with the selected specie's footprint highlighted.

•	View a map with the reforestation allowed areas highlighted.

•	View a map with the projects area of field highlighted.

•	View a projects catalog that include information about the projects associated to the user.

•	Update a project from the projects catalog.

•	Delete a project from the projects catalog.

•	Register or log in the application with unique credentials.

•	View his personal information of his account.

•	Update his personal information of his account.

•	Delete his account.

•	Log in or create an account to access premium features of the application or use it without one.

•	Use the application with limited features without logged in account.

•	Register or log in at any time after first usage, by selecting the option in the User Profile section.

•	Navigate through the different sections of the application by clicking the one of the five available options of a bottom navigation bar.

•	Select the 3D model of the tree's specie desired to create by selecting them in the menu.

•	Delete the project if he has permission to do it.

•	Update his personal information by editing specific textboxes and save the changes by clicking on the right button.

•	Set the height interval of the species by selecting it with a slider present in the Reforestation section menu.

•	Load the progress of a project by selecting the option available in the specific project page accessed by selecting it on the catalog section.

•	User's 3D items created will have to be associated with a project to be saved for future use.

•	Save the progress of the current session, he should click on the screen save button.

•	View specific information about a selected tree's specie by clicking the desired option in the catalog.

•	Not be allowed to update or delete any kind of information about tree's catalog.

•	Delete his account by clicking on the specific button.

•	User's geolocation usage permissions will be asked at the beginning of the application for "in-use" permissions policy.

•	Application will read data from the Firebase Database each time user change section or menu option to show real time data to the user.

•	Feature of save progress in different projects is limited to logged-in users.

# About development of the App

The app took between 3 and 3,5 months to de developed. All the details regarding their programming such as: the algorithms used for its correct behavior, the architecture of the app, the scope, their limitations, the way it works will be detailed below.

## Hardware

The computer used to develop this app was a MacBook Pro 13’ from the year 2020, with 16 GB of RAM and an Intel i-7 (2020), an iPhone 7 (2GB of RAM) from the year 2017 and an iPad mini (3G RAM) from the year 2019, and was developed using the Apple IDE’ XCode, which is the only IDE that allows development of iOS native apps. Even tough XCode provides simulators of all the current devices that Apple still gives support, for running apps with AR features it is necessary to run or test the app with a physical device. 

## Software

The programming language that Apple uses for their cross-platform software (macOS, iOS, iPadOS, WatchOS and tvOS) is Swift, which is a robust language, simple and intuitive language to learn. Before 2014 when Swift was firstly introduced, the main programming language was Objective-C which is more like to C.

## 3D Models

The app has three 3D models available for the user to place in the AR reforestation scene but has information relative to sixteen species. The 3D models available in the app were found online for free usage. More detailed models were discovered but the license to use them were paid and or weren’t consider as useful for the purpose of this project.

## Frameworks Used

The App has used the methods of different libraries and frameworks, to implement their features, here is a list of all of them with a brief description of its usage and capabilities.

### Foundation

Foundation is a framework of Swift included in all initial classes when created a new project. It provides basic functionalities like data storage, persistence, calculations, filtering, and networking.

### UIKit Framework

The UIKit framework allows to display elements and content on screen, interact with that content and let the system answer to those interactions. Another framework that does this is SwiftUI, but UIKit is an imperative framework. That means, the components of a screen can be designed like the drag and place method, then associate actions to buttons or list to functions that are created in code, and finally from the code of those functions, deploy events that might be seen in device screen (depends on what is changed). A major limitation is that is not reactive, and the state of variables needs to be tracked at every moment, otherwise wrong information could be displayed, and that is what SwiftUI appeared to solve.

### SwiftUI

Although Swift is the principal programming language, one of the most important tools that developers use to create apps, is Swift UI. A group of tools that allow to create UI elements, it is easier, intuitive, and declarative and has reactive features.
SwiftUI is a framework or group of tools that simplify the way of developing apps, in this case in a declarative way, so no drag and drop items are available, it’s all just code. But the most important ability it’s that through layers the developer could create any element that want to be displayed, call functions and classes when needed and deploy events on a more organized ways, all at the same time.
The most important feature is their reactiveness, SwiftUI has specific type of variables that allow bindings to be automatic and keep variable and user’s state, what simplifies the process for developers and avoid simple mistakes of showing the right data.
It is cross-platform, which means that is possible to use in different apple devices. The only limitation is that because it was first introduced in 2019, it is just available for devices with iOS 13 or higher, so if any app is aimed to work on a device with an older version of iOS, it must use UIKit components.

### MapKit

MapKit is a framework of the Swift programming language, that allows developers to display a map or satellite view on apps, add polygons, figures, annotations, and text so the user could have all the relevant information pointed out int the map. It can also design polygons, personalize their colors, and add mark pointers to defined places.

### CoreLocation

CoreLocation framework determine device’s geographical location in real time, altitude, orientation, and let track user’s location if is entering a specific area or zone.

### AR Kit

Apple’s own AR SDK for iOS Apps that allows apps to display 2D or 3D objects into the camera’s view from the device running the app. AR Kit uses device motion tracking, camera scene capture to build an AR experience, allowing to use the front and back camera od device. With the usage of this AR SDK, ReforestAR let the users:
Place up until 20 models of tress at the same time (functionality available just for specific 3D models) with different scales; save progress and load previous saved progress of 3D placed models; run an algorithm that limit the number of 3D models placed at the same place, so a perspective of “forest” is created.

### Reality Kit

Reality Kit framework works with AR Kit to implement 3D rendering so AR objects can be displayed, the way of working is by gather information provided by the AR Kit framework to integrate all those virtual objects into the real world. This framework allows to import assets, add audio, animate 3D objects, respond to user input and changes of the environment and most recently to synchronize across devices the AR experiences.

### Scene Kit

Scene Kit is a 3D graphics framework that helps developers and designers create 3D animated scenes and effects inside the apps. In resume, it is a framework that works with the assets, or 3D objects that will be placed inside the camera’s view as an AR experience. It’s all about the geometry, materials, lights, and cameras of the objects.

### Firebase iOS SDK

Firebase is the mobile backend as a service that help developers reduce the effort of managing a database and a backend separately, by having just one service that operates as both.
To use it, it is necessary to integrate it with the iOS app, and that can be achieved by an installation through a command line agent (CLI). Cocoa Pods is an agent than then will help install the Firebase SDK into any app, the process is easy. Every time a service of Firebase needs to be added, should be added to be Pods file.  For this app, the only needed were Authentication and the normal Firebase services, which include the Real-Time database support.

### Combine Framework

Combine framework includes an API to handle asynchronous events inside classes in Swift. This is useful to communicate with different components, classes, and instances inside an app, so when a change is done on one part of the code, it can be communicated to other part of the app. This allows events to be triggered now in different parts of the app.

## Architecture

### Software Design Pattern

Because this app was my first, it doesn’t follow a specific pattern, although, and because Apple’s SwiftUI architecture and tutorials, tend to follow an unofficial model called Model-View architecture, where the View is automatically rendered and communicates with the Model to perform the calls and the change of values.

### Database

![Database 1](https://github.com/matiasortizluna/reforestar/assets/64530615/2057e96d-cb66-4ba8-9346-546727edfad5)

Google Real-Time Firebase is used to share the same information between the iOS and the Android App. The database keeps the information of all users and the data of the app (name of 3D models, height, descriptions of trees, etc.).

![Database 2](https://github.com/matiasortizluna/reforestar/assets/64530615/294a7963-f435-4fde-812e-c42c947138c9)


### Data Flow

The app interacts with different entities and software to work correctly, but for the internal components to work synchronously and all the features to be available, some agents perform actions so other parts of the app could know about the updated data. This process is thereafter explained.

Because SwiftUI is a different UI framework, a way of communicating the changes happening in SwiftUI components to UKit components is by using Notification Center and redundancy of variables. This is why there is a Singleton class called “CurrentSession” that holds all variables and data to correctly deploy changes like, saving the progress to a specific project, verify the location of the user, or place 3 trees with a scale of 3.2; on the other hand, because all of these values are part of a singleton class, their changes are not visible in real time in the user’s screen. 

SwiftUI components (framework in charge of UI) are reactive, a special type of variables that maintains their state thought the app cycle and is evident in the user’s screen.
To solve this issue and make a good user experience when changing values, and to allow the user to personalize the reforestation session even better, a CurrentSessionSwiftUI class was created. Thus, when the user changes a value in the UI interface, the change will be experimented in the SwiftUI variables and will trigger in code the functions of the Singleton class, so the information is the same, when deployed actions in the AR session.

![Data Flow](https://github.com/matiasortizluna/reforestar/assets/64530615/bde712bd-d9d4-43f8-8ea5-4e760339df25)


### Seamless integration between SwiftUI and UIKit

There is an advantage when using both frameworks inside the same application. UIKit let developers drag and drop items to the screen and then program their actions, and SwiftUI allows an easier program of components and their actions, including the possibility of defining reactive variables that will update its value when it’s changed everywhere in the app.
Exactly because of this last feature is that using SwiftUI is a better option, because the user interface will need to show different information according to the actions that the user makes. Noteless programming some of the components in SwiftUI could have taken much more time than doing it with UIKit, that’s why it was used as well. And considering that there is the possibility to integrate SwiftUI components into UIKit or vice-versa, then, it was considered a great option to use both, reusing their best features at the same time.
In resume, either SwiftUI and UIKit are important tools when designing the UI interface of an iOS app, each one with their advantages and disadvantages but it’s a useful thing to have the opportunity to use the best of both worlds, at the same time.

### Views

The app has a tab bar with 5 options that will help the user navigate through the different sections of the app, each of them with a unique purpose and with features available inside them. The 5 options are: Areas, Projects, ReforestAR, Catalog, and the User sections.

![Views](https://github.com/matiasortizluna/reforestar/assets/64530615/1e635140-72a3-411d-b4b1-e1136d644665)


#### Areas Section

The areas section shows the map with the device’s location, and polygons overlaid representing the predefined areas that the system has defined.

#### Projects Section

The projects section shows a list of all the reforestation projects associated with the authenticated user. When adding a virtual 3D tree’s model with AR, its placement is associated with a project. Each project has a specific view that is shown when selected from the list, showing the project’s name, description, status, number of trees, associated users, and sharing/deleting functions if the user that is accessing the page is the project owner.

#### Trees Section

The trees section shows a list of all the tree species considered in the project’s scope. A specific view for each tree is shown when selected, and it shows the tree’s Latin name, common name, recommended space between each one when planted, its minimum and maximum height, and a description.

#### User Section

The user section shows the user’s name, email, username, statistics about the number of projects of the authenticated user, and the number of planted trees. The login, logout and account registration options are also available here. All registration and login forms have validation functions, and an error message is presented when inserted values don’t meet validation rules.

#### ReforestAR Section

The ReforestAR section holds the AR view where the main features of the application are available, or in other words, the AR camera, along with some instructions.
ReforestAR Section in iOS was developed with SwiftUI and is compound by different buttons, labels, sliders, switchers, and pickers with each one of them with a specific function.

Some of the views have either SwiftUI, UIKit components or both. The way of communicating the changes happening in SwiftUI components to UIKit components is done with the API of the Notification Center 15 and redundancy of variables. SwiftUI components are reactive, so the variables state is kept through the app cycle and is evident in the user’s screen. Notification Center notifications are used to exchange information between the interface (as for example, the tap of a button) to the AR class and vice versa, making the user experience fluid and user friendly.

Labels that show relevant information, such as: the current number of trees that have been placed in the current session and the real-time geographic location of the user's device. A toggle switch activates a functionality that compares the current user’s device location to the one stored in the project once the load.

Buttons to remove the last placed tree from the current session, present a view with all available models that may be selected, and a to display or hide a right bar menu. This right bar menu contains a picker select for configuring the number of trees to be placed by a single tap (from 1 to 10), a slider that modifies the scale of future placement models, and another button to display or hide a small menu that includes features to delete all the placed trees existing in the current session, select the associated project, and save and load progress from the associated project. 

##### ReforestAR Placement Algorithm

When the user taps on an available horizontal surface on the screen, an object is created in that position. The algorithm was created so when the user taps to create objects, it must respect some ground rules as if it was a real reforestation plan. The user can’t create an object in a position where there is another virtual object. Every object should have a distance value to prevent this from happening. Now, when the user intends to create more than one object with a single click, the first object will be placed in this position, but it will also be used as the origin position to create new random positions for the new objects that are part of the same tap group. The new positions will go through several comparisons that will verify that they are valid positions to simulate a reforestation environment. If the positions created do not comply, a new position is created and the verifications are made again, having a limit of twenty attempts per position, before failing and communicating to the user that the place where they intend to place the objects does not have enough space.
The three rules that the new random positions must follow are: 1) To be between a “min_distance” and “max_distance” away from the initial position, the first tap of the user. 2) To be “min_distance” and “max_distance” away from any of the models from the same tap group. 3) To be “min_distance” and “max_distance” away from any models that already
existed in the scene before the tap group. 

##### Algorithm load functionality

The process of loading is activated once the user taps in the button, and it will retrieve the information about stored 3D models in the selected project in the Google Firebase database. The user will select a point in the surface that will serve as the origin position to relate the stored 3D models previous positions.

## Limitations

3D models with a size of more than 200MB were found available, but when they were used, the devices would crash since the required RAM was not available on the development equipment, this thus being the main motive for why lighter models were chosen. In future versions, new 3D models are expected to be included.

Apple’s Scene Kit 3D object format “Universal Scene Description” USDZ keeps all the assets of the AR Scenario (including the 3D object) as a folder structure of nested sub-elements from a single “zip file”, but when 3D objects were imported to Apple’s Scene, some of their features weren’t correctly patched to the exported 3D object. That’s why the same models in iOS look different from Android. On future versions, the layout of 3D models is expected to have more details.
