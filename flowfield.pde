class FlowField {
  PVector[][] field;
  int col, row;
  int res;
int listItem;
  float freqArray[] = {32.11, 34.02, 36.04,38.18, 40.45, 42.86, 45.41, 48.11, 50.97, 54.00, 57.21};

  FlowField(int resolution) {
    res = resolution;
    col = width/res;
    row = height/res;

    field = new PVector[col][row];
    init();
  }
  void init() {
    float xoff = 0.0;
    for (int i = 0; i < col; i ++) {
      float yoff = 0.0;
      for (int j = 0; j < row; j++) {
        float theta = map(noise(xoff, yoff), 0, 1, 0, TWO_PI);
        float x = i*res;
        float y = j*res;
        PVector v = new PVector(width/2-x, height/2-y);

        v.normalize();
        field[i][j] = new PVector(cos(theta), sin(theta));
        //  field[i][j] = v;
        yoff += 0.1;
      }
      xoff+= 0.1;
    }
  }

  void update(PVector n) {

     listItem = (int) map(n.x, 0, TWO_PI, 0, freqArray.length);
    float note = freqArray[listItem];

    currentFreq = Frequency.ofHertz( note ); 

    wave.setFrequency( currentFreq ); 
      float xoff = 0.0;
    for (int i = 0; i < col; i ++) {
      float yoff = 0.0;
      for (int j = 0; j < row; j++) {
        float theta = map(noise(xoff, yoff), 0, 1, 0, TWO_PI);
        float x = i*res;
        float y = j*res;
        PVector v = new PVector(width/2-x, height/2-y);

        v.normalize();

        field[i][j] = new PVector(cos(theta)*sin(n.x), sin(theta)*cos(n.y));
        //  field[i][j] = v;
        yoff += 0.1;
      }
      xoff+= 0.1;


        

      }
    }
  



  PVector lookup(PVector lookup) {
    int column =  int(constrain(lookup.x/res, 0, col-1));
    int rows =       int(constrain(lookup.y/res, 0, row-1));
    return field[column][rows].get();
  }

  void display() {
    for (int i = 0; i < col; i++) {
      for (int j = 0; j < row; j++) {
        pushMatrix();
        translate(i*res, j*res);
        rotate(field[i][j].heading2D());
        stroke(255, 0, 0);
        line(-res/2, 0, res/2, 0);
        line(res/2, 0, res/8, res/8);
        line(res/2, 0, res/8, -res/8);

        popMatrix();
      }
    }
  }
}