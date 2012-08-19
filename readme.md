Love Xbox 360 Controller Test App
====================

This app exists to allow you to test [XInputLUA](https://github.com/mrcharles/XInputLUA) with a 360 controller. 

Setup
-------

Copy XInputLUA.dll next to your love.exe. 

NOTE: This project now relies on the XPad library, which you can get from [here](https://github.com/mrcharles/XPad). Please make sure this library is present when you run the project. 


Run
---

That's it! You can see your input react to the libs, and you can explore the differences between XInputLUA and Love.Joystick. 

Hitting spacebar will toggle between raw input labels ("a", "x", "leftx", etc), and a mapped subset of command aliases ("action", "jump", etc)
