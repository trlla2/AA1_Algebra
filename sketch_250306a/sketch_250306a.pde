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

// time stuff

ControlTimer pet_fear_timer;

int startTimeM2 = 0;
int attackTimerM2 = 2000;

int startTimeBoss = 0;
int attackTimerBoss = 1000;

int lastSpawnTime = 0;
int lastSpawnTimer = 2000;

int GameplayTime = 0;
int GameplayHurtTime = 60000;
int GameplayTimer = 0;


//Control

int controler = 1; // 1 - para raton 0 - for teclado

// control teclado
float speed = 15; // speed of keyboard movement
boolean up = false;
boolean down = false;
boolean left = false;
boolean right = false;
boolean first_position = true;


// PJ
float x_pj,y_pj; // position
//Color
float color_pj_r = 0;
float color_pj_g = 0;
float color_pj_b = 255;
//size
float size_pj = 15;

int hp_pj = 3;

// PNJs (mascotas)

//position
float x_m1, y_m1, x_m2, y_m2;
int ofset_m1 = 50;
int ofset_m2 = 50;

//size (los dos con el mismo size)
float size_m1 = 11;
float size_m2 = 13;

float size_width_healthbar_m2 = 30;
float size_height_healthbar_m2 = 10;
float offset_healthbar_m2 = 5;

float alfa_m1;
float alfa_m2;
float alfa_eN;
float alfa_eP;

int hp_m2 = 3;

boolean colisionDetectada = false;
boolean colisionDetectada_m1 = false;
boolean colisionDetectada_m2 = false;
boolean colisionDetectada_m2_pj = false;
boolean distancia_e_m2[];


// PNJs (Enemigos)
int num_e; // numero de enemigos
float alfa_enemy[];
int radio_enemy;
//position
float x_e[];
float y_e[];

int hp_e[];

// size
float size_e[];

int num_spawn_e = 0;



// PowerUps
int num_PwUp = 3;
int num_PwDwn = 3;

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

//walls
PVector[] walls; 
static int num_wall = 10;
int height_wall =  20;
int width_wall = 20;


// Portal
//Position
int x_portal;
int y_portal;

// size
int portal_height = 20;
int portal_width = 60;

// BOSS
float size_boss = 30;
float alfa_boss;
float x_boss, y_boss;
int hp_boss = 10;
boolean colision_pj_boss = false;



//------------------------ Funciotns

