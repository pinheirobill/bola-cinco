


SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


COMMENT ON SCHEMA "public" IS 'standard public schema';



CREATE EXTENSION IF NOT EXISTS "pg_stat_statements" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "supabase_vault" WITH SCHEMA "vault";






CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "extensions";





SET default_tablespace = '';

SET default_table_access_method = "heap";


CREATE TABLE IF NOT EXISTS "public"."active_storage_attachments" (
    "id" bigint NOT NULL,
    "name" character varying NOT NULL,
    "record_type" character varying NOT NULL,
    "record_id" bigint NOT NULL,
    "blob_id" bigint NOT NULL,
    "created_at" timestamp(6) without time zone NOT NULL
);


ALTER TABLE "public"."active_storage_attachments" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."active_storage_attachments_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."active_storage_attachments_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."active_storage_attachments_id_seq" OWNED BY "public"."active_storage_attachments"."id";



CREATE TABLE IF NOT EXISTS "public"."active_storage_blobs" (
    "id" bigint NOT NULL,
    "key" character varying NOT NULL,
    "filename" character varying NOT NULL,
    "content_type" character varying,
    "metadata" "text",
    "service_name" character varying NOT NULL,
    "byte_size" bigint NOT NULL,
    "checksum" character varying,
    "created_at" timestamp(6) without time zone NOT NULL
);


ALTER TABLE "public"."active_storage_blobs" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."active_storage_blobs_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."active_storage_blobs_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."active_storage_blobs_id_seq" OWNED BY "public"."active_storage_blobs"."id";



CREATE TABLE IF NOT EXISTS "public"."active_storage_variant_records" (
    "id" bigint NOT NULL,
    "blob_id" bigint NOT NULL,
    "variation_digest" character varying NOT NULL
);


ALTER TABLE "public"."active_storage_variant_records" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."active_storage_variant_records_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."active_storage_variant_records_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."active_storage_variant_records_id_seq" OWNED BY "public"."active_storage_variant_records"."id";



CREATE TABLE IF NOT EXISTS "public"."ar_internal_metadata" (
    "key" character varying NOT NULL,
    "value" character varying,
    "created_at" timestamp(6) without time zone NOT NULL,
    "updated_at" timestamp(6) without time zone NOT NULL
);


ALTER TABLE "public"."ar_internal_metadata" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."athletes" (
    "id" bigint NOT NULL,
    "birth_certificate" character varying,
    "birth_date" "date",
    "category_id" integer NOT NULL,
    "cell_phone" character varying,
    "cpf" character varying,
    "created_at" timestamp(6) without time zone NOT NULL,
    "document" character varying,
    "documents_count" integer DEFAULT 0 NOT NULL,
    "email" character varying,
    "gender" character varying,
    "name" character varying NOT NULL,
    "passport" character varying,
    "photo_url" character varying,
    "position" character varying,
    "registration_submitted_at" timestamp(6) without time zone,
    "rg" character varying,
    "shirt_number" character varying,
    "source_id" character varying NOT NULL,
    "status" character varying DEFAULT 'pendente'::character varying NOT NULL,
    "team_id" integer NOT NULL,
    "updated_at" timestamp(6) without time zone NOT NULL,
    "user_id" integer,
    "voter_id" character varying
);


ALTER TABLE "public"."athletes" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."athletes_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."athletes_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."athletes_id_seq" OWNED BY "public"."athletes"."id";



CREATE TABLE IF NOT EXISTS "public"."audits" (
    "id" bigint NOT NULL,
    "action" character varying,
    "associated_id" bigint,
    "associated_type" character varying,
    "auditable_id" bigint,
    "auditable_type" character varying,
    "audited_changes" "text",
    "comment" character varying,
    "created_at" timestamp(6) without time zone,
    "remote_address" character varying,
    "request_uuid" character varying,
    "user_id" bigint,
    "user_type" character varying,
    "username" character varying,
    "version" integer DEFAULT 0
);


ALTER TABLE "public"."audits" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."audits_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."audits_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."audits_id_seq" OWNED BY "public"."audits"."id";



CREATE TABLE IF NOT EXISTS "public"."categories" (
    "id" bigint NOT NULL,
    "championship_id" integer,
    "created_at" timestamp(6) without time zone NOT NULL,
    "gender" character varying,
    "max_athletes" integer,
    "max_birth_year" integer,
    "min_birth_year" integer,
    "name" character varying NOT NULL,
    "position" integer,
    "source_id" character varying NOT NULL,
    "updated_at" timestamp(6) without time zone NOT NULL
);


ALTER TABLE "public"."categories" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."categories_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."categories_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."categories_id_seq" OWNED BY "public"."categories"."id";



CREATE TABLE IF NOT EXISTS "public"."championship_categories" (
    "id" bigint NOT NULL,
    "category_id" integer NOT NULL,
    "championship_id" integer NOT NULL,
    "created_at" timestamp(6) without time zone NOT NULL,
    "source_id" character varying NOT NULL,
    "updated_at" timestamp(6) without time zone NOT NULL
);


ALTER TABLE "public"."championship_categories" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."championship_categories_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."championship_categories_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."championship_categories_id_seq" OWNED BY "public"."championship_categories"."id";



CREATE TABLE IF NOT EXISTS "public"."championship_memberships" (
    "id" bigint NOT NULL,
    "championship_id" integer NOT NULL,
    "created_at" timestamp(6) without time zone NOT NULL,
    "notes" "text",
    "role" character varying DEFAULT 'organizador'::character varying NOT NULL,
    "source_id" character varying NOT NULL,
    "status" character varying DEFAULT 'ativo'::character varying NOT NULL,
    "updated_at" timestamp(6) without time zone NOT NULL,
    "user_id" integer NOT NULL
);


ALTER TABLE "public"."championship_memberships" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."championship_memberships_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."championship_memberships_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."championship_memberships_id_seq" OWNED BY "public"."championship_memberships"."id";



CREATE TABLE IF NOT EXISTS "public"."championships" (
    "id" bigint NOT NULL,
    "created_at" timestamp(6) without time zone NOT NULL,
    "end_date" "date",
    "format" json DEFAULT '{}'::json NOT NULL,
    "modality" character varying DEFAULT 'football'::character varying NOT NULL,
    "name" character varying NOT NULL,
    "notes" "text",
    "public_signup_visits_count" integer DEFAULT 0 NOT NULL,
    "registration_end" "date",
    "registration_start" "date",
    "rules" json DEFAULT '{}'::json NOT NULL,
    "scoring" json DEFAULT '{}'::json NOT NULL,
    "season" integer NOT NULL,
    "slug" character varying,
    "source_id" character varying NOT NULL,
    "start_date" "date",
    "status" character varying DEFAULT 'rascunho'::character varying NOT NULL,
    "updated_at" timestamp(6) without time zone NOT NULL
);


ALTER TABLE "public"."championships" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."championships_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."championships_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."championships_id_seq" OWNED BY "public"."championships"."id";



CREATE TABLE IF NOT EXISTS "public"."entities" (
    "id" bigint NOT NULL,
    "city" character varying,
    "created_at" timestamp(6) without time zone NOT NULL,
    "email" character varying,
    "name" character varying NOT NULL,
    "notes" "text",
    "phone" character varying,
    "responsible" character varying,
    "source_id" character varying NOT NULL,
    "updated_at" timestamp(6) without time zone NOT NULL,
    "whatsapp" character varying
);


ALTER TABLE "public"."entities" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."entities_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."entities_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."entities_id_seq" OWNED BY "public"."entities"."id";



CREATE TABLE IF NOT EXISTS "public"."invoices" (
    "id" bigint NOT NULL,
    "amount" numeric(12,2) DEFAULT 0.0 NOT NULL,
    "category_id" integer,
    "championship_id" integer NOT NULL,
    "created_at" timestamp(6) without time zone NOT NULL,
    "due_date" "date",
    "entity_id" integer NOT NULL,
    "status" character varying DEFAULT 'pendente'::character varying NOT NULL,
    "updated_at" timestamp(6) without time zone NOT NULL
);


ALTER TABLE "public"."invoices" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."invoices_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."invoices_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."invoices_id_seq" OWNED BY "public"."invoices"."id";



CREATE TABLE IF NOT EXISTS "public"."match_events" (
    "id" bigint NOT NULL,
    "athlete_id" integer,
    "championship_id" integer NOT NULL,
    "created_at" timestamp(6) without time zone NOT NULL,
    "kind" character varying NOT NULL,
    "match_id" integer,
    "minute" integer,
    "notes" "text",
    "period" character varying,
    "source_data" json DEFAULT '{}'::json NOT NULL,
    "source_id" character varying NOT NULL,
    "team_id" integer,
    "updated_at" timestamp(6) without time zone NOT NULL
);


ALTER TABLE "public"."match_events" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."match_events_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."match_events_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."match_events_id_seq" OWNED BY "public"."match_events"."id";



CREATE TABLE IF NOT EXISTS "public"."match_participations" (
    "id" bigint NOT NULL,
    "athlete_id" integer,
    "athlete_name" character varying NOT NULL,
    "created_at" timestamp(6) without time zone NOT NULL,
    "match_id" integer NOT NULL,
    "notes" "text",
    "position" character varying,
    "shirt_number" character varying,
    "source_id" character varying NOT NULL,
    "status" character varying DEFAULT 'confirmado'::character varying NOT NULL,
    "team_id" integer NOT NULL,
    "updated_at" timestamp(6) without time zone NOT NULL
);


ALTER TABLE "public"."match_participations" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."match_participations_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."match_participations_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."match_participations_id_seq" OWNED BY "public"."match_participations"."id";



CREATE TABLE IF NOT EXISTS "public"."match_reports" (
    "id" bigint NOT NULL,
    "approved_at" timestamp(6) without time zone,
    "created_at" timestamp(6) without time zone NOT NULL,
    "match_id" integer NOT NULL,
    "notes" "text",
    "referee_id" integer,
    "sheet_url" character varying,
    "source_data" json DEFAULT '{}'::json NOT NULL,
    "source_id" character varying NOT NULL,
    "status" character varying DEFAULT 'rascunho'::character varying NOT NULL,
    "submitted_at" timestamp(6) without time zone,
    "updated_at" timestamp(6) without time zone NOT NULL
);


ALTER TABLE "public"."match_reports" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."match_reports_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."match_reports_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."match_reports_id_seq" OWNED BY "public"."match_reports"."id";



CREATE TABLE IF NOT EXISTS "public"."matches" (
    "id" bigint NOT NULL,
    "category_id" integer NOT NULL,
    "championship_id" integer NOT NULL,
    "code" character varying NOT NULL,
    "created_at" timestamp(6) without time zone NOT NULL,
    "decision" character varying,
    "group_key" character varying,
    "highlight_videos" json DEFAULT '[]'::json NOT NULL,
    "penalties_a" integer,
    "penalties_b" integer,
    "phase" character varying NOT NULL,
    "round_number" integer,
    "scheduled_on" "date",
    "scheduled_time" character varying,
    "score_a" integer,
    "score_b" integer,
    "scorers" json DEFAULT '{}'::json NOT NULL,
    "source_a" json,
    "source_b" json,
    "source_data" json DEFAULT '{}'::json NOT NULL,
    "source_id" character varying NOT NULL,
    "status" character varying DEFAULT 'agendado'::character varying NOT NULL,
    "team_a_id" integer,
    "team_b_id" integer,
    "updated_at" timestamp(6) without time zone NOT NULL,
    "venue" character varying,
    "venue_id" integer,
    "winner_id" integer,
    "wo" character varying
);


ALTER TABLE "public"."matches" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."matches_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."matches_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."matches_id_seq" OWNED BY "public"."matches"."id";



CREATE TABLE IF NOT EXISTS "public"."partners" (
    "id" bigint NOT NULL,
    "category_id" integer,
    "championship_id" integer NOT NULL,
    "created_at" timestamp(6) without time zone NOT NULL,
    "highlight" boolean DEFAULT false NOT NULL,
    "logo_url" character varying,
    "name" character varying NOT NULL,
    "notes" "text",
    "source_data" json DEFAULT '{}'::json NOT NULL,
    "source_id" character varying NOT NULL,
    "status" character varying DEFAULT 'ativo'::character varying NOT NULL,
    "tier" character varying DEFAULT 'parceiro'::character varying NOT NULL,
    "updated_at" timestamp(6) without time zone NOT NULL,
    "website_url" character varying
);


ALTER TABLE "public"."partners" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."partners_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."partners_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."partners_id_seq" OWNED BY "public"."partners"."id";



