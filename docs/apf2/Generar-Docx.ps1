# Genera Informe-APF2 .docx via OpenXML (sin Word COM). Solo ASCII en el codigo.
$ErrorActionPreference = "Stop"
$proj = "C:\Users\ROG ZEPHYRUS\Downloads\marketsoft_nrus\marketsoft_nrus"
$stage = "C:\Users\ROGZEP~1\AppData\Local\Temp\opencode\docxstage"
$outFile = Join-Path $proj "docs\apf2\Informe-APF2-MarketSoft-NRUS.docx"
if (Test-Path $stage) { Remove-Item $stage -Recurse -Force }
New-Item -ItemType Directory -Path "$stage\_rels" -Force | Out-Null
New-Item -ItemType Directory -Path "$stage\word\_rels" -Force | Out-Null
if (Test-Path $outFile) { Remove-Item $outFile -Force }

function esc($s) {
  $s = $s -replace "&", "&amp;"
  $s = $s -replace "<", "&lt;"
  $s = $s -replace ">", "&gt;"
  return $s
}
$sb = New-Object System.Text.StringBuilder
function run($t, $b, $sz) {
  $rpr = '<w:rPr><w:rFonts w:ascii="Calibri" w:hAnsi="Calibri" w:cs="Calibri"/><w:sz w:val="' + $sz + '"/><w:szCs w:val="' + $sz + '"/>'
  if ($b) { $rpr += '<w:b/><w:bCs/>' }
  $rpr += '</w:rPr>'
  return '<w:r>' + $rpr + '<w:t xml:space="preserve">' + (esc $t) + '</w:t></w:r>'
}
function para($t, $sz) {
  if ($sz -eq $null) { $sz = "22" }
  [void]$sb.Append('<w:p><w:pPr><w:spacing w:after="120"/></w:pPr>' + (run $t $false $sz) + '</w:p>')
}
function head($t, $lvl) {
  $sz = "32"; if ($lvl -eq "2") { $sz = "26" }
  $col = ""; if ($lvl -eq "1") { $col = '<w:color w:val="C00000"/>' }
  [void]$sb.Append('<w:p><w:pPr><w:pStyle w:val="Heading' + $lvl + '"/><w:spacing w:before="240" w:after="120"/></w:pPr><w:r><w:rPr><w:rFonts w:ascii="Calibri" w:hAnsi="Calibri"/><w:b/><w:sz w:val="' + $sz + '"/>' + $col + '</w:rPr><w:t xml:space="preserve">' + (esc $t) + '</w:t></w:r></w:p>')
}
function bullet($t) {
  [void]$sb.Append('<w:p><w:pPr><w:ind w:left="720"/><w:spacing w:after="60"/></w:pPr>' + (run ("• " + $t) $false "22") + '</w:p>')
}
function cellp($t, $b) {
  $sh = ""
  return '<w:tc><w:tcPr><w:tcW w:w="0" w:type="auto"/>' + $sh + '</w:tcPr><w:p>' + (run $t $b "20") + '</w:p></w:tc>'
}
function table($headers, $rows) {
  [void]$sb.Append('<w:tbl><w:tblPr><w:tblW w:w="0" w:type="auto"/><w:tblBorders><w:top w:val="single" w:sz="4" w:color="999999"/><w:left w:val="single" w:sz="4" w:color="999999"/><w:bottom w:val="single" w:sz="4" w:color="999999"/><w:right w:val="single" w:sz="4" w:color="999999"/><w:insideH w:val="single" w:sz="4" w:color="999999"/><w:insideV w:val="single" w:sz="4" w:color="999999"/></w:tblBorders></w:tblPr><w:tblGrid>')
  for ($i = 0; $i -lt $headers.Count; $i++) { [void]$sb.Append('<w:gridCol/>') }
  [void]$sb.Append('</w:tblGrid><w:tr>')
  foreach ($h in $headers) { [void]$sb.Append((cellp $h $true)) }
  [void]$sb.Append('</w:tr>')
  foreach ($row in $rows) {
    [void]$sb.Append('<w:tr>')
    foreach ($c in $row) { [void]$sb.Append((cellp $c $false)) }
    [void]$sb.Append('</w:tr>')
  }
  [void]$sb.Append('</w:tbl><w:p><w:r><w:t></w:t></w:r></w:p>')
}

