int sqr = 10;
int wth = sqr;
int hgt = sqr;
boolean won = false;
boolean canEnd = false;
int[] pos; // 0 is x, 1 is y
int[] pos2;
int [][] lv;
int [][] relv;
int [] end;
int [] end2;
int [] beg;
int [] beg2;
boolean twoPlayer = false;
int score=0;
int hiscore = 0;

void setup(){
  size(600,600);
  smooth();
  background(255);
  lv = new int[wth][hgt];
  relv = new int[wth][hgt];
  pos = new int[2];
  pos2 = new int[2];
  end = new int[2];
  end2 = new int[2];
  beg = new int[2];
  beg2 = new int[2];
  newBoard();
}

void draw(){
  background(255);
  if(won){
    drawWin();
  } else {
    drawBoard();
    restartButton();
    twoPlayerButton();
    help();
  }
  drawScore();
}

void twoPlayerButton(){
  if(mouseX < 100 && mouseX > 0 && mouseY < 100 && mouseY > 0)
    fill(0,255,255);
  else
    fill(255,255,0);
  rect(0,0,100,100);
  textAlign(CENTER);
  fill(0);
  textSize(11);
  if(!twoPlayer){
    text("TwoPlayerMode", 50,50);
  }
  else{
    text("OnePlayerMode", 50,50);
  }
}

void help(){
  if(!twoPlayer){
    stroke(0);
    fill(0);
    textSize(15);
    textAlign(CENTER);
    String a = "Use arrow keys to get";
    text(a,width/2, height - 75);
    fill(255,0,255);
    rect(width/2+textWidth(a)/2 + 10,height - 90, 20,20);
    fill(0);
    String b = "to ";
    text(b, width/2, height - 25);
    fill(0,255,0);
    rect(width/2 + textWidth(b)/2 + 10, height - 40, 20,20);
  } else{
    stroke(0);
    fill(0);
    textSize(11);
    textAlign(CENTER);
    String a = "Use arrow keys to get";
    text(a,width/3, height - 75);
    fill(255,0,255);
    rect(width/3+textWidth(a)/2 + 10,height - 90, 20,20);
    fill(0);
    String b = "to ";
    text(b, width/3, height - 25);
    fill(0,255,0);
    rect(width/3 + textWidth(b)/2 + 10, height - 40, 20,20);
    
    fill(0);
    line(width/2,height-100, width/2, height);
    
    stroke(0);
    fill(0);
    textAlign(CENTER);
    a = "And use WASD keys to get";
    text(a,2*width/3-20, height - 75);
    fill(100,255,150);
    rect(2*width/3+textWidth(a)/2 - 10,height - 90, 20,20);
    fill(0);
    b = "to ";
    text(b, 2*width/3-20, height - 25);
    fill(255);
    rect(2*width/3 + textWidth(b)/2 - 10, height - 40, 20,20);
  }
}

void mouseClicked(){
  if(mouseX < 100 && mouseX > 0 && mouseY < 100 && mouseY > 0){
    twoPlayer = !twoPlayer;
    if(twoPlayer)
      newTwoBoard();
    else
      newBoard();
    score = 0;
  }
  else if(mouseX > width-100 && mouseX <width && mouseY > height-100 && mouseY < height){
    for(int x = 0; x < wth; x++){
      for(int y = 0; y < hgt; y++){
        lv[x][y] = relv[x][y];
        pos[0] = beg[0];
        pos[1] = beg[1];
        pos2[0] = beg2[0];
        pos2[1] = beg2[1];
      }
    }
    score = 0;
  }
}

void drawScore(){
  fill(0);
  stroke(0);
  textSize(32);
  textAlign(CENTER);
  text("Score: " + score, width/2, 75);
  textAlign(LEFT);
  textSize(20);
  text("High Score: " + hiscore, 20, height - 25);
}

