matrix3D[] lines = new matrix3D[10];
vector3D[] colors = new vector3D[10];

float rot_x, rot_y, rot_z;
float xOffset, yOffset = 0.0; 
float xVel, yVel = 0.0; 
float xScroll, yScroll = 0.0; 
boolean drag = false;


/*
* Sets Up vector x,y,color vectors 
*/
void setup() {
  size(600, 600);
  
    colors[0] = new vector3D(255, 0, 0);
    lines[0] = new matrix3D(new vector3D(400, 0, 0), new vector3D(-400, 0, 0), colors[0]);
    colors[1] = new vector3D(0, 255, 0);
    lines[1] = new matrix3D(new vector3D(0, 400, 0), new vector3D(0, -400, 0), colors[1]);
    colors[2] = new vector3D(0, 0, 255);
    lines[2] = new matrix3D(new vector3D(0, 0, 400), new vector3D(0, 0, -400), colors[2]);
  
  for (int i = 3; i < lines.length; i++){ 
    colors[i] = new vector3D(random(255), random(255), random(255));
    lines[i] = new matrix3D(new vector3D(rand(400), rand(400), rand(400)), new vector3D(rand(400), rand(400), rand(400)), colors[i]);
    }
}

/*
* renders vectors and runs mouse controls
*/
void draw() {
  background(255);
  if(!drag){
    xVel *= 0.99;
    yVel *= 0.99;
  } else {
    xVel = (xOffset + mouseX) - xScroll;
    xScroll = (xOffset + mouseX);
    yVel = (yOffset + mouseY) - yScroll;
    yScroll = (yOffset + mouseY);
  }
   if (abs(xVel) > 0.1) {
      xVel *= 0.1/abs(xVel);
    }
   if (abs(yVel) > 0.1) {
      yVel *= 0.1/abs(yVel);
    }
  cursor(CROSS);
  
  rot_x = yVel;
  rot_y = 0;
  rot_z = xVel;
  
  render();
}

/*
* matrix object
*/
class matrix3D {
    vector3D[] m = new vector3D[3];
    
  matrix3D(vector3D x_, vector3D y_, vector3D z_){
    m[0] = x_;
    m[1] = y_;
    m[2] = z_;
  }
}

/*
* vector object
*/
class vector3D {
 
  float[] v = new float[3];
 
  vector3D(float x, float y, float z) {
    v[0] = x;
    v[1] = y;
    v[2] = z;
  }
}

/*
* multiplies matrices
*/
matrix3D multiply(matrix3D a, matrix3D b){
    vector3D[] m = new vector3D[3];
    m[0] = transform(b, a.m[0]);
    m[1] = transform(b, a.m[1]);
    m[2] = transform(b, a.m[2]);
    return new matrix3D(m[0], m[1], m[2]);
}

/*
* transforms matrix by vector 
*/
vector3D transform(matrix3D T, vector3D A){
    float[] v = new float[3];
    v[0] = T.m[0].v[0] * A.v[0] + T.m[1].v[0] * A.v[1] + T.m[2].v[0] * A.v[2];
    v[1] = T.m[0].v[1] * A.v[0] + T.m[1].v[1] * A.v[1] + T.m[2].v[1] * A.v[2];
    v[2] = T.m[0].v[2] * A.v[0] + T.m[1].v[2] * A.v[1] + T.m[2].v[2] * A.v[2];
    return new vector3D(v[0], v[1], v[2]);
  }
  
/*
* rotates x-axis 
*/
matrix3D rot_x(float tan){
  vector3D rot_i = new vector3D(1,0,0);
  vector3D rot_j = new vector3D(0,cos(tan),sin(tan));
  vector3D rot_k = new vector3D(0,-sin(tan),cos(tan));
  return new matrix3D(rot_i, rot_j, rot_k);
}

/*
* rotates y-axis 
*/
matrix3D rot_y(float tan){
  vector3D rot_i = new vector3D(cos(tan),0,-sin(tan));
  vector3D rot_j = new vector3D(0,1,0);
  vector3D rot_k = new vector3D(sin(tan),0,cos(tan));
  return new matrix3D(rot_i, rot_j, rot_k);
}

/*
* rotates z-axis  
*/
matrix3D rot_z(float tan){
  vector3D rot_i = new vector3D(cos(tan),sin(tan),0);
  vector3D rot_j = new vector3D(-sin(tan),cos(tan),0);
  vector3D rot_k = new vector3D(0,0,1);
  return new matrix3D(rot_i, rot_j, rot_k);
}

//converts position to canvas
float display(int pos, vector3D A){
  return (A.v[pos] * (1-pos) + height)/2;
}

void mousePressed() { 
    xVel = 0;
    yVel = 0;
    xOffset = xScroll - mouseX;
    yOffset = yScroll - mouseY;
    drag = true;
}

void mouseReleased() {
  drag = false;
}

float rand(float size) {
  return random(-1* size, size);
}

void keyPressed() {
}

void render(){
  renderLine(lines);
}

void renderLine(matrix3D[] M){
  matrix3D[] cache = M;
  for (int i = 0; i < cache.length; i++){
    cache[i].m[0] = transform(multiply(rot_z(rot_z), multiply(rot_y(rot_y),rot_x(rot_x))), M[i].m[0]);
    cache[i].m[1] = transform(multiply(rot_z(rot_z), multiply(rot_y(rot_y),rot_x(rot_x))), M[i].m[1]);
    stroke(M[i].m[2].v[0], M[i].m[2].v[1], M[i].m[2].v[2]);
    line(display(0, cache[i].m[0]), display(2, cache[i].m[0]), display(0, cache[i].m[1]), display(2, cache[i].m[1]));
  }
}

vector3D rotate(vector3D A){
  return transform(multiply(rot_z(rot_z), multiply(rot_y(rot_y),rot_x(rot_x))), A);
}
