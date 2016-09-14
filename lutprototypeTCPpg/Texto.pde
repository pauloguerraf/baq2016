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

  void setEsquinas(PVector pos1_, PVector pos2_, PVector pos3_, PVector pos4_) {
    esquinas[0] = new PVector(pos1_.x, pos1_.y);  
    esquinas[1] = new PVector(pos2_.x, pos2_.y);    
    esquinas[2] = new PVector(pos3_.x, pos3_.y);    
    esquinas[3] = new PVector(pos4_.x, pos4_.y);
  }

  void prepareNextImage(String str_) {
    nextImagePG = loadImage(str_);
  }
  void setNewImage() {
    imagePG = nextImagePG;
    posy=0;
  }

  void update() {
    if (posy > -imagePG.height) {
      posy-=0.1;
    } else {
      posy=0;
    }
  }
  void dibujar() {
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

  //void recorrer() {
  //  lastMover = millis();
  //  if (keyCode == DOWN && seleccion<nombres.size()-1) {
  //    seleccion = seleccion+1;
  //  }
  //  if (keyCode == UP && seleccion>0) {
  //    seleccion = seleccion-1;
  //  }
  //}
}
//class Texto {
//  ControlP5 cp5;
//  Textarea tArea;
//  ArrayList<PVector> esquinas = new ArrayList<PVector>();
//  float scroll = 0.0;
//  String fichaTxt = "";
//  float timeScroll = 0.0;
//  PImage image;

//  Texto(PVector pos1_, PVector pos2_, PVector pos3_, PVector pos4_, 
//    String file_) {
//    esquinas.add(new PVector(pos1_.x, pos1_.y));  
//    esquinas.add(new PVector(pos2_.x, pos2_.y));    
//    esquinas.add(new PVector(pos3_.x, pos3_.y));    
//    esquinas.add(new PVector(pos4_.x, pos4_.y));
//    String lines[] = loadStrings(file_);
//    cp5 = new ControlP5(parent);
//    cp5.setAutoDraw(false);
//    tArea = cp5.addTextarea("txt")
//      .setPosition(20, 20)
//      .setSize(int(pos2_.x-pos1_.x)-40, int(pos4_.y-pos1_.y)-40)
//      .setFont(createFont("arial", 12))
//      .setLineHeight(14)
//      .setColor(color(255))
//      .setColorBackground(color(0))
//      .hideScrollbar();
//    fichaTxt="";
//    for (int i = 0; i < lines.length; i++) {
//      //fichaTxt+=lines[i];
//    }
////    //tArea.setText(fichaTxt);
//    ti//meScroll = fichaTxt.length()/((pos2_.x-pos1_.x)/12);    
//    An//i.to(this, timeScroll/2, "scroll", 1.0, Ani.SINE_IN_OUT, "onEnd:scrollUp");
//  }
//  //vo//id setNewTexto(String file_) {
//    sc//roll = 0.0;
//    St//ring lines[] = loadStrings(file_);
//    fi//chaTxt="";
//    fo//r (int i = 0; i < lines.length; i++) {
//      //fichaTxt+=lines[i];
//    }
////    //tArea.setText(fichaTxt);
//    An//i.to(this, 30, "scroll", 1.0, Ani.LINEAR, "onEnd:scrollUp");
//  }
//  //vo//id scrollUp() {
//    An//i.to(this, 1, "scroll", 0.0, Ani.LINEAR, "onEnd:resetScroll");
//  }
//  //vo//id resetScroll() {
//    sc//roll=0.0;
//    An//i.to(this, timeScroll/2, "scroll", 1.0, Ani.SINE_IN_OUT, "onEnd:scrollUp");
//  }
//  //vo//id update() {
//    tA//rea.scroll(scroll);
//  }
//  //vo//id copiar() {
//    cp//5.draw();
//    PV//ector esq1= esquinas.get(0);
//    PV//ector esq2= esquinas.get(1);
//    PV//ector esq3= esquinas.get(2);
//    PV//ector esq4= esquinas.get(3);
//    im//age = get(0, 0, int(esq2.x-esq1.x), int(esq4.y-esq1.y));
//    ba//ckground(0);
//  }
//  //vo//id dibujar() {
//    PV//ector esq1= esquinas.get(0);
//    PV//ector esq2= esquinas.get(1);
//    PV//ector esq3= esquinas.get(2);
//    PV//ector esq4= esquinas.get(3);
//    if//(showStroke)stroke(255);
//    el//se noStroke();
//    be//ginShape();
//    if// (image != null) {
//      //texture(image);
//    }
////    //vertex(esq1.x, esq1.y, 0, 0);
//    ve//rtex(esq2.x, esq2.y, image.width, 0);
//    ve//rtex(esq3.x, esq3.y, image.width, image.height);
//    ve//rtex(esq4.x, esq4.y, 0, image.height);
//    en//dShape();
//  }

// // void checkCalib() {
//    fo//r (int i=0; i<esquinas.size(); i++) {
//      //if (dist(mouseX, mouseY, esquinas.get(i).x, esquinas.get(i).y) < 10) {
//      //  noFill();
//      //  if (mousePressed) {
//      //    esquinas.get(i).x = mouseX;
//      //    esquinas.get(i).y = mouseY;
//      //    stroke(255, 0, 255);
//      //  } else stroke(255, 0, 0);
//      //  ellipse(esquinas.get(i).x, esquinas.get(i).y, 20, 20);
//      //}
//    }
////    //tArea.setSize(int(esquinas.get(1).x-esquinas.get(0).x)-40, int(esquinas.get(3).y-esquinas.get(0).y)-40);
//  }
//}