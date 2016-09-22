void leerStrings() {
  strings = loadStrings("esquinas.txt");
}
void leerNombres() {
  String [] nom = loadStrings("categoria_"+CAT+"/nombres.txt");
  for(int i=0; i<nom.length; i++){
    nombres.add(nom[i]);
  }
}
void save() {
  strings[0] = ""+pantalla.laminas.esquinas.get(0).x+","
    +pantalla.laminas.esquinas.get(0).y+","
    +pantalla.laminas.esquinas.get(1).x+","
    +pantalla.laminas.esquinas.get(1).y+","
    +pantalla.laminas.esquinas.get(2).x+","
    +pantalla.laminas.esquinas.get(2).y+","
    +pantalla.laminas.esquinas.get(3).x+","
    +pantalla.laminas.esquinas.get(3).y;
  strings[1] = ""+pantalla.galeria.esquinas.get(0).x+","
    +pantalla.galeria.esquinas.get(0).y+","
    +pantalla.galeria.esquinas.get(1).x+","
    +pantalla.galeria.esquinas.get(1).y+","
    +pantalla.galeria.esquinas.get(2).x+","
    +pantalla.galeria.esquinas.get(2).y+","
    +pantalla.galeria.esquinas.get(3).x+","
    +pantalla.galeria.esquinas.get(3).y;
  strings[2] = ""+pantalla.texto.esquinas[0].x+","
    +pantalla.texto.esquinas[0].y+","
    +pantalla.texto.esquinas[1].x+","
    +pantalla.texto.esquinas[1].y+","
    +pantalla.texto.esquinas[2].x+","
    +pantalla.texto.esquinas[2].y+","
    +pantalla.texto.esquinas[3].x+","
    +pantalla.texto.esquinas[3].y;
  strings[3] = ""+lista.esquinas[0].x+","
    +lista.esquinas[0].y+","
    +lista.esquinas[1].x+","
    +lista.esquinas[1].y+","
    +lista.esquinas[2].x+","
    +lista.esquinas[2].y+","
    +lista.esquinas[3].x+","
    +lista.esquinas[3].y;

  saveStrings("data/esquinas.txt", strings);
}

void exit() {
  println("escribiendo archivo");
  save();
  super.exit();
}

void keyPressed() {
  lista.recorrer();
  if (key=='s') {
    showStroke = !showStroke;
    if (showStroke)cursor();
    else noCursor();
  } else if (key=='r') {
    resetEsquinas();
  }
}

void resetEsquinas() {
  lista.setEsquinas(new PVector(1333, 511), 
    new PVector(1491, 511), new PVector(1491, 1064), 
    new PVector(1333, 1064));
  pantalla.resetEsquinas();
}