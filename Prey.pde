class Prey {
  PVector pos;
  int[][] vision = new int[16][16];
  int[] pattern=new int[256];
  boolean movingUp, movingDown, movingLeft, movingRight;
  
  int moveSpeed=1;
  
  int age;

  int[] inputValues;
  NeuralNet preyBrain;

  Prey() {
    pos=new PVector(random(0, size-16), random(0, size-16));
    preyBrain=new NeuralNet(259, 64, 32, 32, 4);
    for (int i=0; i< pattern.length; i++) {
      pattern[i]=int(random(127, 127));
    }
  }

  void think() {
    inputValues = new int[260];
    for (int i = 0; i < vision.length; i++) {
      for (int j = 0; j < vision[i].length; j++) {
        int index = i * vision.length + j;
        inputValues[index] = vision[i][j];
      }
    }
    if (movingUp) {
      inputValues[256]=1;
    } else {
      inputValues[256]=0;
    }
    if (movingDown) {
      inputValues[257]=1;
    } else {
      inputValues[257]=0;
    }
    if (movingLeft) {
      inputValues[258]=1;
    } else {
      inputValues[258]=0;
    }
    if (movingRight) {
      inputValues[259]=1;
    } else {
      inputValues[259]=0;
    }

    preyBrain.setInput(float(inputValues));
    preyBrain.generate();

    brainControl();
  }

  void brainControl() {
    if (preyBrain.output[0]>0.5) {
      movingUp=true;
    } else {
      movingUp=false;
    }
    if (preyBrain.output[1]>0.5) {
      movingDown=true;
    } else {
      movingDown=false;
    }
    if (preyBrain.output[2]>0.5) {
      movingLeft=true;
    } else {
      movingLeft=false;
    }
    if (preyBrain.output[3]>0.5) {
      movingRight=true;
    } else {
      movingRight=false;
    }
  }

  void drawPrey() {
    pg.push();
    pg.translate(pos.x, pos.y);
    int index = 0;

    for (int i = 0; i < 16; i++) {
      for (int j = 0; j < 16; j++) {
        pg.stroke(pattern[index]);
        pg.point(j, i);
        index++;
      }
    }

    pg.pop();
  }

  void scan() {
    for (int i = 0; i < vision.length; i++) {
      for (int j = 0; j < vision.length; j++) {
        vision[i][j]=int(brightness(pg.get(int(pos.x+i), int(pos.y+j))));
      }
    }
  }

  void move() {
    age++;
    
    if (movingUp) {
      pos.y-=moveSpeed;
    }
    if (movingDown) {
      pos.y+=moveSpeed;
    }
    if (movingLeft) {
      pos.x--;
    }
    if (movingRight) {
      pos.x+=moveSpeed;
    }

    // dont leave borders
    if (pos.x>size-16) {
      pos.x=0;
    }
    if (pos.x<0) {
      pos.x=size-16;
    }

    if (pos.y>size-16) {
      pos.y=0;
    }
    if (pos.y<0) {
      pos.y=size-16;
    }
  }

  void respawn() {
    preyDeaths++;
    age=0;
    int parent=int(random(0, prey.length));
    pos.x=prey[parent].pos.x+random(-32,32);
    pos.y=prey[parent].pos.y+random(-32,32);

    for (int i = 0; i < pattern.length; i++) {
      pattern[i]=prey[parent].pattern[i];
    }
    mutatePattern(0.25, 25);

    preyBrain.setWeightsAndBiases(prey[parent].preyBrain.weightL1, prey[parent].preyBrain.weightL2, prey[parent].preyBrain.weightL3,prey[parent].preyBrain.weightL4,prey[parent].preyBrain.bias1,prey[parent].preyBrain.bias2,prey[parent].preyBrain.bias3,prey[parent].preyBrain.bias4);
    preyBrain.mutate(0.05, 0.1);
  }

  void mutatePattern(float mutationRate, float mutationAmount) {
    for (int i = 0; i < pattern.length; i++) {
      if (random(1) < mutationRate) {
        float change = random(-mutationAmount, mutationAmount);
        pattern[i] = (int)constrain(pattern[i] + change, 0, 255);
      }
    }
  }




  void debugDrawVision() {
    debugVisionGraphics.beginDraw();
    for (int i = 0; i < vision.length; i++) {
      for (int j = 0; j < vision.length; j++) {
        debugVisionGraphics.stroke(vision[i][j]);
        debugVisionGraphics.point(i, j);
      }
    }

    debugVisionGraphics.endDraw();

    image(debugVisionGraphics, 1054, 250, height/6, height/6);
  }
}
