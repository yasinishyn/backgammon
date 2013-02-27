--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: desks; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE desks (
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    checkers hstore,
    first_player_id integer,
    second_player_id integer,
    started boolean DEFAULT false,
    turn character varying(255),
    moves integer
);


--
-- Name: desks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE desks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: desks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE desks_id_seq OWNED BY desks.id;


--
-- Name: dices; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE dices (
    id integer NOT NULL,
    dices hstore,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    desk_id integer
);


--
-- Name: dices_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE dices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE dices_id_seq OWNED BY dices.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying(255) DEFAULT ''::character varying NOT NULL,
    username character varying(255) DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying(255) DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying(255),
    last_sign_in_ip character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY desks ALTER COLUMN id SET DEFAULT nextval('desks_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY dices ALTER COLUMN id SET DEFAULT nextval('dices_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: checkers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY desks
    ADD CONSTRAINT checkers_pkey PRIMARY KEY (id);


--
-- Name: dices_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY dices
    ADD CONSTRAINT dices_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: checkers_checkers; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX checkers_checkers ON desks USING gin (checkers);


--
-- Name: dices_dice; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX dices_dice ON dices USING gin (dices);


--
-- Name: index_dices_on_desk_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_dices_on_desk_id ON dices USING btree (desk_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

INSERT INTO schema_migrations (version) VALUES ('20130214091802');

INSERT INTO schema_migrations (version) VALUES ('20130214092122');

INSERT INTO schema_migrations (version) VALUES ('20130214092457');

INSERT INTO schema_migrations (version) VALUES ('20130214092550');

INSERT INTO schema_migrations (version) VALUES ('20130220110034');

INSERT INTO schema_migrations (version) VALUES ('20130220171753');

INSERT INTO schema_migrations (version) VALUES ('20130221100458');

INSERT INTO schema_migrations (version) VALUES ('20130224111107');

INSERT INTO schema_migrations (version) VALUES ('20130224111933');

INSERT INTO schema_migrations (version) VALUES ('20130224114357');

INSERT INTO schema_migrations (version) VALUES ('20130225094752');

INSERT INTO schema_migrations (version) VALUES ('20130225100432');