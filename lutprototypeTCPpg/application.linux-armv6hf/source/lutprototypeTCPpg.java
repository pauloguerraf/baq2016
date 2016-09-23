import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import de.looksgood.ani.*; 
import de.looksgood.ani.easing.*; 
import processing.net.*; 
import java.util.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class lutprototypeTCPpg extends PApplet {






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
  public boolean accept(File dir, String name) {
    return name.toLowerCase().endsWith(".jpg");
  }
};
int timeSleep  = 1800000;
int lastSleep = 0;
boolean isSleeping = false;
PFont tFont;
public void setup() {
  
  //size(1920, 1080, P2D);
  leerStrings();
  leerNombres();
  myServer = new Server(this, port); // Starts a server on port 10002
  Ani.init(this);
  pantalla = new Pantalla();
  String[] coordsLista = split(strings[3], ",");
  lista = new Lista(new PVector(PApplet.parseInt(coordsLista[0]), PApplet.parseInt(coordsLista[1])), 
    new PVector(PApplet.parseInt(coordsLista[2]), PApplet.parseInt(coordsLista[3])), new PVector(PApplet.parseInt(coordsLista[4]), PApplet.parseInt(coordsLista[5])), 
    new PVector(PApplet.parseInt(coordsLista[6]), PApplet.parseInt(coordsLista[7])));
  noCursor();
  tFont = loadFont("AlegreyaSansSC-Bold-48.vlw");
  textFont(tFont);
}

