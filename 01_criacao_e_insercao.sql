-- =====================================================================
-- Projeto de Base de Dados: HOTEL
-- Disciplina: Tecnologias de Base de Dados (2.º ano, Licenciatura em Informática)
-- Universidade Licungo
-- Autor: Edwin [APELIDO]
-- SGBD: MySQL 8.0+ / MariaDB 10.5+
-- Ficheiro 1/2: criação da base de dados, tabelas e inserção dos registos
-- Execução: mysql -u root -p < 01_criacao_e_insercao.sql
-- =====================================================================

DROP DATABASE IF EXISTS hotel_db;
CREATE DATABASE hotel_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE hotel_db;

-- ---------------------------------------------------------------------
-- 1. CRIAÇÃO DAS TABELAS
--    (ordem: primeiro as tabelas "pai", depois as que têm chaves estrangeiras)
-- ---------------------------------------------------------------------

CREATE TABLE hospede (
  id_hospede      INT AUTO_INCREMENT PRIMARY KEY,
  nome            VARCHAR(50)  NOT NULL,
  apelido         VARCHAR(50)  NOT NULL,
  documento       VARCHAR(20)  NOT NULL UNIQUE,      -- BI ou passaporte
  telefone        VARCHAR(25)  NOT NULL,
  email           VARCHAR(80)  UNIQUE,
  nacionalidade   VARCHAR(30)  NOT NULL,
  data_nascimento DATE         NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE funcionario (
  id_funcionario INT AUTO_INCREMENT PRIMARY KEY,
  nome           VARCHAR(80)   NOT NULL,
  cargo          VARCHAR(30)   NOT NULL,
  telefone       VARCHAR(25)   NOT NULL,
  data_admissao  DATE          NOT NULL,
  salario        DECIMAL(10,2) NOT NULL CHECK (salario > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE tipo_quarto (
  id_tipo     INT AUTO_INCREMENT PRIMARY KEY,
  nome        VARCHAR(40)   NOT NULL UNIQUE,
  descricao   VARCHAR(150),
  capacidade  INT           NOT NULL CHECK (capacidade BETWEEN 1 AND 6),
  preco_noite DECIMAL(10,2) NOT NULL CHECK (preco_noite > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE servico (
  id_servico INT AUTO_INCREMENT PRIMARY KEY,
  nome       VARCHAR(50)   NOT NULL UNIQUE,
  preco      DECIMAL(10,2) NOT NULL CHECK (preco >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE quarto (
  id_quarto INT AUTO_INCREMENT PRIMARY KEY,
  numero    VARCHAR(5)  NOT NULL UNIQUE,
  andar     INT         NOT NULL CHECK (andar >= 0),
  id_tipo   INT         NOT NULL,
  estado    VARCHAR(15) NOT NULL DEFAULT 'Disponível'
            CHECK (estado IN ('Disponível','Ocupado','Manutenção')),
  CONSTRAINT fk_quarto_tipo FOREIGN KEY (id_tipo)
    REFERENCES tipo_quarto (id_tipo) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE reserva (
  id_reserva      INT AUTO_INCREMENT PRIMARY KEY,
  id_hospede      INT         NOT NULL,
  id_quarto       INT         NOT NULL,
  id_funcionario  INT         NOT NULL,           -- rececionista que registou
  data_reserva    DATE        NOT NULL,
  data_check_in   DATE        NOT NULL,
  data_check_out  DATE        NOT NULL,
  n_hospedes      INT         NOT NULL CHECK (n_hospedes >= 1),
  estado          VARCHAR(15) NOT NULL DEFAULT 'Confirmada'
                  CHECK (estado IN ('Confirmada','Em curso','Concluída','Cancelada')),
  observacoes     VARCHAR(150),
  CONSTRAINT ck_reserva_datas CHECK (data_check_out > data_check_in),
  CONSTRAINT fk_reserva_hospede FOREIGN KEY (id_hospede)
    REFERENCES hospede (id_hospede) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_reserva_quarto FOREIGN KEY (id_quarto)
    REFERENCES quarto (id_quarto) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_reserva_funcionario FOREIGN KEY (id_funcionario)
    REFERENCES funcionario (id_funcionario) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela associativa (relação N:M entre reserva e servico)
CREATE TABLE consumo_servico (
  id_reserva     INT           NOT NULL,
  id_servico     INT           NOT NULL,
  data_consumo   DATE          NOT NULL,
  quantidade     INT           NOT NULL CHECK (quantidade >= 1),
  preco_unitario DECIMAL(10,2) NOT NULL CHECK (preco_unitario >= 0),  -- preço cobrado na data
  PRIMARY KEY (id_reserva, id_servico, data_consumo),
  CONSTRAINT fk_consumo_reserva FOREIGN KEY (id_reserva)
    REFERENCES reserva (id_reserva) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_consumo_servico FOREIGN KEY (id_servico)
    REFERENCES servico (id_servico) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ENTIDADE FRACA: um pagamento só existe associado a uma reserva.
-- Chave primária composta = chave da entidade forte + número parcial (discriminador).
CREATE TABLE pagamento (
  id_reserva      INT           NOT NULL,
  num_pagamento   INT           NOT NULL,
  data_pagamento  DATE          NOT NULL,
  valor           DECIMAL(10,2) NOT NULL CHECK (valor > 0),
  metodo          VARCHAR(30)   NOT NULL,
  descricao       VARCHAR(40),
  PRIMARY KEY (id_reserva, num_pagamento),
  CONSTRAINT fk_pagamento_reserva FOREIGN KEY (id_reserva)
    REFERENCES reserva (id_reserva) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------
-- 2. INSERÇÃO DOS REGISTOS
--    (ordem imposta pelas chaves estrangeiras: pai -> filho)
-- ---------------------------------------------------------------------

-- 2.1 hospede (25 registos)
INSERT INTO hospede (id_hospede, nome, apelido, documento, telefone, email, nacionalidade, data_nascimento) VALUES
  (1, 'Amélia', 'Machava', '110100245871B', '+258 84 112 3401', 'amelia.machava@exemplo.com', 'Moçambicana', '1990-03-14'),
  (2, 'Carlos', 'Sitoe', '110200338912C', '+258 82 334 5502', 'carlos.sitoe@exemplo.com', 'Moçambicana', '1985-07-22'),
  (3, 'Helena', 'Mondlane', '110300412267A', '+258 86 445 6603', 'helena.mondlane@exemplo.com', 'Moçambicana', '1992-11-05'),
  (4, 'Joaquim', 'Cossa', '110400556734D', '+258 87 556 7704', 'joaquim.cossa@exemplo.com', 'Moçambicana', '1978-01-30'),
  (5, 'Fátima', 'Bila', '110500671098E', '+258 84 667 8805', 'fatima.bila@exemplo.com', 'Moçambicana', '1995-09-18'),
  (6, 'Nelson', 'Tembe', '110600789345F', '+258 85 778 9906', 'nelson.tembe@exemplo.com', 'Moçambicana', '1988-05-02'),
  (7, 'Graça', 'Nhaca', '110700823456G', '+258 82 889 0107', 'graca.nhaca@exemplo.com', 'Moçambicana', '1982-12-12'),
  (8, 'Abdul', 'Rassul', '110800934567H', '+258 86 990 1208', 'abdul.rassul@exemplo.com', 'Moçambicana', '1975-04-27'),
  (9, 'Isabel', 'Chissano', '110901045678J', '+258 84 101 2309', 'isabel.chissano@exemplo.com', 'Moçambicana', '1993-08-09'),
  (10, 'Tiago', 'Mabunda', '111001156789K', '+258 87 212 3410', 'tiago.mabunda@exemplo.com', 'Moçambicana', '1999-02-21'),
  (11, 'João', 'Ferreira', 'P1234567', '+351 912 345 678', 'joao.ferreira@exemplo.com', 'Portuguesa', '1980-06-15'),
  (12, 'Maria', 'Santos', 'P2345678', '+351 913 456 789', 'maria.santos@exemplo.com', 'Portuguesa', '1987-10-03'),
  (13, 'Pedro', 'Almeida', 'P3456789', '+351 914 567 890', 'pedro.almeida@exemplo.com', 'Portuguesa', '1972-03-29'),
  (14, 'Thabo', 'Nkosi', 'A4567890', '+27 82 345 6789', 'thabo.nkosi@exemplo.com', 'Sul-africana', '1984-09-11'),
  (15, 'Lerato', 'Dlamini', 'A5678901', '+27 83 456 7890', 'lerato.dlamini@exemplo.com', 'Sul-africana', '1991-01-25'),
  (16, 'Peter', 'Moyo', 'Z6789012', '+263 77 567 8901', 'peter.moyo@exemplo.com', 'Zimbabweana', '1979-07-07'),
  (17, 'Grace', 'Banda', 'M7890123', '+265 99 678 9012', 'grace.banda@exemplo.com', 'Malawiana', '1990-12-19'),
  (18, 'Lucas', 'Oliveira', 'B8901234', '+55 11 98765 4321', 'lucas.oliveira@exemplo.com', 'Brasileira', '1986-05-23'),
  (19, 'Ana', 'Costa', 'B9012345', '+55 21 97654 3210', 'ana.costa@exemplo.com', 'Brasileira', '1994-08-30'),
  (20, 'David', 'Smith', 'G0123456', '+44 7700 900123', 'david.smith@exemplo.com', 'Britânica', '1976-11-14'),
  (21, 'Emma', 'Johnson', 'G1234560', '+44 7700 900456', 'emma.johnson@exemplo.com', 'Britânica', '1989-04-04'),
  (22, 'Wang', 'Li', 'E2345601', '+86 138 0013 8000', 'wang.li@exemplo.com', 'Chinesa', '1983-02-17'),
  (23, 'Sofia', 'Langa', '111101267890L', '+258 82 323 4511', 'sofia.langa@exemplo.com', 'Moçambicana', '1997-06-28'),
  (24, 'Rui', 'Matsinhe', '111201378901M', '+258 84 434 5612', 'rui.matsinhe@exemplo.com', 'Moçambicana', '1981-10-10'),
  (25, 'Celina', 'Muianga', '111301489012N', '+258 86 545 6713', 'celina.muianga@exemplo.com', 'Moçambicana', '1991-03-03');

-- 2.2 funcionario (20 registos)
INSERT INTO funcionario (id_funcionario, nome, cargo, telefone, data_admissao, salario) VALUES
  (1, 'Armando Cumbe', 'Gerente', '+258 84 200 0001', '2018-02-01', 58000),
  (2, 'Berta Macuácua', 'Rececionista', '+258 84 200 0002', '2020-03-15', 18500),
  (3, 'Cláudio Nhantumbo', 'Rececionista', '+258 82 200 0003', '2021-06-01', 18500),
  (4, 'Dulce Zimba', 'Rececionista', '+258 86 200 0004', '2022-01-10', 17500),
  (5, 'Emílio Guambe', 'Rececionista', '+258 87 200 0005', '2023-04-03', 17000),
  (6, 'Filomena Uamusse', 'Camareira', '+258 84 200 0006', '2019-05-20', 12500),
  (7, 'Gina Mavie', 'Camareira', '+258 82 200 0007', '2019-09-02', 12500),
  (8, 'Hortência Sambo', 'Camareira', '+258 86 200 0008', '2021-02-15', 12000),
  (9, 'Inácio Fumo', 'Camareira', '+258 87 200 0009', '2022-07-11', 12000),
  (10, 'Joana Tivane', 'Camareira', '+258 84 200 0010', '2023-10-01', 12000),
  (11, 'Kátia Manjate', 'Cozinheiro', '+258 82 200 0011', '2018-08-13', 21000),
  (12, 'Leonel Chongo', 'Cozinheiro', '+258 86 200 0012', '2020-11-23', 19000),
  (13, 'Mário Bambo', 'Cozinheiro', '+258 87 200 0013', '2022-05-30', 18000),
  (14, 'Noémia Cuna', 'Empregado de Mesa', '+258 84 200 0014', '2021-09-06', 13500),
  (15, 'Orlando Vilanculos', 'Empregado de Mesa', '+258 82 200 0015', '2023-01-16', 13000),
  (16, 'Paulo Mucavele', 'Segurança', '+258 86 200 0016', '2019-03-04', 14000),
  (17, 'Quitéria Massinga', 'Segurança', '+258 87 200 0017', '2020-12-07', 14000),
  (18, 'Rafael Sigaúque', 'Técnico de Manutenção', '+258 84 200 0018', '2019-11-18', 20000),
  (19, 'Sérgio Mazive', 'Motorista', '+258 82 200 0019', '2021-04-12', 15000),
  (20, 'Teresa Cossa', 'Contabilista', '+258 86 200 0020', '2018-06-25', 34000);

-- 2.3 tipo_quarto (20 registos)
INSERT INTO tipo_quarto (id_tipo, nome, descricao, capacidade, preco_noite) VALUES
  (1, 'Individual Standard', '1 cama de solteiro; sem vista especial', 1, 2200),
  (2, 'Individual Superior', '1 cama de solteiro; mobiliário renovado e varanda', 1, 2640),
  (3, 'Individual Vista Mar', '1 cama de solteiro; varanda com vista para o mar', 1, 3080),
  (4, 'Individual Executivo', '1 cama de solteiro; zona de trabalho e acesso ao lounge', 1, 3520),
  (5, 'Duplo Standard', '1 cama de casal; sem vista especial', 2, 3500),
  (6, 'Duplo Superior', '1 cama de casal; mobiliário renovado e varanda', 2, 4200),
  (7, 'Duplo Vista Mar', '1 cama de casal; varanda com vista para o mar', 2, 4900),
  (8, 'Duplo Executivo', '1 cama de casal; zona de trabalho e acesso ao lounge', 2, 5600),
  (9, 'Twin Standard', '2 camas de solteiro; sem vista especial', 2, 3300),
  (10, 'Twin Superior', '2 camas de solteiro; mobiliário renovado e varanda', 2, 3960),
  (11, 'Twin Vista Mar', '2 camas de solteiro; varanda com vista para o mar', 2, 4620),
  (12, 'Twin Executivo', '2 camas de solteiro; zona de trabalho e acesso ao lounge', 2, 5280),
  (13, 'Familiar Standard', '1 cama de casal e 2 de solteiro; sem vista especial', 4, 5500),
  (14, 'Familiar Superior', '1 cama de casal e 2 de solteiro; mobiliário renovado e varanda', 4, 6600),
  (15, 'Familiar Vista Mar', '1 cama de casal e 2 de solteiro; varanda com vista para o mar', 4, 7700),
  (16, 'Familiar Executivo', '1 cama de casal e 2 de solteiro; zona de trabalho e acesso ao lounge', 4, 8800),
  (17, 'Suite Standard', '1 cama king-size e sala de estar; sem vista especial', 2, 8000),
  (18, 'Suite Superior', '1 cama king-size e sala de estar; mobiliário renovado e varanda', 2, 9600),
  (19, 'Suite Vista Mar', '1 cama king-size e sala de estar; varanda com vista para o mar', 2, 11200),
  (20, 'Suite Executivo', '1 cama king-size e sala de estar; zona de trabalho e acesso ao lounge', 2, 12800);

-- 2.4 servico (20 registos)
INSERT INTO servico (id_servico, nome, preco) VALUES
  (1, 'Pequeno-almoço', 450),
  (2, 'Almoço', 750),
  (3, 'Jantar', 900),
  (4, 'Lavandaria (por peça)', 120),
  (5, 'Transfer aeroporto', 1500),
  (6, 'Massagem (spa)', 2200),
  (7, 'Minibar', 600),
  (8, 'Aluguer de viatura (dia)', 4500),
  (9, 'Excursão de barco', 3500),
  (10, 'Sauna', 800),
  (11, 'Internet premium', 300),
  (12, 'Estacionamento (dia)', 250),
  (13, 'Serviço de quarto', 500),
  (14, 'Cesta de fruta', 650),
  (15, 'Bolo de aniversário', 1800),
  (16, 'Sala de reuniões (hora)', 1200),
  (17, 'Late check-out', 1500),
  (18, 'Cama extra', 1000),
  (19, 'Babysitting (hora)', 700),
  (20, 'Bar da piscina', 400);

-- 2.5 quarto (25 registos)
INSERT INTO quarto (id_quarto, numero, andar, id_tipo, estado) VALUES
  (1, '101', 1, 1, 'Disponível'),
  (2, '102', 1, 8, 'Disponível'),
  (3, '103', 1, 15, 'Disponível'),
  (4, '104', 1, 2, 'Disponível'),
  (5, '105', 1, 9, 'Disponível'),
  (6, '201', 2, 16, 'Disponível'),
  (7, '202', 2, 3, 'Disponível'),
  (8, '203', 2, 10, 'Manutenção'),
  (9, '204', 2, 17, 'Disponível'),
  (10, '205', 2, 4, 'Disponível'),
  (11, '301', 3, 11, 'Disponível'),
  (12, '302', 3, 18, 'Manutenção'),
  (13, '303', 3, 5, 'Disponível'),
  (14, '304', 3, 12, 'Ocupado'),
  (15, '305', 3, 19, 'Ocupado'),
  (16, '401', 4, 6, 'Ocupado'),
  (17, '402', 4, 13, 'Disponível'),
  (18, '403', 4, 20, 'Disponível'),
  (19, '404', 4, 7, 'Disponível'),
  (20, '405', 4, 14, 'Disponível'),
  (21, '501', 5, 1, 'Disponível'),
  (22, '502', 5, 8, 'Disponível'),
  (23, '503', 5, 15, 'Disponível'),
  (24, '504', 5, 2, 'Disponível'),
  (25, '505', 5, 9, 'Disponível');

-- 2.6 reserva (25 registos)
INSERT INTO reserva (id_reserva, id_hospede, id_quarto, id_funcionario, data_reserva, data_check_in, data_check_out, n_hospedes, estado, observacoes) VALUES
  (1, 1, 1, 2, '2026-07-24', '2026-08-03', '2026-08-05', 1, 'Concluída', NULL),
  (2, 2, 2, 3, '2026-07-26', '2026-08-08', '2026-08-11', 2, 'Concluída', NULL),
  (3, 3, 3, 4, '2026-07-28', '2026-08-13', '2026-08-17', 3, 'Concluída', NULL),
  (4, 4, 4, 5, '2026-07-30', '2026-08-18', '2026-08-23', 1, 'Concluída', 'Pediu quarto silencioso'),
  (5, 5, 5, 2, '2026-08-01', '2026-08-23', '2026-08-25', 2, 'Concluída', NULL),
  (6, 6, 6, 3, '2026-08-03', '2026-08-28', '2026-08-31', 3, 'Concluída', NULL),
  (7, 7, 7, 4, '2026-08-05', '2026-09-02', '2026-09-06', 1, 'Concluída', NULL),
  (8, 8, 8, 5, '2026-08-27', '2026-09-07', '2026-09-12', 2, 'Concluída', NULL),
  (9, 9, 9, 2, '2026-08-29', '2026-09-12', '2026-09-14', 2, 'Concluída', NULL),
  (10, 10, 10, 3, '2026-08-31', '2026-09-17', '2026-09-20', 1, 'Concluída', NULL),
  (11, 11, 11, 4, '2026-09-02', '2026-09-22', '2026-09-26', 2, 'Concluída', 'Aniversário de casamento'),
  (12, 12, 12, 5, '2026-09-04', '2026-09-27', '2026-10-02', 2, 'Concluída', NULL),
  (13, 13, 13, 2, '2026-09-06', '2026-10-02', '2026-10-04', 1, 'Concluída', NULL),
  (14, 14, 14, 3, '2026-09-20', '2026-10-19', '2026-10-23', 2, 'Em curso', NULL),
  (15, 2, 15, 4, '2026-10-08', '2026-10-20', '2026-10-25', 2, 'Em curso', NULL),
  (16, 16, 16, 5, '2026-10-06', '2026-10-21', '2026-10-27', 1, 'Em curso', NULL),
  (17, 17, 17, 2, '2026-10-18', '2026-11-05', '2026-11-08', 2, 'Confirmada', NULL),
  (18, 18, 18, 3, '2026-10-24', '2026-11-14', '2026-11-18', 2, 'Confirmada', NULL),
  (19, 11, 19, 4, '2026-10-30', '2026-11-23', '2026-11-28', 1, 'Confirmada', NULL),
  (20, 20, 20, 5, '2026-11-05', '2026-12-02', '2026-12-04', 2, 'Confirmada', NULL),
  (21, 21, 21, 2, '2026-12-01', '2026-12-11', '2026-12-14', 1, 'Confirmada', NULL),
  (22, 22, 22, 3, '2026-12-07', '2026-12-20', '2026-12-24', 1, 'Confirmada', NULL),
  (23, 23, 23, 4, '2026-11-24', '2026-12-10', '2026-12-13', 2, 'Cancelada', NULL),
  (24, 24, 24, 5, '2026-11-24', '2026-12-13', '2026-12-16', 1, 'Cancelada', NULL),
  (25, 25, 25, 2, '2026-11-24', '2026-12-16', '2026-12-19', 1, 'Cancelada', 'Cancelada pelo hóspede antes do pagamento do sinal');

-- 2.7 consumo_servico (32 registos)
INSERT INTO consumo_servico (id_reserva, id_servico, data_consumo, quantidade, preco_unitario) VALUES
  (1, 5, '2026-08-03', 1, 1500),
  (1, 11, '2026-08-04', 3, 300),
  (2, 4, '2026-08-08', 3, 120),
  (2, 18, '2026-08-09', 3, 1000),
  (3, 2, '2026-08-16', 1, 750),
  (3, 7, '2026-08-13', 2, 600),
  (4, 3, '2026-08-18', 3, 900),
  (4, 8, '2026-08-22', 2, 4500),
  (5, 4, '2026-08-23', 3, 120),
  (5, 8, '2026-08-24', 1, 4500),
  (6, 2, '2026-08-29', 2, 750),
  (6, 8, '2026-08-30', 1, 4500),
  (7, 5, '2026-09-02', 3, 1500),
  (7, 18, '2026-09-04', 3, 1000),
  (8, 4, '2026-09-08', 2, 120),
  (8, 6, '2026-09-11', 3, 2200),
  (9, 4, '2026-09-12', 3, 120),
  (9, 18, '2026-09-12', 3, 1000),
  (10, 7, '2026-09-19', 3, 600),
  (10, 16, '2026-09-18', 2, 1200),
  (11, 15, '2026-09-25', 2, 1800),
  (11, 19, '2026-09-24', 1, 700),
  (12, 6, '2026-09-27', 3, 2200),
  (12, 8, '2026-09-29', 3, 4500),
  (13, 11, '2026-10-02', 1, 300),
  (13, 16, '2026-10-03', 2, 1200),
  (14, 14, '2026-10-20', 2, 650),
  (14, 17, '2026-10-20', 2, 1500),
  (15, 2, '2026-10-24', 2, 750),
  (15, 14, '2026-10-20', 3, 650),
  (16, 11, '2026-10-25', 2, 300),
  (16, 12, '2026-10-25', 2, 250);

-- 2.8 pagamento - entidade fraca (33 registos)
INSERT INTO pagamento (id_reserva, num_pagamento, data_pagamento, valor, metodo, descricao) VALUES
  (1, 1, '2026-07-25', 2040.0, 'Cartão', 'Sinal'),
  (1, 2, '2026-08-05', 4760.0, 'Transferência bancária', 'Liquidação final'),
  (2, 1, '2026-07-27', 6048.0, 'M-Pesa', 'Sinal'),
  (2, 2, '2026-08-11', 14112.0, 'e-Mola', 'Liquidação final'),
  (3, 1, '2026-07-29', 9825.0, 'Transferência bancária', 'Sinal'),
  (3, 2, '2026-08-17', 22925.0, 'Numerário', 'Liquidação final'),
  (4, 1, '2026-07-31', 7470.0, 'e-Mola', 'Sinal'),
  (4, 2, '2026-08-23', 17430.0, 'Cartão', 'Liquidação final'),
  (5, 1, '2026-08-02', 3438.0, 'Numerário', 'Sinal'),
  (5, 2, '2026-08-25', 8022.0, 'M-Pesa', 'Liquidação final'),
  (6, 1, '2026-08-04', 9720.0, 'Cartão', 'Sinal'),
  (6, 2, '2026-08-31', 22680.0, 'Transferência bancária', 'Liquidação final'),
  (7, 1, '2026-08-06', 5946.0, 'M-Pesa', 'Sinal'),
  (7, 2, '2026-09-06', 13874.0, 'e-Mola', 'Liquidação final'),
  (8, 1, '2026-08-28', 7992.0, 'Transferência bancária', 'Sinal'),
  (8, 2, '2026-09-12', 18648.0, 'Numerário', 'Liquidação final'),
  (9, 1, '2026-08-30', 5808.0, 'e-Mola', 'Sinal'),
  (9, 2, '2026-09-14', 13552.0, 'Cartão', 'Liquidação final'),
  (10, 1, '2026-09-01', 4428.0, 'Numerário', 'Sinal'),
  (10, 2, '2026-09-20', 10332.0, 'M-Pesa', 'Liquidação final'),
  (11, 1, '2026-09-03', 6834.0, 'Cartão', 'Sinal'),
  (11, 2, '2026-09-26', 15946.0, 'Transferência bancária', 'Liquidação final'),
  (12, 1, '2026-09-05', 20430.0, 'M-Pesa', 'Sinal'),
  (12, 2, '2026-10-02', 47670.0, 'e-Mola', 'Liquidação final'),
  (13, 1, '2026-09-07', 2910.0, 'Transferência bancária', 'Sinal'),
  (13, 2, '2026-10-04', 6790.0, 'Numerário', 'Liquidação final'),
  (14, 1, '2026-09-21', 6336.0, 'e-Mola', 'Sinal'),
  (15, 1, '2026-10-09', 16800.0, 'Numerário', 'Sinal'),
  (16, 1, '2026-10-07', 7560.0, 'Cartão', 'Sinal'),
  (17, 1, '2026-10-19', 4950.0, 'M-Pesa', 'Sinal'),
  (18, 1, '2026-10-25', 15360.0, 'Transferência bancária', 'Sinal'),
  (19, 1, '2026-10-31', 7350.0, 'e-Mola', 'Sinal'),
  (23, 1, '2026-11-25', 6930.0, 'Transferência bancária', 'Sinal');

-- ---------------------------------------------------------------------
-- 3. VERIFICAÇÃO: número de registos em cada tabela
-- ---------------------------------------------------------------------
SELECT 'hospede' AS tabela, COUNT(*) AS registos FROM hospede
UNION ALL SELECT 'funcionario', COUNT(*) FROM funcionario
UNION ALL SELECT 'tipo_quarto', COUNT(*) FROM tipo_quarto
UNION ALL SELECT 'servico', COUNT(*) FROM servico
UNION ALL SELECT 'quarto', COUNT(*) FROM quarto
UNION ALL SELECT 'reserva', COUNT(*) FROM reserva
UNION ALL SELECT 'consumo_servico', COUNT(*) FROM consumo_servico
UNION ALL SELECT 'pagamento', COUNT(*) FROM pagamento;