CREATE TABLE IF NOT EXISTS "public"."referees" (
    "id" bigint NOT NULL,
    "championship_id" integer,
    "created_at" timestamp(6) without time zone NOT NULL,
    "document" character varying,
    "email" character varying,
    "name" character varying NOT NULL,
    "notes" "text",
    "phone" character varying,
    "source_id" character varying NOT NULL,
    "status" character varying DEFAULT 'ativo'::character varying NOT NULL,
    "updated_at" timestamp(6) without time zone NOT NULL
);


ALTER TABLE "public"."referees" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."referees_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."referees_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."referees_id_seq" OWNED BY "public"."referees"."id";



CREATE TABLE IF NOT EXISTS "public"."round_selection_athletes" (
    "id" bigint NOT NULL,
    "athlete_id" integer NOT NULL,
    "created_at" timestamp(6) without time zone NOT NULL,
    "position" integer,
    "round_selection_id" integer NOT NULL,
    "updated_at" timestamp(6) without time zone NOT NULL
);


ALTER TABLE "public"."round_selection_athletes" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."round_selection_athletes_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."round_selection_athletes_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."round_selection_athletes_id_seq" OWNED BY "public"."round_selection_athletes"."id";



CREATE TABLE IF NOT EXISTS "public"."round_selections" (
    "id" bigint NOT NULL,
    "category_id" integer,
    "championship_id" integer NOT NULL,
    "created_at" timestamp(6) without time zone NOT NULL,
    "notes" "text",
    "published_at" timestamp(6) without time zone,
    "round_number" integer NOT NULL,
    "source_data" json DEFAULT '{}'::json NOT NULL,
    "source_id" character varying NOT NULL,
    "title" character varying NOT NULL,
    "updated_at" timestamp(6) without time zone NOT NULL
);


ALTER TABLE "public"."round_selections" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."round_selections_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."round_selections_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."round_selections_id_seq" OWNED BY "public"."round_selections"."id";



CREATE TABLE IF NOT EXISTS "public"."schema_migrations" (
    "version" character varying NOT NULL
);


ALTER TABLE "public"."schema_migrations" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."solid_queue_batch_executions" (
    "id" bigint NOT NULL,
    "job_id" bigint NOT NULL,
    "batch_id" bigint NOT NULL,
    "created_at" timestamp(6) without time zone NOT NULL
);


ALTER TABLE "public"."solid_queue_batch_executions" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."solid_queue_batch_executions_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."solid_queue_batch_executions_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."solid_queue_batch_executions_id_seq" OWNED BY "public"."solid_queue_batch_executions"."id";



CREATE TABLE IF NOT EXISTS "public"."solid_queue_batches" (
    "id" bigint NOT NULL,
    "active_job_batch_id" character varying,
    "description" character varying,
    "on_finish" "text",
    "on_success" "text",
    "on_failure" "text",
    "metadata" "text",
    "total_jobs" integer DEFAULT 0 NOT NULL,
    "completed_jobs" integer DEFAULT 0 NOT NULL,
    "failed_jobs" integer DEFAULT 0 NOT NULL,
    "enqueued_at" timestamp(6) without time zone,
    "finished_at" timestamp(6) without time zone,
    "failed_at" timestamp(6) without time zone,
    "created_at" timestamp(6) without time zone NOT NULL,
    "updated_at" timestamp(6) without time zone NOT NULL
);


ALTER TABLE "public"."solid_queue_batches" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."solid_queue_batches_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."solid_queue_batches_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."solid_queue_batches_id_seq" OWNED BY "public"."solid_queue_batches"."id";



CREATE TABLE IF NOT EXISTS "public"."solid_queue_blocked_executions" (
    "id" bigint NOT NULL,
    "job_id" bigint NOT NULL,
    "queue_name" character varying NOT NULL,
    "priority" integer DEFAULT 0 NOT NULL,
    "concurrency_key" character varying NOT NULL,
    "expires_at" timestamp(6) without time zone NOT NULL,
    "created_at" timestamp(6) without time zone NOT NULL
);


ALTER TABLE "public"."solid_queue_blocked_executions" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."solid_queue_blocked_executions_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."solid_queue_blocked_executions_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."solid_queue_blocked_executions_id_seq" OWNED BY "public"."solid_queue_blocked_executions"."id";



CREATE TABLE IF NOT EXISTS "public"."solid_queue_claimed_executions" (
    "id" bigint NOT NULL,
    "job_id" bigint NOT NULL,
    "process_id" bigint,
    "created_at" timestamp(6) without time zone NOT NULL
);


ALTER TABLE "public"."solid_queue_claimed_executions" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."solid_queue_claimed_executions_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."solid_queue_claimed_executions_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."solid_queue_claimed_executions_id_seq" OWNED BY "public"."solid_queue_claimed_executions"."id";



CREATE TABLE IF NOT EXISTS "public"."solid_queue_failed_executions" (
    "id" bigint NOT NULL,
    "job_id" bigint NOT NULL,
    "error" "text",
    "created_at" timestamp(6) without time zone NOT NULL
);


ALTER TABLE "public"."solid_queue_failed_executions" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."solid_queue_failed_executions_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."solid_queue_failed_executions_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."solid_queue_failed_executions_id_seq" OWNED BY "public"."solid_queue_failed_executions"."id";



CREATE TABLE IF NOT EXISTS "public"."solid_queue_jobs" (
    "id" bigint NOT NULL,
    "queue_name" character varying NOT NULL,
    "class_name" character varying NOT NULL,
    "arguments" "text",
    "priority" integer DEFAULT 0 NOT NULL,
    "active_job_id" character varying,
    "scheduled_at" timestamp(6) without time zone,
    "finished_at" timestamp(6) without time zone,
    "concurrency_key" character varying,
    "created_at" timestamp(6) without time zone NOT NULL,
    "updated_at" timestamp(6) without time zone NOT NULL,
    "batch_id" bigint
);


ALTER TABLE "public"."solid_queue_jobs" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."solid_queue_jobs_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."solid_queue_jobs_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."solid_queue_jobs_id_seq" OWNED BY "public"."solid_queue_jobs"."id";



CREATE TABLE IF NOT EXISTS "public"."solid_queue_pauses" (
    "id" bigint NOT NULL,
    "queue_name" character varying NOT NULL,
    "created_at" timestamp(6) without time zone NOT NULL
);


ALTER TABLE "public"."solid_queue_pauses" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."solid_queue_pauses_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."solid_queue_pauses_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."solid_queue_pauses_id_seq" OWNED BY "public"."solid_queue_pauses"."id";



CREATE TABLE IF NOT EXISTS "public"."solid_queue_processes" (
    "id" bigint NOT NULL,
    "kind" character varying NOT NULL,
    "last_heartbeat_at" timestamp(6) without time zone NOT NULL,
    "supervisor_id" bigint,
    "pid" integer NOT NULL,
    "hostname" character varying,
    "metadata" "text",
    "created_at" timestamp(6) without time zone NOT NULL,
    "name" character varying NOT NULL
);


ALTER TABLE "public"."solid_queue_processes" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."solid_queue_processes_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."solid_queue_processes_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."solid_queue_processes_id_seq" OWNED BY "public"."solid_queue_processes"."id";



CREATE TABLE IF NOT EXISTS "public"."solid_queue_ready_executions" (
    "id" bigint NOT NULL,
    "job_id" bigint NOT NULL,
    "queue_name" character varying NOT NULL,
    "priority" integer DEFAULT 0 NOT NULL,
    "created_at" timestamp(6) without time zone NOT NULL
);


ALTER TABLE "public"."solid_queue_ready_executions" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."solid_queue_ready_executions_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."solid_queue_ready_executions_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."solid_queue_ready_executions_id_seq" OWNED BY "public"."solid_queue_ready_executions"."id";



CREATE TABLE IF NOT EXISTS "public"."solid_queue_recurring_executions" (
    "id" bigint NOT NULL,
    "job_id" bigint NOT NULL,
    "task_key" character varying NOT NULL,
    "run_at" timestamp(6) without time zone NOT NULL,
    "created_at" timestamp(6) without time zone NOT NULL
);


ALTER TABLE "public"."solid_queue_recurring_executions" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."solid_queue_recurring_executions_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."solid_queue_recurring_executions_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."solid_queue_recurring_executions_id_seq" OWNED BY "public"."solid_queue_recurring_executions"."id";



CREATE TABLE IF NOT EXISTS "public"."solid_queue_recurring_tasks" (
    "id" bigint NOT NULL,
    "key" character varying NOT NULL,
    "schedule" character varying NOT NULL,
    "command" character varying(2048),
    "class_name" character varying,
    "arguments" "text",
    "queue_name" character varying,
    "priority" integer DEFAULT 0,
    "static" boolean DEFAULT true NOT NULL,
    "description" "text",
    "created_at" timestamp(6) without time zone NOT NULL,
    "updated_at" timestamp(6) without time zone NOT NULL
);


ALTER TABLE "public"."solid_queue_recurring_tasks" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."solid_queue_recurring_tasks_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."solid_queue_recurring_tasks_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."solid_queue_recurring_tasks_id_seq" OWNED BY "public"."solid_queue_recurring_tasks"."id";



CREATE TABLE IF NOT EXISTS "public"."solid_queue_scheduled_executions" (
    "id" bigint NOT NULL,
    "job_id" bigint NOT NULL,
    "queue_name" character varying NOT NULL,
    "priority" integer DEFAULT 0 NOT NULL,
    "scheduled_at" timestamp(6) without time zone NOT NULL,
    "created_at" timestamp(6) without time zone NOT NULL
);


ALTER TABLE "public"."solid_queue_scheduled_executions" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."solid_queue_scheduled_executions_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."solid_queue_scheduled_executions_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."solid_queue_scheduled_executions_id_seq" OWNED BY "public"."solid_queue_scheduled_executions"."id";



CREATE TABLE IF NOT EXISTS "public"."solid_queue_semaphores" (
    "id" bigint NOT NULL,
    "key" character varying NOT NULL,
    "value" integer DEFAULT 1 NOT NULL,
    "expires_at" timestamp(6) without time zone NOT NULL,
    "created_at" timestamp(6) without time zone NOT NULL,
    "updated_at" timestamp(6) without time zone NOT NULL
);


ALTER TABLE "public"."solid_queue_semaphores" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."solid_queue_semaphores_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."solid_queue_semaphores_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."solid_queue_semaphores_id_seq" OWNED BY "public"."solid_queue_semaphores"."id";



CREATE TABLE IF NOT EXISTS "public"."standing_rows" (
    "id" bigint NOT NULL,
    "category_id" integer NOT NULL,
    "championship_id" integer NOT NULL,
    "created_at" timestamp(6) without time zone NOT NULL,
    "draws" integer DEFAULT 0 NOT NULL,
    "goal_diff" integer DEFAULT 0 NOT NULL,
    "goals_against" integer DEFAULT 0 NOT NULL,
    "goals_for" integer DEFAULT 0 NOT NULL,
    "group_key" character varying DEFAULT ''::character varying NOT NULL,
    "losses" integer DEFAULT 0 NOT NULL,
    "played" integer DEFAULT 0 NOT NULL,
    "points" integer DEFAULT 0 NOT NULL,
    "position" integer NOT NULL,
    "qualified" boolean,
    "team_id" integer NOT NULL,
    "updated_at" timestamp(6) without time zone NOT NULL,
    "wins" integer DEFAULT 0 NOT NULL
);


ALTER TABLE "public"."standing_rows" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."standing_rows_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."standing_rows_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."standing_rows_id_seq" OWNED BY "public"."standing_rows"."id";



CREATE TABLE IF NOT EXISTS "public"."suspensions" (
    "id" bigint NOT NULL,
    "athlete_id" integer NOT NULL,
    "automatic" boolean DEFAULT false NOT NULL,
    "category_id" integer,
    "championship_id" integer NOT NULL,
    "created_at" timestamp(6) without time zone NOT NULL,
    "ends_on" "date",
    "match_event_id" integer,
    "matches_count" integer DEFAULT 1 NOT NULL,
    "notes" "text",
    "reason" character varying NOT NULL,
    "source_data" json DEFAULT '{}'::json NOT NULL,
    "source_id" character varying NOT NULL,
    "starts_on" "date",
    "status" character varying DEFAULT 'ativa'::character varying NOT NULL,
    "team_id" integer,
    "updated_at" timestamp(6) without time zone NOT NULL
);


