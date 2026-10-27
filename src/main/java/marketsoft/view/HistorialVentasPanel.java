package marketsoft.view;

import marketsoft.controller.VentaController;
import marketsoft.model.Venta;
import javax.swing.*;
import javax.swing.table.DefaultTableCellRenderer;
import javax.swing.table.DefaultTableModel;
import javax.swing.table.TableRowSorter;
import java.awt.*;
import java.sql.SQLException;
import java.time.format.DateTimeFormatter;
import java.util.List;

/** OPCION 14: Historial legible con filtros, colores por metodo y totalizador. */
public class HistorialVentasPanel extends JPanel {

    private final VentaController ventaController = new VentaController();
    private final DateTimeFormatter formatoFecha = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
    private final boolean puedeEliminar;

    private DefaultTableModel modeloVentas;
    private JTable tablaVentas;
    private TableRowSorter<DefaultTableModel> sorter;
    private JTextField txtFiltro;
    private JComboBox<String> cbMetodo;
    private JLabel lblTotalizador;

    public HistorialVentasPanel(boolean puedeEliminar) {
        this.puedeEliminar = puedeEliminar;
        setLayout(new BorderLayout(8, 8));
        setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));
        initComponents();
        cargarVentas();
    }

    private void initComponents() {
        JPanel filtros = new JPanel(new FlowLayout(FlowLayout.LEFT, 8, 4));
        filtros.setBorder(BorderFactory.createTitledBorder("Filtros"));
        txtFiltro = new JTextField(22);
        txtFiltro.putClientProperty("JTextField.placeholderText", "🔍 Cliente, DNI o ID…");
        txtFiltro.getDocument().addDocumentListener(new javax.swing.event.DocumentListener() {
            public void insertUpdate(javax.swing.event.DocumentEvent e) { aplicarFiltro(); }
            public void removeUpdate(javax.swing.event.DocumentEvent e) { aplicarFiltro(); }
            public void changedUpdate(javax.swing.event.DocumentEvent e) { aplicarFiltro(); }
        });
        cbMetodo = new JComboBox<>(new String[]{"Todos", "Efectivo", "Yape", "Plin"});
        cbMetodo.addActionListener(e -> aplicarFiltro());
        filtros.add(new JLabel("Buscar:"));
        filtros.add(txtFiltro);
        filtros.add(new JLabel("Método:"));
        filtros.add(cbMetodo);
        add(filtros, BorderLayout.NORTH);

        modeloVentas = new DefaultTableModel(
                new String[]{"ID", "Fecha", "Cliente", "DNI", "Método", "Monto Total"}, 0) {
            @Override public boolean isCellEditable(int r, int c) { return false; }
            @Override public Class<?> getColumnClass(int c) { return c == 0 ? Integer.class : String.class; }
        };
        tablaVentas = new JTable(modeloVentas);
        UiHelper.estiloTabla(tablaVentas);
        sorter = new TableRowSorter<>(modeloVentas);
        tablaVentas.setRowSorter(sorter);
        tablaVentas.getColumnModel().getColumn(4).setCellRenderer(new DefaultTableCellRenderer() {
            @Override public Component getTableCellRendererComponent(JTable t, Object v, boolean s, boolean f, int r, int c) {
                Component comp = super.getTableCellRendererComponent(t, v, s, f, r, c);
                if (!s) {
                    String m = v == null ? "" : v.toString();
                    setHorizontalAlignment(CENTER); setFont(getFont().deriveFont(Font.BOLD));
                    if (m.equals("Yape")) { comp.setBackground(new Color(0xE8EAF6)); comp.setForeground(new Color(0x4527A0)); }
                    else if (m.equals("Plin")) { comp.setBackground(new Color(0xE0F2F1)); comp.setForeground(new Color(0x00695C)); }
                    else { comp.setBackground(new Color(0xFFF3E0)); comp.setForeground(new Color(0xE65100)); }
                }
                return comp;
            }
        });
        add(new JScrollPane(tablaVentas), BorderLayout.CENTER);

        JPanel sur = new JPanel(new BorderLayout());
        lblTotalizador = new JLabel("—");
        lblTotalizador.setFont(new Font("Segoe UI", Font.BOLD, 13));
        sur.add(lblTotalizador, BorderLayout.WEST);
        JPanel botones = new JPanel(new FlowLayout(FlowLayout.RIGHT));
        JButton btnActualizar = new JButton("↻ Actualizar");
        btnActualizar.addActionListener(e -> cargarVentas());
        botones.add(btnActualizar);
        if (puedeEliminar) {
            JButton btnEliminar = new JButton("🗑 Eliminar seleccionada");
            btnEliminar.setToolTipText("Solo Administrador. Devuelve stock y descuenta del total.");
            btnEliminar.addActionListener(e -> eliminarVentaSeleccionada());
            botones.add(btnEliminar);
        } else {
            JLabel aviso = new JLabel("Solo lectura (rol Cajero)");
            aviso.setForeground(Color.GRAY);
            botones.add(aviso);
        }
        sur.add(botones, BorderLayout.EAST);
        add(sur, BorderLayout.SOUTH);
    }

    private void aplicarFiltro() {
        String texto = txtFiltro.getText().trim();
        String metodo = (String) cbMetodo.getSelectedItem();
        RowFilter<DefaultTableModel, Integer> rfTexto = texto.isEmpty() ? null
                : RowFilter.regexFilter("(?i)" + java.util.regex.Pattern.quote(texto));
        RowFilter<DefaultTableModel, Integer> rfMetodo = "Todos".equals(metodo) ? null
                : RowFilter.regexFilter("^" + java.util.regex.Pattern.quote(metodo) + "$", 4);
        if (rfTexto == null && rfMetodo == null) sorter.setRowFilter(null);
        else if (rfTexto == null) sorter.setRowFilter(rfMetodo);
        else if (rfMetodo == null) sorter.setRowFilter(rfTexto);
        else sorter.setRowFilter(RowFilter.andFilter(java.util.List.of(rfTexto, rfMetodo)));
        actualizarTotalizador();
    }

    public void recargar() { cargarVentas(); }

    private void cargarVentas() {
        modeloVentas.setRowCount(0);
        List<Venta> ventas = ventaController.listarVentas();
        for (Venta v : ventas) {
            modeloVentas.addRow(new Object[]{
                v.getIdVenta(),
                v.getFechaHora() != null ? v.getFechaHora().format(formatoFecha) : "",
                v.getNombreCliente() != null ? v.getNombreCliente() : "—",
                v.getDniCliente() != null ? v.getDniCliente() : "—",
                v.getMetodoPago(),
                String.format("S/. %.2f", v.getTotal())
            });
        }
        aplicarFiltro();
        if (ventas.isEmpty()) lblTotalizador.setText("Sin ventas registradas. Ve a ⚡ Venta Express para la primera venta.");
    }

    private void actualizarTotalizador() {
        double total = 0; int n = sorter.getViewRowCount();
        for (int i = 0; i < n; i++) {
            String s = String.valueOf(modeloVentas.getValueAt(sorter.convertRowIndexToModel(i), 5)).replace("S/.", "").trim();
            try { total += Double.parseDouble(s); } catch (Exception ignored) {}
        }
        lblTotalizador.setText(String.format("Mostrando %d ventas · Total: S/. %.2f", n, total));
    }

    private void eliminarVentaSeleccionada() {
        int vista = tablaVentas.getSelectedRow();
        if (vista == -1) { JOptionPane.showMessageDialog(this, "Selecciona una venta.", "Aviso", JOptionPane.WARNING_MESSAGE); return; }
        int idVenta = (int) modeloVentas.getValueAt(tablaVentas.convertRowIndexToModel(vista), 0);
        int c = JOptionPane.showConfirmDialog(this,
                "¿Eliminar venta #" + idVenta + "? Se devolverá el stock y se descontará del total/NRUS.",
                "Confirmar eliminación", JOptionPane.YES_NO_OPTION, JOptionPane.WARNING_MESSAGE);
        if (c != JOptionPane.YES_OPTION) return;
        try {
            if (ventaController.eliminarVenta(idVenta)) {
                JOptionPane.showMessageDialog(this, "✓ Venta eliminada y stock restaurado.");
                cargarVentas();
            } else JOptionPane.showMessageDialog(this, "No se pudo eliminar.", "Error", JOptionPane.ERROR_MESSAGE);
        } catch (SQLException ex) {
            JOptionPane.showMessageDialog(this, "Error: " + ex.getMessage(), "Error de base de datos", JOptionPane.ERROR_MESSAGE);
        }
    }
}
