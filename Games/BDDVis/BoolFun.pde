import org.quark.jasmine.*;

class BoolFun{
  String infun;
  char[] invars;
  int numvars;
  
  BoolFun(String _in){
    infun = _in;
    infun = _in.replaceAll("&","&&").replaceAll("\\|","\\|\\|");;
    int _numvars = 0;
    
    int funln = infun.length();
    char[] invars_tmp = new char[funln];
    
    
    
    for(int i = 0; i < funln; i++){
      char tmp = infun.charAt(i);
      if((tmp >= 65 && tmp <= 90) || (tmp >= 97 && tmp <= 122)) {// If the boolean is a letter (which represents a boolean variable) then we want to store that variable's representation
        boolean existsInArray = false;
        for(int j = 0; j < _numvars; j++){
          existsInArray |= tmp == invars_tmp[j];  
        }
        if(!existsInArray){
          invars_tmp[_numvars] = tmp;
          _numvars++;
        }
      } else { // Find implications
        if((tmp == 61 || tmp == 41) && funln > i+2){
          // This is hard.
        }
      }
    }
    
    if(funln >= _numvars){ // The  length of the string will be longer than the number of variables, 
                         //so we want to (for optimization of ram usage) store a smaller array of only the variables instead of just garbage
      invars = new char[_numvars];
      for(int i=0; i< _numvars; i++) invars[i] = invars_tmp[i]; 
    }
    numvars = _numvars;
  }
  
    boolean evaluate(boolean[] in){
    String literal = toLiteral(in);
    return eval(literal);
  }
  
  String toLiteral(boolean[] in){
    String tmpfun = infun;
    if(tmpfun.length()==1)
    {
      println(str(invars[0]));
      tmpfun = tmpfun.replaceAll(str(invars[0]),str(in[0]).toUpperCase());
    } else 
    {
      for(int i=0; i<numvars; i++){
        tmpfun = tmpfun.replaceAll(str(invars[i]), str(in[i]).toUpperCase());
      }
    }
    while(tmpfun.indexOf("!")>-1){
      tmpfun = tmpfun.replaceAll("!FALSE", "TRUE");
      tmpfun = tmpfun.replaceAll("!TRUE", "FALSE");
    }
    return tmpfun;
  }
  
  boolean eval(String lit){
    Expression e = Compile.expression(lit, false);
    boolean request = e.eval().answer().toBoolean();
    return request;
  }
  
  
}