import java.io.FileReader;
import java_cup.runtime.Symbol;

public class Main {
    public static void main(String[] args) {
        for (int i = 0; i < args.length; i++) {
            try {
                System.out.println("Lexing [" + args[i] + "]");
                VCScanner scanner = new VCScanner(new FileReader(args[i]));

                Symbol s;
                do {
                    s = scanner.debug_next_token();
                    System.out.println("token: " + s);
                } while (s.sym != sym.EOF);

                System.out.println("No errors.");
            } catch (Exception e) {
                e.printStackTrace(System.out);
                System.exit(1);
            }
        }
    }
}
