package marketsoft.controller;
import marketsoft.dao.ReporteDAO;
import java.util.List;

public class ReporteController {
    private final ReporteDAO reporteDAO = new ReporteDAO();

    public List<ReporteDAO.FilaReporte> obtenerRentabilidad(String desde, String hasta) {
        return reporteDAO.rentabilidadPorRango(desde, hasta);
    }

    public List<ReporteDAO.FilaVenta> obtenerVentasConCosto(String desde, String hasta) {
        return reporteDAO.ventasConCostoPorRango(desde, hasta);
    }
}