void newBoard(){
  lv = new int[wth][hgt];
  relv = new int[wth][hgt];
  int[] maker = new int[2];
  for(int x = 0; x < wth; x++){
    for(int y = 0; y < hgt; y++){
      lv[x][y] = 0;
    }
  }
  maker[0]=floor(random(1,wth-1.1));
  maker[1]=floor(random(1,hgt-1.1));
  pos[0] = maker[0];
  pos[1] = maker[1];
  beg[0] = pos[0];
  beg[1] = pos[1];
  lv[pos[0]][pos[1]] = 3;
  int steps = 0;
  while(steps <= 50){//maker[0]!=wth-2 && maker[1]!=hgt-2){   
    boolean canGoUp, canGoDown, canGoLeft, canGoRight;
    if(maker[0]<wth - 2) 
      canGoRight = lv[maker[0]+1][maker[1]] == 0;
    else
      canGoRight = false;
    
    if(maker[0]>1)
      canGoLeft = lv[maker[0]-1][maker[1]] == 0;
    else
      canGoLeft = false;
    
    if(maker[1] > 1)
      canGoUp = lv[maker[0]][maker[1]-1] == 0;
    else
      canGoUp = false;
    
    if(maker[1] < hgt - 2)
      canGoDown = lv[maker[0]][maker[1]+1] == 0;
    else
      canGoDown = false;
    
    int numDirs=0;
    if(canGoRight)
      numDirs++;
    if(canGoLeft)
      numDirs++;
    if(canGoUp)
      numDirs++;
    if(canGoDown)
      numDirs++;
    int soFar = 0;
    int seed = floor(random(0,numDirs+1));
    
    //if surrounded, done
    if(numDirs == 0){
       lv[maker[0]][maker[1]] = 4;
       steps = 51;
    } else if(canGoRight && seed == soFar++){
       maker[0]++;
       lv[maker[0]][maker[1]] = 1;
    } else if(canGoLeft && seed == soFar++){
       maker[0]--;
       lv[maker[0]][maker[1]] = 1;
    } else if(canGoUp && seed == soFar++){
       maker[1]--;
       lv[maker[0]][maker[1]] = 1;
    } else if(canGoDown && seed == soFar){
      maker[1]++; 
      lv[maker[0]][maker[1]] = 1;
    }
  }
  end[0] = maker[0];
  end[1] = maker[1];
  for(int x = 0; x < wth; x++){
    for(int y = 0; y < hgt; y++){
      relv[x][y] = lv[x][y];
    }
  }
}

