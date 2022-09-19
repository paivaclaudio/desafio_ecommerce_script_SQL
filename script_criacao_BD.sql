-- -----------------------------------------------------
-- Script para criar Banco de dados do exemplo para e-commerce
-- Padrão da linguagme SQL para SQL-Server
-- -----------------------------------------------------

CREATE DATABASE ecommerce
GO
USE ecommerce


-- -----------------------------------------------------
-- Table cliente
-- -----------------------------------------------------
CREATE TABLE cliente (
  idcliente INT CONSTRAINT pkCli PRIMARY KEY IDENTITY(1,1),
  identificacao VARCHAR(45) NOT NULL,
  rua VARCHAR(50),
  nroResidencia varchar(10),
  complementoEndereco varchar(50),
  bairro VARCHAR(45),
  cep VARCHAR(15),
  cidade VARCHAR(45),
  UF CHAR(2),
  email VARCHAR(45),
  fone VARCHAR(20)
);


-- -----------------------------------------------------
-- Table formas_pagto
-- -----------------------------------------------------
CREATE TABLE formas_pagto (
  idformas_pagto INT CONSTRAINT pkPgto PRIMARY KEY IDENTITY(1,1),
  bandeira VARCHAR(45) NOT NULL,
  numero_cartao VARCHAR(45) NOT NULL,
  data_cartao VARCHAR(20),
  idcliente INT CONSTRAINT fkPgtoCli FOREIGN KEY REFERENCES cliente (idcliente)
);


-- -----------------------------------------------------
-- Table pedido
-- -----------------------------------------------------
CREATE TABLE pedido (
  idpedido INT CONSTRAINT pkPed PRIMARY KEY IDENTITY(1,1),
  status_pedido VARCHAR(45),
  descricao VARCHAR(100),
  frete FLOAT,
  data_pedido DATE CONSTRAINT dfDataPed default(getdate()),
  idcliente INT CONSTRAINT fkPedCli FOREIGN KEY REFERENCES cliente (idcliente)
);


-- -----------------------------------------------------
-- Table categoria
-- -----------------------------------------------------
CREATE TABLE categoria (
  idcategoria INT CONSTRAINT pkCat PRIMARY KEY IDENTITY(1,1),
  descricao VARCHAR(45) NOT NULL
);


-- -----------------------------------------------------
-- Table produto
-- -----------------------------------------------------
CREATE TABLE produto (
  idproduto INT CONSTRAINT pkPro PRIMARY KEY IDENTITY(1,1),
  descricao VARCHAR(45) NOT NULL,
  valor FLOAT NOT NULL,
  idcategoria INT CONSTRAINT fkProCat FOREIGN KEY REFERENCES categoria (idcategoria)
);


-- -----------------------------------------------------
-- Table fornecedor
-- -----------------------------------------------------
CREATE TABLE fornecedor (
  idfornecedor INT CONSTRAINT pkFor PRIMARY KEY IDENTITY(1,1),
  razao_social VARCHAR(45) NOT NULL,
  CNPJ VARCHAR(45) CONSTRAINT UkCnpjFor UNIQUE NOT NULL
);

-- -----------------------------------------------------
-- Table disponibiliza_produto
-- -----------------------------------------------------
CREATE TABLE disponibiliza_produto (
  idDisponibiliza INT CONSTRAINT pkDis PRIMARY KEY IDENTITY(1,1),
  idproduto INT CONSTRAINT fkDispPro FOREIGN KEY REFERENCES produto (idproduto) NOT NULL,
  idfornecedor INT CONSTRAINT fkDispForn FOREIGN KEY REFERENCES fornecedor (idfornecedor) NOT NULL,
);


-- -----------------------------------------------------
-- Table estoque
-- -----------------------------------------------------
CREATE TABLE estoque (
  idestoque INT CONSTRAINT pkEst PRIMARY KEY IDENTITY(1,1),
  localEstoque VARCHAR(45) NOT NULL
);


-- -----------------------------------------------------
-- Table produto_estoque
-- -----------------------------------------------------
CREATE TABLE produto_estoque (
  idProduto_estoque INT CONSTRAINT pkProEst PRIMARY KEY IDENTITY(1,1),
  idproduto INT CONSTRAINT fkProEstPro FOREIGN KEY REFERENCES produto (idproduto) NOT NULL,
  idestoque INT CONSTRAINT fkProEstEst FOREIGN KEY REFERENCES estoque (idestoque) NOT NULL,
  quantidade INT NOT NULL
);


