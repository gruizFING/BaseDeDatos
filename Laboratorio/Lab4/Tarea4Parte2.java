import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;

public class Tarea4Parte2 {

	public static void main(String[] args) 
	{
		String inputDataPath = args[0];
		String dbhost = args[1];
		String dbport = args[2];
		String dbname = args[3];
		String username = args[4];
		String password = args[5];
		
		BufferedReader inBuffer = null;
		BufferedWriter outBuffer = null;
		PrintWriter output = null;
		Connection connection = null;
		try {
			inBuffer = new BufferedReader(new FileReader(inputDataPath));
		} catch (FileNotFoundException e) {
			System.out.println("No se pudo abrir el archivo de entrada: " + e.getMessage());
			return;
		}
		try {
			outBuffer = new BufferedWriter(new FileWriter("bdatos34-resultados.txt"));
			output = new PrintWriter(outBuffer);
		} catch (IOException e) {
			System.out.println("No se pudo crear el archivo de salida: " + e.getMessage());
			return;
		}
		try {
			Class.forName("org.postgresql.Driver");
			connection = DriverManager.getConnection("jdbc:postgresql://" + dbhost + ":" + dbport + "/" + dbname, username, password);
			//Seteo autocommit en false para poder controlar fallas en la transaccion
			connection.setAutoCommit(false);
		} catch (ClassNotFoundException e) {
			System.out.println("No se encontro el Driver: " + e.getMessage());
			return;
		} catch (SQLException e) {
			System.out.println("No se pudo conectar a la base de datos: " + e.getMessage());
			return;
		}
		
		PreparedStatement insertAlquiler;
		PreparedStatement updateAlquiler;
		PreparedStatement insertPago;
		PreparedStatement updatePago;
		try {
			insertAlquiler = connection.prepareStatement(
								"INSERT INTO alquileres " +
								"(idPelicula, idSucursal, idCliente, fecha, idPersonal, fechaDevolucion) " +
								"VALUES (?, ?, ?, ?, ?, ?);"
							);
			updateAlquiler = connection.prepareStatement(
								"UPDATE alquileres " +
								"SET fechaDevolucion = ? " +
								"WHERE idPelicula = ? AND idSucursal = ? AND idCliente = ? AND fecha = ? AND idPersonal = ?;"
							);
			insertPago 	   = connection.prepareStatement(
								"INSERT INTO pagos " +
								"(idPeliculaAlquilo, idClienteAlquilo, idSucursalAlquilo, idPersonalAlquilo, fechaAlquilo, idPersonalRecibePago, fecha, monto) " +
								"VALUES (?, ?, ?, ?, ?, ?, ?, ?);"
							);
			updatePago     = connection.prepareStatement(
								"UPDATE pagos " +
								"SET monto = ? " +
								"WHERE idPeliculaAlquilo = ? AND idClienteAlquilo = ? AND idSucursalAlquilo = ? AND idPersonalAlquilo = ? AND fechaAlquilo = ? AND fecha = ?;"
							);
		} catch (SQLException e1) {
			System.out.println("Error en preparar un statment de SQL: " + e1.getMessage());
			return;
		}
		
		String linea;
		String movCod;
		String movParams;
		Integer idSucursal = null;
		DateFormat formato = new SimpleDateFormat("yyyy-MM-dd");
		java.util.Date utilFecha;
		java.sql.Date sqlFecha1, sqlFecha2;
		boolean falla = false;
		boolean errorCommit = false;
		
		try {
			while ((linea = inBuffer.readLine()) != null)
			{
				if (linea.startsWith("#i"))
				{
					idSucursal = Integer.parseInt(linea.substring(18, linea.length() - 1));
					falla = false;
					errorCommit = false;
				}
				else if (linea.startsWith("#f"))
				{
					if (!falla)
					{
						//Commit de la transaccion e imprimo un 1 en el archivo de salida
						errorCommit = true;
						connection.commit();
						output.println("1");
					}
					else
					{
						//Rollback de la transaccion e imprimo un 0 en el archivo de salida
						connection.rollback();
						output.println("0");
					}
				}
				else if (!falla)
				{
					movCod = linea.substring(0, 2);
					movParams = linea.substring(3, linea.length());
					String[] params = movParams.split(",");
					try {
						if (movCod.equals("AA"))
						{
							utilFecha = formato.parse(params[2].substring(1, params[2].length() - 1));
							sqlFecha1 = new java.sql.Date(utilFecha.getTime());
							utilFecha = formato.parse(params[4].substring(1, params[4].length() - 1));
							sqlFecha2 = new java.sql.Date(utilFecha.getTime());
							if (!sqlFecha2.before(sqlFecha1))
							{
								updateAlquiler.setDate(1, sqlFecha2);
								updateAlquiler.setInt(2, Integer.parseInt(params[0]));
								updateAlquiler.setInt(3, idSucursal);
								updateAlquiler.setInt(4, Integer.parseInt(params[1]));
								updateAlquiler.setDate(5, sqlFecha1);
								updateAlquiler.setInt(6, Integer.parseInt(params[3]));
								updateAlquiler.execute();
							}
							else
								//Lo tomo como falla
								throw new SQLException("La fecha de devolucion no es posterior a la fecha de alquiler");
						}
						else if (movCod.equals("IA"))
						{
							utilFecha = formato.parse(params[2].substring(1, params[2].length() - 1));
							sqlFecha1 = new java.sql.Date(utilFecha.getTime());
							if (params.length == 5)
							{
								utilFecha = formato.parse(params[4].substring(1, params[4].length() - 1));
								sqlFecha2 = new java.sql.Date(utilFecha.getTime());
							}
							else
								sqlFecha2 = null;
							insertAlquiler.setInt(1, Integer.parseInt(params[0]));
							insertAlquiler.setInt(2, idSucursal);
							insertAlquiler.setInt(3, Integer.parseInt(params[1]));
							insertAlquiler.setDate(4, sqlFecha1);
							insertAlquiler.setInt(5, Integer.parseInt(params[3]));
							insertAlquiler.setDate(6, sqlFecha2);
							insertAlquiler.execute();
						}
						else if (movCod.equals("AP"))
						{
							utilFecha = formato.parse(params[4].substring(1, params[4].length() - 1));
							sqlFecha1 = new java.sql.Date(utilFecha.getTime());
							utilFecha = formato.parse(params[5].substring(1, params[5].length() - 1));
							sqlFecha2 = new java.sql.Date(utilFecha.getTime());
							updatePago.setDouble(1, Double.parseDouble(params[6]));
							updatePago.setInt(2, Integer.parseInt(params[0]));
							updatePago.setInt(3, Integer.parseInt(params[1]));
							updatePago.setInt(4, Integer.parseInt(params[2]));
							updatePago.setInt(5, Integer.parseInt(params[3]));
							updatePago.setDate(6, sqlFecha1);
							updatePago.setDate(7, sqlFecha2);
							updatePago.execute();
						}
						else if (movCod.equals("IP"))
						{
							utilFecha = formato.parse(params[4].substring(1, params[4].length() - 1));
							sqlFecha1 = new java.sql.Date(utilFecha.getTime());
							utilFecha = formato.parse(params[6].substring(1, params[6].length() - 1));
							sqlFecha2 = new java.sql.Date(utilFecha.getTime());
							insertPago.setInt(1, Integer.parseInt(params[0]));
							insertPago.setInt(2, Integer.parseInt(params[1]));
							insertPago.setInt(3, Integer.parseInt(params[2]));
							insertPago.setInt(4, Integer.parseInt(params[3]));
							insertPago.setDate(5, sqlFecha1);
							insertPago.setInt(6, Integer.parseInt(params[5]));
							insertPago.setDate(7, sqlFecha2);
							insertPago.setDouble(8, Double.parseDouble(params[7]));
							insertPago.execute();
						}
					} catch (ParseException e) {
						System.out.println("Error de parseo con alguna fecha: " + e.getMessage());
						return;
					} catch (SQLException e) {
						//Ocurrio una falla en la operacion
						falla = true;
					}
				}
			}
		} catch (IOException e) {
			System.out.println("Error de E/S: " + e.getMessage());
			return;
		} catch (SQLException e) {
			if (errorCommit)
				System.out.println("Error al hacer commit: " + e.getMessage());
			else
				System.out.println("Error al hacer rollback: " + e.getMessage());
			return;
		}
		finally
		{
			try {
				inBuffer.close();
				outBuffer.close();
				output.close();
				insertAlquiler.close();
				updateAlquiler.close();
				insertPago.close();
				updatePago.close();
				connection.close();
			} catch (IOException e) {
				System.out.println("Error de E/S al cerrar un archivo: " + e.getMessage());
			}
			catch (SQLException e) {
				System.out.println("Error al cerrar statements o la conexion: " + e.getMessage());
			}
		}
	}
}
