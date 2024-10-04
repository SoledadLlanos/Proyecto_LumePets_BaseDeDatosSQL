-- PROYECTO 'LUME PETS' TIENDA DE ROPA Y ACCESORIOS PARA MASCOTAS
DROP DATABASE IF EXISTS lume_pets;

CREATE DATABASE lume_pets;

USE lume_pets;

-- CREACION DE LAS TABLAS

CREATE TABLE IF NOT EXISTS provincias(
    pk_provincia INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nombre_provincia VARCHAR (100) NOT NULL
);

CREATE TABLE IF NOT EXISTS localidades(
    pk_localidad INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nombre_localidad VARCHAR (100) NOT NULL,
    fk_provincia INT NOT NULL,
    FOREIGN KEY (fk_provincia) REFERENCES provincias(pk_provincia)
);

CREATE TABLE IF NOT EXISTS generos(
    pk_genero INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nombre_genero  ENUM('F','M','No Binario')
);

CREATE TABLE IF NOT EXISTS generos_mascotas(
    pk_genero_mascota INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nombre_genero_mascota ENUM('Hembra','Macho','Unisex')
);

CREATE TABLE IF NOT EXISTS colores(
    pk_color INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nombre_color VARCHAR (30) NOT NULL
);

CREATE TABLE IF NOT EXISTS talles(
    pk_talle INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    numero_talle  VARCHAR (10) NOT NULL
);

CREATE TABLE IF NOT EXISTS categorias_productos(
    pk_categoria_producto INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nombre_categoria VARCHAR (20) NOT NULL 
);

CREATE TABLE IF NOT EXISTS tipos_facturas(
    pk_tipo_factura INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nombre_tipo_factura VARCHAR (20) NOT NULL 
);

CREATE TABLE IF NOT EXISTS tipos_sueldo(
    pk_tipo_sueldo INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nombre_tipo_sueldo VARCHAR (20) NOT NULL 
);