void setup(){
  size(_widthSetup,_heightSetup); //ventana
  menuInitialize();
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
        
        startGame = false; // set startGame to false 
      }
      break;
    case GAMEPLAY:
      timer();
    
      // ----- pj
      // set position pj
      if(controler == 1){ // control reton
        if(!checkWallColisoin(mouseX,mouseY)){
          x_pj = mouseX;
          y_pj = mouseY;
        }
      }
      else if(controler == 0){
        
        if (first_position)
        {
          x_pj = width / 2;
          y_pj = height / 2;
        }
        println(x_pj < 0);
        if (left && x_pj > 0  || !checkWallColisoin(x_pj - speed,y_pj)){ // go left and dont go off de screen and colision with walls
          x_pj -= speed;
          first_position = false;
          moved(); //call function on moved
        }
        if (right && x_pj < width || !checkWallColisoin(x_pj + speed,y_pj)){ // go right and dont go off de screen and colision with walls
          x_pj += speed;
          first_position = false;
          moved(); //call function on moved
        }
        if (up && y_pj > 0 || !checkWallColisoin(x_pj,y_pj - speed)){ // go up and dont go off de screen and colision with walls
          y_pj -= speed;
          first_position = false;
          moved(); //call function on moved
        }
        if (down && y_pj < height || !checkWallColisoin(x_pj,y_pj + speed)){ // go down and dont go off de screen and colision with walls
          y_pj += speed;
          first_position = false;
          moved(); //call function on moved
        } 
      }
      
      // draw
      fill(0,255,0);
      ellipse(x_pj,y_pj,size_pj*2,size_pj*2);  
      
      
      // Perseguir mascota 1
      x_m1 = (1 - alfa_m1) * x_m1 + alfa_m1 * (x_pj + ofset_m1);
      y_m1 = (1 - alfa_m1) * y_m1 + alfa_m1 * y_pj;
      
      // Spawn Enemyes
      if (millis() > lastSpawnTime + lastSpawnTimer && num_spawn_e < num_e){
        println("Spawnean");
        
        if (alfa_enemy[num_spawn_e] > 0)
        {
          lastSpawnTime = millis();
          int aux = (int)random(1, 4);
          if(aux == 1)
          {
            println("1");
            x_e[num_spawn_e] = width/random(1,10);
            y_e[num_spawn_e] = -10;
          }
          else if(aux == 2)
          {
            println("2");
            x_e[num_spawn_e] = width/random(1,10);
            y_e[num_spawn_e] = height + 10;
          }
          else if(aux == 3)
          {
            println("3");
            x_e[num_spawn_e] = -10;
            y_e[num_spawn_e] = height/random(1,10);
          }
          else
          {
            println("4");
            x_e[num_spawn_e] = width + 10;
            y_e[num_spawn_e] = height/random(1,10);
          }
        }
        num_spawn_e++;
    }
    
    for (int i = 0; i < num_e; i++) {
          if (hp_e[i] > 0)
          {
            fill(255,0,0);
            ellipse(x_e[i], y_e[i], radio_enemy * 2, radio_enemy * 2);
          }
          
      }
      
      
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
      
      // helathbar mascota 2
      rectMode(CENTER);  
      fill(255,0,0);  
      size_width_healthbar_m2 = hp_m2 * 10;
      rect(x_m2 , y_m2 - (size_m2*2) + offset_healthbar_m2, size_width_healthbar_m2,  size_height_healthbar_m2);
      
      // Draw walls
      for(int i = 0; i < num_wall; i++){
        rectMode(CENTER);  // pinta los muros a partir del punto central, el alto y el ancho
        fill(127);  // Set fill to white
        rect(walls[i].x, walls[i].y, height_wall, width_wall); // Draw white rect using CORNER mode
      }
      
      for (int i = 0; i < num_e; i++) {
        if (hp_e[i] > 0){
          // Colisiones PJ con Enemys
          if (dist(x_e[i], y_e[i], x_pj, y_pj) < radio_enemy + size_pj) {
              colisionDetectada = true;
              hp_e[i] -= 1;
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
          if (dist(x_e[i], y_e[i], x_m2, y_m2) < radio_enemy + size_m2 && millis() > startTimeM2 + attackTimerM2) {
              colisionDetectada_m2 = true;
              
              
              startTimeM2 = millis();
              
              hp_m2 -= 1;
              
               

              break; // Sale del bucle si hay una colisión
          }
          else
          {
            colisionDetectada_m2 = false;
            
          }
          if(hp_m2 <= 0)
          {
            hp_pj -= 1;
            //println(hp_pj);
            if(hp_pj <= 0){
              actualScene = Scenes.MENU; // go to menu
              menuInitialize();
            }
          }
          if (hp_m2 <= 0)
          {
            hp_m2 = 3;
          }
        }
      }
      
      //println(hp_m2);
      
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
      //if(distancia_e_m2)
      //{
        //println("HAY DETECCIÓN CON M2");
      //}
      if(colisionDetectada_m2_pj)
      {
          // Perseguir mascota 2
         // println("HAY COLISION CON M1 Y PJ");
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
      if (colisionDetectada_m2_pj)
      {
        for (int i = 0; i < num_e; i++) // fear of the pet
        {
          if (hp_e[i] > 0){
            
            float[] vector_distance = new float[2]; // check distance
             vector_distance[0] = x_e[i] -x_m2;
             vector_distance[1] = y_e[i] - y_m2;
              
            if (sqrt( vector_distance[0] * vector_distance[0] + vector_distance[1] * vector_distance[1]) < 50 || distancia_e_m2[i]) // calculate distance
              {
                distancia_e_m2[i] = true;
                
                x_m2 = (1 - 0.01) * x_m2 - 0.01 * x_e[i];
                y_m2 = (1 - 0.01) * y_m2 - 0.01 * y_e[i];
  
                if(sqrt( vector_distance[0] * vector_distance[0] + vector_distance[1] * vector_distance[1])  >  100){
                  distancia_e_m2[i] = false;
                }
                break;
              }
            }
        }
      }
      
      if (!colisionDetectada && !colisionDetectada_m1 && !colisionDetectada_m2 && !colisionDetectada_m2_pj) {
          //println("NO HAY COLISION");
      }
      
      break;
      case BOSS:
      timer();
      // ----- pj
      // set position pj
      if(controler == 1){ // control reton
        x_pj = mouseX;
        y_pj = mouseY;  
      }
      else if(controler == 0){
        if (left){
          x_pj -= speed;
          moved(); //call function on moved
        }
        if (right){
          x_pj += speed;
          moved(); //call function on moved
        }
        if (up){
          y_pj -= speed;
          moved(); //call function on moved
        }
        if (down){
          y_pj += speed;
          moved(); //call function on moved
        } 
      }
      // draw
      fill(0,255,0);
      ellipse(x_pj,y_pj,size_pj*2,size_pj*2);
      
      // Perseguir mascota 1
      x_m1 = (1 - alfa_m1) * x_m1 + alfa_m1 * (x_pj + ofset_m1);
      y_m1 = (1 - alfa_m1) * y_m1 + alfa_m1 * y_pj;
      
      // Pintar PNJ's
      fill(255,255,0);
      ellipse(x_m1,y_m1,size_m1*2,size_m1*2);
      fill(90,255,200);
      ellipse(x_m2,y_m2,size_m2*2,size_m2*2);
      
      // helathbar mascota 2
      rectMode(CENTER);  
      fill(255,0,0);  
      size_width_healthbar_m2 = hp_m2 * 10;
      rect(x_m2 , y_m2 - (size_m2*2) + offset_healthbar_m2, size_width_healthbar_m2,  size_height_healthbar_m2);
      
      if (colisionDetectada_m2_pj)
      {
         x_m2 = (1 - alfa_m2) * x_m2 + alfa_m2 * x_pj;
         y_m2 = (1 - alfa_m2) * y_m2 + alfa_m2 * (y_pj - ofset_m2);  
      }
      
      
      if (hp_boss > 0)
      {
        if(millis() > startTimeBoss + attackTimerBoss){
          fill(255, 0, 0);
        }
        else{
          fill(255, 255, 0);
        }
        ellipse(x_boss,y_boss,size_boss*2,size_boss*2);
      }
      else{
        actualScene = Scenes.MENU;
         menuInitialize();
      }

      alfa_boss = random(0.01, 0.0001); 
      
      x_boss = (1 - alfa_boss) * x_boss + alfa_boss * x_m2;
      y_boss = (1 - alfa_boss) * y_boss + alfa_boss * y_m2;
      
      if (dist(x_boss, y_boss, x_pj, y_pj) < size_boss + size_pj && millis() > startTimeBoss + attackTimerBoss) {
          colision_pj_boss = true;
          startTimeBoss = millis();
          hp_boss -= 1;
          break; // Sale del bucle si hay una colisión
      }
      else
      {
        colision_pj_boss = false;
      }
      if (dist(x_boss, y_boss, x_m2, y_m2) < size_boss + size_m2 && millis() > startTimeM2 + attackTimerM2) {
              colisionDetectada_m2 = true;
              startTimeM2 = millis();
              hp_m2 -= 1;
              println(hp_m2);
      }
      else
      {
         colisionDetectada_m2 = false;
      }
      
      if(hp_m2 <= 0)
      {
        hp_pj -= 1;
        println(hp_pj);
      }
      
      if(hp_pj <= 0){
        actualScene = Scenes.MENU; // go to menu
        menuInitialize();
      }
      
      if (hp_m2 <= 0)
      {
        hp_m2 = 3;
      }
      
      if(colisionDetectada_m2){
        println("HAY COLISION CON M2");
      }
      if(colision_pj_boss)
      {
        println("HAY COLISION CON BOSS");
      }
      
  }
  
}

