void checkClient() {
  Client thisClient = myServer.available();
  if (thisClient !=null) {
    if (thisClient.available() > 0) {
      enc = thisClient.read();
      if (abs(enc-lastPosicion) > 0) {
        lastSleep = millis();
        currentPosicion = enc;
        if (currentPosicion>lastPosicion) {
          recorrerEncoder(1);
          println("up encoder pos: " + currentPosicion);
          lastPosicion = currentPosicion;
        } else if (currentPosicion<lastPosicion) {
          recorrerEncoder(-1);
          println("down encoder pos: " + currentPosicion);
          lastPosicion = currentPosicion;
        }
      }
    }
  }
}
void serverEvent(Server someServer, Client someClient) {
  println("We have a new client: " + someClient.ip());
}