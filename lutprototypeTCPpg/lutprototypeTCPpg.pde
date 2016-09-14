import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;
import processing.net.*;

int port = 10002;   
Server myServer;    
int enc; 
Lista lista;
Pantalla pantalla;
float seleccion = 0;
float lastPosicion = 0;
float currentPosicion = 0;
int numFichas = 3;
boolean isChanging = false;
boolean showStroke = false;
String [] strings = new String[4];

void setup() {
  size(1920, 1080, P2D);
  leerStrings();
  //fullScreen(P3D);
  myServer = new Server(this, port); // Starts a server on port 10002
  Ani.init(this);
  pantalla = new Pantalla();
  String[] coordsLista = split(strings[3], ",");
  lista = new Lista(new PVector(int(coordsLista[0]), int(coordsLista[1])), 
    new PVector(int(coordsLista[2]), int(coordsLista[3])), new PVector(int(coordsLista[4]), int(coordsLista[5])), 
    new PVector(int(coordsLista[6]), int(coordsLista[7])));
  noCursor();
}

void draw() {
  background(0);
  pantalla.updateAndDibujar();
  if (showStroke)lista.checkCalib();
  if (frameCount % 10 == 0) {
    //println(frameRate);
  }
  lista.checkChange();
  lista.dibujar();
  checkClient();
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

void checkClient() {
  Client thisClient = myServer.available();
  if (thisClient !=null) {
    if (thisClient.available() > 0) {
      enc = thisClient.read();
      if (abs(enc-lastPosicion) > 2) {
        currentPosicion = enc;
        if (currentPosicion>lastPosicion) {
          lista.recorrerEncoder(1);
          lastPosicion = currentPosicion;
        } else if (currentPosicion<lastPosicion) {
          lista.recorrerEncoder(-1);
          lastPosicion = currentPosicion;
        }
      }
    }
  }
}

void resetEsquinas() {
  lista.setEsquinas(new PVector(1333, 511), 
    new PVector(1491, 511), new PVector(1491, 1064), 
    new PVector(1333, 1064));
  pantalla.resetEsquinas();
}

void leerStrings() {
  strings = loadStrings("esquinas.txt");
}
void save() {
  strings[0] = ""+pantalla.lamina1.esquinas.get(0).x+","
    +pantalla.lamina1.esquinas.get(0).y+","
    +pantalla.lamina1.esquinas.get(1).x+","
    +pantalla.lamina1.esquinas.get(1).y+","
    +pantalla.lamina1.esquinas.get(2).x+","
    +pantalla.lamina1.esquinas.get(2).y+","
    +pantalla.lamina1.esquinas.get(3).x+","
    +pantalla.lamina1.esquinas.get(3).y;
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

void serverEvent(Server someServer, Client someClient) {
  println("We have a new client: " + someClient.ip());
}