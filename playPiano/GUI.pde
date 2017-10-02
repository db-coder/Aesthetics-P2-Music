 // ********************************************************* GUI
 
void keyPressed()
  {
  if(key=='`') {playAndShowNote(0); if(recording) T.recordNote(0);}
  if(key=='1') {playAndShowNote(1); if(recording) T.recordNote(1);}
  if(key=='2') {playAndShowNote(2); if(recording) T.recordNote(2);}
  if(key=='3') {playAndShowNote(3); if(recording) T.recordNote(3);}
  if(key=='4') {playAndShowNote(4); if(recording) T.recordNote(4);}
  if(key=='5') {playAndShowNote(5); if(recording) T.recordNote(5);}
  if(key=='6') {playAndShowNote(6); if(recording) T.recordNote(6);}
  if(key=='7') {playAndShowNote(7); if(recording) T.recordNote(7);}
  if(key=='8') {playAndShowNote(8); if(recording) T.recordNote(8);}
  if(key=='9') {playAndShowNote(9); if(recording) T.recordNote(9);}
  if(key=='0') {playAndShowNote(10); if(recording) T.recordNote(10);}
  if(key=='-') {playAndShowNote(11); if(recording) T.recordNote(11);}
  if(key=='=') {playAndShowNote(12); if(recording) T.recordNote(12);}
  if(key=='q') {playAndShowNote(13); if(recording) T.recordNote(13);}
  if(key=='w') {playAndShowNote(14); if(recording) T.recordNote(14);}
  if(key=='e') {playAndShowNote(15); if(recording) T.recordNote(15);}
  if(key=='r') {playAndShowNote(16); if(recording) T.recordNote(16);}
  if(key=='t') {playAndShowNote(17); if(recording) T.recordNote(17);}
  if(key=='y') {playAndShowNote(18); if(recording) T.recordNote(18);}
  if(key=='u') {playAndShowNote(19); if(recording) T.recordNote(19);}
  if(key=='i') {playAndShowNote(20); if(recording) T.recordNote(20);}
  if(key=='o') {playAndShowNote(21); if(recording) T.recordNote(21);}
  if(key=='p') {playAndShowNote(22); if(recording) T.recordNote(22);}
  if(key=='[') {playAndShowNote(23); if(recording) T.recordNote(23);}
  if(key==']') {playAndShowNote(24); if(recording) T.recordNote(24);}
  if(key=='\\') {playAndShowNote(25); if(recording) T.recordNote(25);} 
  if(key==' ') { if(recording) T.recordNote(-1);} 
    
  if(key=='s') T.startRecording();
  if(key=='f') T.endRecording();
  if(key=='c') T.resumeRecording();
  if(key=='z') T.startTune(mouseX);
  if(key=='x') playing=false;
  if(key==',') {T.makeRandom(); T.startTune();} // set whole tune to random
  if(key=='.') {T.fillInRandom(); T.startTune();} // set center to random
  if(key=='/') {T.myFillIn(); T.startTune();} // use student's method to set center to random
  if(key==':') T.reset();
  if(key==';') T.resetMiddle();
  if(key=='?') T.printNotes();
  if(key=='S') saveTune(folder+fileName);
  if(key=='L') loadTune(folder+fileName);
  if(key=='F') fileName=getClipboard();
  if(key=='T') {String S=T.convertToString(); println("Saved to clipboard: "+S); setClipboard(S);}
  if(key=='C') {String S=getClipboard(); println("Loaded from clipboard: "+S); T.ConstructFromString(S);}
  if(key=='~') snapPic=true; // to snap an image of the canvas and save as a PDF
  if(key=='\'') showStaff=!showStaff;
  if(key=='#') addSharp();
  if(key=='@') resetSharp(); 
  }
  
void mousePressed() 
  {
  T.toggleSlot(mouseX,mouseY);  
  }