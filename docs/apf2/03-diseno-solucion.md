# APF2-03 — Diseño de la solución (charter, gantt, BPM, ER, clases)

## 1. Project Charter básico
| Campo | Contenido |
|---|---|
| Proyecto | MarketSoft NRUS — POS + inventario para bodegas (NRUS Cat.1) |
| Objetivo | Arqueo en 3 min, 0 quiebres top-100, margen visible, no exceder S/. 8,000 |
| Alcance | Login, Venta, Inventario, Dashboard A, Historial, Reportes, hora Lima |
| Fuera | Fact. electrónica, multitienda, delivery |
| Stack | Java 21, Swing + FlatLaf 3.4.1, SQLite 3.45.3, JCalendar 1.4, Maven shade, MVC+DAO |
| Riesgos | Exceder NRUS, merma oculta, UTC vs Lima, PC único |
| Éxito | Venta <60 s, arqueo cuadra, ganancia y NRUS correctos |

## 2. Gantt (Mermaid)
```mermaid
gantt
  title MarketSoft NRUS - Sem 8
  dateFormat  YYYY-MM-DD
  section Diseno
  BPM venta/inventario   :2026-09-01, 3d
  ER + clases + SRS      :2026-09-03, 3d
  section Build
  Venta + Inventario     :2026-09-06, 4d
  Dashboard A + NRUS     :2026-09-10, 3d
  Mermas + hora Lima     :2026-09-13, 3d
  section Cierre
  Pruebas + informe APA  :2026-09-16, 3d
  PPT + ensayo 10min     :2026-09-19, 2d
```

## 3. BPM (notación + procesos)
**Notación usada:** pool/carril (Cliente/Cajero/Sistema), tarea usuario/servicio,
compuerta exclusiva XOR (¿stock? ¿monto OK? ¿excede NRUS?), evento inicio/fin,
temporizador (revisar vencimiento), objeto de datos (ticket, merma).
**TO-BE Venta:** Cliente pide → Cajero busca (nombre/código) → Sistema valida stock
(XOR sin stock → sugiere sustituto) → agrega → cobra Efectivo/Yape/Plin →
Sistema valida monto (XOR insuficiente → pide faltante) → registra transacción
atómica + descuenta stock → ticket + actualiza KPIs/NRUS Lima.
**TO-BE Inventario/merma:** Admin crea (Unidad/Caja, costo auto) → ingresa por CAJAS
→ Sistema convierte a unidades → venta descuenta → si vence/rompe, retira como
merma con motivo → Sistema inserta merma + descuenta (atómico) → reporte pérdida.

## 4. Base de datos — lógico y físico (SQLite)
```mermaid
erDiagram
  CATEGORIAS ||--o{ PRODUCTOS : tiene
  PRODUCTOS ||--o{ DETALLE_VENTAS : vende
  VENTAS ||--o{ DETALLE_VENTAS : contiene
  PRODUCTOS ||--o{ MERMAS : pierde
  CATEGORIAS { int id_categoria PK string nombre UK }
  PRODUCTOS { int id_producto PK string codigo_barras_UK string nombre int id_categoria_FK real precio_compra_unitario real precio_venta_unitario int viene_en_caja int unidades_por_caja real precio_compra_caja int stock_unidades int stock_minimo date fecha_vencimiento }
  VENTAS { int id_venta PK datetime fecha_hora_UTC real total real monto_recibido real vuelto string metodo_pago string dni_cliente string nombre_cliente }
  DETALLE_VENTAS { int id_detalle PK int id_venta_FK int id_producto_FK int cantidad real precio_unitario real subtotal }
  USUARIOS { int id_usuario PK string usuario_UK string contrasena string rol }
  MERMAS { int id_merma PK int id_producto_FK int cantidad string motivo datetime fecha_UTC }
```
**Físico:** ver `src/main/resources/schema.sql`. Claves FK con `PRAGMA foreign_keys=ON`,
`ON DELETE CASCADE` en detalle, `UNIQUE` en código/usuario/categoría,
`CHECK(metodo_pago IN ...)`, `CHECK(rol IN ...)`. **Seguridad:** `PreparedStatement`
siempre, transacciones venta/merma, validación DNI/longitud, roles Admin/Cajero,
DB fuera del JAR en `%APPDATA%`. **Hora:** se guarda UTC (`CURRENT_TIMESTAMP`) y se
lee/filtra en Lima (`FechaUtil.utcALima`, `date(...,'-5 hours')`) — Perú sin DST.

## 5. Clases UML — MVC + DAO (Mermaid)
```mermaid
classDiagram
  class Main
  class AppConfig
  class ConexionSQLite
  class FechaUtil
  class Producto
  class Venta
  class DetalleVenta
  class Merma
  class Categoria
  class Usuario
  class ProductoDAO
  class VentaDAO
  class MermaDAO
  class ReporteDAO
  class CategoriaDAO
  class ProductoController
  class VentaController
  class MermaController
  class DashboardPanel
  class VentaExpressPanel
  class InventarioPanel
  class HistorialVentasPanel
  class ReportesPanel
  Venta *-- DetalleVenta
  VentaDAO --> ProductoDAO
  MermaDAO ..> ProductoDAO
  ProductoController --> ProductoDAO
  VentaController --> VentaDAO
  MermaController --> MermaDAO
  DashboardPanel --> VentaController
  DashboardPanel --> ProductoController
  VentaExpressPanel --> VentaController
  InventarioPanel --> MermaController
```
**Buenas prácticas:** DAO solo SQL, Controller valida/calcula (costo caja/unid,
vuelto, ganancia), View solo UI con `UiHelper`; sin SQL en vistas.
