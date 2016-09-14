class Galeria {
  ArrayList<PImage> imagenes = new ArrayList<PImage>();
  ArrayList<PImage> nextImagenes = new ArrayList<PImage>();
  ArrayList<PVector> esquinas = new ArrayList<PVector>();
  int numfots = 0;
  int currentfot = 0;
  int lastChanged = 0;
  int opacity=255;
  PImage img;
  PVector esq1;
  PVector esq2;
  PVector esq3;
  PVector esq4;

  Galeria(int numfots_, PVector pos1_, PVector pos2_, PVector pos3_, PVector pos4_) {
    numfots = numfots_;
    for (int i = 0; i<numfots; i++) {
      imagenes.add(loadImage("ficha_"+int(seleccion)+"/foto_"+i+".jpg"));
    }
    esquinas.add(new PVector(pos1_.x, pos1_.y));  
    esquinas.add(new PVector(pos2_.x, pos2_.y));    
    esquinas.add(new PVector(pos3_.x, pos3_.y));    
    esquinas.add(new PVector(pos4_.x, pos4_.y));
    opacity=255;
  }

  void setEsquinas(PVector pos1_, PVector pos2_, PVector pos3_, PVector pos4_) {
    esquinas.set(0, new PVector(pos1_.x, pos1_.y));  
    esquinas.set(1, new PVector(pos2_.x, pos2_.y));    
    esquinas.set(2, new PVector(pos3_.x, pos3_.y));    
    esquinas.set(3, new PVector(pos4_.x, pos4_.y));
  }

  void setNewImages() {
    for (int i = 0; i<numfots; i++) {
      imagenes.add(nextImagenes.get(i));
    }
    opacity=255;
  }

  void prepareNextImages(int numfots_) {
    numfots = numfots_;
    for (int i = 0; i<numfots; i++) {
      nextImagenes.add(loadImage("ficha_"+int(seleccion)+"/foto_"+i+".jpg"));
    }
    opacity=255;
  }

  void update() {
    if ((millis()-lastChanged) > 7000 && !isChanging) {
      lastChanged = millis();
      isChanging = true;
      Ani.to(this, 1.0, "opacity", 0, Ani.LINEAR, "onEnd:changePhoto");
    }
    checkCalib();
  }

  void changePhoto() {
    if (currentfot < numfots-1)currentfot++;
    else currentfot = 0;
    Ani.to(this, 1.0, "opacity", 255, Ani.LINEAR, "onEnd:changeState");
  }

  void changeState() {
    isChanging = false;
  }

  void dibujar() {
    esq1= esquinas.get(0);
    esq2= esquinas.get(1);
    esq3= esquinas.get(2);
    esq4= esquinas.get(3);
    img = imagenes.get(currentfot);
    tint(opacity);
    if (showStroke)stroke(255);
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
    tint(255);
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