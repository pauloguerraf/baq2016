class Pantalla {

  PApplet parent;
  Lamina lamina1;
  Galeria galeria;
  Texto texto;


  //Pantalla() {
  //  lamina1 = new Lamina(new PVector(172, 17), 
  //    new PVector(918, 17), new PVector(918, 1065), 
  //    new PVector(172, 1065), "ficha_0/ficha.jpg");
  //  galeria = new Galeria(3, new PVector(974, 62), 
  //    new PVector(1528, 62), new PVector(1528, 452), 
  //    new PVector(974, 452));
  //  texto = new Texto(new PVector(1014, 575), 
  //    new PVector(1273, 575), new PVector(1273, 1046), 
  //    new PVector(1014, 1046), "ficha_0/texto.jpg");
  //}
  Pantalla() {
    String[] coordsLamina = split(strings[0], ",");
    lamina1 = new Lamina(new PVector(int(coordsLamina[0]), int(coordsLamina[1])), 
      new PVector(int(coordsLamina[2]), int(coordsLamina[3])), new PVector(int(coordsLamina[4]), int(coordsLamina[5])), 
      new PVector(int(coordsLamina[6]), int(coordsLamina[7])), "ficha_0/ficha.jpg");
    String[] coordsGaleria = split(strings[1], ",");
    galeria = new Galeria(3, new PVector(int(coordsGaleria[0]), int(coordsGaleria[1])), 
      new PVector(int(coordsGaleria[2]), int(coordsGaleria[3])), new PVector(int(coordsGaleria[4]), int(coordsGaleria[5])), 
      new PVector(int(coordsGaleria[6]), int(coordsGaleria[7])));
    String[] coordsTexto = split(strings[2], ",");
    texto = new Texto(new PVector(int(coordsTexto[0]), int(coordsTexto[1])), 
      new PVector(int(coordsTexto[2]), int(coordsTexto[3])), new PVector(int(coordsTexto[4]), int(coordsTexto[5])), 
      new PVector(int(coordsTexto[6]), int(coordsTexto[7])), "ficha_0/texto.jpg");
  }

  void resetEsquinas() {
    lamina1.setEsquinas(new PVector(172, 17), 
      new PVector(918, 17), new PVector(918, 1065), 
      new PVector(172, 1065));
    galeria.setEsquinas(new PVector(974, 62), 
      new PVector(1528, 62), new PVector(1528, 452), 
      new PVector(974, 452)); 
    texto.setEsquinas(new PVector(1014, 575), 
      new PVector(1273, 575), new PVector(1273, 1046), 
      new PVector(1014, 1046));
  }
  void prepareNextImages() {
    lamina1.prepareNextImage("ficha_"+int(seleccion)+"/ficha.jpg");
    galeria.prepareNextImages(3);
    texto.prepareNextImage("ficha_"+int(seleccion)+"/texto.jpg");
  }
  void setNewImages() {
    lamina1.setNewImage();
    galeria.setNewImages();
    texto.setNewImage();
  }

  void updateAndDibujar() {
    galeria.update();  
    texto.update();
    lamina1.checkCalib();
    texto.checkCalib();
    galeria.dibujar();
    lamina1.dibujar();    
    texto.dibujar();
  }
}