-- -----------------------------------------------------
-- Table itens_pedido
-- -----------------------------------------------------
CREATE TABLE itens_pedido (
  idItensPedido INT CONSTRAINT pkItens PRIMARY KEY IDENTITY(1,1),
  idproduto INT CONSTRAINT fkItensPro FOREIGN KEY REFERENCES produto (idproduto) NOT NULL,
  idpedido INT CONSTRAINT fkItensPed FOREIGN KEY REFERENCES pedido (idpedido) NOT NULL,
  quantidade INT NOT NULL
);


-- -----------------------------------------------------
-- Table rastreamento_entrega
-- -----------------------------------------------------
CREATE TABLE rastreamento_entrega (
  idrastreamento INT CONSTRAINT pkRast PRIMARY KEY IDENTITY(1,1),
  codigo_rastreamento VARCHAR(45) NOT NULL,
  status_entrega VARCHAR(45) NOT NULL,
  data_envio DATE,
  data_entrega DATE,
  idpedido INT CONSTRAINT fkRastPed FOREIGN KEY REFERENCES pedido (idpedido) NOT NULL,
  CONSTRAINT chkEntEnv check(data_envio <= data_entrega)
);


-- -----------------------------------------------------
-- Table terceiro_vendedor
-- -----------------------------------------------------
CREATE TABLE terceiro_vendedor (
  idterceiro_vendedor INT CONSTRAINT pkTer PRIMARY KEY IDENTITY(1,1),
  razao_social VARCHAR(45) NOT NULL,
  localTerceiro VARCHAR(45)
);


-- -----------------------------------------------------
-- Table produto_vendedor
-- -----------------------------------------------------
CREATE TABLE produto_vendedor (
  idProdutoVendedor INT CONSTRAINT pkProVEn PRIMARY KEY IDENTITY(1,1),
  idproduto INT CONSTRAINT fkProVendPro FOREIGN KEY REFERENCES produto (idproduto) NOT NULL,
  idterceiro_vendedor INT CONSTRAINT fkProVendTerc FOREIGN KEY REFERENCES terceiro_vendedor (idterceiro_vendedor) NOT NULL,
  quantidade INT NOT NULL
);


-- -----------------------------------------------------
-- Table pessoa_fisica
-- -----------------------------------------------------
CREATE TABLE pessoa_fisica (
  idCliPF INT CONSTRAINT pkPF PRIMARY KEY CONSTRAINT fkPfCli FOREIGN KEY REFERENCES cliente (idcliente) NOT NULL,
  nome VARCHAR(80) NOT NULL,
  data_nascimento DATE,
  CPF VARCHAR(11) CONSTRAINT UkCpfPf UNIQUE NOT NULL,
  RG VARCHAR(20),
  sexo CHAR(1)
);


-- -----------------------------------------------------
-- Table pessoa_juridica
-- -----------------------------------------------------
CREATE TABLE pessoa_juridica (
  idCliPJ INT CONSTRAINT pkPJ PRIMARY KEY CONSTRAINT fkPjCli FOREIGN KEY REFERENCES cliente (idcliente) NOT NULL,
  razao_social VARCHAR(80) NOT NULL,
  CNPJ VARCHAR(14) CONSTRAINT UkCpfPj UNIQUE NOT NULL,
  inscr_estadual VARCHAR(45)
);


-- -----------------------------------------------------
-- Inserção de dados para testes
-- -----------------------------------------------------
-- CLIENTES:
insert into cliente
values
  ('mercado.joao', 'Rua Bauru', '15A', 'Loja 02', 'Engenheiro Taveira', '16087-013', 'Araçatuba', 'SP', 'mercado.joao@hotmail.com', '8542562522'),
  ('ana.silva', 'Rua Voluntário Umburana', '1500', null, 'Pimenta', '14781-370', 'Barretos', 'SP', 'anasilva1507@gmail.com', '1422445226'),
  ('pedromalta', 'Rua Comandante Ferraz', '17', 'Fundos', 'Betânia', '69073-060', 'Manaus', 'AM', 'pedromalta@hotmail.com', '87562325412'),
  ('pecuaria_zona_sul', 'Rua Paulo Lasmar', '800', null, 'Da Paz', '69049-11 0', 'Manaus', 'AM', 'contato@pecuaria_zona_sul.com.br', '885652152355'),
  ('minimercadoAzul', 'Travessa Comandante Almeida', '205', 'Loja 01', 'Coité', '61765-320', 'Eusébio', 'CE', 'mercadinho.azul@gmail.com', '7452256325')

