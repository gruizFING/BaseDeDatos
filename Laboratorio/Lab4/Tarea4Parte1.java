/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */


import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.GregorianCalendar;

/**
 *
 * @author Facultad
 */
public class Tarea4Parte1 {

    public static void main(String[] args) throws IOException {

        String dbhost = args[0];
        String dbport = args[1];
        String dbname = args[2];
        String username = args[3];
        String password = args[4];

        BufferedReader inBuffer = null;
        BufferedWriter outBuffer = null;
        PrintWriter output = null;
        Connection connection = null;


        try {
            Class.forName("org.postgresql.Driver");
            connection = DriverManager.getConnection("jdbc:postgresql://" + dbhost + ":" + dbport + "/" + dbname, username, password);
        } catch (ClassNotFoundException e) {
            System.out.println("No se encontro el Driver: " + e.getMessage());
            return;
        } catch (SQLException e) {
            System.out.println("No se pudo conectar a la base de datos: " + e.getMessage());
            return;
        }

        try {
            DateFormat formato = new SimpleDateFormat("yyyy-MM-dd");
            String sql =
                    "SELECT * FROM boletines ORDER BY idCliente,titulo,idpelicula ASC;";
            Statement comando = connection.createStatement(
                    ResultSet.TYPE_SCROLL_INSENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            Statement comando2 = connection.createStatement(
                    ResultSet.TYPE_SCROLL_INSENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            ResultSet resultado = comando.executeQuery(sql);

            boolean CambioUsr = true;
            String nombreArchivo = "bdatos34-mails.txt";
            FileWriter fw = new FileWriter("bdatos34-mails.txt");
          
            
            PrintWriter salArch = new PrintWriter(fw);
            String idCliente = null;
            GregorianCalendar FechaActual = new GregorianCalendar();
            Date FechaInf = new Date();
            Date FechaSup = new Date();
   
            boolean esPrimero = true;


            while (resultado.next()) {



                try {
                    if (!esPrimero) {
                        CambioUsr = !idCliente.equals(resultado.getString("idCliente"));
                    }
                    if (CambioUsr) {
                        if (!esPrimero) {
                            salArch.println();

                            String sql2 = "SELECT (per.nombre || ' ' ||per.apellido) AS nombre FROM personal per,clientes cl, sucursales suc WHERE cl.idCliente = " + idCliente + " AND suc.idSucursal = cl.idSucursal AND per.idPersonal = suc.idEncargado;";
                            

                            ResultSet resultado2 = comando2.executeQuery(sql2);
                            
                            resultado2.next();

                            salArch.print("Te esperamos pronto!");
                            salArch.println();

                            salArch.print("Saludos " + resultado2.getString("nombre"));
                            salArch.println();

                            salArch.print("(Nota: Los ingresos corresponden al periodo " + formato.format(FechaInf).toString() + " a " + formato.format(FechaSup).toString() + ")");
                            salArch.println();

                            salArch.print("#FIN MAIL#");
                            salArch.println();

                            salArch.println();

                        }

                        esPrimero = false;
                        //inicio
                        idCliente = resultado.getString("idCliente");

                        salArch.print("#INICIO MAIL#");

                        salArch.println();

                        salArch.print(resultado.getString("mail"));
                        salArch.println();

                        salArch.print("Asunto: Novedades en tu sucursal del video club");
                        salArch.println();

                        salArch.print("Fecha: " + formato.format(FechaActual.getTime()).toString());
                        salArch.println();
                        salArch.println();
                        
                        salArch.print("Hola " + resultado.getString("nombrecliente") + "!");
                        salArch.println();


                        salArch.print("Llegaron nuevas peliculas a nuestra sucursal.");
                        salArch.println();

                        salArch.print("Creemos que las siguientes peliculas te pueden interesar:");
                        salArch.println();
                      

                        salArch.print(resultado.getString("titulo") + ", las categorias de esta pelicula son: " + resultado.getString("categorias") + " y los actores que participan en la misma son: " + resultado.getString("actores") + ".");
                        salArch.println();
                        FechaInf = resultado.getDate("fecha");
                        FechaSup = resultado.getDate("fecha");

                    } else {
                        salArch.print(resultado.getString("titulo") + ", las categorias de esta pelicula son: " + resultado.getString("categorias") + " y los actores que participan en la misma son: " + resultado.getString("actores") + ".");
                        salArch.println();
                        Date Aux = resultado.getDate("fecha");

                        if (Aux.compareTo(FechaInf) < 0) {
                            FechaInf = Aux;
                        }
                        if (Aux.compareTo(FechaSup)>0 ) {
                            FechaSup = Aux;
                        }
                    }
                    
                } catch (Exception ex) {
                    System.out.println(ex.getMessage());
                }



            }
            salArch.println();

                            String sql2 = "SELECT (per.nombre || ' ' ||per.apellido) AS nombre FROM personal per,clientes cl, sucursales suc WHERE cl.idCliente = " + idCliente + " AND suc.idSucursal = cl.idSucursal AND per.idPersonal = suc.idEncargado;";
                            

                            ResultSet resultado2 = comando2.executeQuery(sql2);
                            
                            resultado2.next();

                            salArch.print("Te esperamos pronto!");
                            salArch.println();

                            salArch.print("Saludos " + resultado2.getString("nombre"));
                            salArch.println();

                            salArch.print("(Nota: Los ingresos corresponden al periodo " + formato.format(FechaInf).toString() + " a " + formato.format(FechaSup).toString() + ")");
                            salArch.println();

                            salArch.print("#FIN MAIL#");
                            
            salArch.close();
            fw.close();
            sql2 = "DELETE FROM boletines;";
            comando2.execute(sql2);
        } catch (SQLException ex) {
            System.out.println("No se encontro el Driver: " + ex.getMessage());
            return;
        }





    }
}
