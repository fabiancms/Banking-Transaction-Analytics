# Análisis de Clientes y Transacciones Bancarias

Proyecto de portafolio de análisis de datos enfocado en el comportamiento de los clientes, la estructura de las cuentas y el rendimiento de las transacciones bancarias utilizando **SQL, Python, SQLite y Power BI**.

El proyecto utiliza un conjunto de datos bancarios sintéticos. Python se emplea para la generación y preparación de los datos, SQL es la herramienta principal de análisis y Power BI se utiliza para el diseño de tableros y la presentación de resultados.

## Descripción del proyecto

Este proyecto analiza información de clientes, cuentas, sucursales y transacciones para responder preguntas como:

- ¿Cuántos clientes, cuentas, transacciones y sucursales existen?
- ¿Cómo se distribuyen los clientes por ciudad y segmento?
- ¿Qué relación existe entre el número de cuentas y la actividad de los clientes?
- ¿Cuáles son los tipos de transacción y canales más utilizados?
- ¿Qué porcentaje de transacciones falla?
- ¿Cómo varían los saldos según el tipo de cuenta, estado, ciudad y año de apertura?
- ¿Qué clientes generan el mayor valor transaccional?
- ¿Cómo cambió la actividad entre 2024 y 2025?

## Objetivos de negocio

1. Analizar las características y la segmentación de los clientes.
2. Comprender la distribución de las cuentas y su estado.
3. Evaluar el volumen y el valor de las transacciones.
4. Comparar tipos de transacción, canales, categorías comerciales y estados.
5. Identificar patrones que puedan apoyar la toma de decisiones en el sector bancario.
6. Construir un proyecto reproducible de portafolio que demuestre el uso práctico de SQL.

## Dataset

El dataset es sintético y fue creado con fines educativos y de portafolio.

| Tabla | Descripción | Registros |
|---|---|---:|
| `customers` | Información de clientes, ciudad, género, ingresos y segmento | 10.549 |
| `accounts` | Tipo de cuenta, saldo, estado, cliente y sucursal | 15.824 |
| `transactions` | Tipo de transacción, valor, canal, categoría y estado | 306.872 |
| `branches` | Información de las sucursales | 15 |

**Periodo de las transacciones:** del 1 de enero de 2024 al 31 de diciembre de 2025.

Los datos no representan clientes reales, entidades financieras reales ni operaciones bancarias reales.

## Herramientas y tecnologías

- **Python:** generación de datos sintéticos y preparación de la información.
- **SQL:** consultas, cruces, agregaciones, segmentación y cálculo de indicadores.
- **SQLite:** base de datos relacional utilizada para el análisis.
- **DB Browser for SQLite:** ejecución y validación de consultas SQL.
- **Power BI:** diseño de tableros y presentación interactiva de resultados.
- **Jupyter Notebook:** documentación del proceso analítico.
- **Git y GitHub:** control de versiones y publicación del proyecto.

## Modelo de datos

```text
customers
    |
    └── accounts
            |
            ├── branches
            |
            └── transactions
```

Relaciones principales:

- Un cliente puede tener una o más cuentas.
- Cada cuenta pertenece a un cliente.
- Cada cuenta está asociada a una sucursal.
- Las transacciones están asociadas a las cuentas.

## Indicadores principales

| Indicador | Resultado |
|---|---:|
| Clientes con cuentas | 10.549 |
| Total de cuentas | 15.824 |
| Total de transacciones | 306.872 |
| Valor total de las transacciones | 82.640.720,36 |
| Valor promedio por transacción | 269,30 |
| Transacciones completadas | 297.644 |
| Transacciones fallidas | 9.228 |
| Porcentaje de transacciones completadas | 96,99 % |
| Porcentaje de transacciones fallidas | 3,01 % |

Los valores monetarios están expresados en unidades monetarias sintéticas del dataset.

## Principales hallazgos

### Comportamiento de clientes y cuentas

- La base de clientes contiene 10.549 clientes con cuentas.
- Aproximadamente la mitad de los clientes tiene una cuenta y la otra mitad tiene dos.
- Los clientes con dos cuentas presentan un mayor promedio de transacciones y un mayor valor transaccional.
- Las cuentas de ahorro representan la mayoría de las cuentas.
- Las cuentas activas representan más del 90 % del total.

### Comportamiento de las transacciones

- Los pagos son el tipo de transacción más frecuente.
- El canal móvil es el canal con mayor volumen de transacciones.
- Aproximadamente el 97 % de las transacciones se completan.
- Cerca del 3 % de las transacciones presentan un estado fallido.
- El volumen y el valor total de las transacciones fueron similares en 2024 y 2025.

### Saldos de las cuentas

- La mayoría de los saldos se encuentra entre 1.000 y 9.999 unidades monetarias sintéticas.
- Existe un grupo menor de cuentas con saldos superiores a 25.000.
- Las cuentas de ahorro presentan un saldo total superior al de las cuentas corrientes en el dataset generado.

