-- sqlplus geodatashare/iluvlerryellison247@ditxxxxx @dump_subaddress.sql
SET HEADING OFF
SET FEEDBACK OFF
SET ECHO OFF
SET TERMOUT OFF
SET PAGESIZE 0
SPOOL load_subaddress_prune.sql
-- formatting here seems funny   
select 
    'create table subaddress_prune (sub_address_id number, usps_hnum varchar(15), constraint subaddress_prune_pkc primary key(sub_address_id));' 
from 
    dual
union all    
select 'set termout off;' from dual
union all
select 
    'insert into subaddress_prune values(' || 
    to_char(a.sub_address_id) || ',''' || to_char(a.usps_hnum) || ''');' 
from 
    subaddress a 
where 
    a.usps_hnum is not null
union all
select 
    'commit;'
from
    dual;
union all
select 'EXECUTE DBMS_STATS.GATHER_SCHEMA_STATS(NULL,NULL);' from dual;
SPOOL OFF
EXIT