void mouseMoved(){ // on mouse moved
  if(actualScene == Scenes.GAMEPLAY){ // if we are in GAMEPLAY SCENE
    moved();
  }
}

void keyPressed() { // on any key pressed
  if (key == CODED) {
    if (keyCode == LEFT) {
      left = true;
    }
    else if (keyCode == RIGHT) {
      right = true;
    }
    else if (keyCode == UP) {
      up = true;
    }
    else if (keyCode == DOWN){
      down = true;
    }
  }
  
  
}

void keyReleased() { // on any key released
  if (key == CODED) {
    if (keyCode == LEFT) {
      left = false;
    }
    else if (keyCode == RIGHT) {
      right = false;
    }
    else if (keyCode == UP) {
      up = false;
    }
    else if (keyCode == DOWN){
      down = false;
    }
  }
}
void bossInitialize()
{
  x_boss = width/2;//random position
  y_boss = width/2;
  
  hp_boss = 10;
}

void menuInitialize(){
     
  gui(); // initialize UI
}

// -------- GAMEPLAY Functions

void gameplayInitialize(){
  // reset timer
  GameplayTime = millis();
  GameplayTimer = 0;
  
  // initialize arrays
  
  alfa_enemy = new float [num_e];
  x_e = new float [num_e];
  y_e = new float [num_e];
  size_e = new float[num_e];
  hp_e = new int[num_e];
  distancia_e_m2 = new boolean[num_e];
  
  
  x_m1 = width/2;//random position
  y_m1 = 0;
  x_m2 = width/random(1,10);
  y_m2 = height/random(1,10);
  alfa_m1 = random(0.001,0.1);
  alfa_m2 = random(0.001,0.1);
  
  size_width_healthbar_m2 = 30;
  
  hp_pj = 3;
  
  for (int i = 0; i < num_e; i++) { // Iterar entre todos los enemigos
        if (i < num_e / 2) { 
            alfa_enemy[i] = random(-0.01, -0.0001); 
            
        } else if (i < 3 * num_e / 4) { 
            alfa_enemy[i] = random(0.01, 0.0001);
            
        } else { 
            alfa_enemy[i] = random(0.01, 0.0001);
        }
   }

    for (int i = 0; i < num_e; i++)
    {
      if(alfa_enemy[i] < 0){
         println("Huyen");
         x_e[num_spawn_e] = random(0,width);
         y_e[num_spawn_e] = random(0,height);
      }
    }
    
  
  
  radio_enemy = 12;
  
  // Set HP Enemy
  for(int i = 0; i < num_e; i++)
  {
    hp_e[i] = 1;
  }
  
  // initialize powerUps
  for(int i = 0; i < num_PwUp; i++){
      x_PwUp[i] = random(0,width);// set random position
      y_PwUp[i] = random(0,height);
      active_PwUp[i] = true;
  }
  
  for(int i = 0; i < num_PwDwn; i++){
      x_PwDwn[i] = random(0,width);// set random position
      y_PwDwn[i] = random(0,height);
      active_PwDwn[i] = true;
  }
  
  left_powerUps = num_PwUp;
  
  // initialize timers
  
  pet_fear_timer = new ControlTimer();
  pet_fear_timer.setSpeedOfTime(1); // speed of the timer
  
  
  // set booleans to false
  
  colisionDetectada = false;
  colisionDetectada_m1 = false;
  colisionDetectada_m2 = false;
  colisionDetectada_m2_pj = false;
  
  
  // portal initialize
  x_portal = height/2;
  y_portal = width/4;
  
  // wall initialize
  walls = new PVector[num_wall]; 
  
  for(int i = 0; i < num_wall; i++){
    walls[i] = new PVector( // random position
      (int)random(0 + width_wall,width - width_wall),
      (int)random(0 + height_wall,height - height_wall)
    ); 
  }
}

