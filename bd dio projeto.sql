-- criação do banco de dados para o cenário de e-commerce
-- drop database ecommerce;

create database ecommerce;

use ecommerce;

-- criar tabela cliente

create table cliente(
	idCliente int auto_increment primary key,
	Fnome varchar(10),
	Minit char(3),
	Lnome varchar(20),
	cpf char(11),
	endereco varchar(30),
	constraint unique_cpf_cliente unique (cpf)
); 

desc cliente;

-- criar tabela produto

create table produto(
	idProduto int auto_increment primary key,
	descricao varchar(10), 
	classificacao_infantil bool default false,
	categoria enum('Eletronicos', 'Vestuarios', 'Brinquedos', 'Alimentos', 'Moveis') not null,
	avaliacao float default 0,
	tamanho varchar(10)
);

desc produto;

-- criar tabela vendedor

create table vendedor(
	idVendedor int auto_increment primary key,
	nome varchar (150) not null,
	cpf char (15),
	regiao varchar (30),
	telefone char (11) not null,
	constraint unique_vendedor unique (cpf)
);

-- criar tabela pagamento

create table pagamento(
	idPagamento int,
	idCliente int,
	tipoPagamento enum('Boleto','Cartao'),
	limiteDisponivel float,
	primary key(idCliente,idPagamento)
	
); 

desc pagamento;

-- criar tabela pedido

create table pedido(
	idPedido int auto_increment primary key,
	idPedidoCliente int,
	idpagamento int,
	statusPedido enum('Cancelado', 'Confirmado', 'Em processamento') default 'Em processamento',
	descricao varchar (255),
	frete float default 10,
	pagamento boolean default false,
	constraint fk_pedido_cliente foreign key (idPedidoCliente) references cliente(idcliente)
		on update cascade
); 

desc pedido;

-- criar tabela estoque

create table estoque(
	idEstoque int auto_increment primary key,
	descricao varchar(45),
	quantidade int default 0
);

desc estoque;

-- criar tabela fornecedor

create table fornecedor(
	idFornecedor int auto_increment primary key,
	razao varchar (150) not null,
	cnpj char (15) ,
	telefone char (11) not null,
	constraint unique_fornecedor unique (cnpj)
);

desc fornecedor;

-- criar tabela armazem

create table armazem(
	idArmazem int auto_increment primary key,
	descricao varchar(45)
);

-- criar tabela produto vendedor

create table produto_vendedor(
	idVendedor int,
	idProduto int,
	quantidade int default 0,
	primary key (idVendedor, idProduto),
	constraint fk_produto_vendedor foreign key (idVendedor) references vendedor(idVendedor),
	constraint fk_vendedor_produto foreign key (idProduto) references produto(idProduto)
);

desc produto_vendedor;

-- criar tabela pedido produto

create table pedido_produto(
	idPedido int,
	idProduto int,
	quantidade int default 0,
	primary key (idPedido, idProduto),
	constraint fk_pedido_produto foreign key (idPedido) references pedido(idPedido),
	constraint fk_produto_pedido foreign key (idProduto) references produto(idProduto)
);

desc pedido_produto;

--- criar tabela armazem produto

create table armazem_produto(
	idArmazem int,
	idProduto int,
	primary key (idArmazem, idProduto),
	constraint fk_armazem_produto foreign key (idArmazem) references armazem(idArmazem),
	constraint fk_produto_armazem foreign key (idProduto) references produto(idProduto)
);

show tables;

show databases;

-- use information_schema;

-- desc referential_constraints;

-- select * from referential_constraints where constraint_schema = 'ecommerce';

-- insert into cliente (Fnome, Minit, Lnome, cpf, endereco) values
--		    ('Maria', 'M', 'Silva', '123456789', 'Rua Tal,1, Bairro - Cidade'),
--		    ('João', 'J', 'Souza', '987654321', 'Rua Outra,2, Bairro - Cidade');
            
-- insert into produto (descricao) values
--
--		    ('Sapato'),
--		    ('Camisa');
            
-- insert into vendedor (nome, cpf, regiao, telefone) values
--		    ('Jose', '12345678900', 'Sao Paulo', '123456789'),
--			('Januario', '32165498700', 'Rio de Janeiro', '987654321');

alter table cliente auto_increment = 1;

select count(*) from cliente;

select * from cliente c, pedido p where c.idCliente = idPedidoCliente;

select concat(Fnome,' ',Lnome) as Cliente, idPedido as Pedido, statusPedido as Status from cliente c, pedido p where c.idCliente = p.idPedidoCliente;

select * from cliente c, pedido p where c.idCliente = idPedidoCliente group by idPedido;

select * from cliente left outer join pedido on idCliente = idPedidoCliente group by idPedido;

select * from cliente c inner join pedido p on idCliente = idPedidoCliente inner join pedido_produto pp on p.idPedido = p.idPedido group by idCliente;
