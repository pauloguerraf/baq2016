void checkClient() {
  Client thisClient = myServer.available();
  if (thisClient !=null) {
    if (thisClient.available() > 0) {
      enc = thisClient.read();
      if (abs(enc-lastPosicion) > 1) {
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
void serverEvent(Server someServer, Client someClient) {
  println("We have a new client: " + someClient.ip());
}