ALTER TABLE "public"."suspensions" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."suspensions_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."suspensions_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."suspensions_id_seq" OWNED BY "public"."suspensions"."id";



CREATE TABLE IF NOT EXISTS "public"."team_athletes" (
    "id" bigint NOT NULL,
    "athlete_id" integer NOT NULL,
    "created_at" timestamp(6) without time zone NOT NULL,
    "source_id" character varying NOT NULL,
    "team_id" integer NOT NULL,
    "updated_at" timestamp(6) without time zone NOT NULL
);


ALTER TABLE "public"."team_athletes" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."team_athletes_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."team_athletes_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."team_athletes_id_seq" OWNED BY "public"."team_athletes"."id";



CREATE TABLE IF NOT EXISTS "public"."team_memberships" (
    "id" bigint NOT NULL,
    "created_at" timestamp(6) without time zone NOT NULL,
    "notes" "text",
    "role" character varying DEFAULT 'tecnico'::character varying NOT NULL,
    "source_id" character varying NOT NULL,
    "status" character varying DEFAULT 'ativo'::character varying NOT NULL,
    "team_id" integer NOT NULL,
    "updated_at" timestamp(6) without time zone NOT NULL,
    "user_id" integer NOT NULL
);


ALTER TABLE "public"."team_memberships" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."team_memberships_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."team_memberships_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."team_memberships_id_seq" OWNED BY "public"."team_memberships"."id";



CREATE TABLE IF NOT EXISTS "public"."teams" (
    "id" bigint NOT NULL,
    "category_id" integer NOT NULL,
    "created_at" timestamp(6) without time zone NOT NULL,
    "entity_id" integer NOT NULL,
    "finance_status" character varying DEFAULT 'pendente'::character varying NOT NULL,
    "group_key" character varying,
    "name" character varying NOT NULL,
    "registration_status" character varying DEFAULT 'pendente'::character varying NOT NULL,
    "short_name" character varying,
    "source_id" character varying NOT NULL,
    "updated_at" timestamp(6) without time zone NOT NULL
);


ALTER TABLE "public"."teams" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."teams_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."teams_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."teams_id_seq" OWNED BY "public"."teams"."id";



CREATE TABLE IF NOT EXISTS "public"."tranca_classificacao_rows" (
    "id" bigint NOT NULL,
    "category_id" integer NOT NULL,
    "championship_id" integer NOT NULL,
    "created_at" timestamp(6) without time zone NOT NULL,
    "draws" integer DEFAULT 0 NOT NULL,
    "goal_diff" integer DEFAULT 0 NOT NULL,
    "goals_against" integer DEFAULT 0 NOT NULL,
    "goals_for" integer DEFAULT 0 NOT NULL,
    "group_key" character varying DEFAULT ''::character varying NOT NULL,
    "losses" integer DEFAULT 0 NOT NULL,
    "played" integer DEFAULT 0 NOT NULL,
    "points" integer DEFAULT 0 NOT NULL,
    "position" integer NOT NULL,
    "qualified" boolean,
    "source_id" character varying NOT NULL,
    "tranca_dupla_id" integer NOT NULL,
    "updated_at" timestamp(6) without time zone NOT NULL,
    "wins" integer DEFAULT 0 NOT NULL,
    "stage_number" integer DEFAULT 1 NOT NULL
);


ALTER TABLE "public"."tranca_classificacao_rows" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."tranca_classificacao_rows_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."tranca_classificacao_rows_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."tranca_classificacao_rows_id_seq" OWNED BY "public"."tranca_classificacao_rows"."id";



CREATE TABLE IF NOT EXISTS "public"."tranca_dupla_memberships" (
    "id" bigint NOT NULL,
    "athlete_id" integer NOT NULL,
    "created_at" timestamp(6) without time zone NOT NULL,
    "position" integer,
    "shirt_number" character varying,
    "source_id" character varying NOT NULL,
    "tranca_dupla_id" integer NOT NULL,
    "updated_at" timestamp(6) without time zone NOT NULL
);


ALTER TABLE "public"."tranca_dupla_memberships" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."tranca_dupla_memberships_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."tranca_dupla_memberships_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."tranca_dupla_memberships_id_seq" OWNED BY "public"."tranca_dupla_memberships"."id";



CREATE TABLE IF NOT EXISTS "public"."tranca_duplas" (
    "id" bigint NOT NULL,
    "category_id" integer NOT NULL,
    "championship_id" integer NOT NULL,
    "created_at" timestamp(6) without time zone NOT NULL,
    "entity_id" integer,
    "name" character varying NOT NULL,
    "registration_status" character varying DEFAULT 'aprovada'::character varying NOT NULL,
    "short_name" character varying,
    "source_id" character varying NOT NULL,
    "status" character varying DEFAULT 'ativo'::character varying NOT NULL,
    "updated_at" timestamp(6) without time zone NOT NULL
);


ALTER TABLE "public"."tranca_duplas" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."tranca_duplas_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."tranca_duplas_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."tranca_duplas_id_seq" OWNED BY "public"."tranca_duplas"."id";



CREATE TABLE IF NOT EXISTS "public"."tranca_mesas" (
    "id" bigint NOT NULL,
    "championship_id" integer NOT NULL,
    "code" character varying NOT NULL,
    "created_at" timestamp(6) without time zone NOT NULL,
    "location" character varying,
    "name" character varying NOT NULL,
    "source_id" character varying NOT NULL,
    "status" character varying DEFAULT 'disponivel'::character varying NOT NULL,
    "tranca_rodada_id" integer,
    "updated_at" timestamp(6) without time zone NOT NULL
);


ALTER TABLE "public"."tranca_mesas" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."tranca_mesas_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."tranca_mesas_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."tranca_mesas_id_seq" OWNED BY "public"."tranca_mesas"."id";



CREATE TABLE IF NOT EXISTS "public"."tranca_partida_maos" (
    "id" bigint NOT NULL,
    "batida_a" boolean DEFAULT false NOT NULL,
    "batida_b" boolean DEFAULT false NOT NULL,
    "canastra_limpa_a" boolean DEFAULT false NOT NULL,
    "canastra_limpa_b" boolean DEFAULT false NOT NULL,
    "canastra_suja_a" boolean DEFAULT false NOT NULL,
    "canastra_suja_b" boolean DEFAULT false NOT NULL,
    "championship_id" integer NOT NULL,
    "created_at" timestamp(6) without time zone NOT NULL,
    "desconto_a" integer DEFAULT 0 NOT NULL,
    "desconto_b" integer DEFAULT 0 NOT NULL,
    "numero" integer NOT NULL,
    "observacoes" "text",
    "pontos_a" integer DEFAULT 0 NOT NULL,
    "pontos_b" integer DEFAULT 0 NOT NULL,
    "source_data" json DEFAULT '{}'::json NOT NULL,
    "source_id" character varying NOT NULL,
    "tranca_partida_id" integer NOT NULL,
    "tres_vermelho_a" boolean DEFAULT false NOT NULL,
    "tres_vermelho_b" boolean DEFAULT false NOT NULL,
    "updated_at" timestamp(6) without time zone NOT NULL
);


ALTER TABLE "public"."tranca_partida_maos" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."tranca_partida_maos_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."tranca_partida_maos_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."tranca_partida_maos_id_seq" OWNED BY "public"."tranca_partida_maos"."id";



CREATE TABLE IF NOT EXISTS "public"."tranca_partidas" (
    "id" bigint NOT NULL,
    "category_id" integer NOT NULL,
    "championship_id" integer NOT NULL,
    "code" character varying NOT NULL,
    "created_at" timestamp(6) without time zone NOT NULL,
    "decision" character varying,
    "dupla_a_id" integer,
    "dupla_b_id" integer,
    "group_key" character varying,
    "penalties_a" integer,
    "penalties_b" integer,
    "phase" character varying NOT NULL,
    "round_number" integer,
    "scheduled_on" "date",
    "scheduled_time" character varying,
    "score_a" integer,
    "score_b" integer,
    "source_data" json DEFAULT '{}'::json NOT NULL,
    "source_id" character varying NOT NULL,
    "status" character varying DEFAULT 'agendado'::character varying NOT NULL,
    "tranca_mesa_id" integer,
    "tranca_rodada_id" integer,
    "updated_at" timestamp(6) without time zone NOT NULL,
    "winner_id" integer,
    "wo" character varying,
    "stage_number" integer DEFAULT 1 NOT NULL
);


ALTER TABLE "public"."tranca_partidas" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."tranca_partidas_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."tranca_partidas_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."tranca_partidas_id_seq" OWNED BY "public"."tranca_partidas"."id";



CREATE TABLE IF NOT EXISTS "public"."tranca_rodadas" (
    "id" bigint NOT NULL,
    "championship_id" integer NOT NULL,
    "created_at" timestamp(6) without time zone NOT NULL,
    "ends_on" "date",
    "label" character varying NOT NULL,
    "phase" character varying NOT NULL,
    "round_number" integer NOT NULL,
    "source_id" character varying NOT NULL,
    "starts_on" "date",
    "status" character varying DEFAULT 'programada'::character varying NOT NULL,
    "updated_at" timestamp(6) without time zone NOT NULL,
    "stage_number" integer DEFAULT 1 NOT NULL
);


ALTER TABLE "public"."tranca_rodadas" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."tranca_rodadas_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."tranca_rodadas_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."tranca_rodadas_id_seq" OWNED BY "public"."tranca_rodadas"."id";



CREATE TABLE IF NOT EXISTS "public"."tranca_settings" (
    "id" bigint NOT NULL,
    "championship_id" integer NOT NULL,
    "created_at" timestamp(6) without time zone NOT NULL,
    "format" json DEFAULT '{}'::json NOT NULL,
    "rules" json DEFAULT '{}'::json NOT NULL,
    "scoring" json DEFAULT '{}'::json NOT NULL,
    "source_id" character varying NOT NULL,
    "updated_at" timestamp(6) without time zone NOT NULL
);


ALTER TABLE "public"."tranca_settings" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."tranca_settings_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."tranca_settings_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."tranca_settings_id_seq" OWNED BY "public"."tranca_settings"."id";



CREATE TABLE IF NOT EXISTS "public"."users" (
    "id" bigint NOT NULL,
    "created_at" timestamp(6) without time zone NOT NULL,
    "email" character varying DEFAULT ''::character varying NOT NULL,
    "encrypted_password" character varying DEFAULT ''::character varying NOT NULL,
    "preferred_theme" character varying DEFAULT 'corporate'::character varying NOT NULL,
    "remember_created_at" timestamp(6) without time zone,
    "reset_password_sent_at" timestamp(6) without time zone,
    "reset_password_token" character varying,
    "role" character varying DEFAULT 'adm_master'::character varying NOT NULL,
    "updated_at" timestamp(6) without time zone NOT NULL
);


ALTER TABLE "public"."users" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."users_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."users_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."users_id_seq" OWNED BY "public"."users"."id";



CREATE TABLE IF NOT EXISTS "public"."venues" (
    "id" bigint NOT NULL,
    "address" character varying,
    "championship_id" integer,
    "city" character varying,
    "created_at" timestamp(6) without time zone NOT NULL,
    "name" character varying NOT NULL,
    "notes" "text",
    "short_name" character varying,
    "source_id" character varying NOT NULL,
    "status" character varying DEFAULT 'ativo'::character varying NOT NULL,
    "updated_at" timestamp(6) without time zone NOT NULL
);


ALTER TABLE "public"."venues" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."venues_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."venues_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."venues_id_seq" OWNED BY "public"."venues"."id";



