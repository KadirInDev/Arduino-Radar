import processing.serial.*; 
import java.awt.event.KeyEvent;
import java.io.IOException;

Serial myPort;
String angle = "";
String distance = "";
String data = "";
String noObject = "";
float pixsDistance;
int iAngle = 0, iDistance = 0;
int index1 = 0;
PFont orcFont;

void setup() {
  size(1280, 800, P2D);  
 // smooth();
  myPort = new Serial(this, "COM4", 9600); 
  myPort.bufferUntil('.'); 
  orcFont = loadFont("Bahnschrift-48.vlw");
  if (orcFont == null) {
    println("Font yüklenemedi. Lütfen font dosyasının doğru dizinde olduğundan emin olun.");
  }
  
  background(0); 
}

void draw() {
  fill(98, 245, 31);
  textFont(orcFont);
  
  noStroke();
  fill(0, 4);
  rect(0, 0, width, 1010);
  
  fill(98, 245, 31); 
  drawRadar(); 
  drawLine();
  drawObject();
  drawText();
}

void serialEvent(Serial myPort) {
  try {
    data = myPort.readStringUntil('.');
    data = data.trim(); 

    // Eğer veri boş değilse
    if (data != null && data.length() > 0) {
      index1 = data.indexOf(","); 
      if (index1 != -1) {  
        angle = data.substring(0, index1); 
        distance = data.substring(index1 + 1); 
        
        // Verileri sayıya çevir
        iAngle = int(angle);
        iDistance = int(distance);
      }
    }
  } catch (Exception e) {
    println("Veri işlenirken hata oluştu: " + e.getMessage());
  }
}
void drawRadar() {
  pushMatrix();
  translate(width / 2, height - 100); // Merkezi ekran genişliğine göre ayarlama
  noFill();
  strokeWeight(2);
  stroke(98, 245, 31);
  
  // Yay çizgileri
  arc(0, 0, 1400, 1400, PI, TWO_PI);
  arc(0, 0, 1000, 1000, PI, TWO_PI);
  arc(0, 0, 600, 600, PI, TWO_PI);
  arc(0, 0, 400, 400, PI, TWO_PI);
  
  // Açı çizgileri
  for (int angle = 0; angle <= 180; angle += 30) {
    float x = -700 * cos(radians(angle));
    float y = -700 * sin(radians(angle));
    line(0, 0, x, y);
  }
  popMatrix();
}
void drawObject() {
  pushMatrix();
  translate(width / 2, height - 100); 
  strokeWeight(9);
  stroke(255, 10, 10); 
  pixsDistance = iDistance * 10; 
  
  if (iDistance < 40) {
    line(pixsDistance * cos(radians(iAngle)), 
         -pixsDistance * sin(radians(iAngle)), 
         650 * cos(radians(iAngle)), 
         -650 * sin(radians(iAngle)));
  }
  popMatrix();
}
void drawLine() {
  pushMatrix();
  strokeWeight(9);
  stroke(30, 250, 60);
  translate(width / 2, height - 100);
  line(0, 0, 650 * cos(radians(iAngle)), -650 * sin(radians(iAngle)));
  popMatrix();
}
void drawText() {
  pushMatrix();
  if (iDistance > 40) {
    noObject = "Out of Range";
  } else {
    noObject = "In Range";
  }
  fill(0);
  noStroke();
  rect(0, height - 60, width, height);
  fill(98, 245, 31);
  textSize(25);
  text("10cm", width / 2 + 150, height - 70);
  text("20cm", width / 2 + 300, height - 70);
  text("30cm", width / 2 + 450, height - 70);
  text("40cm", width / 2 + 600, height - 70); 
  textSize(40);
  text("Object: " + noObject, 50, height - 20);
  text("Angle: " + iAngle + " °", width / 2 - 200, height - 20);
  text("Distance: " + (iDistance < 40 ? iDistance + " cm" : ""), width / 2 + 200, height - 20);
  popMatrix();
}
