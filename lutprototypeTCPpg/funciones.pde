void leerStrings() {
  strings = loadStrings("esquinas.txt");
}
void leerNombres() {
  String [] nom = loadStrings("categoria_"+CAT+"/nombres.txt");
  for (int i=0; i<nom.length; i++) {
    nombres.add(nom[i]);
  }
}
void save() {
  strings[0] = ""+pantalla.laminas.esquinas[0].x+","
    +pantalla.laminas.esquinas[0].y+","
    +pantalla.laminas.esquinas[1].x+","
    +pantalla.laminas.esquinas[1].y+","
    +pantalla.laminas.esquinas[2].x+","
    +pantalla.laminas.esquinas[2].y+","
    +pantalla.laminas.esquinas[3].x+","
    +pantalla.laminas.esquinas[3].y;
  strings[1] = ""+pantalla.galeria.esquinas[0].x+","
    +pantalla.galeria.esquinas[0].y+","
    +pantalla.galeria.esquinas[1].x+","
    +pantalla.galeria.esquinas[1].y+","
    +pantalla.galeria.esquinas[2].x+","
    +pantalla.galeria.esquinas[2].y+","
    +pantalla.galeria.esquinas[3].x+","
    +pantalla.galeria.esquinas[3].y;
  strings[2] = ""+pantalla.texto.esquinas[0].x+","
    +pantalla.texto.esquinas[0].y+","
    +pantalla.texto.esquinas[1].x+","
    +pantalla.texto.esquinas[1].y+","
    +pantalla.texto.esquinas[2].x+","
    +pantalla.texto.esquinas[2].y+","
    +pantalla.texto.esquinas[3].x+","
    +pantalla.texto.esquinas[3].y;
  saveStrings("data/esquinas.txt", strings);
}

void exit() {
  println("escribiendo archivo");
  save();
  super.exit();
}

void keyPressed() {
  lastSleep = millis();
  recorrer();
  if (key=='c') {
    showStroke = !showStroke;
    if (showStroke)cursor();
    else noCursor();
  } else if (key=='r') {
    resetEsquinas();
  }
  if (showStroke) {
    if (keyCode == RIGHT) {
      if (esq<11)esq++;
      else esq = 0;
    } else if (keyCode == LEFT) {
      if (esq>0)esq--;
      else esq = 11;
    }
  }
}

void checkSleep() {
  if ((millis()-lastSleep) > timeSleep) {
    isSleeping = true;
  } else isSleeping = false;
}

void resetEsquinas() {
  pantalla.resetEsquinas();
}
void recorrer() {
  if (keyCode == DOWN && seleccion<nombres.size()-1) {
    seleccion = seleccion+1;
  }
  if (keyCode == UP && seleccion>0) {
    seleccion = seleccion-1;
  }
  pantalla.prepareNextImages();
  changeImages();
}

void recorrerEncoder(int dir) {
  if (dir == 1 && seleccion<nombres.size()-1) {
    seleccion = seleccion+1;
  }
  if (dir == -1 && seleccion>0) {
    seleccion = seleccion-1;
  }
  pantalla.prepareNextImages();
  changeImages();
}

void changeImages() {
  pantalla.setNewImages();
}
void cursorpos() {
  //String cursorPos ="x:"+floor(mouseX)+" y:"+floor(mouseY);
  //fill(100);
  //text(cursorPos, mouseX+20, mouseY+20);
  fill(255);
  text(esq+1, 20, 50);
  pantalla.checkCalib();
}