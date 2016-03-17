
class Vehicle {

  // The usual stuff
  PVector location;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed
  int blue;
  int alpha;

  Vehicle(PVector l, float ms, float mf, int b, int a) {
    location = l.get();
    r = mf*2;
    maxspeed = ms;
    maxforce = mf;
    acceleration = new PVector(0, 0);
    velocity = new PVector(0, 0);
    blue = b;
    alpha = a;
  }

  public void run(float radius) {
    update();
    borders();
    display(radius);
  }


  // Implementing Reynolds' flow field following algorithm
  // http://www.red3d.com/cwr/steer/FlowFollow.html
  void follow(FlowField flow) {
    // What is the vector at that spot in the flow field?
    PVector desired = flow.lookup(location);
    // Scale it up by maxspeed
    desired.mult(maxspeed);
    // Steering is desired minus velocity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);  // Limit to maximum steering force
    applyForce(steer);
  }

  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acceleration.add(force);
  }

  // Method to update location
  void update() {
    // Update velocity
    velocity.add(acceleration);
    // Limit speed
    velocity.limit(maxspeed);
    location.add(velocity);
    // Reset accelertion to 0 each cycle
    acceleration.mult(0);
  }

  void display(float radius) {
    // Draw a triangle rotated in the direction of velocity
    float theta = velocity.heading2D() + radians(90);
    int red = (int) map(blue, 0, 100, 180, 220); 
    int green = (int) map(blue, 0, 100, 80, 120); 

    fill(red, green, blue, alpha);
//    tint(255, alpha);
    noStroke();
    pushMatrix();
    translate(location.x, location.y);
    rotate(theta);
    radius*= flowfield.listItem/7.5;
    scale(radius);
//image(img,  -r/2, -r/2);
    ellipse(0, 0, r*2, r*2);

    popMatrix();
  }

  // Wraparound
  void borders() {
    if (location.x < -r) location.x = width+r;
    if (location.y < -r) location.y = height+r;
    if (location.x > width+r) location.x = -r;
    if (location.y > height+r) location.y = -r;
  }
  
   PVector separate (ArrayList boids) {
    float desiredseparation = r*2;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    // For every boid in the system, check if it's too close
    for (int i = 0; i < boids.size(); i++) {
      Vehicle other = (Vehicle) boids.get(i);
      float d = PVector.dist(location, other.location);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(location, other.location);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      steer.div((float)count);
    }

    // As long as the vector is greater than 0
    if (steer.mag() > 0) {
      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(velocity);
      steer.limit(maxforce);
    }
    return steer;
  }
}