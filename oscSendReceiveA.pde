// Title:  OSC send & receive example A
// Author: Luke Demarest
// Github: https://github.com/feature-creature/processingOSCSendReceive
// Reference: http://www.sojamo.com/libraries/oscP5/reference/oscP5/OscMessage.html

import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress theirRemoteLocation;

int mouseXRemote = 0;
int mouseYRemote = 0;

void setup() {
  
  size(600,600);
  frameRate(15);
  background(0);  
  noFill();
  
  /*
  
  oscP5 allows us to send and receive data
  in the form of osc packets to/from another:
  1) machine (can be same or different)
  2) program 
  
  oscP5.send() uses a NetAddress as a parameter
  
  new NetAddress( "ip", port# );
  A NetAddress is an object that takes 2 parameters:
  1) ip address  (which machine on the current network)
  2) port number (which program on the machine)
  
  ip: 127.0.0.1 is universal slang term for self (this computer's ip address)
  note: if you are sending data across machines - you will have to use a *real* ip address

  port: 12000 is a typically unused port that we can use for our data.
  note: some port #s are pre-reserved for a particular well known program (ssh, ftp)
  */
  
  theirRemoteLocation = new NetAddress( "127.0.0.1", 12001 );
  
  /* start oscP5, listening for incoming messages on my port 12000 */
  oscP5 = new OscP5( this, 12000 );
  
}


void draw() {
  background(0);  
  
  // send my mouse data
  OscMessage myMessage = new OscMessage("/mouse");
  myMessage.add( mouseX );
  myMessage.add( mouseY );
  oscP5.send( myMessage, theirRemoteLocation ); 
  
  // draw my mouse
  strokeWeight(3);
  stroke(255,0,0);
  ellipse( mouseX, mouseY, 10, 10 );
  text("my mouse: " + mouseX + ", " + mouseY, mouseX+40, mouseY-10);
  
  // draw their mouse
  strokeWeight(3);
  stroke(0,0,255);
  ellipse( mouseXRemote, mouseYRemote, 50, 50 );
  text("remote mouse: " + mouseXRemote + ", " + mouseYRemote, mouseXRemote+40, mouseYRemote+10);

  // connecting line
  strokeWeight(1);
  stroke(255,50);
  line( mouseX, mouseY, mouseXRemote, mouseYRemote );
}


// oscEvent function receives the incoming osc messages 
void oscEvent(OscMessage theOscMessage) {
 
  // receive their mouse data
  if( theOscMessage.checkAddrPattern("/mouse") == true ){
    println("osc message: "+theOscMessage.addrPattern());
    mouseXRemote = theOscMessage.get(0).intValue();
    mouseYRemote = theOscMessage.get(1).intValue();
  }
  
}



void keyPressed() {
  background(0);
}
