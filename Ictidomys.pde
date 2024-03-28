// Model proposed by De Gomensoro Malheiros et al. 2020 (https://dl.acm.org/doi/abs/10.1145/3386569.3392478)

final int largeur = 250; //largeur de la grille
final int hauteur = 250; //hauteur de la grille
float a0[][] = new float [hauteur][largeur]; //matrice 2D des anciennes valeurs de a
float b0[][] = new float [hauteur][largeur]; //matrice 2D des nouvelles valeurs de a
float a1[][] = new float [hauteur][largeur]; //matrice 2D des anciennes valeurs de b
float b1[][] = new float [hauteur][largeur]; //matrice 2D des nouvelles valeurs de b
final float s = 6; //facteur de scaling (paramètre du modèle de Turing). default value : 3
final float r = 30;//facteur de reaction (paramètre du modèle de Turing). default value : 20
//final float g = 0.0;//growth rate. default value : 

float g = 0.00;//growth rate. initial default value : 0.00
final float g1 = 0.01;//final growth rate. default value : 0.05

float d = 0.3;// Diffusion scaling by growth
float dt = 0.002;//deltatime. default value : 0.006

final float minA = 0;
final float maxA = 4.4;
final float minB = 3.5;
final float maxB = 100;
int t = 0;
final float sigma = 0.05; //écart type loi normale stripes
final float mu = largeur/2; // position central stripe
final float r2 = 0.1;
int tpicture = 0;

void setup() {
size(250, 250); //taille du canevas

//calcul de l'état initial (valeur de a fixe (4), valeur de b aléatoire entre 4 et 5)
  for (int i = 0; i < hauteur; i++) {
    for (int j = 0; j < largeur; j++) {
      float ainit = 4 + random(-0.5, 0.5); 
      float binit = 4.5 + random(-0.5, 0.5); //si pas stripes init
      a0[i][j] = ainit;
      a0[i][j] += 100.00/(sigma*2.50)*exp(-0.5*((j-mu)/sigma*(j-mu)/sigma)); //garder juste ainit pour cond init aléatoires
      a0[i][j] += 100.00/(sigma*2.50)*exp(-0.5*((j-0.2*mu)/sigma*(j-0.2*mu)/sigma));
      a0[i][j] += 100.00/(sigma*2.50)*exp(-0.5*((j-0.4*mu)/sigma*(j-0.4*mu)/sigma));
      a0[i][j] += 100.00/(sigma*2.50)*exp(-0.5*((j-0.6*mu)/sigma*(j-0.6*mu)/sigma));
      a0[i][j] += 100.00/(sigma*2.50)*exp(-0.5*((j-0.8*mu)/sigma*(j-0.8*mu)/sigma));
      a0[i][j] += 100.00/(sigma*2.50)*exp(-0.5*((j-1.2*mu)/sigma*(j-1.2*mu)/sigma));
      a0[i][j] += 100.00/(sigma*2.50)*exp(-0.5*((j-1.4*mu)/sigma*(j-1.4*mu)/sigma));
      a0[i][j] += 100.00/(sigma*2.50)*exp(-0.5*((j-1.6*mu)/sigma*(j-1.6*mu)/sigma));
      a0[i][j] += 100.00/(sigma*2.50)*exp(-0.5*((j-1.8*mu)/sigma*(j-1.8*mu)/sigma));
      
      b0[i][j] = binit;
      b0[i][j] += 100.00/(sigma*2.50)*exp(-0.5*((j-mu)/sigma*(j-mu)/sigma)); //garder juste ainit pour cond init aléatoires
      b0[i][j] += 100.00/(sigma*2.50)*exp(-0.5*((j-0.2*mu)/sigma*(j-0.2*mu)/sigma));
      b0[i][j] += 100.00/(sigma*2.50)*exp(-0.5*((j-0.4*mu)/sigma*(j-0.4*mu)/sigma));
      b0[i][j] += 100.00/(sigma*2.50)*exp(-0.5*((j-0.6*mu)/sigma*(j-0.6*mu)/sigma));
      b0[i][j] += 100.00/(sigma*2.50)*exp(-0.5*((j-0.8*mu)/sigma*(j-0.8*mu)/sigma));
      b0[i][j] += 100.00/(sigma*2.50)*exp(-0.5*((j-1.2*mu)/sigma*(j-1.2*mu)/sigma));
      b0[i][j] += 100.00/(sigma*2.50)*exp(-0.5*((j-1.4*mu)/sigma*(j-1.4*mu)/sigma));
      b0[i][j] += 100.00/(sigma*2.50)*exp(-0.5*((j-1.6*mu)/sigma*(j-1.6*mu)/sigma));
      b0[i][j] += 100.00/(sigma*2.50)*exp(-0.5*((j-1.8*mu)/sigma*(j-1.8*mu)/sigma));
    }
  }

 colorMode(RGB,255,255,255);  //set color mode to RGB
 //colorMode(HSB, 360, 100, 100); //color mode : HSB
}



