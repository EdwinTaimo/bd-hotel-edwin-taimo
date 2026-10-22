-- ============================================================
-- SCRIPT DE MANIPULAÇÃO DE DADOS (ETAPA 3 - EXIGÊNCIAS)
-- ============================================================
USE bd_hotel;

-- ------------------------------------------------------------
-- 1. CONSULTAS SELECT SIMPLES (Com filtro e ordenação)
-- ------------------------------------------------------------

-- Esperado: Listar todos os hóspedes com e-mail do domínio 'gmail.com', ordenados por nome.
SELECT id_hospede, nome, email, telefone 
FROM hospede 
WHERE email LIKE '%@gmail.com' 
ORDER BY nome ASC;

-- Esperado: Listar todos os quartos com diária superior a 5000 Meticais, ordenados do mais caro para o mais barato.
SELECT numero_quarto, andar, preco_diaria 
FROM quarto 
WHERE preco_diaria > 5000.00 
ORDER BY preco_diaria DESC;

-- Esperado: Listar reservas com estado 'Confirmada', ordenadas por data de check-in.
SELECT id_reserva, id_hospede, id_quarto, data_checkin, data_checkout 
FROM reserva 
WHERE estado_reserva = 'Confirmada' 
ORDER BY data_checkin ASC;


-- ------------------------------------------------------------
-- 2. CONSULTAS SELECT COM JOIN
-- ------------------------------------------------------------

-- Esperado: Exibir as reservas detalhadas com o nome do hóspede, número do quarto e categoria.
SELECT 
    r.id_reserva,
    h.nome AS hospede,
    q.numero_quarto,
    c.nome_categoria,
    r.data_checkin,
    r.data_checkout,
    r.estado_reserva
FROM reserva r
INNER JOIN hospede h ON r.id_hospede = h.id_hospede
INNER JOIN quarto q ON r.id_quarto = q.id_quarto
INNER JOIN categoria_quarto c ON q.id_categoria = c.id_categoria;

-- Esperado: Exibir o consumo de serviços extra por reserva com o nome do hóspede e total gasto no serviço.
SELECT 
    h.nome AS hospede,
    s.nome_servico,
    cs.quantidade,
    s.preco AS preco_unitario,
    (cs.quantidade * s.preco) AS subtotal,
    cs.data_consumo
FROM consumo_servico cs
INNER JOIN reserva r ON cs.id_reserva = r.id_reserva
INNER JOIN hospede h ON r.id_hospede = h.id_hospede
INNER JOIN servico s ON cs.id_servico = s.id_servico;


-- ------------------------------------------------------------
-- 3. COMANDOS UPDATE
-- ------------------------------------------------------------

-- Esperado: Atualizar o estado do quarto '104' de 'Manutenção' para 'Disponível'.
UPDATE quarto 
SET estado = 'Disponível' 
WHERE numero_quarto = '104';

-- Esperado: Reajustar em 10% o preço do preço diário das Suítes Presidenciais.
UPDATE quarto 
SET preco_diaria = preco_diaria * 1.10 
WHERE id_categoria = 4;


-- ------------------------------------------------------------
-- 4. COMANDO DELETE
-- ------------------------------------------------------------

-- Esperado: Remover um registo de consumo de serviço específico respeitando as chaves estrangeiras.
DELETE FROM consumo_servico 
WHERE id_consumo = 5;


-- ------------------------------------------------------------
-- 5. TESTE DE INTEGRIDADE REFERENCIAL (Geração Intencional de Erro)
-- ------------------------------------------------------------

-- Esperado: Falha na inserção ao tentar associar uma reserva a um hóspede com id inexistente (ex: id_hospede = 9999).
-- O SGBD deve barrar o comando retornando o erro de violação de Foreign Key.
INSERT INTO reserva (id_hospede, id_quarto, data_checkin, data_checkout, estado_reserva) 
VALUES (9999, 1, '2026-11-01', '2026-11-05', 'Pendente');
