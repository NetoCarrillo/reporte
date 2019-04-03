CREATE TABLE bitacora(
   id numeric(20,0) PRIMARY KEY NOT NULL,
   id_sesion numeric(20,0),
   fecha datetime DEFAULT (getdate()) NOT NULL,
   descripcion varchar(500) NOT NULL
);
CREATE TABLE cat_clientes(
   lugar_entrega numeric(20,0),
   factura numeric(20,0),
   destino numeric(20,0),
   consignado_controlado numeric(20,0),
   almacen varchar(255),
   entrega varchar(255)
);
CREATE TABLE cat_contratos(
   pedido varchar(20),
   documento_comercial numeric(20,0),
   cbb numeric(6,0),
   material numeric(20,0),
   tipo varchar(50),
   etiqueta varchar(255),
   fianza varchar(20)
);



CREATE TABLE cat_estatus_orden(
   id numeric(2,0) PRIMARY KEY NOT NULL,
   nombre varchar(30) NOT NULL
);


CREATE TABLE cat_estatus_sa(
   id numeric(2,0) PRIMARY KEY NOT NULL,
   nombre varchar(30) NOT NULL
);


CREATE TABLE ordenes_is(
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
   estatus_sa numeric(2,0),
   estatus_sap numeric(2,0)
);


CREATE TABLE roles(
   id numeric(20,0) PRIMARY KEY NOT NULL,
   nombre varchar(30)
);


CREATE TABLE roles_maypo(
   rol varchar(30) PRIMARY KEY NOT NULL
);


CREATE TABLE sesion(
   id numeric(20,0) PRIMARY KEY NOT NULL,
   id_usuario numeric(20,0) NOT NULL,
   fecha_creacion datetime DEFAULT (getdate()) NOT NULL,
   id_usuario_actividad numeric(20,0),
   fecha_actividad datetime,
   id_usuario_fin numeric(20,0),
   fecha_fin datetime,
   activa numeric(1,0) DEFAULT ((1)) NOT NULL,
   rol numeric(20,0)
);


CREATE TABLE usuarios_web(
   usuario varchar(30) PRIMARY KEY NOT NULL,
   pass varchar(65) NOT NULL,
   nombre varchar(60) NOT NULL,
   apaterno varchar(60) NOT NULL,
   amaterno varchar(60) NOT NULL,
   email varchar(80) NOT NULL
);






CREATE TABLE usuarios_roles(
   usuario varchar(30) NOT NULL,
   rol varchar(30) NOT NULL,
   CONSTRAINT pk_usuarios_roles PRIMARY KEY (usuario,rol)
);



-- Constraints, indexes, etc.
CREATE INDEX cat_clientes_lentrega_idx ON cat_clientes(lugar_entrega);
CREATE INDEX cat_contratos_pedido_cbb_idx ON cat_contratos(pedido, cbb);
CREATE INDEX cat_contratos_material_idx ON cat_contratos(material);
CREATE INDEX ordenes_is_orden_idx ON ordenes_is(orden);
CREATE INDEX ordenes_is_sesion_estatus_idx ON ordenes_is(id_sesion_estatus);

ALTER TABLE ordenes_is 
  ADD CONSTRAINT fk_ordenes_is_session_est 
      FOREIGN KEY (id_sesion_estatus)
      REFERENCES sesion(id);

ALTER TABLE ordenes_is 
  ADD CONSTRAINT fk_imss_sap_estatus_sap 
      FOREIGN KEY (estatus_sap)
      REFERENCES cat_estatus_sa(id);

ALTER TABLE ordenes_is 
  ADD CONSTRAINT fk_ordenes_is_session_ins 
      FOREIGN KEY (id_sesion_insersion)
      REFERENCES sesion(id);

ALTER TABLE ordenes_is 
  ADD CONSTRAINT fk_ordenes_is_estatus 
      FOREIGN KEY (estatus)
      REFERENCES cat_estatus_orden(id);

ALTER TABLE ordenes_is 
  ADD CONSTRAINT fk_imss_sai_estatus_sap 
      FOREIGN KEY (estatus_sa)
      REFERENCES cat_estatus_sa(id);

