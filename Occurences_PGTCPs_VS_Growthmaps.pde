PImage img;

//number of segments
final int segment_number = 22;

//array of lists which contains every pixel position for a given color
IntList[] segment_pixels_positions = new IntList[segment_number];

color[] segmentcolors = new color[segment_number];
color pixelcolor;
FloatList growthfactor = new FloatList(segment_number);



void setup() {
  
// setting the color mode to RGB 
colorMode(RGB,255,255,255);

//// Adult - 1st stage setting the growthfactor values (between 0 and 1) 
//growthfactor.append(0.36);
//growthfactor.append(0.056);
//growthfactor.append(0.066);
//growthfactor.append(0.14);
//growthfactor.append(0.145);
//growthfactor.append(0.22);
//growthfactor.append(0.14);
//growthfactor.append(0.86);
//growthfactor.append(0.67);
//growthfactor.append(0);
//growthfactor.append(0.65);
//growthfactor.append(0.065);
//growthfactor.append(0.23);
//growthfactor.append(0.45);
//growthfactor.append(0.47);
//growthfactor.append(0.64);
//growthfactor.append(0.65);
//growthfactor.append(1);
//growthfactor.append(0.38);
//growthfactor.append(0.52);
//growthfactor.append(0.54);
//growthfactor.append(0.34);

//Adult - 1st stage (sigmoid correction for the color code)
//growthfactor.append(0.21);
//growthfactor.append(0.011);
//growthfactor.append(0.013);
//growthfactor.append(0.025);
//growthfactor.append(0.027);
//growthfactor.append(0.056);
//growthfactor.append(0.026);
//growthfactor.append(0.97);
//growthfactor.append(0.86);
//growthfactor.append(0);
//growthfactor.append(0.83);
//growthfactor.append(0.012);
//growthfactor.append(0.07);
//growthfactor.append(0.38);
//growthfactor.append(0.43);
//growthfactor.append(0.81);
//growthfactor.append(0.83);
//growthfactor.append(1);
//growthfactor.append(0.22);
//growthfactor.append(0.56);
//growthfactor.append(0.60);
//growthfactor.append(0.17);

//Adult - 2nd stage (sigmoid correction for the color code)
growthfactor.append(0.58);
growthfactor.append(0.006);
growthfactor.append(0.009);
growthfactor.append(0.031);
growthfactor.append(0.019);
growthfactor.append(0.053);
growthfactor.append(0.97);
growthfactor.append(0.88);
growthfactor.append(0.60);
growthfactor.append(0.016);
growthfactor.append(0.194);
growthfactor.append(0.017);
growthfactor.append(0.016);
growthfactor.append(0.268);
growthfactor.append(0.44);
growthfactor.append(0.895);
growthfactor.append(0.992);
growthfactor.append(0.608);
growthfactor.append(0.993);
growthfactor.append(0.051);
growthfactor.append(0.990);
growthfactor.append(0.178);


//initialisation  segment_pixels_positions[a]
for (int a = 0; a < segment_number; a++) {
  segment_pixels_positions[a] = new IntList() ;
}

//setting the segment colors from dark grey (10, 10, 10) to light gray (230, 230, 230)
for (int i = 0; i < segment_number; i++) {
  segmentcolors[i] = color(10+i*10, 10+i*10, 10+i*10);
}

size(500, 334); //taille du canevas
img = loadImage("zebre nuances de gris sans couleur 5.png");
image(img, 0, 0);


loadPixels();

color black = color(0, 0, 0);
color white = color(255, 255, 255);
color pixelcolor;
color segmentcolor;

for (int k = 0; k < pixels.length; k++) {
  if (pixels[k] != black && pixels[k] != white) {
    for (int l = 0; l < segment_number; l++) {
      segmentcolor = segmentcolors[l];
      pixelcolor = pixels[k];
      if (pixelcolor == segmentcolor) {
        segment_pixels_positions[l].append(k);
        break;
      }
    }
  }
}
//print(segment_pixels_positions);

// calcul de la nouvelle couleur de chaque pixel noir
color black2 = color(0, 0, 0);
float distance;
float distancetemp;
float scale;
float pixelgrowthfactor;
int xcoordinate;
int ycoordinate;
int positionpixelsegment;
int xpositionpixelsegment;
int ypositionpixelsegment;


for (int j = 0; j < pixels.length; j++) {
    if (pixels[j] == black2) {
      scale = 0;
      pixelgrowthfactor = 0;
      xcoordinate = j/500;
      ycoordinate = j % 500;
      for (int b = 0; b < segment_number; b++) {
        distance = 100000;
        for (int c = 0; c < segment_pixels_positions[b].size(); c++) {
          positionpixelsegment = segment_pixels_positions[b].get(c);
          xpositionpixelsegment = positionpixelsegment/500;
          ypositionpixelsegment = positionpixelsegment % 500;
          distancetemp = dist(xcoordinate, ycoordinate, xpositionpixelsegment, ypositionpixelsegment);
          if (distancetemp < distance) {
            distance = distancetemp;
          }
        }
        pixelgrowthfactor = pixelgrowthfactor + growthfactor.get(b)/(distance*distance);
        scale = scale + 1.00/(distance*distance);
      }
      pixelgrowthfactor = pixelgrowthfactor/scale;
      pixelcolor = color(60+pixelgrowthfactor*(255-60), pixelgrowthfactor*26, 255*(1-pixelgrowthfactor)); //dark red and blue
      //pixelcolor = color(60+pixelgrowthfactor*(255-60), pixelgrowthfactor*97, 97+157*(1-pixelgrowthfactor)); //light red and blue

      pixels[j] = pixelcolor;
    }
    
}
updatePixels();
save("zebra adult - 2nd stage sigmoid square decrease light red and blue.png");
}

void draw() {




}
