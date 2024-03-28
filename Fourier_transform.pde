PImage img;
float[] fourier;
float maxvaluemag = 0; //max value of the magnitude
float save = 0;
float[] fourierTransform(PImage image) {
  int width = image.width;
  int height = image.height;

  // Create an image to store the Fourier transform magnitude
  float result[] = new float[width * height];

  // Loop through each frequency point in the Fourier transform
  for (int u = 0; u < width; u++) {
    print(u);
    for (int v = 0; v < height; v++) {
      float realSum = 0;
      float imagSum = 0;

      // Loop through each pixel in the image
      for (int x = 0; x < width; x++) {
        for (int y = 0; y < height; y++) {
          float intensity = red(image.pixels[x + y * width]); // Get the red channel intensity

          // Compute the contribution of the pixel to the Fourier transform at the given frequency point
          //float angle = -2 * PI * (u * x / (float) width + v * y / (float) height);
          float angle = -2 * PI * ((u - width / 2) * x / (float) width + (v - height / 2) * y / (float) height);
          realSum += intensity * cos(angle);
          imagSum += intensity * sin(angle);
        }
      }

      // Compute the magnitude of the Fourier transform and set it as the pixel intensity in the result image
      float magnitude = sqrt(realSum * realSum + imagSum * imagSum);
      if (magnitude > maxvaluemag) {
        maxvaluemag = magnitude;
      }
      result[u + v * width] = magnitude;
    }
  }
  return result;
}

void setup() {
    size(500,1000);
    colorMode(RGB,255,255,255);
    img = loadImage("tetradon_mbu_juvenile_1bit.png");
    println("compute fourier");
    fourier = fourierTransform(img);
    println("fourier computation done");
}

void draw() {
  image(img, 0, 0);
  loadPixels();
  float c = 255.0 / log(1 + maxvaluemag); //1+maxvaluemag if not normalised
  
  for (int k = 0; k < img.width; k++) {
    for (int l = 0; l < img.height; l++) {
      float magnitude = fourier[k + l * img.width];
      float logMagnitude = c * log(1 + magnitude); // (Apply logarithm for better visualization)
      
      //float logMagnitude = 0;
      //if (magnitude > maxvaluemag/float(100)) { //for threshold vizualisation
      //  logMagnitude = c * log(1 + magnitude); //for threshold vizualisation
      //}
      //colorvalue = 255*fourier[k][l]/maxvaluemag;
      pixels[500*500+img.width*k+l] = color(logMagnitude);
    }  
   }
  updatePixels();
  if (save == 0) {
        save("tetradon_mbu_juvenile_1bit_Fourier_no_threshold.png");
        print("maxvaluemag = " + maxvaluemag + ". ");
        save = 1;
      }
}
//20000 : 3.1003924x10^7, 23500 : 3.1207536x10^7, 30000 : 3.0856536x10^7
//2BITS. 20000 : 3.8026492x10^7, 30000 : 3.6190972x10^7

//Real leopard pattern 1 : 4.5487356x10^7, Dots pattern : 3.1662332x10^7
//Real leopard pattern 2 : 3.3885948x10^7, Dots pattern : 2.5933308x10^7
//Real Tetraodon mbu pattern adult : 4.1006588x10^7, 2nd order: 3.7508092x10^7, 3rd order : 3.1369212x10^7
