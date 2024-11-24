// made with assistance from ChatGPT becuase i dont know how to write neural nets

class NeuralNet {

  // Neural network layers and weights
  float[] input;
  float[] hidden1;
  float[] hidden2;
  float[] hidden3;
  float[] output;

  float[] weightL1;  // weights from input to hidden1
  float[] weightL2;  // weights from hidden1 to hidden2
  float[] weightL3;  // weights from hidden2 to output
  float[] weightL4;  // weights from hidden2 to output

  float[] bias1;     // bias for hidden1 layer
  float[] bias2;     // bias for hidden2 layer
  float[] bias3;     // bias for hidden3 layer
  float[] bias4;     // bias for output layer

  NeuralNet(int numInput, int numHidden1, int numHidden2,int numHidden3, int numOutput) {

    // Initialize layers
    input = new float[numInput];
    hidden1 = new float[numHidden1];
    hidden2 = new float[numHidden2];
    hidden3 = new float[numHidden3];
    output = new float[numOutput];

    // Initialize weight matrices
    weightL1 = new float[numInput * numHidden1];
    weightL2 = new float[numHidden1 * numHidden2];
    weightL3 = new float[numHidden2 * numHidden3];
    weightL4 = new float[numHidden3 * numOutput];

    // Initialize bias arrays
    bias1 = new float[numHidden1];
    bias2 = new float[numHidden2];
    bias3 = new float[numHidden3];
    bias4 = new float[numOutput];

    // Initialize input values (set first input to 1 for bias, others to 0)
    for (int i = 0; i < input.length; i++) {
      input[i] = (i == 0) ? 1 : 0;
    }

    // Initialize hidden layers and output values to 0
    for (int i = 0; i < hidden1.length; i++) {
      hidden1[i] = 0;
    }
    for (int i = 0; i < hidden2.length; i++) {
      hidden2[i] = 0;
    }
    for (int i = 0; i < hidden3.length; i++) {
      hidden3[i] = 0;
    }
    for (int i = 0; i < output.length; i++) {
      output[i] = 0;
    }

    // Initialize weights and biases with small random values
    for (int i = 0; i < weightL1.length; i++) {
      weightL1[i] = random(-10, 10);  // smaller range to prevent large activations
    }
    for (int i = 0; i < weightL2.length; i++) {
      weightL2[i] = random(-10, 10);
    }
    for (int i = 0; i < weightL3.length; i++) {
      weightL3[i] = random(-10, 10);
    }
    for (int i = 0; i < weightL4.length; i++) {
      weightL4[i] = random(-10, 10);
    }

    // Initialize biases with small random values
    for (int i = 0; i < bias1.length; i++) {
      bias1[i] = random(-10, 10);
    }
    for (int i = 0; i < bias2.length; i++) {
      bias2[i] = random(-10, 10);
    }
    for (int i = 0; i < bias3.length; i++) {
      bias3[i] = random(-10, 10);
    }
    for (int i = 0; i < bias4.length; i++) {
      bias4[i] = random(-10, 10);
    }
  }

  // Sigmoid activation function
  float sigmoid(float x) {
    return 1 / (1 + exp(-x));
  }

  // Generate output based on input and weights
  void generate() {
    // Feedforward from input to hidden1
    for (int i = 0; i < hidden1.length; i++) {
      hidden1[i] = 0;
      for (int j = 0; j < input.length; j++) {
        hidden1[i] += input[j] * weightL1[i * input.length + j];
      }
      hidden1[i] += bias1[i];  // Add bias
      hidden1[i] = sigmoid(hidden1[i]);  // Apply activation function
    }

    // Feedforward from hidden1 to hidden2
    for (int i = 0; i < hidden2.length; i++) {
      hidden2[i] = 0;
      for (int j = 0; j < hidden1.length; j++) {
        hidden2[i] += hidden1[j] * weightL2[i * hidden1.length + j];
      }
      hidden2[i] += bias2[i];  // Add bias
      hidden2[i] = sigmoid(hidden2[i]);  // Apply activation function
    }
    
    for (int i = 0; i < hidden3.length; i++) {
      hidden3[i] = 0;
      for (int j = 0; j < hidden2.length; j++) {
        hidden3[i] += hidden2[j] * weightL3[i * hidden2.length + j];
      }
      hidden3[i] += bias3[i];  // Add bias
      hidden3[i] = sigmoid(hidden3[i]);  // Apply activation function
    }

    // Feedforward from hidden2 to output
    for (int i = 0; i < output.length; i++) {
      output[i] = 0;
      for (int j = 0; j < hidden2.length; j++) {
        output[i] += hidden3[j] * weightL4[i * hidden3.length + j];
      }
      output[i] += bias4[i];  // Add bias
      output[i] = sigmoid(output[i]);  // Apply activation function
    }
  }
  