public void draw() {
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
  int tiempoDeCambio = 7000;

  Galeria(PVector pos1_, PVector pos2_, PVector pos3_, PVector pos4_) {
    String path = sketchPath()+"/data/categoria_"+CAT+"/"+CAT+"_ficha_"+PApplet.parseInt(seleccion)+"/fotos"; 
    File dataFolder = new File(path); 
    String[] fileList = dataFolder.list(jpgFilter); 
    println(fileList.length + " jpg files in specified directory");
    numfots = fileList.length; 
    for (int i = 0; i<numfots; i++) {
      imagenes.add(loadImage("categoria_"+CAT+"/"+CAT+"_ficha_"+PApplet.parseInt(seleccion)+"/fotos/foto_"+i+".jpg"));
    }
    esquinas.add(new PVector(pos1_.x, pos1_.y));  
    esquinas.add(new PVector(pos2_.x, pos2_.y));    
    esquinas.add(new PVector(pos3_.x, pos3_.y));    
    esquinas.add(new PVector(pos4_.x, pos4_.y));
    opacity=255;
    println("fotos galeria : " + numfots);
  }

  public void setEsquinas(PVector pos1_, PVector pos2_, PVector pos3_, PVector pos4_) {
    esquinas.set(0, new PVector(pos1_.x, pos1_.y));  
    esquinas.set(1, new PVector(pos2_.x, pos2_.y));    
    esquinas.set(2, new PVector(pos3_.x, pos3_.y));    
    esquinas.set(3, new PVector(pos4_.x, pos4_.y));
  }

  public void setNewImages() {
    imagenes.clear();
    for (int i = 0; i<numfots; i++) {
      imagenes.add(nextImagenes.get(i));
    }
    currentfot = 0;
    lastChanged = millis();
    opacity=255;
  }

  public void prepareNextImages() {
    nextImagenes.clear();
    String path = sketchPath()+"/data/categoria_"+CAT+"/"+CAT+"_ficha_"+PApplet.parseInt(seleccion)+"/planos"; 
    File dataFolder = new File(path); 
    String[] fileList = dataFolder.list(); 
    numfots = fileList.length; 
    for (int i = 0; i<numfots; i++) {
      nextImagenes.add(loadImage("categoria_"+CAT+"/"+CAT+"_ficha_"+PApplet.parseInt(seleccion)+"/fotos/foto_"+i+".jpg"));
    }
    opacity=255;
  }

  public void update() {
    if ((millis()-lastChanged) > 7000 && !isChanging) {
      lastChanged = millis();
      isChanging = true;
      Ani.to(this, 1.0f, "opacity", 0, Ani.LINEAR, "onEnd:changePhoto");
    }
    checkCalib();
  }

  public void changePhoto() {
    if (currentfot < numfots-1)currentfot=currentfot+1;
    else currentfot = 0;
    Ani.to(this, 1.0f, "opacity", 255, Ani.LINEAR, "onEnd:changeState");
  }

  public void changeState() {
    isChanging = false;
  }

  public void dibujar() {
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

  public void checkCalib() {
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
    String path = sketchPath()+"/data/categoria_"+CAT+"/"+CAT+"_ficha_"+PApplet.parseInt(seleccion)+"/planos"; 
    File dataFolder = new File(path); 
    String[] fileList = dataFolder.list(jpgFilter); 
    println(fileList.length + " jpg files in specified directory");
    numplanos = fileList.length; 
    for (int i = 0; i<numplanos; i++) {
      imagenes.add(loadImage("categoria_"+CAT+"/"+CAT+"_ficha_"+PApplet.parseInt(seleccion)+"/planos/plano_"+i+".jpg"));
    }
    esquinas.add(new PVector(pos1_.x, pos1_.y));  
    esquinas.add(new PVector(pos2_.x, pos2_.y));    
    esquinas.add(new PVector(pos3_.x, pos3_.y));    
    esquinas.add(new PVector(pos4_.x, pos4_.y));
    println("fotos planos : " + numplanos);
    opacity=255;
  }

  public void setEsquinas(PVector pos1_, PVector pos2_, PVector pos3_, PVector pos4_) {
    esquinas.set(0, new PVector(pos1_.x, pos1_.y));  
    esquinas.set(1, new PVector(pos2_.x, pos2_.y));    
    esquinas.set(2, new PVector(pos3_.x, pos3_.y));    
    esquinas.set(3, new PVector(pos4_.x, pos4_.y));
  }

  public void setNewImages() {
    imagenes.clear();
    for (int i = 0; i<numplanos; i++) {
      imagenes.add(nextImagenes.get(i));
    }
    currentfot = 0;
    lastChanged = millis();
    opacity=255;
  }
  public void prepareNextImages() {
    nextImagenes.clear();
    String path = sketchPath()+"/data/categoria_"+CAT+"/"+CAT+"_ficha_"+PApplet.parseInt(seleccion)+"/planos"; 
    File dataFolder = new File(path); 
    String[] fileList = dataFolder.list(); 
    numplanos = fileList.length; 
    for (int i = 0; i<numplanos; i++) {
      nextImagenes.add(loadImage("categoria_"+CAT+"/"+CAT+"_ficha_"+PApplet.parseInt(seleccion)+"/planos/plano_"+i+".jpg"));
    }
    opacity=255;
  }

  public void update() {
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

  public void changePlano() {
    if (currentfot < numplanos-1)currentfot=currentfot+1;
    else currentfot = 0;
    opacity = 255;
    changeStatePlano();
    //Ani.to(this, 1.0, "opacity", 255, Ani.LINEAR, "onEnd:changeStatePlano");
  }

  public void changeStatePlano() {
    isChanging = false;
  }

  public void dibujar() {
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



  public void checkCalib() {
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
class Lista {
  PVector [] esquinas = new PVector[4];
  PVector loc;
  PGraphics pg;
  int lastMover = 0;
  float lastSeleccion = seleccion;
  float opacity = 0;
  PImage img;
  PVector esq1;
  PVector esq2;
  PVector esq3;
  PVector esq4;

  Lista(PVector pos1_, PVector pos2_, PVector pos3_, PVector pos4_) {
    esquinas[0] = new PVector(pos1_.x, pos1_.y);  
    esquinas[1] = new PVector(pos2_.x, pos2_.y);    
    esquinas[2] = new PVector(pos3_.x, pos3_.y);    
    esquinas[3] = new PVector(pos4_.x, pos4_.y);
    loc = new PVector(0.7354f*width, 0.7291f*height);
    pg = createGraphics(PApplet.parseInt(0.0822f*width), PApplet.parseInt(0.5111f*height), P3D);
  }

  public void setEsquinas(PVector pos1_, PVector pos2_, PVector pos3_, PVector pos4_) {
    esquinas[0] = new PVector(pos1_.x, pos1_.y);  
    esquinas[1] = new PVector(pos2_.x, pos2_.y);    
    esquinas[2] = new PVector(pos3_.x, pos3_.y);    
    esquinas[3] = new PVector(pos4_.x, pos4_.y);
  }

  public void dibujar() {
    esq1= esquinas[0];
    esq2= esquinas[1];
    esq3= esquinas[2];
    esq4= esquinas[3];
    pg.beginDraw();
    pg.fill(0);
    if (showStroke)pg.stroke(255);
    else pg.noStroke();
    pg.beginShape();
    pg.vertex(0, 0, 0, 0);   
    pg.vertex(pg.width, 0, 1, 0);
    pg.vertex(pg.width, pg.height, 1, 1);
    pg.vertex(0, pg.height, 0, 1);
    pg.endShape();
    pg.fill(0xff48F1FF);
    pg.beginShape();
    pg.vertex(0, 0.475f*pg.height, 0, 0);   
    pg.vertex(pg.width, 0.475f*pg.height, 1, 0);
    pg.vertex(pg.width, 0.525f*pg.height, 1, 1);
    pg.vertex(0, 0.525f*pg.height, 0, 1);
    pg.endShape(CLOSE);
    for (int i=0; i<nombres.size(); i++) {
      pg.pushMatrix();
      float posy = 0.5f*pg.height+0.05f*pg.height*i-0.05f*pg.height*seleccion;
      pg.translate(0.5f*pg.width, posy);
      if (posy<0.5f*pg.height-0.005f*pg.height/2 || posy>0.5f*pg.height+0.005f*pg.height/2) pg.fill(150);
      else pg.fill(255);
      pg.textAlign(CENTER, CENTER);
      pg.textSize(10);
      if (i==seleccion)fill(0);
      pg.text(nombres.get(i), 0, 0);
      pg.popMatrix();
    }
    pg.endDraw();
    img = pg.get(0, 0, pg.width, pg.height);
    beginShape();
    if (img != null) {
      texture(img);
    }
    vertex(esq1.x, esq1.y, 0, 0);
    vertex(esq2.x, esq2.y, img.width, 0);
    vertex(esq3.x, esq3.y, img.width, img.height);
    vertex(esq4.x, esq4.y, 0, img.height);
    endShape(CLOSE);
    fill(0, opacity);
    beginShape();
    vertex(0, 0, 0, 0);   
    vertex(width, 0, 1, 0);
    vertex(width, height, 1, 1);
    vertex(0, height, 0, 1);
    endShape(CLOSE);
  }

  public void checkCalib() {
    for (int i=0; i<esquinas.length; i++) {
      if (dist(mouseX, mouseY, esquinas[i].x, esquinas[i].y) < 10) {
        noFill();
        if (mousePressed) {
          esquinas[i].x = mouseX;
          esquinas[i].y = mouseY;
          stroke(255, 0, 255);
        } else stroke(255, 0, 0);
        ellipse(esquinas[i].x, esquinas[i].y, 20, 20);
      }
    }
  }

  public void checkChange() {
    if (millis()-lastMover>1000 && seleccion != lastSeleccion && !isChanging) {
      isChanging = true;
      pantalla.prepareNextImages();
      Ani.to(this, 2.0f, "opacity", 280, Ani.EXPO_IN_OUT, "onEnd:changeImages");
    }
  }
  public void changeImages() {
    pantalla.setNewImages();
    lastSeleccion = seleccion;
    Ani.to(this, 1.0f, "opacity", 0, Ani.EXPO_IN, "onEnd:changeState");
  }

  public void changeState() {
    isChanging = false;
  }

  public void recorrer() {
    lastMover = millis();
    if (keyCode == DOWN && seleccion<nombres.size()-1) {
      seleccion = seleccion+1;
    }
    if (keyCode == UP && seleccion>0) {
      seleccion = seleccion-1;
    }
  }

  public void recorrerEncoder(int dir) {
    lastMover = millis();
    if (dir == 1 && seleccion<nombres.size()-1) {
      seleccion = seleccion+1;
    }
    if (dir == -1 && seleccion>0) {
      seleccion = seleccion-1;
    }
  }
}
class Pantalla {

  PApplet parent;
  GaleriaPlanos laminas;
  Galeria galeria;
  Texto texto;
  Pantalla() {
    String[] coordsLamina = split(strings[0], ",");
    laminas = new GaleriaPlanos(new PVector(PApplet.parseInt(coordsLamina[0]), PApplet.parseInt(coordsLamina[1])), 
      new PVector(PApplet.parseInt(coordsLamina[2]), PApplet.parseInt(coordsLamina[3])), new PVector(PApplet.parseInt(coordsLamina[4]), PApplet.parseInt(coordsLamina[5])), 
      new PVector(PApplet.parseInt(coordsLamina[6]), PApplet.parseInt(coordsLamina[7])));
    String[] coordsGaleria = split(strings[1], ",");
    galeria = new Galeria(new PVector(PApplet.parseInt(coordsGaleria[0]), PApplet.parseInt(coordsGaleria[1])), 
      new PVector(PApplet.parseInt(coordsGaleria[2]), PApplet.parseInt(coordsGaleria[3])), new PVector(PApplet.parseInt(coordsGaleria[4]), PApplet.parseInt(coordsGaleria[5])), 
      new PVector(PApplet.parseInt(coordsGaleria[6]), PApplet.parseInt(coordsGaleria[7])));
    String[] coordsTexto = split(strings[2], ",");
    texto = new Texto(new PVector(PApplet.parseInt(coordsTexto[0]), PApplet.parseInt(coordsTexto[1])), 
      new PVector(PApplet.parseInt(coordsTexto[2]), PApplet.parseInt(coordsTexto[3])), new PVector(PApplet.parseInt(coordsTexto[4]), PApplet.parseInt(coordsTexto[5])), 
      new PVector(PApplet.parseInt(coordsTexto[6]), PApplet.parseInt(coordsTexto[7])), "categoria_"+CAT+"/"+CAT+"_ficha_0/texto.jpg");
  }

  public void resetEsquinas() {
    laminas.setEsquinas(new PVector(172, 17), 
      new PVector(918, 17), new PVector(918, 1065), 
      new PVector(172, 1065));
    galeria.setEsquinas(new PVector(974, 62), 
      new PVector(1528, 62), new PVector(1528, 452), 
      new PVector(974, 452)); 
    texto.setEsquinas(new PVector(1014, 575), 
      new PVector(1273, 575), new PVector(1273, 1046), 
      new PVector(1014, 1046));
  }
  public void prepareNextImages() {
    laminas.prepareNextImages();
    galeria.prepareNextImages();
    texto.prepareNextImage("categoria_"+CAT+"/"+CAT+"_ficha_"+PApplet.parseInt(seleccion)+"/texto.jpg");
  }
  public void setNewImages() {
    laminas.setNewImages();
    galeria.setNewImages();
    texto.setNewImage();
  }

  public void updateAndDibujar() {
    laminas.update();
    galeria.update();  
    texto.update();
    galeria.dibujar();
    laminas.dibujar();    
    texto.dibujar();
  }
}
class Texto {
  PVector [] esquinas = new PVector[4];
  PVector loc;
  PGraphics pg;
  float opacity = 0;
  PImage img;
  PVector esq1;
  PVector esq2;
  PVector esq3;
  PVector esq4;
  PImage imagePG;
  PImage nextImagePG;
  float posy=0;

  Texto() {
  }

  Texto(PVector pos1_, PVector pos2_, PVector pos3_, PVector pos4_, String str_) {
    esquinas[0] = new PVector(pos1_.x, pos1_.y);  
    esquinas[1] = new PVector(pos2_.x, pos2_.y);    
    esquinas[2] = new PVector(pos3_.x, pos3_.y);    
    esquinas[3] = new PVector(pos4_.x, pos4_.y);
    pg = createGraphics(259, 471, P3D);
    imagePG = loadImage(str_);
  }

  public void setEsquinas(PVector pos1_, PVector pos2_, PVector pos3_, PVector pos4_) {
    esquinas[0] = new PVector(pos1_.x, pos1_.y);  
    esquinas[1] = new PVector(pos2_.x, pos2_.y);    
    esquinas[2] = new PVector(pos3_.x, pos3_.y);    
    esquinas[3] = new PVector(pos4_.x, pos4_.y);
  }

  public void prepareNextImage(String str_) {
    nextImagePG = loadImage(str_);
  }
  public void setNewImage() {
    imagePG = nextImagePG;
    posy=0;
  }

  public void update() {
    if (posy > -imagePG.height) {
      posy-=1.0f;
    } else {
      posy=0;
    }
    checkCalib();
  }
  public void dibujar() {
    esq1= esquinas[0];
    esq2= esquinas[1];
    esq3= esquinas[2];
    esq4= esquinas[3];
    pg.beginDraw();
    pg.image(imagePG, 0, posy);
    pg.endDraw();
    img = pg.get(0, 0, pg.width, pg.height);
    beginShape();
    if (img != null) {
      texture(img);
    }
    vertex(esq1.x, esq1.y, 0, 0);
    vertex(esq2.x, esq2.y, img.width, 0);
    vertex(esq3.x, esq3.y, img.width, img.height);
    vertex(esq4.x, esq4.y, 0, img.height);
    endShape(CLOSE);
  }

  public void checkCalib() {
    for (int i=0; i<esquinas.length; i++) {
      if (dist(mouseX, mouseY, esquinas[i].x, esquinas[i].y) < 10) {
        noFill();
        if (mousePressed) {
          esquinas[i].x = mouseX;
          esquinas[i].y = mouseY;
          stroke(255, 0, 255);
        } else stroke(255, 0, 0);
        ellipse(esquinas[i].x, esquinas[i].y, 20, 20);
      }
    }
  }
}
public void leerStrings() {
  strings = loadStrings("esquinas.txt");
}
public void leerNombres() {
  String [] nom = loadStrings("categoria_"+CAT+"/nombres.txt");
  for(int i=0; i<nom.length; i++){
    nombres.add(nom[i]);
  }
}
public void save() {
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

public void exit() {
  println("escribiendo archivo");
  save();
  super.exit();
}

public void keyPressed() {
  lastSleep = millis();
  lista.recorrer();
  if (key=='s') {
    showStroke = !showStroke;
    if (showStroke)cursor();
    else noCursor();
  } else if (key=='r') {
    resetEsquinas();
  }
}

public void checkSleep(){
  if ((millis()-lastSleep) > timeSleep) {
       isSleeping = true;
  }
  else isSleeping = false;
}

public void resetEsquinas() {
  lista.setEsquinas(new PVector(1333, 511), 
    new PVector(1491, 511), new PVector(1491, 1064), 
    new PVector(1333, 1064));
  pantalla.resetEsquinas();
}
public void checkClient() {
  Client thisClient = myServer.available();
  if (thisClient !=null) {
    if (thisClient.available() > 0) {
      enc = thisClient.read();
      if (abs(enc-lastPosicion) > 1) {
        lastSleep = millis();
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
public void serverEvent(Server someServer, Client someClient) {
  println("We have a new client: " + someClient.ip());
}
  public void settings() {  fullScreen(P2D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--present", "--window-color=#666666", "--hide-stop", "lutprototypeTCPpg" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
