import java.util.*;

final int size = 1500;
final int num = 30;
HashSet <Piece> pieces = new HashSet<Piece>();
HashMap <String, Piece> mapPieces= new HashMap<String, Piece>();
Piece p;
boolean clicked = false;
boolean player1 = true;
float clickMX, clickMY;
boolean run = true;
int wid;
void setup(){
  size(1500, 1500);
}

void draw(){
  if(run){
    board();
  }
  else{
    end();
  }
}

void board(){
  fill(250, 253, 15);
  rect(0, 0, size, size);
  int len = size/num;
  wid = len;
  for(int i = 0; i < num; i++){
    for(int j = 0; j < num; j++){
       int x= i*len;
       int y = j*len;
       stroke(0);
       rect(x, y, len, len);
    }
  }
  float mX = (float)mouseX/len;
  float mY = (float)mouseY/len;
  int roundedX = round(mX);
  int roundedY = round(mY);
  float diamtr = wid*.6;
  if(abs(mX-roundedX)<.3 && abs(mY-roundedY)<.3){
       int x= roundedX*len;
       int y = roundedY*len;
       if(player1){
          fill(255);
          ellipse(x, y,diamtr, diamtr);       
          p = new Black(x, y);
       }
       else{
          fill(0);
          ellipse(x, y,diamtr, diamtr);
          p = new White(x, y);
       }

       boolean valid = ((float)x-clickMX)*((float)x-clickMX)+((float)y-clickMY)*((float)y-clickMY)<=diamtr*diamtr;
       if(clicked&&valid){
         mapPieces.put(x+"|"+y, p);
         pieces.add(p);
         p.update();
         HashSet<Piece> remove = p.connected();
         Iterator itr = remove.iterator();
         while(itr.hasNext()){
           Piece t = (Piece)itr.next();
           int x_ = t.getX();
           int y_ = t.getY();
           mapPieces.remove(x_+"|"+y_);
         }
         pieces.removeAll(remove);
       }
       clicked = false;
  }
  Iterator itr = pieces.iterator();
  while(itr.hasNext()){
    Piece t = (Piece)itr.next();
    int x = t.getX();
    int y = t.getY();
    fill(t.getLabel());
    ellipse(x, y,diamtr, diamtr);
  }
}

void end(){
  fill(200);
  rect(500, 200, 500, 500);
  fill(0);
  textSize(40);
  if(player1){
     text("Game Over\nPlayer 2 Wins", 600, 400);
  }
  else{
     text("Game Over\nPlayer 1 Wins", 600, 400);
  }

}
void mouseClicked(){
  clicked = true;
  clickMX = mouseX;
  clickMY = mouseY;
  player1 = !player1;
}

abstract class Piece{
  HashMap <String, Piece> adj;
  protected int x, y;  //xy coordinates (without adjusting for screen and sq size
  protected int label; //Color
  Piece (int x, int y){
     adj = new HashMap<String, Piece>();
     this.x = x;
     this.y = y;
  }
  int getX(){
    return x;
  }
  int getY(){
    return y;
  }
  abstract int getLabel();
    HashSet<Piece> connected(){
      HashSet<Piece> connected = new HashSet<Piece>();
      Piece n = adj.get("n");
      Piece s = adj.get("s");
      Piece e = adj.get("e");
      Piece w = adj.get("w");
      if(n!=null){
         HashSet<Piece> set = new HashSet<Piece>();
         checkFill(set, n, !this.isBlack());
         connected.addAll(set);
      }
      if(s!=null){
          HashSet<Piece> set = new HashSet<Piece>();
          checkFill(set, s, !this.isBlack());
          connected.addAll(set);
      }
      if(w!=null){
          HashSet<Piece> set = new HashSet<Piece>();
          checkFill(set, w, !this.isBlack());      
         connected.addAll(set); 
      }
      if(e!=null){
         HashSet<Piece> set = new HashSet<Piece>();
         checkFill(set, e, !this.isBlack());
         connected.addAll(set);
      }
  
     return connected;
  }
    void checkFill(HashSet <Piece> seen, Piece p, boolean isBlack){
      if(p==null){
        seen.clear();
        return;
      }
      int x = p.x;
      int y = p.y;
      Piece n = mapPieces.get(x+"|"+(y-wid));
      Piece s = mapPieces.get(x+"|"+(y+wid));
      Piece e = mapPieces.get((x+wid)+"|"+y);
      Piece w = mapPieces.get((x-wid)+"|"+y);
      if(p.isBlack()==isBlack){
         if(!seen.contains(p)){
             seen.add(p);
             checkFill(seen, n, isBlack);
             checkFill(seen, s, isBlack);
             checkFill(seen, e, isBlack);
             checkFill(seen, w, isBlack);
         }
      }
      else{
        return;
      }
  }
  
  abstract boolean isBlack();
    void update(){
    boolean b = isBlack();
    int x = this.x;
    int y = this.y;
    Piece n = mapPieces.get(x+"|"+(y-wid));
    Piece s = mapPieces.get(x+"|"+(y+wid));
    Piece e = mapPieces.get((x+wid)+"|"+y);
    Piece w = mapPieces.get((x-wid)+"|"+y);
    if(n!=null){
      adj.put("n", n);
      n.adj.put("s", this);
    }
    if(s!=null){
      adj.put("s", s);
      s.adj.put("n", this);
    }
    if(e!=null){
      adj.put("e", e);
      e.adj.put("w", this);
    }
    if(w!=null){
      adj.put("w", w);
      w.adj.put("e", this);
    }
  }


}

class Black extends Piece{
  Black (int x, int y){
     super(x, y);
     this.label = 0;
  }
  boolean isBlack(){
    return true;
  }
  int getLabel(){
    return label;
  }

}

class White extends Piece{
  White (int x, int y){
    super(x, y);
    this.label = 255;
  }
  boolean isBlack(){
    return false;
  }
  int getLabel(){
    return label;
  }

}