void newTwoBoard(){
  lv = new int[wth][hgt];
  relv = new int[wth][hgt];
  int[] maker = new int[2];
  int[] maker2 = new int[2];
  for(int x = 0; x < wth; x++){
    for(int y = 0; y < hgt; y++){
      lv[x][y] = 0;
    }
  }
  maker[0]=floor(random(1,wth-1.1));
  maker2[0] = floor(random(1,wth-1.1));
  maker[1]=floor(random(1,hgt-1.1));
  maker2[1] = floor(random(1,wth-1.1));
  if(maker[0]==maker2[0])
    maker2[0] = (maker[0]+3)%wth;
  if(maker[1]==maker2[1])
    maker2[1] = (maker[1]+3)%hgt;
  pos[0] = maker[0];
  pos[1] = maker[1];
  pos2[0] = maker2[0];
  pos2[1] = maker2[1];
  beg[0] = pos[0];
  beg[1] = pos[1];
  beg2[0] = pos2[0];
  beg2[1] = pos2[1];
  lv[pos[0]][pos[1]] = 3;
  lv[pos2[0]][pos2[1]] = 5;
  boolean searching = true;
  boolean searching2 = true;
  while(searching || searching2){
      boolean canGoUp, canGoDown, canGoLeft, canGoRight, canGoUp2, canGoDown2, canGoLeft2, canGoRight2;
      int numDirs=0;
      int numDirs2=0;
      
      if(searching){
        if(maker[0]<wth - 2) 
          canGoRight = lv[maker[0]+1][maker[1]] == 0;
        else
          canGoRight = false;
        
        if(maker[0]>1)
          canGoLeft = lv[maker[0]-1][maker[1]] == 0;
        else
          canGoLeft = false;
        
        if(maker[1] > 1)
          canGoUp = lv[maker[0]][maker[1]-1] == 0;
        else
          canGoUp = false;
          
        if(maker[1] < hgt - 2)
          canGoDown = lv[maker[0]][maker[1]+1] == 0;
        else
          canGoDown = false;
        
        if(canGoRight)
          numDirs++;
        if(canGoLeft)
          numDirs++;
        if(canGoUp)
          numDirs++;
        if(canGoDown)
          numDirs++;
  
        int soFar = 0;
        int seed = floor(random(0,numDirs+1));
        //if surrounded, done
        if(numDirs == 0){
           lv[maker[0]][maker[1]] = 4;
           searching = false;
        } else if(canGoRight && seed == soFar++){
           maker[0]++;
           lv[maker[0]][maker[1]] = 1;
        } else if(canGoLeft && seed == soFar++){
           maker[0]--;
           lv[maker[0]][maker[1]] = 1;
        } else if(canGoUp && seed == soFar++){
           maker[1]--;
           lv[maker[0]][maker[1]] = 1;
        } else if(canGoDown && seed == soFar){
          maker[1]++; 
          lv[maker[0]][maker[1]] = 1;
        }
      end[0] = maker[0];
      end[1] = maker[1];
    
    }
    
    if(searching2){
      if(maker2[1] > 1 && lv[maker[0]][maker[1]] != lv[maker2[0]][maker[1]-1])
        canGoUp2 = lv[maker2[0]][maker2[1]-1] == 0;
      else
        canGoUp2 = false;
      
  
      if(maker2[1] < hgt - 2 && lv[maker[0]][maker[1]] != lv[maker2[0]][maker[1]+1])
        canGoDown2 = lv[maker2[0]][maker2[1]+1] == 0;
      else
        canGoDown2 = false;
        
      if(maker2[0]>1 && lv[maker[0]][maker[1]] != lv[maker2[0]-1][maker[1]])
        canGoLeft2 = lv[maker2[0]-1][maker2[1]] == 0;
      else
        canGoLeft2 = false;
        
      if(maker2[0]<wth - 2 && lv[maker[0]][maker[1]] != lv[maker2[0]+1][maker[1]]) 
        canGoRight2 = lv[maker2[0]+1][maker2[1]] == 0;
      else
        canGoRight2 = false;

      if(canGoRight2)
        numDirs2++;
      if(canGoLeft2)
        numDirs2++;
      if(canGoUp2)
        numDirs2++;
      if(canGoDown2)
        numDirs2++;
        
      int soFar2 = 0;
      int seed2 = floor(random(0,numDirs+1));
        //if surrounded, done
      if(numDirs2 == 0){
         lv[maker2[0]][maker2[1]] = 6;
         searching2 = false;
      } else if(canGoRight2 && seed2 == soFar2++){
           maker2[0]++;
           lv[maker2[0]][maker2[1]] = 1;
      } else if(canGoLeft2 && seed2 == soFar2++){
           maker2[0]--;
           lv[maker2[0]][maker2[1]] = 1;
      } else if(canGoUp2 && seed2 == soFar2++){
           maker2[1]--;
           lv[maker2[0]][maker2[1]] = 1;
      } else if(canGoDown2 && seed2 == soFar2){
          maker2[1]++; 
          lv[maker2[0]][maker2[1]] = 1;
      }
      end2[0] = maker2[0];
      end2[1] = maker2[1];
    }
  }
  for(int x = 0; x < wth; x++){
    for(int y = 0; y < hgt; y++){
      relv[x][y] = lv[x][y];
    }
  }
}
void restartButton(){
  if(mouseX > width-100 && mouseX <width && mouseY > height-100 && mouseY < height){
    fill(255,0,255);
    rect(width-100, height-100, 100,100);
    fill(0);
    textSize(11);
    textAlign(CENTER);
    text("Are you sure?", width-50, height-75);
    text("score -> 0", width - 50, height - 25);
  } else{
    fill(255,255,0);
    rect(width-100, height-100, 100,100);
    fill(0);
    textSize(11);
    textAlign(CENTER);
    text("Click To Restart", width-50, height-75);
    text("score will be reset", width - 50, height - 25);
  }
  drawScore();
}

void drawBoard(){
  for(int x = 0; x < wth; x ++){
    for(int y = 0; y < hgt; y ++){
      if(lv[x][y] == 0){
        //Wall Stuff
        fill(0);
      } else if(lv[x][y] == 1){
        //Untouched Path
        fill(255,0,0);
      } else if(lv[x][y] == 2){
        //Touched Path
        fill(0,0,255);
      } else if(lv[x][y] == 3){
        //Player
        fill(255,0,255);
      } else if(lv[x][y] == 4){
        //End Square
        fill(0,255,0);
      } else if(lv[x][y] == 5){
        //Player 2
        fill(100,255,150);
      } else if(lv[x][y] == 6){
        //End Square 2
        fill(255,255,255);
      }
      float xrect = map(x, 0, wth-1, 100, width-150);
      float yrect = map(y, 0, hgt-1, 100, height-150);
      rect(xrect,yrect,50,50);
    }
  }
}

