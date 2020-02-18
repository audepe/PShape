import java.util.ArrayList;

enum State {
  P2D,
  P3D;
}

State dimensionState = State.P2D;
ArrayList<Tuple> palette;
ArrayList<PVector> points;
PVector shapePosition;
PVector strokeColor;
PVector fillColor;
PShape object3D;
int multAngle;
float rotationStep;
boolean rotateUY, rotateDY, rotateUX, rotateDX;
int colorSel;

void setup(){
  size(1280,720,P3D);
  
  points = new ArrayList<PVector>();
    
  palette = new ArrayList<Tuple>();
  palette.add(new Tuple(new PVector(0,255,0),new PVector(0,0,0)));
  palette.add(new Tuple(new PVector(255,255,255),new PVector(0,0,0)));
  palette.add(new Tuple(new PVector(102, 179, 255),new PVector(0,0,255)));
  palette.add(new Tuple(new PVector(255, 92, 51),new PVector(255,0,0)));
  palette.add(new Tuple(new PVector(255,113,206),new PVector(185,103,255)));
  
  colorSel = 0;
  
  shapePosition = new PVector(width/2, height/2);
  multAngle = 10;
  rotationStep = 0.05;
  
  rotateUY = false;
  rotateDY = false;
  rotateUX = false;
  rotateDX = false;
  
  strokeColor = new PVector(0,255,0);
  fillColor = new PVector(255,0,0);
  
}

void draw(){
  background(0);
  setPalette();
  if (dimensionState == State.P2D){
    drawSplitLine();
    drawMenu(); 
    PVector last = null;
    for(PVector p : points){
      circle(p.x + width/2,p.y + height/2,5);
      if(last != null){
        line(last.x + width/2, last.y + height/2, p.x + width/2, p.y + height/2);
      }      
      last = p;
    }
    
  }else if (dimensionState == State.P3D){
    setStile();
    translate(shapePosition.x, shapePosition.y);
    shape(object3D);
    rotateShape();
  }
}
void setPalette(){
  Tuple colors = palette.get(colorSel);
  strokeColor = colors.getStroke();
  fillColor = colors.getFill();
}

void setStile(){  
  if(fillColor.x + fillColor.y + fillColor.z == 0.0){
    object3D.setFill(false);
  } else {
    object3D.setFill(true);
    object3D.setFill(color(fillColor.x,fillColor.y,fillColor.z));
  }
  object3D.setStroke(color(strokeColor.x,strokeColor.y,strokeColor.z));    
}

void rotateShape(){
  if(rotateUY){
    object3D.rotateX(rotationStep);
  }else if(rotateDY){
    object3D.rotateX(-rotationStep);
  } 
  
  if(rotateUX){
    object3D.rotate(rotationStep, 0, 1, 0);
  } else if (rotateDX){
    object3D.rotate(-rotationStep, 0, 1, 0);
  }
}

void drawSplitLine(){
  stroke(255);
  line(width/2,0,width/2,height);
}

void drawMenu(){
  fill(strokeColor.x,strokeColor.y,strokeColor.z);
  textAlign(CENTER);
  textSize(64);
  text("RevolutionShape", 325, 125);
  textSize(37);
  text("Dibujar puntos: Click Izquierdo", 325, 250);
  text("Generar figura: Click Derecho", 325, 325);
  text("Rotar la figura: WASD",325,400);
  text("Mover la figura: Click Izquierdo",325,475);
  text("Nueva Figura: Barra Espaciadora",325,550);
  text("Cambiar Paleta: Q-E",325,625);
}

PVector rotatePoint(PVector point){
  PVector result = new PVector(0, 0, 0);
  double r = Math.toRadians(multAngle);
  result.x = (float)(point.x * Math.cos(r) - point.z * Math.sin(r));
  result.z = (float)(point.x * Math.sin(r) + point.z * Math.cos(r));
  result.y = point.y;
  return result;
}

ArrayList<PVector> rotateLine(){
  ArrayList<PVector> rotated = new ArrayList();
  for (int i = 0; i < points.size(); i++){
    PVector v = points.get(i);
    rotated.add(rotatePoint(v));
  }
  return rotated;
}


void addVertex(ArrayList<PVector> rotated){
  if (rotated.isEmpty()) return;
  object3D.vertex(rotated.get(0).x, rotated.get(0).y, rotated.get(0).z);
  for (int i = 0; i < rotated.size() - 1; i++){
    object3D.vertex(points.get(i).x, points.get(i).y, points.get(i).z);
    object3D.vertex(rotated.get(i + 1).x, rotated.get(i + 1).y, rotated.get(i + 1).z);
  }
  PVector v = points.get(points.size() - 1);
  object3D.vertex(v.x, v.y, v.z);
} 


void makeShape(){
  object3D = createShape();
  object3D.beginShape(TRIANGLE_STRIP);
  double angle = 0;
  while (angle < 360){
    ArrayList<PVector> rotated = rotateLine();
    addVertex(rotated);
    points = rotated;
    angle += multAngle;
  }
  object3D.endShape();
  
}


void mouseClicked(){
  if(mouseButton == LEFT && mouseX >= width/2 && dimensionState == State.P2D){
    points.add(new PVector(mouseX - width/2,mouseY -height/2));
  } else if(mouseButton == RIGHT && points.size() > 0 && dimensionState == State.P2D){
    makeShape(); 
    dimensionState = State.P3D;
  }
}

void mouseDragged(){
  if(mouseButton == LEFT && dimensionState == State.P3D){
    shapePosition.x = mouseX;
    shapePosition.y = mouseY;
  }
}

void keyPressed(){
  if(key == ' '){
    object3D = null;
    dimensionState = State.P2D;
    setup();
  }
  if(key == 'w' && dimensionState == State.P3D){
    rotateUY = true;
  } else if(key == 's' && dimensionState == State.P3D){
    rotateDY = true;
  }
  
  if(key == 'd' && dimensionState == State.P3D){
    rotateUX = true;
  } else if (key == 'a' && dimensionState == State.P3D){
    rotateDX = true;
  }
  
  if(key == 'q'){
    colorSel++;
    colorSel = colorSel == 5 ? 0 : colorSel;
  } else if (key == 'e') {
    colorSel--;
    colorSel = colorSel == -1 ? 4 : colorSel;
  }
}

void keyReleased(){
  if(key == 'w' && dimensionState == State.P3D){
    rotateUY = false;
  } else if(key == 's' && dimensionState == State.P3D){
    rotateDY = false;
  }
  
  if(key == 'd' && dimensionState == State.P3D){
    rotateUX = false;
  } else if (key == 'a' && dimensionState == State.P3D){
    rotateDX = false;
  }
}
