package marketsoft.dao;
import marketsoft.config.ConexionSQLite;
import marketsoft.model.Producto;
import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class ProductoDAO {

    public boolean guardar(Producto p) {
        String sql = "INSERT INTO productos (codigo_barras, nombre, id_categoria, "
                + "precio_compra_unitario, precio_venta_unitario, viene_en_caja, "
                + "unidades_por_caja, precio_compra_caja, stock_unidades, stock_minimo, fecha_vencimiento) "
                + "VALUES (?,?,?,?,?,?,?,?,?,?,?)";
        try (PreparedStatement ps = ConexionSQLite.getConexion().prepareStatement(sql)) {
            mapearParametros(ps, p);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean actualizar(Producto p) {
        String sql = "UPDATE productos SET codigo_barras=?, nombre=?, id_categoria=?, "
                + "precio_compra_unitario=?, precio_venta_unitario=?, viene_en_caja=?, "
                + "unidades_por_caja=?, precio_compra_caja=?, stock_unidades=?, stock_minimo=?, "
                + "fecha_vencimiento=? WHERE id_producto=?";
        try (PreparedStatement ps = ConexionSQLite.getConexion().prepareStatement(sql)) {
            mapearParametros(ps, p);
            ps.setInt(12, p.getIdProducto());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private void mapearParametros(PreparedStatement ps, Producto p) throws SQLException {
        ps.setString(1, p.getCodigoBarras());
        ps.setString(2, p.getNombre());
        ps.setInt(3, p.getIdCategoria());
        ps.setDouble(4, p.getPrecioCompraUnitario());
        ps.setDouble(5, p.getPrecioVentaUnitario());
        ps.setInt(6, p.isVieneEnCaja() ? 1 : 0);
        ps.setInt(7, p.getUnidadesPorCaja());
        ps.setDouble(8, p.getPrecioCompraCaja());
        ps.setInt(9, p.getStockUnidades());
        ps.setInt(10, p.getStockMinimo());
        ps.setString(11, p.getFechaVencimiento() != null ? p.getFechaVencimiento().toString() : null);
    }

    public List<Producto> listarTodos() {
        List<Producto> lista = new ArrayList<>();
        String sql = "SELECT p.*, c.nombre AS nombre_categoria FROM productos p "
                + "LEFT JOIN categorias c ON p.id_categoria = c.id_categoria ORDER BY p.nombre";
        try (Statement st = ConexionSQLite.getConexion().createStatement(); ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                lista.add(mapearProducto(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    public List<Producto> buscarPorNombre(String texto) {
        List<Producto> lista = new ArrayList<>();
        String sql = "SELECT p.*, c.nombre AS nombre_categoria FROM productos p "
                + "LEFT JOIN categorias c ON p.id_categoria = c.id_categoria "
                + "WHERE p.nombre LIKE ? OR p.codigo_barras = ? ORDER BY p.nombre";
        try (PreparedStatement ps = ConexionSQLite.getConexion().prepareStatement(sql)) {
            ps.setString(1, "%" + texto + "%");
            ps.setString(2, texto);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(mapearProducto(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    public Producto buscarPorId(int idProducto) {
        String sql = "SELECT p.*, c.nombre AS nombre_categoria FROM productos p "
                + "LEFT JOIN categorias c ON p.id_categoria = c.id_categoria "
                + "WHERE p.id_producto = ?";
        try (PreparedStatement ps = ConexionSQLite.getConexion().prepareStatement(sql)) {
            ps.setInt(1, idProducto);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapearProducto(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Producto> listarStockBajo() {
        List<Producto> lista = new ArrayList<>();
        String sql = "SELECT p.*, c.nombre AS nombre_categoria FROM productos p "
                + "LEFT JOIN categorias c ON p.id_categoria = c.id_categoria "
                + "WHERE p.stock_unidades <= p.stock_minimo";
        try (Statement st = ConexionSQLite.getConexion().createStatement(); ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                lista.add(mapearProducto(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    public List<Producto> listarProximosAVencer(int diasLimite) {
        List<Producto> lista = new ArrayList<>();
        String sql = "SELECT p.*, c.nombre AS nombre_categoria FROM productos p "
                + "LEFT JOIN categorias c ON p.id_categoria = c.id_categoria "
                + "WHERE p.fecha_vencimiento IS NOT NULL "
                + "AND julianday(p.fecha_vencimiento) - julianday('now','-5 hours') <= ?";
        try (PreparedStatement ps = ConexionSQLite.getConexion().prepareStatement(sql)) {
            ps.setInt(1, diasLimite);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(mapearProducto(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    // Descuento de stock al procesar una venta — misma transacción que VentaDAO.registrarVenta()
    public void descontarStock(Connection conn, int idProducto, int cantidad) throws SQLException {
        String sql = "UPDATE productos SET stock_unidades = stock_unidades - ? WHERE id_producto = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, cantidad);
            ps.setInt(2, idProducto);
            ps.executeUpdate();
        }
    }

    // Reabastecimiento manual desde Inventario
    public boolean aumentarStock(int idProducto, int cantidad) {
        String sql = "UPDATE productos SET stock_unidades = stock_unidades + ? WHERE id_producto = ?";
        try (PreparedStatement ps = ConexionSQLite.getConexion().prepareStatement(sql)) {
            ps.setInt(1, cantidad);
            ps.setInt(2, idProducto);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Retiro manual de stock desde Inventario (mermas, ajustes, etc.)
    public boolean disminuirStock(int idProducto, int cantidad) {
        Producto actual = buscarPorId(idProducto);
        if (actual == null || actual.getStockUnidades() < cantidad) {
            return false; // no dejar stock negativo
        }
        String sql = "UPDATE productos SET stock_unidades = stock_unidades - ? WHERE id_producto = ?";
        try (PreparedStatement ps = ConexionSQLite.getConexion().prepareStatement(sql)) {
            ps.setInt(1, cantidad);
            ps.setInt(2, idProducto);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private Producto mapearProducto(ResultSet rs) throws SQLException {
        Producto p = new Producto();
        p.setIdProducto(rs.getInt("id_producto"));
        p.setCodigoBarras(rs.getString("codigo_barras"));
        p.setNombre(rs.getString("nombre"));
        p.setIdCategoria(rs.getInt("id_categoria"));
        p.setNombreCategoria(rs.getString("nombre_categoria"));
        p.setPrecioCompraUnitario(rs.getDouble("precio_compra_unitario"));
        p.setPrecioVentaUnitario(rs.getDouble("precio_venta_unitario"));
        p.setVieneEnCaja(rs.getInt("viene_en_caja") == 1);
        p.setUnidadesPorCaja(rs.getInt("unidades_por_caja"));
        p.setPrecioCompraCaja(rs.getDouble("precio_compra_caja"));
        p.setStockUnidades(rs.getInt("stock_unidades"));
        p.setStockMinimo(rs.getInt("stock_minimo"));
        String fecha = rs.getString("fecha_vencimiento");
        if (fecha != null) {
            p.setFechaVencimiento(LocalDate.parse(fecha));
        }
        return p;
    }
}
