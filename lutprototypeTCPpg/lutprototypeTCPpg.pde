import processing.net.*;
import java.util.*;

int port = 10002;   
Server myServer;    
int enc; 
Pantalla pantalla;
float seleccion = 0;
float lastPosicion = 0;
float currentPosicion = 0;
float rad = 10.0;
int numFichas = 3;
boolean isChanging = false;
boolean showStroke = false;
String [] strings = new String[4];
String CAT = "b";
ArrayList<String> nombres = new ArrayList<String>();
java.io.FilenameFilter jpgFilter = new java.io.FilenameFilter() {
  public boolean accept(File dir, String name) {
    return name.toLowerCase().endsWith(".jpg");
  }
};
int  timeSleep  = 1800000;
int lastSleep = 0;
boolean isSleeping = false;
PFont tFont;
int esq = 0;
void setup() {
  fullScreen(P2D);
  //size(1920, 1080, P2D);
  leerStrings();
  leerNombres();
  myServer = new Server(this, port); // Starts a server on port 10002
  pantalla = new Pantalla();
  noCursor();
  tFont = loadFont("AlegreyaSansSC-Bold-48.vlw");
  textFont(tFont);
  textureMode(NORMAL);
}

void draw() {
  background(0);
  if (!isSleeping) {
    pantalla.updateAndDibujar();
    if (frameCount % 30 == 0) {
      println(frameRate);
    }
    checkClient();
  }
  checkSleep();
  if (showStroke)cursorpos();
}