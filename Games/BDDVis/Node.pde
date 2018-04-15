
class Node{
  boolean[] path;
  boolean lit;
  Node right;
  Node left;
  boolean leaf;
  PVector pos;
  boolean moving = false;
    
  Node(boolean[] _path, PVector _pos){
    path = _path;
    pos = _pos;
    leaf = false;
  }
  
  Node(boolean _lit, boolean[] _path, PVector _pos){
    pos = _pos;
    lit = _lit;
    path = _path;
    leaf = true;
  }
  
  Node(){}
  
  
  boolean Same(Node in){
    if(in.leaf && leaf){
      // I think that we aren't counting the 1 and 0 as nodes when we should?
      return in.lit == lit;//in.right.lit == right.lit && in.left.lit == left.lit;
    } else { 
      return SamePath(in, this, "");
    }
  }
  
  boolean SamePath(Node in, Node comp, String pa){ 
    println(pa);
    // An issue that may arise, is it returns if the path directions are the same, not the path variables... Might require that we add a path of chars.
    if(comp.leaf && in.leaf){ // They should both be leaves if one is
      return (in.lit == comp.lit);
    } else if(!comp.leaf && !in.leaf){
      return SamePath(in.right, comp.right, pa+"r") && 
             SamePath(in.left, comp.left, pa + "l");
    } else {
      println("Looking at node and leaf in Node:SamePath");
      return false;
    } 
  }
  
  
  void printboolarr(boolean[] arr){
    println();
    for(int i = 0; i<arr.length; i++){
      if(arr[i])
        print("r");
      else
        print("l");
    }
    println();
  }
  
  void printboolarr(){
    println();
    for(int i = 0; i<path.length; i++){
      if(path[i])
        print("r");
      else
        print("l");
    }
    println();
  }
}

  //void Copy(Node a){
  //  path = new boolean[a.path.length];
  //  int rov = 0;
  //  for(boolean i:a.path) {
  //    path[rov] = i;
  //    rov++;
  //  }
  //  if(a.leaf) {
  //    leaf = a.leaf;
  //    lit = a.lit;
  //  } else {
  //    right = a.right;
  //    left = a.left;
  //  }
  //  pos = a.pos;
  //  CopyNodes(this,a);
  //}
  
  //void CopyNodes(Node in, Node comp){
  //  if(!in.leaf){
  //    CopyNodes(in.right, comp.right);
  //    CopyNodes(in.left, comp.left);
  //    in.Copy(comp);
  //  } else {
  //    in.lit = comp.lit;
  //  }
  //}
  
  //  void Move(PVector newpos){ // NOT WORKING
  //  moving = true;
  //  while(pos.x != newpos.x && pos.y != newpos.y){
  //    //println("x is " + pos.x + " y is " + pos.y);
  //    println("moving");
  //    fill(255, 0, 0);
  //    stroke(255,255,0);
  //    //rect(pos.x,pos.y,50,50);
  //    pos.x = newpos.x;//lerp(pos.x, newpos.x, 1.0/mill);
  //    pos.y = newpos.y;//lerp(pos.y, newpos.y, 1.0/mill);
  //  }
  //  moving = false;
  //}