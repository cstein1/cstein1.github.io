import controlP5.*;

// Last thing to do is to make the combined tree a new tree. But that can wait until after presentation etc...

ControlP5 cp5;
String textValue = "";
Textfield TreeA, TreeB, Order;
boolean reducedA = false,reducedB=false;

void settings(){
  size(1400, 800);
}

void setup() {
  PFont font = createFont("comic sans",20);

  cp5 = new ControlP5(this);

  TreeB = cp5.addTextfield("Tree B")
     .setPosition(width*2/3,height*2/3)
     .setSize(width/3-10,30)
     .setFont(font)
     .setFocus(true)
     .setAutoClear(false)
     ;

  TreeA = cp5.addTextfield("Tree A")
     .setPosition(width*2/3,height/3)
     .setSize(width/3-10,30)
     .setFont(font)
     .setAutoClear(false)
     ;

  cp5.addBang("ReduceTreeA")
     .setPosition(width*2/3,height/3-height/6+height/9)
     .setSize(80,40)
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
     ;

   cp5.addBang("ReduceTreeB")
     .setPosition(width*2/3,height/3+height/6+height/9)
     .setSize(80,40)
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
     ;

  cp5.addBang("OrJoin")
     .setPosition(width*2/3,height-80)
     .setSize(80,40)
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
     ;
  cp5.addBang("AndJoin")
     .setPosition(width*2/3+100,height-80)
     .setSize(80,40)
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
     ;
  cp5.addBang("XorJoin")
     .setPosition(width*2/3+200,height-80)
     .setSize(80,40)
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
     ;
  cp5.addBang("ImpliesJoin")
     .setPosition(width*2/3+300,height-80)
     .setSize(80,40)
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
     ;

  Order = cp5.addTextfield("Order")
     .setPosition(width*2/3,height/3+height/6)
     .setSize(width/3-10,30)
     .setFont(font)
     .setAutoClear(false)
     ;

  textFont(font);

  String bfa = "(z&x)|(z&!x&y)";//"x||!x";//"(!x&!y&z)|(!x&y&!z)|(x&!y&!z)|(x&y&z)";//
  String bfb = "x&y&z";//"(x||!x)&&(y||!y)&&z";


  parsedA = new BoolFun(bfa);
  parsedB = new BoolFun(bfb);

  treeA = new Tree(parsedA, true);
  treeB = new Tree(parsedB, false);

  loading = false;

  TreeA.setText(bfa);
  TreeB.setText(bfb);

  Order.setText(String.valueOf(parsedA.invars));
  Order.setText(String.valueOf(parsedB.invars));
  change(bfa,bfb,"x");
}

BoolFun parsedA, parsedB;
Tree treeA, treeB;
boolean loading, working;

void draw() {
  background(0);
  text("Press Enter to reset image and ", width*2/3,50);
  text("to input information into boxes", width*2/3,80);
  fill(255,0,0);
  float[] gaps = {10};
  text("Bottom",width*2/3,110);
  dashline(width*2/3+75,105,width*2/3+120,105, gaps);
  fill(0,100,255);
  stroke(0,100,255);
  text("Top",width*2/3,135);

  if(treeA.trns) {
    fill(255);
    text("TREEA",width/3-width/6-35-textWidth("TreeA"),50);
    text("TREEB",width/3+width/6+35,50);
  }


  line(width*2/3+75,130,width*2/3+120,130);
  fill(255);
  if(!loading){
    working = true;
    if(treeB.trns) treeA.display();
    if(treeA.trns) treeB.display();
    working = false;
  }
  else{
    displayError();
  }
}

void displayError(){
    text("Something Went Wrong",width/4-200,height/2);
    text("Make sure that the following are true:",width/4-200,height/2+20);
    text("1) Variable names are a single letter long (case-sensitive)",width/4-200+50,height/2+40);
    text("2) You are using the available operations in the correct way (!, &&, ||)",width/4-200+50,height/2+60);
    text("3) Both formulas have the same variables",width/4-200+50,height/2+80);
}

