class Pantalla {
  GaleriaPlanos laminas;
  Galeria galeria;
  Texto texto;
  Pantalla() {
    String[] coordsLamina = split(strings[0], ",");
    laminas = new GaleriaPlanos(new PVector(int(coordsLamina[0]), int(coordsLamina[1])), 
      new PVector(int(coordsLamina[2]), int(coordsLamina[3])), new PVector(int(coordsLamina[4]), int(coordsLamina[5])), 
      new PVector(int(coordsLamina[6]), int(coordsLamina[7])));
    String[] coordsGaleria = split(strings[1], ",");
    galeria = new Galeria(new PVector(int(coordsGaleria[0]), int(coordsGaleria[1])), 
      new PVector(int(coordsGaleria[2]), int(coordsGaleria[3])), new PVector(int(coordsGaleria[4]), int(coordsGaleria[5])), 
      new PVector(int(coordsGaleria[6]), int(coordsGaleria[7])));
    String[] coordsTexto = split(strings[2], ",");
    texto = new Texto(new PVector(int(coordsTexto[0]), int(coordsTexto[1])), 
      new PVector(int(coordsTexto[2]), int(coordsTexto[3])), new PVector(int(coordsTexto[4]), int(coordsTexto[5])), 
      new PVector(int(coordsTexto[6]), int(coordsTexto[7])));
  }

  void resetEsquinas() {
    laminas.setEsquinas(new PVector(172, 17), 
      new PVector(918, 17), new PVector(918, 1065), 
      new PVector(172, 1065));
    galeria.setEsquinas(new PVector(974, 62), 
      new PVector(1528, 62), new PVector(1528, 452), 
      new PVector(974, 452)); 
    texto.setEsquinas(new PVector(974, 459), 
      new PVector(1574, 459), new PVector(1574, 1076), 
      new PVector(974, 1076));
  }
  void prepareNextImages() {
    laminas.prepareNextImages();
    galeria.prepareNextImages();
    texto.prepareNextImage("categoria_"+CAT+"/"+CAT+"_ficha_"+int(seleccion)+"/texto.jpg");
  }
  void setNewImages() {
    laminas.setNewImages();
    galeria.setNewImages();
    texto.setNewImage();
  }

  void updateAndDibujar() {
    laminas.update();
    galeria.update();  
    texto.update();
    galeria.dibujar();
    laminas.dibujar();    
    texto.dibujar();
  }

  void checkCalib() {
    if (esq >= 0 && esq < 4) {
      noFill();
      strokeWeight(3);
      stroke(255, 0, 0);
      fill(255, 0, 0);
      ellipse(laminas.esquinas[esq].x, laminas.esquinas[esq].y, rad, rad);
      if (mousePressed) {
        laminas.esquinas[esq] = new PVector(mouseX, mouseY);
      }
    } else if (esq >= 4 && esq < 8) {
      noFill();
      strokeWeight(3);
      stroke(255, 0, 0);
      fill(255, 0, 0);
      ellipse(galeria.esquinas[esq-4].x, galeria.esquinas[esq-4].y, rad, rad);
      if (mousePressed) {
        galeria.esquinas[esq-4] = new PVector(mouseX, mouseY);
      }
    } else if (esq >= 8 && esq < 12) {
      noFill();
      strokeWeight(3);
      stroke(255, 0, 0);
      fill(255, 0, 0);
      ellipse(texto.esquinas[esq-8].x, texto.esquinas[esq-8].y, rad, rad);
      if (mousePressed) {
        texto.esquinas[esq-8] =  new PVector(mouseX, mouseY);
      }
    }
  }
}