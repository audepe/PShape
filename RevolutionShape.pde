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


void setup(){
  size(1280,720,P3D);
  points = new ArrayList<PVector>();
}

void draw(){
  background(0);
  if (dimensionState == State.P2D){
    drawSplitLine();
    
    PVector last = null;
    for(PVector p : points){
      circle(p.x,p.y,5);
      if(last != null){
        line(last.x, last.y, p.x, p.y);
      }      
      last = p;
    }
    
  }else if (dimensionState == State.P3D){
    
  }
}

void drawSplitLine(){
  stroke(255);
  line(width/2,0,width/2,height);
}

void mouseClicked(){
  if(mouseX > width/2){
    points.add(new PVector(mouseX,mouseY));
  }
}

void keyPressed(){

}
