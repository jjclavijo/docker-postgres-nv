# No Volume postgres Image.

This is a Slightly modified postgres image, doesn't declares the VOLUME on $PGDATA

Is only usefull as base image if you wish to populate the database on build time.

Which in turn may be usefull if you are sharing a somehow complex dataset and, by 
providing some querys along with the container your counterpart will be able to
make some data analysis.

After database population, the VOLUME must be declared again.
