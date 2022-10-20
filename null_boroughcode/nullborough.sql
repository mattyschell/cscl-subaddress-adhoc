declare
    myversion nvarchar2(100) := 'subaddressversion';
begin
    sde.version_user_ddl.create_version('CSCL.DOITTWORKVERSION'
                                        ,myversion
                                        ,sde.version_util.C_take_name_as_given
                                        ,sde.version_util.C_version_public
                                        ,'updating boroughcode'); 
end;
/
-- change to new version
CALL sde.version_util.set_current_version('subaddressversion');
-- start editing
CALL sde.version_user_ddl.edit_version('subaddressversion',1);
update 
    cscl.subaddress_evw a
set
    a.boroughcode = NULL
where
    a.boroughcode IS NOT NULL;
-- click save
commit;
-- click stop editing
CALL sde.version_user_ddl.edit_version('subaddressversion',2);