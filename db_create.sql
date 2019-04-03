CREATE TABLE "dbo"."bitacora"
(
   id numeric(20,0) PRIMARY KEY NOT NULL,
   id_sesion numeric(20,0),
   fecha datetime DEFAULT (getdate()) NOT NULL,
   descripcion varchar(500) NOT NULL
)
;
CREATE UNIQUE INDEX pk_bitacora ON "dbo"."bitacora"(id)
;
CREATE TABLE "dbo"."cat_clientes"
(
   lugar_entrega numeric(20,0),
   factura numeric(20,0),
   destino numeric(20,0),
   consignado_controlado numeric(20,0),
   almacen varchar(255),
   entrega varchar(255)
)
;
CREATE INDEX cat_clientes_lentrega_idx ON "dbo"."cat_clientes"(lugar_entrega)
;
CREATE TABLE "dbo"."cat_contratos"
(
   pedido varchar(20),
   documento_comercial numeric(20,0),
   cbb numeric(6,0),
   material numeric(20,0),
   tipo varchar(50),
   etiqueta varchar(255),
   fianza varchar(20)
)
;
CREATE INDEX cat_contratos_pedido_cbb_idx ON "dbo"."cat_contratos"
(
  pedido,
  cbb
)
;
CREATE INDEX cat_contratos_material_idx ON "dbo"."cat_contratos"(material)
;



CREATE TABLE "dbo"."cat_estatus_orden"
(
   id numeric(2,0) PRIMARY KEY NOT NULL,
   nombre varchar(30) NOT NULL
)
;
CREATE UNIQUE INDEX pk_cat_estatus_orden ON "dbo"."cat_estatus_orden"(id)
;
INSERT INTO "dbo"."cat_estatus_orden" (id,nombre) VALUES (1,'NUEVA');
INSERT INTO "dbo"."cat_estatus_orden" (id,nombre) VALUES (2,'PRECONTESTADA');
INSERT INTO "dbo"."cat_estatus_orden" (id,nombre) VALUES (3,'CONTESTADA');
INSERT INTO "dbo"."cat_estatus_orden" (id,nombre) VALUES (4,'PREENVIADA');
INSERT INTO "dbo"."cat_estatus_orden" (id,nombre) VALUES (5,'ENVIADA');
INSERT INTO "dbo"."cat_estatus_orden" (id,nombre) VALUES (6,'ERROR');
INSERT INTO "dbo"."cat_estatus_orden" (id,nombre) VALUES (7,'AUTOCONTESTADA');


CREATE TABLE "dbo"."cat_estatus_sai"
(
   id numeric(2,0) PRIMARY KEY NOT NULL,
   nombre varchar(30) NOT NULL
)
;
CREATE UNIQUE INDEX pk_cat_estatus_sai ON "dbo"."cat_estatus_sai"(id)
;
INSERT INTO "dbo"."cat_estatus_sai" (id,nombre) VALUES (1,'Pendiente');
INSERT INTO "dbo"."cat_estatus_sai" (id,nombre) VALUES (2,'Confirmada');
INSERT INTO "dbo"."cat_estatus_sai" (id,nombre) VALUES (3,'Atendida');
INSERT INTO "dbo"."cat_estatus_sai" (id,nombre) VALUES (4,'Incumplida');
INSERT INTO "dbo"."cat_estatus_sai" (id,nombre) VALUES (5,'Cancelada');


