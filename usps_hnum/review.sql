create table addresspointrev as 
select a.addresspointid
      ,a.hyphen_type
      ,to_char(a.created_date, 'YYYY-MM-DD' ) as created_date
      ,to_char(a.modified_date, 'YYYY-MM-DD' ) as modified_date
      ,sdo_cs.transform(a.shape,4326) as shape
from 
    addresspoint a
where 
    a.addresspointid in 
    (select distinct ap_id from subaddress where usps_hnum is null);
-- then export to shp
-- then 
-- > ogr2ogr -f GeoJSON addresspointreview.geojson addresspointrev.shp