ALTER TABLE ONLY "public"."active_storage_attachments" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."active_storage_attachments_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."active_storage_blobs" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."active_storage_blobs_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."active_storage_variant_records" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."active_storage_variant_records_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."athletes" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."athletes_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."audits" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."audits_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."categories" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."categories_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."championship_categories" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."championship_categories_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."championship_memberships" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."championship_memberships_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."championships" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."championships_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."entities" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."entities_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."invoices" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."invoices_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."match_events" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."match_events_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."match_participations" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."match_participations_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."match_reports" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."match_reports_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."matches" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."matches_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."partners" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."partners_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."referees" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."referees_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."round_selection_athletes" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."round_selection_athletes_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."round_selections" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."round_selections_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."solid_queue_batch_executions" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."solid_queue_batch_executions_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."solid_queue_batches" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."solid_queue_batches_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."solid_queue_blocked_executions" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."solid_queue_blocked_executions_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."solid_queue_claimed_executions" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."solid_queue_claimed_executions_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."solid_queue_failed_executions" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."solid_queue_failed_executions_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."solid_queue_jobs" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."solid_queue_jobs_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."solid_queue_pauses" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."solid_queue_pauses_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."solid_queue_processes" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."solid_queue_processes_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."solid_queue_ready_executions" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."solid_queue_ready_executions_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."solid_queue_recurring_executions" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."solid_queue_recurring_executions_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."solid_queue_recurring_tasks" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."solid_queue_recurring_tasks_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."solid_queue_scheduled_executions" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."solid_queue_scheduled_executions_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."solid_queue_semaphores" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."solid_queue_semaphores_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."standing_rows" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."standing_rows_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."suspensions" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."suspensions_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."team_athletes" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."team_athletes_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."team_memberships" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."team_memberships_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."teams" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."teams_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."tranca_classificacao_rows" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."tranca_classificacao_rows_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."tranca_dupla_memberships" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."tranca_dupla_memberships_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."tranca_duplas" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."tranca_duplas_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."tranca_mesas" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."tranca_mesas_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."tranca_partida_maos" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."tranca_partida_maos_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."tranca_partidas" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."tranca_partidas_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."tranca_rodadas" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."tranca_rodadas_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."tranca_settings" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."tranca_settings_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."users" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."users_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."venues" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."venues_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."active_storage_attachments"
    ADD CONSTRAINT "active_storage_attachments_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."active_storage_blobs"
    ADD CONSTRAINT "active_storage_blobs_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."active_storage_variant_records"
    ADD CONSTRAINT "active_storage_variant_records_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."ar_internal_metadata"
    ADD CONSTRAINT "ar_internal_metadata_pkey" PRIMARY KEY ("key");



ALTER TABLE ONLY "public"."athletes"
    ADD CONSTRAINT "athletes_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."audits"
    ADD CONSTRAINT "audits_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."categories"
    ADD CONSTRAINT "categories_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."championship_categories"
    ADD CONSTRAINT "championship_categories_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."championship_memberships"
    ADD CONSTRAINT "championship_memberships_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."championships"
    ADD CONSTRAINT "championships_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."entities"
    ADD CONSTRAINT "entities_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."invoices"
    ADD CONSTRAINT "invoices_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."match_events"
    ADD CONSTRAINT "match_events_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."match_participations"
    ADD CONSTRAINT "match_participations_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."match_reports"
    ADD CONSTRAINT "match_reports_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."matches"
    ADD CONSTRAINT "matches_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."partners"
    ADD CONSTRAINT "partners_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."referees"
    ADD CONSTRAINT "referees_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."round_selection_athletes"
    ADD CONSTRAINT "round_selection_athletes_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."round_selections"
    ADD CONSTRAINT "round_selections_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."schema_migrations"
    ADD CONSTRAINT "schema_migrations_pkey" PRIMARY KEY ("version");



ALTER TABLE ONLY "public"."solid_queue_batch_executions"
    ADD CONSTRAINT "solid_queue_batch_executions_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."solid_queue_batches"
    ADD CONSTRAINT "solid_queue_batches_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."solid_queue_blocked_executions"
    ADD CONSTRAINT "solid_queue_blocked_executions_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."solid_queue_claimed_executions"
    ADD CONSTRAINT "solid_queue_claimed_executions_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."solid_queue_failed_executions"
    ADD CONSTRAINT "solid_queue_failed_executions_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."solid_queue_jobs"
    ADD CONSTRAINT "solid_queue_jobs_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."solid_queue_pauses"
    ADD CONSTRAINT "solid_queue_pauses_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."solid_queue_processes"
    ADD CONSTRAINT "solid_queue_processes_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."solid_queue_ready_executions"
    ADD CONSTRAINT "solid_queue_ready_executions_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."solid_queue_recurring_executions"
    ADD CONSTRAINT "solid_queue_recurring_executions_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."solid_queue_recurring_tasks"
    ADD CONSTRAINT "solid_queue_recurring_tasks_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."solid_queue_scheduled_executions"
    ADD CONSTRAINT "solid_queue_scheduled_executions_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."solid_queue_semaphores"
    ADD CONSTRAINT "solid_queue_semaphores_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."standing_rows"
    ADD CONSTRAINT "standing_rows_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."suspensions"
    ADD CONSTRAINT "suspensions_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."team_athletes"
    ADD CONSTRAINT "team_athletes_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."team_memberships"
    ADD CONSTRAINT "team_memberships_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."teams"
    ADD CONSTRAINT "teams_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."tranca_classificacao_rows"
    ADD CONSTRAINT "tranca_classificacao_rows_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."tranca_dupla_memberships"
    ADD CONSTRAINT "tranca_dupla_memberships_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."tranca_duplas"
    ADD CONSTRAINT "tranca_duplas_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."tranca_mesas"
    ADD CONSTRAINT "tranca_mesas_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."tranca_partida_maos"
    ADD CONSTRAINT "tranca_partida_maos_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."tranca_partidas"
    ADD CONSTRAINT "tranca_partidas_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."tranca_rodadas"
    ADD CONSTRAINT "tranca_rodadas_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."tranca_settings"
    ADD CONSTRAINT "tranca_settings_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."venues"
    ADD CONSTRAINT "venues_pkey" PRIMARY KEY ("id");



CREATE INDEX "associated_index" ON "public"."audits" USING "btree" ("associated_type", "associated_id");



CREATE INDEX "auditable_index" ON "public"."audits" USING "btree" ("auditable_type", "auditable_id", "version");



CREATE INDEX "idx_on_championship_id_category_id_status_7b5eed8cd6" ON "public"."suspensions" USING "btree" ("championship_id", "category_id", "status");



CREATE UNIQUE INDEX "idx_on_round_selection_id_athlete_id_ce14c7b16e" ON "public"."round_selection_athletes" USING "btree" ("round_selection_id", "athlete_id");



CREATE INDEX "index_active_storage_attachments_on_blob_id" ON "public"."active_storage_attachments" USING "btree" ("blob_id");



CREATE UNIQUE INDEX "index_active_storage_attachments_uniqueness" ON "public"."active_storage_attachments" USING "btree" ("record_type", "record_id", "name", "blob_id");



CREATE UNIQUE INDEX "index_active_storage_blobs_on_key" ON "public"."active_storage_blobs" USING "btree" ("key");



CREATE UNIQUE INDEX "index_active_storage_variant_records_uniqueness" ON "public"."active_storage_variant_records" USING "btree" ("blob_id", "variation_digest");



CREATE INDEX "index_athletes_on_category_id" ON "public"."athletes" USING "btree" ("category_id");



CREATE UNIQUE INDEX "index_athletes_on_source_id" ON "public"."athletes" USING "btree" ("source_id");



CREATE INDEX "index_athletes_on_team_id" ON "public"."athletes" USING "btree" ("team_id");



CREATE INDEX "index_athletes_on_team_id_and_status" ON "public"."athletes" USING "btree" ("team_id", "status");



CREATE UNIQUE INDEX "index_athletes_on_team_id_and_user_id" ON "public"."athletes" USING "btree" ("team_id", "user_id");



CREATE UNIQUE INDEX "index_athletes_on_user_id" ON "public"."athletes" USING "btree" ("user_id");



CREATE INDEX "index_audits_on_created_at" ON "public"."audits" USING "btree" ("created_at");



CREATE INDEX "index_audits_on_request_uuid" ON "public"."audits" USING "btree" ("request_uuid");



CREATE INDEX "index_categories_on_championship_id" ON "public"."categories" USING "btree" ("championship_id");



CREATE INDEX "index_categories_on_championship_id_and_position" ON "public"."categories" USING "btree" ("championship_id", "position");



CREATE UNIQUE INDEX "index_categories_on_source_id" ON "public"."categories" USING "btree" ("source_id");



CREATE INDEX "index_championship_categories_on_category_id" ON "public"."championship_categories" USING "btree" ("category_id");



CREATE UNIQUE INDEX "index_championship_categories_on_championship_and_category" ON "public"."championship_categories" USING "btree" ("championship_id", "category_id");



CREATE INDEX "index_championship_categories_on_championship_id" ON "public"."championship_categories" USING "btree" ("championship_id");



CREATE UNIQUE INDEX "index_championship_categories_on_source_id" ON "public"."championship_categories" USING "btree" ("source_id");



CREATE INDEX "index_championship_memberships_on_championship_id" ON "public"."championship_memberships" USING "btree" ("championship_id");



CREATE UNIQUE INDEX "index_championship_memberships_on_championship_id_and_user_id" ON "public"."championship_memberships" USING "btree" ("championship_id", "user_id");



CREATE UNIQUE INDEX "index_championship_memberships_on_source_id" ON "public"."championship_memberships" USING "btree" ("source_id");



CREATE INDEX "index_championship_memberships_on_user_id" ON "public"."championship_memberships" USING "btree" ("user_id");



CREATE INDEX "index_championship_memberships_on_user_id_and_status" ON "public"."championship_memberships" USING "btree" ("user_id", "status");



CREATE INDEX "index_championships_on_modality" ON "public"."championships" USING "btree" ("modality");



CREATE INDEX "index_championships_on_season" ON "public"."championships" USING "btree" ("season");



CREATE UNIQUE INDEX "index_championships_on_slug" ON "public"."championships" USING "btree" ("slug");



CREATE UNIQUE INDEX "index_championships_on_source_id" ON "public"."championships" USING "btree" ("source_id");



CREATE INDEX "index_championships_on_status" ON "public"."championships" USING "btree" ("status");



CREATE INDEX "index_entities_on_name" ON "public"."entities" USING "btree" ("name");



CREATE UNIQUE INDEX "index_entities_on_source_id" ON "public"."entities" USING "btree" ("source_id");



CREATE INDEX "index_invoices_on_category_id" ON "public"."invoices" USING "btree" ("category_id");



CREATE INDEX "index_invoices_on_championship_id" ON "public"."invoices" USING "btree" ("championship_id");



CREATE INDEX "index_invoices_on_championship_id_and_category_id" ON "public"."invoices" USING "btree" ("championship_id", "category_id");



CREATE INDEX "index_invoices_on_entity_id" ON "public"."invoices" USING "btree" ("entity_id");



CREATE INDEX "index_invoices_on_entity_id_and_status" ON "public"."invoices" USING "btree" ("entity_id", "status");



CREATE INDEX "index_match_events_on_athlete_id" ON "public"."match_events" USING "btree" ("athlete_id");



CREATE INDEX "index_match_events_on_athlete_id_and_kind" ON "public"."match_events" USING "btree" ("athlete_id", "kind");



CREATE INDEX "index_match_events_on_championship_id" ON "public"."match_events" USING "btree" ("championship_id");



CREATE INDEX "index_match_events_on_match_id" ON "public"."match_events" USING "btree" ("match_id");



CREATE INDEX "index_match_events_on_match_id_and_kind" ON "public"."match_events" USING "btree" ("match_id", "kind");



CREATE UNIQUE INDEX "index_match_events_on_source_id" ON "public"."match_events" USING "btree" ("source_id");



CREATE INDEX "index_match_events_on_team_id" ON "public"."match_events" USING "btree" ("team_id");



CREATE INDEX "index_match_participations_on_athlete_id" ON "public"."match_participations" USING "btree" ("athlete_id");



CREATE INDEX "index_match_participations_on_match_id" ON "public"."match_participations" USING "btree" ("match_id");



CREATE INDEX "index_match_participations_on_match_id_and_status" ON "public"."match_participations" USING "btree" ("match_id", "status");



CREATE UNIQUE INDEX "index_match_participations_on_match_team_athlete" ON "public"."match_participations" USING "btree" ("match_id", "team_id", "athlete_id");



CREATE UNIQUE INDEX "index_match_participations_on_source_id" ON "public"."match_participations" USING "btree" ("source_id");



CREATE INDEX "index_match_participations_on_team_id" ON "public"."match_participations" USING "btree" ("team_id");



CREATE INDEX "index_match_participations_on_team_id_and_status" ON "public"."match_participations" USING "btree" ("team_id", "status");



CREATE UNIQUE INDEX "index_match_reports_on_match_id" ON "public"."match_reports" USING "btree" ("match_id");



CREATE INDEX "index_match_reports_on_referee_id" ON "public"."match_reports" USING "btree" ("referee_id");



CREATE UNIQUE INDEX "index_match_reports_on_source_id" ON "public"."match_reports" USING "btree" ("source_id");



CREATE INDEX "index_match_reports_on_status_and_submitted_at" ON "public"."match_reports" USING "btree" ("status", "submitted_at");



