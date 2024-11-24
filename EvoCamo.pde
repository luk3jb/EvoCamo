/*
EvoCamo v1
 November 18 2024
 */

int size=1024;
int[][] backdrop = new int[size][size];
int fastForward=1;
int eats;
int failedEats;
int oldAge;
int predDeaths;
int preyDeaths;
int frame;
boolean controllingPred=true;
PGraphics pg;
PGraphics debugVisionGraphics;

PImage img;

Pred[] predator = new Pred[256];
Prey[] prey = new Prey[256];
void setup() {
  size(1400, 1024);
  frameRate(1000);
  noSmooth();
  textSize(25);
  pg=createGraphics(size, size);
  debugVisionGraphics=createGraphics(16, 16);
  rectMode(CENTER);

  img = loadImage("stripeNoise1024.png");
  imageBackdrop();

  for (int i = 0; i<predator.length; i++) {
    predator[i]=new Pred();
  }

  for (int i = 0; i<prey.length; i++) {
    prey[i]=new Prey();
  }
}

void draw() {
  background(100);
  runUI();
  for (int i=0; i<fastForward; i++) {
    frame++;
    pg.beginDraw();
    drawBackdrop();
    runPreys();
    runPredators();
    pg.endDraw();
  }

  image(pg, 0, 0, height, height);
}

void runPredators() {
  for (int i = 0; i<predator.length; i++) {
    predator[i].scan();
  }
  for (int i = 0; i<predator.length; i++) {
    predator[i].move();
  }
  for (int i = 0; i<predator.length; i++) {
    predator[i].threats();
  }
  for (int i = 0; i<predator.length; i++) {
    predator[i].think();
  }
  collidePredsAndPreys();
  for (int i = 0; i<predator.length; i++) {
    predator[i].drawPred();
  }
}

void runPreys() {
  for (int i = 0; i<prey.length; i++) {
    prey[i].scan();
  }
  for (int i = 0; i<prey.length; i++) {
    prey[i].move();
  }
  for (int i = 0; i<prey.length; i++) {
    prey[i].think();
  }
  collidePreys();
  for (int i = 0; i<prey.length; i++) {
    prey[i].drawPrey();
  }
}

void runUI() {
  predator[0].debugDrawVision();
  prey[0].debugDrawVision();
  debugDrawPreyAppearance(0);
  push();
  fill(0);
  text("Frame:\n"+frame, 1250, 50);
  text("fastForward:\n"+fastForward+"x", 1250, 120);
  text("Pred[0]'s View:", 1044, 25);
  text("Prey[0]'s View:", 1044, 230);
  text("Prey[0]'s Appearance:", 1044, 470);
  text("Total Preds: "+predator.length+"\nTotal Preys: "+prey.length+"\nSuccessful eats: "+eats+"\nFailed eats: "+failedEats+"\nDeath of old age: "+oldAge+"\nTotal Pred deaths: "+predDeaths+"\nAverage times ate "+avgTimesAte()+"\n Average Pred age:"+avgAge(true)+" frames"+"\n Average Prey age:"+avgAge(false)+" frames", 1030, 690);
  pop();
}

int avgAge(boolean isPred) {
  if (isPred) {
    float allAges=0;
    for (int i=0; i< predator.length; i++) {
      allAges=allAges+predator[i].age;
    }
    return round(allAges/predator.length);
  } else {
    float allAges=0;
    for (int i=0; i< prey.length; i++) {
      allAges=allAges+prey[i].age;
    }
    return round(allAges/prey.length);
  }
}

float avgTimesAte() {
  float allTimesAte=0;
  for (int i=0; i< predator.length; i++) {
    allTimesAte=allTimesAte+predator[i].timesAte;
  }
  return (allTimesAte/predator.length);
}

void collidePreys() {
  for (int i = 0; i < prey.length; i++) {
    for (int j = 0; j < prey.length; j++) {
      if (i != j) {
        if (prey[i].pos.x < prey[j].pos.x + 16 &&
          prey[i].pos.x + 16 > prey[j].pos.x &&
          prey[i].pos.y < prey[j].pos.y + 16 &&
          prey[i].pos.y + 16 > prey[j].pos.y) {

          if (prey[i].pos.x > prey[j].pos.x) {
            prey[i].pos.x++;
          }

          if (prey[i].pos.x < prey[j].pos.x) {
            prey[i].pos.x--;
          }

          if (prey[i].pos.y > prey[j].pos.y) {
            prey[i].pos.y++;
          }

          if (prey[i].pos.y < prey[j].pos.y) {
            prey[i].pos.y--;
          }
        }
      }
    }
  }
}