ALTER TABLE sesion 
  ADD CONSTRAINT fk_sesion_rol 
      FOREIGN KEY (rol)
      REFERENCES roles(id);

ALTER TABLE usuarios_roles 
  ADD CONSTRAINT fk_roles_maypo 
      FOREIGN KEY (rol)
      REFERENCES roles_maypo(rol);

ALTER TABLE usuarios_roles 
  ADD CONSTRAINT fk_ususario_maypo 
      FOREIGN KEY (usuario)
      REFERENCES usuarios_web(usuario);



-- Inserts
INSERT INTO cat_estatus_orden (id,nombre) VALUES (1,'NUEVA');
INSERT INTO cat_estatus_orden (id,nombre) VALUES (2,'PRECONTESTADA');
INSERT INTO cat_estatus_orden (id,nombre) VALUES (3,'CONTESTADA');
INSERT INTO cat_estatus_orden (id,nombre) VALUES (4,'PREENVIADA');
INSERT INTO cat_estatus_orden (id,nombre) VALUES (5,'ENVIADA');
INSERT INTO cat_estatus_orden (id,nombre) VALUES (6,'ERROR');
INSERT INTO cat_estatus_orden (id,nombre) VALUES (7,'AUTOCONTESTADA');

INSERT INTO cat_estatus_sa (id,nombre) VALUES (1,'Pendiente');
INSERT INTO cat_estatus_sa (id,nombre) VALUES (2,'Confirmada');
INSERT INTO cat_estatus_sa (id,nombre) VALUES (3,'Atendida');
INSERT INTO cat_estatus_sa (id,nombre) VALUES (4,'Incumplida');
INSERT INTO cat_estatus_sa (id,nombre) VALUES (5,'Cancelada');

INSERT INTO roles (id,nombre) VALUES (1,'IMSS');
INSERT INTO roles (id,nombre) VALUES (2,'PEMEX');
INSERT INTO roles_maypo (rol) VALUES ('ROLE_USER');

INSERT INTO usuarios_web (usuario,pass,nombre,apaterno,amaterno,email) VALUES ('aespinoza','263c8513eb12002822aa6b638ab6c39ef7835f2402aedd0f5079baefa8b43327','Azucena','Espinoza','Osorio','aespinoza@maypo.com.mx');
INSERT INTO usuarios_web (usuario,pass,nombre,apaterno,amaterno,email) VALUES ('fflores','9351b2884170f1c215c0533e5a7cf90178ae064b0582675c87212a2713ef0094','Fernando','Flores','Rodriguez','fernando.flores@maypo.com.mx');
INSERT INTO usuarios_web (usuario,pass,nombre,apaterno,amaterno,email) VALUES ('nsantiago','c0855e10c7efea3190014a13e7489ec2cd3328546c6747372c2c82d94c5db6b8','Norma Lila','Santiago','','norma.santiago@maypo.com.mx');
INSERT INTO usuarios_web (usuario,pass,nombre,apaterno,amaterno,email) VALUES ('ocruz','f64f89af8a74564928764162375b0615262e535255ffd7b256f18aae1a922dac','Osias','Cruz','','osias.cruz@maypo.com');
INSERT INTO usuarios_web (usuario,pass,nombre,apaterno,amaterno,email) VALUES ('user','04f8996da763b7a969b1028ee3007569eaf3a635486ddab211d512c85b9df8fb','Usuario','Maypo','Maypo','usuario.maypo@maypo.com.mx');

INSERT INTO usuarios_roles (usuario,rol) VALUES ('aespinoza','ROLE_USER');
INSERT INTO usuarios_roles (usuario,rol) VALUES ('fflores','ROLE_USER');
INSERT INTO usuarios_roles (usuario,rol) VALUES ('nsantiago','ROLE_USER');
INSERT INTO usuarios_roles (usuario,rol) VALUES ('ocruz','ROLE_USER');
INSERT INTO usuarios_roles (usuario,rol) VALUES ('user','ROLE_USER');
