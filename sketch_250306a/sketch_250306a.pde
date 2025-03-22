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
int num_PwUp = 3;
int num_PwDwn = 4;

int left_powerUps = num_PwUp; // left powerups to start bossfight 

float[] x_PwUp = new float[num_PwUp];// cord powerups 
float[] y_PwUp = new float[num_PwUp];

float[] x_PwDwn = new float[num_PwDwn];
float[] y_PwDwn = new float[num_PwDwn];

boolean[] active_PwUp = new boolean[num_PwUp]; // if powerUPs are active
boolean[] active_PwDwn = new boolean[num_PwDwn];

int radio_PwUps = 10; // tamaño radio PwUps

// powerup modifiers
float m_speed_powerUp = 0.03; // 1
float m_size_powerUp = 3; // 2
float pj_size_powerUp = 5; // 3

// teleport

//Position
int x_portal = height/4;
int y_portal = width/2;

// size
int portal_height = 20;
int portal_width = 60;



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
  for(int i = 0; i < num_PwUp; i++){
      x_PwUp[i] = width/random(1, 10);// set random position
      y_PwUp[i] = height/random(1, 10);
      active_PwUp[i] = true;
  }
  
  for(int i = 0; i < num_PwDwn; i++){
      x_PwDwn[i] = width / random( 1, 10);// set random position
      y_PwDwn[i] = height/random(1, 10);
      active_PwDwn[i] = true;
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
          fill(255,0,255); //color powerUps
          for(int i = 0; i < num_PwUp; i++){
            if(active_PwUp[i]){ // if they are active
             ellipse(x_PwUp[i],y_PwUp[i],radio_PwUps * 2, radio_PwUps * 2); //Draw Good PWUp
            }
          }
          
          for(int i = 0; i < num_PwDwn; i++){
            if(active_PwDwn[i]){ // if they are active
             ellipse(x_PwDwn[i],y_PwDwn[i],radio_PwUps * 2, radio_PwUps * 2); //Draw Good PWUp
            }
          }
          
          
          if(left_powerUps <= 0){ // draw portal
            rectMode(CENTER);  // draw portal from the center
            fill(0,0,255);  
            rect( x_portal, y_portal, portal_width, portal_height); // Draw white rect using CORNER mode
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
    for(int i = 0; i < num_PwUp; i++){// good powerups collision
      if(active_PwUp[i]) {
        //Collison
         // Collision = Distance <= radipj + radipnj
         float[] vector_distance = new float[2];
         vector_distance[0] = x_PwUp[i] - x_pj;
         vector_distance[1] = y_PwUp[i] - y_pj;
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
            
            left_powerUps --; // - powerUP to spawn the portal
            
            active_PwUp[i] = false;// deactivate powerUP
           break;
         }
      }
        
    }
    
    for(int i = 0; i < num_PwDwn; i++){ // bad powerup collision
      if(active_PwDwn[i]) {
        //Collison
         // Collision = Distance <= radipj + radipnj
         float[] vector_distance = new float[2];
         vector_distance[0] = x_PwDwn[i] - x_pj;
         vector_distance[1] = y_PwDwn[i] - y_pj;
         float module_distance = sqrt(vector_distance[0] * vector_distance[0] + vector_distance[1] * vector_distance[1]);
           
         if(module_distance <= radio_PwUps * 2){ // if they colision
            println("collision true");
            
            switch(i){
              case 1:
                alfa_m1 -= m_speed_powerUp; // reduce pet speed
                alfa_m2 -= m_speed_powerUp;
                
                if(alfa_m1 <= 0){ // speed cap
                  alfa_m1 = 0.001;
                }
                if(alfa_m2 <= 0){ // speed cap
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
            
            active_PwDwn[i] = false;// deactivate powerUP
           break;
         }
      }
        
    }
    
    // portal position
    // Calcular límites del jugador
    float PJ_left = x_pj - portal_width/2;
    float PJ_right = x_pj + portal_width/2;
    float PJ_top = y_pj - portal_height/2;
    float PJ_bottom = y_pj + portal_height/2;
    
  
    // Calcular límites del muro
    float wall_left = x_portal - portal_width/2;
    float wall_right = x_portal + portal_width/2;
    float wall_top = y_portal - portal_height/2;
    float wall_bottom = y_portal + portal_height/2;

    // Detección AABB correcta
    if(PJ_right > wall_left && 
       PJ_left < wall_right && 
       PJ_bottom > wall_top && 
       PJ_top < wall_bottom) {
      println("enter portal");
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