insert into cliente(identificacao, rua, nroResidencia, cidade, UF, email)
values
  ('marcojose', 'Praça das bandeiras', 's/n', 'Sobral', 'CE', 'marcomarco@gmail.com'),
  ('alamedamodajovem', 'Av. Comandante Aviador', '1200', 'Vitória', 'ES', 'modajovemalameda@hotmail.com'),
  ('seforasantos', 'Rua Francisco Caro Dias', '840', 'Caieiras', 'SP', 'seforasantos198@gmail.com'),
  ('gabriel.s.louveira', 'Rua Médio São Francisco', '1980', 'Guarulhos', 'SP', 'gabslouveira@gmail.com')


select * from cliente

-- FORMAS DE PAGAMENTO (CARTÃO):
insert into formas_pagto
values
  ('VISA', '548555625', '08/25', 3),
  ('VISA', '7854523652', '07/22', 2),
  ('MASTER', '52145236', '09/29', 5),
  ('CIELO', '52147856', '10/25', 8),
  ('ELO', '56320101', '10/22', 7),
  ('MASTER', '74523685', '02/26', 6),
  ('CIELO', '14528542', '07/24', 5),
  ('VISA', '54253152', '11/28', 3),
  ('MASTER', '57548561', '05/25', 2),
  ('MASTER', '58954267', '08/27', 2),
  ('VISA', '52540785', '10/23', 1),
  ('ELO', '14750248', '04/26', 7)

select * from formas_pagto

-- PEDIDOS:
-- não informar valor para data do pedido para testar constraint com valor default da data-hora do sistema:
insert into pedido(status_pedido, descricao, frete, idcliente)
values
  ('FATURADO', null, 28.50, 7),
  ('EM SEPARAÇÃO', 'Ligar antes da entrega', 87.90, 5),
  ('CANCELADO', 'Carrinho abandonado após 48h', 14.00, 8),
  ('FATURADO', 'Frete grátis promocional', 0, 4)

insert into pedido
values
  ('FATURADO', null, 29.50, '2022/05/20', 9),
  ('FATURADO', 'Retirada na loja', 15, '2022/10/19', 6),
  ('EM SEPARAÇÃO', 'Recuperação call-center', 28.90, '2022/07/23', 5),
  ('FATURADO', 'Cliente preferencial', 19.90, '2022/02/02', 4),
  ('EM SEPARAÇÃO', 'Entregar no período da manhã', 31, '2022/03/17', 8),
  ('CANCELADO', 'Abandono de carrinho', 44.70, '2022/04/21', 7),
  ('FATURADO', null, 19.85, '2022/08/20', 8),
  ('FATURADO', 'Separação adiada a pedido do cliente', 101.4, '2021/12/28', 9),
  ('EM SEPARAÇÃO', 'Retirada na loja', 28.17, '2021/10/18', 2),
  ('CANCELADO', 'Abandono de carrinho', 40.50, '2021/09/11', 3),
  ('FATURADO', 'Retirada na loja', 34.78, '2021/10/05', 1),
  ('FATURADO', 'Envio pelo correio', 29.18, '2021/09/22', 3),
  ('CANCELADO', 'Abandono de carrinho', 44.90, '2020/05/18', 4),
  ('CANCELADO', null, 88.40, '2020/04/10', 3),
  ('FATURADO', 'Cliente preferencial', 75, '2020/02/25', 7)

select * from pedido

-- CATEGORIAS:
insert into categoria
values
  ('Artesanato'),
  ('Automotivo'),
  ('Brinquedos'),
  ('Cama, mesa e banho'),
  ('Colchões'),
  ('Decoração'),
  ('Eletrodomésticos'),
  ('Informática'),
  ('Moda'),
  ('Utilidades domésticas')

select * from categoria

