import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;
import processing.net.*;
import java.util.*;

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
String CAT = "b";
ArrayList<String> nombres = new ArrayList<String>();
java.io.FilenameFilter jpgFilter = new java.io.FilenameFilter() {
  boolean accept(File dir, String name) {
    return name.toLowerCase().endsWith(".jpg");
  }
};
int timeSleep  = 1800000;
int lastSleep = 0;
boolean isSleeping = false;
PFont tFont;
void setup() {
  fullScreen(P2D);
  //size(1920, 1080, P2D);
  leerStrings();
  leerNombres();
  myServer = new Server(this, port); // Starts a server on port 10002
  Ani.init(this);
  pantalla = new Pantalla();
  String[] coordsLista = split(strings[3], ",");
  lista = new Lista(new PVector(int(coordsLista[0]), int(coordsLista[1])), 
    new PVector(int(coordsLista[2]), int(coordsLista[3])), new PVector(int(coordsLista[4]), int(coordsLista[5])), 
    new PVector(int(coordsLista[6]), int(coordsLista[7])));
  noCursor();
  tFont = loadFont("AlegreyaSansSC-Bold-48.vlw");
  textFont(tFont);
}

void draw() {
  background(0);
  if (!isSleeping) {
    pantalla.updateAndDibujar();
    if (showStroke)lista.checkCalib();
    if (frameCount % 10 == 0) {
      println(frameRate);
    }
    lista.checkChange();
    lista.dibujar();
    checkClient();
  }
  checkSleep();
}