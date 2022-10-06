import java.io.*;

public class Test {


    public static void main(String[] args) {
/*
        int x, y, regN;

        StringBuilder ans = new StringBuilder();

        for (regN = 0, x = 250, y = 50; regN < 32; regN++, y += 70) {

            ans.append(String.format("""
                    <wire from="(270,%d)" to="(280,%d)"/>
                    <comp lib="0" loc="(270,%d)" name="Tunnel">
                      <a name="facing" val="east"/>
                      <a name="width" val="32"/>
                      <a name="label" val="in%d"/>
                    </comp>""".indent(4), y,y,y,regN));
        }
        System.out.println(ans);*/
        try {
            BufferedReader in = new BufferedReader(new FileReader("P0_L0_GRF.circ"));
            BufferedWriter out = new BufferedWriter(new FileWriter("new.circ"));

            while (true) {
                String s = in.readLine();
                if (s == null)
                    break;
                String content = s.replaceAll("reset[0-9]*", "reset");
                out.write(content + "\n");
            }
            out.close();
        } catch (IOException e) {
            throw new RuntimeException(e);
        }

    }
}