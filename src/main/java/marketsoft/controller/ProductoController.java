package marketsoft.controller;
import marketsoft.dao.ProductoDAO;
import marketsoft.model.Producto;
import java.util.List;

public class ProductoController {

    private final ProductoDAO productoDAO = new ProductoDAO();

    public List<Producto> listarProductos() {
        return productoDAO.listarTodos();
    }

    public List<Producto> buscar(String texto) {
        return productoDAO.buscarPorNombre(texto);
    }

    public Producto obtenerPorId(int id) {
        return productoDAO.buscarPorId(id);
    }

    public List<Producto> alertasStockBajo() {
        return productoDAO.listarStockBajo();
    }

    public List<Producto> alertasPorVencer() {
        return productoDAO.listarProximosAVencer(5);
    }

    public boolean guardarProducto(Producto p) {
        if (p.getNombre() == null || p.getNombre().isBlank()) {
            return false;
        }
        if (p.isVieneEnCaja() && p.getUnidadesPorCaja() > 0) {
            double precioUnitarioCalculado = p.getPrecioCompraCaja() / p.getUnidadesPorCaja();
            p.setPrecioCompraUnitario(precioUnitarioCalculado);
        }
        return p.getIdProducto() == 0 ? productoDAO.guardar(p) : productoDAO.actualizar(p);
    }

    public boolean registrarIngresoStock(int idProducto, int cantidad) {
        if (cantidad <= 0) {
            return false;
        }
        return productoDAO.aumentarStock(idProducto, cantidad);
    }

    public boolean registrarRetiroStock(int idProducto, int cantidad) {
        if (cantidad <= 0) {
            return false;
        }
        return productoDAO.disminuirStock(idProducto, cantidad);
    }
}
