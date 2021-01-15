import processing.serial.*;

Serial myPort;
String str_received="-1"; 
String portName="-";

float val1;
float[] keep_val1;

int nSample = 200;


void setup(){
  size(800, 600);
  printArray(Serial.list());
  
  portName = Serial.list()[Serial.list().length - 1];
  
  myPort = new Serial(this, portName, 9600);//38400
  
  keep_val1 = new float[nSample];
  
}


void draw(){
  
  background(255);
  fill(0);
  textSize(12); 
  String buf;
  
  buf = portName;
  text(buf, 20,50);
  
  
  buf = String.format("%06d", frameCount);
  text(buf, 20,70);
  
  textSize(32); 
  
  
  //text(str_received, 20,150);
  
  // https://processing.org/reference/trim_.html
  // Removes whitespace characters from the beginning and end of a String. 
  int distance = Integer.valueOf(str_received.trim());
  ShiftWithNewf(keep_val1, distance);
  
  
  buf = String.format("%d mm", distance);
  text(buf, 20,150);
  
  
  // Graph
  
  // Draw graph
  int offset_x1 = 100;
  int offset_y1 = 400;
  int y1, y2;
  float g = 0.75;
  float gx = 2.0;
  for(int i=0; i<nSample-1; i++)
  {
    y1 = int(offset_y1 - g* keep_val1[i]) - 0;
    y2 = int(offset_y1 - g* keep_val1[i+1]) - 0;
    stroke(255,0,0);
    line(offset_x1 + gx*i, y1, offset_x1 + gx*(i+1), y2);
    
  }
  
  
  
  
  
  
  
  
  
  // Serial 
  int lf = 10;    // Linefeed in ASCII
  while (myPort.available() > 0) 
  {
    String str1  = myPort.readStringUntil(lf);//myPort.readString();
    
    if (str1 != null) 
    {
      str_received = str1;
    }
  }
  
  
}




public static float GetMean(float[] arr)
{
  int sz = arr.length;
  int i;
  float sum =0;
  for(i=0; i< sz; i++)
  {
  sum = sum + arr[i];
  }
  
  float mean = sum / (float)i;
  return mean;
}

public static void ShiftWithNewf(float[] arr, float n_val) //
{
  int sz = arr.length;
  int i;
  for(i=0; i< sz-1; i++)
  {
    arr[sz-1-i] = arr[sz-2-i];
  
  }

  arr[0] = n_val;

}
