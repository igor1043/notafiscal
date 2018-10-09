create Database notafiscal_db;
use notafiscal_db;

create table clientes (id int primary key auto_increment,cpf varchar(11) not null unique,nome varchar(255) )
engine = InnoDB default charset = utf8;

create table vendedores (id int primary key auto_increment, nome varchar (255), operador varchar(7))engine=InnoDB default charset=utf8;

 create table empresas (id int primary key auto_increment, nome varchar (255),cnpj varchar(14) not null unique,ie varchar(9),telefone varchar(12),estado varchar(255),cidade varchar(255))engine=InnoDB default charset=utf8;

create table produtos(id int primary key auto_increment,nome varchar(100),preco decimal(9,2))engine=InnoDB default charset=utf8;

create table notas_fiscais (id int primary key auto_increment,id_empresa int,id_cliente int references clientes(id),id_vendedor int references vendedor(id),data date,pagamento varchar(255),foreign key(id_empresa) references empresas(id))engine=InnoDB default charset=utf8;

create table itens_da_nota_fiscal (id int primary key auto_increment, id_produto int references produtos(id),id_notafiscal int,qtd int,valor decimal(9,2),foreign key (id_notafiscal) references notas_fiscais(id))engine=InnoDB default charset=utf8;




insert into clientes (cpf,nome) values ('13902029684','Igor'),('20369584235','Maria'),('20145689752','Jose');

insert into vendedores (nome,operador) values ('Lourdes','caixa 2');

insert into produtos (nome,preco) values('Resistor 1W 1K5',0.30),('Diodo 1N4148',0.30),('Regulador 5V',1.00),('USB-A macho',2.50),('Mouse',18.90),('Soquete 8 pinos', 0.50),('Capacitor eletrolítico 10x25v',0.25);

insert into empresas (nome,cnpj,ie,telefone,estado,cidade) values ('Ideal Eletronica','05645828000110','059620945','77-34215615','Bahia','Vitoria da conquista');

insert into notas_fiscais(id_cliente,id_empresa,id_vendedor,data,pagamento) values (1,1,1,'2018/09/10','a vista'),(2,1,1,'2018/09/11','cartao'),(1,1,1,'2018/09/12','a vista');

insert into itens_da_nota_fiscal (id_produto,qtd,id_notafiscal,valor)  values (1,2,1,(select p.preco from produtos p where id=1)*qtd),(2,1,1,(select p.preco from produtos p where id=2)*qtd),(6,1,2,(select p.preco from produtos p where id=6)*qtd),(5,1,3,(select p.preco from produtos p where id=5)*qtd);



igor comprou dois produtos,maria 1
igor comprou :Um resistor e um diodo,maria comprou:soquete 8 pinos
DQL

comandos//
/*Mostrar ID do cliente e o nome(Notas fiscais):*/
select a.id_cliente,b.nome from notas_fiscais a inner join clientes b on a.id_cliente=b.id;

/*Mostra os dados básicos da nota fiscal (Notas fiscais):*/
select clientes.nome as nome,notas_fiscais.data as data,notas_fiscais.pagamento as pagamento from clientes inner join notas_fiscais on clientes.id=notas_fiscais.id_cliente;

/*Mostra os dados da nota com o nome,data,pagamento e cod.vendedor:*/
select clientes.nome as nome,notas_fiscais.data as data,notas_fiscais.pagamento as pagamento, notas_fiscais.id_vendedor as vendedores from clientes inner join notas_fiscais on clientes.id=notas_fiscais.id_cliente;

/*Mostra os dados anteriores com o nome do vendedor:*/
select clientes.nome as nome,notas_fiscais.data as data,notas_fiscais.pagamento as pagamento, vendedores.nome as vendedores from 
(clientes inner join notas_fiscais on clientes.id=notas_fiscais.id_cliente)
inner join vendedores on vendedores.id=notas_fiscais.id_vendedor;