CREATE TABLE "dbo"."ordenes_imss"
(
   id numeric(20,0) PRIMARY KEY NOT NULL,
   contrato varchar(20) NOT NULL,
   solicitud numeric(20,0) NOT NULL,
   orden numeric(20,0) NOT NULL,
   fecha_expedicion varchar(30) NOT NULL,
   almacen_destino numeric(20,0),
   estatus numeric(2,0) NOT NULL,
   cbb numeric(6,0),
   fecha_vencimiento varchar(20),
   cantidad numeric(20,0),
   fecha_insersion datetime DEFAULT (getdate()) NOT NULL,
   fecha_estatus datetime DEFAULT (getdate()) NOT NULL,
   id_sesion_insersion numeric(20,0) NOT NULL,
   id_sesion_estatus numeric(20,0) NOT NULL,
   url_con varchar(200),
   url_env varchar(200),
   confirmacion numeric(10,0),
   articulo varchar(255),
   unidad varchar(50),
   precio numeric(10,2),
   lugar_entrega varchar(255),
   lote varchar(10),
   fecha_fabricacion varchar(30),
   fecha_caducidad varchar(30),
   direccion_entrega varchar(255),
   marca varchar(255),
   procedencia varchar(255),
   estatus_sai numeric(2,0),
   estatus_sap numeric(2,0)
)
;
ALTER TABLE "dbo"."ordenes_imss"
ADD CONSTRAINT fk_ordenes_imss_session_est
FOREIGN KEY (id_sesion_estatus)
REFERENCES "dbo"."sesion"(id)
;
ALTER TABLE "dbo"."ordenes_imss"
ADD CONSTRAINT fk_imss_sap_estatus_sap
FOREIGN KEY (estatus_sap)
REFERENCES "dbo"."cat_estatus_sai"(id)
;
ALTER TABLE "dbo"."ordenes_imss"
ADD CONSTRAINT fk_ordenes_imss_session_ins
FOREIGN KEY (id_sesion_insersion)
REFERENCES "dbo"."sesion"(id)
;
ALTER TABLE "dbo"."ordenes_imss"
ADD CONSTRAINT fk_ordenes_imss_estatus
FOREIGN KEY (estatus)
REFERENCES "dbo"."cat_estatus_orden"(id)
;
ALTER TABLE "dbo"."ordenes_imss"
ADD CONSTRAINT fk_imss_sai_estatus_sap
FOREIGN KEY (estatus_sai)
REFERENCES "dbo"."cat_estatus_sai"(id)
;
CREATE UNIQUE INDEX pk_ordenes_imss ON "dbo"."ordenes_imss"(id)
;
CREATE UNIQUE INDEX uq_ordenes_imss ON "dbo"."ordenes_imss"
(
  contrato,
  orden,
  solicitud
)
;
CREATE INDEX ordenes_imss_orden_idx ON "dbo"."ordenes_imss"(orden)
;
CREATE INDEX ordenes_imss_sesion_estatus_idx ON "dbo"."ordenes_imss"(id_sesion_estatus)
;
CREATE TABLE "dbo"."ordenes_pemex"
(
   id numeric(20,0) PRIMARY KEY NOT NULL,
   contrato varchar(20) NOT NULL,
   orden numeric(20,0) NOT NULL,
   siaf numeric(20,0) NOT NULL,
   fecha_generacion varchar(50) NOT NULL,
   estatus numeric(2,0) NOT NULL,
   fecha_insersion datetime DEFAULT (getdate()) NOT NULL,
   fecha_estatus datetime DEFAULT (getdate()) NOT NULL,
   id_sesion_insersion numeric(20,0) NOT NULL,
   id_sesion_estatus numeric(20,0) NOT NULL
)
;
ALTER TABLE "dbo"."ordenes_pemex"
ADD CONSTRAINT fk_ordenes_pemex_sesion_est
FOREIGN KEY (id_sesion_estatus)
REFERENCES "dbo"."sesion"(id)
;
ALTER TABLE "dbo"."ordenes_pemex"
ADD CONSTRAINT fk_ordenes_pemex_sesion_ins
FOREIGN KEY (id_sesion_insersion)
REFERENCES "dbo"."sesion"(id)
;
CREATE INDEX ordenes_pemex_id_idx ON "dbo"."ordenes_pemex"(id)
;
CREATE UNIQUE INDEX pk_ordenes_pemex ON "dbo"."ordenes_pemex"(id)
;
CREATE TABLE "dbo"."productos_pemex"
(
   id numeric(20,0) NOT NULL,
   id_orden numeric(20,0) NOT NULL,
   codificacion varchar(20) NOT NULL,
   cantidad numeric(20,0) NOT NULL,
   precio numeric(12,2) NOT NULL,
   total numeric(12,2) NOT NULL,
   fecha_insersion datetime DEFAULT (getdate()) NOT NULL,
   id_sesion_insersion numeric(20,0) NOT NULL,
   CONSTRAINT pk_productos_pemex PRIMARY KEY (id_orden,id)
)
;
ALTER TABLE "dbo"."productos_pemex"
ADD CONSTRAINT fk_productos_ordenes_pemex
FOREIGN KEY (id_orden)
REFERENCES "dbo"."ordenes_pemex"(id)
;
CREATE UNIQUE INDEX pk_productos_pemex ON "dbo"."productos_pemex"
(
  id_orden,
  id
)
;


CREATE TABLE "dbo"."roles"
(
   id numeric(20,0) PRIMARY KEY NOT NULL,
   nombre varchar(30)
)
;
CREATE UNIQUE INDEX pk_roles ON "dbo"."roles"(id)
;


INSERT INTO "dbo"."roles" (id,nombre) VALUES (1,'IMSS');
INSERT INTO "dbo"."roles" (id,nombre) VALUES (2,'PEMEX');
CREATE TABLE "dbo"."roles_maypo"
(
   rol varchar(30) PRIMARY KEY NOT NULL
)
;
CREATE UNIQUE INDEX pk_roles_maypo ON "dbo"."roles_maypo"(rol)
;


