$ErrorActionPreference = "Stop"
Write-Host "STEP-0 inicio"
$outDir = "C:\Users\ROG ZEPHYRUS\Downloads\marketsoft_nrus\marketsoft_nrus\docs\apf2"
New-Item -ItemType Directory -Path $outDir -Force | Out-Null
$outFile = Join-Path $outDir "Informe-APF2-MarketSoft-NRUS.docx"
if (Test-Path $outFile) { Remove-Item $outFile -Force }

$word = New-Object -ComObject Word.Application
$word.Visible = $false
$word.DisplayAlerts = 0
Write-Host "STEP-1 word creado"
$doc = $word.Documents.Add()
Write-Host "STEP-2 doc creado"

function Add-Heading($text, $level) {
  $p = $doc.Content.Paragraphs.Add()
  $p.Range.Text = $text
  $wd = -2; if ($level -eq "Heading 2") { $wd = -3 }
  $p.Style = $doc.Styles.Item($wd)
  $p.Range.Font.Name = "Calibri"
  if ($level -eq "Heading 1") { $p.Range.Font.Size = 16; $p.Range.Font.Bold = $true; $p.Range.Font.Color = 0xC00000 }
  else { $p.Range.Font.Size = 13; $p.Range.Font.Bold = $true }
  $p.Range.InsertParagraphAfter() | Out-Null
}
function Add-Para($text, $bold=$false, $italic=$false, $size=11) {
  $p = $doc.Content.Paragraphs.Add()
  $p.Range.Text = $text
  $p.Range.Font.Name = "Calibri"; $p.Range.Font.Size = $size
  $p.Range.Font.Bold = $bold; $p.Range.Font.Italic = $italic
  $p.Range.InsertParagraphAfter() | Out-Null
}
function Add-Bullet($text) {
  $p = $doc.Content.Paragraphs.Add()
  $p.Range.Text = $text
  $p.Range.Font.Name = "Calibri"; $p.Range.Font.Size = 11
  $p.Format.LeftIndent = 36
  $p.Range.InsertParagraphAfter() | Out-Null
}
function Add-Table($headers, $rows) {
  $nR = $rows.Count + 1; $nC = $headers.Count
  $rng = $doc.Content
  $rng.Collapse(0)
  $tbl = $doc.Tables.Add($rng, $nR, $nC)
  for ($c=0; $c -lt $nC; $c++) { $tbl.Cell(1,$c+1).Range.Text = $headers[$c]; $tbl.Cell(1,$c+1).Range.Font.Bold = $true }
  for ($r=0; $r -lt $rows.Count; $r++) {
    for ($c=0; $c -lt $nC; $c++) { $tbl.Cell($r+2,$c+1).Range.Text = $rows[$r][$c] }
  }
  $p = $doc.Content.Paragraphs.Add(); $p.Range.InsertParagraphAfter() | Out-Null
}

# PORTADA
Add-Para "UNIVERSIDAD TECNOLÓGICA DEL PERÚ — UTP" $true $false 14
Add-Para "Curso Integrador I — Avance de Proyecto Final 2" $true $false 13
Add-Para "MarketSoft NRUS — Sistema de ventas e inventario para bodegas y minimarkets (Nuevo RUS, tope S/. 8,000/mes)" $true $false 13
Add-Para "Stack: Java 21 · Swing + FlatLaf · SQLite · Maven · MVC + DAO" $false $true 11
Add-Para "Informe en formato APA / IEEE — Diseño de la solución informática" $false $true 11
Add-Para "Fecha: septiembre 2026" $false $false 11

Add-Heading "Resumen ejecutivo" "Heading 1"
Add-Para "MarketSoft NRUS digitaliza la bodega de barrio: Venta Express en menos de 60 segundos, inventario por Unidad/Caja con costo automático, Dashboard Opción A (Ventas, Efectivo, Digital Yape/Plin, Ganancia del día), control tributario NRUS Categoría 1 (S/. 8,000) con semáforo, alertas de stock y vencimiento, historial con anulación, reportes de ganancia y pérdida por merma con CSV para Excel, y hora de Lima (UTC-5) en toda la app. Funciona sin internet en un solo PC."