CREATE TABLE IF NOT EXISTS turnos(
    pk_turno INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    horario_turno VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS cargos_empleados(
    pk_cargo_empleado INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nombre_cargo VARCHAR (20) NOT NULL, 
    sueldo_mensual_completo DECIMAL NOT NULL
);

CREATE TABLE IF NOT EXISTS detalle_cargos_empleados(
    pk_detalle_cargo_empleado INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    fk_cargo_empleado INT NOT NULL,
    FOREIGN KEY (fk_cargo_empleado) REFERENCES cargos_empleados(pk_cargo_empleado),
    fk_tipo_sueldo INT NOT NULL,
    FOREIGN KEY (fk_tipo_sueldo) REFERENCES tipos_sueldo(pk_tipo_sueldo)
);

CREATE TABLE IF NOT EXISTS productos(
    pk_producto INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nombre_producto VARCHAR (50) NOT NULL,
    cantidad_actual INT NOT NULL,
    precio_actual_unitario DECIMAL NOT NULL,
    producto_activo BOOLEAN DEFAULT TRUE,
    fk_categoria_producto INT NOT NULL,
    FOREIGN KEY (fk_categoria_producto) REFERENCES categorias_productos(pk_categoria_producto),
    fk_genero_mascota INT NOT NULL,
    FOREIGN KEY (fk_genero_mascota) REFERENCES generos_mascotas(pk_genero_mascota),
    fk_talle INT NOT NULL,
    FOREIGN KEY (fk_talle) REFERENCES talles(pk_talle),
    fk_color INT NOT NULL,
    FOREIGN KEY (fk_color) REFERENCES colores(pk_color)
);

CREATE TABLE IF NOT EXISTS proveedores(
    pk_proveedor INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    razon_social VARCHAR (100) NOT NULL,
    cuit_proveedor VARCHAR (30) NOT NULL,
    instagram_proveedor VARCHAR(200) NOT NULL,
    telefono_proveedor VARCHAR (100) NOT NULL,
    direccion_proveedor VARCHAR (300),
    fk_localidad INT NOT NULL,
    FOREIGN KEY (fk_localidad) REFERENCES localidades(pk_localidad)
);

CREATE TABLE IF NOT EXISTS clientes(
    pk_cliente INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nombre_cliente VARCHAR (100) NOT NULL,
    apellido_cliente VARCHAR (100) NOT NULL,
    cuil_cliente VARCHAR (30) NOT NULL,
    email_cliente VARCHAR(200) NOT NULL,
    telefono_cliente VARCHAR (100) NOT NULL,
    nombre_mascota VARCHAR (100) NOT NULL,
    direccion_cliente VARCHAR (300),
    fecha_nacimiento_mascota DATE NOT NULL,
    fk_genero_cliente INT NOT NULL,
    FOREIGN KEY (fk_genero_cliente) REFERENCES generos(pk_genero),
    fk_localidad INT NOT NULL,
    FOREIGN KEY (fk_localidad) REFERENCES localidades(pk_localidad),
    fk_genero_mascota INT NOT NULL,
    FOREIGN KEY (fk_genero_mascota) REFERENCES generos_mascotas(pk_genero_mascota)
);

CREATE TABLE IF NOT EXISTS empleados(
    pk_empleado INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nombre_empleado VARCHAR (100) NOT NULL,
    apellido_empleado VARCHAR(200) NOT NULL,
    dni_empleado VARCHAR (30) NOT NULL,
    cuil_empleado VARCHAR (30) NOT NULL,
    telefono_empleado VARCHAR (100) NOT NULL,
    direccion_empleado VARCHAR (300) NOT NULL,
    fecha_nacimiento_empleado DATE NOT NULL,
    fecha_ingreso DATE NOT NULL,
    fecha_egreso DATE NULL,
    fk_genero INT NOT NULL,
    FOREIGN KEY (fk_genero) REFERENCES generos(pk_genero),
    fk_localidad INT NOT NULL,
    FOREIGN KEY (fk_localidad) REFERENCES localidades(pk_localidad),
    fk_detalle_cargo_empleado INT NOT NULL,
    FOREIGN KEY (fk_detalle_cargo_empleado) REFERENCES detalle_cargos_empleados (pk_detalle_cargo_empleado),
    fk_turno INT NOT NULL,
    FOREIGN KEY (fk_turno) REFERENCES turnos (pk_turno)
);

CREATE TABLE IF NOT EXISTS compras(
    pk_compra INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    fecha_compra DATE NOT NULL,
    numero_factura VARCHAR (100) NOT NULL,
    monto_total DECIMAL NOT NULL,
    fk_proveedor INT NULL,
    FOREIGN KEY (fk_proveedor) REFERENCES proveedores(pk_proveedor),
    fk_tipo_factura INT NOT NULL,
    FOREIGN KEY (fk_tipo_factura) REFERENCES tipos_facturas(pk_tipo_factura),
    fk_empleado INT NULL,
    FOREIGN KEY (fk_empleado) REFERENCES empleados(pk_empleado)
    ON DELETE SET NULL /* EN CASO DE QUE YA NO TRABAJE CON ESE PROVEEDOR Y 
    LO ELIMINE DE MI TABLA PROVEEDORES, ASI MISMO EN EL CASO DE QUE EL EMPLEADO QUE REALIZO LA COMPRA 
    YA NO TRABAJE PARA LA EMPRESA */
    
);

CREATE TABLE IF NOT EXISTS ventas(
    pk_venta INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    fecha_venta DATE NOT NULL,
    numero_factura VARCHAR (100) NOT NULL,
    monto_total DECIMAL NOT NULL,
    fk_cliente INT NOT NULL,
    FOREIGN KEY (fk_cliente) REFERENCES clientes(pk_cliente),
    fk_tipo_factura INT NOT NULL,
    FOREIGN KEY (fk_tipo_factura) REFERENCES tipos_facturas(pk_tipo_factura),
    fk_empleado INT NOT NULL,
    FOREIGN KEY (fk_empleado) REFERENCES empleados (pk_empleado)
);

-- TABLAS INTERMEDIAS

CREATE TABLE IF NOT EXISTS proveedores_productos(
    pk_proveedor_producto INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    fk_proveedor INT NULL,
    FOREIGN KEY (fk_proveedor) REFERENCES proveedores(pk_proveedor),
    fk_producto INT NULL,
    FOREIGN KEY (fk_producto) REFERENCES productos(pk_producto)
    ON DELETE SET NULL /* EN EL CASO DE QUE DECIDA NO TRABAJAR YA CON TAL PROVEEDOR NI TAL O CUAL PRODUCTO,
    O SIMPLEMENTE UN PRODUCTO SE HALLE DISCONTINUADO*/
);

CREATE TABLE IF NOT EXISTS detalles_venta(
	pk_detalle_venta INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    precio_venta_unit DECIMAL NULL,
    cantidad INT NOT NULL,
    fk_producto INT NULL,
    FOREIGN KEY (fk_producto) REFERENCES productos(pk_producto),
    fk_venta INT NULL,
    FOREIGN KEY (fk_venta) REFERENCES ventas(pk_venta)
    ON DELETE SET NULL /* EN EL CASO DE QUE DECIDA NO TRABAJAR YA CON TAL O CUAL PRODUCTO,
    O SIMPLEMENTE UN PRODUCTO SE HALLE DISCONTINUADO*/
);

CREATE TABLE IF NOT EXISTS detalles_compra(
	pk_detalle_compra INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    precio_compra_unit DECIMAL NULL,
    cantidad INT NOT NULL,
    fk_producto INT NULL,
    FOREIGN KEY (fk_producto) REFERENCES productos(pk_producto),
    fk_compra INT NULL,
    FOREIGN KEY (fk_compra) REFERENCES compras(pk_compra)
    ON DELETE SET NULL /* EN EL CASO DE QUE DECIDA NO TRABAJAR YA CON TAL O CUAL PRODUCTO,
    O SIMPLEMENTE UN PRODUCTO SE HALLE DISCONTINUADO*/
);
-- TABLA HISTORICA

CREATE TABLE IF NOT EXISTS bitacora_productos (
    pk_producto INT,
    nombre_producto VARCHAR(50),
    precio_venta INT,
    precio_costo INT,
    fecha_hora DATETIME,
    usuario VARCHAR(50),
    operacion VARCHAR(20)
);

/*INGESTA DE DATOS*/

INSERT INTO provincias(pk_provincia,nombre_provincia) VALUES (NULL,'Buenos Aires'),
(NULL,'Buenos Aires-GBA'),(NULL,'Capital Federal'),(NULL,'Catamarca'),(NULL,'Chaco'),
(NULL,'Chubut'),(NULL,'Cordoba'),(NULL,'Corrientes'),(NULL,'Entre Rios'),(NULL,'Formosa'),
(NULL,'Jujuy'),(NULL,'La Pampa'),(NULL,'La Rioja'),(NULL,'Mendoza'),(NULL,'Misiones'),
(NULL,'Neuquen'),(NULL,'Rio Negro'),(NULL,'Salta'),(NULL,'San Juan'),(NULL,'San Luis'),
(NULL,'Santa Cruz'),(NULL,'Santa Fe'),(NULL,'Santiago del Estero'),(NULL,'Tierra del Fuego'),
(NULL,'Tucuman');

INSERT INTO localidades(pk_localidad,nombre_localidad,fk_provincia) VALUES (NULL,'25 de Mayo',1),
(NULL,'Carmen de Areco',1),(NULL,'Gral. Villegas',1),(NULL,'Tandil',1),(NULL,'Adrogue',2),(NULL,'Ciudadela',2),
(NULL,'Loma Hermosa',2),(NULL,'Sarandi',2),(NULL,'Almagro',3),(NULL,'Belgrano',3),(NULL,'Monte Castro',3),
(NULL,'Villa Urquiza',3),(NULL,'Corral Quemado',4),(NULL,'El Alto',4),(NULL,'El Rodeo',4),(NULL,'F.Mamerto Esquiu',4),
(NULL,'Gral. Vedia',5),(NULL,'Hermoso Campo',5),(NULL,'I. del Cerrito',5),(NULL,'J.J. Castelli',5),
(NULL,'Paso de los Indios',6),(NULL,'Paso del Sapo',6),(NULL,'Pto. Madryn',6),(NULL,'Pto. Pirámides',6),
(NULL,'Alejo Ledesma',7),(NULL,'Alicia',7),(NULL,'Almafuerte',7),(NULL,'Alpa Corral',7),(NULL,'Tatacua',8),
(NULL,'Virasoro',8),(NULL,'Yapeyu',8),(NULL,'Yataiti Calle',8),(NULL,'Aldea Valle Maria',9),(NULL,'Altamirano Sur',9),
(NULL,'Antelo',9),(NULL,'Antonio Tomas',9),(NULL,'Herradura',10),(NULL,'Ibarreta',10),(NULL,'Ing. Juarez',10),
(NULL,'Laguna Blanca',10),(NULL,'Rinconada',11),(NULL,'Rodeitos',11),(NULL,'Rosario de Río Grande',11),
(NULL,'San Antonio',11),(NULL,'La Reforma',12),(NULL,'Limay Mahuida',12),(NULL,'Lonquimay',12),(NULL,'Sta. Rosa',12),
(NULL,'Rosario Penaloza',13),(NULL,'San Blas de Los Sauces',13),(NULL,'Sanagasta',13),(NULL,'Vinchina',13),
(NULL,'Capital',14),(NULL,'Chacras de Coria',14),(NULL,'Dorrego',14),(NULL,'Gllen',14),(NULL,'Dos Arroyos',15),
(NULL,'Dos de Mayo',15),(NULL,'El Alcazar',15),(NULL,'El Dorado',15),(NULL,'Loncopue',16),(NULL,'Los Catutos',16),
(NULL,'Los Chihuidos',16),(NULL,'Los Miches',16),(NULL,'Bariloche',17),(NULL,'Calte. Cordero',17),
(NULL,'Campo Grande',17),(NULL,'Catriel',17),(NULL,'Cerrillos',18),(NULL,'Chicoana',18),(NULL,'Col. Sta. Rosa',18),
(NULL,'Coronel Moldes',18),(NULL,'Nueve de Julio',19),(NULL,'Pocito',19),(NULL,'Rawson',19),
(NULL,'Rivadavia',19),(NULL,'Villa Gral. Roca',20),(NULL,'Villa Larca',20),(NULL,'Villa Mercedes',20),
(NULL,'Zanjitas',20),(NULL,'El Calafate',21),(NULL,'El Chalten',21),(NULL,'Gdor. Gregores',21),
(NULL,'Hipolito Yrigoyen',21),(NULL,'Franck',22),(NULL,'Fray Luis Beltran',22),(NULL,'Frontera',22),
(NULL,'Fuentes',22),(NULL,'Pozo Hondo',23),(NULL,'Quimili',23),(NULL,'Real Sayana',23),(NULL,'Sachayoj',23),
(NULL,'Weisburd',23),(NULL,'Rio Grande',24),(NULL,'Tolhuin',24),(NULL,'Ushuaia',24),(NULL,'Acheral',25),
(NULL,'Agua Dulce',25),(NULL,'Aguilares',25),(NULL,'Alderetes',25);

INSERT INTO generos(pk_genero,nombre_genero) VALUES (NULL,'F'),(NULL,'M'),(NULL,'No Binario');

INSERT INTO generos_mascotas(pk_genero_mascota,nombre_genero_mascota) VALUES (NULL,'Hembra'),(NULL,'Macho'),
(NULL,'Unisex');

INSERT INTO colores(pk_color,nombre_color) VALUES (NULL,'Amarillo'),(NULL,'Amarillo pastel'),
(NULL,'Azul'),(NULL,'Beige'),(NULL,'Blanco'),(NULL,'Borgonia'),(NULL,'Celeste'),
(NULL,'Combinado'),(NULL,'Fucsia'),(NULL,'Gris'),(NULL,'Marron'),(NULL,'Mostaza'),
(NULL,'Naranja'),(NULL,'Negro'),(NULL,'Print'),(NULL,'Rojo'),(NULL,'Rosa'),
(NULL,'Rosa pastel'),(NULL,'Salmon'),(NULL,'Turquesa'),(NULL,'Verde'),(NULL,'Verde pastel'),
(NULL,'Verde lima'),(NULL,'Verde oscuro'),(NULL,'Violeta');

INSERT INTO talles(pk_talle,numero_talle) VALUES (NULL,'1');
INSERT INTO talles(pk_talle,numero_talle) VALUES (NULL,'2');
INSERT INTO talles(pk_talle,numero_talle) VALUES (NULL,'3');
INSERT INTO talles(pk_talle,numero_talle) VALUES (NULL,'4');
INSERT INTO talles(pk_talle,numero_talle) VALUES (NULL,'5');
INSERT INTO talles(pk_talle,numero_talle) VALUES (NULL,'6');
INSERT INTO talles(pk_talle,numero_talle) VALUES (NULL,'7');
INSERT INTO talles(pk_talle,numero_talle) VALUES (NULL,'8');
INSERT INTO talles(pk_talle,numero_talle) VALUES (NULL,'9');
INSERT INTO talles(pk_talle,numero_talle) VALUES (NULL,'10');
INSERT INTO talles(pk_talle,numero_talle) VALUES (NULL,'11');
INSERT INTO talles(pk_talle,numero_talle) VALUES (NULL,'12');
INSERT INTO talles(pk_talle,numero_talle) VALUES (NULL,'Unico');

INSERT INTO categorias_productos(pk_categoria_producto,nombre_categoria) VALUES
(NULL,'ROPA'),(NULL,'ACCESORIOS'),(NULL,'JUGUETES');

INSERT INTO tipos_facturas(pk_tipo_factura,nombre_tipo_factura) VALUES (NULL,'A'),(NULL,'B'),
(NULL,'C'),(NULL,'M'),(NULL,'E'),(NULL,'T'),(NULL,'TICKET CF');

INSERT INTO tipos_sueldo(pk_tipo_sueldo,nombre_tipo_sueldo) VALUES (NULL,'JORNAL'),(NULL,'QUINCENAL'),
(NULL,'MENSUAL');

INSERT INTO turnos(pk_turno,horario_turno) VALUES (NULL,'Part-time Matutino'),(NULL,'Part-time Vespertino'),
(NULL,'COMPLETO');

INSERT INTO cargos_empleados(pk_cargo_empleado,nombre_cargo,sueldo_mensual_completo) VALUES  
(NULL,'Cajero-Vendedor',650000),(NULL,'Repositor',650000),(NULL,'Encargado',700000),(NULL,'Franquero',325000);

INSERT INTO detalle_cargos_empleados(pk_detalle_cargo_empleado,fk_cargo_empleado,fk_tipo_sueldo) VALUES 
(NULL,1,1),(NULL,1,2),(NULL,1,3),(NULL,2,1),(NULL,2,2),(NULL,2,3),(NULL,3,3),(NULL,4,2),(NULL,4,3);


INSERT INTO productos(pk_producto,nombre_producto,cantidad_actual,precio_actual_unitario,producto_activo,
fk_categoria_producto,fk_genero_mascota,fk_talle,fk_color) VALUES
 (NULL,'buzo animacion moschino',2,6500,TRUE,1,2,4,3)
,(NULL,'buzo animacion moschino',1,6500,TRUE,1,3,2,16)
,(NULL,'musculosa animacion batman',2,5000,TRUE,1,3,3,14)
,(NULL,'campera friza',3,8000,TRUE,1,3,7,20)
,(NULL,'campera plush',2,6500,TRUE,1,1,3,18)
,(NULL,'campera plush',4,6500,TRUE,1,2,5,4)
,(NULL,'soft sin mangas liso',5,4000,TRUE,1,1,2,9)
,(NULL,'soft sin mangas liso',2,4000,TRUE,1,2,4,3)
,(NULL,'soft sin mangas liso',6,4000,TRUE,1,3,3,10)
,(NULL,'soft sin mangas huellitas',3,4000,TRUE,1,3,1,5)
,(NULL,'soft sin mangas print',7,4000,TRUE,1,3,9,11)
,(NULL,'soft sin mangas destello',9,4000,FALSE,1,3,6,6)
,(NULL,'soft sin mangas leopardo',5,4000,TRUE,1,3,2,1)
,(NULL,'pañuelo tela para cuello',5,2500,TRUE,1,3,13,6)
,(NULL,'guante de tela para baño raqueta',8,4000,TRUE,2,3,13,1)
,(NULL,'pelota de goma chica',30,700,TRUE,3,3,13,4)
,(NULL,'pelota de goma mediana',2,900,TRUE,3,3,13,15)
,(NULL,'pelota de goma mediana',17,900,TRUE,3,3,13,13)
,(NULL,'pelota de goma con luz',15,150,TRUE,3,3,13,5)
,(NULL,'pelota de goma con luz',10,1500,TRUE,3,3,13,17)
,(NULL,'pelota para bocaditos',4,1500,TRUE,3,3,13,20)
,(NULL,'peluche candy pato',3,3000,TRUE,3,3,13,1)
,(NULL,'peluche candy panda',0,3000,TRUE,3,3,13,8)
,(NULL,'hueso mordillo',33,1500,TRUE,3,3,13,4)
,(NULL,'paleta huella de helado c/chifle',3,1500,TRUE,3,3,13,8)
,(NULL,'rata peluche vibradora',6,2000,TRUE,3,3,13,10)
,(NULL,'soga 4 nudos',7,2000,TRUE,2,3,13,8)
,(NULL,'soga 5 nudos',10,2000,FALSE,2,3,13,8)
,(NULL,'transportadora Skudo',1,30000,TRUE,2,3,13,20)
,(NULL,'transportadora bolso kitty',0,25000,TRUE,2,3,13,9)
,(NULL,'mochila viajera',6,20000,TRUE,2,3,13,14)
,(NULL,'colchoneta lisa',3,9000,TRUE,2,3,13,11)
,(NULL,'colchoneta fantasia',0,10000,TRUE,2,3,13,2)
,(NULL,'moises desmontable',11,16000,TRUE,2,3,13,2)
,(NULL,'sillon antidesgarro',0,25000,TRUE,2,3,13,14)
,(NULL,'bebedero modelo kenia',2,20000,TRUE,2,3,13,19)
,(NULL,'comedero tolva 0111',2,20000,TRUE,2,3,13,3)
,(NULL,'comedero lento huella',4,3500,TRUE,2,3,13,10)
,(NULL,'comedero desmontable con altura',1,2000,TRUE,2,3,13,6)
,(NULL,'comedero con dificultad 17x17',4,2500,TRUE,2,3,13,1)
,(NULL,'pretal alitas de gato',5,3500,TRUE,2,3,13,7)
,(NULL,'deslanador gato pelo largo L',17,17000,TRUE,2,3,13,5)
,(NULL,'deslanador gato pelo largo S',11,15000,TRUE,2,3,13,17);

INSERT INTO proveedores(pk_proveedor,razon_social,cuit_proveedor,instagram_proveedor,telefono_proveedor,direccion_proveedor,fk_localidad) VALUES
 (NULL,'que mona mascotas',201093347,'@quemonamascotas',11345653,'Av Rivadavia 11110',6)
,(NULL,'vale for pets',243171969,'@valeforpets',1144483390,'Pablo Casares 270',2)
,(NULL,'nam hut',23157111083,'@namhut',11634866,'Virasoro 2532',11)
,(NULL,'onda mascotera',2094677001,'@ondamascotera',114311011,'Av Santa Fe 4500',10)
,(NULL,'jumbo',271349953,'@jumbo',115688090,'Pueyrredon 614',9);

INSERT INTO clientes(pk_cliente,nombre_cliente,apellido_cliente,cuil_cliente,email_cliente,telefono_cliente,nombre_mascota,direccion_cliente,fecha_nacimiento_mascota,fk_genero_cliente,fk_localidad,fk_genero_mascota) VALUES
 (NULL,'Alfredo Raul','Martinez',20354029323,'alfredoraulmartinez@gmail.com',1154487792,'Estrella','Maipu 360','2015-08-20',1,1,1)
,(NULL,'Mirta Alejandra','Hernandez',23267790052,'mirtaalejandrahernandez@gmail.com',1142541221,'Mordedor','Olivares 2884','2020-02-28',2,3,2)
,(NULL,'Elena Carla','Alcaraz',27286633493,'elenacarlaalcaraz@gmail.com',1144249875,'Toby','Corrientes 4387','2024-03-16',2,2,2)
,(NULL,'Esteban Carlos','Ramallo',24927264893,'estebancarlosramallo@gmail.com',1165244351,'Toby','Olazabal 1110','2021-01-01',2,3,2)
,(NULL,'Miranda Lucia','Lopez',24301006552,'mirandalucialopez@hotmail.com',1128902004,'Colmillo','Av. Militar 2024','2022-07-10',2,2,2)
,(NULL,'Elvia Ramona','Martinez',27209711123,'elviaramonamartinez@hotmail.com',1152255471,'Peluche','Av. Pueyrredon 350','2022-02-05',2,1,2)
,(NULL,'Luis Manuel','Hernandez',27109888512,'luismanuelhernandez@hotmail.com',1128499908,'Encanto','Loyola 732','2017-02-14',1,1,1)
,(NULL,'Dayanna Ximena','Alcaraz',20925322233,'dayannaximenaalcaraz@outlook.com',11324343221,'Pocho','Av. Rivadavia 7690','2019-06-25',2,1,2)
,(NULL,'Ariana Soledad','Ramallo',23176543563,'arianasoledadramallo@outlook.com',1143667070,'Pamela','Armenia 444','2020-01-23',1,2,1)
,(NULL,'Roxana Celeste','Lopez',23408777763,'roxanacelestelopez@outlook.com',1138665544,'Lucas','Irigoyen 963','2023-09-27',2,2,2)
,(NULL,'Mia Rosa','Martinez',20339705552,'miarosamartinez@outlook.com',1126268833,'Manchas','Comesaña 861','2016-12-31',2,3,2)
,(NULL,'Octavio Jesus','Hernandez',20315754843,'octaviojesushernandez@outlook.com',1155489009,'Irina','San Roque 2547','2021-10-29',1,16,1)
,(NULL,'Pablo Cesar','Camerano',27963128992,'pablocesarcamerano@outlook.com',1162313755,'Pipu Chan','Castelli 720','2015-02-05',1,2,1);

INSERT INTO empleados(pk_empleado,nombre_empleado,apellido_empleado,dni_empleado,cuil_empleado,telefono_empleado,direccion_empleado,
fecha_nacimiento_empleado,fecha_ingreso,fecha_egreso,fk_genero,fk_localidad,fk_detalle_cargo_empleado,fk_turno) VALUES
 (NULL,'Camila Gabriela','Armella','33245722','27332457223','1194522121','Av Juan B Justo 1240','1987-10-03','2020-10-01',NULL,3,'1','3','3')
,(NULL,'Ramiro Luis','Paredes','31994576','27319945763','1197707309','Combate de los Pozos 889','1987-08-20','2020-10-01',NULL,2,'3','6','3')
,(NULL,'Selva Noelia','Prieto','29310250','27293102503','1191005491','Av Alvear 1500','1982-04-23','2023-02-01',NULL,1,'2','9','3')
,(NULL,'Dario Roman','Accorinti','30515675','27305156753','1123789940','Mariano Moreno 478','1988-01-17','2020-10-01',NULL,2,'2','7','3')
,(NULL,'Lorena Alba','Leguizamon','33478141','27334781413','1109004570','Luis Maria Campos 750','1987-11-23','2020-10-01',NULL,1,'1','2','2');


INSERT INTO compras(pk_compra,fecha_compra,numero_factura,monto_total,fk_proveedor,fk_tipo_factura,fk_empleado) VALUES
 (NULL,'2020-10-01',12269608,50000,3,2,4)
,(NULL,'2021-06-14',67825080,35000,3,1,4)
,(NULL,'2021-07-23',70165213,780000,1,1,4)
,(NULL,'2022-04-05',72837684,150000,4,5,3)
,(NULL,'2023-10-03',99944397,790000,4,4,2);

INSERT INTO ventas(pk_venta,fecha_venta,numero_factura,monto_total,fk_cliente,fk_tipo_factura,fk_empleado) VALUES
 (NULL,'2020-10-01',8107705,8000,5,7,1)
,(NULL,'2020-10-01',4894823,25000,9,2,3)
,(NULL,'2020-12-20',8143036,20000,6,2,3)
,(NULL,'2021-01-07',9153071,2500,1,7,1)
,(NULL,'2021-01-15',1394501,17500,11,7,5)
,(NULL,'2021-01-02',95030341,13000,3,7,1)
,(NULL,'2021-08-09',3337813,5000,7,7,1)
,(NULL,'2022-09-07',81800038,34000,1,6,3)
,(NULL,'2022-10-17',8865560,73000,6,1,5)
,(NULL,'2022-11-20',9897684,11000,4,7,3)
,(NULL,'2022-12-10',68041749,9500,1,7,3)
,(NULL,'2022-12-23',4345698,41000,6,2,1)
,(NULL,'2023-02-07',1300343,53000,3,1,1)
,(NULL,'2023-03-31',34723913,12500,8,7,5);

INSERT INTO proveedores_productos(pk_proveedor_producto,fk_proveedor,fk_producto) VALUES
 (NULL,4,26)
,(NULL,3,23)
,(NULL,1,9)
,(NULL,5,1)
,(NULL,5,35)
,(NULL,4,37)
,(NULL,2,37)
,(NULL,4,5)
,(NULL,4,20)
,(NULL,2,43)
,(NULL,2,40)
,(NULL,3,27)
,(NULL,4,27)
,(NULL,4,13)
,(NULL,5,13)
,(NULL,5,12)
,(NULL,1,12)
,(NULL,5,8)
,(NULL,1,8)
,(NULL,2,8)
,(NULL,3,9)
,(NULL,4,9)
,(NULL,3,7)
,(NULL,3,18)
,(NULL,4,18)
,(NULL,1,39)
,(NULL,2,39)
,(NULL,3,40)
,(NULL,5,30)
,(NULL,1,30)
,(NULL,2,3)
,(NULL,3,4);


INSERT INTO detalles_venta(pk_detalle_venta,precio_venta_unit,cantidad,fk_producto,fk_venta) VALUES
 (NULL,1500,1,19,1)
,(NULL,6500,1,1,1)
,(NULL,12500,2,14,2)
,(NULL,6500,1,6,3)
,(NULL,8000,1,4,3)
,(NULL,4000,1,15,3)
,(NULL,1500,1,20,3)
,(NULL,2500,1,40,4)
,(NULL,16000,1,34,5)
,(NULL,1500,1,25,5)
,(NULL,6500,2,5,6)
,(NULL,5000,1,3,7)
,(NULL,900,3,17,8)
,(NULL,900,2,18,8)
,(NULL,20000,1,31,8)
,(NULL,3500,1,38,8)
,(NULL,2000,1,27,8)
,(NULL,2000,1,28,8)
,(NULL,2000,1,26,8)
,(NULL,30000,2,29,9)
,(NULL,3000,1,22,9)
,(NULL,10000,1,33,9)
,(NULL,9000,1,32,10)
,(NULL,2000,1,28,10)
,(NULL,1500,1,24,11)
,(NULL,8000,1,4,11)
,(NULL,25000,1,35,12)
,(NULL,16000,1,34,12)
,(NULL,30000,1,29,13)
,(NULL,20000,1,31,13)
,(NULL,3000,1,23,13)
,(NULL,4000,2,10,14)
,(NULL,2500,1,40,14)
,(NULL,2000,1,39,14);

INSERT INTO detalles_compra(pk_detalle_compra,precio_compra_unit,cantidad,fk_producto,fk_compra) VALUES
 (NULL,4000,6,32,1)
,(NULL,18000,1,30,1)
,(NULL,2000,4,11,1)
,(NULL,3500,10,6,2)
,(NULL,1600,50,38,3)
,(NULL,8000,30,42,3)
,(NULL,600,100,24,3)
,(NULL,10000,40,36,3)
,(NULL,1400,50,22,4)
,(NULL,3000,10,1,4)
,(NULL,1000,50,24,4)
,(NULL,4000,80,33,5)
,(NULL,4000,15,6,5)
,(NULL,450,100,17,5)
,(NULL,800,50,5,5)
,(NULL,19000,15,9,5)
,(NULL,4000,10,5,5);

-- VISTAS

/*1) Mostrar la razon social del proveedor a quien mas se le compro por año*/

CREATE OR REPLACE VIEW fecha_mayor_compra AS
SELECT compras.fecha_compra AS 'Fecha de compra', compras.monto_total AS 'Mayor Compra', proveedores.razon_social AS 'Proveedor'
FROM compras RIGHT JOIN proveedores 
ON fk_proveedor = pk_proveedor
WHERE compras.monto_total = (SELECT MAX(compras.monto_total) FROM compras);

-- SELECT * FROM fecha_mayor_compra;

/*2) Mostrar el nombre completo del empleado que realizo la mayor venta, el monto de esa venta y la fecha*/

CREATE OR REPLACE VIEW mayor_venta AS
SELECT CONCAT(nombre_empleado, ' ', apellido_empleado) AS 'Nombre Completo empleado', ventas.monto_total AS 'Mayor Venta', 
fecha_venta AS 'Fecha de Venta'
FROM empleados RIGHT JOIN ventas 
ON fk_empleado = pk_empleado 
WHERE ventas.monto_total = (SELECT MAX(ventas.monto_total) FROM ventas);

-- SELECT * FROM mayor_venta;

/*3) Mostrar el nombre, color y precio actual del producto mas vendido*/

CREATE OR REPLACE VIEW producto_mas_vendido AS
SELECT productos.nombre_producto AS 'Producto', colores.nombre_color AS 'Color', productos.precio_actual_unitario AS 'Precio Actual'
FROM  detalles_venta INNER JOIN productos 
ON fk_producto = pk_producto
INNER JOIN colores
ON fk_color = pk_color 
WHERE detalles_venta.cantidad = (SELECT MAX(detalles_venta.cantidad) FROM detalles_venta);

-- SELECT * FROM producto_mas_vendido;

/* 4) Mostrar el resultado de la diferencia entre el total de las compras y las ventas de
cada año, agrupadas por año*/

CREATE OR REPLACE VIEW ganancias_por_anio AS
SELECT YEAR(fecha_compra) AS 'Anio', SUM(compras.monto_total) AS 'Total Compras',
SUM(ventas.monto_total) AS 'Total Ventas',
CASE WHEN SUM(compras.monto_total) > SUM(ventas.monto_total) 
THEN CONCAT('-', SUM(compras.monto_total) - SUM(ventas.monto_total))
ELSE SUM(compras.monto_total) - SUM(ventas.monto_total)
END AS 'Ganancia por año'
FROM compras LEFT JOIN ventas ON YEAR(fecha_compra) = YEAR(fecha_venta)
GROUP BY YEAR(fecha_compra)
ORDER BY YEAR(fecha_compra) DESC;

-- SELECT * FROM ganancias_por_anio;

/*FUNCIONES

1) TRAER LAS RAZONES SOCIALES DE LOS PROVEEDORES O DE 1 EN ESPECIFICO*/

DROP FUNCTION  IF EXISTS proveedor;

DELIMITER $$
CREATE FUNCTION  proveedor(idProveedor INT)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE razon_social VARCHAR (100);
    SET razon_social = (SELECT proveedores.razon_social FROM proveedores WHERE pk_proveedor = idProveedor);
    RETURN razon_social;
END
$$

-- SELECT proveedor(pk_proveedor) AS PROVEEDOR FROM proveedores ORDER BY pk_proveedor ASC;
-- SELECT DISTINCT proveedor(3) AS PROVEEDOR FROM proveedores;

/*2) TRAER LOS NOMBRES Y COLORES DE LOS PRODUCTOS */

DROP FUNCTION  IF EXISTS producto_color;

DELIMITER $$
CREATE FUNCTION  producto_color(idProducto INT)
RETURNS VARCHAR(100)
READS SQL DATA
BEGIN
    DECLARE producto VARCHAR (100);
    DECLARE color VARCHAR (50);
    DECLARE  producto_color VARCHAR (100);
    SET producto = (SELECT nombre_producto FROM productos WHERE pk_producto = idProducto);
    SET color = (SELECT nombre_color FROM colores INNER JOIN productos ON pk_color = fk_color WHERE pk_producto = idProducto);
    SET producto_color = (SELECT CONCAT(producto,' color: ', color));
    RETURN producto_color;
END
$$

/* PUESTA A PRUEBA: 

SELECT * FROM productos;
SELECT * FROM colores; */

-- Para visualizar cada producto y sus respectivos colores:

-- SELECT producto_color(pk_producto) AS 'PRODUCTO Y COLOR' FROM productos GROUP BY pk_producto ORDER BY pk_producto ASC; 

-- O Para q me devuelva un solo producto y su valor:

-- SELECT DISTINCT producto_color(4) FROM productos;


/*3) AUMENTAR X % LOS PRECIOS */

DROP FUNCTION IF EXISTS aumenta_precio;

DELIMITER //
CREATE FUNCTION aumenta_precio(idProducto INT , porcentaje FLOAT)
RETURNS FLOAT
READS SQL DATA
BEGIN
    DECLARE precio FLOAT;
    DECLARE  precio_nuevo FLOAT;
    SET precio = (SELECT precio_actual_unitario FROM productos WHERE pk_producto = idProducto);
    SET precio_nuevo = precio + (porcentaje * precio)/100 ;
    RETURN precio_nuevo;
    END
//
-- Para aumentar un 20% a TODOS los productos:

/* SELECT pk_producto, nombre_producto AS 'PRODUCTO', precio_actual_unitario AS 'PRECIO ANTERIOR', aumenta_precio(pk_producto, 20) AS 'NUEVO PRECIO' 
FROM productos GROUP BY pk_producto ORDER BY pk_producto ASC; */

/* 4) MOSTRAR EL STOCK ACTUAL DE CADA PRODUCTO */

DROP FUNCTION stock_por_producto;

DELIMITER //
CREATE FUNCTION stock_por_producto(idProducto INT)
RETURNS VARCHAR(150)
READS SQL DATA
BEGIN
    DECLARE producto VARCHAR(100);
    DECLARE cantidad INT;
    DECLARE resultado VARCHAR(150);
    SET producto = (SELECT nombre_producto FROM productos WHERE pk_producto = idProducto );
    SET cantidad = (SELECT cantidad_actual FROM productos WHERE pk_producto = idProducto);
    SET resultado =  (SELECT CONCAT('EL PRODUCTO ', producto, ' CUENTA CON UN STOCK DE ', cantidad, ' UNIDADES ACTUALMENTE')) ;
    RETURN resultado;
END
//

-- SELECT pk_producto, stock_por_producto(pk_producto) as 'STOCK POR PRODUCTO' FROM productos GROUP BY pk_producto ORDER BY pk_producto;

/*STORED PROCEDURES

/*1) REALIZAR UN PROCEDIMIENTO QUE AUMENTE EL PRECIO DE UN PRODUCTO EN PARTICULAR EN MI TABLA PRODUCTOS Y LO MUESTRE COMO PRECIO ACTUAL*/

DROP PROCEDURE IF EXISTS sp_aplica_aumento;

DELIMITER $$
CREATE PROCEDURE sp_aplica_aumento(IN p_idProducto INT, IN p_porcentaje FLOAT)
BEGIN
    DECLARE mensaje_error1 VARCHAR(100);
    DECLARE mensaje_error2 VARCHAR(100);
    DECLARE mensaje_error3 VARCHAR(100);
    DECLARE mensaje_error4 VARCHAR(100);
    DECLARE precio FLOAT;
    DECLARE precio_nuevo FLOAT;

    -- EVAULUAR QUE SE HAYAN INGRESADO VALORES VÁLIDOS
    IF p_idProducto <= 0 OR p_porcentaje <= 0 THEN
        SET mensaje_error1 = CONCAT('Error: El valor ', p_idProducto, ' o ', p_porcentaje, 
                                    ' o ambos son inválidos. Por favor, ingrese valores válidos y no nulos.');
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = mensaje_error1;
    ELSEIF p_idProducto IS NULL OR p_porcentaje IS NULL THEN
        SET mensaje_error2 = CONCAT('Error: El valor ', p_idProducto, ' o ', p_porcentaje, 
                                    ' o ambos son nulos. Por favor, ingrese valores válidos y no nulos.');
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = mensaje_error2;
    ELSEIF p_idProducto = '' OR p_porcentaje = '' THEN
        SET mensaje_error3 = CONCAT('Error: El valor ', p_idProducto, ' o ', p_porcentaje, 
                                    ' o ninguno de los dos ha sido ingresado. Por favor, ingrese valores válidos y no nulos.');
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = mensaje_error3;
        ELSE
        -- OBTENGO EL PRECIO ACTUAL DE LOS PRODUCTOS QUE ESTEN ACTVOS
            SELECT precio_actual_unitario INTO precio FROM productos
            WHERE pk_producto = p_idProducto AND producto_activo = TRUE;

        -- VERIFICO SI SE ENCONTRO UN PRECIO PARA EL PRODUCTO
            IF precio IS NULL THEN
            SET mensaje_error4 = 'Error: No se encontró precio para producto especificado.';
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = mensaje_error4 ;
            ELSE
	    -- CALCULO EL NUEVO PRECIO CON EL AUMENTO
            SET precio_nuevo = precio + (p_porcentaje * precio) / 100;

		-- ACTUALIZO EL PRECIO EN LA TABLA PRODUCTOS
            UPDATE productos SET precio_actual_unitario = precio_nuevo
            WHERE pk_producto = p_idProducto AND producto_activo = TRUE;
            END IF;
    END IF;
END 
$$
-- SELECT * FROM productos;
-- SELECT * FROM productos WHERE pk_producto = 1;
-- CALL sp_aplica_aumento(1, 15);

-- 2) Aplicar descuento a un producto especifico

