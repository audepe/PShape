import java.util.ArrayList;

enum State {
  P2D,
  P3D;
}

enum Movement {
  translate, 
  rotate;
}

State dimensionState = State.P2D;
ArrayList<PVector> points;
PVector shapePosition;
PShape object3D;
int multAngle;

void setup(){
  size(1280,720,P3D);
  points = new ArrayList<PVector>();
  shapePosition = new PVector(width/2, height/2);
  multAngle = 10;
}

void draw(){
  background(0);
  if (dimensionState == State.P2D){
    drawSplitLine();
    
    PVector last = null;
    for(PVector p : points){
      circle(p.x + width/2,p.y,5);
      if(last != null){
        line(last.x + width/2, last.y, p.x + width/2, p.y);
      }      
      last = p;
    }
    
  }else if (dimensionState == State.P3D){
    translate(shapePosition.x, shapePosition.y - height / 2);
    shape(object3D);
  }
}

void drawSplitLine(){
  stroke(255);
  line(width/2,0,width/2,height);
}

PVector rotatePoint(PVector point){
  PVector result = new PVector(0, 0, 0);
  double r = Math.toRadians(multAngle);
  result.x = (float)(point.x * Math.cos(r) - point.z * Math.sin(r));
  result.z = (float)(point.x * Math.sin(r) + point.z * Math.cos(r));
  result.y = point.y;
  return result;
}

void makeShape(){
  object3D = createShape();
  object3D.beginShape(TRIANGLE_STRIP);
  object3D.stroke(255, 0, 0);
  double angle = 0;
  while (angle < 360){
    ArrayList<PVector> rotated = new ArrayList();
    for (int i = 0; i < points.size(); i++){
      PVector v = points.get(i);
      rotated.add(rotatePoint(v));
    }
    object3D.vertex(rotated.get(0).x, rotated.get(0).y, rotated.get(0).z);
    for (int i = 0; i < rotated.size() - 1; i++){
      object3D.vertex(points.get(i).x, points.get(i).y, points.get(i).z);
      object3D.vertex(rotated.get(i + 1).x, rotated.get(i + 1).y, rotated.get(i + 1).z);
    }
    PVector v = points.get(points.size() - 1);
    object3D.vertex(v.x, v.y, v.z);
    points = rotated;
    angle += multAngle;
  }
  object3D.endShape();

}

void drawLine(){
  if (points.isEmpty()) return;
  for(int i = 0; i < points.size() - 1; i++){
    line(width/2 + points.get(i).x, points.get(i).y, width/2 + points.get(i + 1).x, points.get(i + 1).y);
  }
}

void mouseClicked(){
  if(mouseButton == LEFT && mouseX >= width/2 && dimensionState == State.P2D){
    points.add(new PVector(mouseX - width/2,mouseY));
  } else if(mouseButton == RIGHT){
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
}
