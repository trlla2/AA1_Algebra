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
int x_m1, y_m1, x_m2, y_m2;

//color
float color_m1_r = 0;
float color_m1_g = 255;
float color_m1_b = 0;

float color_m2_r = 0;
float color_m2_g = 255;
float color_m2_b = 0;
//size (los dos con el mismo size)
float size_m = 10;


// PNJs (Enemigos)
int num_e = 4; // numero de enemigos
//position
float x_e[] = new float [num_e];
float y_e[] = new float [num_e];
//color
float color_pnj_r[] = new float[num_e];
float color_pnj_g[] = new float[num_e];
float color_pnj_b[] = new float[num_e];
// size
float size_e[] = new float[num_e];

//------------------------ Funciotns

void setup(){
  size(_widthSetup,_heightSetup); //ventana
}