CREATE INDEX "index_matches_on_category_id" ON "public"."matches" USING "btree" ("category_id");



CREATE INDEX "index_matches_on_category_id_and_phase_and_group_key" ON "public"."matches" USING "btree" ("category_id", "phase", "group_key");



CREATE INDEX "index_matches_on_championship_id" ON "public"."matches" USING "btree" ("championship_id");



CREATE INDEX "index_matches_on_championship_id_and_scheduled_on" ON "public"."matches" USING "btree" ("championship_id", "scheduled_on");



CREATE INDEX "index_matches_on_code" ON "public"."matches" USING "btree" ("code");



CREATE UNIQUE INDEX "index_matches_on_source_id" ON "public"."matches" USING "btree" ("source_id");



CREATE INDEX "index_matches_on_team_a_id" ON "public"."matches" USING "btree" ("team_a_id");



CREATE INDEX "index_matches_on_team_b_id" ON "public"."matches" USING "btree" ("team_b_id");



CREATE INDEX "index_matches_on_venue_id" ON "public"."matches" USING "btree" ("venue_id");



CREATE INDEX "index_matches_on_winner_id" ON "public"."matches" USING "btree" ("winner_id");



CREATE INDEX "index_partners_on_category_id" ON "public"."partners" USING "btree" ("category_id");



CREATE INDEX "index_partners_on_championship_id" ON "public"."partners" USING "btree" ("championship_id");



CREATE INDEX "index_partners_on_championship_id_and_status_and_highlight" ON "public"."partners" USING "btree" ("championship_id", "status", "highlight");



CREATE INDEX "index_partners_on_championship_id_and_tier" ON "public"."partners" USING "btree" ("championship_id", "tier");



CREATE UNIQUE INDEX "index_partners_on_source_id" ON "public"."partners" USING "btree" ("source_id");



CREATE INDEX "index_referees_on_championship_id" ON "public"."referees" USING "btree" ("championship_id");



CREATE INDEX "index_referees_on_championship_id_and_status" ON "public"."referees" USING "btree" ("championship_id", "status");



CREATE UNIQUE INDEX "index_referees_on_source_id" ON "public"."referees" USING "btree" ("source_id");



CREATE INDEX "index_round_selection_athletes_on_athlete_id" ON "public"."round_selection_athletes" USING "btree" ("athlete_id");



CREATE INDEX "index_round_selection_athletes_on_round_selection_id" ON "public"."round_selection_athletes" USING "btree" ("round_selection_id");



CREATE INDEX "index_round_selections_on_category_id" ON "public"."round_selections" USING "btree" ("category_id");



CREATE INDEX "index_round_selections_on_championship_id" ON "public"."round_selections" USING "btree" ("championship_id");



CREATE UNIQUE INDEX "index_round_selections_on_scope_and_round" ON "public"."round_selections" USING "btree" ("championship_id", "category_id", "round_number");



CREATE UNIQUE INDEX "index_round_selections_on_source_id" ON "public"."round_selections" USING "btree" ("source_id");



CREATE INDEX "index_solid_queue_batch_executions_on_batch_id" ON "public"."solid_queue_batch_executions" USING "btree" ("batch_id");



CREATE UNIQUE INDEX "index_solid_queue_batch_executions_on_job_id" ON "public"."solid_queue_batch_executions" USING "btree" ("job_id");



CREATE UNIQUE INDEX "index_solid_queue_batches_on_active_job_batch_id" ON "public"."solid_queue_batches" USING "btree" ("active_job_batch_id");



CREATE INDEX "index_solid_queue_batches_on_finished_at" ON "public"."solid_queue_batches" USING "btree" ("finished_at");



CREATE INDEX "index_solid_queue_blocked_executions_for_maintenance" ON "public"."solid_queue_blocked_executions" USING "btree" ("expires_at", "concurrency_key");



CREATE INDEX "index_solid_queue_blocked_executions_for_release" ON "public"."solid_queue_blocked_executions" USING "btree" ("concurrency_key", "priority", "job_id");



CREATE UNIQUE INDEX "index_solid_queue_blocked_executions_on_job_id" ON "public"."solid_queue_blocked_executions" USING "btree" ("job_id");



CREATE UNIQUE INDEX "index_solid_queue_claimed_executions_on_job_id" ON "public"."solid_queue_claimed_executions" USING "btree" ("job_id");



CREATE INDEX "index_solid_queue_claimed_executions_on_process_id_and_job_id" ON "public"."solid_queue_claimed_executions" USING "btree" ("process_id", "job_id");



CREATE INDEX "index_solid_queue_dispatch_all" ON "public"."solid_queue_scheduled_executions" USING "btree" ("scheduled_at", "priority", "job_id");



CREATE UNIQUE INDEX "index_solid_queue_failed_executions_on_job_id" ON "public"."solid_queue_failed_executions" USING "btree" ("job_id");



CREATE INDEX "index_solid_queue_jobs_for_alerting" ON "public"."solid_queue_jobs" USING "btree" ("scheduled_at", "finished_at");



CREATE INDEX "index_solid_queue_jobs_for_filtering" ON "public"."solid_queue_jobs" USING "btree" ("queue_name", "finished_at");



CREATE INDEX "index_solid_queue_jobs_on_active_job_id" ON "public"."solid_queue_jobs" USING "btree" ("active_job_id");



CREATE INDEX "index_solid_queue_jobs_on_batch_id" ON "public"."solid_queue_jobs" USING "btree" ("batch_id");



CREATE INDEX "index_solid_queue_jobs_on_class_name" ON "public"."solid_queue_jobs" USING "btree" ("class_name");



CREATE INDEX "index_solid_queue_jobs_on_finished_at" ON "public"."solid_queue_jobs" USING "btree" ("finished_at");



CREATE UNIQUE INDEX "index_solid_queue_pauses_on_queue_name" ON "public"."solid_queue_pauses" USING "btree" ("queue_name");



CREATE INDEX "index_solid_queue_poll_all" ON "public"."solid_queue_ready_executions" USING "btree" ("priority", "job_id");



CREATE INDEX "index_solid_queue_poll_by_queue" ON "public"."solid_queue_ready_executions" USING "btree" ("queue_name", "priority", "job_id");



CREATE INDEX "index_solid_queue_processes_on_last_heartbeat_at" ON "public"."solid_queue_processes" USING "btree" ("last_heartbeat_at");



CREATE UNIQUE INDEX "index_solid_queue_processes_on_name_and_supervisor_id" ON "public"."solid_queue_processes" USING "btree" ("name", "supervisor_id");



CREATE INDEX "index_solid_queue_processes_on_supervisor_id" ON "public"."solid_queue_processes" USING "btree" ("supervisor_id");



CREATE UNIQUE INDEX "index_solid_queue_ready_executions_on_job_id" ON "public"."solid_queue_ready_executions" USING "btree" ("job_id");



CREATE UNIQUE INDEX "index_solid_queue_recurring_executions_on_job_id" ON "public"."solid_queue_recurring_executions" USING "btree" ("job_id");



CREATE UNIQUE INDEX "index_solid_queue_recurring_executions_on_task_key_and_run_at" ON "public"."solid_queue_recurring_executions" USING "btree" ("task_key", "run_at");



CREATE UNIQUE INDEX "index_solid_queue_recurring_tasks_on_key" ON "public"."solid_queue_recurring_tasks" USING "btree" ("key");



CREATE INDEX "index_solid_queue_recurring_tasks_on_static" ON "public"."solid_queue_recurring_tasks" USING "btree" ("static");



CREATE UNIQUE INDEX "index_solid_queue_scheduled_executions_on_job_id" ON "public"."solid_queue_scheduled_executions" USING "btree" ("job_id");



CREATE INDEX "index_solid_queue_semaphores_on_expires_at" ON "public"."solid_queue_semaphores" USING "btree" ("expires_at");



CREATE UNIQUE INDEX "index_solid_queue_semaphores_on_key" ON "public"."solid_queue_semaphores" USING "btree" ("key");



CREATE INDEX "index_solid_queue_semaphores_on_key_and_value" ON "public"."solid_queue_semaphores" USING "btree" ("key", "value");



CREATE UNIQUE INDEX "index_standing_rows_on_category_group_and_team" ON "public"."standing_rows" USING "btree" ("category_id", "group_key", "team_id");



CREATE INDEX "index_standing_rows_on_category_id" ON "public"."standing_rows" USING "btree" ("category_id");



CREATE INDEX "index_standing_rows_on_championship_id" ON "public"."standing_rows" USING "btree" ("championship_id");



CREATE UNIQUE INDEX "index_standing_rows_on_competition_group_and_position" ON "public"."standing_rows" USING "btree" ("championship_id", "category_id", "group_key", "position");



CREATE INDEX "index_standing_rows_on_team_id" ON "public"."standing_rows" USING "btree" ("team_id");



CREATE INDEX "index_suspensions_on_athlete_id" ON "public"."suspensions" USING "btree" ("athlete_id");



CREATE INDEX "index_suspensions_on_athlete_id_and_status" ON "public"."suspensions" USING "btree" ("athlete_id", "status");



CREATE INDEX "index_suspensions_on_category_id" ON "public"."suspensions" USING "btree" ("category_id");



CREATE INDEX "index_suspensions_on_championship_id" ON "public"."suspensions" USING "btree" ("championship_id");



CREATE INDEX "index_suspensions_on_match_event_id" ON "public"."suspensions" USING "btree" ("match_event_id");



CREATE UNIQUE INDEX "index_suspensions_on_source_id" ON "public"."suspensions" USING "btree" ("source_id");



CREATE INDEX "index_suspensions_on_team_id" ON "public"."suspensions" USING "btree" ("team_id");



CREATE INDEX "index_team_athletes_on_athlete_id" ON "public"."team_athletes" USING "btree" ("athlete_id");



CREATE UNIQUE INDEX "index_team_athletes_on_source_id" ON "public"."team_athletes" USING "btree" ("source_id");



CREATE INDEX "index_team_athletes_on_team_id" ON "public"."team_athletes" USING "btree" ("team_id");



CREATE UNIQUE INDEX "index_team_athletes_on_team_id_and_athlete_id" ON "public"."team_athletes" USING "btree" ("team_id", "athlete_id");



CREATE UNIQUE INDEX "index_team_memberships_on_source_id" ON "public"."team_memberships" USING "btree" ("source_id");



CREATE INDEX "index_team_memberships_on_team_id" ON "public"."team_memberships" USING "btree" ("team_id");



CREATE UNIQUE INDEX "index_team_memberships_on_team_id_and_user_id" ON "public"."team_memberships" USING "btree" ("team_id", "user_id");



CREATE INDEX "index_team_memberships_on_user_id" ON "public"."team_memberships" USING "btree" ("user_id");



CREATE INDEX "index_team_memberships_on_user_id_and_status" ON "public"."team_memberships" USING "btree" ("user_id", "status");



CREATE INDEX "index_teams_on_category_id" ON "public"."teams" USING "btree" ("category_id");



CREATE INDEX "index_teams_on_category_id_and_group_key" ON "public"."teams" USING "btree" ("category_id", "group_key");



CREATE INDEX "index_teams_on_entity_id" ON "public"."teams" USING "btree" ("entity_id");



CREATE INDEX "index_teams_on_entity_id_and_category_id" ON "public"."teams" USING "btree" ("entity_id", "category_id");



CREATE UNIQUE INDEX "index_teams_on_source_id" ON "public"."teams" USING "btree" ("source_id");



CREATE UNIQUE INDEX "index_tranca_class_rows_on_stage_group_and_dupla" ON "public"."tranca_classificacao_rows" USING "btree" ("category_id", "stage_number", "group_key", "tranca_dupla_id");



CREATE UNIQUE INDEX "index_tranca_class_rows_on_stage_scope_position" ON "public"."tranca_classificacao_rows" USING "btree" ("championship_id", "category_id", "stage_number", "group_key", "position");



CREATE INDEX "index_tranca_classificacao_rows_on_category_id" ON "public"."tranca_classificacao_rows" USING "btree" ("category_id");



CREATE INDEX "index_tranca_classificacao_rows_on_championship_id" ON "public"."tranca_classificacao_rows" USING "btree" ("championship_id");



CREATE UNIQUE INDEX "index_tranca_classificacao_rows_on_source_id" ON "public"."tranca_classificacao_rows" USING "btree" ("source_id");



