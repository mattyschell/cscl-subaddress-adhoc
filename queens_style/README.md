# QUEENS_STYLE

For all my Queens-style addresses. (missing hyphens)  See https://github.com/mattyschell/cscl-subaddress-matched/issues/13

## Update

1. Load the corrected .csv into a scratch schema as QUEENSSTYLE. Be a pro, use ArcGIS Pro. 

Delete duplicates.  
```sql
delete from 
    queensstyle 
where
    sub_address_id in (
        select 
            sub_address_id 
        from 
            queensstyle
        group by sub_address_id
        having count(sub_address_id) > 1);
```

```sql
create index queensstyleuqk on queensstyle(sub_address_id);
```

2.  Verify. Should return nothing

```sql 
select 
    count(*) 
from
    queensstyle a
where 
    a.sub_address_id 
not in (select 
            sub_address_id 
        from
            cscl.subaddress_evw b);
```


3. Update cscl.subaddress_evw (versioned view)

```shell
sqlplus <editor>/iluvscottmorehouse247@ditxxxxx @update_target.sql
```

4. Review the results and manually reconcile and post from "subaddressversion"

5. Tidy up

Delete "subaddressversion." Delete QUEENSSTYLE.

