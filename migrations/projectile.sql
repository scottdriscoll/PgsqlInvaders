CREATE TABLE projectile (
  id integer NOT NULL,
  x integer,
  y integer,
  player boolean,
  last_update timestamp without time zone DEFAULT now(),
  speed interval
);

CREATE SEQUENCE projectile_id_seq
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

ALTER SEQUENCE projectile_id_seq OWNED BY projectile.id;
ALTER TABLE ONLY projectile ALTER COLUMN id SET DEFAULT nextval('projectile_id_seq'::regclass);
ALTER TABLE ONLY projectile ADD CONSTRAINT projectile_pkey PRIMARY KEY (id);