DROP PROCEDURE IF EXISTS sp_aplica_descuento;

DELIMITER $$
CREATE PROCEDURE sp_aplica_descuento(IN p_idProducto INT, IN p_porcentaje FLOAT)
BEGIN
    DECLARE mensaje_error1 VARCHAR(100);
    DECLARE mensaje_error2 VARCHAR(100);
    DECLARE mensaje_error3 VARCHAR(100);
    DECLARE mensaje_error4 VARCHAR(100);
    DECLARE precio FLOAT;
    DECLARE precio_rebajado FLOAT;

    -- EVAULUAR QUE SE HAYAN INGRESADO VALORES VÁLIDOS
    IF p_idProducto <= 0 OR p_porcentaje <= 0 THEN
        SET mensaje_error1 = CONCAT('Error: El valor ', p_idProducto, ' o ', p_porcentaje, 
                                    ' o ambos son inválidos. Por favor, ingrese valores válidos y no nulos.');
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = mensaje_error1;
    ELSEIF p_idProducto IS NULL OR p_porcentaje IS NULL THEN
        SET mensaje_error2 = CONCAT('Error: El valor ', p_idProducto, ' o ', p_porcentaje, 
                                    ' o ambos son nulos. Por favor, ingrese valores válidos y no nulos.');
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = mensaje_error2;
    ELSEIF p_idProducto = '' OR p_porcentaje = '' THEN
        SET mensaje_error3 = CONCAT('Error: El valor ', p_idProducto, ' o ', p_porcentaje, 
                                    ' o ninguno de los dos ha sido ingresado. Por favor, ingrese valores válidos y no nulos.');
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = mensaje_error3;
        ELSE
        -- OBTENGO EL PRECIO ACTUAL DE LOS PRODUCTOS QUE ESTEN ACTVOS
            SELECT precio_actual_unitario INTO precio FROM productos
            WHERE pk_producto = p_idProducto AND producto_activo = TRUE;

        -- VERIFICO SI SE ENCONTRO UN PRECIO PARA EL PRODUCTO
            IF precio IS NULL THEN
            SET mensaje_error4 = 'Error: No se encontró precio para producto especificado.';
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = mensaje_error4 ;
            ELSE
	    -- CALCULO EL NUEVO PRECIO CON EL DESCUENTO
            SET precio_rebajado = precio - (p_porcentaje * precio) / 100;

		-- ACTUALIZO EL PRECIO EN LA TABLA PRODUCTOS
            UPDATE productos SET precio_actual_unitario = precio_rebajado
            WHERE pk_producto = p_idProducto AND producto_activo = TRUE;
            END IF;
    END IF;
