# USPS_HNUM

Ad hoc work to update subaddress.usps_hnum.

We performed the annual subaddress update using (https://github.com/mattyschell/cscl-subaddress-matched) but that update only adds and removes records as necessary.  It does not touch existing records.

The goal of this adhoc update is to populate as many usps_hnum values as possible.

## Update in scratch schema

After loading [CSCL-Subaddress-Matched](https://github.com/mattyschell/cscl-subaddress-matched) inputs as usual, and performing processing...

1. execute usps_hnum_setup.sql
    
    This will perform some basic checks that expected inputs are present

2. execute usps_hnum_update.sql

   This will conclude by reporting some simple QA stats on the results 

## Manual updates in production
    
1. Simple spool export 2 columns from working subaddress

Use SQLPlus for this.

```
sqlplus workschema/iluvlerryellison247@ditxxxxx @dump_subaddress.sql
```

Drops out load_subaddress_prune.sql.  This file may be several hundred MB.

2. Load into a schema on the CSCL target. CSCL is fine, but check with the bosses.  

```
sqlplus cscl/iluvljackdangermond247@ditxxxxx @load_subaddress_prune.sql
```

Give your user schema access to subaddress_prune (if necessary)

```
grant select on subaddress_prune to "MSCHELL";
```

3. Update cscl.subaddress_evw (versioned view)

We will create a version and edit the version.  Though this seems like overkill for an attribute update it is a path that will be respected by  ESRI functionality like replication.

4. Review the results and manually reconcile and post from "subaddressversion"

5. Tidy up

Delete  the version created in step 3, subaddressversion.  Drop subaddress_prune.