void timer(){
  GameplayTimer = int((millis() - GameplayTime) / 1000);
  
  if(GameplayTimer >= GameplayHurtTime){
    GameplayTime = millis();
    hp_pj --;
  }
  
  PFont font;
  font = createFont("Roboto-VariableFont_wdth,wght.ttf", 20);
  fill(255);
  textFont(font);
  text(GameplayTimer, width/2, height/10);
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
    if(actualScene == Scenes.GAMEPLAY){
      // portal position
      // Calcular límites del jugador
      float PJ_left = x_pj - size_pj/2;
      float PJ_right = x_pj + size_pj/2;
      float PJ_top = y_pj - size_pj/2;
      float PJ_bottom = y_pj + size_pj/2;
      
    
      // Calcular límites del muro
      float wall_left = x_portal - portal_width/2;
      float wall_right = x_portal + portal_width/2;
      float wall_top = y_portal - portal_height/2;
      float wall_bottom = y_portal + portal_height/2;
  
      // Detección AABB correcta
      if(PJ_right > wall_left && 
         PJ_left < wall_right && 
         PJ_bottom > wall_top && 
         PJ_top < wall_bottom && left_powerUps <= 0) {
        println("enter portal");
        actualScene = Scenes.BOSS; //set GAMEPLAY scene
        bossInitialize();
      }
     }
  }
  
  
}

boolean checkWallColisoin(float x , float y){
  // Calcular límites del jugador
     float PJ_left = x - size_pj/2;
     float PJ_right = x + size_pj/2;
     float PJ_top = y - size_pj/2;
     float PJ_bottom = y + size_pj/2;
     
    
    for(int i = 0; i < num_wall; i++){
      // Calcular límites del muro
      float wall_left = walls[i].x - width_wall/2;
      float wall_right = walls[i].x + width_wall/2;
      float wall_top = walls[i].y - height_wall/2;
      float wall_bottom = walls[i].y + height_wall/2;
      
      // Detección AABB correcta
      if(PJ_right > wall_left && 
         PJ_left < wall_right && 
         PJ_bottom > wall_top && 
         PJ_top < wall_bottom) {
         println("collision muro: " + i + "posicion del muro: " + walls[i].x + " ," + walls[i].y);
         return true;
        
      }
   }
  return false;
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