void checkWin(){
  boolean checkTiles = true;
  for(int x = 0; x < wth; x ++){
    for(int y = 0; y < hgt; y ++){
      checkTiles &= lv[x][y] != 1;
    }
  }
  canEnd = checkTiles;
  boolean checkProx;
  if(twoPlayer)
    checkProx = ((end[0] == pos[0] && end[1] == pos[1]) && (end2[0] == pos2[0] && end2[1] == pos2[1]));
  else
    checkProx = (end[0] == pos[0] && end[1] == pos[1]);
    
  if(twoPlayer)
    won = canEnd && checkProx;
  else
    won = checkTiles && checkProx;
}

void drawWin(){
  background(0);
  fill(255);
  //textAlign(CENTER);
  String a ="You won. Press SPACE for next level!"; 
  text(a, width/2-textWidth(a)/2, height/2);
}

void keyPressed(){
  if(keyCode == LEFT){
    if(pos[0]>0){
      if(lv[pos[0]-1][pos[1]] == 1 || (canEnd && lv[pos[0]-1][pos[1]] == 4)){
        lv[pos[0]][pos[1]] = 2;
        pos[0] -= 1;
        lv[pos[0]][pos[1]] = 3;
      }
    }
  } else if (keyCode == RIGHT) {
    if(pos[0]<wth-1){
      if(lv[pos[0]+1][pos[1]] == 1 || (canEnd && lv[pos[0]+1][pos[1]] == 4)){
        lv[pos[0]][pos[1]] = 2;
        pos[0] += 1;
        lv[pos[0]][pos[1]] = 3;
      }
    }
  } else if (keyCode == DOWN) {
    if(pos[1]<hgt-1){
      if(lv[pos[0]][pos[1]+1] == 1 || (canEnd && lv[pos[0]][pos[1]+1] == 4)){
        lv[pos[0]][pos[1]] = 2;
        pos[1] += 1;
        lv[pos[0]][pos[1]] = 3;
      }
    }
  } else if (keyCode == UP) {
    if(pos[1]>0){
      if(lv[pos[0]][pos[1]-1] == 1 || (canEnd && lv[pos[0]][pos[1]-1] == 4)){
        lv[pos[0]][pos[1]] = 2;
        pos[1] -= 1;
        lv[pos[0]][pos[1]] = 3;
      }
    }
  } if(key == 'a'){
    if(pos2[0]>0){
      if(lv[pos2[0]-1][pos2[1]] == 1 || (canEnd && lv[pos2[0]-1][pos2[1]] == 6)){
        lv[pos2[0]][pos2[1]] = 2;
        pos2[0] -= 1;
        lv[pos2[0]][pos2[1]] = 5;
      }
    }
  } else if (key == 'd') {
    if(pos2[0]<wth-1){
      if(lv[pos2[0]+1][pos2[1]] == 1 || (canEnd && lv[pos2[0]+1][pos2[1]] == 6)){
        lv[pos2[0]][pos2[1]] = 2;
        pos2[0] += 1;
        lv[pos2[0]][pos2[1]] = 5;
      }
    }
  } else if (key == 's') {
    if(pos2[1]<hgt-1){
      if(lv[pos2[0]][pos2[1]+1] == 1 || (canEnd && lv[pos2[0]][pos2[1]+1] == 6)){
        lv[pos2[0]][pos2[1]] = 2;
        pos2[1] += 1;
        lv[pos2[0]][pos2[1]] = 5;
      }
    }
  } else if (key == 'w') {
    if(pos2[1]>0){
      if(lv[pos2[0]][pos2[1]-1] == 1 || (canEnd && lv[pos2[0]][pos2[1]-1] == 6)){
        lv[pos2[0]][pos2[1]] = 2;
        pos2[1] -= 1;
        lv[pos2[0]][pos2[1]] = 5;
      }
    }
  }
  
  else if (key == ' '){
    if(won){
      won = false;
      if(twoPlayer)
        newTwoBoard();
      else
        newBoard();
      score++;
      if(score > hiscore)
        hiscore = score;
    }
  }
  else if( key == 'r'){
    score = 0;
    if(twoPlayer)
      newTwoBoard();
    else
      newBoard();
  }
  checkWin();
}
