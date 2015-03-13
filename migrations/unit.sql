CREATE TABLE unit (
    id integer NOT NULL,
    x integer,
    y integer,
    player boolean,
    last_update timestamp without time zone DEFAULT now(),
    direction_right boolean,
    speed interval
);

CREATE SEQUENCE unit_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE unit_id_seq OWNED BY unit.id;
ALTER TABLE ONLY unit ALTER COLUMN id SET DEFAULT nextval('unit_id_seq'::regclass);
ALTER TABLE ONLY unit ADD CONSTRAINT unit_pkey PRIMARY KEY (id);
