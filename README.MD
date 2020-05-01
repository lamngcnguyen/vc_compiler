## **VC Parser implementation on JFLex**
### **_Without CUP_**

Build using JFlex jar file

`java -jar lib\jflex-full-1.8.1.jar src\main\jflex\vc.flex`

Compile the scanner

`javac src\main\jflex\VCScanner.java`

Run the scanner

`java -cp src\main\jflex VCScanner <inputfile>`