
import ddf.minim.*;
import ddf.minim.ugens.*;

Minim minim;
AudioOutput out;

Oscil      wave;
Frequency  currentFreq;

float noise = 0;
float noiseX= 0;
float noiseY= 110000;
float noiseR = 1;

float xn, yn;
float xoff = 0;
float yoff = 999;
boolean noiseOn = false;



float offset = 0;
float offsetValue = .0100;

boolean debug = false;

PImage img;

// Flowfield object
FlowField flowfield;
// An ArrayList of vehicles
ArrayList<Vehicle> vehicles;

void setup() {
  ////////MINIM SETUP ////////
  minim = new Minim(this);
  out   = minim.getLineOut();

  currentFreq = Frequency.ofHertz( 432 );
  wave = new Oscil( currentFreq, 0.6f, Waves.SINE );

  wave.patch( out );
  noCursor();

  // size(1800, 1000, P2D);
  fullScreen(P2D);
  img = loadImage("grad.png");
  // Make a new flow field with "resolution" of 16
  flowfield = new FlowField(20);
  vehicles = new ArrayList<Vehicle>();
  // Make a whole bunch of vehicles with random maxspeed and maxforce values
  for (int i = 0; i < 25000; i++) {
    vehicles.add(new Vehicle(new PVector(random(width), random(height)), random(.5, 3), random(0.3, .9), int(random(0, 100)), int(random(50, 255))));
  }
  background(0);
}

void draw() {
  //image(img, 0, 0);
  fill(0, 10);
  rect(0, 0, width, height);

  float oscillate = map(sin(offset), -1, 1, -9, 4);

  //  rect(0, 0, width, height);
  /* if (noiseOn = true) {
   noiseX = map(noise(noise), -1, 1, -2, 2);
   noiseY = map(noise(noise), -1, 1, -2, 2);
   path.updatePoints(noiseX, noiseY);
   } else { */
  xn = map(noise(xoff), 0, 1, 0.001, .100);
  xoff+= .1;

  noiseX = map(noise(sin(noise)), -1, 1, 0, TWO_PI);
  noiseY = map(cos(noise(noise)), -1, 1, 0, TWO_PI);
  noiseR = map(cos(noise(noise)), -1, 1, .1, 2.5);
  offset+= offsetValue;
  // path.updatePoints(noiseX, noiseY);

  flowfield.update(new PVector(noiseX, noiseY));

  fill(0);


  // Display the flowfield in "debug" mode
  if (debug) flowfield.display();
  // Tell all the vehicles to follow the flow field
  for (Vehicle v : vehicles) {
    v.follow(flowfield);
    v.run(noiseR);
    //        v.separate(vehicles);
  }

  noise+= xn;
  println(xn);
  if (debug) flowfield.display();;
  // Instructions
}


void keyPressed() {
  if (key == ' ') {
    debug = !debug;
  }
}