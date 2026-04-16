-- ============================================================
-- Projeto: Análise de Finanças Pessoais — SQL
-- Autor: Lucas
-- Data: 2025
-- Descrição: Consultas da Aula 2 — HAVING, JOIN e Subconsultas
--            Parte do portfólio de análise de dados (Excel > SQL > Power BI)
-- ============================================================


-- ------------------------------------------------------------
-- AULA 2 — HAVING
-- Diferença do WHERE: filtra grupos DEPOIS do GROUP BY
-- ------------------------------------------------------------

-- Meses em que o total gasto passou de R$ 2.500
SELECT mes, SUM(valor) AS total_gasto
FROM gastos
GROUP BY mes
HAVING total_gasto > 2500
ORDER BY total_gasto DESC;


-- ------------------------------------------------------------
-- AULA 2 — JOIN
-- Cruza as tabelas gastos e resumo pela coluna mes
-- Equivalente ao PROCV do Excel, mas para múltiplas linhas
-- ------------------------------------------------------------

-- Todos os gastos com a receita do mês correspondente
SELECT g.mes, g.categoria, g.valor, r.receita
FROM gastos g
JOIN resumo r ON g.mes = r.mes
ORDER BY g.mes, g.valor DESC;

-- Percentual de cada gasto sobre a receita mensal
SELECT g.mes, g.categoria, g.valor,
       ROUND((g.valor / r.receita) * 100, 2) AS pct_receita
FROM gastos g
JOIN resumo r ON g.mes = r.mes
ORDER BY g.mes, pct_receita DESC;


-- ------------------------------------------------------------
-- AULA 2 — SUBCONSULTA
-- O SELECT interno roda primeiro e vira o critério do WHERE externo
-- ------------------------------------------------------------

-- Gastos acima da média geral (média calculada dinamicamente)
SELECT mes, categoria, valor
FROM gastos
WHERE valor > (SELECT AVG(valor) FROM gastos)
ORDER BY valor DESC;


-- ------------------------------------------------------------
-- AULA 2 — QUERY ANALÍTICA COMPLETA
-- Combina JOIN + GROUP BY duplo + SUM + ROUND + HAVING + ORDER BY
-- Nível de análise esperado em relatórios financeiros profissionais
-- ------------------------------------------------------------

-- Total por tipo (Fixo/Variável) em cada mês, com % sobre a receita
-- Filtra apenas grupos com total acima de R$ 500
SELECT g.mes,
       g.tipo,
       SUM(g.valor)                               AS total_tipo,
       r.receita,
       ROUND((SUM(g.valor) / r.receita) * 100, 2) AS pct_receita
FROM gastos g
JOIN resumo r ON g.mes = r.mes
GROUP BY g.mes, g.tipo
HAVING total_tipo > 500
ORDER BY g.mes, total_tipo DESC;