END 
$$

-- SELECT * FROM PRODUCTOS WHERE pk_producto = 11;
-- CALL sp_aplica_descuento(11, 10);

-- TRIGGERS

/* 1) Trigger para insertar datos por alta de productos en tabla bitacora_productos. 
Se activa luego de ingresar un nuevo producto en mi tabla "productos" */

-- SELECT * FROM bitacora_productos;

DROP TRIGGER IF EXISTS trigger_bitacora_alta_producto; 

DELIMITER $$
CREATE TRIGGER trigger_bitacora_alta_producto
AFTER INSERT ON productos
FOR EACH ROW
BEGIN
    INSERT INTO bitacora_productos(pk_producto, nombre_producto, precio_venta, precio_costo, fecha_hora, usuario, operacion) 
    VALUES (NEW.pk_producto, NEW.nombre_producto, NEW.precio_actual_unitario, NULL, NOW(), USER(), 'ALTA');
END;
$$

/* INSERT DE PRUEBA:

INSERT INTO productos(pk_producto,nombre_producto,cantidad_actual,precio_actual_unitario,producto_activo,
fk_categoria_producto,fk_genero_mascota,fk_talle,fk_color) VALUES (NULL,'peluche candy oruga',1,3000,TRUE,3,3,13,7);
-- 44 es el pk_producto

SELECT * FROM productos; 

SELECT * FROM bitacora_productos;
*/

