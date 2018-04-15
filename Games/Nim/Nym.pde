int[] stacks;
int[] defaults;

int numCols = 5;

int ceiling = 5; // The highest number of coins in a stack

boolean testing = false;

boolean player1 = true;
boolean player2 = false;

boolean gameconstructed = false;

boolean constructgame = false;
boolean endgame = false;
boolean maingame = true;



void setup(){
  size(1000,600);
  reset();
}

int stack = 0;
int coin = 0;

void draw(){
  background(0);
  stroke(0);
  if(maingame)
    mainGameScreen();
  else if(endgame)
    endGameScreen();
  else if(constructgame)
    constructGameScreen();
}

void mouseClicked(){
  if(maingame) takeCoins(stack, coin);
  else if(constructgame) stackCoins(stack,coin);
  
  boolean cleared = true;
  for(int i = 0; i < stacks.length; i++)
    cleared &= stacks[i]==0;
  if(cleared){
    maingame = false;
    endgame = true;
    constructgame = false;
  }
  player1 = player1 == false;
  player2 = player2 == false;
}

void keyPressed(){
  if(key == ' '){
    maingame = true;
    endgame = false;
    constructgame = false;
    reinitializeStacks();
  }
  else if(key == 'c'){
    for(int i = 0; i < numCols; i++){
      defaults[i] = 0;
    }
    gameconstructed = true;
    constructgame = true;
    endgame = false;
    maingame = false;
  }
  else if(key == 'q'){
    gameconstructed = false;
    constructgame = false;
    endgame = false;
    maingame = true;
  }
  else if(keyCode == LEFT){
    if(numCols >2) numCols--;
    reset();
  }
  else if(keyCode == RIGHT){
    numCols++;
    reset();
  }
  else if(keyCode == UP){
    ceiling++;
    reset();
  }
  else if(keyCode == DOWN){
    if(ceiling >2) ceiling --;
    reset();
  }
}

void reinitializeStacks() {
  player1 = true;
  player2 = false;
  maingame = true;
  endgame = false;
  constructgame = false;
  if(!gameconstructed){
    for(int i = 0; i < stacks.length; i++){
      if(!testing)
        stacks[i] = floor(random(0, ceiling+0.99));
      else
        stacks[i] = ceiling;
    }
  }
  else{
    for(int i = 0; i < stacks.length; i++){
      stacks[i] = defaults[i];
    }
    //stacks = defaults.clone(); // .CLONE()
  }
}

void reset(){
  stacks = new int[numCols];
  defaults = new int[numCols];
  player1 = true;
  player2 = false;
  maingame = true;
  endgame = false;
  constructgame = false;
  gameconstructed = false;

  for(int i = 0; i < stacks.length; i++){
    if(!testing)
      stacks[i] = floor(random(0, ceiling+0.99));
    else
      stacks[i] = ceiling;
  }
}

void takeCoins(int stack, int coin){
  stacks[stack] = coin;
}

void stackCoins(int stack, int coin){
  defaults[stack] = coin;
}

void endGameScreen(){
  textAlign(CENTER);
  textSize(72);
  if(player1){
    text("Player 1 Wins!", width/2, height/2);
  } else if(player2){
    text("Player 2 Wins!", width/2, height/2);
  }
  textSize(32);
  text("Press spacebar to play again", width/2, height*2/3);
}

void constructGameScreen(){
  stroke(255);
  for(int i = 0; i < defaults.length; i++){
    for(int j = 0; j < ceiling; j++){
      fill(255);
      float xpos = map(i,0,stacks.length-1, 0, width-width/numCols);
      float ypos = map(j,0,ceiling-1,height-height/ceiling,0);
      if(defaults[i]<j+1)
        fill(0);
      if(mouseY < ypos + height/ceiling){
        if(mouseX > xpos && mouseX < xpos+width/numCols){          
          fill(0,255,255);
          if(mouseY > ypos){
            coin = j+1;
            stack = i;
          }
        }
      }
      rectMode(CORNER);
      rect(xpos,ypos,
           width/numCols, height/ceiling);
    }
  }
}

void mainGameScreen(){
   for(int i = 0; i < stacks.length; i++){
    for(int j = 0; j < ceiling; j++){
      fill(255);
      float xpos = map(i,0,stacks.length-1, 0, width-width/numCols);
      float ypos = map(j,0,ceiling-1,height-height/ceiling,0);
      if(j<stacks[i]){
        fill(255,0,0);
        if(mouseY > ypos){
          if(mouseX > xpos && mouseX < xpos+width/numCols){
            if(player1)
              fill(0,100,255);
            else if(player2)
              fill(0,255,100);
            if(mouseY < ypos + height/ceiling){
              coin = j;
              stack = i;
            }
          }
        }
      }
      rectMode(CORNER);
      rect(xpos,ypos,
           width/numCols, height/ceiling);
    }
  }
}