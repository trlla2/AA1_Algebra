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
float size_pj = 15;

// PNJs (mascotas)

//position
float x_m1, y_m1, x_m2, y_m2;

//size (los dos con el mismo size)
float size_m1 = 11;
float size_m2 = 13;

float alfa_m1;
float alfa_m2;
float alfa_eN;
float alfa_eP;



// PNJs (Enemigos)
int num_e = 11; // numero de enemigos
float alfa_enemy[] = new float[num_e];
int radio_enemy;
//position
float x_e[] = new float [num_e];
float y_e[] = new float [num_e];

// size
float size_e[] = new float[num_e];


boolean colision = false;

//------------------------ Funciotns

void setup(){
  size(_widthSetup,_heightSetup); //ventana
  
  x_m1 = width/random(1,10);//random position
  y_m1 = height/random(1,10);
  x_m2 = width/random(1,10);
  y_m2 = height/random(1,10);
  
  alfa_m1 = random(0.001,0.01);
  alfa_m2 = random(0.001,0.01);
  
  for(int i = 0; i < num_e; i++)
  {
    x_e[i] = width/random(1,10);
    y_e[i] = height/random(1,10);
  }
  
  for (int i = 0; i < num_e; i++) { // Iterar entre todos los enemigos
    if (i < num_e / 2) { 
        alfa_enemy[i] = random(-0.01, -0.0001); 
        
    } else if (i < 3 * num_e / 4) { 
        alfa_enemy[i] = random(0.01, 0.0001);
        
    } else { 
        alfa_enemy[i] = random(0.01, 0.0001);
    }
  }
  
  radio_enemy = 12;
  
}

void draw(){
  // Clear Screen
    background(0);
  
  // ----- pj
  // set position pj
  x_pj = mouseX;
  y_pj = mouseY;
  // draw
  fill(0,255,0);
  ellipse(x_pj,y_pj,size_pj*2,size_pj*2);  
  
  // Perseguir mascota 1
  x_m1 = (1 - alfa_m1) * x_m1 + alfa_m1 * x_pj;
  y_m1 = (1 - alfa_m1) * y_m1 + alfa_m1 * y_pj;
  // Perseguir mascota 2
  x_m2 = (1 - alfa_m2) * x_m2 + alfa_m2 * x_pj;
  y_m2 = (1 - alfa_m2) * y_m2 + alfa_m2 * y_pj;
  
  // Perseguir de los enemigos
   for(int i = 0; i < num_e; i++){ //iterar entre todos los pnj
    if(i < num_e / 2){
      // N/2 enemigos huyen del PJ
      x_e[i] = (1 - alfa_enemy[i]) * x_e[i] + alfa_enemy[i] * x_pj;
      y_e[i] = (1 - alfa_enemy[i]) * y_e[i] + alfa_enemy[i] * y_pj;
      
    }else if (i < 3 * num_e / 4) {
      // N/4 enemigos persiguen al PNJ1
      x_e[i] = (1 - alfa_enemy[i]) * x_e[i] + alfa_enemy[i] * x_m1;
      y_e[i] = (1 - alfa_enemy[i]) * y_e[i] + alfa_enemy[i] * y_m1;
    } else {
      // N/4 enemigos persiguen al PNJ2
      x_e[i] = (1 - alfa_enemy[i]) * x_e[i] + alfa_enemy[i] * x_m2;
      y_e[i] = (1 - alfa_enemy[i]) * y_e[i] + alfa_enemy[i] * y_m2;
    }
  }
  
  // Pintar PNJ's
  fill(255,255,0);
  ellipse(x_m1,y_m1,size_m1*2,size_m1*2);
  fill(90,255,200);
  ellipse(x_m2,y_m2,size_m2*2,size_m2*2);
  
  boolean colisionDetectada = false;

  for (int i = 0; i < num_e; i++) {
      fill(255,0,0);
      ellipse(x_e[i], y_e[i], radio_enemy * 2, radio_enemy * 2);
  }
  
  for (int i = 0; i < num_e; i++) {
      if (dist(x_e[i], y_e[i], x_pj, y_pj) < radio_enemy + size_pj) {
          colisionDetectada = true;
          break; // Sale del bucle si hay una colisión
      }
  }
  
  
  
  if (colisionDetectada) {
      println("HAY COLISION");
  }else{
      println("NO HAY COLISION");
  }
  
}