/*2) Trigger de Baja(eliminacion) de producto*/

DROP TRIGGER IF EXISTS trigger_bitacora_baja_producto;

DELIMITER $$
CREATE TRIGGER trigger_bitacora_baja_producto
AFTER DELETE ON productos
FOR EACH ROW
BEGIN
    DECLARE v_precio_costo FLOAT;
    
    -- Intento obtener el precio de costo desde bitacora_productos
    
    SELECT precio_costo INTO v_precio_costo
    FROM bitacora_productos
    WHERE pk_producto = OLD.pk_producto
    ORDER BY fecha_hora DESC
    LIMIT 1;
    
    -- Si no se encontro en bitacora_productos, lo obtengo desde detalles_compra
    
    IF v_precio_costo IS NULL THEN
        SELECT precio_compra_unit INTO v_precio_costo
        FROM detalles_compra
        WHERE fk_producto = OLD.pk_producto
        ORDER BY pk_detalle_compra DESC
        LIMIT 1;
    END IF;
    
    -- Inserto los datos en bitacora_productos
    
    INSERT INTO bitacora_productos(pk_producto, nombre_producto, precio_venta, precio_costo, fecha_hora, usuario, operacion) 
    VALUES (OLD.pk_producto, OLD.nombre_producto, OLD.precio_actual_unitario, v_precio_costo, NOW(), USER(), 'BAJA');
END
$$

/* PUESTA A PRUEBA:

DELETE FROM productos WHERE pk_producto = 44;
SELECT * FROM bitacora_productos; */