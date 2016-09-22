class Texto {
  PVector [] esquinas = new PVector[4];
  PVector loc;
  PGraphics pg;
  float opacity = 0;
  PImage img;
  PVector esq1;
  PVector esq2;
  PVector esq3;
  PVector esq4;
  PImage imagePG;
  PImage nextImagePG;
  float posy=0;

  Texto() {
  }

  Texto(PVector pos1_, PVector pos2_, PVector pos3_, PVector pos4_, String str_) {
    esquinas[0] = new PVector(pos1_.x, pos1_.y);  
    esquinas[1] = new PVector(pos2_.x, pos2_.y);    
    esquinas[2] = new PVector(pos3_.x, pos3_.y);    
    esquinas[3] = new PVector(pos4_.x, pos4_.y);
    pg = createGraphics(259, 471, P3D);
    imagePG = loadImage(str_);
  }

  void setEsquinas(PVector pos1_, PVector pos2_, PVector pos3_, PVector pos4_) {
    esquinas[0] = new PVector(pos1_.x, pos1_.y);  
    esquinas[1] = new PVector(pos2_.x, pos2_.y);    
    esquinas[2] = new PVector(pos3_.x, pos3_.y);    
    esquinas[3] = new PVector(pos4_.x, pos4_.y);
  }

  void prepareNextImage(String str_) {
    nextImagePG = loadImage(str_);
  }
  void setNewImage() {
    imagePG = nextImagePG;
    posy=0;
  }

  void update() {
    if (posy > -imagePG.height) {
      posy-=0.1;
    } else {
      posy=0;
    }
    checkCalib();
  }
  void dibujar() {
    esq1= esquinas[0];
    esq2= esquinas[1];
    esq3= esquinas[2];
    esq4= esquinas[3];
    pg.beginDraw();
    pg.image(imagePG, 0, posy);
    pg.endDraw();
    img = pg.get(0, 0, pg.width, pg.height);
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
    for (int i=0; i<esquinas.length; i++) {
      if (dist(mouseX, mouseY, esquinas[i].x, esquinas[i].y) < 10) {
        noFill();
        if (mousePressed) {
          esquinas[i].x = mouseX;
          esquinas[i].y = mouseY;
          stroke(255, 0, 255);
        } else stroke(255, 0, 0);
        ellipse(esquinas[i].x, esquinas[i].y, 20, 20);
      }
    }
  }
}