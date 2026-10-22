# Sistema de Gestão Hoteleira - Base de Dados

**Estudante:** Edwin Jerry Joaquim Taimo Gema
**Curso:** Licenciatura em Informática (2º Ano)
**Disciplina:** Tecnologias de Base de Dados
**Instituição:** Universidade Licungo
**Tema:** Gestão Hoteleira (Hotel)
**Link do Vídeo:** [Link para o Vídeo no YouTube - Não Listado]

---

## 1. Descrição do Problema e Âmbito do Sistema Web

O setor de hotelaria enfrenta desafios na organização de quartos, gestão de reservas de hóspedes, alocação de serviços adicionais (como restauração e limpeza) e processamento de pagamentos.

Este projeto visa conceber a base de dados relacional para um **Sistema Web de Gestão Hoteleira**. O sistema permitirá aos utilizadores (hóspedes, rececionistas e administradores):

- Efetuar o registo de hóspedes e gestão de perfis;
- Consultar a disponibilidade de quartos por categoria (Solteiro, Casal, Suíte Presidencial);
- Realizar e gerir reservas em tempo real;
- Registar consumos de serviços adicionais associados à estadia;
- Processar pagamentos e emissão de faturas na caixa da receção.

---

## 2. Regras de Negócio

1. **Hóspedes:** Um hóspede deve ser identificado de forma única por um BI/Passaporte e ter dados de contacto válidos.
2. **Quartos:** Cada quarto possui um número único, um andar, um preço por noite e pertence obrigatoriamente a uma **Categoria**.
3. **Reservas:**
   - Um hóspede pode realizar várias reservas, mas cada reserva pertence a um único hóspede.
   - Uma reserva deve ter uma data de check-in e check-out bem definidas, onde `data_checkout > data_checkin`.
   - O estado da reserva pode variar entre: 'Pendente', 'Confirmada', 'Cancelada' ou 'Concluída'.
4. **Serviços Adicionais:**
   - Podem ser associados consumos extras (ex.: Restaurante, Lavandaria, Bar) a uma reserva ativa.
5. **Pagamentos:**
   - Cada reserva associada gera um registo de pagamento com o valor total calculado (dias de permanência × preço diário + consumos extra) e forma de pagamento ('Numerário', 'Cartão', 'M-Pesa').

---

## 3. Diagrama Entidade-Relacionamento (Conceito ER)

### Entidades e Atributos:

- **Hospede** (`id_hospede`, nome, email, telefone, documento_id)
- **CategoriaQuarto** (`id_categoria`, nome_categoria, descricao)
- **Quarto** (`id_quarto`, numero_quarto, andar, preco_diaria, estado, `id_categoria`)
- **Reserva** (`id_reserva`, `id_hospede`, `id_quarto`, data_checkin, data_checkout, valor_total, estado_reserva)
- **Servico** (`id_servico`, nome_servico, preco)
- **ConsumoServico** (`id_consumo`, `id_reserva`, `id_servico`, data_consumo, quantidade)
- **Pagamento** (`id_pagamento`, `id_reserva`, data_pagamento, valor_pago, metodo_pagamento)

---

## 4. Roteiro para Apresentação do Vídeo (8 a 12 Minutos)

Conforme os requisitos da avaliação, a demonstração em vídeo deve seguir os tópicos:

1. **Apresentação (1 min):** Introdução pessoal, apresentação do tema (Hotel) e do propósito do sistema web.
2. **Processo de Conceção (2-3 min):** Identificação de entidades, atributos, relacionamentos e regras de negócio.
3. **Diagramas (2 min):** Explicação das cardinalidades, chaves primárias e estrangeiras.
4. **Criação da Base de Dados (2 min):** Execução do script `01_criacao_e_insercao.sql` e visualização das tabelas preenchidas no SGBD.
5. **Execução dos Comandos (3-4 min):** Execução passo a passo dos comandos do ficheiro `02_manipulacao.sql`. *(Nota: Explicar o resultado esperado antes de cada execução)*.
6. **Conclusão (1 min):** Desafios enfrentados durante a modelação e aprendizagens obtidas.
