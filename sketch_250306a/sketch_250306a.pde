// Primera practica de algebra lineal
import controlP5.*;


//------------------------ Variables 
// Setup Ventana
int _widthSetup = 600; // varables con _ pq si no la funcion size() no le mola 
int _heightSetup = 600;

// Scenes

enum Scenes{MENU, GAMEPLAY, BOSS};
Scenes actualScene = Scenes.MENU;

// UI
ControlP5 cp5;

boolean startGame = false;

//Control

int controler = 1; // 1 - para raton 0 - for teclado

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
int ofset_m1 = 50;
int ofset_m2 = 50;

//size (los dos con el mismo size)
float size_m1 = 11;
float size_m2 = 13;

float alfa_m1;
float alfa_m2;
float alfa_eN;
float alfa_eP;


boolean colisionDetectada = false;
boolean colisionDetectada_m1 = false;
boolean colisionDetectada_m2 = false;
boolean colisionDetectada_m2_pj = false;


// PNJs (Enemigos)
int num_e; // numero de enemigos
float alfa_enemy[];
int radio_enemy;
//position
float x_e[];
float y_e[];

// size
float size_e[];

// PowerUps
int num_Good_PwUp = 3;
int num_Bad_PwUp = 4;

float[] good_PwUp_x = new float[num_Good_PwUp];// cord powerups 
float[] good_PwUp_y = new float[num_Good_PwUp];

float[] bad_PwUp_x = new float[num_Bad_PwUp];
float[] bad_PwUp_y = new float[num_Bad_PwUp];

boolean[] active_Good_PwUp = new boolean[num_Good_PwUp]; // if powerUPs are active
boolean[] active_Bad_PwUp = new boolean[num_Bad_PwUp];

int radio_PwUps = 10; // tamaño radio PwUps


float m_speed_powerUp = 0.03;
float m_size_powerUp = 3;
float pj_size_powerUp = 5;

//------------------------ Funciotns

void setup(){
  size(_widthSetup,_heightSetup); //ventana
  
  gui(); // UI

  
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
  
  
  
  radio_enemy = 12;
  
  // SetUp powerUps
  for(int i = 0; i < num_Good_PwUp; i++){
      good_PwUp_x[i] = width/random(1, 10);// set random position
      good_PwUp_y[i] = height/random(1, 10);
      active_Good_PwUp[i] = true;
  }
  
  for(int i = 0; i < num_Bad_PwUp; i++){
      bad_PwUp_x[i] = width / random( 1, 10);// set random position
      bad_PwUp_y[i] = height/random(1, 10);
      active_Bad_PwUp[i] = true;
  }
  
}

void draw(){
  // Clear Screen
    background(0);
  switch(actualScene){
    case MENU:
      num_e = int(cp5.get(Textfield.class,"num of enemies").getText()); // set num of enemies
      
      if(startGame){ // if button pressed
        actualScene = Scenes.GAMEPLAY; //set GAMEPLAY scene
        
        deleteMenuGUI(); // delete UI
         
        gameplayInitialize(); // Initialize gameplay
      }
      break;
    case GAMEPLAY:
        // ----- pj
      // set position pj
      x_pj = mouseX;
      y_pj = mouseY;
      // draw
      fill(0,255,0);
      ellipse(x_pj,y_pj,size_pj*2,size_pj*2);  
      
      for (int i = 0; i < num_e; i++) { // Iterar entre todos los enemigos
        if (i < num_e / 2) { 
            alfa_enemy[i] = random(-0.01, -0.0001); 
            
        } else if (i < 3 * num_e / 4) { 
            alfa_enemy[i] = random(0.01, 0.0001);
            
        } else { 
            alfa_enemy[i] = random(0.01, 0.0001);
        }
      }
      // Perseguir mascota 1
      x_m1 = (1 - alfa_m1) * x_m1 + alfa_m1 * (x_pj + ofset_m1);
      y_m1 = (1 - alfa_m1) * y_m1 + alfa_m1 * y_pj;
      
      
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
    
      for (int i = 0; i < num_e; i++) {
          fill(255,0,0);
          ellipse(x_e[i], y_e[i], radio_enemy * 2, radio_enemy * 2);
      }
      
      for (int i = 0; i < num_e; i++) {
        // Colisiones PJ con Enemys
          if (dist(x_e[i], y_e[i], x_pj, y_pj) < radio_enemy + size_pj) {
              colisionDetectada = true;
              break; // Sale del bucle si hay una colisión
          }
          else
          {
            colisionDetectada = false;
          }
          // Colisiones m1 con Enemys
          if (dist(x_e[i], y_e[i], x_m1, y_m1) < radio_enemy + size_m1) {
              colisionDetectada_m1 = true;
              break; // Sale del bucle si hay una colisión
          }
          else
          {
            colisionDetectada_m1 = false;
          }
          // Colisiones m2 con Enemys
          if (dist(x_e[i], y_e[i], x_m2, y_m2) < radio_enemy + size_m2) {
              colisionDetectada_m2 = true;
              break; // Sale del bucle si hay una colisión
          }
          else
          {
            colisionDetectada_m2 = false;
          }
      }
      
      if (dist(x_m2, y_m2, x_pj, y_pj) < size_m2 + size_pj)
      {
        colisionDetectada_m2_pj = true;
      }
      if (colisionDetectada) {
          //println("HAY COLISION");
      }
      if(colisionDetectada_m1){
          //println("HAY COLISION CON M1");
      }
      if(colisionDetectada_m2){
          //println("HAY COLISION CON M2");
      }
      if(colisionDetectada_m2_pj)
      {
          // Perseguir mascota 2
          //println("HAY COLISION CON M1 Y PJ");
          x_m2 = (1 - alfa_m2) * x_m2 + alfa_m2 * x_pj;
          y_m2 = (1 - alfa_m2) * y_m2 + alfa_m2 * (y_pj - ofset_m2);
          
          // Draw powerUps
          for(int i = 0; i < num_Good_PwUp; i++){
            if(active_Good_PwUp[i]){ // if they are active
             ellipse(good_PwUp_x[i],good_PwUp_y[i],radio_PwUps * 2, radio_PwUps * 2); //Draw Good PWUp
            }
          }
          
          for(int i = 0; i < num_Bad_PwUp; i++){
            if(active_Bad_PwUp[i]){ // if they are active
             ellipse(bad_PwUp_x[i],bad_PwUp_y[i],radio_PwUps * 2, radio_PwUps * 2); //Draw Good PWUp
            }
          }
          
      }
      if (!colisionDetectada && !colisionDetectada_m1 && !colisionDetectada_m2 && !colisionDetectada_m2_pj) {
          //println("NO HAY COLISION");
      }
      break;
  }
  
}

