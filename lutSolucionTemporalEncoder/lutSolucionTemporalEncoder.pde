import processing.net.*;

Client c;
Server s;
int enc = 0;
int lastPosicion = 0;
int currentPosicion = 0;
void setup() 
{
  size(450, 255);
  frameRate(10); 
  c = new Client(this, "127.0.0.1", 10003);
  s = new Server(this, 10002); 
}

void draw() 
{
  Client thisClient = s.available();
  if (thisClient !=null) {
    if (thisClient.available() > 0) {
      enc = thisClient.read();
      if (abs(enc-lastPosicion) > 0) {
        currentPosicion = enc;
        if (currentPosicion>lastPosicion) {
          println("up encoder pos: " + currentPosicion);
          lastPosicion = currentPosicion;
          if(c!=null)c.write(enc+"\n");
        } else if (currentPosicion<lastPosicion) {
          println("down encoder pos: " + currentPosicion);
          lastPosicion = currentPosicion;
          if(c!=null)c.write(enc+"\n");
        }
      }
    }
  }
}
void serverEvent(Server someServer, Client someClient) {
  println("We have a new client: " + someClient.ip());
}