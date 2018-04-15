var desiredDepth ;
var met;
var maxwid
var maxhei
var skt;
var grid;
function setup(){
  skt = createCanvas(window.innerWidth, window.innerHeight);
  skt.parent("sktch")
  met = euclid
  desiredDepth = 6
  maxwid = 200
  maxhei = 200
  grid = false
}

function draw(){
  background(0)
  translate((width-maxwid)/2,(height-maxhei)*10/11)
  scale(window.innerWidth/screen.width)
  quadtree(1, 0,maxwid,0,maxhei,0)
}

function IsNumeric(val) {
    return Number(parseFloat(val)) == val;
}

function sanitizeString(string){
    var mathwords = Object.getOwnPropertyNames(Math)
    mathwords.push("x")
    mathwords.push("y")
    var patt = /(\w)+/g
    stringlst = string.match(patt)
    console.log(stringlst)
    for(var i = 0; i < stringlst.length;i++){
      if(mathwords.indexOf(stringlst[i])==-1 && !IsNumeric(stringlst[i])){
        console.log(stringlst[i])
        alert("You've input a word that is not in the Javascript Math Library.\n"+
              "Please email me if you have a problem!")
        return
      }
    }
    return string.trim();
}

changeMetric = function(string){
  try{
    string = sanitizeString(string)
    console.log(string)
    met = function(x,y){
      return(eval(string))
    }
    met(1,1)
  } catch(err) {
    alert("Not a valid input:\n"+
    "Input should be Javascript style\n"+
    "Input should reference x and y.")
    met = euclid
  }
}

minkowski = function(x,y){
  p = 4;
  distance = pow(pow(abs(x),p)+pow(abs(y),p),1.0/p)
  return distance
}

euclid = function(x,y){
  distance = sqrt(x*x+y*y)
  return distance
}

taxicab = function(x,y){
  distance = abs(x)+abs(y)
  return distance
}

discrete = function(x,y){
  distance = max(abs(x),abs(y))
  return distance
}

function quadtree(eps, xmin, xmax, ymin, ymax, depth){
  var logicx = map_range((xmin+xmax)/2.0, 0.0,maxwid,-1.0,1.0)
  var logicy = map_range((ymin+ymax)/2.0, 0.0,maxhei,-1.0,1.0)
  if(depth<=desiredDepth){
    if(abs(met(logicx, logicy)-1)<=eps){
      quadtree(eps/2.0, (xmin+xmax)/2.0,xmax,(ymin+ymax)/2.0,ymax,depth+1)
      quadtree(eps/2.0, xmin,(xmin+xmax)/2.0,(ymin+ymax)/2.0,ymax,depth+1)
      quadtree(eps/2.0, xmin,(xmin+xmax)/2.0,ymin,(ymin+ymax)/2.0,depth+1)
      quadtree(eps/2.0, (xmin+xmax)/2.0,xmax,ymin,(ymin+ymax)/2.0,depth+1)
    }
    stroke(125)
    fill(120)
    if(depth == desiredDepth || grid){
      line(xmin,ymin,xmin,ymax)
      line(xmin,ymin,xmax,ymin)
      line(xmax,ymin,xmax,ymax)
      line(xmin,ymax,xmax,ymax)
    }
  }
}

function map_range(value, low1, high1, low2, high2) {
    return low2 + (high2 - low2) * (value - low1) / (high1 - low1);
}
