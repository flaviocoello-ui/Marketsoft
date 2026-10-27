# APF2-04 — Prototipo UX/UI (Opción A), reportes y doc técnica

## 1. Prototipo funcional (vale como mockup 100% alcance + Balsamiq opcional)
El JAR en uso ES el prototipo. Flujo demo 5 min: Login cajero → Venta (buscar código,
doble-clic, +/-, Efectivo exacto, F2) → Dashboard A verifica
`Efectivo+Digital=Ventas` → Inventario crea producto Caja 12×S/.84 (costo S/.7 auto),
ingresa 5 cajas (=60 unid.) → retira 1 caja por Vencimiento → Reportes verifica
ganancia y pérdida → Historial filtra Yape y anula con retorno de stock.
Equivalencia Balsamiq: Login, Venta 3 zonas, Inventario 3 secciones, Dashboard 4 KPIs
+ NRUS héroe, Historial, Reportes 2 pestañas.

## 2. Pantallas y principios UX (Nielsen/FlatLaf)
**Venta:** total 30pt, vuelto vivo verde/rojo, toggles pago 1-clic, chips Exacto/10/20/50/100,
JSpinner, Enter/F2/Supr, stock con color. **Inventario:** 3 tarjetas, radio Unidad/Caja
que bloquea campos, costo+margen en vivo, JDateChooser, tabla con Código visible y
filtro solo Nombre/Código (stock NO filtra), semáforo. **Dashboard A:** 4 tarjetas caja,
NRUS con consumido/disponible y semáforo 70/90/100, alertas con prioridad
🔴HOY/🟡Pronto + sugerido pedir. **Historial/Reportes:** filtros, colores por método,
totalizadores, CSV `;` + BOM para Excel es-PE, fechas Lima.

## 3. Reportes clave
**Ganancias:** por producto (cant, costo, venta, ganancia) + resumen Venta/Costo/Ganancia/N°.
**Pérdidas-merma:** fecha Lima, producto, cant. unid., costo unit., pérdida, motivo +
total + CSV. **CSV ventas:** Fecha Lima, Cliente, DNI, Método, Venta, Costo, Ganancia.
Fórmulas: `ganancia=Σ(subtotal-cant×costo_unit)`, `pérdida=Σ(cant×costo_unit)`,
filtros día/mes/rango siempre con `'-5 hours'`.

## 4. Documentación técnica (Markdown para devs)
**Instalar:** JDK 21 + NetBeans/Maven; `mvn package` genera JAR gordo (shade).
Dependencias: `sqlite-jdbc 3.45.3.0`, `flatlaf 3.4.1`, `jcalendar 1.4`.
**Correr:** `java -jar target/marketsoft_nrus-1.0-SNAPSHOT.jar`; login `admin/admin`,
`cajero/cajero`; DB se crea en `%APPDATA%/MarketSoftNRUS/marketsoft.db`.
**Arquitectura:** `Main → MainView(tabs) → Paneles → Controller → DAO → SQLite`;
`UiHelper` estilos/filtros, `FechaUtil` UTC→Lima. **Despliegue:** copiar JAR + JDK 21,
sin internet. **Pruebas:** vender Efectivo/Yape, ingresar por cajas, mermar, anular,
exportar CSV y abrir en Excel.