-- Produtos:
insert into produto
values
  ('Kit Tie Dye com Camiseta Infantil', 85, 4),
  ('Espelho Redondo Decorativo', 12.90, 3),
  ('Papel De Parede Ripas De Madeira', 43.45, 9),
  ('Tablet Multilaser Kid Pad Plus', 45.80, 5),
  ('Cabo Carregador Micro USB', 66, 6),
  ('Bolsa Feminina Kit 4 Peças Sacola', 78, 2),
  ('Tenis Caminhada Cano Baixo Masculino', 223.90, 4),
  ('Impressora Multifuncional', 53, 6),
  ('Jogo de Cama Casal Queen', 48.59, 8),
  ('Cortina Roma Para Sala', 99, 9),
  ('Pirografo Gravador E Soldador ', 79, 10),
  ('Kit Miçanga Infantil Para Pulseira', 80.50, 2),
  ('Cozinha Infantil', 86.10, 1),
  ('Potiche de Cristal com Tampa e com Pé', 120.90, 3),
  ('Cubo Mágico Quadrado', 249, 6),
  ('Tenis Shoes Feminino Slip-on Calce', 45.50, 7),
  ('Forno Elétrico de Bancada', 55.80, 3),
  ('Quadriciclo Infantil a Pedal', 167.45, 8),
  ('Lava e Seca 11kg', 19.90, 9),
  ('Geladeira/Refrigerador ', 34.50, 2)

select * from produto

-- Fornecedores:
insert into fornecedor
values
  ('Brastemp', '40528525'),
  ('Consul', '48522000'),
  ('Electrolux', '15856320'),
  ('HP', '25423655'),
  ('Multilaser', '20150254'),
  ('Western', '18254762'),
  ('Eurofios', '50452358')

select * from fornecedor

-- Disponibilidade de estoque:
insert into disponibiliza_produto
values
  (1, 2),
  (2, 3),
  (3, 4),
  (4, 1),
  (5, 2),
  (6, 3),
  (7, 5),
  (8, 6),
  (9, 3),
  (10, 6),
  (11, 7),
  (12, 4),
  (13, 2),
  (14, 1),
  (15, 2),
  (16, 5),
  (17, 7),
  (18, 5),
  (19, 3),
  (20, 5)

select * from disponibiliza_produto

-- Locais de estoque:
insert into estoque
values
  ('CD MATRIZ'),
  ('CD ZONA LESTE'),
  ('CD RP'),
  ('ARMAZEM CENTRAL'),
  ('CD LOJAS'),
  ('CD INTERIOR PAULISTA'),
  ('CD MATO GROSSO')

select * from estoque

-- Produtos por estoque:
insert into produto_estoque
values
  (1, 3, 20),
  (2, 4, 15),
  (3, 5, 25),
  (4, 3, 110),
  (5, 3, 158),
  (6, 4, 15),
  (7, 4, 20),
  (8, 1, 35),
  (9, 2, 37),
  (10, 6, 48),
  (11, 7, 15),
  (12, 6, 110),
  (13, 4, 90),
  (14, 3, 75),
  (15, 5, 119),
  (16, 6, 89),
  (17, 7, 14),
  (18, 4, 25),
  (19, 3, 113),
  (20, 2, 52),
  (1, 2, 63),
  (2, 3, 50),
  (3, 5, 80),
  (4, 6, 163),
  (5, 7, 18),
  (6, 4, 99),
  (7, 5, 105),
  (8, 3, 53),
  (9, 1, 44),
  (10, 4, 80),
  (11, 5, 187),
  (12, 3, 90),
  (13, 2, 74),
  (14, 4, 56),
  (15, 6, 85)

select * from produto_estoque

-- Itens de pedido:
insert into itens_pedido
values
  (4, 5, 2),
  (5, 5, 1),
  (7, 1, 2),
  (5, 3, 2),
  (11, 8, 1),
  (1, 4, 4),
  (20, 6, 5),
  (15, 4, 2),
  (7, 2, 2),
  (8, 6, 4),
  (2, 8, 2),
  (3, 9, 1),
  (12, 9, 1),
  (17, 1, 1),
  (8, 2, 3),
  (13, 5, 2),
  (8, 10, 1),
  (5, 11, 1),
  (3, 15, 1),
  (5, 14, 4),
  (8, 7, 2),
  (9, 4, 1),
  (10, 4, 2),
  (8, 4, 1),
  (7, 5, 4),
  (4, 8, 3),
  (3, 10, 2),
  (8, 12, 2),
  (11, 5, 1),
  (15, 13, 3),
  (10, 17, 1),
  (5, 6, 1),
  (6, 8, 1),
  (1, 3, 3),
  (9, 1, 4),
  (14, 4, 2),
  (1, 4, 4),
  (13, 7, 4),
  (7, 18, 1)

