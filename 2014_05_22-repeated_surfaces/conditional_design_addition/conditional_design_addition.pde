import processing.video.*;

Capture cam;
PGraphics bg;
PGraphics curr;
PGraphics fg;
boolean m_bKP = false;
char m_cKey = ' ';

void setup() {
  size(2592/2, 1944/2);

  String[] cameras = Capture.list();
  
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(i + ": " + cameras[i]);
    }
    
    // The camera can be initialized directly using an 
    // element from the array returned by list():
    cam = new Capture(this, cameras[191]);
    cam.start();     
  }      
}

void draw() {
  if (cam.available() == true) {
    cam.read();
    if (bg == null){
      bg = createGraphics(cam.width, cam.height);
      fg = createGraphics(cam.width, cam.height);
      curr = createGraphics(cam.width, cam.height);
//      bg.beginDraw();
//      bg.image(cam, 0, 0);
//      bg.endDraw();
    }
    background(0);
    image(cam, 0, 0, width, height);
    blend(bg, 0, 0, bg.width, bg.height, 0, 0, width, height, DIFFERENCE);
    blend(fg, 0, 0, fg.width, fg.height, 0, 0, fg.width, fg.height, ADD);
    if (m_bKP){
      if (m_cKey == 'b'){
        println("capturing background");
        m_bKP = false;
        bg.beginDraw();
        bg.background(0);
        bg.image(cam, 0, 0);
        bg.endDraw();
      } else if (m_cKey == 'c'){
        println("capturing!");
        curr.beginDraw();
        curr.background(0);
        curr.image(cam, 0, 0);
        curr.blend(bg, 0, 0, cam.width, cam.height, 0, 0, curr.width, curr.height, DIFFERENCE);
        curr.endDraw();
        fg.beginDraw();
        fg.image(this.g, 0, 0);
        //fg.blend(curr, 0, 0, curr.width, curr.height, 0, 0, fg.width, fg.height, ADD);
        fg.endDraw();
        m_cKey = 's';
      } else if (m_cKey == 'f'){
        image(fg, 0, 0, width, height);
      } else if (m_cKey == 'r'){
        m_bKP = false;
      } else if (m_cKey == 'm'){
        background(0);
        image(cam, 0, 0, width, height);
      } else if (m_cKey == 's'){
        saveFrame();
        m_bKP = false;
      } else {
        m_bKP = false;
      }
    }
  }
  // The following does the same, and is faster when just drawing the image
  // without any additional resizing, transformations, or tint.
  //set(0, 0, cam);
}

void keyPressed(){
  m_bKP = true;
  m_cKey = key;
  println("keypressed: " + key);
}
  