INSERT INTO "dbo"."roles_maypo" (rol) VALUES ('ROLE_USER');
CREATE TABLE "dbo"."sesion"
(
   id numeric(20,0) PRIMARY KEY NOT NULL,
   id_usuario numeric(20,0) NOT NULL,
   fecha_creacion datetime DEFAULT (getdate()) NOT NULL,
   id_usuario_actividad numeric(20,0),
   fecha_actividad datetime,
   id_usuario_fin numeric(20,0),
   fecha_fin datetime,
   activa numeric(1,0) DEFAULT ((1)) NOT NULL,
   rol numeric(20,0)
)
;
ALTER TABLE "dbo"."sesion"
ADD CONSTRAINT fk_sesion_rol
FOREIGN KEY (rol)
REFERENCES "dbo"."roles"(id)
;
CREATE UNIQUE INDEX pk_sesion ON "dbo"."sesion"(id)
;


CREATE TABLE "dbo"."usuarios_maypo"
(
   usuario varchar(30) PRIMARY KEY NOT NULL,
   pass varchar(65) NOT NULL,
   nombre varchar(60) NOT NULL,
   apaterno varchar(60) NOT NULL,
   amaterno varchar(60) NOT NULL,
   email varchar(80) NOT NULL
)
;
CREATE UNIQUE INDEX pk_usuarios_maypo ON "dbo"."usuarios_maypo"(usuario)
;




INSERT INTO "dbo"."usuarios_maypo" (usuario,pass,nombre,apaterno,amaterno,email) VALUES ('aespinoza','263c8513eb12002822aa6b638ab6c39ef7835f2402aedd0f5079baefa8b43327','Azucena','Espinoza','Osorio','aespinoza@maypo.com.mx');
INSERT INTO "dbo"."usuarios_maypo" (usuario,pass,nombre,apaterno,amaterno,email) VALUES ('fflores','9351b2884170f1c215c0533e5a7cf90178ae064b0582675c87212a2713ef0094','Fernando','Flores','Rodriguez','fernando.flores@maypo.com.mx');
INSERT INTO "dbo"."usuarios_maypo" (usuario,pass,nombre,apaterno,amaterno,email) VALUES ('nsantiago','c0855e10c7efea3190014a13e7489ec2cd3328546c6747372c2c82d94c5db6b8','Norma Lila','Santiago','','norma.santiago@maypo.com.mx');
INSERT INTO "dbo"."usuarios_maypo" (usuario,pass,nombre,apaterno,amaterno,email) VALUES ('ocruz','f64f89af8a74564928764162375b0615262e535255ffd7b256f18aae1a922dac','Osias','Cruz','','osias.cruz@maypo.com');
INSERT INTO "dbo"."usuarios_maypo" (usuario,pass,nombre,apaterno,amaterno,email) VALUES ('user','04f8996da763b7a969b1028ee3007569eaf3a635486ddab211d512c85b9df8fb','Usuario','Maypo','Maypo','usuario.maypo@maypo.com.mx');


CREATE TABLE "dbo"."usuarios_roles"
(
   usuario varchar(30) NOT NULL,
   rol varchar(30) NOT NULL,
   CONSTRAINT pk_usuarios_roles PRIMARY KEY (usuario,rol)
)
;
ALTER TABLE "dbo"."usuarios_roles"
ADD CONSTRAINT fk_roles_maypo
FOREIGN KEY (rol)
REFERENCES "dbo"."roles_maypo"(rol)
;
ALTER TABLE "dbo"."usuarios_roles"
ADD CONSTRAINT fk_ususario_maypo
FOREIGN KEY (usuario)
REFERENCES "dbo"."usuarios_maypo"(usuario)
;
CREATE UNIQUE INDEX pk_usuarios_roles ON "dbo"."usuarios_roles"
(
  usuario,
  rol
)
;


INSERT INTO "dbo"."usuarios_roles" (usuario,rol) VALUES ('aespinoza','ROLE_USER');
INSERT INTO "dbo"."usuarios_roles" (usuario,rol) VALUES ('fflores','ROLE_USER');
INSERT INTO "dbo"."usuarios_roles" (usuario,rol) VALUES ('nsantiago','ROLE_USER');
INSERT INTO "dbo"."usuarios_roles" (usuario,rol) VALUES ('ocruz','ROLE_USER');
INSERT INTO "dbo"."usuarios_roles" (usuario,rol) VALUES ('user','ROLE_USER');