Add-Heading "1. Análisis del contexto" "Heading 1"
Add-Para "1.1 Visión, misión, entorno, estrategias y planes" $true
Add-Bullet "Visión: ser la bodega de confianza del barrio, sin quiebres ni sobreprecios."
Add-Bullet "Misión: vender rápido, con stock disponible, precios justos y cuentas claras ante SUNAT."
Add-Bullet "Entorno: competencia (tambos/minimarkets), fiscalización Nuevo RUS, clientes que exigen Yape/Plin, compra a mayoristas por caja, espacio limitado."
Add-Bullet "Estrategias: (1) no quebrar top-100, (2) priorizar perecibles por vencer, (3) arqueo diario en 3 minutos, (4) no exceder S/. 8,000/mes."
Add-Bullet "Planes: digitalizar el cuaderno (POS + inventario + reportes); etapa 2: lector de barras y respaldo nube."
Add-Para "1.2 Business Model Canvas (resumen)" $true
Add-Table @("Bloque","Contenido") @(
  @("Socios","Mayoristas, Yape/Plin, contador"),
  @("Actividades","Vender, reponer por cajas, controlar vencimiento, arqueo, declarar NRUS"),
  @("Propuesta","Cobrar en menos de 1 min, no faltar top-vendidos, saber ganancia y tope S/. 8,000"),
  @("Clientes","Vecinos, escolares, trabajadores (pago mixto)"),
  @("Ingresos","Venta diaria Efectivo + Digital por margen unidad"),
  @("Costos","Mercadería por caja, merma, alquiler")
)
Add-Para "1.3 Problema y efecto en procesos" $true
Add-Para "Cuaderno manual: ventas no registradas (arqueo no cuadra), stock desactualizado (quiebres/sobrestock), costo caja→unidad calculado a mano (mal precio), merma sin registro (pérdida invisible), sin control NRUS (riesgo de exceder tope) y hora UTC mostrada como local (+5 h) con cierres de día errados."
Add-Para "1.4 Alcance (SÍ / NO)" $true
Add-Bullet "SÍ: Login por rol, Venta Express, Inventario Unidad/Caja, Dashboard A + NRUS, Historial, Reportes Ganancia/Merma + CSV, hora Lima."
Add-Bullet "NO: facturación electrónica SUNAT, multitienda, delivery, contabilidad completa."

Add-Heading "2. Planteamiento de 3 alternativas (≥50% Java, 5+ pantallas)" "Heading 1"
Add-Table @("Alternativa","Pantallas","Pro/Contra") @(
  @("A. Escritorio Java Swing + SQLite (ELEGIDA 100% Java)","Login, Venta 3 zonas, Inventario 3 secciones, Dashboard A, Historial, Reportes","Pro: sin internet, rápida, portable. Contra: un solo PC."),
  @("B. Web Java Spring + Thymeleaf (≥50% Java)","Mismas 5 + consulta móvil","Pro: multi-dispositivo. Contra: servidor/internet, más seguridad."),
  @("C. Móvil Android Java + backend (≥50% Java)","Cajero móvil, escáner cámara, sincronización","Pro: movilidad. Contra: hardware y sync offline.")
)

Add-Heading "3. Requerimientos SRS" "Heading 1"
Add-Para "Funcionales" $true
Add-Table @("ID","Requerimiento") @(
  @("RF1","Login Admin/Cajero por rol"),
  @("RF2","Venta: buscar nombre/código, validar stock, carrito"),
  @("RF3","Cobro Efectivo/Yape/Plin, vuelto en vivo, F2/Supr"),
  @("RF4","Inventario Unidad/Caja, costo auto y margen %"),
  @("RF5","Ingreso por CAJAS, retiro como merma con motivo"),
  @("RF6","12+ categorías gestionables"),
  @("RF7","Dashboard A: Ventas, Efectivo, Digital, Ganancia día"),
  @("RF8","NRUS S/. 8,000 con semáforo (hora Lima)"),
  @("RF9","Alertas stock/vencimiento con prioridad"),
  @("RF10","Historial filtrable + anulación con retorno stock"),
  @("RF11","Reportes Ganancia/Merma + CSV Excel es-PE"),
  @("RF12","Fechas UTC→Lima y filtros -5 hours")
)
Add-Para "No funcionales" $true
Add-Bullet "Java 21 + Maven shade; SQLite en %APPDATA%/MarketSoftNRUS; transacciones atómicas; validaciones; FlatLaf + atajos; arranque menor a 3 s."