void change(String newFunA, String newFunB, String _Order){
  loading = true;
  if(!working){

    if(newFunA.trim().length() != 0 && newFunB.trim().length() != 0){
      parsedA = new BoolFun(newFunA);
      parsedB = new BoolFun(newFunB);


      String tmp = _Order;
      String tmp1 = _Order;

      for(char i : parsedA.invars){
        if(tmp.indexOf(i) < 0) {
          tmp += i;
        }
      }
      parsedA.invars = tmp.toCharArray();


      for(char i : parsedB.invars){
        if(tmp1.indexOf(i) < 0) tmp1 += i;
      }
      parsedB.invars = tmp1.toCharArray();

      treeA = new Tree(parsedA, true);
      treeB = new Tree(parsedB, false);
      Order.setText(SetAdd(parsedB.invars,parsedA.invars));
    }

    if(newFunA.trim().length() != 0)
    {
      parsedA = new BoolFun(newFunA);
      if(_Order.length() == parsedA.invars.length) parsedA.invars = _Order.toCharArray();
      else Order.setText(String.valueOf(parsedA.invars));
      treeA = new Tree(parsedA, true);
    } else {
      treeB.trns = false;
      treeB.Center();
    }

    if(newFunB.trim().length() != 0)
    {
      parsedB = new BoolFun(newFunB);
      if(_Order.length() == parsedB.invars.length) parsedB.invars = _Order.toCharArray();
      else Order.setText(String.valueOf(parsedB.invars));
      treeB = new Tree(parsedB, false);
    } else {
      treeA.trns = false;
      treeA.Center();
    }
  }
  loading = false;
}

void keyPressed(){
  if(key == ENTER){
    enterpress();
  }
}

void enterpress(){
    try{
      change(TreeA.getText(), TreeB.getText(), Order.getText());
    } catch (IndexOutOfBoundsException e){
      displayError();
    } catch (NullPointerException e){
      displayError();
    }
    treeA.Prep(Order.getText());
    treeB.Prep(Order.getText());
    reducedA = false;
    reducedB = false;
}



public void ReduceTreeB(){
  if(reducedB) {return;}
  try{
    treeB.Reduce();
  } catch (IndexOutOfBoundsException e){
    text("SOMETHING WENT WRONG WHEN TRYING TO REDUCE TREE B.",width/2,height/2);
  }
  reducedB = true;
}

public void ReduceTreeA(){
  if(reducedA) {return;}
  try{
    treeA.Reduce();
    //treeA.Print();
  } catch (IndexOutOfBoundsException e){
    text("SOMETHING WENT WRONG WHEN TRYING TO REDUCE TREE A.",width/2,height/2);
  }
  reducedA = true;
}

public void OrJoin(){
  enterpress();
  treeA.Prep(Order.getText());
  treeB.Prep(Order.getText());
  treeA.JoinOr(treeB);
}

public void AndJoin(){
  enterpress();
  treeA.Prep(Order.getText());
  treeB.Prep(Order.getText());
  treeA.JoinAnd(treeB);
}

public void XorJoin(){
  enterpress();
  treeA.Prep(Order.getText());
  treeB.Prep(Order.getText());
  treeA.JoinXor(treeB);
}

public void ImpliesJoin(){
  enterpress();
  treeA.Prep(Order.getText());
  treeB.Prep(Order.getText());
  treeA.JoinImplies(treeB);
}

String SetAdd(String a, String b){
  char[] ret = new char[a.length()];
  arrayCopy(a.toCharArray(),ret);
  for(char i : b.toCharArray()){
    if(a.indexOf(i) < 0){
      ret = append(ret, i);
    }
  }
  return String.valueOf(ret);
}

String SetAdd(char[] a, char[] b){
  return SetAdd(String.valueOf(a),String.valueOf(b));
}


// BoolFun.pde
