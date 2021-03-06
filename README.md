# iOS ARKit demo: Pet
Demo is a tabletop augmented reality iOS demo app, built with the echoAR Swift SDK, that allows users
to choose their favourite pets.

**By Yuhan Yin**

-------------------------

## Build and Run
1. Make sure you have Xcode downloaded
2. clone this repository
3. Go to the "Signing&Capabilities" tab on Xcode and fill out your signing
  information. See more details [here](https://docs.echoar.xyz/swift/adding-ar-capabilities) 
4. Go to the EchoAR.swift file, insert api key
5. Go to the echoAR console and add the 3d content
6. Go to the ViewController.swift file, add the entry id's for 3d content
7. Connect iPhone to your computer.
8. Press the play button to build an run (Note: your device must be unlocked to run)
9. Use postman to get `entryId` for each model
10. Add `UIPinchGestureRecognizer` to interact with your pet. Like look closer and touch it.
11. Add **Drawing** sections. RGSColorSlider is used to choose different color
12. Use `DispatchQueue` to create new nodes and add it to the original model. In each session, we create a SCNNode adding to the existing node.

##  Using The Demo
1. Move your phone around a horizontal surface to scan a plane.
2. The fox pet is selected by default
3. Use other buttons to change your pet. Choices are Fox, Ferret, Parrot, JapanFox and Corgi.
4. Use Color button to choose whichever color/size you like.
5. Use Pen to start drawing and decorating your pet.
6. Use Erase button to delete the part you do not like.

## Screenshots


![image-20210122153345081](3.png)

### Images of the default entries for the demo
![image-20210122153439814](2.png)