void update() {
  for (int i = 1; i < hauteur-1; i++) {
    for (int j = 1; j < largeur-1; j++) {

      float oldvaluea = a0[i][j]; //on récupère la valeur actuelle de a
      float oldvalueb = b0[i][j]; //on récupère la valeur actuelle de b
      

      float laplaceA = 0; // calcul du laplacien à partir des 8 voisins les plus proches
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

      float laplaceB = 0; // calcul du laplacien à partir des 8 voisins les plus proches
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

      // calcul de la nouvelle valeur de a et b (modèle de Turing)
      //float newvaluea = oldvaluea + (16 - oldvaluea*oldvalueb + r*s*laplaceA*oldvaluea)*0.0006; //dt=0.006 -> travelling wave
      //float newvalueb = oldvalueb + (oldvaluea*oldvalueb - oldvalueb - 12 + s*laplaceB*oldvalueb)*0.0006; //dt=0.006 -> travelling wave
      float newvaluea = oldvaluea/(1+g*dt) + random(-0.5*r2, 0.5*r2)+ (16 - oldvaluea*oldvalueb/((1+g*dt)*(1+g*dt)) + d*r*s*laplaceA)*dt; //dt=0.006 -> travelling wave
      float newvalueb = oldvalueb/(1+g*dt) + random(-0.5*r2, 0.5*r2)+ (oldvaluea*oldvalueb/((1+g*dt)*(1+g*dt)) - oldvalueb/(1+g*dt) - 12 + d*s*laplaceB)*dt; //dt=0.006 -> travelling wave
       
      // encadrement des nouvelles valeurs de a et b
      newvaluea = constrain(newvaluea, minA, maxA);
      newvalueb = constrain(newvalueb, minB, maxB);
      a1[i][j] = newvaluea;
      b1[i][j] = newvalueb;
    }
   }
// calcul des bords
  // bord gauche   
  for (int i = 1; i < hauteur-1; i++) {
    float oldvaluea = a0[i][0]; //on récupère la valeur actuelle de a
    float oldvalueb = b0[i][0]; //on récupère la valeur actuelle de b
    
    float laplaceA = 0; // calcul du laplacien à partir des 8 voisins les plus proches
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

    float laplaceB = 0; // calcul du laplacien à partir des 8 voisins les plus proches
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
    
    // calcul de la nouvelle valeur de a et b (modèle de Turing)
    //float newvaluea = oldvaluea + (16 - oldvaluea*oldvalueb + r*s*laplaceA*oldvaluea)*0.0006; //dt=0.006 -> travelling wave
    //float newvalueb = oldvalueb + (oldvaluea*oldvalueb - oldvalueb - 12 + s*laplaceB*oldvalueb)*0.0006; //dt=0.006 -> travelling wave
    float newvaluea = oldvaluea/(1+g*dt) + random(-0.5*r2, 0.5*r2)+ (16 - oldvaluea*oldvalueb/((1+g*dt)*(1+g*dt)) + d*r*s*laplaceA)*dt; //dt=0.006 -> travelling wave
    float newvalueb = oldvalueb/(1+g*dt) + random(-0.5*r2, 0.5*r2)+ (oldvaluea*oldvalueb/((1+g*dt)*(1+g*dt)) - oldvalueb/(1+g*dt) - 12 + d*s*laplaceB)*dt; //dt=0.006 -> travelling wave
       
    // encadrement des nouvelles valeurs de a et b
    newvaluea = constrain(newvaluea, minA, maxA);
    newvalueb = constrain(newvalueb, minB, maxB);
    a1[i][0] = newvaluea;
    b1[i][0] = newvalueb;
}
// bord droit   
  for (int i = 1; i < hauteur-1; i++) {
    float oldvaluea = a0[i][largeur-1]; //on récupère la valeur actuelle de a
    float oldvalueb = b0[i][largeur-1]; //on récupère la valeur actuelle de b
    
    float laplaceA = 0; // calcul du laplacien à partir des 8 voisins les plus proches
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

    float laplaceB = 0; // calcul du laplacien à partir des 8 voisins les plus proches
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
    
    // calcul de la nouvelle valeur de a et b (modèle de Turing)
    //float newvaluea = oldvaluea + (16 - oldvaluea*oldvalueb + r*s*laplaceA*oldvaluea)*0.0006; //dt=0.006 -> travelling wave
    //float newvalueb = oldvalueb + (oldvaluea*oldvalueb - oldvalueb - 12 + s*laplaceB*oldvalueb)*0.0006; //dt=0.006 -> travelling wave
    float newvaluea = oldvaluea/(1+g*dt) + random(-0.5*r2, 0.5*r2)+ (16 - oldvaluea*oldvalueb/((1+g*dt)*(1+g*dt)) + d*r*s*laplaceA)*dt; //dt=0.006 -> travelling wave
    float newvalueb = oldvalueb/(1+g*dt) + random(-0.5*r2, 0.5*r2)+ (oldvaluea*oldvalueb/((1+g*dt)*(1+g*dt)) - oldvalueb/(1+g*dt) - 12 + d*s*laplaceB)*dt; //dt=0.006 -> travelling wave
      
    // encadrement des nouvelles valeurs de a et b
    newvaluea = constrain(newvaluea, minA, maxA);
    newvalueb = constrain(newvalueb, minB, maxB);
    a1[i][largeur-1] = newvaluea;
    b1[i][largeur-1] = newvalueb;
   
  }
  //bord bas
  for (int j = 1; j < largeur-1; j++) {
    float oldvaluea = a0[hauteur-1][j]; //on récupère la valeur actuelle de a
    float oldvalueb = b0[hauteur-1][j]; //on récupère la valeur actuelle de b
    
    float laplaceA = 0; // calcul du laplacien à partir des 8 voisins les plus proches
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

    float laplaceB = 0; // calcul du laplacien à partir des 8 voisins les plus proches
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

    // calcul de la nouvelle valeur de a et b (modèle de Turing)
    //float newvaluea = oldvaluea + (16 - oldvaluea*oldvalueb + r*s*laplaceA*oldvaluea)*0.0006; //dt=0.006 -> travelling wave
    //float newvalueb = oldvalueb + (oldvaluea*oldvalueb - oldvalueb - 12 + s*laplaceB*oldvalueb)*0.0006; //dt=0.006 -> travelling wave
    float newvaluea = oldvaluea/(1+g*dt) + random(-0.5*r2, 0.5*r2)+ (16 - oldvaluea*oldvalueb/((1+g*dt)*(1+g*dt)) + d*r*s*laplaceA)*dt; //dt=0.006 -> travelling wave
    float newvalueb = oldvalueb/(1+g*dt) + random(-0.5*r2, 0.5*r2)+ (oldvaluea*oldvalueb/((1+g*dt)*(1+g*dt)) - oldvalueb/(1+g*dt) - 12 + d*s*laplaceB)*dt; //dt=0.006 -> travelling wave
     
    // encadrement des nouvelles valeurs de a et b
    newvaluea = constrain(newvaluea, minA, maxA);
    newvalueb = constrain(newvalueb, minB, maxB);
    a1[hauteur-1][j] = newvaluea;
    b1[hauteur-1][j] = newvalueb;
  }
  
  //bord haut
  for (int j = 1; j < largeur-1; j++) {
    float oldvaluea = a0[0][j]; //on récupère la valeur actuelle de a
    float oldvalueb = b0[0][j]; //on récupère la valeur actuelle de b
    
    float laplaceA = 0; // calcul du laplacien à partir des 8 voisins les plus proches
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

    float laplaceB = 0; // calcul du laplacien à partir des 8 voisins les plus proches
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

    // calcul de la nouvelle valeur de a et b (modèle de Turing)
    //float newvaluea = oldvaluea + (16 - oldvaluea*oldvalueb + r*s*laplaceA*oldvaluea)*0.0006; //dt=0.006 -> travelling wave
    //float newvalueb = oldvalueb + (oldvaluea*oldvalueb - oldvalueb - 12 + s*laplaceB*oldvalueb)*0.0006; //dt=0.006 -> travelling wave
    float newvaluea = oldvaluea/(1+g*dt) + random(-0.5*r2, 0.5*r2)+ (16 - oldvaluea*oldvalueb/((1+g*dt)*(1+g*dt)) + d*r*s*laplaceA)*dt; //dt=0.006 -> travelling wave
    float newvalueb = oldvalueb/(1+g*dt) + random(-0.5*r2, 0.5*r2)+ (oldvaluea*oldvalueb/((1+g*dt)*(1+g*dt)) - oldvalueb/(1+g*dt) - 12 + d*s*laplaceB)*dt; //dt=0.006 -> travelling wave
    
    // encadrement des nouvelles valeurs de a et b
    newvaluea = constrain(newvaluea, minA, maxA);
    newvalueb = constrain(newvalueb, minB, maxB);
    a1[0][j] = newvaluea;
    b1[0][j] = newvalueb;
  }

  
//calcul du coin 0,0
float oldvaluea = a0[0][0]; //on récupère la valeur actuelle de a
float oldvalueb = b0[0][0]; //on récupère la valeur actuelle de b

float laplaceA = 0; // calcul du laplacien à partir des 8 voisins les plus proches
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

float laplaceB = 0; // calcul du laplacien à partir des 8 voisins les plus proches
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

// calcul de la nouvelle valeur de a et b (modèle de Turing)
//float newvaluea = oldvaluea + (16 - oldvaluea*oldvalueb + r*s*laplaceA*oldvaluea)*0.0006; //dt=0.006 -> travelling wave
//float newvalueb = oldvalueb + (oldvaluea*oldvalueb - oldvalueb - 12 + s*laplaceB*oldvalueb)*0.0006; //dt=0.006 -> travelling wave
    float newvaluea = oldvaluea/(1+g*dt) + random(-0.5*r2, 0.5*r2)+ (16 - oldvaluea*oldvalueb/((1+g*dt)*(1+g*dt)) + d*r*s*laplaceA)*dt; //dt=0.006 -> travelling wave
    float newvalueb = oldvalueb/(1+g*dt) + random(-0.5*r2, 0.5*r2)+ (oldvaluea*oldvalueb/((1+g*dt)*(1+g*dt)) - oldvalueb/(1+g*dt) - 12 + d*s*laplaceB)*dt; //dt=0.006 -> travelling wave

// encadrement des nouvelles valeurs de a et b
newvaluea = constrain(newvaluea, minA, maxA);
newvalueb = constrain(newvalueb, minB, maxB);
a1[0][0] = newvaluea;
b1[0][0] = newvalueb;

//calcul du coin hauteur-1,largeur-1

oldvaluea = a0[hauteur-1][largeur-1]; //on récupère la valeur actuelle de a
oldvalueb = b0[hauteur-1][largeur-1]; //on récupère la valeur actuelle de b

laplaceA = 0; // calcul du laplacien à partir des 8 voisins les plus proches
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

laplaceB = 0; // calcul du laplacien à partir des 8 voisins les plus proches
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

// calcul de la nouvelle valeur de a et b (modèle de Turing)
//float newvaluea = oldvaluea + (16 - oldvaluea*oldvalueb + r*s*laplaceA*oldvaluea)*0.0006; //dt=0.006 -> travelling wave
//float newvalueb = oldvalueb + (oldvaluea*oldvalueb - oldvalueb - 12 + s*laplaceB*oldvalueb)*0.0006; //dt=0.006 -> travelling wave
newvaluea = oldvaluea/(1+g*dt) + random(-0.5*r2, 0.5*r2)+ (16 - oldvaluea*oldvalueb/((1+g*dt)*(1+g*dt)) + d*r*s*laplaceA)*dt; //dt=0.006 -> travelling wave
newvalueb = oldvalueb/(1+g*dt) + random(-0.5*r2, 0.5*r2)+ (oldvaluea*oldvalueb/((1+g*dt)*(1+g*dt)) - oldvalueb/(1+g*dt) - 12 + d*s*laplaceB)*dt; //dt=0.006 -> travelling wave

// encadrement des nouvelles valeurs de a et b
newvaluea = constrain(newvaluea, minA, maxA);
newvalueb = constrain(newvalueb, minB, maxB);
a1[hauteur-1][largeur-1] = newvaluea;
b1[hauteur-1][largeur-1] = newvalueb;

//calcul du coin 0,largeur-1

oldvaluea = a0[0][largeur-1]; //on récupère la valeur actuelle de a
oldvalueb = b0[0][largeur-1]; //on récupère la valeur actuelle de b

laplaceA = 0; // calcul du laplacien à partir des 8 voisins les plus proches
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

laplaceB = 0; // calcul du laplacien à partir des 8 voisins les plus proches
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

// calcul de la nouvelle valeur de a et b (modèle de Turing)
//float newvaluea = oldvaluea + (16 - oldvaluea*oldvalueb + r*s*laplaceA*oldvaluea)*0.0006; //dt=0.006 -> travelling wave
//float newvalueb = oldvalueb + (oldvaluea*oldvalueb - oldvalueb - 12 + s*laplaceB*oldvalueb)*0.0006; //dt=0.006 -> travelling wave
newvaluea = oldvaluea/(1+g*dt) + random(-0.5*r2, 0.5*r2)+ (16 - oldvaluea*oldvalueb/((1+g*dt)*(1+g*dt)) + d*r*s*laplaceA)*dt; //dt=0.006 -> travelling wave
newvalueb = oldvalueb/(1+g*dt) + random(-0.5*r2, 0.5*r2)+ (oldvaluea*oldvalueb/((1+g*dt)*(1+g*dt)) - oldvalueb/(1+g*dt) - 12 + d*s*laplaceB)*dt; //dt=0.006 -> travelling wave

// encadrement des nouvelles valeurs de a et b
newvaluea = constrain(newvaluea, minA, maxA);
newvalueb = constrain(newvalueb, minB, maxB);
a1[0][largeur-1] = newvaluea;
b1[0][largeur-1] = newvalueb;

//calcul du coin hauteur-1,0

oldvaluea = a0[hauteur-1][0]; //on récupère la valeur actuelle de a
oldvalueb = b0[hauteur-1][0]; //on récupère la valeur actuelle de b

laplaceA = 0; // calcul du laplacien à partir des 8 voisins les plus proches
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

laplaceB = 0; // calcul du laplacien à partir des 8 voisins les plus proches
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

// calcul de la nouvelle valeur de a et b (modèle de Turing)
//float newvaluea = oldvaluea + (16 - oldvaluea*oldvalueb + r*s*laplaceA*oldvaluea)*0.0006; //dt=0.006 -> travelling wave
//float newvalueb = oldvalueb + (oldvaluea*oldvalueb - oldvalueb - 12 + s*laplaceB*oldvalueb)*0.0006; //dt=0.006 -> travelling wave
newvaluea = oldvaluea/(1+g*dt) + random(-0.5*r2, 0.5*r2)+ (16 - oldvaluea*oldvalueb/((1+g*dt)*(1+g*dt)) + d*r*s*laplaceA)*dt; //dt=0.006 -> travelling wave
newvalueb = oldvalueb/(1+g*dt) + random(-0.5*r2, 0.5*r2)+ (oldvaluea*oldvalueb/((1+g*dt)*(1+g*dt)) - oldvalueb/(1+g*dt) - 12 + d*s*laplaceB)*dt; //dt=0.006 -> travelling wave

// encadrement des nouvelles valeurs de a et b
newvaluea = constrain(newvaluea, minA, maxA);
newvalueb = constrain(newvalueb, minB, maxB);
a1[hauteur-1][0] = newvaluea;
b1[hauteur-1][0] = newvalueb;

//copie de a1 et b1 dans a0 et b0
arrayCopy(a1,a0);
arrayCopy(b1,b0);

}

