#!/bin/bash

BASEDIR=/var/www/html
# extract and initialize zenphoto if not present


if [ ! -f $BASEDIR/zp-data/zenphoto.cfg.php ]; then
	/bin/cp $BASEDIR/zp-core/zenphoto_cfg.txt $BASEDIR/zp-data/zenphoto.cfg.php
	sed -i "/mysql_user/c\$conf['mysql_user'] = 'root';" $BASEDIR/zp-data/zenphoto.cfg.php
	sed -i "/mysql_pass/c\$conf['mysql_pass'] = 'root';" $BASEDIR/zp-data/zenphoto.cfg.php
	sed -i "/mysql_host/c\$conf['mysql_host'] = 'db';" $BASEDIR/zp-data/zenphoto.cfg.php
	sed -i "/mysql_database/c\$conf['mysql_database'] = 'zenphoto';" $BASEDIR/zp-data/zenphoto.cfg.php
	sed -i "/mysql_prefix/c\$conf['mysql_prefix'] = '';" $BASEDIR/zp-data/zenphoto.cfg.php
fi

# Ensure that Zenphoto knows that the filesystem supports UTF8
if [ ! -f $BASEDIR/zp-data/charset_tést ]; then
	touch $BASEDIR/zp-data/charset_tést
fi

exec apache2-foreground
