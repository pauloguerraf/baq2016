# Quito Architecture Biennial / Interface Prototype / 2016  

Quick prototype using Processing to test control of projection mapped digital posters through OSC messages. Biennnial visitors shoudl be able to navigate through submissions using a wireless rotary interface. 

The project consists of an image gallery that looks for images within a data folder. The selected image is projected as a quad texture. Each of point of the projected quad can be tranlasted in order to achieve the right projection perspective on the projection surface. The user can navigate through the image gallery using a knob connected to a [Particle Photon](https://docs.particle.io/photon/) that send the current knob position via OSC messages to the server controlling the projection. 

The final version of this project was implemented using openFrameworks due to performance issues we encountered when using Processing on a Raspberry Pi.

![BAQ2016](https://github.com/pauloguerraf/baq2016_Processing/blob/master/baq2016.jpg "BAQ2016")

![BAQ2016](https://github.com/pauloguerraf/baq2016_Processing/blob/master/baq2016_2.jpg "BAQ2016")
