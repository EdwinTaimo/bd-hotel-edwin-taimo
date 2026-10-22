-- ============================================================
-- TRABALHO DE TECNOLOGIAS DE BASE DE DADOS
-- Tema: Sistema de Gestão Hoteleira
-- Autor: Edwin Jerry Joaquim Taimo Gema
-- ============================================================

DROP DATABASE IF EXISTS bd_hotel;
CREATE DATABASE bd_hotel DEFAULT CHARACTER SET utf8mb4;
USE bd_hotel;

-- ------------------------------------------------------------
-- CRIAÇÃO DAS TABELAS
-- ------------------------------------------------------------

CREATE TABLE categoria_quarto (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nome_categoria VARCHAR(50) NOT NULL,
    descricao TEXT
);

CREATE TABLE quarto (
    id_quarto INT AUTO_INCREMENT PRIMARY KEY,
    numero_quarto VARCHAR(10) NOT NULL UNIQUE,
    andar INT NOT NULL,
    preco_diaria DECIMAL(10,2) NOT NULL,
    estado VARCHAR(20) DEFAULT 'Disponível',
    id_categoria INT NOT NULL,
    FOREIGN KEY (id_categoria) REFERENCES categoria_quarto(id_categoria)
);

CREATE TABLE hospede (
    id_hospede INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    telefone VARCHAR(20) NOT NULL,
    documento_id VARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE reserva (
    id_reserva INT AUTO_INCREMENT PRIMARY KEY,
    id_hospede INT NOT NULL,
    id_quarto INT NOT NULL,
    data_checkin DATE NOT NULL,
    data_checkout DATE NOT NULL,
    estado_reserva VARCHAR(20) DEFAULT 'Pendente',
    FOREIGN KEY (id_hospede) REFERENCES hospede(id_hospede),
    FOREIGN KEY (id_quarto) REFERENCES quarto(id_quarto)
);

CREATE TABLE servico (
    id_servico INT AUTO_INCREMENT PRIMARY KEY,
    nome_servico VARCHAR(50) NOT NULL,
    preco DECIMAL(10,2) NOT NULL
);

CREATE TABLE consumo_servico (
    id_consumo INT AUTO_INCREMENT PRIMARY KEY,
    id_reserva INT NOT NULL,
    id_servico INT NOT NULL,
    data_consumo DATETIME NOT NULL,
    quantidade INT DEFAULT 1,
    FOREIGN KEY (id_reserva) REFERENCES reserva(id_reserva),
    FOREIGN KEY (id_servico) REFERENCES servico(id_servico)
);

CREATE TABLE pagamento (
    id_pagamento INT AUTO_INCREMENT PRIMARY KEY,
    id_reserva INT UNIQUE NOT NULL,
    data_pagamento DATETIME NOT NULL,
    valor_pago DECIMAL(10,2) NOT NULL,
    metodo_pagamento VARCHAR(30) NOT NULL,
    FOREIGN KEY (id_reserva) REFERENCES reserva(id_reserva)
);

-- ------------------------------------------------------------
-- INSERÇÃO DE DADOS (Pelo menos 20 registos em tabelas base)
-- ------------------------------------------------------------

-- Categorias de Quartos
INSERT INTO categoria_quarto (nome_categoria, descricao) VALUES
('Standard Solteiro', 'Quarto individual com cama de solteiro e mesa de trabalho'),
('Standard Casal', 'Quarto com cama de casal e vista para a cidade'),
('Suíte Executiva', 'Quarto espaçoso com sala de estar e varanda'),
('Suíte Presidencial', 'Acomodação de luxo com jacuzzi e serviço privativo');

-- Quartos (20 Registos)
INSERT INTO quarto (numero_quarto, andar, preco_diaria, estado, id_categoria) VALUES
('101', 1, 2500.00, 'Ocupado', 1),
('102', 1, 2500.00, 'Disponível', 1),
('103', 1, 2500.00, 'Disponível', 1),
('104', 1, 2500.00, 'Manutenção', 1),
('105', 1, 2500.00, 'Disponível', 1),
('201', 2, 4000.00, 'Ocupado', 2),
('202', 2, 4000.00, 'Ocupado', 2),
('203', 2, 4000.00, 'Disponível', 2),
('204', 2, 4000.00, 'Disponível', 2),
('205', 2, 4000.00, 'Ocupado', 2),
('301', 3, 7500.00, 'Ocupado', 3),
('302', 3, 7500.00, 'Disponível', 3),
('303', 3, 7500.00, 'Disponível', 3),
('304', 3, 7500.00, 'Ocupado', 3),
('305', 3, 7500.00, 'Disponível', 3),
('401', 4, 15000.00, 'Ocupado', 4),
('402', 4, 15000.00, 'Disponível', 4),
('403', 4, 15000.00, 'Disponível', 4),
('404', 4, 15000.00, 'Disponível', 4),
('405', 4, 15000.00, 'Disponível', 4);

-- Hóspedes (20 Registos)
INSERT INTO hospede (nome, email, telefone, documento_id) VALUES
('Carlos Alberto Sitoe', 'carlos.sitoe@gmail.com', '841234567', '110100203A'),
('Ana Maria Mabunda', 'ana.mabunda@hotmail.com', '823456789', '110100203B'),
('Mateus José Tembe', 'mateus.tembe@sapo.mz', '865432109', '110100203C'),
('Sofia Bernardo Cossa', 'sofia.cossa@outlook.com', '849876543', '110100203D'),
('Lúcio Fernando Macuácua', 'lucio.macuacua@yahoo.com', '821122334', '110100203E'),
('Marta Beatriz Langa', 'marta.langa@gmail.com', '845566778', '110100203F'),
('Joana Pedro Mondlane', 'joana.mondlane@gmail.com', '878899001', '110100203G'),
('Tomas Eduardo Chissano', 'tomas.chissano@gmail.com', '843322110', '110100203H'),
('Isabel Helena Machel', 'isabel.machel@outlook.com', '826677889', '110100203I'),
('Paulo Victor Mutola', 'paulo.mutola@gmail.com', '861133557', '110100203J'),
('Ercília Samuel Nhantumbo', 'ercilia.nhantumbo@hotmail.com', '842244668', '110100203K'),
('David Francisco Mapusse', 'david.mapusse@gmail.com', '829988776', '110100203L'),
('Beatriz Jorge Vilanculos', 'beatriz.v@sapo.mz', '847755331', '110100203M'),
('Gabriel Antunes Machava', 'gabriel.machava@gmail.com', '864422009', '110100203N'),
('Vanessa Teresa Cau', 'vanessa.cau@outlook.com', '823311998', '110100203O'),
('Inácio Domingos Guambe', 'inacio.guambe@gmail.com', '848800224', '110100203P'),
('Clara Patricia Massingue', 'clara.m@hotmail.com', '871144770', '110100203Q'),
('Alexandre Lucas Tivane', 'alex.tivane@gmail.com', '846633992', '110100203R'),
('Filipa Rosario Nhanala', 'filipa.nhanala@yahoo.com', '825588113', '110100203S'),
('Nelson Amadeu Sumbana', 'nelson.sumbana@gmail.com', '863377221', '110100203T');

-- Serviços Disponíveis
INSERT INTO servico (nome_servico, preco) VALUES
('Pequeno Almoço Buffet', 800.00),
('Almoço Executivo', 1500.00),
('Jantar À La Carte', 2200.00),
('Serviço de Lavandaria', 500.00),
('Acesso ao Spa & Massagem', 3500.00),
('Transporte Aeroporto (Transfer)', 2000.00);

-- Reservas
INSERT INTO reserva (id_hospede, id_quarto, data_checkin, data_checkout, estado_reserva) VALUES
(1, 1, '2026-10-01', '2026-10-05', 'Concluída'),
(2, 6, '2026-10-02', '2026-10-06', 'Concluída'),
(3, 11, '2026-10-10', '2026-10-15', 'Concluída'),
(4, 16, '2026-10-12', '2026-10-14', 'Concluída'),
(5, 2, '2026-10-20', '2026-10-25', 'Confirmada'),
(6, 7, '2026-10-21', '2026-10-24', 'Confirmada'),
(7, 10, '2026-10-22', '2026-10-26', 'Confirmada'),
(8, 14, '2026-10-22', '2026-10-28', 'Confirmada');

-- Consumos dos Hóspedes
INSERT INTO consumo_servico (id_reserva, id_servico, data_consumo, quantidade) VALUES
(1, 1, '2026-10-02 08:30:00', 2),
(1, 4, '2026-10-03 14:00:00', 1),
(2, 2, '2026-10-03 13:00:00', 2),
(3, 5, '2026-10-11 16:00:00', 1),
(4, 6, '2026-10-12 10:00:00', 1);

-- Pagamentos
INSERT INTO pagamento (id_reserva, data_pagamento, valor_pago, metodo_pagamento) VALUES
(1, '2026-10-05 10:00:00', 12100.00, 'Cartão de Crédito'),
(2, '2026-10-06 11:30:00', 19000.00, 'M-Pesa'),
(3, '2026-10-15 09:00:00', 41000.00, 'Numerário'),
(4, '2026-10-14 12:00:00', 32000.00, 'Cartão de Crédito');