void draw() {
  //println(frameRate);
  update();
  
  t = t+1;
  tpicture = tpicture+1;
  //print(d);
  //println(a0[100][100] + "    " + b0[100][100]);


  loadPixels();
  for (int i = 0; i < hauteur-1; i++) {
    for (int j = 0; j < largeur-1; j++) {
      //float pixelcolora = a0[i][j];
      float pixelcolorb = b0[i][j]-3.5;
      int pos = j + i * largeur;
      //pixels[pos] = color(247-198/7*pixelcolorb, 208-167/7*pixelcolorb, 122-98/7*pixelcolorb);//color between yellow and brown
      pixels[pos] = color(56+199/7*pixelcolorb, 11+232/7*pixelcolorb, 2+150/7*pixelcolorb);//56 11 2, 255 243 152 color between brown and yellow ictydomys tridecemlineatus

      //pixels[pos] = color(255-110/7*pixelcolorb, 255-186/7*pixelcolorb, 240-158/7*pixelcolorb);//color between bordeaux rgb(145,69,82) and ivory (rgb(255,255,240))

      //pixels[pos] = color(pixelcolorb/100*360, 80, 80); rgb(145,69,82)
      //pixels[pos] = color(pixelcolorb*36, 80, 80);
  }
  }
  
  updatePixels();
  
  if (t == 1) {
    save(str(r) + "Ictidomys g=0.01 t=1.png");
  }
  if (tpicture == 250) {
    if (t <= 100001) {
    save("Ictidomys g=0.01 t = " + str(t) + ".png");
    tpicture = 0;
    }
}
    if (t > 250) {
      if (d > 0.275) {
      d = d/((1+g*dt)*(1+g*dt)); //implementing indirect exponential growth
      g = g1; //implementing growth rate
      print(d);
      }
      if (d <= 0.275) {
        g = 0;
         } 
}
  
}
