declare
    myversion nvarchar2(100) := 'subaddressversion';
begin
    sde.version_user_ddl.create_version('CSCL.DOITTWORKVERSION'
                                        ,myversion
                                        ,sde.version_util.C_take_name_as_given
                                        ,sde.version_util.C_version_public
                                        ,'description goes here'); 
end;
/
-- change to new version
CALL sde.version_util.set_current_version('subaddressversion');
-- start editing
CALL sde.version_user_ddl.edit_version('subaddressversion',1);
update 
    cscl.subaddress_evw a
set
    a.usps_hnum = 
        (select 
            b.usps_hnum
        from 
            cscl.subaddress_prune b
        where 
            a.sub_address_id = b.sub_address_id)
   ,a.modified_by = USER
   ,a.modified_date = current_timestamp
where 
    a.usps_hnum is null
and exists
    (select 1 
     from 
        cscl.subaddress_prune b
     where 
        a.sub_address_id = b.sub_address_id);
 -- click save
commit;
-- click stop editing
CALL sde.version_user_ddl.edit_version('subaddressversion',2);