# ---- CONTENIDO ----
head "UNIVERSIDAD TECNOLOGICA DEL PERU - UTP" "1"
para "Curso Integrador I - Avance de Proyecto Final 2" "26"
para "MarketSoft NRUS - Sistema de ventas e inventario para bodegas y minimarkets (Nuevo RUS, tope S/. 8,000/mes)" "24"
para "Stack: Java 21, Swing + FlatLaf, SQLite, Maven, MVC + DAO" "22"
para "Informe en formato APA / IEEE - Diseno de la solucion informatica. Septiembre 2026." "22"

head "Resumen ejecutivo" "1"
para "MarketSoft NRUS digitaliza la bodega de barrio: Venta Express en menos de 60 segundos, inventario por Unidad/Caja con costo automatico, Dashboard Opcion A (Ventas, Efectivo, Digital Yape/Plin, Ganancia del dia), control tributario NRUS Categoria 1 (S/. 8,000) con semaforo, alertas de stock y vencimiento, historial con anulacion, reportes de ganancia y perdida por merma con CSV para Excel, y hora de Lima (UTC-5) en toda la app. Funciona sin internet en un solo PC."

head "1. Analisis del contexto" "1"
head "1.1 Vision, mision, entorno, estrategias y planes" "2"
bullet "Vision: ser la bodega de confianza del barrio, sin quiebres ni sobreprecios."
bullet "Mision: vender rapido, con stock disponible, precios justos y cuentas claras ante SUNAT."
bullet "Entorno: competencia (tambos/minimarkets), fiscalizacion Nuevo RUS, clientes que exigen Yape/Plin, compra a mayoristas por caja, espacio limitado."
bullet "Estrategias: (1) no quebrar top-100, (2) priorizar perecibles por vencer, (3) arqueo diario en 3 minutos, (4) no exceder S/. 8,000/mes."
bullet "Planes: digitalizar el cuaderno (POS + inventario + reportes); etapa 2: lector de barras y respaldo nube."
head "1.2 Business Model Canvas (resumen)" "2"
table @("Bloque","Contenido") @(
  @("Socios","Mayoristas, Yape/Plin, contador"),
  @("Actividades","Vender, reponer por cajas, controlar vencimiento, arqueo, declarar NRUS"),
  @("Propuesta","Cobrar en menos de 1 min, no faltar top-vendidos, saber ganancia y tope S/. 8,000"),
  @("Clientes","Vecinos, escolares, trabajadores (pago mixto)"),
  @("Ingresos","Venta diaria Efectivo + Digital por margen unidad"),
  @("Costos","Mercaderia por caja, merma, alquiler")
)
head "1.3 Problema y efecto en procesos" "2"
para "Cuaderno manual: ventas no registradas (arqueo no cuadra), stock desactualizado (quiebres/sobrestock), costo caja a unidad calculado a mano (mal precio), merma sin registro (perdida invisible), sin control NRUS (riesgo de exceder tope) y hora UTC mostrada como local (+5 h) con cierres de dia errados."
head "1.4 Alcance (SI / NO)" "2"
bullet "SI: Login por rol, Venta Express, Inventario Unidad/Caja, Dashboard A + NRUS, Historial, Reportes Ganancia/Merma + CSV, hora Lima."
bullet "NO: facturacion electronica SUNAT, multitienda, delivery, contabilidad completa."

head "2. Tres alternativas de solucion (50% Java o mas, 5+ pantallas)" "1"
table @("Alternativa","Pantallas","Pro / Contra") @(
  @("A. Escritorio Java Swing + SQLite (ELEGIDA, 100% Java)","Login, Venta 3 zonas, Inventario 3 secciones, Dashboard A, Historial, Reportes","Pro: sin internet, rapida, portable. Contra: un solo PC."),
  @("B. Web Java Spring + Thymeleaf","Mismas 5 + consulta movil","Pro: multi-dispositivo. Contra: servidor/internet, mas seguridad."),
  @("C. Movil Android Java + backend","Cajero movil, escaner camara, sincronizacion","Pro: movilidad. Contra: hardware y sync offline.")
)

