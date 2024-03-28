// The equations of the model were proposed by De Gomensoro Malheiros et al. 2020 (https://dl.acm.org/doi/abs/10.1145/3386569.3392478)

final int largeur = 250; //grid width
final int hauteur = 250; //grid height
float a0[][] = new float [hauteur][largeur]; //2D matrix with old a values
float b0[][] = new float [hauteur][largeur]; //2D matrix with new a values
float a1[][] = new float [hauteur][largeur]; //2D matrix with old b values
float b1[][] = new float [hauteur][largeur]; //2D matrix with new b values
final float s = 6; //scaling factor (one of Turing model parameters). default value : 6
final float r = 30;//reaction factor (one of Turing model parameters). default value : 30
float g = 0.00;//growth rate. initial default value : 1.00
final float g1 = 0.05;//final growth rate. default value : 1.05

float d = 1;// Diffusion scaling by growth
float dt = 0.002;//deltatime. default value : 0.006
final float minA = 0;
final float maxA = 4.4;
final float minB = 3.5;
final float maxB = 100;
int t = 0;
int tpicture = 0;


void setup() {
size(250, 500); //canvas size
textSize(12);
//initial state calculation (fixed a value (4), random b value between 4 and 5)
  for (int i = 0; i < hauteur; i++) {
    for (int j = 0; j < largeur; j++) {
      float ainit = 4;
      float binit = 4.5 + random(-0.5, 0.5);
      a0[i][j] = ainit;
      b0[i][j] = binit;

    }
  }

 colorMode(RGB,255,255,255);  //set color mode to RGB
 //colorMode(HSB, 360, 100, 100); //color mode : HSB
}



