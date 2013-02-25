/*

    Copyright (c) 2010, 2012 Tender.Pro http://tender.pro.

    This file is part of PGWS - Postgresql WebServices.

    PGWS is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    PGWS is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with PGWS.  If not, see <http://www.gnu.org/licenses/>.

    Таблицы блока управления свойствами
*/

/* ------------------------------------------------------------------------- */
INSERT INTO wsd.pkg_script_protected (pkg, code, ver) VALUES ('cfg', :'FILE', :'VER');

/* ------------------------------------------------------------------------- */
CREATE TABLE prop (
  code        d_prop_code PRIMARY KEY
, pkg         TEXT NOT NULL DEFAULT ws.pg_cs()
, pogc_list   d_texta NOT NULL
, is_mask     BOOL NOT NULL -- рассчитывается RULE
, def_value   TEXT
, name        TEXT NOT NULL
, value_fmt   TEXT
, anno        TEXT
);

SELECT pg_c('r', 'prop',        'Справочник свойств')
, pg_c('c', 'prop.code',        'Код свойства')
, pg_c('c', 'prop.pkg',         'Пакет, в котором добавлено свойство')
, pg_c('c', 'prop.pogc_list',   'Массив кодов разрешенных групп (prop_group)')
, pg_c('c', 'prop.is_mask',     'Свойство не атомарно')
, pg_c('c', 'prop.def_value',   'Значение по умолчанию')
, pg_c('c', 'prop.name',        'Название')
, pg_c('c', 'prop.value_fmt',   'Строка формата для вывода значения')
, pg_c('c', 'prop.anno',        'Аннотация')
;

-- Индекс для автокомплита и поиска
CREATE INDEX prop_code ON prop USING btree(lower(code)  text_pattern_ops);

/* ------------------------------------------------------------------------- */
CREATE TABLE wsd.prop_group (
  pogc            TEXT PRIMARY KEY
, pkg             TEXT NOT NULL
, sort            INTEGER NOT NULL
, is_id_required  BOOL NOT NULL DEFAULT TRUE
, name            TEXT NOT NULL
, anno            TEXT
);

SELECT pg_c('r', 'wsd.prop_group', 'Группа владельцев свойств')
, pg_c('c', 'wsd.prop_group.pogc', 'Код группы (Property Owner Group Code)')
, pg_c('c', 'wsd.prop_group.pkg',  'Пакет, в котором добавлена группа')
, pg_c('c', 'wsd.prop_group.sort', 'Порядок сортировки')
, pg_c('c', 'wsd.prop_group.is_id_required', 'Загрузка без указания poid не используется')
, pg_c('c', 'wsd.prop_group.name', 'Название')
, pg_c('c', 'wsd.prop_group.anno', 'Аннотация')
;

/* ------------------------------------------------------------------------- */
CREATE TABLE wsd.prop_owner (
  pogc        TEXT REFERENCES wsd.prop_group
, poid        INTEGER
, pkg         TEXT NOT NULL
, sort        INTEGER NOT NULL
, name        TEXT NOT NULL
, anno        TEXT
, CONSTRAINT  prop_id_pkey PRIMARY KEY (pogc, poid)
);

SELECT pg_c('r', 'wsd.prop_owner', 'Владельцы свойств (Property Owner)')
, pg_c('c', 'wsd.prop_owner.pogc', 'Код группы (Property Owner Group Code)')
, pg_c('c', 'wsd.prop_owner.poid', 'ID владельца (Property Owner ID)')
, pg_c('c', 'wsd.prop_owner.pkg',  'Пакет, в котором добавлена группа')
, pg_c('c', 'wsd.prop_owner.sort', 'Порядок сортировки')
, pg_c('c', 'wsd.prop_owner.name', 'Название')
, pg_c('c', 'wsd.prop_owner.anno', 'Аннотация')
;

/* ------------------------------------------------------------------------- */
CREATE TABLE wsd.prop_value (
  pogc        TEXT
, poid        INTEGER
, code        TEXT      -- d_prop_code REFERENCES prop
, valid_from  DATE DEFAULT '2000-01-01'
, pkg         TEXT NOT NULL
, value       TEXT
, CONSTRAINT  prop_value_pkey PRIMARY KEY (pogc, poid, code, valid_from)
, CONSTRAINT  prop_value_pogc_poid_fkey FOREIGN KEY (pogc, poid) REFERENCES wsd.prop_owner
);

SELECT pg_c('r', 'wsd.prop_value',       'Значения свойств объектов')
, pg_c('c', 'wsd.prop_value.pogc',       'Код группы (Property Owner Group Code)')
, pg_c('c', 'wsd.prop_value.poid',       'ID владельца (Property Owner ID)')
, pg_c('c', 'wsd.prop_value.code',       'Код свойства')
, pg_c('c', 'wsd.prop_value.valid_from', 'Дата начала действия')
, pg_c('c', 'wsd.prop_value.pkg',        'Пакет, в котором задано значение')
, pg_c('c', 'wsd.prop_value.value',      'Значение свойства')
;
