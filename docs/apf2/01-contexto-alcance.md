# APF2-01 — Análisis del contexto, problema y alcance (MarketSoft NRUS)

## 1. Empresa tipo (bodega/minimarket de barrio en Perú)
Negocio familiar, 1–3 trabajadores, atención 12–16 h/día, ticket S/. 5–30,
pago mixto Efectivo/Yape/Plin, compra a mayoristas por caja, merma por vencimiento/rotura.

**Visión:** ser la bodega de confianza del barrio, sin quiebres ni sobreprecios.
**Misión:** vender rápido, con stock disponible, precios justos y cuentas claras ante SUNAT.
**Entorno:** competencia (tambo, minimarkets), presión SUNAT Nuevo RUS, clientes que exigen
Yape/Plin, proveedores con entrega por caja, inseguridad y espacio limitado.
**Estrategia:** (1) no quebrar stock top-100, (2) priorizar perecibles próximos a vencer,
(3) arqueo diario en 3 minutos, (4) no exceder tope NRUS Cat.1 S/. 8,000/mes.
**Planes:** digitalizar cuaderno → POS + inventario + reportes; segunda etapa: lector de barras
y backup en la nube.

## 2. Problema y cómo afecta procesos
Cuaderno manual causa: (a) ventas no registradas → arqueo no cuadra; (b) stock desactualizado
→ quiebres y sobrestock; (c) sin costo unitario caja→unidad → mal precio/margen;
(d) merma no registrada → pérdida invisible; (e) sin control NRUS → riesgo de exceder
S/. 8,000; (f) hora UTC vs Lima → reportes con hora +5h y cierres de día errados.

## 3. Alcance de la solución informática (lo que SÍ / NO hace)
**Incluye:** Login por rol (Admin/Cajero); Venta Express (catálogo, carrito, vuelto en vivo,
Efectivo/Yape/Plin, DNI opcional, F2/Supr); Inventario (12 categorías + gestión, modo
Unidad/Caja con equivalencia, JDateChooser, semáforo, filtro Nombre/Código);
Dashboard Opción A (Ventas, Efectivo, Digital, Ganancia día + NRUS héroe + alertas con
prioridad); Historial con filtros y anulación con devolución de stock; Reportes
Ganancias + Pérdidas por merma + CSV Excel; hora Lima en BD/UI.
**Excluye:** facturación electrónica SUNAT, multitienda, delivery, contabilidad completa.

## 4. Business Model Canvas (para la rúbrica)
| Bloque | Contenido bodega |
|---|---|
| Socios | Mayoristas, distribuidores Yape/Plin, contador |
| Actividades | Vender, reponer por cajas, controlar vencimiento, arqueo, declarar NRUS |
| Recursos | POS Java Swing + SQLite, lector barras (futuro), exhibidoras |
| Propuesta | Cobrar en <1 min, nunca faltar top-vendidos, saber ganancia y no pasarse S/. 8,000 |
| Clientes | Vecinos, escolares, trabajadores (pago mixto) |
| Canales | Mostrador, WhatsApp pedidos |
| Costos | Mercadería por caja, merma, alquiler, comisión Yape/Plin |
| Ingresos | Venta diaria Efectivo + Digital, margen unidad |

> Este archivo cubre el criterio **Análisis del contexto** (visión, misión, entorno,
> estrategias, planes + canvas).
