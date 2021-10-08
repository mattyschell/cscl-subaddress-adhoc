update 
    subaddress a
set 
    a.usps_hnum = 
        (select 
             b.hnum 
         from 
             melissa_geocoded_src b
         where 
             a.ap_id = b.addresspointid
         and UPPER(a.melissa_suite) = b.suite
        ) 
where 
    a.usps_hnum is null
and a.ap_id not in (select 
                        addresspointid
                    from (select 
                              distinct addresspointid, hnum 
                          from 
                              melissa_geocoded_src
                         ) group by addresspointid
                    having count(addresspointid) > 1
                    )
and exists
    (select 1 
     from 
         melissa_geocoded_src b
     where 
         a.ap_id = b.addresspointid
     and UPPER(a.melissa_suite) = b.suite);
commit;
-- explanation of "and a.ap_id not in" where clause
-- 
--
-- these are in subaddress, they are not duplicates
-- so we did not delete and replace them
--select  ap_id as ap_id
--   ,melissa_suite as melissa_suite
--   , usps_hnum
--   from subaddress
--where ap_id = 127454
---order by 2
-- if there were two APT 1As (corresponding to 2 USPS Hnums) we would have deleted and replaced
--AP_ID |MELISSA_SUITE|USPS_HNUM
--------+-------------+---------
--127454|APT 1A       |         
--127454|APT 1B       |         
--127454|APT 1C       |         
--instead what we have is (implicitly) 2 addresses stacked up on a single address point
-- instead we have 2 addresses smushed onto a single address point
-- when geocoded to the melissa data.  Not sure how exactly DCP did it
-- it is a location in the CSCL data that has since been updated - 2 addresses here now 
--127454  APT 1A  147-45
--127454  APT 1A  147-47
--127454  APT 1B  147-45
--127454  APT 1B  147-47
-- need to find these address points and exclude them from the update
-- most do not need to be updated because they do not have null house numbers
-- we already force replaced them
-- but this is the full universe
--select addresspointid, count(addresspointid) from (
--select distinct addresspointid, hnum from melissa_geocoded_src
--) group by addresspointid
--having count(addresspointid) > 1
--905 total address points off limits
--
--review
--these are address points with differing usps hnum values 
select 
    to_char(count(*)) 
    || ' address points have varying usps_hnum values on a set of subaddresses ' 
    as review 
from (select 
          ap_id 
      from (select 
                ap_id
               ,usps_hnum
               ,count(*) 
            from 
                subaddress
            where 
                usps_hnum is not null
            group by 
                ap_id
               ,usps_hnum
) group by ap_id 
having count(ap_id) > 1
);
-- 
-- not updated
select 
    to_char(count(*)) 
    || ' subaddresses have no usps_hnum ' 
    as review 
from 
    subaddress 
where usps_hnum is null;
--
select 
    to_char(count(distinct ap_id)) 
    || ' distinct address points have no usps_hnum ' 
    as review 
from 
    subaddress 
where usps_hnum is null;


