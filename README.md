# paper
Create a 2d animated character from paper sketches

## Description

You need one piece of paper and a webcam.
Draw your character as sprite under the paper.
Run the code : your character is now moving under your computer.

If you have a projector and a white board or paper you can project the result on it.

## how the code is to be 

1. Detect n character sprites from a paper using a web cam
2. Treat the detected sprites to make them clean
3. Detect a white paper next using the webcam
4. Project the character under the white paper
5. Make the character move

## Version

This project is in very early stage pre alpha 0.0.1.  
I am porting what I did in lua to cpp.


## Prerequisites

Based on ARtoolkit https://artoolkit.org

## run

comming soon

## Modules 

### Detection

Detects the sprites from the character to animate.
Detects the white piece of paper where the charater will be projected.

### Animation

Takes as input a walk cycle divided into n sprites.  
Makes the character move.

### Projection

Projects the animated under the white paper.  
Track that the image is correctly projected on the white paper.