CREATE INDEX "index_tranca_classificacao_rows_on_tranca_dupla_id" ON "public"."tranca_classificacao_rows" USING "btree" ("tranca_dupla_id");



CREATE INDEX "index_tranca_dupla_memberships_on_athlete_id" ON "public"."tranca_dupla_memberships" USING "btree" ("athlete_id");



CREATE UNIQUE INDEX "index_tranca_dupla_memberships_on_dupla_and_athlete" ON "public"."tranca_dupla_memberships" USING "btree" ("tranca_dupla_id", "athlete_id");



CREATE UNIQUE INDEX "index_tranca_dupla_memberships_on_source_id" ON "public"."tranca_dupla_memberships" USING "btree" ("source_id");



CREATE INDEX "index_tranca_dupla_memberships_on_tranca_dupla_id" ON "public"."tranca_dupla_memberships" USING "btree" ("tranca_dupla_id");



CREATE INDEX "index_tranca_duplas_on_category_id" ON "public"."tranca_duplas" USING "btree" ("category_id");



CREATE INDEX "index_tranca_duplas_on_championship_id" ON "public"."tranca_duplas" USING "btree" ("championship_id");



CREATE INDEX "index_tranca_duplas_on_entity_id" ON "public"."tranca_duplas" USING "btree" ("entity_id");



CREATE UNIQUE INDEX "index_tranca_duplas_on_scope_and_name" ON "public"."tranca_duplas" USING "btree" ("championship_id", "category_id", "name");



CREATE UNIQUE INDEX "index_tranca_duplas_on_source_id" ON "public"."tranca_duplas" USING "btree" ("source_id");



CREATE INDEX "index_tranca_duplas_on_status" ON "public"."tranca_duplas" USING "btree" ("status");



CREATE INDEX "index_tranca_mesas_on_championship_id" ON "public"."tranca_mesas" USING "btree" ("championship_id");



CREATE UNIQUE INDEX "index_tranca_mesas_on_scope_and_code" ON "public"."tranca_mesas" USING "btree" ("championship_id", "code");



CREATE UNIQUE INDEX "index_tranca_mesas_on_source_id" ON "public"."tranca_mesas" USING "btree" ("source_id");



CREATE INDEX "index_tranca_mesas_on_tranca_rodada_id" ON "public"."tranca_mesas" USING "btree" ("tranca_rodada_id");



CREATE INDEX "index_tranca_partida_maos_on_championship_id" ON "public"."tranca_partida_maos" USING "btree" ("championship_id");



CREATE UNIQUE INDEX "index_tranca_partida_maos_on_partida_and_numero" ON "public"."tranca_partida_maos" USING "btree" ("tranca_partida_id", "numero");



CREATE INDEX "index_tranca_partida_maos_on_scope" ON "public"."tranca_partida_maos" USING "btree" ("championship_id", "tranca_partida_id");



CREATE UNIQUE INDEX "index_tranca_partida_maos_on_source_id" ON "public"."tranca_partida_maos" USING "btree" ("source_id");



CREATE INDEX "index_tranca_partida_maos_on_tranca_partida_id" ON "public"."tranca_partida_maos" USING "btree" ("tranca_partida_id");



CREATE INDEX "index_tranca_partidas_on_category_id" ON "public"."tranca_partidas" USING "btree" ("category_id");



CREATE INDEX "index_tranca_partidas_on_championship_and_date" ON "public"."tranca_partidas" USING "btree" ("championship_id", "scheduled_on");



CREATE INDEX "index_tranca_partidas_on_championship_id" ON "public"."tranca_partidas" USING "btree" ("championship_id");



CREATE INDEX "index_tranca_partidas_on_dupla_a_id" ON "public"."tranca_partidas" USING "btree" ("dupla_a_id");



CREATE INDEX "index_tranca_partidas_on_dupla_b_id" ON "public"."tranca_partidas" USING "btree" ("dupla_b_id");



CREATE UNIQUE INDEX "index_tranca_partidas_on_source_id" ON "public"."tranca_partidas" USING "btree" ("source_id");



CREATE INDEX "index_tranca_partidas_on_stage_scope_phase_round" ON "public"."tranca_partidas" USING "btree" ("championship_id", "stage_number", "phase", "round_number");



CREATE INDEX "index_tranca_partidas_on_tranca_mesa_id" ON "public"."tranca_partidas" USING "btree" ("tranca_mesa_id");



CREATE INDEX "index_tranca_partidas_on_tranca_rodada_id" ON "public"."tranca_partidas" USING "btree" ("tranca_rodada_id");



CREATE INDEX "index_tranca_partidas_on_winner_id" ON "public"."tranca_partidas" USING "btree" ("winner_id");



CREATE INDEX "index_tranca_rodadas_on_championship_id" ON "public"."tranca_rodadas" USING "btree" ("championship_id");



CREATE UNIQUE INDEX "index_tranca_rodadas_on_source_id" ON "public"."tranca_rodadas" USING "btree" ("source_id");



CREATE UNIQUE INDEX "index_tranca_rodadas_on_stage_scope_and_round" ON "public"."tranca_rodadas" USING "btree" ("championship_id", "stage_number", "phase", "round_number");



CREATE UNIQUE INDEX "index_tranca_settings_on_championship_id" ON "public"."tranca_settings" USING "btree" ("championship_id");



CREATE UNIQUE INDEX "index_tranca_settings_on_source_id" ON "public"."tranca_settings" USING "btree" ("source_id");



CREATE UNIQUE INDEX "index_users_on_email" ON "public"."users" USING "btree" ("email");



CREATE INDEX "index_users_on_preferred_theme" ON "public"."users" USING "btree" ("preferred_theme");



CREATE UNIQUE INDEX "index_users_on_reset_password_token" ON "public"."users" USING "btree" ("reset_password_token");



CREATE INDEX "index_users_on_role" ON "public"."users" USING "btree" ("role");



CREATE INDEX "index_venues_on_championship_id" ON "public"."venues" USING "btree" ("championship_id");



CREATE INDEX "index_venues_on_championship_id_and_status" ON "public"."venues" USING "btree" ("championship_id", "status");



CREATE UNIQUE INDEX "index_venues_on_source_id" ON "public"."venues" USING "btree" ("source_id");



CREATE INDEX "user_index" ON "public"."audits" USING "btree" ("user_id", "user_type");



ALTER TABLE ONLY "public"."suspensions"
    ADD CONSTRAINT "fk_rails_035f2d3365" FOREIGN KEY ("championship_id") REFERENCES "public"."championships"("id");



ALTER TABLE ONLY "public"."tranca_duplas"
    ADD CONSTRAINT "fk_rails_0cb9f98ab5" FOREIGN KEY ("entity_id") REFERENCES "public"."entities"("id");



ALTER TABLE ONLY "public"."invoices"
    ADD CONSTRAINT "fk_rails_0dcd6cec29" FOREIGN KEY ("category_id") REFERENCES "public"."categories"("id");



ALTER TABLE ONLY "public"."matches"
    ADD CONSTRAINT "fk_rails_11dd75bc5a" FOREIGN KEY ("team_b_id") REFERENCES "public"."teams"("id");



ALTER TABLE ONLY "public"."tranca_duplas"
    ADD CONSTRAINT "fk_rails_13b7549e06" FOREIGN KEY ("category_id") REFERENCES "public"."categories"("id");



ALTER TABLE ONLY "public"."tranca_mesas"
    ADD CONSTRAINT "fk_rails_156c7a24ce" FOREIGN KEY ("championship_id") REFERENCES "public"."championships"("id");



ALTER TABLE ONLY "public"."suspensions"
    ADD CONSTRAINT "fk_rails_1f3f5f11ec" FOREIGN KEY ("category_id") REFERENCES "public"."categories"("id");



ALTER TABLE ONLY "public"."partners"
    ADD CONSTRAINT "fk_rails_24147e97df" FOREIGN KEY ("category_id") REFERENCES "public"."categories"("id");



ALTER TABLE ONLY "public"."tranca_dupla_memberships"
    ADD CONSTRAINT "fk_rails_2fbc4ed709" FOREIGN KEY ("athlete_id") REFERENCES "public"."athletes"("id");



ALTER TABLE ONLY "public"."solid_queue_recurring_executions"
    ADD CONSTRAINT "fk_rails_318a5533ed" FOREIGN KEY ("job_id") REFERENCES "public"."solid_queue_jobs"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."round_selection_athletes"
    ADD CONSTRAINT "fk_rails_32aedc5b76" FOREIGN KEY ("round_selection_id") REFERENCES "public"."round_selections"("id");



ALTER TABLE ONLY "public"."teams"
    ADD CONSTRAINT "fk_rails_357b71e9bb" FOREIGN KEY ("entity_id") REFERENCES "public"."entities"("id");



ALTER TABLE ONLY "public"."match_reports"
    ADD CONSTRAINT "fk_rails_388600c742" FOREIGN KEY ("match_id") REFERENCES "public"."matches"("id");



ALTER TABLE ONLY "public"."solid_queue_failed_executions"
    ADD CONSTRAINT "fk_rails_39bbc7a631" FOREIGN KEY ("job_id") REFERENCES "public"."solid_queue_jobs"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."tranca_mesas"
    ADD CONSTRAINT "fk_rails_3a5f373f97" FOREIGN KEY ("tranca_rodada_id") REFERENCES "public"."tranca_rodadas"("id");



ALTER TABLE ONLY "public"."matches"
    ADD CONSTRAINT "fk_rails_3d74062101" FOREIGN KEY ("category_id") REFERENCES "public"."categories"("id");



ALTER TABLE ONLY "public"."tranca_rodadas"
    ADD CONSTRAINT "fk_rails_4196788361" FOREIGN KEY ("championship_id") REFERENCES "public"."championships"("id");



ALTER TABLE ONLY "public"."team_athletes"
    ADD CONSTRAINT "fk_rails_47df157c51" FOREIGN KEY ("athlete_id") REFERENCES "public"."athletes"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."venues"
    ADD CONSTRAINT "fk_rails_4a6c5832d2" FOREIGN KEY ("championship_id") REFERENCES "public"."championships"("id");



ALTER TABLE ONLY "public"."solid_queue_blocked_executions"
    ADD CONSTRAINT "fk_rails_4cd34e2228" FOREIGN KEY ("job_id") REFERENCES "public"."solid_queue_jobs"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."athletes"
    ADD CONSTRAINT "fk_rails_5591d399b9" FOREIGN KEY ("category_id") REFERENCES "public"."categories"("id");



ALTER TABLE ONLY "public"."suspensions"
    ADD CONSTRAINT "fk_rails_572806ed18" FOREIGN KEY ("athlete_id") REFERENCES "public"."athletes"("id");



ALTER TABLE ONLY "public"."round_selections"
    ADD CONSTRAINT "fk_rails_57a206f9e4" FOREIGN KEY ("category_id") REFERENCES "public"."categories"("id");



ALTER TABLE ONLY "public"."team_memberships"
    ADD CONSTRAINT "fk_rails_5aba9331a7" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id");



ALTER TABLE ONLY "public"."standing_rows"
    ADD CONSTRAINT "fk_rails_615f610b9f" FOREIGN KEY ("championship_id") REFERENCES "public"."championships"("id");



ALTER TABLE ONLY "public"."team_memberships"
    ADD CONSTRAINT "fk_rails_61c29b529e" FOREIGN KEY ("team_id") REFERENCES "public"."teams"("id");



ALTER TABLE ONLY "public"."tranca_partidas"
    ADD CONSTRAINT "fk_rails_6247794b22" FOREIGN KEY ("championship_id") REFERENCES "public"."championships"("id");



ALTER TABLE ONLY "public"."match_events"
    ADD CONSTRAINT "fk_rails_690dcfef23" FOREIGN KEY ("match_id") REFERENCES "public"."matches"("id");



ALTER TABLE ONLY "public"."matches"
    ADD CONSTRAINT "fk_rails_6f393bbe16" FOREIGN KEY ("venue_id") REFERENCES "public"."venues"("id");



ALTER TABLE ONLY "public"."tranca_partidas"
    ADD CONSTRAINT "fk_rails_7625a281c1" FOREIGN KEY ("tranca_rodada_id") REFERENCES "public"."tranca_rodadas"("id");



ALTER TABLE ONLY "public"."tranca_partidas"
    ADD CONSTRAINT "fk_rails_76aaf44735" FOREIGN KEY ("dupla_a_id") REFERENCES "public"."tranca_duplas"("id");



ALTER TABLE ONLY "public"."invoices"
    ADD CONSTRAINT "fk_rails_76b0290097" FOREIGN KEY ("championship_id") REFERENCES "public"."championships"("id");



