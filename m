Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FFEC30FCD5
	for <lists+linux-xfs@lfdr.de>; Thu,  4 Feb 2021 20:32:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238017AbhBDTbs (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 4 Feb 2021 14:31:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:55866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239793AbhBDTbm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 4 Feb 2021 14:31:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D74F464F38;
        Thu,  4 Feb 2021 19:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612467059;
        bh=lv+rognihUwxTon0CgKt9f+KkEzVc+MV4BA3QaZ5iUk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UYkmPkgE7t91LlUou7rI8rbHB3LVJW9Y1Y0cxHcfQ5ZFAGj1Jy45BDG8lUP12FxMV
         pddXWvFM3zAsZnxiYl2UWwFd/IJMLPLAdQquoYEUs7XC94FO231x0fLREcgHokvSKO
         aCJdH3OWUJ/Sx3a8zQl9LnTKtSnzCx/cLiB1LLeUM0KsDxvyAqDw2Bnaz3MDM65+sm
         IU1XgOAECsxHdv3RodHfUcjCUsP6UT84kFVCfY9bf4LICmPak0nLTkt3WUdOsrMtrr
         F9BnX9ivk9wucQq43/aN9262RZIFCWTzgGeyLhdEQgtJtlCc+H5B52eW6sGtyYjALj
         9gZSOFi1Pnl3g==
Date:   Thu, 4 Feb 2021 11:30:58 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs_db: support the needsrepair feature flag in the
 version command
Message-ID: <20210204193058.GH7193@magnolia>
References: <161238139177.1278306.5915396345874239435.stgit@magnolia>
 <161238140924.1278306.7058193268638972167.stgit@magnolia>
 <20210204175412.GB3721376@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210204175412.GB3721376@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 04, 2021 at 12:54:12PM -0500, Brian Foster wrote:
> On Wed, Feb 03, 2021 at 11:43:29AM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Teach the xfs_db version command about the 'needsrepair' flag, which can
> > be used to force the system administrator to repair the filesystem with
> > xfs_repair.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  db/check.c           |    5 ++
> >  db/sb.c              |  154 ++++++++++++++++++++++++++++++++++++++++++++++++--
> >  db/xfs_admin.sh      |   25 +++++++-
> >  man/man8/xfs_admin.8 |   30 ++++++++++
> >  man/man8/xfs_db.8    |    8 +++
> >  5 files changed, 213 insertions(+), 9 deletions(-)
> > 
> > 
> ...
> > diff --git a/db/sb.c b/db/sb.c
> > index f306e939..223b84fe 100644
> > --- a/db/sb.c
> > +++ b/db/sb.c
> ...
> > @@ -720,8 +840,23 @@ version_f(
> >  			return 0;
> >  		}
> >  
> > +		if (xfs_sb_version_needsrepair(&mp->m_sb)) {
> > +			dbprintf(_("%s: filesystem needs xfs_repair\n"),
> > +				progname);
> > +			return 0;
> > +		}
> > +
> >  		/* Logic here derived from the IRIX xfs_chver(1M) script. */
> > -		if (!strcasecmp(argv[1], "extflg")) {
> > +		if (!strcasecmp(argv[1], "needsrepair")) {
> > +			if (!xfs_sb_version_hascrc(&mp->m_sb)) {
> > +				dbprintf(
> > +		_("needsrepair flag cannot be enabled on pre-V5 filesystems\n"));
> > +				exitcode = 2;
> > +				return 1;
> > +			}
> 
> I still don't understand why we need this magic error code logic, here
> and in xfs_admin.sh. Can we not just have xfs_db succeed or fail
> (printing why if necessary) as it does today, and then let xfs_admin run
> repair if $status == 0 && NEEDSREPAIR?

I wanted to establish a new behavior that xfs_db would return an error
code for upgrade requests that aren't applicable to the filesystem.

But, seeing as the version command already exhibits the "return zero"
behavior if you try to "add" proji32bit to a V5 fs or feed version_f a
garbage parameter, I'll just keep doing things the way we do them now so
that I can at least get this part (and the long delayed fstests updates
for these three new features) going.

--D

> Brian
> 
> > +
> > +			v5features.incompat |= XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
> > +		} else if (!strcasecmp(argv[1], "extflg")) {
> >  			switch (XFS_SB_VERSION_NUM(&mp->m_sb)) {
> >  			case XFS_SB_VERSION_1:
> >  				version = 0x0004 | XFS_SB_VERSION_EXTFLGBIT;
> > @@ -813,6 +948,11 @@ version_f(
> >  			mp->m_sb.sb_versionnum = version;
> >  			mp->m_sb.sb_features2 = features;
> >  		}
> > +
> > +		if (!upgrade_v5_features(mp, &v5features)) {
> > +			exitcode = 1;
> > +			return 1;
> > +		}
> >  	}
> >  
> >  	if (argc == 3) {	/* VERSIONNUM + FEATURES2 */
> > diff --git a/db/xfs_admin.sh b/db/xfs_admin.sh
> > index 5c57b461..f465bd43 100755
> > --- a/db/xfs_admin.sh
> > +++ b/db/xfs_admin.sh
> > @@ -6,10 +6,11 @@
> >  
> >  status=0
> >  DB_OPTS=""
> > +DASH_O_DB_OPTS=""
> >  REPAIR_OPTS=""
> > -USAGE="Usage: xfs_admin [-efjlpuV] [-c 0|1] [-L label] [-U uuid] device [logdev]"
> > +USAGE="Usage: xfs_admin [-efjlpuV] [-c 0|1] [-L label] [-U uuid] [-O v5_feature] device [logdev]"
> >  
> > -while getopts "efjlpuc:L:U:V" c
> > +while getopts "efjlpuc:L:O:U:V" c
> >  do
> >  	case $c in
> >  	c)	REPAIR_OPTS=$REPAIR_OPTS" -c lazycount="$OPTARG;;
> > @@ -19,6 +20,13 @@ do
> >  	l)	DB_OPTS=$DB_OPTS" -r -c label";;
> >  	L)	DB_OPTS=$DB_OPTS" -c 'label "$OPTARG"'";;
> >  	p)	DB_OPTS=$DB_OPTS" -c 'version projid32bit'";;
> > +	O)
> > +		if [ -n "$DASH_O_DB_OPTS" ]; then
> > +			echo "-O can only be specified once." 1>&2
> > +			exit 1
> > +		fi
> > +		DASH_O_DB_OPTS=" -c 'version "$OPTARG"'"
> > +		;;
> >  	u)	DB_OPTS=$DB_OPTS" -r -c uuid";;
> >  	U)	DB_OPTS=$DB_OPTS" -c 'uuid "$OPTARG"'";;
> >  	V)	xfs_db -p xfs_admin -V
> > @@ -30,6 +38,13 @@ do
> >  		;;
> >  	esac
> >  done
> > +if [ -n "$DASH_O_DB_OPTS" ]; then
> > +	if [ -n "$DB_OPTS" ]; then
> > +		echo "-O can only be used by itself." 1>&2
> > +		exit 1
> > +	fi
> > +	DB_OPTS="$DASH_O_DB_OPTS"
> > +fi
> >  set -- extra $@
> >  shift $OPTIND
> >  case $# in
> > @@ -48,6 +63,12 @@ case $# in
> >  		fi
> >  		if [ $status -eq 1 ]; then
> >  			echo "Conversion failed due to filesystem errors; run xfs_repair."
> > +		elif xfs_db -c 'version' "$1" | grep -q NEEDSREPAIR; then
> > +			# Upgrade required us to run repair, so force
> > +			# xfs_repair to run by adding a single space to
> > +			# REPAIR_OPTS.
> > +			echo "Running xfs_repair to complete the upgrade."
> > +			REPAIR_OPTS="$REPAIR_OPTS "
> >  		fi
> >  		if [ -n "$REPAIR_OPTS" ]
> >  		then
> > diff --git a/man/man8/xfs_admin.8 b/man/man8/xfs_admin.8
> > index 8afc873f..d8a0125c 100644
> > --- a/man/man8/xfs_admin.8
> > +++ b/man/man8/xfs_admin.8
> > @@ -6,6 +6,8 @@ xfs_admin \- change parameters of an XFS filesystem
> >  [
> >  .B \-eflpu
> >  ] [
> > +.BI \-O " feature"
> > +] [
> >  .BR "\-c 0" | 1
> >  ] [
> >  .B \-L
> > @@ -103,6 +105,34 @@ The filesystem label can be cleared using the special "\c
> >  " value for
> >  .IR label .
> >  .TP
> > +.BI \-O " feature"
> > +Add a new feature to a V5 filesystem.
> > +Only one filesystem feature can be specified per invocation of xfs_admin.
> > +This option cannot be combined with any other
> > +.B xfs_admin
> > +option.
> > +.IP
> > +.B NOTE:
> > +Administrators must ensure the filesystem is clean by running
> > +.B xfs_repair -n
> > +to inspect the filesystem before performing the upgrade.
> > +If corruption is found, recovery procedures (e.g. reformat followed by
> > +restoration from backup; or running
> > +.B xfs_repair
> > +without the
> > +.BR -n )
> > +must be followed to clean the filesystem.
> > +.IP
> > +Features are as follows:
> > +.RS 0.7i
> > +.TP
> > +.B needsrepair
> > +Flag the filesystem as needing repairs.
> > +Until
> > +.BR xfs_repair (8)
> > +is run, the filesystem will not be mountable.
> > +.RE
> > +.TP
> >  .BI \-U " uuid"
> >  Set the UUID of the filesystem to
> >  .IR uuid .
> > diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
> > index ee57b03a..792d98c8 100644
> > --- a/man/man8/xfs_db.8
> > +++ b/man/man8/xfs_db.8
> > @@ -971,6 +971,11 @@ may toggle between
> >  and
> >  .B attr2
> >  at will (older kernels may not support the newer version).
> > +The filesystem can be flagged as requiring a run through
> > +.BR xfs_repair (8)
> > +if the
> > +.B needsrepair
> > +option is specified and the filesystem is formatted with the V5 format.
> >  .IP
> >  If no argument is given, the current version and feature bits are printed.
> >  With one argument, this command will write the updated version number
> > @@ -983,6 +988,9 @@ bits respectively, and their string equivalent reported
> >  (but no modifications are made).
> >  .IP
> >  If the feature upgrade succeeds, the program will return 0.
> > +The upgrade process may set the NEEDSREPAIR feature in the superblock to
> > +force the filesystem to be run through
> > +.BR xfs_repair (8).
> >  If the requested upgrade has already been applied to the filesystem, the
> >  program will also return 0.
> >  If the upgrade fails due to corruption or IO errors, the program will return
> > 
> 
