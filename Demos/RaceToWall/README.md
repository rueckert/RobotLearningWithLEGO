This folder provides a demo script for the following task:

The robot is placed sonmewhere in front of a wall, heading towards the wall. The task is to move the robot as close to the wall as possible, without touching it.

The provided implementation stops the robot if the ultrasonic sensor returns values smaller that 15cm. In the range of 15cm to 30 cm the robot moves with half the speed to avoid overshooting.
[RaceToWall.m](https://github.com/rueckert/RobotLearningWithLEGO/blob/master/Demos/RaceToWall/RaceToWall.m) contains the code for the normal Matlab add on, while [RaceToWallAS.m](https://github.com/rueckert/RobotLearningWithLEGO/blob/master/Demos/RaceToWall/RaceToWallAS.m) contains the implementation with the [async-extension](https://github.com/rueckert/RobotLearningWithLEGO/tree/master/AsyncComputing).