ALTER TABLE ONLY "public"."solid_queue_batch_executions"
    ADD CONSTRAINT "fk_rails_7c5e073422" FOREIGN KEY ("batch_id") REFERENCES "public"."solid_queue_batches"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."tranca_duplas"
    ADD CONSTRAINT "fk_rails_7fe8f9b738" FOREIGN KEY ("championship_id") REFERENCES "public"."championships"("id");



ALTER TABLE ONLY "public"."suspensions"
    ADD CONSTRAINT "fk_rails_80112af988" FOREIGN KEY ("match_event_id") REFERENCES "public"."match_events"("id");



ALTER TABLE ONLY "public"."solid_queue_ready_executions"
    ADD CONSTRAINT "fk_rails_81fcbd66af" FOREIGN KEY ("job_id") REFERENCES "public"."solid_queue_jobs"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."referees"
    ADD CONSTRAINT "fk_rails_847922ff87" FOREIGN KEY ("championship_id") REFERENCES "public"."championships"("id");



ALTER TABLE ONLY "public"."athletes"
    ADD CONSTRAINT "fk_rails_850341c714" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id");



ALTER TABLE ONLY "public"."matches"
    ADD CONSTRAINT "fk_rails_88dd88676e" FOREIGN KEY ("championship_id") REFERENCES "public"."championships"("id");



ALTER TABLE ONLY "public"."tranca_partidas"
    ADD CONSTRAINT "fk_rails_8bf48033c3" FOREIGN KEY ("tranca_mesa_id") REFERENCES "public"."tranca_mesas"("id");



ALTER TABLE ONLY "public"."suspensions"
    ADD CONSTRAINT "fk_rails_8e2e7461da" FOREIGN KEY ("team_id") REFERENCES "public"."teams"("id");



ALTER TABLE ONLY "public"."matches"
    ADD CONSTRAINT "fk_rails_93b5616a8c" FOREIGN KEY ("team_a_id") REFERENCES "public"."teams"("id");



ALTER TABLE ONLY "public"."tranca_partidas"
    ADD CONSTRAINT "fk_rails_983946bab4" FOREIGN KEY ("category_id") REFERENCES "public"."categories"("id");



ALTER TABLE ONLY "public"."active_storage_variant_records"
    ADD CONSTRAINT "fk_rails_993965df05" FOREIGN KEY ("blob_id") REFERENCES "public"."active_storage_blobs"("id");



ALTER TABLE ONLY "public"."match_participations"
    ADD CONSTRAINT "fk_rails_9af15d9a89" FOREIGN KEY ("match_id") REFERENCES "public"."matches"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."solid_queue_claimed_executions"
    ADD CONSTRAINT "fk_rails_9cfe4d4944" FOREIGN KEY ("job_id") REFERENCES "public"."solid_queue_jobs"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."matches"
    ADD CONSTRAINT "fk_rails_9d0deeb219" FOREIGN KEY ("winner_id") REFERENCES "public"."teams"("id");



ALTER TABLE ONLY "public"."championship_categories"
    ADD CONSTRAINT "fk_rails_9e444e8f18" FOREIGN KEY ("championship_id") REFERENCES "public"."championships"("id");



ALTER TABLE ONLY "public"."tranca_partida_maos"
    ADD CONSTRAINT "fk_rails_a132b9eba7" FOREIGN KEY ("tranca_partida_id") REFERENCES "public"."tranca_partidas"("id");



ALTER TABLE ONLY "public"."match_events"
    ADD CONSTRAINT "fk_rails_a61c27bccb" FOREIGN KEY ("athlete_id") REFERENCES "public"."athletes"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."invoices"
    ADD CONSTRAINT "fk_rails_a974bf3d8a" FOREIGN KEY ("entity_id") REFERENCES "public"."entities"("id");



ALTER TABLE ONLY "public"."tranca_partidas"
    ADD CONSTRAINT "fk_rails_ac1e0ff636" FOREIGN KEY ("dupla_b_id") REFERENCES "public"."tranca_duplas"("id");



ALTER TABLE ONLY "public"."tranca_partida_maos"
    ADD CONSTRAINT "fk_rails_ad52f36d7c" FOREIGN KEY ("championship_id") REFERENCES "public"."championships"("id");



ALTER TABLE ONLY "public"."match_events"
    ADD CONSTRAINT "fk_rails_ae570b0525" FOREIGN KEY ("team_id") REFERENCES "public"."teams"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."tranca_classificacao_rows"
    ADD CONSTRAINT "fk_rails_b08a9fe419" FOREIGN KEY ("category_id") REFERENCES "public"."categories"("id");



ALTER TABLE ONLY "public"."match_participations"
    ADD CONSTRAINT "fk_rails_b34f7f965e" FOREIGN KEY ("athlete_id") REFERENCES "public"."athletes"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."round_selection_athletes"
    ADD CONSTRAINT "fk_rails_b924bbe750" FOREIGN KEY ("athlete_id") REFERENCES "public"."athletes"("id");



ALTER TABLE ONLY "public"."tranca_settings"
    ADD CONSTRAINT "fk_rails_b93b984a43" FOREIGN KEY ("championship_id") REFERENCES "public"."championships"("id");



ALTER TABLE ONLY "public"."solid_queue_batch_executions"
    ADD CONSTRAINT "fk_rails_bc9f981155" FOREIGN KEY ("job_id") REFERENCES "public"."solid_queue_jobs"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."categories"
    ADD CONSTRAINT "fk_rails_bd499a80cb" FOREIGN KEY ("championship_id") REFERENCES "public"."championships"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."tranca_classificacao_rows"
    ADD CONSTRAINT "fk_rails_be4be0bd46" FOREIGN KEY ("championship_id") REFERENCES "public"."championships"("id");



ALTER TABLE ONLY "public"."tranca_dupla_memberships"
    ADD CONSTRAINT "fk_rails_c001c9f64e" FOREIGN KEY ("tranca_dupla_id") REFERENCES "public"."tranca_duplas"("id");



ALTER TABLE ONLY "public"."active_storage_attachments"
    ADD CONSTRAINT "fk_rails_c3b3935057" FOREIGN KEY ("blob_id") REFERENCES "public"."active_storage_blobs"("id");



ALTER TABLE ONLY "public"."solid_queue_scheduled_executions"
    ADD CONSTRAINT "fk_rails_c4316f352d" FOREIGN KEY ("job_id") REFERENCES "public"."solid_queue_jobs"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."match_participations"
    ADD CONSTRAINT "fk_rails_c5085a551d" FOREIGN KEY ("team_id") REFERENCES "public"."teams"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."team_athletes"
    ADD CONSTRAINT "fk_rails_cb95cd8d72" FOREIGN KEY ("team_id") REFERENCES "public"."teams"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."tranca_classificacao_rows"
    ADD CONSTRAINT "fk_rails_d531c3664a" FOREIGN KEY ("tranca_dupla_id") REFERENCES "public"."tranca_duplas"("id");



ALTER TABLE ONLY "public"."athletes"
    ADD CONSTRAINT "fk_rails_de29630229" FOREIGN KEY ("team_id") REFERENCES "public"."teams"("id");



ALTER TABLE ONLY "public"."championship_categories"
    ADD CONSTRAINT "fk_rails_e6376d63be" FOREIGN KEY ("category_id") REFERENCES "public"."categories"("id");



ALTER TABLE ONLY "public"."match_reports"
    ADD CONSTRAINT "fk_rails_e8aae22505" FOREIGN KEY ("referee_id") REFERENCES "public"."referees"("id");



ALTER TABLE ONLY "public"."championship_memberships"
    ADD CONSTRAINT "fk_rails_eb91289142" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id");



ALTER TABLE ONLY "public"."round_selections"
    ADD CONSTRAINT "fk_rails_f105b39dbc" FOREIGN KEY ("championship_id") REFERENCES "public"."championships"("id");



ALTER TABLE ONLY "public"."tranca_partidas"
    ADD CONSTRAINT "fk_rails_f13158e6ad" FOREIGN KEY ("winner_id") REFERENCES "public"."tranca_duplas"("id");



ALTER TABLE ONLY "public"."championship_memberships"
    ADD CONSTRAINT "fk_rails_f14c5907eb" FOREIGN KEY ("championship_id") REFERENCES "public"."championships"("id");



ALTER TABLE ONLY "public"."standing_rows"
    ADD CONSTRAINT "fk_rails_f2b68e9f1b" FOREIGN KEY ("team_id") REFERENCES "public"."teams"("id");



ALTER TABLE ONLY "public"."teams"
    ADD CONSTRAINT "fk_rails_f303df3bce" FOREIGN KEY ("category_id") REFERENCES "public"."categories"("id");



ALTER TABLE ONLY "public"."standing_rows"
    ADD CONSTRAINT "fk_rails_f68f6c68fb" FOREIGN KEY ("category_id") REFERENCES "public"."categories"("id");



ALTER TABLE ONLY "public"."match_events"
    ADD CONSTRAINT "fk_rails_f805040078" FOREIGN KEY ("championship_id") REFERENCES "public"."championships"("id");



ALTER TABLE ONLY "public"."partners"
    ADD CONSTRAINT "fk_rails_fbbdc6b7f5" FOREIGN KEY ("championship_id") REFERENCES "public"."championships"("id");





ALTER PUBLICATION "supabase_realtime" OWNER TO "postgres";


GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";





































































































































































GRANT ALL ON TABLE "public"."active_storage_attachments" TO "anon";
GRANT ALL ON TABLE "public"."active_storage_attachments" TO "authenticated";
GRANT ALL ON TABLE "public"."active_storage_attachments" TO "service_role";



GRANT ALL ON SEQUENCE "public"."active_storage_attachments_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."active_storage_attachments_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."active_storage_attachments_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."active_storage_blobs" TO "anon";
GRANT ALL ON TABLE "public"."active_storage_blobs" TO "authenticated";
GRANT ALL ON TABLE "public"."active_storage_blobs" TO "service_role";



GRANT ALL ON SEQUENCE "public"."active_storage_blobs_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."active_storage_blobs_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."active_storage_blobs_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."active_storage_variant_records" TO "anon";
GRANT ALL ON TABLE "public"."active_storage_variant_records" TO "authenticated";
GRANT ALL ON TABLE "public"."active_storage_variant_records" TO "service_role";



GRANT ALL ON SEQUENCE "public"."active_storage_variant_records_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."active_storage_variant_records_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."active_storage_variant_records_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."ar_internal_metadata" TO "anon";
GRANT ALL ON TABLE "public"."ar_internal_metadata" TO "authenticated";
GRANT ALL ON TABLE "public"."ar_internal_metadata" TO "service_role";



GRANT ALL ON TABLE "public"."athletes" TO "anon";
GRANT ALL ON TABLE "public"."athletes" TO "authenticated";
GRANT ALL ON TABLE "public"."athletes" TO "service_role";



GRANT ALL ON SEQUENCE "public"."athletes_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."athletes_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."athletes_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."audits" TO "anon";
GRANT ALL ON TABLE "public"."audits" TO "authenticated";
GRANT ALL ON TABLE "public"."audits" TO "service_role";



GRANT ALL ON SEQUENCE "public"."audits_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."audits_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."audits_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."categories" TO "anon";
GRANT ALL ON TABLE "public"."categories" TO "authenticated";
GRANT ALL ON TABLE "public"."categories" TO "service_role";



GRANT ALL ON SEQUENCE "public"."categories_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."categories_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."categories_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."championship_categories" TO "anon";
GRANT ALL ON TABLE "public"."championship_categories" TO "authenticated";
GRANT ALL ON TABLE "public"."championship_categories" TO "service_role";



GRANT ALL ON SEQUENCE "public"."championship_categories_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."championship_categories_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."championship_categories_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."championship_memberships" TO "anon";
GRANT ALL ON TABLE "public"."championship_memberships" TO "authenticated";
GRANT ALL ON TABLE "public"."championship_memberships" TO "service_role";



GRANT ALL ON SEQUENCE "public"."championship_memberships_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."championship_memberships_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."championship_memberships_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."championships" TO "anon";
GRANT ALL ON TABLE "public"."championships" TO "authenticated";
GRANT ALL ON TABLE "public"."championships" TO "service_role";



GRANT ALL ON SEQUENCE "public"."championships_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."championships_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."championships_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."entities" TO "anon";
GRANT ALL ON TABLE "public"."entities" TO "authenticated";
GRANT ALL ON TABLE "public"."entities" TO "service_role";