void update() {
  for (int i = 1; i < hauteur-1; i++) {
    for (int j = 1; j < largeur-1; j++) {

      float oldvaluea = a0[i][j]; //we retrieve the current value of a
      float oldvalueb = b0[i][j]; //we retrieve the current value of b
      

      float laplaceA = 0; // calculation of the Laplacian from the 8 nearest neighbors
      //laplaceA += oldvaluea*(-20/6);
      laplaceA -= oldvaluea*20.00/6.00;
      laplaceA += a0[i+1][j]*4.00/6.00;
      laplaceA += a0[i-1][j]*4.00/6.00;
      laplaceA += a0[i][j+1]*4.00/6.00;
      laplaceA += a0[i][j-1]*4.00/6.00;
      laplaceA += a0[i-1][j-1]*1.00/6.00;
      laplaceA += a0[i+1][j-1]*1.00/6.00;
      laplaceA += a0[i-1][j+1]*1.00/6.00;
      laplaceA += a0[i+1][j+1]*1.00/6.00;

      float laplaceB = 0; // calculation of the Laplacian from the 8 nearest neighbors
      //laplaceB += oldvalueb*(-20/6);
      laplaceB -= oldvalueb*20.00/6.00;
      laplaceB += b0[i+1][j]*4.00/6.00;
      laplaceB += b0[i-1][j]*4.00/6.00;
      laplaceB += b0[i][j+1]*4.00/6.00;
      laplaceB += b0[i][j-1]*4.00/6.00;
      laplaceB += b0[i-1][j-1]*1.00/6.00;
      laplaceB += b0[i+1][j-1]*1.00/6.00;
      laplaceB += b0[i-1][j+1]*1.00/6.00;
      laplaceB += b0[i+1][j+1]*1.00/6.00;

      // calculation of the new value of a and b (Turing model)
      //float newvaluea = oldvaluea + (16 - oldvaluea*oldvalueb + r*s*laplaceA*oldvaluea)*0.0006; //dt=0.006 -> travelling wave
      //float newvalueb = oldvalueb + (oldvaluea*oldvalueb - oldvalueb - 12 + s*laplaceB*oldvalueb)*0.0006; //dt=0.006 -> travelling wave
      float newvaluea = oldvaluea/(1+g*dt) + (16 - oldvaluea*oldvalueb/((1+g*dt)*(1+g*dt)) + d*r*s*laplaceA)*dt; //dt=0.006 -> travelling wave
      float newvalueb = oldvalueb/(1+g*dt) + (oldvaluea*oldvalueb/((1+g*dt)*(1+g*dt)) - oldvalueb/(1+g*dt) - 12 + d*s*laplaceB)*dt; //dt=0.006 -> travelling wave
      
      // bounding new a and b values
      newvaluea = constrain(newvaluea, minA, maxA);
      newvalueb = constrain(newvalueb, minB, maxB);
      a1[i][j] = newvaluea;
      b1[i][j] = newvalueb;
    }
   }
// boundaries calculation
  // left border  
  for (int i = 1; i < hauteur-1; i++) {
    float oldvaluea = a0[i][0]; //we retrieve the current value of a
    float oldvalueb = b0[i][0]; //we retrieve the current value of b
    
    float laplaceA = 0; // calculation of the Laplacian from the 8 nearest neighbors
    //laplaceA += oldvaluea*(-20/6);
    laplaceA -= oldvaluea*20.00/6.00;
    laplaceA += a0[i+1][0]*4.00/6.00;
    laplaceA += a0[i-1][0]*4.00/6.00;
    laplaceA += a0[i][1]*4.00/6.00;
    laplaceA += a0[i][largeur-1]*4.00/6.00;
    laplaceA += a0[i-1][largeur-1]*1.00/6.00;
    laplaceA += a0[i+1][largeur-1]*1.00/6.00;
    laplaceA += a0[i-1][1]*1.00/6.00;
    laplaceA += a0[i+1][1]*1.00/6.00;

    float laplaceB = 0; // calculation of the Laplacian from the 8 nearest neighbors
    //laplaceB += oldvalueb*(-20/6);
    laplaceB -= oldvalueb*20.00/6.00;
    laplaceB += b0[i+1][0]*4.00/6.00;
    laplaceB += b0[i-1][0]*4.00/6.00;
    laplaceB += b0[i][1]*4.00/6.00;
    laplaceB += b0[i][largeur-1]*4.00/6.00;
    laplaceB += b0[i-1][largeur-1]*1.00/6.00;
    laplaceB += b0[i+1][largeur-1]*1.00/6.00;
    laplaceB += b0[i-1][1]*1.00/6.00;
    laplaceB += b0[i+1][1]*1.00/6.00;
    
    // calculation of the new value of a and b (Turing model)
    //float newvaluea = oldvaluea + (16 - oldvaluea*oldvalueb + r*s*laplaceA*oldvaluea)*0.0006; //dt=0.006 -> travelling wave
    //float newvalueb = oldvalueb + (oldvaluea*oldvalueb - oldvalueb - 12 + s*laplaceB*oldvalueb)*0.0006; //dt=0.006 -> travelling wave
    float newvaluea = oldvaluea/(1+g*dt) + (16 - oldvaluea*oldvalueb/((1+g*dt)*(1+g*dt)) + d*r*s*laplaceA)*dt; //dt=0.006 -> travelling wave
    float newvalueb = oldvalueb/(1+g*dt) + (oldvaluea*oldvalueb/((1+g*dt)*(1+g*dt)) - oldvalueb/(1+g*dt) - 12 + d*s*laplaceB)*dt; //dt=0.006 -> travelling wave
    
    // bounding new a and b values
    newvaluea = constrain(newvaluea, minA, maxA);
    newvalueb = constrain(newvalueb, minB, maxB);
    a1[i][0] = newvaluea;
    b1[i][0] = newvalueb;
}
// right border   
  for (int i = 1; i < hauteur-1; i++) {
    float oldvaluea = a0[i][largeur-1]; //we retrieve the current value of a
    float oldvalueb = b0[i][largeur-1]; //we retrieve the current value of b
    
    float laplaceA = 0; // calculation of the Laplacian from the 8 nearest neighbors
    //laplaceA += oldvaluea*(-20/6);
    laplaceA -= oldvaluea*20.00/6.00;
    laplaceA += a0[i+1][largeur-1]*4.00/6.00;
    laplaceA += a0[i-1][largeur-1]*4.00/6.00;
    laplaceA += a0[i][0]*4.00/6.00;
    laplaceA += a0[i][largeur-2]*4.00/6.00;
    laplaceA += a0[i-1][largeur-2]*1.00/6.00;
    laplaceA += a0[i+1][largeur-2]*1.00/6.00;
    laplaceA += a0[i-1][0]*1.00/6.00;
    laplaceA += a0[i+1][0]*1.00/6.00;

    float laplaceB = 0; // calculation of the Laplacian from the 8 nearest neighbors
    //laplaceB += oldvalueb*(-20/6);
    laplaceB -= oldvalueb*20.00/6.00;
    laplaceB += b0[i+1][largeur-1]*4.00/6.00;
    laplaceB += b0[i-1][largeur-1]*4.00/6.00;
    laplaceB += b0[i][0]*4.00/6.00;
    laplaceB += b0[i][largeur-2]*4.00/6.00;
    laplaceB += b0[i-1][largeur-2]*1.00/6.00;
    laplaceB += b0[i+1][largeur-2]*1.00/6.00;
    laplaceB += b0[i-1][0]*1.00/6.00;
    laplaceB += b0[i+1][0]*1.00/6.00;
    
    // calculation of the new value of a and b (Turing model)
    //float newvaluea = oldvaluea + (16 - oldvaluea*oldvalueb + r*s*laplaceA*oldvaluea)*0.0006; //dt=0.006 -> travelling wave
    //float newvalueb = oldvalueb + (oldvaluea*oldvalueb - oldvalueb - 12 + s*laplaceB*oldvalueb)*0.0006; //dt=0.006 -> travelling wave
    float newvaluea = oldvaluea/(1+g*dt) + (16 - oldvaluea*oldvalueb/((1+g*dt)*(1+g*dt)) + d*r*s*laplaceA)*dt; //dt=0.006 -> travelling wave
    float newvalueb = oldvalueb/(1+g*dt) + (oldvaluea*oldvalueb/((1+g*dt)*(1+g*dt)) - oldvalueb/(1+g*dt) - 12 + d*s*laplaceB)*dt; //dt=0.006 -> travelling wave
    
    // bounding new a and b values
    newvaluea = constrain(newvaluea, minA, maxA);
    newvalueb = constrain(newvalueb, minB, maxB);
    a1[i][largeur-1] = newvaluea;
    b1[i][largeur-1] = newvalueb;
   
  }
  //low border
  for (int j = 1; j < largeur-1; j++) {
    float oldvaluea = a0[hauteur-1][j]; //we retrieve the current value of a
    float oldvalueb = b0[hauteur-1][j]; //we retrieve the current value of b
    
    float laplaceA = 0; // calculation of the Laplacian from the 8 nearest neighbors
    //laplaceA += oldvaluea*(-20/6);
    laplaceA -= oldvaluea*20.00/6.00;
    laplaceA += a0[0][j]*4.00/6.00;
    laplaceA += a0[hauteur-2][j]*4.00/6.00;
    laplaceA += a0[hauteur-1][j+1]*4.00/6.00;
    laplaceA += a0[hauteur-1][j-1]*4.00/6.00;
    laplaceA += a0[hauteur-2][j-1]*1.00/6.00;
    laplaceA += a0[0][j-1]*1.00/6.00;
    laplaceA += a0[hauteur-2][j+1]*1.00/6.00;
    laplaceA += a0[0][j+1]*1.00/6.00;

    float laplaceB = 0; // calculation of the Laplacian from the 8 nearest neighbors
    //laplaceB += oldvalueb*(-20/6);
    laplaceB -= oldvalueb*20.00/6.00;
    laplaceB += b0[0][j]*4.00/6.00;
    laplaceB += b0[hauteur-2][j]*4.00/6.00;
    laplaceB += b0[hauteur-1][j+1]*4.00/6.00;
    laplaceB += b0[hauteur-1][j-1]*4.00/6.00;
    laplaceB += b0[hauteur-2][j-1]*1.00/6.00;
    laplaceB += b0[0][j-1]*1.00/6.00;
    laplaceB += b0[hauteur-2][j+1]*1.00/6.00;
    laplaceB += b0[0][j+1]*1.00/6.00;

    // calculation of the new value of a and b (Turing model)
    //float newvaluea = oldvaluea + (16 - oldvaluea*oldvalueb + r*s*laplaceA*oldvaluea)*0.0006; //dt=0.006 -> travelling wave
    //float newvalueb = oldvalueb + (oldvaluea*oldvalueb - oldvalueb - 12 + s*laplaceB*oldvalueb)*0.0006; //dt=0.006 -> travelling wave
    float newvaluea = oldvaluea/(1+g*dt) + (16 - oldvaluea*oldvalueb/((1+g*dt)*(1+g*dt)) + d*r*s*laplaceA)*dt; //dt=0.006 -> travelling wave
    float newvalueb = oldvalueb/(1+g*dt) + (oldvaluea*oldvalueb/((1+g*dt)*(1+g*dt)) - oldvalueb/(1+g*dt) - 12 + d*s*laplaceB)*dt; //dt=0.006 -> travelling wave
    
    // bounding new a and b values
    newvaluea = constrain(newvaluea, minA, maxA);
    newvalueb = constrain(newvalueb, minB, maxB);
    a1[hauteur-1][j] = newvaluea;
    b1[hauteur-1][j] = newvalueb;
  }
  
  //up border
  for (int j = 1; j < largeur-1; j++) {
    float oldvaluea = a0[0][j]; //we retrieve the current value of a
    float oldvalueb = b0[0][j]; //we retrieve the current value of b
    
    float laplaceA = 0; // calculation of the Laplacian from the 8 nearest neighbors
    //laplaceA += oldvaluea*(-20/6);
    laplaceA -= oldvaluea*20.00/6.00;
    laplaceA += a0[1][j]*4.00/6.00;
    laplaceA += a0[hauteur-1][j]*4.00/6.00;
    laplaceA += a0[0][j+1]*4.00/6.00;
    laplaceA += a0[0][j-1]*4.00/6.00;
    laplaceA += a0[hauteur-1][j-1]*1.00/6.00;
    laplaceA += a0[1][j-1]*1.00/6.00;
    laplaceA += a0[hauteur-1][j+1]*1.00/6.00;
    laplaceA += a0[1][j+1]*1.00/6.00;

    float laplaceB = 0; // calculation of the Laplacian from the 8 nearest neighbors
    //laplaceB += oldvalueb*(-20/6);
    laplaceB -= oldvalueb*20.00/6.00;
    laplaceB += b0[1][j]*4.00/6.00;
    laplaceB += b0[hauteur-1][j]*4.00/6.00;
    laplaceB += b0[0][j+1]*4.00/6.00;
    laplaceB += b0[0][j-1]*4.00/6.00;
    laplaceB += b0[hauteur-1][j-1]*1.00/6.00;
    laplaceB += b0[1][j-1]*1.00/6.00;
    laplaceB += b0[hauteur-1][j+1]*1.00/6.00;
    laplaceB += b0[1][j+1]*1.00/6.00;

    // calculation of the new value of a and b (Turing model)
    //float newvaluea = oldvaluea + (16 - oldvaluea*oldvalueb + r*s*laplaceA*oldvaluea)*0.0006; //dt=0.006 -> travelling wave
    //float newvalueb = oldvalueb + (oldvaluea*oldvalueb - oldvalueb - 12 + s*laplaceB*oldvalueb)*0.0006; //dt=0.006 -> travelling wave
    float newvaluea = oldvaluea/(1+g*dt) + (16 - oldvaluea*oldvalueb/((1+g*dt)*(1+g*dt)) + d*r*s*laplaceA)*dt; //dt=0.006 -> travelling wave
    float newvalueb = oldvalueb/(1+g*dt) + (oldvaluea*oldvalueb/((1+g*dt)*(1+g*dt)) - oldvalueb/(1+g*dt) - 12 + d*s*laplaceB)*dt; //dt=0.006 -> travelling wave
    
    // bounding new a and b values
    newvaluea = constrain(newvaluea, minA, maxA);
    newvalueb = constrain(newvalueb, minB, maxB);
    a1[0][j] = newvaluea;
    b1[0][j] = newvalueb;
  }

  
//corner calculation 0,0
float oldvaluea = a0[0][0]; //we retrieve the current value of a
float oldvalueb = b0[0][0]; //we retrieve the current value of b

float laplaceA = 0; // calculation of the Laplacian from the 8 nearest neighbors
//laplaceA += oldvaluea*(-20/6);
laplaceA -= oldvaluea*20.00/6.00;
laplaceA += a0[0][1]*4.00/6.00;
laplaceA += a0[1][0]*4.00/6.00;
laplaceA += a0[hauteur-1][0]*4.00/6.00;
laplaceA += a0[0][largeur-1]*4.00/6.00;
laplaceA += a0[1][1]*1.00/6.00;
laplaceA += a0[hauteur-1][1]*1.00/6.00;
laplaceA += a0[1][largeur-1]*1.00/6.00;
laplaceA += a0[hauteur-1][largeur-1]*1.00/6.00;

float laplaceB = 0; // calculation of the Laplacian from the 8 nearest neighbors
//laplaceB += oldvalueb*(-20/6);
laplaceB -= oldvalueb*20.00/6.00;
laplaceB += b0[0][1]*4.00/6.00;
laplaceB += b0[1][0]*4.00/6.00;
laplaceB += b0[hauteur-1][0]*4.00/6.00;
laplaceB += b0[0][largeur-1]*4.00/6.00;
laplaceB += b0[1][1]*1.00/6.00;
laplaceB += b0[hauteur-1][1]*1.00/6.00;
laplaceB += b0[1][largeur-1]*1.00/6.00;
laplaceB += b0[hauteur-1][largeur-1]*1.00/6.00;

// calculation of the new value of a and b (Turing model)
//float newvaluea = oldvaluea + (16 - oldvaluea*oldvalueb + r*s*laplaceA*oldvaluea)*0.0006; //dt=0.006 -> travelling wave
//float newvalueb = oldvalueb + (oldvaluea*oldvalueb - oldvalueb - 12 + s*laplaceB*oldvalueb)*0.0006; //dt=0.006 -> travelling wave
    float newvaluea = oldvaluea/(1+g*dt) + (16 - oldvaluea*oldvalueb/((1+g*dt)*(1+g*dt)) + d*r*s*laplaceA)*dt; //dt=0.006 -> travelling wave
    float newvalueb = oldvalueb/(1+g*dt) + (oldvaluea*oldvalueb/((1+g*dt)*(1+g*dt)) - oldvalueb/(1+g*dt) - 12 + d*s*laplaceB)*dt; //dt=0.006 -> travelling wave

// bounding new a and b values
newvaluea = constrain(newvaluea, minA, maxA);
newvalueb = constrain(newvalueb, minB, maxB);
a1[0][0] = newvaluea;
b1[0][0] = newvalueb;

//corner calculation height-1,width-1

oldvaluea = a0[hauteur-1][largeur-1]; //we retrieve the current value of a
oldvalueb = b0[hauteur-1][largeur-1]; //we retrieve the current value of b

laplaceA = 0; // calculation of the Laplacian from the 8 nearest neighbors
//laplaceA += oldvaluea*(-20/6);
laplaceA -= oldvaluea*20.00/6.00;
laplaceA += a0[0][largeur-1]*4.00/6.00;
laplaceA += a0[hauteur-1][0]*4.00/6.00;
laplaceA += a0[hauteur-1][largeur-2]*4.00/6.00;
laplaceA += a0[hauteur-2][largeur-1]*4.00/6.00;
laplaceA += a0[0][0]*1.00/6.00;
laplaceA += a0[hauteur-2][largeur-2]*1.00/6.00;
laplaceA += a0[hauteur-2][0]*1.00/6.00;
laplaceA += a0[0][largeur-2]*1.00/6.00;

laplaceB = 0; // calculation of the Laplacian from the 8 nearest neighbors
//laplaceB += oldvalueb*(-20/6);
laplaceB -= oldvalueb*20.00/6.00;
laplaceB += b0[0][largeur-1]*4.00/6.00;
laplaceB += b0[hauteur-1][0]*4.00/6.00;
laplaceB += b0[hauteur-1][largeur-2]*4.00/6.00;
laplaceB += b0[hauteur-2][largeur-1]*4.00/6.00;
laplaceB += b0[0][0]*1.00/6.00;
laplaceB += b0[hauteur-2][largeur-2]*1.00/6.00;
laplaceB += b0[hauteur-2][0]*1.00/6.00;
laplaceB += b0[0][largeur-2]*1.00/6.00;

// calculation of the new value of a and b (Turing model)
//float newvaluea = oldvaluea + (16 - oldvaluea*oldvalueb + r*s*laplaceA*oldvaluea)*0.0006; //dt=0.006 -> travelling wave
//float newvalueb = oldvalueb + (oldvaluea*oldvalueb - oldvalueb - 12 + s*laplaceB*oldvalueb)*0.0006; //dt=0.006 -> travelling wave
newvaluea = oldvaluea/(1+g*dt) + (16 - oldvaluea*oldvalueb/((1+g*dt)*(1+g*dt)) + d*r*s*laplaceA)*dt; //dt=0.006 -> travelling wave
newvalueb = oldvalueb/(1+g*dt) + (oldvaluea*oldvalueb/((1+g*dt)*(1+g*dt)) - oldvalueb/(1+g*dt) - 12 + d*s*laplaceB)*dt; //dt=0.006 -> travelling wave

// bounding new a and b values
newvaluea = constrain(newvaluea, minA, maxA);
newvalueb = constrain(newvalueb, minB, maxB);
a1[hauteur-1][largeur-1] = newvaluea;
b1[hauteur-1][largeur-1] = newvalueb;

//corner calculation 0,width-1

oldvaluea = a0[0][largeur-1]; //we retrieve the current value of a
oldvalueb = b0[0][largeur-1]; //we retrieve the current value of b

laplaceA = 0; // calculation of the Laplacian from the 8 nearest neighbors
//laplaceA += oldvaluea*(-20/6);
laplaceA -= oldvaluea*20.00/6.00;
laplaceA += a0[0][0]*4.00/6.00;
laplaceA += a0[0][largeur-2]*4.00/6.00;
laplaceA += a0[1][largeur-1]*4.00/6.00;
laplaceA += a0[hauteur-1][largeur-1]*4.00/6.00;
laplaceA += a0[1][0]*1.00/6.00;
laplaceA += a0[hauteur-1][largeur-2]*1.00/6.00;
laplaceA += a0[hauteur-1][0]*1.00/6.00;
laplaceA += a0[1][largeur-2]*1.00/6.00;

laplaceB = 0; // calculation of the Laplacian from the 8 nearest neighbors
//laplaceB += oldvalueb*(-20/6);
laplaceB -= oldvalueb*20.00/6.00;
laplaceB += b0[0][0]*4.00/6.00;
laplaceB += b0[0][largeur-2]*4.00/6.00;
laplaceB += b0[1][largeur-1]*4.00/6.00;
laplaceB += b0[hauteur-1][largeur-1]*4.00/6.00;
laplaceB += b0[1][0]*1.00/6.00;
laplaceB += b0[hauteur-1][largeur-2]*1.00/6.00;
laplaceB += b0[hauteur-1][0]*1.00/6.00;
laplaceB += b0[1][largeur-2]*1.00/6.00;

// calculation of the new value of a and b (Turing model)
//float newvaluea = oldvaluea + (16 - oldvaluea*oldvalueb + r*s*laplaceA*oldvaluea)*0.0006; //dt=0.006 -> travelling wave
//float newvalueb = oldvalueb + (oldvaluea*oldvalueb - oldvalueb - 12 + s*laplaceB*oldvalueb)*0.0006; //dt=0.006 -> travelling wave
newvaluea = oldvaluea/(1+g*dt) + (16 - oldvaluea*oldvalueb/((1+g*dt)*(1+g*dt)) + d*r*s*laplaceA)*dt; //dt=0.006 -> travelling wave
newvalueb = oldvalueb/(1+g*dt) + (oldvaluea*oldvalueb/((1+g*dt)*(1+g*dt)) - oldvalueb/(1+g*dt) - 12 + d*s*laplaceB)*dt; //dt=0.006 -> travelling wave

// bounding new a and b values
newvaluea = constrain(newvaluea, minA, maxA);
newvalueb = constrain(newvalueb, minB, maxB);
a1[0][largeur-1] = newvaluea;
b1[0][largeur-1] = newvalueb;

//corner calculation height-1,0

oldvaluea = a0[hauteur-1][0]; //we retrieve the current value of a
oldvalueb = b0[hauteur-1][0]; //we retrieve the current value of b

laplaceA = 0; // calculation of the Laplacian from the 8 nearest neighbors
//laplaceA += oldvaluea*(-20/6);
laplaceA -= oldvaluea*20.00/6.00;
laplaceA += a0[hauteur-1][1]*4.00/6.00;
laplaceA += a0[hauteur-1][largeur-1]*4.00/6.00;
laplaceA += a0[0][0]*4.00/6.00;
laplaceA += a0[hauteur-2][0]*4.00/6.00;
laplaceA += a0[0][1]*1.00/6.00;
laplaceA += a0[hauteur-1][1]*1.00/6.00;
laplaceA += a0[0][largeur-1]*1.00/6.00;
laplaceA += a0[hauteur-2][largeur-1]*1.00/6.00;

laplaceB = 0; // calculation of the Laplacian from the 8 nearest neighbors
//laplaceB += oldvalueb*(-20/6);
laplaceB -= oldvalueb*20.00/6.00;
laplaceB += b0[hauteur-1][1]*4.00/6.00;
laplaceB += b0[hauteur-1][largeur-1]*4.00/6.00;
laplaceB += b0[0][0]*4.00/6.00;
laplaceB += b0[hauteur-2][0]*4.00/6.00;
laplaceB += b0[0][1]*1.00/6.00;
laplaceB += b0[hauteur-1][1]*1.00/6.00;
laplaceB += b0[0][largeur-1]*1.00/6.00;
laplaceB += b0[hauteur-2][largeur-1]*1.00/6.00;

// calculation of the new value of a and b (Turing model)
//float newvaluea = oldvaluea + (16 - oldvaluea*oldvalueb + r*s*laplaceA*oldvaluea)*0.0006; //dt=0.006 -> travelling wave
//float newvalueb = oldvalueb + (oldvaluea*oldvalueb - oldvalueb - 12 + s*laplaceB*oldvalueb)*0.0006; //dt=0.006 -> travelling wave
newvaluea = oldvaluea/(1+g*dt) + (16 - oldvaluea*oldvalueb/((1+g*dt)*(1+g*dt)) + d*r*s*laplaceA)*dt; //dt=0.006 -> travelling wave
newvalueb = oldvalueb/(1+g*dt) + (oldvaluea*oldvalueb/((1+g*dt)*(1+g*dt)) - oldvalueb/(1+g*dt) - 12 + d*s*laplaceB)*dt; //dt=0.006 -> travelling wave

// bounding new a and b values
newvaluea = constrain(newvaluea, minA, maxA);
newvalueb = constrain(newvalueb, minB, maxB);
a1[hauteur-1][0] = newvaluea;
b1[hauteur-1][0] = newvalueb;

//copy of a1 and b1 in a0 and b0
arrayCopy(a1,a0);
arrayCopy(b1,b0);

}

