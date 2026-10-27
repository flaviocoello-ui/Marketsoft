# APF2-02 — 3 alternativas de solución + SRS (MarketSoft NRUS)

## Alternativa 1 — Escritorio Java Swing + SQLite (ELEGIDA, 100% Java)
5+ pantallas: (1) Login roles, (2) Venta Express 3 zonas, (3) Inventario por secciones
Unidad/Caja, (4) Dashboard Caja + NRUS + alertas, (5) Historial, (6) Reportes Ganancia/Merma.
**Pros:** funciona sin internet, rápida con FlatLaf, SQLite portable, atajos F2/Supr, hora Lima.
**Contras:** un solo PC, sin acceso móvil.

## Alternativa 2 — Web Java (Spring Boot + Thymeleaf) + SQLite/Postgres (≥50% Java)
Mismas 5 pantallas en navegador + acceso desde celular para consultar stock.
**Pros:** multi-dispositivo, backup central. **Contras:** requiere servidor/internet,
más costo y seguridad web (sesiones, CSRF).

## Alternativa 3 — Móvil Android (Java) + backend local (≥50% Java)
App cajero con escáner de cámara + sincronización al PC.
**Pros:** movilidad en anaquel. **Contras:** hardware, sincronización offline compleja.

> Las 3 cubren el alcance (§01) y son ≥50% Java. Se sustenta la Alternativa 1 por costo,
> offline y velocidad de cola en bodega.

## SRS resumido
### Funcionales (RF)
| ID | Requerimiento | Pantalla |
|---|---|---|
| RF1 | Login Admin/Cajero con roles | Login |
| RF2 | Buscar por nombre/código, agregar con cantidad, validar stock | Venta |
| RF3 | Cobro Efectivo/Yape/Plin, vuelto en vivo, montos rápidos, F2 | Venta |
| RF4 | Registrar producto Unidad/Caja, costo unit. auto, margen % | Inventario |
| RF5 | Ingreso por CAJAS (convierte a unidades), retiro como merma con motivo | Inventario |
| RF6 | Gestionar 12+ categorías (agregar/eliminar) | Inventario |
| RF7 | KPIs día: Ventas, Efectivo, Digital (Yape/Plin), Ganancia estimada | Dashboard A |
| RF8 | NRUS mensual S/. 8,000 con semáforo y disponible (hora Lima) | Dashboard |
| RF9 | Alertas stock bajo / por vencer con prioridad y sugerido pedir | Dashboard |
| RF10 | Historial filtrable + anulación con retorno de stock | Historial |
| RF11 | Reportes Ganancia y Pérdida-merma + CSV `;` BOM para Excel es-PE | Reportes |
| RF12 | Fechas UTC→Lima en UI y filtros `-5 hours` en SQL | Transversal |

### No funcionales (RNF)
RNF1 Java 21 + Maven shade JAR; RNF2 SQLite en `%APPDATA%/MarketSoftNRUS`;
RNF3 transacciones atómicas venta/merma (commit/rollback); RNF4 validaciones
(DNI 8, decimales, no-negativos); RNF5 FlatLaf, tablas 24–26px, atajos teclado;
RNF6 arranque <3 s con 5,000 productos; RNF7 documentación Markdown + informe APA/IEEE.
