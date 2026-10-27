package marketsoft.controller;
import marketsoft.dao.CategoriaDAO;
import marketsoft.model.Categoria;
import java.util.List;

public class CategoriaController {
    private final CategoriaDAO categoriaDAO = new CategoriaDAO();

    public List<Categoria> listarCategorias() { return categoriaDAO.listarTodas(); }

    public boolean guardarCategoria(String nombre) {
        if (nombre == null || nombre.isBlank()) return false;
        return categoriaDAO.guardar(nombre.trim());
    }

    public boolean eliminarCategoria(int id) { return categoriaDAO.eliminar(id); }
}