## Ejemplos de consultas SQL

### Indicadores generales de transacciones

```sql
SELECT
    COUNT(*) AS total_transacciones,
    ROUND(SUM(amount), 2) AS valor_total_transacciones,
    ROUND(AVG(amount), 2) AS valor_promedio_transaccion
FROM transactions;
```

### Transacciones por canal

```sql
SELECT
    channel,
    COUNT(*) AS cantidad_transacciones,
    ROUND(SUM(amount), 2) AS valor_total,
    ROUND(AVG(amount), 2) AS valor_promedio
FROM transactions
GROUP BY channel
ORDER BY cantidad_transacciones DESC;
```

### Tasa de transacciones exitosas y fallidas

```sql
SELECT
    status,
    COUNT(*) AS cantidad_transacciones,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM transactions),
        2
    ) AS porcentaje
FROM transactions
GROUP BY status
ORDER BY cantidad_transacciones DESC;
```

### Actividad de los clientes según el número de cuentas

```sql
SELECT
    cantidad_cuentas,
    COUNT(*) AS cantidad_clientes,
    ROUND(AVG(cantidad_transacciones), 2)
        AS promedio_transacciones_por_cliente,
    ROUND(AVG(valor_total_transacciones), 2)
        AS promedio_valor_por_cliente
FROM (
    SELECT
        c.customer_id,
        COUNT(DISTINCT a.account_id) AS cantidad_cuentas,
        COUNT(t.transaction_id) AS cantidad_transacciones,
        SUM(t.amount) AS valor_total_transacciones
    FROM customers c
    JOIN accounts a
        ON c.customer_id = a.customer_id
    LEFT JOIN transactions t
        ON a.account_id = t.account_id
    GROUP BY c.customer_id
) resumen_clientes
GROUP BY cantidad_cuentas
ORDER BY cantidad_cuentas;
```

## Concepto del tablero en Power BI

El tablero se organiza en cuatro páginas propuestas:

### 1. Resumen ejecutivo

Incluye:

- Total de clientes.
- Total de cuentas.
- Total de transacciones.
- Valor total transaccional.
- Porcentaje de transacciones completadas y fallidas.
- Evolución de las transacciones en el tiempo.
- Distribución por canal.

### 2. Análisis de clientes

Incluye:

- Distribución de clientes por segmento.
- Clientes por ciudad.
- Actividad según el número de cuentas.
- Clientes con mayor valor transaccional.
- Valor promedio por segmento.

### 3. Análisis de cuentas

Incluye:

- Tipo y estado de las cuentas.
- Saldos por ciudad.
- Año de apertura.
- Rangos de saldo.
- Comparación entre cuentas activas y cerradas.

### 4. Rendimiento de las transacciones

Incluye:

- Transacciones por tipo.
- Transacciones por canal.
- Transacciones fallidas por canal.
- Distribución por categoría comercial.
- Tendencias mensuales y anuales.

## Estructura recomendada del repositorio

```text
banking-customer-transaction-analytics/
│
├── data/
│   ├── raw/
│   └── processed/
├── database/
│   └── banking.db
├── notebooks/
│   └── banking_customer_transaction_analytics.ipynb
├── sql/
│   └── analysis_queries.sql
├── src/
│   └── generate_data.py
├── powerbi/
│   └── dashboard_mockups/
├── images/
├── README.md
└── requirements.txt
```

## Metodología

1. Generar los datos bancarios sintéticos con Python.
2. Validar identificadores, cantidad de registros y relaciones entre tablas.
3. Cargar los datos en SQLite.
4. Explorar la estructura de la base de datos.
5. Realizar análisis descriptivos mediante SQL.
6. Calcular indicadores de clientes, cuentas y transacciones.
7. Validar los resultados en DB Browser for SQLite.
8. Convertir los hallazgos en conceptos de tableros para Power BI.
9. Documentar los resultados en un notebook de storytelling.
10. Publicar el proyecto en GitHub.

## Limitaciones

- El dataset es sintético.
- Los resultados no representan indicadores reales del sector bancario.
- Los valores monetarios están expresados en unidades monetarias sintéticas.
- El proyecto se concentra en análisis descriptivo y diagnóstico.
- No incluye modelos predictivos ni información en tiempo real.

## Mejoras futuras

- Predicción de abandono de clientes.
- Detección de fraude y anomalías.
- Análisis del valor de vida del cliente.
- Segmentación de clientes mediante clustering.
- Pronóstico de transacciones.
- Actualización automática de datos.
- Creación de vistas SQL avanzadas.
- Actualización programada en Power BI.

## Autor

**Fabian Medina**

Analista de Datos | Gestión de Proyectos | Inteligencia de Negocios

Tecnologías principales:

`SQL` `Python` `Pandas` `SQLite` `Power BI` `Tableau` `Excel` `Git`

## Licencia

Este proyecto está destinado a fines educativos y de portafolio. El dataset es sintético y no debe utilizarse como fuente de información financiera real.