head "3. Requerimientos SRS" "1"
para "Funcionales" "24"
table @("ID","Requerimiento") @(
  @("RF1","Login Admin/Cajero por rol"),
  @("RF2","Venta: buscar nombre/codigo, validar stock, carrito"),
  @("RF3","Cobro Efectivo/Yape/Plin, vuelto en vivo, F2/Supr"),
  @("RF4","Inventario Unidad/Caja, costo auto y margen %"),
  @("RF5","Ingreso por CAJAS, retiro como merma con motivo"),
  @("RF6","12+ categorias gestionables"),
  @("RF7","Dashboard A: Ventas, Efectivo, Digital, Ganancia dia"),
  @("RF8","NRUS S/. 8,000 con semaforo (hora Lima)"),
  @("RF9","Alertas stock/vencimiento con prioridad"),
  @("RF10","Historial filtrable + anulacion con retorno de stock"),
  @("RF11","Reportes Ganancia/Merma + CSV Excel es-PE"),
  @("RF12","Fechas UTC a Lima y filtros -5 hours")
)
para "No funcionales: Java 21 + Maven shade; SQLite en %APPDATA%/MarketSoftNRUS; transacciones atomicas; validaciones; FlatLaf + atajos; arranque menor a 3 s." "22"

head "4. Diseno de la solucion" "1"
head "4.1 Project Charter (resumen)" "2"
table @("Campo","Valor") @(
  @("Objetivo","Arqueo en 3 min, 0 quiebres top-100, no exceder S/. 8,000"),
  @("Stack","Java 21, Swing+FlatLaf 3.4.1, SQLite 3.45, JCalendar 1.4, MVC+DAO"),
  @("Riesgos","Exceder NRUS, merma oculta, UTC vs Lima")
)
head "4.2 Gantt (resumen semanal)" "2"
bullet "Sem 8 d1-3: BPM venta/inventario. d3-6: ER + clases + SRS. d6-10: Venta + Inventario. d10-13: Dashboard A + NRUS. d13-16: Mermas + hora Lima. d16-19: pruebas + informe + PPT 10 min."
head "4.3 BPM: notacion y procesos TO-BE" "2"
bullet "Notacion: pool/carril (Cliente/Cajero/Sistema), tarea usuario/servicio, compuerta XOR (stock? monto OK?), evento inicio/fin, temporizador vencimiento, objeto ticket/merma."
bullet "Venta: buscar, validar stock (XOR), agregar, cobrar, validar monto (XOR), transaccion atomica + ticket + KPIs/NRUS Lima."
bullet "Inventario/merma: crear Unidad/Caja, ingresar por CAJAS (convierte), vender descuenta, retirar como merma con motivo, reporte perdida."
head "4.4 Base de datos (logico/fisico + seguridad)" "2"
bullet "Tablas: categorias (UK nombre) 1-N productos; productos 1-N detalle_ventas; ventas 1-N detalle (CASCADE); productos 1-N mermas; usuarios (UK). CHECK metodo_pago/rol, FK con PRAGMA foreign_keys=ON."
bullet "Seguridad: PreparedStatement, transacciones venta/merma, validacion DNI, roles, DB fuera del JAR. Hora: guarda UTC, lee/filtra Lima (FechaUtil, -5 hours)."
bullet "Fisico: src/main/resources/schema.sql (ver proyecto)."
head "4.5 Clases UML MVC+DAO" "2"
bullet "Modelo: Producto, Venta (+DetalleVenta), Merma, Categoria, Usuario. DAO: ProductoDAO, VentaDAO (totales por metodo, ganancia dia), MermaDAO, ReporteDAO, CategoriaDAO. Controller valida/calcula. View solo UI (UiHelper). Main/MainView orquesta tabs con auto-refresh."

head "5. Prototipo UX/UI y reportes" "1"
bullet "Prototipo = JAR funcional (100% alcance). Demo: Login, Venta F2, Dashboard A (Efectivo+Digital=Ventas), Inventario caja 12x84, ingreso 5 cajas, merma, Reportes CSV Lima, Historial/anulacion."
bullet "Venta: total 30pt, vuelto vivo, toggles pago, chips, JSpinner, Enter/F2/Supr. Inventario: 3 secciones, radio Caja bloquea campos, costo+margen vivo, JDateChooser, columna Codigo, filtro solo Nombre/Codigo. Dashboard A: 4 tarjetas caja + NRUS heroe + alertas con prioridad y sugerido pedir."
bullet "Reportes: ganancia = suma(subtotal - cant x costo), perdida = suma(cant x costo); CSV con punto y coma y BOM; filtros dia/mes/rango con -5 hours."

