// Primera practica de algebra lineal

//------------------------ Variables 
// Setup Ventana
int _widthSetup = 600; // varables con _ pq si no la funcion size() no le mola 
int _heightSetup = 600;

// PJ
float x_pj,y_pj; // position
//Color
float color_pj_r = 0;
float color_pj_g = 0;
float color_pj_b = 255;
//size
float size_pj = 20;

// PNJs (mascotas)

//position
float x_m1, y_m1, x_m2, y_m2;

//color
float color_m1_r = 0;
float color_m1_g = 255;
float color_m1_b = 0;

float color_m2_r = 0;
float color_m2_g = 255;
float color_m2_b = 0;
//size (los dos con el mismo size)
float size_m = 10;

float alfa_m1;
float alfa_m2;
float alfa_eN;
float alfa_eP;

// PNJs (Enemigos)
int num_e = 4; // numero de enemigos
//position
float x_e[] = new float [num_e];
float y_e[] = new float [num_e];
//color

// size
float size_e[] = new float[num_e];

//------------------------ Funciotns

void setup(){
  size(_widthSetup,_heightSetup); //ventana
  
  x_m1 = width/random(1,10);//random position
  y_m1 = height/random(1,10);
  x_m2 = width/random(1,10);
  y_m2 = height/random(1,10);
  
  alfa_m1 = random(0.001,0.1);
  alfa_m2 = random(0.001,0.1);
  
  for(int i = 0; i < num_e; i++)
  {
    x_e[i] = width/random(1,10);
    y_e[i] = height/random(1,10);
  }
  
  alfa_eN = random(-0.001,-0.1);
  alfa_eP = random(0.001,0.1);
  
  
}

void draw(){
  // Clear Screen
    background(0);
  
  // ----- pj
  // set position pj
  x_pj = pmouseX;
  y_pj = pmouseY;
  // draw
  fill(0,255,0);
  ellipse(x_pj,y_pj,width/20,height/20);  
  
  // Perseguir mascota 1
  x_m1 = (1 - alfa_m1) * x_m1 + alfa_m1 * x_pj;
  y_m1 = (1 - alfa_m1) * y_m1 + alfa_m1 * y_pj;
  // Perseguir mascota 2
  x_m2 = (1 - alfa_m2) * x_m2 + alfa_m2 * x_pj;
  y_m2 = (1 - alfa_m2) * y_m2 + alfa_m2 * y_pj;
  
  // Pintar PNJ's
  fill(255,255,0);
  ellipse(x_m1,y_m1,width/25,height/25);
  fill(90,255,200);
  ellipse(x_m2,y_m2,width/20,height/20);
  
  for(int i = 0; i < num_e; i++)
  {
    fill(255,0,0);
    ellipse(x_e[i],y_e[i],width/25,height/25);
  }
  
}