Add-Heading "4. Diseño de la solución" "Heading 1"
Add-Para "4.1 Project Charter (resumen)" $true
Add-Table @("Campo","Valor") @(
  @("Objetivo","Arqueo en 3 min, 0 quiebres top-100, no exceder S/. 8,000"),
  @("Stack","Java 21, Swing+FlatLaf 3.4.1, SQLite 3.45, JCalendar 1.4, MVC+DAO"),
  @("Riesgos","Exceder NRUS, merma oculta, UTC vs Lima")
)
Add-Para "4.2 Gantt (resumen semanal)" $true
Add-Bullet "Sem 8 d1-3: BPM venta/inventario. d3-6: ER + clases + SRS. d6-10: Venta + Inventario. d10-13: Dashboard A + NRUS. d13-16: Mermas + hora Lima. d16-19: pruebas + informe + PPT 10 min."
Add-Para "4.3 BPM — notación y procesos TO-BE" $true
Add-Bullet "Notación: pool/carril (Cliente/Cajero/Sistema), tarea usuario/servicio, compuerta XOR (¿stock? ¿monto OK?), evento inicio/fin, temporizador vencimiento, objeto ticket/merma."
Add-Bullet "Venta: buscar → validar stock (XOR) → agregar → cobrar → validar monto (XOR) → transacción atómica + ticket + KPIs/NRUS Lima."
Add-Bullet "Inventario/merma: crear Unidad/Caja → ingresar por CAJAS (convierte) → vender descuenta → retirar como merma con motivo → reporte pérdida."
Add-Para "4.4 Base de datos (lógico/físico + seguridad)" $true
Add-Bullet "Tablas: categorias(UK nombre) 1—N productos; productos—N detalle_ventas; ventas 1—N detalle (CASCADE); productos 1—N mermas; usuarios(UK). CHECK metodo_pago/rol, FK con PRAGMA foreign_keys=ON."
Add-Bullet "Seguridad: PreparedStatement, transacciones venta/merma, validación DNI, roles, DB fuera del JAR. Hora: guarda UTC, lee/filtra Lima (FechaUtil, -5 hours)."
Add-Bullet "Físico: src/main/resources/schema.sql (ver anexo/proyecto)."
Add-Para "4.5 Clases UML MVC+DAO" $true
Add-Bullet "Modelo: Producto, Venta(+DetalleVenta), Merma, Categoria, Usuario. DAO: ProductoDAO, VentaDAO (totales por método, ganancia día), MermaDAO, ReporteDAO, CategoriaDAO. Controller valida/calcula. View solo UI (UiHelper). Main/MainView orquesta tabs con auto-refresh."

Add-Heading "5. Prototipo UX/UI y reportes" "Heading 1"
Add-Bullet "Prototipo = JAR funcional (100% alcance). Demo: Login → Venta F2 → Dashboard A (Efectivo+Digital=Ventas) → Inventario caja 12×84 → ingreso 5 cajas → merma → Reportes CSV Lima → Historial/anulación."
Add-Bullet "Venta: total 30pt, vuelto vivo, toggles pago, chips, JSpinner, Enter/F2/Supr. Inventario: 3 secciones, radio Caja bloquea campos, costo+margen vivo, JDateChooser, columna Código, filtro solo Nombre/Código. Dashboard A: 4 tarjetas caja + NRUS héroe + alertas con prioridad y sugerido pedir."
Add-Bullet "Reportes: ganancia=Σ(subtotal−cant×costo), pérdida=Σ(cant×costo); CSV con ; y BOM; filtros día/mes/rango con -5 hours."

Add-Heading "6. Documentación técnica (Markdown en docs/apf2/)" "Heading 1"
Add-Bullet "Instalar JDK 21 + NetBeans/Maven; mvn package (shade); dependencias sqlite-jdbc, flatlaf, jcalendar."
Add-Bullet "Ejecutar: java -jar target/*.jar; usuarios admin/admin y cajero/cajero; DB en %APPDATA%/MarketSoftNRUS/marketsoft.db; sin internet."

Add-Heading "7. Guía de sustentación 10 min (8 slides)" "Heading 1"
Add-Bullet "1 Portada · 2 Contexto/Canvas · 3 Alternativas · 4 SRS · 5 Charter/Gantt/BPM/ER/Clases · 6 Demo viva 4 min · 7 UX/Reportes Lima · 8 Cierre y futuro (barras, e-factura). Repartir tiempos y vincular conceptos."

Add-Heading "Referencias (APA 7 / IEEE)" "Heading 1"
Add-Bullet "Object Management Group. (2014). BPMN 2.0. / IEEE Std 830-1998 (SRS)."
Add-Bullet "Sommerville, I. (2011). Ingeniería de software (9.ª ed.). Pearson."
Add-Bullet "SUNAT. (2026). Nuevo RUS – Categoría 1 (tope S/. 8,000). https://www.sunat.gob.pe"
Add-Bullet "Oracle. (2024). Java 21 docs. / SQLite docs – Date & time functions. / FormDev FlatLaf."

Add-Heading "Anexos" "Heading 1"
Add-Bullet "A: modelos BPM. B: diseño BD (schema.sql + ER). C: diagrama de clases. D: prototipos + CSV ejemplo. E: código (VentaDAO totales/ganancia, FechaUtil, DashboardPanel Opción A)."

$doc.SaveAs2($outFile, 16)
Write-Host "STEP-3 guardado"
$doc.Saved = $true
$doc.Close()
Write-Host "STEP-4 cerrado"
$word.Quit()
Write-Host "STEP-5 fin"
[System.Runtime.InteropServices.Marshal]::ReleaseComObject($word) | Out-Null
Write-Host "DOCX-OK: $outFile"