GRANT ALL ON SEQUENCE "public"."entities_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."entities_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."entities_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."invoices" TO "anon";
GRANT ALL ON TABLE "public"."invoices" TO "authenticated";
GRANT ALL ON TABLE "public"."invoices" TO "service_role";



GRANT ALL ON SEQUENCE "public"."invoices_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."invoices_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."invoices_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."match_events" TO "anon";
GRANT ALL ON TABLE "public"."match_events" TO "authenticated";
GRANT ALL ON TABLE "public"."match_events" TO "service_role";



GRANT ALL ON SEQUENCE "public"."match_events_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."match_events_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."match_events_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."match_participations" TO "anon";
GRANT ALL ON TABLE "public"."match_participations" TO "authenticated";
GRANT ALL ON TABLE "public"."match_participations" TO "service_role";



GRANT ALL ON SEQUENCE "public"."match_participations_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."match_participations_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."match_participations_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."match_reports" TO "anon";
GRANT ALL ON TABLE "public"."match_reports" TO "authenticated";
GRANT ALL ON TABLE "public"."match_reports" TO "service_role";



GRANT ALL ON SEQUENCE "public"."match_reports_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."match_reports_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."match_reports_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."matches" TO "anon";
GRANT ALL ON TABLE "public"."matches" TO "authenticated";
GRANT ALL ON TABLE "public"."matches" TO "service_role";



GRANT ALL ON SEQUENCE "public"."matches_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."matches_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."matches_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."partners" TO "anon";
GRANT ALL ON TABLE "public"."partners" TO "authenticated";
GRANT ALL ON TABLE "public"."partners" TO "service_role";



GRANT ALL ON SEQUENCE "public"."partners_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."partners_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."partners_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."referees" TO "anon";
GRANT ALL ON TABLE "public"."referees" TO "authenticated";
GRANT ALL ON TABLE "public"."referees" TO "service_role";



GRANT ALL ON SEQUENCE "public"."referees_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."referees_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."referees_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."round_selection_athletes" TO "anon";
GRANT ALL ON TABLE "public"."round_selection_athletes" TO "authenticated";
GRANT ALL ON TABLE "public"."round_selection_athletes" TO "service_role";



GRANT ALL ON SEQUENCE "public"."round_selection_athletes_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."round_selection_athletes_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."round_selection_athletes_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."round_selections" TO "anon";
GRANT ALL ON TABLE "public"."round_selections" TO "authenticated";
GRANT ALL ON TABLE "public"."round_selections" TO "service_role";



GRANT ALL ON SEQUENCE "public"."round_selections_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."round_selections_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."round_selections_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."schema_migrations" TO "anon";
GRANT ALL ON TABLE "public"."schema_migrations" TO "authenticated";
GRANT ALL ON TABLE "public"."schema_migrations" TO "service_role";



GRANT ALL ON TABLE "public"."solid_queue_batch_executions" TO "anon";
GRANT ALL ON TABLE "public"."solid_queue_batch_executions" TO "authenticated";
GRANT ALL ON TABLE "public"."solid_queue_batch_executions" TO "service_role";



GRANT ALL ON SEQUENCE "public"."solid_queue_batch_executions_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."solid_queue_batch_executions_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."solid_queue_batch_executions_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."solid_queue_batches" TO "anon";
GRANT ALL ON TABLE "public"."solid_queue_batches" TO "authenticated";
GRANT ALL ON TABLE "public"."solid_queue_batches" TO "service_role";



GRANT ALL ON SEQUENCE "public"."solid_queue_batches_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."solid_queue_batches_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."solid_queue_batches_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."solid_queue_blocked_executions" TO "anon";
GRANT ALL ON TABLE "public"."solid_queue_blocked_executions" TO "authenticated";
GRANT ALL ON TABLE "public"."solid_queue_blocked_executions" TO "service_role";



GRANT ALL ON SEQUENCE "public"."solid_queue_blocked_executions_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."solid_queue_blocked_executions_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."solid_queue_blocked_executions_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."solid_queue_claimed_executions" TO "anon";
GRANT ALL ON TABLE "public"."solid_queue_claimed_executions" TO "authenticated";
GRANT ALL ON TABLE "public"."solid_queue_claimed_executions" TO "service_role";



GRANT ALL ON SEQUENCE "public"."solid_queue_claimed_executions_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."solid_queue_claimed_executions_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."solid_queue_claimed_executions_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."solid_queue_failed_executions" TO "anon";
GRANT ALL ON TABLE "public"."solid_queue_failed_executions" TO "authenticated";
GRANT ALL ON TABLE "public"."solid_queue_failed_executions" TO "service_role";



GRANT ALL ON SEQUENCE "public"."solid_queue_failed_executions_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."solid_queue_failed_executions_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."solid_queue_failed_executions_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."solid_queue_jobs" TO "anon";
GRANT ALL ON TABLE "public"."solid_queue_jobs" TO "authenticated";
GRANT ALL ON TABLE "public"."solid_queue_jobs" TO "service_role";



GRANT ALL ON SEQUENCE "public"."solid_queue_jobs_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."solid_queue_jobs_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."solid_queue_jobs_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."solid_queue_pauses" TO "anon";
GRANT ALL ON TABLE "public"."solid_queue_pauses" TO "authenticated";
GRANT ALL ON TABLE "public"."solid_queue_pauses" TO "service_role";



GRANT ALL ON SEQUENCE "public"."solid_queue_pauses_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."solid_queue_pauses_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."solid_queue_pauses_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."solid_queue_processes" TO "anon";
GRANT ALL ON TABLE "public"."solid_queue_processes" TO "authenticated";
GRANT ALL ON TABLE "public"."solid_queue_processes" TO "service_role";



GRANT ALL ON SEQUENCE "public"."solid_queue_processes_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."solid_queue_processes_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."solid_queue_processes_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."solid_queue_ready_executions" TO "anon";
GRANT ALL ON TABLE "public"."solid_queue_ready_executions" TO "authenticated";
GRANT ALL ON TABLE "public"."solid_queue_ready_executions" TO "service_role";



GRANT ALL ON SEQUENCE "public"."solid_queue_ready_executions_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."solid_queue_ready_executions_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."solid_queue_ready_executions_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."solid_queue_recurring_executions" TO "anon";
GRANT ALL ON TABLE "public"."solid_queue_recurring_executions" TO "authenticated";
GRANT ALL ON TABLE "public"."solid_queue_recurring_executions" TO "service_role";



GRANT ALL ON SEQUENCE "public"."solid_queue_recurring_executions_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."solid_queue_recurring_executions_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."solid_queue_recurring_executions_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."solid_queue_recurring_tasks" TO "anon";
GRANT ALL ON TABLE "public"."solid_queue_recurring_tasks" TO "authenticated";
GRANT ALL ON TABLE "public"."solid_queue_recurring_tasks" TO "service_role";



GRANT ALL ON SEQUENCE "public"."solid_queue_recurring_tasks_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."solid_queue_recurring_tasks_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."solid_queue_recurring_tasks_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."solid_queue_scheduled_executions" TO "anon";
GRANT ALL ON TABLE "public"."solid_queue_scheduled_executions" TO "authenticated";
GRANT ALL ON TABLE "public"."solid_queue_scheduled_executions" TO "service_role";



GRANT ALL ON SEQUENCE "public"."solid_queue_scheduled_executions_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."solid_queue_scheduled_executions_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."solid_queue_scheduled_executions_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."solid_queue_semaphores" TO "anon";
GRANT ALL ON TABLE "public"."solid_queue_semaphores" TO "authenticated";
GRANT ALL ON TABLE "public"."solid_queue_semaphores" TO "service_role";



GRANT ALL ON SEQUENCE "public"."solid_queue_semaphores_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."solid_queue_semaphores_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."solid_queue_semaphores_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."standing_rows" TO "anon";
GRANT ALL ON TABLE "public"."standing_rows" TO "authenticated";
GRANT ALL ON TABLE "public"."standing_rows" TO "service_role";



GRANT ALL ON SEQUENCE "public"."standing_rows_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."standing_rows_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."standing_rows_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."suspensions" TO "anon";
GRANT ALL ON TABLE "public"."suspensions" TO "authenticated";
GRANT ALL ON TABLE "public"."suspensions" TO "service_role";



GRANT ALL ON SEQUENCE "public"."suspensions_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."suspensions_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."suspensions_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."team_athletes" TO "anon";
GRANT ALL ON TABLE "public"."team_athletes" TO "authenticated";
GRANT ALL ON TABLE "public"."team_athletes" TO "service_role";



GRANT ALL ON SEQUENCE "public"."team_athletes_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."team_athletes_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."team_athletes_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."team_memberships" TO "anon";
GRANT ALL ON TABLE "public"."team_memberships" TO "authenticated";
GRANT ALL ON TABLE "public"."team_memberships" TO "service_role";



GRANT ALL ON SEQUENCE "public"."team_memberships_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."team_memberships_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."team_memberships_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."teams" TO "anon";
GRANT ALL ON TABLE "public"."teams" TO "authenticated";
GRANT ALL ON TABLE "public"."teams" TO "service_role";



GRANT ALL ON SEQUENCE "public"."teams_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."teams_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."teams_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."tranca_classificacao_rows" TO "anon";
GRANT ALL ON TABLE "public"."tranca_classificacao_rows" TO "authenticated";
GRANT ALL ON TABLE "public"."tranca_classificacao_rows" TO "service_role";



GRANT ALL ON SEQUENCE "public"."tranca_classificacao_rows_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."tranca_classificacao_rows_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."tranca_classificacao_rows_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."tranca_dupla_memberships" TO "anon";
GRANT ALL ON TABLE "public"."tranca_dupla_memberships" TO "authenticated";
GRANT ALL ON TABLE "public"."tranca_dupla_memberships" TO "service_role";



GRANT ALL ON SEQUENCE "public"."tranca_dupla_memberships_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."tranca_dupla_memberships_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."tranca_dupla_memberships_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."tranca_duplas" TO "anon";
GRANT ALL ON TABLE "public"."tranca_duplas" TO "authenticated";
GRANT ALL ON TABLE "public"."tranca_duplas" TO "service_role";



GRANT ALL ON SEQUENCE "public"."tranca_duplas_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."tranca_duplas_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."tranca_duplas_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."tranca_mesas" TO "anon";
GRANT ALL ON TABLE "public"."tranca_mesas" TO "authenticated";
GRANT ALL ON TABLE "public"."tranca_mesas" TO "service_role";



GRANT ALL ON SEQUENCE "public"."tranca_mesas_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."tranca_mesas_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."tranca_mesas_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."tranca_partida_maos" TO "anon";
GRANT ALL ON TABLE "public"."tranca_partida_maos" TO "authenticated";
GRANT ALL ON TABLE "public"."tranca_partida_maos" TO "service_role";



GRANT ALL ON SEQUENCE "public"."tranca_partida_maos_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."tranca_partida_maos_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."tranca_partida_maos_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."tranca_partidas" TO "anon";
GRANT ALL ON TABLE "public"."tranca_partidas" TO "authenticated";
GRANT ALL ON TABLE "public"."tranca_partidas" TO "service_role";



GRANT ALL ON SEQUENCE "public"."tranca_partidas_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."tranca_partidas_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."tranca_partidas_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."tranca_rodadas" TO "anon";
GRANT ALL ON TABLE "public"."tranca_rodadas" TO "authenticated";
GRANT ALL ON TABLE "public"."tranca_rodadas" TO "service_role";



GRANT ALL ON SEQUENCE "public"."tranca_rodadas_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."tranca_rodadas_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."tranca_rodadas_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."tranca_settings" TO "anon";
GRANT ALL ON TABLE "public"."tranca_settings" TO "authenticated";
GRANT ALL ON TABLE "public"."tranca_settings" TO "service_role";



GRANT ALL ON SEQUENCE "public"."tranca_settings_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."tranca_settings_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."tranca_settings_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."users" TO "anon";
GRANT ALL ON TABLE "public"."users" TO "authenticated";
GRANT ALL ON TABLE "public"."users" TO "service_role";



GRANT ALL ON SEQUENCE "public"."users_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."users_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."users_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."venues" TO "anon";
GRANT ALL ON TABLE "public"."venues" TO "authenticated";
GRANT ALL ON TABLE "public"."venues" TO "service_role";



GRANT ALL ON SEQUENCE "public"."venues_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."venues_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."venues_id_seq" TO "service_role";









ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "service_role";































