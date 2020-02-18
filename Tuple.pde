class Tuple{
  PVector fill;
  PVector stroke;
  Tuple(PVector stroke, PVector fill){
    this.stroke = stroke;
    this.fill = fill;
  }
  
  PVector getFill(){
    return this.fill;
  }
  
  PVector getStroke(){
    return this.stroke;
  }
}
