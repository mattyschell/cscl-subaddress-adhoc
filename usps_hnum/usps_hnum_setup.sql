-- copy SUBADDRESS into this working schema
-- 3rd party data should be here too (see cscl-subaddress-matched)
create index 
    subaddressmelissa_suite 
on 
    subaddress(melissa_suite);
create index 
    subaddressap_id 
on 
    subaddress(ap_id);
create unique index 
    suabddresssubaddress_id 
on 
    subaddress(sub_address_id);
call DBMS_STATS.GATHER_SCHEMA_STATS(sys_context('USERENV','CURRENT_USER')); 
--none should be returned: this is a prerequisite
select case count(*) 
           when 0 then 'SUPER'
           else 'STOP'
       end as subaddress_dupe_check
from (select 
          melissa_suite
         ,ap_id
         ,count(*)
     from 
          subaddress
     where 
         usps_hnum is null
     group by melissa_suite
             ,ap_id
     having count(*) > 1);
-- should have 3rd party data ready as described
-- https://github.com/mattyschell/cscl-subaddress-matched#3c-insert-relevant-loaded-data-into-subaddress_src-and-melissa_geocoded_src
select case count(*) 
           when 0 then 'STOP'
           else 'SUPER'
       end as melissa_geocoded_src_check
from melissa_geocoded_src;