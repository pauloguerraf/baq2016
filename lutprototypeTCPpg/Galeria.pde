class Galeria {
  ArrayList<PImage> imagenes = new ArrayList<PImage>();
  ArrayList<PImage> nextImagenes = new ArrayList<PImage>();
  PVector [] esquinas = new PVector[4];
  int numfots = 0;
  int currentfot = 0;
  int lastChanged = 0;
  PImage img;
  PVector esq1;
  PVector esq2;
  PVector esq3;
  PVector esq4;
  int tiempoDeCambio = 7000;

  Galeria(PVector pos1_, PVector pos2_, PVector pos3_, PVector pos4_) {
    String path = sketchPath()+"/data/categoria_"+CAT+"/"+CAT+"_ficha_"+int(seleccion)+"/fotos"; 
    File dataFolder = new File(path); 
    String[] fileList = dataFolder.list(jpgFilter); 
    println(fileList.length + " jpg files in specified directory");
    numfots = fileList.length; 
    for (int i = 0; i<numfots; i++) {
      imagenes.add(loadImage("categoria_"+CAT+"/"+CAT+"_ficha_"+int(seleccion)+"/fotos/foto_"+i+".jpg"));
    }
    esquinas[0] = new PVector(pos1_.x, pos1_.y);  
    esquinas[1] = new PVector(pos2_.x, pos2_.y);    
    esquinas[2] = new PVector(pos3_.x, pos3_.y);    
    esquinas[3] = new PVector(pos4_.x, pos4_.y);
  }

  void setEsquinas(PVector pos1_, PVector pos2_, PVector pos3_, PVector pos4_) {
    esquinas[0] = new PVector(pos1_.x, pos1_.y);  
    esquinas[1] = new PVector(pos2_.x, pos2_.y);    
    esquinas[2] = new PVector(pos3_.x, pos3_.y);    
    esquinas[3] = new PVector(pos4_.x, pos4_.y);
  }

  void setNewImages() {
    imagenes.clear();
    for (int i = 0; i<numfots; i++) {
      imagenes.add(nextImagenes.get(i));
    }
    currentfot = 0;
    lastChanged = millis();
  }

  void prepareNextImages() {
    nextImagenes.clear();
    String path = sketchPath()+"/data/categoria_"+CAT+"/"+CAT+"_ficha_"+int(seleccion)+"/planos"; 
    File dataFolder = new File(path); 
    String[] fileList = dataFolder.list(); 
    numfots = fileList.length; 
    for (int i = 0; i<numfots; i++) {
      nextImagenes.add(loadImage("categoria_"+CAT+"/"+CAT+"_ficha_"+int(seleccion)+"/fotos/foto_"+i+".jpg"));
    }
  }

  void update() {
    if ((millis()-lastChanged) > 7000 && !isChanging) {
      lastChanged = millis();
      isChanging = true;
      changePhoto();
    }
  }

  void changePhoto() {
    if (currentfot < numfots-1)currentfot=currentfot+1;
    else currentfot = 0;
    isChanging = false;
  }  

  void dibujar() {
    esq1= esquinas[0];
    esq2= esquinas[1];
    esq3= esquinas[2];
    esq4= esquinas[3];
    img = imagenes.get(currentfot);
    if (showStroke)stroke(255);
    else noStroke();
    beginShape();
    if (img != null) {
      texture(img);
    }
    vertex(esq1.x, esq1.y, 0, 0);
    vertex(esq2.x, esq2.y, 1, 0);
    vertex(esq3.x, esq3.y, 1, 1);
    vertex(esq4.x, esq4.y, 0, 1);
    endShape(CLOSE);
    tint(255);
  }
}