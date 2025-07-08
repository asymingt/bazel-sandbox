package org.ros;

import java.io.File;
import java.util.Scanner;
import com.google.devtools.build.runfiles.Runfiles; // Import the Runfiles library

public class Main {

  private Main() {}

  public static void main (String[] args) {
    try {
      Runfiles runfiles = Runfiles.create();
      String filePath = runfiles.rlocation("experimental/data");
      System.out.println("Path to data.txt: " + filePath);
      
      File file = new File(filePath + "/foo.txt");
      Scanner fileReader = new Scanner(file);
      while (fileReader.hasNextLine()) {
          String data = fileReader.nextLine();
          System.out.println(data);
      }
      fileReader.close();
      
    } catch (Exception e) {
        e.printStackTrace();
    }
  }
}