/*Mostra os dados básicos com empresa e CPF(Notas fiscais):*/
select empresas.nome as empresa, clientes.nome as nome,clientes.cpf as cpf,notas_fiscais.data as data,notas_fiscais.pagamento as pagamento, vendedores.nome as vendedores from 
((clientes inner join notas_fiscais on clientes.id=notas_fiscais.id_cliente)
inner join vendedores on vendedores.id=notas_fiscais.id_vendedor)
inner join empresas on empresas.id=notas_fiscais.id_empresa;

/*Mostra os dados completos sem os produtos(notas_fiscais):*/
select empresas.nome as empresa, clientes.nome as nome,notas_fiscais.data as data,notas_fiscais.pagamento as pagamento, vendedores.nome as vendedores from ((clientes inner join notas_fiscais on clientes.id=notas_fiscais.id_cliente)
inner join vendedores on vendedores.id=notas_fiscais.id_vendedor)
inner join empresas on empresas.id=notas_fiscais.id_empresa;

/*Mostro o nome do produto e preço vendidos na loja(itens_da_nota_fiscal):*/
select produtos.nome as nome_produto,produtos.preco as preco from itens_da_nota_fiscal inner join produtos on produtos.id=itens_da_nota_fiscal.id_produto;

/*Os dados basicos da nota */
select empresas.nome as empresa, clientes.nome as nome,notas_fiscais.data as data,notas_fiscais.pagamento as pagamento, vendedores.nome as vendedoresa from (((clientes inner join notas_fiscais on clientes.id=notas_fiscais.id_cliente)
inner join vendedores on vendedores.id=notas_fiscais.id_vendedor)
inner join empresas on empresas.id=notas_fiscais.id_empresa);

/*[Oficial] Itens da nota fiscal completa,sem soma e localização (itens_da_nota_fiscal)*/
select clientes.nome as cliente,notas_fiscais.data as data,notas_fiscais.pagamento as pagamento,notas_fiscais.id as id_da_nota,itens_da_nota_fiscal.qtd as qtd,produtos.nome as produtos,itens_da_nota_fiscal.valor,produtos.preco as preco_de_tabela from 
(((clientes inner join notas_fiscais on clientes.id=notas_fiscais.id_cliente)inner join empresas on empresas.id=notas_fiscais.id_empresa)inner join itens_da_nota_fiscal on itens_da_nota_fiscal.id_notafiscal=notas_fiscais.id) inner join produtos on produtos.id=itens_da_nota_fiscal.id_produto;

/*Soma os produtos comprados pelo cliente durante todo o periodo*/

select clientes.nome as cliente,notas_fiscais.data as data,SUM(itens_da_nota_fiscal.qtd) as qtd_produtos,SUM(itens_da_nota_fiscal.valor) as valortotal from 
((clientes inner join notas_fiscais on clientes.id=notas_fiscais.id_cliente)
inner join itens_da_nota_fiscal on itens_da_nota_fiscal.id_notafiscal=notas_fiscais.id) inner join produtos on produtos.id=itens_da_nota_fiscal.id_produto
where clientes.id=1 GROUP BY produtos.preco;


/*Soma os produtos comprados pelo cliente pelo nome*/

select clientes.nome as cliente,notas_fiscais.data as data,SUM(itens_da_nota_fiscal.qtd) as qtd_produtos,SUM(itens_da_nota_fiscal.valor) as valortotal from 
((clientes inner join notas_fiscais on clientes.id=notas_fiscais.id_cliente)
inner join itens_da_nota_fiscal on itens_da_nota_fiscal.id_notafiscal=notas_fiscais.id) inner join produtos on produtos.id=itens_da_nota_fiscal.id_produto
where clientes.nome='Igor' GROUP BY produtos.preco;


/*Soma os produtos comprados pelo cliente por periodo especifico*/

select clientes.nome as cliente,notas_fiscais.data as data,SUM(itens_da_nota_fiscal.qtd) as qtd_produtos,SUM(itens_da_nota_fiscal.valor) as valortotal from 
((clientes inner join notas_fiscais on clientes.id=notas_fiscais.id_cliente)
inner join itens_da_nota_fiscal on itens_da_nota_fiscal.id_notafiscal=notas_fiscais.id) inner join produtos on produtos.id=itens_da_nota_fiscal.id_produto
where notas_fiscais.data='2018-09-10' GROUP BY produtos.preco;
