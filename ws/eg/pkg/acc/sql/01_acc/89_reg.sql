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

*/
-- 89_reg.sql - Регистрация методов и страниц
/* ------------------------------------------------------------------------- */
\qecho '-- FD: acc:acc:89_reg.sql / 23 --'

/* ------------------------------------------------------------------------- */

INSERT INTO method (code, class_id , action_id, cache_id, rvf_id) VALUES
  ('acc.sid_info',          2, 1, 3, 3)
  , ('acc.sid_info_cook',   2, 1, 3, 3)
  , ('acc.profile',         2, 1, 3, 3)
;

INSERT INTO method (code, class_id , action_id, cache_id, rvf_id, is_write) VALUES
  ('acc.login',             2, 1, 3, 3, true)
  , ('acc.logout',          2, 1, 3, 2, true)
;

/* ------------------------------------------------------------------------- */

INSERT INTO i18n_def.page (code, up_code, class_id, action_id, sort, uri, tmpl, name) VALUES
  ('login',     'main', 2, 1, null, 'login$',     'acc/login',    'Вход')
  , ('logout',  'main', 2, 1, null, 'logout$',    'acc/logout',   'Выход')
;


/* ------------------------------------------------------------------------- */
\qecho '-- FD: acc:acc:89_reg.sql / 47 --'
