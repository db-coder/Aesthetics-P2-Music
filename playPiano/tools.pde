import java.awt.Toolkit;
import java.awt.datatransfer.*;


// ********************************************************* TOOLS FOR TEXT AND PICTURES
boolean snapPic=false;
int pictureCounter=0;
String PicturesOutputPath=".";
void selectFolderForPDFs(File selection) {
  if (selection == null) println("Window was closed or the user hit cancel.");
  else PicturesOutputPath=selection.getAbsolutePath();
  println("    path to PDF image folder = "+PicturesOutputPath);
  }

void scribeHeader(String S, int i) {fill(0); text(S,10,20+i*20); noFill();} // writes black at line i
void scribeHeaderRight(String S) {fill(0); text(S,width-6.5*S.length(),20); noFill();} // writes black on screen top, right-aligned
void scribeFooter(String S, int i) {fill(0); text(S,10,height-10-i*20); noFill();} // writes black on screen at line i from bottom



// ********************************************************* FILE I/O
String folder="data/Tunes/", fileName = "practiceTune";

void saveTune(String fn) {
  String [] SS = new String[1];
  SS[0]=T.convertToString();
  saveStrings(fn,SS);
  println("saved tune to "+fn); 
  }; 


void loadTune(String fn) {
  String [] S = loadStrings(fn);
  T.ConstructFromString(S[0]);
  println("loaded tune from "+fn); 
  }; 
  
// ********************************************************* CLIPBOARD FOR CHANGING FILENAME
String clipText="myTune";

public static String getClipboard()    // returns content of clipboard (if it contains text) or null
       {
       Transferable t = Toolkit.getDefaultToolkit().getSystemClipboard().getContents(null);
       try 
         {
         if (t != null && t.isDataFlavorSupported(DataFlavor.stringFlavor)) 
               {
               String text = (String)t.getTransferData(DataFlavor.stringFlavor);
               return text; 
               }
         } 
       catch (UnsupportedFlavorException e) { } catch (IOException e) { }
       return null;
       }
       
public static void setClipboard(String str) // This method writes a string to the system clipboard.
       { 
       StringSelection ss = new StringSelection(str);
       Toolkit.getDefaultToolkit().getSystemClipboard().setContents(ss, null);
       }