void mouseMoved(){ // on mouse moved
  if(actualScene == Scenes.GAMEPLAY){ // if we are in GAMEPLAY SCENE
    moved();
  }
}

// -------- GAMEPLAY Functions

void gameplayInitialize(){
  // initialize arrays
  
  alfa_enemy = new float [num_e];
  x_e = new float [num_e];
  y_e = new float [num_e];
  size_e = new float[num_e];
  
  
  x_m1 = width/2;//random position
  y_m1 = 0;
  x_m2 = width/random(1,10);
  y_m2 = height/random(1,10);
  
  alfa_m1 = random(0.001,0.1);
  alfa_m2 = random(0.001,0.1);
  
  for(int i = 0; i < num_e; i++)
  {
    x_e[i] = width/random(1,10);
    y_e[i] = height/random(1,10);
  }
  
  radio_enemy = 12;
}

void moved(){
  if(colisionDetectada_m2_pj){// if player got de second pet 
    for(int i = 0; i < num_Good_PwUp; i++){// good powerups collision
      if(active_Good_PwUp[i]) {
        //Collison
         // Collision = Distance <= radipj + radipnj
         float[] vector_distance = new float[2];
         vector_distance[0] = good_PwUp_x[i] - x_pj;
         vector_distance[1] = good_PwUp_y[i] - y_pj;
         float module_distance = sqrt(vector_distance[0] * vector_distance[0] + vector_distance[1] * vector_distance[1]);
           
         if(module_distance <= radio_PwUps * 2){ // if they colision
            println("collision true");
            
            switch(i){
              case 1:
                alfa_m1 += m_speed_powerUp; // augment pet speed
                alfa_m2 += m_speed_powerUp;
                break;
              case 2:
                size_m1 -= m_size_powerUp; // reduce pet size
                size_m2 -= m_size_powerUp;
                break;
              case 3:
                size_pj += pj_size_powerUp; // augment player size
                break;
            }
            
            active_Good_PwUp[i] = false;// deactivate powerUP
           break;
         }
      }
        
    }
    
    for(int i = 0; i < num_Bad_PwUp; i++){ // bad powerup collision
      if(active_Bad_PwUp[i]) {
        //Collison
         // Collision = Distance <= radipj + radipnj
         float[] vector_distance = new float[2];
         vector_distance[0] = bad_PwUp_x[i] - x_pj;
         vector_distance[1] = bad_PwUp_y[i] - y_pj;
         float module_distance = sqrt(vector_distance[0] * vector_distance[0] + vector_distance[1] * vector_distance[1]);
           
         if(module_distance <= radio_PwUps * 2){ // if they colision
            println("collision true");
            
            switch(i){
              case 1:
                alfa_m1 -= m_speed_powerUp; // reduce pet speed
                alfa_m2 -= m_speed_powerUp;
                
                if(alfa_m1 <= 0){
                  alfa_m1 = 0.001;
                }
                if(alfa_m2 <= 0){
                  alfa_m2 = 0.001;
                }
                break;
              case 2:
                size_m1 += m_size_powerUp; // augment pet size
                size_m2 += m_size_powerUp;
                break;
              case 3:
                size_pj -= pj_size_powerUp; // reduce player size
                break;
            }
            
            active_Bad_PwUp[i] = false;// deactivate powerUP
           break;
         }
      }
        
    }
  }
}

// -------- UI Functions

void gui(){
  PFont font = createFont("arial",20);
  
  cp5 = new ControlP5(this);
  
  //Set controls
  cp5.addRadioButton("control")
     .setPosition(200,20)
     .setItemWidth(20)
     .setItemHeight(20)
     .addItem("Teclado", 0)
     .addItem("Raton", 1)
     .setColorLabel(color(255))
     .activate(1);
  
    //Set Enemies
  cp5.addTextfield("num of enemies")
     .setPosition(20,100)
     .setSize(200,40)
     .setFont(font)
     .setFocus(true)
     .setColor(color(255))
     .setText("5")
     ;  

  //button
  cp5.addBang("Start")
    .setPosition(10,20)
    .setSize(40,50);
  
}

void control(int theC){ // chose controler
  switch(theC){
    case(0):
      println("Teclado");
      controler = 0; // set keyboard
      break;
    case(1):
      println("Raton");
      controler = 1; // set mouse
      break;
  }
}

void Start(){
  println("Start game");
  startGame = true;
}

void deleteMenuGUI(){
  
  cp5.remove("Start"); // delete start button
  cp5.remove("num of enemies"); // delete textfield
  cp5.remove("control"); // delete control
  
}
