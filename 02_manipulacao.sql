-- =====================================================================
-- Projeto de Base de Dados: HOTEL
-- Ficheiro 2/2: manipulação dos dados (SELECT, JOIN, UPDATE, DELETE)
-- Pré-requisito: ter executado antes o ficheiro 01_criacao_e_insercao.sql
-- Execução: mysql -u root -p hotel_db < 02_manipulacao.sql
-- =====================================================================

USE hotel_db;

-- =====================================================================
-- A. SELECT SIMPLES (3)
-- =====================================================================

-- A1. Hóspedes moçambicanos, por ordem alfabética do apelido.
-- Esperado: 13 linhas, começando em "Bila" e terminando em "Tembe".
SELECT id_hospede, nome, apelido, telefone
FROM hospede
WHERE nacionalidade = 'Moçambicana'
ORDER BY apelido;

-- A2. Tipos de quarto com preço por noite igual ou superior a 6000 MZN,
--     do mais caro para o mais barato.
-- Esperado: 7 linhas (4 tipos Suite e 3 tipos Familiar), com o mais caro
-- (Suite Executivo, 12800.00) em primeiro lugar e Familiar Superior (6600.00) no fim.
SELECT nome, capacidade, preco_noite
FROM tipo_quarto
WHERE preco_noite >= 6000
ORDER BY preco_noite DESC;

-- A3. Reservas ainda por realizar (estado 'Confirmada'), da mais próxima
--     para a mais distante.
-- Esperado: 6 reservas (ids 17 a 22), a primeira com check-in a 2026-11-05.
SELECT id_reserva, id_hospede, id_quarto, data_check_in, data_check_out
FROM reserva
WHERE estado = 'Confirmada'
ORDER BY data_check_in;

-- =====================================================================
-- B. SELECT COM JOIN (2)
-- =====================================================================

-- B1. Reservas em curso, com o nome do hóspede, número e tipo do quarto
--     e número de noites (junta 4 tabelas).
-- Esperado: 3 linhas (reservas 14, 15 e 16), cada uma com o hóspede,
-- o quarto, o tipo, o preço e as noites calculadas.
SELECT r.id_reserva,
       CONCAT(h.nome, ' ', h.apelido)           AS hospede,
       q.numero                                 AS quarto,
       t.nome                                   AS tipo_quarto,
       DATEDIFF(r.data_check_out, r.data_check_in) AS noites,
       t.preco_noite
FROM reserva r
JOIN hospede     h ON h.id_hospede = r.id_hospede
JOIN quarto      q ON q.id_quarto  = r.id_quarto
JOIN tipo_quarto t ON t.id_tipo    = q.id_tipo
WHERE r.estado = 'Em curso';

-- B2. As 5 reservas com maior gasto em serviços extra
--     (junta reserva, hóspede e consumo_servico e agrega com SUM).
-- Esperado: 5 linhas por ordem decrescente de total_servicos; a primeira é
-- a reserva 12 (Maria Santos) com 20100.00 MZN.
SELECT r.id_reserva,
       CONCAT(h.nome, ' ', h.apelido)         AS hospede,
       SUM(c.quantidade * c.preco_unitario)   AS total_servicos
FROM reserva r
JOIN hospede         h ON h.id_hospede = r.id_hospede
JOIN consumo_servico c ON c.id_reserva = r.id_reserva
GROUP BY r.id_reserva, h.nome, h.apelido
ORDER BY total_servicos DESC
LIMIT 5;

-- =====================================================================
-- C. UPDATE (2)
-- =====================================================================

-- C1. Colocar o quarto 201 em manutenção.
-- Esperado: 1 linha alterada (estado passa de 'Disponível' a 'Manutenção').
UPDATE quarto
SET estado = 'Manutenção'
WHERE numero = '201';

-- Verificação de C1
SELECT numero, estado FROM quarto WHERE numero = '201';

-- C2. Aumentar em 5 % o preço por noite de todos os tipos "Suite".
-- Esperado: 4 linhas alteradas (Suite Standard 8000.00 -> 8400.00, etc.).
UPDATE tipo_quarto
SET preco_noite = ROUND(preco_noite * 1.05, 2)
WHERE nome LIKE 'Suite%';

-- Verificação de C2
SELECT nome, preco_noite FROM tipo_quarto WHERE nome LIKE 'Suite%';

-- =====================================================================
-- D. DELETE (1)
-- =====================================================================

-- D1. Eliminar a reserva 25 (cancelada pelo hóspede antes de pagar o sinal).
--     Respeita as chaves estrangeiras: a reserva 25 não tem registos
--     "filhos" em pagamento nem em consumo_servico, por isso pode ser apagada.
-- Antes: existe 1 linha. Depois do DELETE: 0 linhas.
SELECT COUNT(*) AS antes FROM reserva WHERE id_reserva = 25;

DELETE FROM reserva
WHERE id_reserva = 25;

SELECT COUNT(*) AS depois FROM reserva WHERE id_reserva = 25;

-- =====================================================================
-- E. TESTE DE INTEGRIDADE (1)  --  ESTE COMANDO DEVE FALHAR DE PROPÓSITO
-- =====================================================================

-- E1. Inserir uma reserva para um hóspede que não existe (id_hospede = 999).
-- Esperado: ERRO. No MySQL: "ERROR 1452 (23000): Cannot add or update a
-- child row: a foreign key constraint fails (... fk_reserva_hospede ...)".
-- Explicação: a chave estrangeira id_hospede obriga a que o valor exista
-- na tabela hospede; como 999 não existe, o SGBD recusa a inserção e
-- protege a integridade referencial.
INSERT INTO reserva
  (id_hospede, id_quarto, id_funcionario, data_reserva, data_check_in,
   data_check_out, n_hospedes, estado)
VALUES
  (999, 1, 2, '2026-10-22', '2026-12-28', '2026-12-30', 2, 'Confirmada');
