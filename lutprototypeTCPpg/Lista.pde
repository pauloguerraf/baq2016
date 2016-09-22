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
    loc = new PVector(0.7354*width, 0.7291*height);
    pg = createGraphics(int(0.0822*width), int(0.5111*height), P3D);
  }

  void setEsquinas(PVector pos1_, PVector pos2_, PVector pos3_, PVector pos4_) {
    esquinas[0] = new PVector(pos1_.x, pos1_.y);  
    esquinas[1] = new PVector(pos2_.x, pos2_.y);    
    esquinas[2] = new PVector(pos3_.x, pos3_.y);    
    esquinas[3] = new PVector(pos4_.x, pos4_.y);
  }

  void dibujar() {
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
    pg.fill(#48F1FF);
    pg.beginShape();
    pg.vertex(0, 0.475*pg.height, 0, 0);   
    pg.vertex(pg.width, 0.475*pg.height, 1, 0);
    pg.vertex(pg.width, 0.525*pg.height, 1, 1);
    pg.vertex(0, 0.525*pg.height, 0, 1);
    pg.endShape(CLOSE);
    for (int i=0; i<nombres.size(); i++) {
      pg.pushMatrix();
      float posy = 0.5*pg.height+0.05*pg.height*i-0.05*pg.height*seleccion;
      pg.translate(0.5*pg.width, posy);
      if (posy<0.5*pg.height-0.005*pg.height/2 || posy>0.5*pg.height+0.005*pg.height/2) pg.fill(150);
      else pg.fill(255);
      pg.textAlign(CENTER, CENTER);
      pg.textSize(16);
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

  void checkCalib() {
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

  void checkChange() {
    if (millis()-lastMover>1000 && seleccion != lastSeleccion && !isChanging) {
      isChanging = true;
      pantalla.prepareNextImages();
      Ani.to(this, 2.0, "opacity", 280, Ani.EXPO_IN_OUT, "onEnd:changeImages");
    }
  }
  void changeImages() {
    pantalla.setNewImages();
    lastSeleccion = seleccion;
    Ani.to(this, 1.0, "opacity", 0, Ani.EXPO_IN, "onEnd:changeState");
  }

  void changeState() {
    isChanging = false;
  }

  void recorrer() {
    lastMover = millis();
    if (keyCode == DOWN && seleccion<nombres.size()-1) {
      seleccion = seleccion+1;
    }
    if (keyCode == UP && seleccion>0) {
      seleccion = seleccion-1;
    }
  }

  void recorrerEncoder(int dir) {
    lastMover = millis();
    if (dir == 1 && seleccion<nombres.size()-1) {
      seleccion = seleccion+1;
    }
    if (dir == -1 && seleccion>0) {
      seleccion = seleccion-1;
    }
  }
}