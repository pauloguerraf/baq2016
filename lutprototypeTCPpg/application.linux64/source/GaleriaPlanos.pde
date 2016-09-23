class GaleriaPlanos {
  ArrayList<PImage> imagenes = new ArrayList<PImage>();
  ArrayList<PImage> nextImagenes = new ArrayList<PImage>();
  ArrayList<PVector> esquinas = new ArrayList<PVector>();
  int numplanos = 0;
  int currentfot = 0;
  int lastChanged = 0;
  int opacity = 255;
  PImage img = null;
  PVector esq1;
  PVector esq2;
  PVector esq3;
  PVector esq4;
  int tiempoDeCambio = 15000;

  GaleriaPlanos(PVector pos1_, PVector pos2_, PVector pos3_, PVector pos4_) {
    String path = sketchPath()+"/data/categoria_"+CAT+"/"+CAT+"_ficha_"+int(seleccion)+"/planos"; 
    File dataFolder = new File(path); 
    String[] fileList = dataFolder.list(jpgFilter); 
    println(fileList.length + " jpg files in specified directory");
    numplanos = fileList.length; 
    for (int i = 0; i<numplanos; i++) {
      imagenes.add(loadImage("categoria_"+CAT+"/"+CAT+"_ficha_"+int(seleccion)+"/planos/plano_"+i+".jpg"));
    }
    esquinas.add(new PVector(pos1_.x, pos1_.y));  
    esquinas.add(new PVector(pos2_.x, pos2_.y));    
    esquinas.add(new PVector(pos3_.x, pos3_.y));    
    esquinas.add(new PVector(pos4_.x, pos4_.y));
    println("fotos planos : " + numplanos);
    opacity=255;
  }

  void setEsquinas(PVector pos1_, PVector pos2_, PVector pos3_, PVector pos4_) {
    esquinas.set(0, new PVector(pos1_.x, pos1_.y));  
    esquinas.set(1, new PVector(pos2_.x, pos2_.y));    
    esquinas.set(2, new PVector(pos3_.x, pos3_.y));    
    esquinas.set(3, new PVector(pos4_.x, pos4_.y));
  }

  void setNewImages() {
    imagenes.clear();
    for (int i = 0; i<numplanos; i++) {
      imagenes.add(nextImagenes.get(i));
    }
    currentfot = 0;
    lastChanged = millis();
    opacity=255;
  }
  void prepareNextImages() {
    nextImagenes.clear();
    String path = sketchPath()+"/data/categoria_"+CAT+"/"+CAT+"_ficha_"+int(seleccion)+"/planos"; 
    File dataFolder = new File(path); 
    String[] fileList = dataFolder.list(); 
    numplanos = fileList.length; 
    for (int i = 0; i<numplanos; i++) {
      nextImagenes.add(loadImage("categoria_"+CAT+"/"+CAT+"_ficha_"+int(seleccion)+"/planos/plano_"+i+".jpg"));
    }
    opacity=255;
  }

  void update() {
    if ((millis()-lastChanged) > tiempoDeCambio && !isChanging) {
      lastChanged = millis();
      isChanging = true;
      opacity=0;
      //Ani.to(this, 1.0, "opacity", 0, Ani.LINEAR, "onEnd:changePlano");
      changePlano();
      println("changing Plano");
    }
    checkCalib();
  }

  void changePlano() {
    if (currentfot < numplanos-1)currentfot=currentfot+1;
    else currentfot = 0;
    opacity = 255;
    changeStatePlano();
    //Ani.to(this, 1.0, "opacity", 255, Ani.LINEAR, "onEnd:changeStatePlano");
  }

  void changeStatePlano() {
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