select * from itens_pedido

-- Rastreamentos de entrega
insert into rastreamento_entrega
values
  ('45151S5B', 'ENTREGUE', '2022/08/14', '2022/08/25', 6),
  ('4899784B', 'DEVOLVIDO', '2022/07/20', null, 4),
  ('320205VC', 'ENTREGUE', '2022/02/27', '2022/03/20', 3),
  ('499965DV', 'DEVOLVIDO', '2021/12/29', null, 2),
  ('2302001D', 'ENTREGUE', '2021/10/19', '2021/10/25', 2),
  ('55651C25', 'PENDENTE', '2022/07/11', null, 4),
  ('351651V6', 'PENDENTE', '2021/11/30', null, 5),
  ('8864321V', 'ENTREGUE', '2021/10/16', '2021/10/30', 7),
  ('516541AS', 'ENTREGUE', '2022/03/20', '2022/04/15', 15)

select * from rastreamento_entrega

-- Terceiro/Vendedor:
insert into terceiro_vendedor
values
  ('JOÃO ARANTES REPRESENTAÇÕES', 'JOÃO PESSOA'),
  ('PEDRO MAGALHÃES', 'CURITIBA'),
  ('LOJA MAIS EM DIA', 'INDIANÁPOLIS'),
  ('ROUPA NOVA PRONTA ENTREGA', 'SÃO PAULO'),
  ('RAFAEL SILVA', 'SÃO PAULO')

select * from terceiro_vendedor

-- Produtos por vendedor:
insert into produto_vendedor
values
  (11, 2, 23),
  (10, 2, 45),
  (8, 1, 20),
  (2, 3, 18),
  (2, 5, 8),
  (15, 3, 14),
  (4, 1, 10)

select * from produto_vendedor

-- Pessoa Física:
insert into pessoa_fisica
values
  (2 , 'Ana Beatriz Silva', '1998/12/19', '10102030', '563215', 'F'),
  (3 , 'Pedro Malta Lima', '1987/05/14', '22112222', '97489165', 'M'),
  (6 , 'Antonio Marcos José', '1975/10/18', '45203202', '32151', 'M'),
  (8 , 'Séfora Borges Santos', '2001/05/10', '52058502', '1164978', 'F'),
  (9 , 'Gabriel Souza Louveira', '2002/08/30', '12123545', '21216558', 'M')

select * from pessoa_fisica

-- Pessoa Jurídica:
insert into pessoa_juridica
values
  (1 , 'MERCADO JOÃO', '5654654165', '65615'),
  (4 , 'PECUÁRIA ZONA SUL', '8986561030', 'ISENTO'),
  (5 , 'MINI-MERCADO AZUL', '1021021560', '65416'),
  (7 , 'ALAMEDA MODA JOVEM', '3025216565', '48880')

select * from pessoa_juridica


-- -----------------------------------------------------
-- Script para testar recuperação de dados contendo, mas não se limitando a:
--   Recuperações simples com SELECT Statement
--   Filtros com WHERE Statement
--   Crie expressões para gerar atributos derivados
--   Defina ordenações dos dados com ORDER BY
--   Condições de filtros aos grupos – HAVING Statement
--   Crie junções entre tabelas para fornecer uma perspectiva mais complexa dos dados
-- -----------------------------------------------------

--1. Selecionar todos os produtos cadastrados:
select * from produto

--2. Selecionar produtos cujos preços são maiores que R$ 100,00
select * from produto
where valor > 100

--3. Calcular qual seria o valor se fosse dado desconto de 5% sobre o preço dos produtos
select descricao, valor as PrecoVenda, round(valor * 0.05, 2) as DescontoAVista, round(valor * 0.95, 2) as PrecoAVista
from produto

--4. Selecionar os produtos de preço maior que R$ 50,00 exibindo o resultado do mais caro para o mais barato
select * from produto
where valor > 50
order by valor desc

--5. Mostrar a quantidade de produtos que existe por categoria cuja média de preço da categoria seja maior que R$ 80,00
select idCategoria, count(*) as qtdePorCategoria, round(avg(valor), 2) as precoMedio
from produto
group by idcategoria
having round(avg(valor), 2) > 80

