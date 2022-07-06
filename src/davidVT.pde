import processing.sound.*;
Amplitude amp;
AudioIn in;

PImage open;
PImage open_alt;
PImage closed;
PImage chosen;
PImage chosenn;
PImage icon;

// Background Color
int bkr = 0;
int bkg = 255;
int bkb = 0;
// Background Color

void setup() {
  size(800,800);
  icon = loadImage("icon.png");
  surface.setIcon(icon);

  surface.setTitle("davidVT Processing Edition");
  surface.setResizable(true);
  
  open = loadImage("open.png");
  open_alt = loadImage("alternative.png");
  closed = loadImage("closed.png");
  chosen = closed;
  imageMode(CENTER);
  
  amp = new Amplitude(this);
  in = new AudioIn(this, 0);
  in.start();
  amp.input(in);
}

float volume;
float v_low = 0.06;
boolean info = true;
int bkmode = 0; // 0 = green, 1 = fuchsia, 2 = blue
String modechanger_current = "volume";

//Mode Integer
int mode = 0;
// 0 = None
// 1 = Bopping
// 2 = Alternating
// 3 = Bopping alternating
// (Image alternation is integrated on all)

int bopAmount = 10; // In pixels, how much to bop?
boolean alternateBool = false; // Is it speaking? (Avoids switching fastly due to loop)

void draw() {
  background(bkr, bkg, bkb);
  volume = float(nf(amp.analyze(), 0, 2));
  
  // Labels
  if (info) {
    textSize(24);
    
    if (bkmode != 2) {
      fill(0, 0, 0);
    } else {
      fill(255, 255, 255);
    }
    
    
    text(str(volume) + " (current)", 40, 40); // Current volume
    text(float(nf(v_low, 0, 2)) + " (required)", 40, 70); // Lowest Volume Required
    text(bopAmount + " (bop amount)", 40, 100); // Bop amount in pixels
    
    text(mode + " (mode)", width-160, 40); // Mode Using
    text(modechanger_current + " (scroll)", width-160, 70); // Bop amount in pixels
  }
  
  if (volume > v_low) {
    chosen = open;
  } else {
    chosen = closed;
  }
  
  // None
  if (mode == 0) {
    image(chosen, width/2, height/2);
  }
  
  //Bopping
  else if (mode == 1 && volume > v_low) {
    image(chosen, width/2, (height/2) - bopAmount);
  } else if (mode == 1 && volume < v_low) {
    image(chosen, width/2, height/2);
  } else if (mode == 1 && volume == v_low) {
    image(chosen, width/2, height/2);
  } 
  
  //Alternating
  else if (mode == 2 && volume > v_low) {
    if (!alternateBool) {
      int ra = int(random(1, 3));
      
      if (ra == 1) {
        image(open, width/2, height/2);
        chosenn = open;
      } else {
        image(open_alt, width/2, height/2);
        chosenn = open_alt;
      }
      
      alternateBool = true;
    } else {
      image(chosenn, width/2, height/2);
    }
  } else if (mode == 2 && volume < v_low) {
    image(chosen, width/2, height/2);
    alternateBool = false;
  } else if (mode == 2 && volume == v_low) {
    image(chosen, width/2, height/2);
    alternateBool = false;
  } 
  
  // Bopping Alternating
  else if (mode == 3 && volume > v_low) {
    if (!alternateBool) {
      int ra = int(random(1, 3));
      
      if (ra == 1) {
        image(open, width/2, (height/2) - bopAmount);
        chosenn = open;
      } else {
        image(open_alt, width/2, (height/2) - bopAmount);
        chosenn = open_alt;
      }
      
      alternateBool = true;
    } else {
      image(chosenn, width/2, (height/2) - bopAmount);
    }
  } else if (mode == 3 && volume < v_low) {
    image(chosen, width/2, height/2);
    alternateBool = false;
  } else if (mode == 3 && volume == v_low) {
    image(chosen, width/2, height/2);
    alternateBool = false;
  } 
}


// Mouse Scroll Events //
void mouseWheel(MouseEvent event) {
  float e = event.getCount(); // -1 up to 1 down
  
  if (modechanger_current == "volume") {
    if (e < 0 && v_low < 0.99) { // Scroll up
      v_low += 0.01;
    } else if (e > 0 && v_low > 0.01 ) { // Scroll down
      v_low -= 0.01;
    }
  } else if (modechanger_current == "bopper") {
    if (e < 0) { // Scroll up
      bopAmount++;
    } else if (e > 0) { // Scroll down
      bopAmount--;
    }
  }
}

// Keyboard Interrupt Events //
void keyPressed() {
  if (keyCode == java.awt.event.KeyEvent.VK_F1){
    link("https://github.com/davidlao27/davidVT-PE/blob/main/README.md");
  }
   
  if (key == 'i' || key == 'I') { // Info aka Semidebug Panel
      if (info) {
        info = false;
      } else {
        info = true;
      }
  } if (key == 'b' || key == 'B') { // Background Color Alternation
      if (bkmode == 0) {
        bkr = 255;
        bkg = 0;
        bkb = 255;
        bkmode = 1;
      } else if (bkmode == 1) {
        bkr = 0;
        bkg = 0;
        bkb = 255;
        bkmode = 2;
      } else if (bkmode == 2) {
        bkr = 0;
        bkg = 255;
        bkb = 0;
        bkmode = 0;
      }
  } else if (key == 'q' || key == 'Q') { // Backwards Mode List
    if (mode != 0) {
      mode--;
    }
  } else if (key == 'e' || key == 'E') { // Forwards Mode List
    if (mode != 3) {
      mode++;
    }
  } else if (key == 'w' || key == 'W') { // Scroll Mode Alternator Key
    if (modechanger_current == "volume") {
      modechanger_current = "bopper";
    } else if (modechanger_current == "bopper") {
      modechanger_current = "volume";
    }
  }
}