  void mutate(float mutationRate, float mutationAmount) {
  // Mutate weights in the first layer (input to hidden1)
  for (int i = 0; i < weightL1.length; i++) {
    if (random(1) < mutationRate) {  // Random chance to mutate
      weightL1[i] += random(-mutationAmount, mutationAmount);  // Mutate by a small random value
    }
  }

  // Mutate weights in the second layer (hidden1 to hidden2)
  for (int i = 0; i < weightL2.length; i++) {
    if (random(1) < mutationRate) {
      weightL2[i] += random(-mutationAmount, mutationAmount);
    }
  }

  // Mutate weights in the third layer (hidden2 to output)
  for (int i = 0; i < weightL3.length; i++) {
    if (random(1) < mutationRate) {
      weightL3[i] += random(-mutationAmount, mutationAmount);
    }
  }
  
  for (int i = 0; i < weightL4.length; i++) {
    if (random(1) < mutationRate) {
      weightL4[i] += random(-mutationAmount, mutationAmount);
    }
  }

  // Mutate biases in the first hidden layer
  for (int i = 0; i < bias1.length; i++) {
    if (random(1) < mutationRate) {
      bias1[i] += random(-mutationAmount, mutationAmount);
    }
  }

  // Mutate biases in the second hidden layer
  for (int i = 0; i < bias2.length; i++) {
    if (random(1) < mutationRate) {
      bias2[i] += random(-mutationAmount, mutationAmount);
    }
  }

  
  for (int i = 0; i < bias3.length; i++) {
    if (random(1) < mutationRate) {
      bias3[i] += random(-mutationAmount, mutationAmount);
    }
  }
  
  // Mutate biases in the output layer
  for (int i = 0; i < bias4.length; i++) {
    if (random(1) < mutationRate) {
      bias4[i] += random(-mutationAmount, mutationAmount);
    }
  }
}

  // Set input values (to be called from outside the class)
  void setInput(float[] inputValues) {
    for (int i = 0; i < input.length; i++) {
      input[i] = inputValues[i];
    }
  }

  // Set weights (to be called from outside the class)
  // Set weights and biases (to be called from outside the class)
void setWeightsAndBiases(float[] newWeightsL1, float[] newWeightsL2, float[] newWeightsL3,float[] newWeightsL4,
                         float[] newBias1, float[] newBias2, float[] newBias3,float[] newBias4) {
  weightL1 = newWeightsL1;
  weightL2 = newWeightsL2;
  weightL3 = newWeightsL3;
  weightL4 = newWeightsL4;

  bias1 = newBias1;
  bias2 = newBias2;
  bias3 = newBias3;
  bias4 = newBias4;
}


// drawNet is unfinished
  void drawNet(float x, float y, float w, float h) {
    float[] posInputY = new float[input.length];
    float[] posHidden1Y = new float[hidden1.length];
    float[] posHidden2Y = new float[hidden2.length];
    float[] posOutputY = new float[output.length];
    float spacingX = w / 3; // Horizontal spacing between layers

    push();
    translate(x, y);

    // Draw input layer
    for (int i = 0; i < input.length; i++) {
      posInputY[i] = i * (h / input.length);
      ellipse(0, posInputY[i], 10, 10);
    }

    // Draw first hidden layer
    for (int i = 0; i < hidden1.length; i++) {
      posHidden1Y[i] = i * (h / hidden1.length);
      ellipse(spacingX, posHidden1Y[i], 10, 10);
    }

    // Draw second hidden layer
    for (int i = 0; i < hidden2.length; i++) {
      posHidden2Y[i] = i * (h / hidden2.length);
      ellipse(2 * spacingX, posHidden2Y[i], 10, 10);
    }

    // Draw output layer
    for (int i = 0; i < output.length; i++) {
      posOutputY[i] = i * (h / output.length);
      ellipse(3 * spacingX, posOutputY[i], 10, 10);
    }

    // Draw connections from input to first hidden layer
    int weightIndex = 0;
    for (int i = 0; i < input.length; i++) {
      for (int j = 0; j < hidden1.length; j++) {
        strokeWeight(map(abs(weightL1[weightIndex]), 0, 1, 0.5, 3)); // Map weight magnitude to line thickness
        line(0, posInputY[i], spacingX, posHidden1Y[j]);
        weightIndex++;
      }
    }

    // Draw connections from first hidden layer to second hidden layer
    weightIndex = 0;
    for (int i = 0; i < hidden1.length; i++) {
      for (int j = 0; j < hidden2.length; j++) {
        strokeWeight(map(abs(weightL2[weightIndex]), 0, 1, 0.5, 3)); // Adjust thickness based on weightL2
        line(spacingX, posHidden1Y[i], 2 * spacingX, posHidden2Y[j]);
        weightIndex++;
      }
    }

    // Draw connections from second hidden layer to output layer
    weightIndex = 0;
    for (int i = 0; i < hidden2.length; i++) {
      for (int j = 0; j < output.length; j++) {
        strokeWeight(map(abs(weightL3[weightIndex]), 0, 1, 0.5, 3)); // Adjust thickness based on weightL3
        line(2 * spacingX, posHidden2Y[i], 3 * spacingX, posOutputY[j]);
        weightIndex++;
      }
    }

    pop();
  }
}
