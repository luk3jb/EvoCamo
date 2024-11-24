class Pred {
  PVector pos;
  int[][] vision = new int[16][16];

  int moveSpeed=1;
  float time;
  boolean movingUp, movingDown, movingLeft, movingRight;
  boolean eating;

  int age;
  int timesAte;

  int[] inputValues;
  NeuralNet predBrain;

  Pred() {
    pos=new PVector(random(0, size-16), random(0, size-16));
    time=random(250, 500);
    predBrain=new NeuralNet(260, 512, 256, 256, 5);
  }

  void think() {
    inputValues = new int[261];
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
    inputValues[260]=age;

    predBrain.setInput(float(inputValues));
    predBrain.generate();

    brainControl();
  }

  void brainControl() {
    if (predBrain.output[0]>0.5) {
      movingUp=true;
    } else {
      movingUp=false;
    }
    if (predBrain.output[1]>0.5) {
      movingDown=true;
    } else {
      movingDown=false;
    }
    if (predBrain.output[2]>0.5) {
      movingLeft=true;
    } else {
      movingLeft=false;
    }
    if (predBrain.output[3]>0.5) {
      movingRight=true;
    } else {
      movingRight=false;
    }
    if (predBrain.output[4]>0.9) {
      eating=true;
    } else {
      eating=false;
    }
  }

  void drawPred() {
    push();
    pg.noFill();
    pg.stroke(255, 0, 0, 150);
    pg.rect(pos.x-1, pos.y-1, 17, 17);
    pg.rect(pos.x+7, pos.y+7, 1, 1);
    pop();
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

  void threats() {
    time--;
    if (time<=0) {
      oldAge++;
      respawn();
    }
  }

  void respawn() {
    predDeaths++;
    age=0;
    timesAte=0;
    int parent=int(random(0, predator.length));
    eating=false;
    pos.x=predator[parent].pos.x+random(-32, 32);
    pos.y=predator[parent].pos.y+random(-32, 32);
    time=random(250, 500);

    predBrain.setWeightsAndBiases(predator[parent].predBrain.weightL1, predator[parent].predBrain.weightL2, predator[parent].predBrain.weightL3,predator[parent].predBrain.weightL4,  predator[parent].predBrain.bias1, predator[parent].predBrain.bias2, predator[parent].predBrain.bias3,predator[parent].predBrain.bias4);
    predBrain.mutate(0.05, 0.1);
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

    image(debugVisionGraphics, 1054, 30, height/6, height/6);
  }
}