head "6. Documentacion tecnica (para desarrolladores)" "1"
bullet "Instalar JDK 21 + NetBeans/Maven; mvn package (shade); dependencias sqlite-jdbc, flatlaf, jcalendar."
bullet "Ejecutar: java -jar target/*.jar; usuarios admin/admin y cajero/cajero; DB en %APPDATA%/MarketSoftNRUS/marketsoft.db; sin internet."

head "7. Guia de sustentacion 10 min (8 slides)" "1"
bullet "1 Portada. 2 Contexto/Canvas. 3 Alternativas. 4 SRS. 5 Charter/Gantt/BPM/ER/Clases. 6 Demo viva 4 min. 7 UX/Reportes Lima. 8 Cierre y futuro (barras, e-factura). Repartir tiempos y vincular conceptos."

head "Referencias (APA 7 / IEEE)" "1"
bullet "Object Management Group. (2014). BPMN 2.0. / IEEE Std 830-1998 (SRS)."
bullet "Sommerville, I. (2011). Ingenieria de software (9.a ed.). Pearson."
bullet "SUNAT. (2026). Nuevo RUS - Categoria 1 (tope S/. 8,000). https://www.sunat.gob.pe"
bullet "Oracle. (2024). Java 21 docs. / SQLite docs - Date and time functions. / FormDev FlatLaf."

head "Anexos" "1"
bullet "A: modelos BPM. B: diseno BD (schema.sql + ER). C: diagrama de clases. D: prototipos + CSV ejemplo. E: codigo (VentaDAO totales/ganancia, FechaUtil, DashboardPanel Opcion A)."

# ---- ENSAMBLAR DOCX ----
$ct = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>' + "`n" + '<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types"><Default Extension="rels" ContentType="application/vnd.open-package.relationships+xml"/><Default Extension="xml" ContentType="application/xml"/><Override PartName="/word/document.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml"/><Override PartName="/word/styles.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.styles+xml"/></Types>'
$rels = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>' + "`n" + '<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"><Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="word/document.xml"/></Relationships>'
$drels = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>' + "`n" + '<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"><Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles" Target="styles.xml"/></Relationships>'
$styles = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>' + "`n" + '<w:styles xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"><w:style w:type="paragraph" w:default="1" w:styleId="Normal"><w:name w:val="Normal"/><w:rPr><w:rFonts w:ascii="Calibri" w:hAnsi="Calibri" w:cs="Calibri"/><w:sz w:val="22"/><w:szCs w:val="22"/></w:rPr></w:style><w:style w:type="paragraph" w:styleId="Heading1"><w:name w:val="heading 1"/><w:basedOn w:val="Normal"/><w:rPr><w:b/><w:color w:val="C00000"/><w:sz w:val="32"/></w:rPr></w:style><w:style w:type="paragraph" w:styleId="Heading2"><w:name w:val="heading 2"/><w:basedOn w:val="Normal"/><w:rPr><w:b/><w:sz w:val="26"/></w:rPr></w:style></w:styles>'
$docxml = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>' + "`n" + '<w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"><w:body>' + $sb.ToString() + '<w:sectPr><w:pgSz w:w="12240" w:h="15840"/><w:pgMar w:top="1440" w:right="1440" w:bottom="1440" w:left="1440"/></w:sectPr></w:body></w:document>'

[IO.File]::WriteAllText("$stage\[Content_Types].xml", $ct, [Text.Encoding]::UTF8)
[IO.File]::WriteAllText("$stage\_rels\.rels", $rels, [Text.Encoding]::UTF8)
[IO.File]::WriteAllText("$stage\word\_rels\document.xml.rels", $drels, [Text.Encoding]::UTF8)
[IO.File]::WriteAllText("$stage\word\styles.xml", $styles, [Text.Encoding]::UTF8)
[IO.File]::WriteAllText("$stage\word\document.xml", $docxml, [Text.Encoding]::UTF8)
$zipTmp = "$stage.zip"
if (Test-Path $zipTmp) { Remove-Item $zipTmp -Force }
Add-Type -AssemblyName System.IO.Compression.FileSystem
[IO.Compression.ZipFile]::CreateFromDirectory($stage, $zipTmp)
Move-Item $zipTmp $outFile -Force
Write-Host ("DOCX-OK: " + $outFile)
