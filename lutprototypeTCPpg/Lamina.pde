class Lamina {
  ArrayList<PVector> esquinas = new ArrayList<PVector>();
  PImage img = null;
  PImage nextImage = null;
  PVector esq1;
  PVector esq2;
  PVector esq3;
  PVector esq4;
  Lamina(PVector pos1_, PVector pos2_, PVector pos3_, PVector pos4_, String img_) {
    esquinas.add(new PVector(pos1_.x, pos1_.y));  
    esquinas.add(new PVector(pos2_.x, pos2_.y));    
    esquinas.add(new PVector(pos3_.x, pos3_.y));    
    esquinas.add(new PVector(pos4_.x, pos4_.y));
    if (img_ != null) img = loadImage(img_);
  }
  
  void setEsquinas(PVector pos1_, PVector pos2_, PVector pos3_, PVector pos4_){
    esquinas.set(0, new PVector(pos1_.x, pos1_.y));  
    esquinas.set(1, new PVector(pos2_.x, pos2_.y));    
    esquinas.set(2, new PVector(pos3_.x, pos3_.y));    
    esquinas.set(3, new PVector(pos4_.x, pos4_.y));
  }

  void prepareNextImage(String str_) {
    nextImage = loadImage(str_);
  }

  void setNewImage() {
    if (nextImage != null)img = nextImage;
  }

  void dibujar() {
    esq1= esquinas.get(0);
    esq2= esquinas.get(1);
    esq3= esquinas.get(2);
    esq4= esquinas.get(3);
    if(showStroke)stroke(255);
    else noStroke();
    beginShape();
    if (img != null) {
      texture(img);
    }
    vertex(esq1.x, esq1.y, 0, 0);
    vertex(esq2.x, esq2.y, img.width, 0);
    vertex(esq3.x, esq3.y, img.width, img.height);
    vertex(esq4.x, esq4.y, 0, img.height);
    endShape(CLOSE);
  }

  void checkCalib() {
    for (int i=0; i<esquinas.size(); i++) {
      if (dist(mouseX, mouseY, esquinas.get(i).x, esquinas.get(i).y) < 10) {
        noFill();
        if (mousePressed) {
          esquinas.get(i).x = mouseX;
          esquinas.get(i).y = mouseY;
          stroke(255, 0, 255);
        } else stroke(255, 0, 0);
        ellipse(esquinas.get(i).x, esquinas.get(i).y, 20, 20);
      }
    }
  }
}