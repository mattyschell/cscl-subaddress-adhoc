# USPS_HNUM

Ad hoc work to update subaddress.usps_hnum.

We performed the annual subaddress update using (https://github.com/mattyschell/cscl-subaddress-matched) but this update only adds and removes records as necessary.  It does not touch existing records.

The goal of this adhoc update is to populate as many usps_hnum values as possible.

## Update in scratch schema

1. After loading [CSCL-Subaddress-Matched](https://github.com/mattyschell/cscl-subaddress-matched) inputs as usual, and performing processing...
2. execute usps_hnum_setup.sql
   2a. This will perform some basic checks that expected inputs are present
3. execute usps_hnum_update.sql
   2a. This will conclude by reporting some simple QA stats on the results 

## Manual updates in production

General outline reminders

1. Create a new file geodatabase
2. Export subaddress to the file geodatabase in 5 buckets
3. export only sub_address_id and usps_hnum
    
```
create table subaddress_prune_2
as 
select 
    sub_address_id
   ,usps_hnum
from 
    subaddress 
where 
    usps_hnum is not null
and objectid > 1800000
and objectid <= 2400000
order by 
    sub_address_id;
```


4. [index](https://pro.arcgis.com/en/pro-app/latest/tool-reference/data-management/add-attribute-index.htm) the sub_address_id column 
5. https://pro.arcgis.com/en/pro-app/latest/help/data/geodatabases/overview/an-overview-of-fields.htm
6. In ArcGIS Pro connect to cscl production subaddress as a user schema
7. Create a new version under cscl.doittworkversion. Change to the new version
8. Join the file geodatabase to subaddress
9. An inner join is "uncheck keep all target features" in ESRIese.
10. Upate where usps_hnum is null and join column is not null
11. Remove join
12. Reconcile and post