void draw() {
  //println(frameRate);
  background(255);
  update();
  
  d = constrain(d,0.1,1); //implementing indirect exponential growth
  t = t+1;
  tpicture = tpicture+1;
  print(d + "  ");
  print(t + "  ");
  //println(a0[100][100] + "    " + b0[100][100]);

  loadPixels();
  for (int i = 0; i < hauteur-1; i++) {
    for (int j = 0; j < largeur-1; j++) {
      //float pixelcolora = a0[i][j];
      float pixelcolorb = b0[i][j];
      int pos = j + i * largeur;
      pixels[pos] = color(255-116/10*pixelcolorb, 215-146/10*pixelcolorb, 19/10*pixelcolorb);//color between yellow and brown
      //pixels[pos] = color(pixelcolorb/100*360, 80, 80);
      //pixels[pos] = color(pixelcolorb*36, 80, 80);
  }
  }
  
    // draw the graph of a0 and b0 values corresponding to the medial horizontal slice -> a[125][i]
  for (int k = 0; k < largeur-1; k++) {
    // entre 0 et 5
    int pos2 = round((b0[125][k]+1)*250/105);
    int pos3 = (500-pos2)*largeur + k;
    pixels[pos3] = color (255,0,0);
  }
  
  for (int k = 0; k < largeur-1; k++) {
    // entre 0 et 5
    int pos2 = round((a0[125][k]+1)*250/6);
    int pos3 = (500-pos2)*largeur + k;
    pixels[pos3] = color (0,255,0);
  }
  
   for (int l = 0; l < largeur-1; l++) {
     pixels[275*250+l] = color (0,0,0);
     pixels[458*250+l] = color (0,0,0);
   }
  
  updatePixels();
  text("t = " + str(t), 0, 300);
  text("g = " + str(g), 0, 312);
  text("s = " + str(s), 0, 324);
  text("r = " + str(r), 0, 336);
  text("d = " + str(d), 0, 348);
  text("dt = " + str(dt), 0, 360);
  text("picture = " + str(tpicture), 0, 372);
  fill(0,0,0);
  if (t == 1) {
    save("THEORETICAL values g=0.05 t = 1.png");
  }

  if (tpicture == 250) {
    if (t <= 100001) {
    save("THEORETICAL values g=0.05 t = " + str(t) + ".png");
    tpicture = 0;
    }
  }
  
  
    if (t > 10000) {
      d = d/((1+g*dt)*(1+g*dt)); //implementing indirect exponential growth
      g = g1; //implementing growth rate
      }
        
}