--6. Mostre os nomes das categorias e a quantidade de produtos que existe em cada uma delas:
select c.descricao as NomeCategoria, count(p.idProduto) as QtdePorCategoria
from produto as p inner join categoria as c ON p.idcategoria = c.idcategoria
group by c.descricao 

--7. Selecione as descricoes dos produtos e suas quantidades em cada estoque, 
--  organizando o resultado por nome do Centro de Armazenamento e nome do Produto:
select p.descricao as nomeProduto, e.localEstoque as CentroArmazenamento, pe.quantidade as qtdeEmEstoque
from produto as p inner join produto_estoque as pe ON p.idproduto = pe.idproduto
                  inner join estoque as e ON pe.idestoque = e.idestoque
order by CentroArmazenamento, nomeProduto


--8. Liste dados dos produtos comprados por clientes do tipo pessoa física
select pf.nome, p.descricao as NomeProduto,  i.quantidade as QtdeComprada, pe.status_pedido as SituacaoPedido, 
       pe.data_pedido 
from produto as p inner join itens_pedido as i ON p.idproduto = i.idproduto
                  inner join pedido as pe on i.idpedido = pe.idpedido
				  inner join cliente as c on c.idcliente = pe.idcliente
				  inner join pessoa_fisica as pf ON pf.idCliPF = c.idcliente

-- uso de sub-select para filtrar pessoa física
select p.descricao as NomeProduto,  i.quantidade as QtdeComprada, pe.status_pedido as SituacaoPedido, 
       pe.data_pedido 
from produto as p inner join itens_pedido as i ON p.idproduto = i.idproduto
                  inner join pedido as pe on i.idpedido = pe.idpedido
				  inner join cliente as c on c.idcliente = pe.idcliente
where c.idcliente in (select idCliPF from pessoa_fisica)


--9. Liste dados dos pedidos faturados, os dados dos clientes e seus códigos de rastreamento
select p.idpedido, p.status_pedido, p.frete as ValorFrete, c.identificacao as Usuario, 
       codigo_rastreamento, status_entrega, p.data_pedido, r.data_envio, r.data_entrega
from pedido as p inner join cliente as c ON p.idcliente = c.idcliente
                 inner join rastreamento_entrega r ON p.idcliente = r.idpedido
where status_pedido = 'FATURADO'

--10. Liste os pedidos faturados que ainda não foram entregues:
select p.idpedido, p.status_pedido, p.frete as ValorFrete, c.identificacao as Usuario, 
       codigo_rastreamento, status_entrega, p.data_pedido, r.data_envio, r.data_entrega
from pedido as p inner join cliente as c ON p.idcliente = c.idcliente
                 inner join rastreamento_entrega r ON p.idcliente = r.idpedido
where status_pedido = 'FATURADO' and r.data_entrega is null

--11. Liste os produtos que não foram vendidos nos últimos 120 dias
select *
from produto
where idproduto not in
      (select p.idproduto
       from produto as p inner join itens_pedido as i ON p.idproduto = i.idproduto
	                     inner join pedido as pe ON i.idpedido = pe.idpedido
	   where pe.data_pedido >= getdate()-120
	   )

--12. Quantos pedidos foram feitos por cada cliente?
select c.identificacao as Usuario, count(p.idCliente) as QtdePedidosDoCliente
from cliente as c inner join pedido as p ON c.idcliente = p.idcliente
group by c.identificacao

--13. Algum vendedor também é fornecedor?
select * 
from terceiro_vendedor
where razao_social in (select razao_social from fornecedor)

--14. Relação de produtos fornecedores e estoques;
select f.razao_social as nomeFornecedor, p.descricao as nomeProduto, pe.quantidade as QtdeEmEstoque
from produto as p inner join disponibiliza_produto as dp ON p.idproduto = dp.idproduto
                  inner join fornecedor as f on dp.idfornecedor = f.idfornecedor
				  inner join produto_estoque as pe ON p.idproduto = pe.idproduto
				  inner join estoque as e on pe.idestoque = e.idestoque
order by f.razao_social, p.descricao

--15. Relação de nomes dos fornecedores e nomes dos produtos;
select f.razao_social as nomeFornecedor, p.descricao as nomeProduto
from produto as p inner join disponibiliza_produto as dp ON p.idproduto = dp.idproduto
                  inner join fornecedor as f on dp.idfornecedor = f.idfornecedor
order by f.razao_social, p.descricao