void collidePredsAndPreys() {
  for (int i = 0; i < predator.length; i++) {
    if (predator[i].eating) {
      predator[i].eating=false;
      boolean atePrey = false;

      for (int j = 0; j < prey.length; j++) {
        float predatorCenterX = predator[i].pos.x + 7;
        float predatorCenterY = predator[i].pos.y + 7;
        float predatorRightCenterX = predator[i].pos.x + 8;
        float predatorBottomCenterY = predator[i].pos.y + 8;

        if (predatorCenterX < prey[j].pos.x + 16 &&
          predatorRightCenterX > prey[j].pos.x &&
          predatorCenterY < prey[j].pos.y + 16 &&
          predatorBottomCenterY > prey[j].pos.y) {
          prey[j].respawn();
          predator[i].time=predator[i].time+10000;
          predator[i].timesAte++;
          eats++;
          atePrey = true;
          break;
        }
      }

      if (!atePrey) {
        failedEats++;
        predator[i].respawn();
      }
    }
  }
}





void drawBackdrop() {
  pg.loadPixels();
  for (int i = 0; i < backdrop.length; i++) {
    for (int j = 0; j < backdrop[i].length; j++) {
      int index = i + j * pg.width;
      pg.pixels[index] = backdrop[i][j];
    }
  }
  pg.updatePixels();
}

void patternBackDrop() {
  for (int i = 0; i < backdrop.length; i++) {
    for (int j = 0; j < backdrop[i].length; j++) {
      backdrop[i][j] = ((i + j) % 15)*17;
    }
  }
}

void fractalBackdrop() {
  for (int i = 0; i < backdrop.length; i++) {
    for (int j = 0; j < backdrop[i].length; j++) {
      backdrop[i][j] = img.pixels[i^j];
    }
  }
}

void imageBackdrop() {
  img.loadPixels();

  for (int i = 0; i < backdrop.length; i++) {
    for (int j = 0; j < backdrop[i].length; j++) {
      int pixelIndex = i + j * img.width;
      backdrop[i][j] = img.pixels[pixelIndex];
    }
  }
}

void debugDrawPrednVision(int n) {
  debugVisionGraphics.beginDraw();
  for (int i = 0; i < predator[n].vision.length; i++) {
    for (int j = 0; j < predator[n].vision.length; j++) {
      debugVisionGraphics.stroke(predator[n].vision[i][j]);
      debugVisionGraphics.point(i, j);
    }
  }

  debugVisionGraphics.endDraw();

  image(debugVisionGraphics, 1054, 500, height/6, height/6);
}

void debugDrawPreyAppearance(int n) {
  debugVisionGraphics.beginDraw();
  int index = 0;

  for (int i = 0; i < 16; i++) {
    for (int j = 0; j < 16; j++) {
      debugVisionGraphics.stroke(prey[n].pattern[index]);
      debugVisionGraphics.point(j, i);
      index++;
    }
  }
  debugVisionGraphics.endDraw();

  debugVisionGraphics.endDraw();

  image(debugVisionGraphics, 1054, 500, height/6, height/6);
}

void keyPressed() {
  if (keyCode==81) {
    fastForward--;
  }
  if (keyCode==69) {
    fastForward++;
  }
}

/*
void keyPressed() {
 if (controllingPred) {
 if (keyCode==87) {
 predator[0].movingUp=true;
 }
 if (keyCode==83) {
 predator[0].movingDown=true;
 }
 if (keyCode==65) {
 predator[0].movingLeft=true;
 }
 if (keyCode==68) {
 predator[0].movingRight=true;
 }
 } else {
 if (keyCode==87) {
 prey[0].movingUp=true;
 }
 if (keyCode==83) {
 prey[0].movingDown=true;
 }
 if (keyCode==65) {
 prey[0].movingLeft=true;
 }
 if (keyCode==68) {
 prey[0].movingRight=true;
 }
 }
 
 if (keyCode==32) {
 if (controllingPred) {
 controllingPred=false;
 } else {
 controllingPred=true;
 }
 }
 if (keyCode==69) {
 predator[0].eating=true;
 }
 }
 
 void keyReleased() {
 if (controllingPred) {
 if (keyCode==87) {
 predator[0].movingUp=false;
 }
 if (keyCode==83) {
 predator[0].movingDown=false;
 }
 if (keyCode==65) {
 predator[0].movingLeft=false;
 }
 if (keyCode==68) {
 predator[0].movingRight=false;
 }
 } else {
 if (keyCode==87) {
 prey[0].movingUp=false;
 }
 if (keyCode==83) {
 prey[0].movingDown=false;
 }
 if (keyCode==65) {
 prey[0].movingLeft=false;
 }
 if (keyCode==68) {
 prey[0].movingRight=false;
 }
 }
 }
 */
