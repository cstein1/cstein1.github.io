// TODO One level extra being calculated

class Tree {
  Node root;
  BoolFun bf;
  Boolean treea; //Tree A or tree B
  PVector leaf0; // false node
  PVector leaf1; // true node
  boolean trns; // If transitioning

  Tree(BoolFun _bf, Boolean _treea) {
    trns = true;
    treea = _treea;
    bf = _bf;
    leaf1 = new PVector(width*2/3-50, height-40);
    leaf0 = new PVector(50, height-40);

    root = new Node();
    if (bf.numvars != 1) {
      ConnectTree(root);
    } else if (bf.numvars == 1) {
      boolean[] b = {true};
      boolean[] c = {false};
      root.pos = new PVector(width/3, 10);
      boolean rightval = bf.evaluate(b);
      boolean leftval = bf.evaluate(c);
      root.right = new Node(bf.evaluate(b), b, rightval?leaf1:leaf0); 
      root.left = new Node(bf.evaluate(c), c, leftval?leaf1:leaf0);
    }
  }

  void ConnectTree(Node root) {
    MakeLevels(0, root, 0);
  }

  void MakeLevels(int level, Node root, float col) {          
    float hgt = map(level, 0, bf.numvars, 10, height-50);
    float wdt;
    if (trns) {
      wdt = map(col, -1, 1, 10, width*2/3);
    } else  wdt = map(col, -.5, .5, 10, width*2/3);
    if (trns) {
      if (treea) {
        wdt -= width/6;
      } else {
        wdt += width/6;
      }
    }
    root.pos = new PVector(wdt, hgt);
    if (level < bf.numvars-1) {
      if (level==0) {
        boolean[] b = {true};
        root.right = new Node(b, new PVector());
        boolean[] c = {false};
        root.left = new Node(c, new PVector());
      } else {
        boolean[] b = CopyPath(root.path);
        boolean[] c = CopyPath(root.path);
        b[level] = true;
        root.right = new Node(b, new PVector()); 
        c[level] = false;
        root.left = new Node(c, new PVector());
      }
      if (col == 0) {
        MakeLevels(level+1, root.right, 1.0/4);
        MakeLevels(level+1, root.left, -1.0/4);
      } else {
        float mv;
        if (trns) mv = 1.0/pow(3.0, level+1);
        else mv = 1.0/pow(2.0, level+2);
        MakeLevels(level + 1, root.right, col+mv);
        MakeLevels(level + 1, root.left, col-mv);
      }
    } else { // If we are looking at a leaf!
      boolean[] b = CopyPath(root.path);
      boolean[] c = CopyPath(root.path);
      b[level]= true;//PrintArr(2,b);
      root.right = new Node(bf.evaluate(b), b, new PVector());
      if (root.right.lit) root.right.pos = leaf1;
      else root.right.pos = leaf0;
      c[level] = false;//PrintArr(2,b);
      root.left = new Node(bf.evaluate(c), c, new PVector()); 
      if (root.left.lit) root.left.pos = leaf1;
      else root.left.pos = leaf0;
    }
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

  void Prep(String newinvars){
    //boolean subsume = true;
    //String miss = "";
    //for(int i = 0; i<newinvars.length();i++){
    //  subsume &= newinvars.indexOf(bf.invars[i])>0;
    //  miss = SetAdd(miss, str(newinvars.indexOf(bf.invars[i])));
    //}

    //if(subsume && newinvars.length() > bf.invars.length){
    //  bf.infun = "("+bf.infun+")";
    //  for(int i = 0; i < miss.length(); i++){
    //    bf.infun += "&("+miss.charAt(i)+"\\|"+miss.charAt(i)+")";
    //  }
    //  bf.invars = newinvars.toCharArray();
    //}
  }

  void Relevel() {
    PlaceLevels(0, root, 0);
  }

  void PlaceLevels(int level, Node root, float col) {
    float hgt = map(level, 0, bf.numvars, 10, height-50);
    float wdt;
    if (trns) {
      wdt = map(col, -1, 1, 10, width*2/3);
    } else  wdt = map(col, -.5, .5, 10, width*2/3);
    if (trns) {
      if (treea) {
        wdt -= width/6;
      } else {
        wdt += width/6;
      }
    }
    root.pos = new PVector(wdt, hgt);
    if (level < bf.numvars-1) {
      if (col == 0) {
        PlaceLevels(level+1, root.right, 1.0/4);
        PlaceLevels(level+1, root.left, -1.0/4);
      } else {
        float mv;
        if (trns) mv = 1.0/pow(3.0, level+1);
        else mv = 1.0/pow(2.0, level+2);
        PlaceLevels(level + 1, root.right, col+mv);
        PlaceLevels(level + 1, root.left, col-mv);
      }
    }
  }

  void display() {
    rectMode(CENTER);
    noStroke();
    fill(0, 125, 255);
    rect(leaf1.x, leaf1.y, 50, 50);
    fill(255, 0, 0);
    rect(leaf0.x, leaf0.y, 50, 50);

    noStroke();
    fill(100, 150, 100);
    ellipse(root.pos.x, root.pos.y, 30, 30);
    fill(200, 0, 77);
    textSize(20);
    text(bf.invars[0], root.pos.x-5, root.pos.y+15);

    displayTree(root.right, root);
    displayTree(root.left, root);
  }

  void displayTree(Node in, Node parent) { // what is happening?
    //if(bf.numvars == 1){
    //  if(trns) {
    //    if(treea) parent.pos = new PVector(width/3-width/6, 10);
    //    else      parent.pos = new PVector(width/3+width/6, 10);
    //  } else {
    //    parent.pos = new PVector(width/3, 10);
    //  }
    //}
    if (in.moving) {
      println("moving");
    } else {
      if (!in.leaf) {
        noStroke();
        fill(100, 150, 100);
        //in.printboolarr();
        ellipse(in.pos.x, in.pos.y, 30, 30);
        fill(200, 0, 77);
        textSize(20);
        text(bf.invars[in.path.length], in.pos.x-5, in.pos.y+10);
        stroke(255);
        if (in.path[in.path.length-1]) {
          line(parent.pos.x, parent.pos.y, in.pos.x, in.pos.y);
        } else {
          float[] gaps = {10};
          dashline(parent.pos.x, parent.pos.y, in.pos.x, in.pos.y, gaps);
        }
        displayTree(in.right, in);
        displayTree(in.left, in);
      } else {
        if (!in.path[in.path.length-1]) {
          stroke(255, 0, 0);
          noFill();
          float[] gaps = {10};
          dashline(parent.pos.x, parent.pos.y, in.pos.x, in.pos.y, gaps);
        } else {
          stroke(0, 125, 255);
          noFill();
          line(parent.pos.x, parent.pos.y, in.pos.x, in.pos.y);
        }
      }
    }
  } 

  void Reduce() {
    
    ReduceWidthTree(root.left, root, root.right, root);//ReduceWidthTreedeb(root.left, root, root.right, root, "","");
    for(int i = 0; i<bf.numvars;i++){
      ReduceHeightTreeStarter(root);
    }

    println("________");
  } 

  void ReduceWidthTree(Node in, Node inpar, Node comp, Node comppar) {
    if (in.leaf && comp.leaf) {
      if (inpar.left.lit == comppar.left.lit && inpar.right.lit == comppar.right.lit) {
        inpar.pos = comppar.pos;
        inpar.left = comppar.left;
        inpar.right= comppar.right;
      }
    } else if (!in.leaf && !comp.leaf) {
      if (in.Same(comp)) {
        FoundSameW(in, inpar, comp);
        println("yes");
      }
      ReduceWidthTree(in.right, in, comp.right, comp);   
      ReduceWidthTree(in.left, in, comp.right, comp);
      ReduceWidthTree(in.left, in, comp.left, comp);
      ReduceWidthTree(in.right, in, comp.left, comp);
      ReduceWidthTree(in.left, in, in.right, in);
      ReduceWidthTree(comp.left, comp, comp.right, comp);
    }
  }

  void FoundSameW(Node in, Node inpar, Node comp) {
    FoundSameWHelper(in, comp);
    //if(in.path[in.path.length-1]) inpar.right.pos = comp.right.pos;
    //else inpar.left.pos = comp.pos;
  }

  void FoundSameWHelper(Node in, Node comp) {
    if (!in.leaf) {
      FoundSameWHelper(in.left, comp.left);
      FoundSameWHelper(in.right, comp.right);
      in.right = comp.right;
      in.left = comp.left;
    }
  }

  void ReduceHeightTreeStarter(Node in) {
    if (!in.leaf) {
      if (in.left.Same(in.right)) {
        FoundSameH(in);
      }
      ReduceHeightTree(in.left, in);
      ReduceHeightTree(in.right, in);
    } else {
    }
  }

  void ReduceHeightTree(Node in, Node parent) {
    if (!in.leaf) {
      ReduceHeightTree(in.left, in);
      ReduceHeightTree(in.right, in);
      if (in.left.Same(in.right)) {
        FoundSameH(in);
      }
    } else {
      if (parent.left.leaf && parent.right.leaf) {
        if (parent.left.lit == parent.right.lit) {
          parent.pos = in.pos;
          parent.leaf = true;
          //parent.path = CopyPath(in.path);
          parent.lit = in.lit;
        }
      }
    }
  }



  void FoundSameH(Node in) {
    if (in.left.leaf && in.right.leaf) {
      if (in.left.lit && in.right.lit) {
        in.leaf = true;
        in.lit = in.left.lit;
        in.pos = in.left.pos;
      }
    } else {
      in.left = in.left.left;
      in.right = in.right.right;
    }
    /*if(!in.left.leaf&&!in.right.leaf){
     FoundSameH(in.left);
     FoundSameH(in.right);
     }
     in.pos = comp.pos;
     in.right = comp.right;
     in.left = comp.left;*/
  }

  boolean[] CopyPath(boolean[] a) {
    boolean[] b = new boolean[a.length + 1];
    for (int i = 0; i < a.length; i++) {
      b[i] = a[i];
    }
    return b;
  }

  void JoinOr(Tree intree) {
    JoinOrHelper(intree.root, root);
    trns = false;
    Relevel();
  }

  void JoinOrHelper(Node inroot, Node node) {
    if (inroot.leaf && node.leaf) {// THEY SHOULD BOTH BE LEAVES
      node.lit = inroot.lit || node.lit;
      node.pos = node.lit?leaf1:leaf0;
    } else if (inroot.leaf || node.leaf) {
      //if(inroot.leaf){
      //  JoinOrHelper(inroot,node.left);
      //  JoinOrHelper(inroot,node.right);
      //} else if(node.leaf){
      //  JoinOrHelper(inroot.left,node);
      //  JoinOrHelper(inroot.right,node);
    } else {
      JoinOrHelper(inroot.left, node.left);
      JoinOrHelper(inroot.right, node.right);
    }
  }

  void JoinAnd(Tree intree) {
    JoinAndHelper(intree.root, root);
    trns = false;
    Relevel();
  }

  void JoinAndHelper(Node inroot, Node root) {
    if (inroot.leaf && root.leaf) {
      root.lit = inroot.lit && root.lit;    
      root.pos = root.lit?leaf1:leaf0;
    } else if (inroot.leaf || root.leaf) {
      println("What to do here");
    } else {
      JoinAndHelper(inroot.left, root.left);
      JoinAndHelper(inroot.right, root.right);
    }
  }

  void JoinXor(Tree intree) {
    JoinXorHelper(intree.root, root);
    trns = false;
    Relevel();
  }

  void JoinXorHelper(Node inroot, Node root) {
    if (inroot.leaf && root.leaf) {// THEY SHOULD BOTH BE LEAVES
      root.lit = (inroot.lit && !root.lit)||(!inroot.lit && root.lit);  
      root.pos = root.lit?leaf1:leaf0;
    } else if (inroot.leaf || root.leaf) {
      println("One is not a leaf something has happened and it is not happy");
    } else {
      JoinXorHelper(inroot.left, root.left);
      JoinXorHelper(inroot.right, root.right);
    }
  }

  void JoinImplies(Tree intree) {
    JoinImpliesHelper(intree.root, root);
    trns = false;
    Relevel();
  }

  void JoinImpliesHelper(Node inroot, Node root) {
    if (inroot.leaf && root.leaf) {// THEY SHOULD BOTH BE LEAVES
      root.lit = !root.lit || inroot.lit;  
      root.pos = root.lit?leaf1:leaf0;
    } else if (inroot.leaf || root.leaf) {
      println("One is not a leaf something has happened and it is not happy");
    } else {
      JoinImpliesHelper(inroot.left, root.left);
      JoinImpliesHelper(inroot.right, root.right);
    }
  }


  void Center() {
    if (bf.numvars>1) {
      root.pos.x = width/2;
      MakeLevels(0, root, 0);
    }
  }

  void Print() {
    PrintTree(0, root);
  }
  void PrintTree(int level, Node root) {
    if (level == 0) {
      println("Root!");
      PrintTree(level + 1, root.right);
      PrintTree(level + 1, root.left);
    } else if (!root.leaf) {
      PrintArr(level, root.path);
      PrintTree(level + 1, root.right);
      PrintTree(level + 1, root.left);
    } else if (root.leaf) {
      String a;
      if (root.path[root.path.length-1]) a = "right";
      else a = "left";
      if (root.lit)println(a + " has value TRUE");
      else println(a + " has value FALSE");
    } else println("We have reached a point where neither leaf nor node exists.");
  }
  void PrintArr(int level, boolean[] b) {
    println("_________________________________");
    println("Level: " + level);
    for (int i = 0; i < b.length; i++) {
      if (b[i]) {
        print("true, ");
      } else {
        print("false, ");
      }
    }
    println();
  }
}