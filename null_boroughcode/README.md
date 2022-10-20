# Issue 4

https://github.com/mattyschell/cscl-subaddress-adhoc/issues

The de-normalized subaddress boroughcode column is not strictly necessary. We actively maintain boroughs on address points which have a one to many relationship to subaddresses.

We do not know the exact history of the column boroughcode on the subaddress table. It may have been created to help create a sort of virtual partition, either for internal updates or for downstream users.

As of Fall 2022 we are unaware of any uses for this column. It is a mix of NULLs and old values.

To be safe instead of dropping the column we will NULL all values to make clear that the column will not be maintained.

1. Update cscl.subaddress_evw (versioned view)

We will create a version and edit the version.  Though this seems like overkill for a simple attribute update it is a path that will be respected by ESRI functionality like replication.

```
sqlplus <editor>/iluvjackdangermond247@ditxxxxx @nullborough.sql
```

In production this should null out 2381988 values.  Lots of adds/deletes in the deltas.

2. Review the results and manually reconcile and post from "subaddressversion"

3. Tidy up. Delete subaddressversion.
