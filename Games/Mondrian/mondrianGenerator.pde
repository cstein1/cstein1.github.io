void setup(){
  size(1000,600);
  background(0);

  fill(255);
  stroke(0);
  strokeWeight(16);
  quadrant(0,0,width,height);
  coverUp();
}

float tillX;
float tillY;

void draw(){
}

void keyPressed(){
  reset();
}

void mouseClicked(){
  reset();
}

void reset(){
  background(255);
  rect(0,0,width,height);
  quadrant(0,0,width,height);
  coverUp();
}

float x;
float y;
float x1;
float y1;
void recurse(int rec){
  if(rec - random(0,10) < 1){
    quadrant(x,y,x1,y1);
    recurse(rec +1);
  }
}
float col;
void defineCol(){
  col = floor(random(0,20));
  if(col % 5 == 0)
    fill(255,0,0);
  else if(col % 7 == 0)
    fill(0,255,0);
  else if(col % 9 == 0)
    fill(0,0,255);
  else
    fill(255,255,255);
}
void quadrant(float minX, float minY, float maxX, float maxY){
  x = random(minX,maxX);
  y = random(minY,maxY);
  x1 = random(x, maxX);
  y1 = random(y, maxY);

  defineCol();
  rect(minX,minY,maxX,maxY);
  defineCol();
  rect(x,minY,x1,y);
  defineCol();
  rect(minX,y,x,y1);
  defineCol();
  rect(x,y,x1,y1);

  while(x < maxX - 50 && y < maxY - 50){
    x = x1;
    y = y1;
    x1 = random(x1+100, maxX-100);
    y1 = random(y1+100, maxY-100);
    defineCol();
    rect(x,y,x1,y1);
    defineCol();
    rect(x,minY,x1,y);
    defineCol();
    rect(minX,y,x,y1);
    defineCol();
    rect(x,y,x1,y1);
  }
}

void coverUp(){
  line(width,0,width,height);
  line(0,height, width,height);
}
