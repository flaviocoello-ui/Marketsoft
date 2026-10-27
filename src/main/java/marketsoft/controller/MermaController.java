package marketsoft.controller;

import marketsoft.dao.MermaDAO;
import marketsoft.model.Merma;
import java.util.List;

public class MermaController {
    private final MermaDAO dao = new MermaDAO();

    public boolean registrarMerma(int idProducto, int cantidadUnidades, String motivo) {
        if (cantidadUnidades <= 0) return false;
        return dao.registrarMerma(idProducto, cantidadUnidades, motivo);
    }

    public List<Merma> listarPorRango(String desde, String hasta) { return dao.listarPorRango(desde, hasta); }

    public double totalPerdida(List<Merma> lista) {
        return lista.stream().mapToDouble(Merma::getPerdidaTotal).sum();
    }
}
