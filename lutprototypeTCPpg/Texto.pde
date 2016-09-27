class Texto {
  PVector [] esquinas = new PVector[4];
  PGraphics pg;
  PImage img;
  PVector esq1;
  PVector esq2;
  PVector esq3;
  PVector esq4;
  PImage imagePG;
  PImage nextImagePG;

  Texto() {
  }

  Texto(PVector pos1_, PVector pos2_, PVector pos3_, PVector pos4_) {
    esquinas[0] = new PVector(pos1_.x, pos1_.y);  
    esquinas[1] = new PVector(pos2_.x, pos2_.y);    
    esquinas[2] = new PVector(pos3_.x, pos3_.y);    
    esquinas[3] = new PVector(pos4_.x, pos4_.y);
    pg = createGraphics(600, 667, P3D);
    imagePG = loadImage("categoria_"+CAT+"/"+CAT+"_ficha_0/texto.jpg");
  }

  void setEsquinas(PVector pos1_, PVector pos2_, PVector pos3_, PVector pos4_) {
    esquinas[0] = new PVector(pos1_.x, pos1_.y);  
    esquinas[1] = new PVector(pos2_.x, pos2_.y);    
    esquinas[2] = new PVector(pos3_.x, pos3_.y);    
    esquinas[3] = new PVector(pos4_.x, pos4_.y);
  }
  
  void update(){
    
  }
  
  void prepareNextImage(String str_) {
    nextImagePG = loadImage(str_);
  }
  
  void setNewImage() {
    imagePG = nextImagePG;
  }
  
  void dibujar() {
    esq1= esquinas[0];
    esq2= esquinas[1];
    esq3= esquinas[2];
    esq4= esquinas[3];
    pg.beginDraw();
    pg.image(imagePG, 0, 0);
    pg.endDraw();
    img = pg.get(0, 0, pg.width, pg.height);
    beginShape();
    if (img != null) {
      texture(img);
    }
    vertex(esq1.x, esq1.y, 0, 0);
    vertex(esq2.x, esq2.y, 1, 0);
    vertex(esq3.x, esq3.y, 1, 1);
    vertex(esq4.x, esq4.y, 0, 1);
    endShape(CLOSE);
  }
}