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
         run = !p.connected();
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
  protected int x, y;
  protected int label;
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
  boolean connected(){
    Piece n = adj.get("n");
    Piece s = adj.get("s");
    Piece e = adj.get("e");
    Piece w = adj.get("w");
    Piece nw = adj.get("nw");
    Piece ne = adj.get("ne");
    Piece sw = adj.get("sw");
    Piece se = adj.get("se");
    HashSet <Piece> vert = new HashSet<Piece>();
    HashSet <Piece> hor = new HashSet<Piece>();
    HashSet <Piece> diagLR = new HashSet<Piece>();
    HashSet <Piece> diagRL = new HashSet<Piece>();
    vert.add(this);
    hor.add(this);
    diagLR.add(this);
    diagRL.add(this);
    if(n!=null){
      checkDir(vert, "n");
    }
    if(s!=null){
      checkDir(vert, "s");
    }
    if(e!=null){
      checkDir(hor, "e");
    }
    if(w!=null){
      checkDir(hor, "w");
    }
    if(nw!=null){
      checkDir(diagLR, "nw");
    }
    if(se!=null){
      checkDir(diagLR, "se");
    }
    if(ne!=null){
      checkDir(diagRL, "ne");
    }
    if(sw!=null){
      checkDir(diagRL, "sw");
    } 
    return vert.size()>4||hor.size()>4||diagLR.size()>4||diagRL.size()>4;
  }
  void checkDir(HashSet <Piece> seen, String dir){
 
    Piece t = adj.get(dir);
    if(t!=null){
      seen.add(t);
      System.out.println(seen.size());
      t.checkDir(seen, dir);
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
    Piece nw = mapPieces.get((x-wid)+"|"+(y-wid));
    Piece ne = mapPieces.get((x+wid)+"|"+(y-wid));
    Piece sw = mapPieces.get((x-wid)+"|"+(y+wid));
    Piece se = mapPieces.get((x+wid)+"|"+(y+wid));    
    if(n!=null&&b==n.isBlack()){
      adj.put("n", n);
      n.adj.put("s", this);
    }
    if(s!=null&&b==s.isBlack()){
      adj.put("s", s);
      s.adj.put("n", this);
    }
    if(e!=null&&b==e.isBlack()){
      adj.put("e", e);
      e.adj.put("w", this);
    }
    if(w!=null&&b==w.isBlack()){
      adj.put("w", w);
      w.adj.put("e", this);
    }
    if(nw!=null&&b==nw.isBlack()){
      adj.put("nw", nw);
      nw.adj.put("se", this);
    }
    if(ne!=null&&b==ne.isBlack()){
      adj.put("ne", ne);
      ne.adj.put("sw", this);
    }
    if(sw!=null&&b==sw.isBlack()){
      adj.put("sw", sw);
      sw.adj.put("ne", this);
    }
    if(se!=null&&b==se.isBlack()){
      adj.put("se", se);
      se.adj.put("nw", this);
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