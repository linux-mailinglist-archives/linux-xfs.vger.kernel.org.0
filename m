Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C54230E319
	for <lists+linux-xfs@lfdr.de>; Wed,  3 Feb 2021 20:11:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbhBCTLN (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 3 Feb 2021 14:11:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48047 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229606AbhBCTLM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Feb 2021 14:11:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612379384;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UX6Dj+wSHwoH6YamzFIlSS6ivJc4JD8TJdb0hrfzvEE=;
        b=A+3GQPftG1t3jgY2GdO0362FB2yAEj7c6xF9XLaPRNUevbtTlY3wS++i0utcWYat13kJvk
        r7+kpRRLy5K0UGBX19driSAuS5sD2mJe0CGAwItT0bQzDTiNXsk/ou7TnDdnpYfbAZEtud
        yJtWrnV2WE869y1pdUYTP98Vlju1h+0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-407-RW5R4DTtMfujB7iL-c9s5A-1; Wed, 03 Feb 2021 14:09:41 -0500
X-MC-Unique: RW5R4DTtMfujB7iL-c9s5A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7A1128030B5;
        Wed,  3 Feb 2021 19:09:40 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DA45C5D74F;
        Wed,  3 Feb 2021 19:09:39 +0000 (UTC)
Date:   Wed, 3 Feb 2021 14:09:38 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs_db: support the needsrepair feature flag in the
 version command
Message-ID: <20210203190938.GJ3647012@bfoster>
References: <161076028124.3386490.8050189989277321393.stgit@magnolia>
 <161076028723.3386490.10074737936252642930.stgit@magnolia>
 <20210119143714.GA1646807@bfoster>
 <20210202210915.GV7193@magnolia>
 <20210203130721.GA3647012@bfoster>
 <20210203183057.GB7190@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210203183057.GB7190@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 03, 2021 at 10:30:57AM -0800, Darrick J. Wong wrote:
> On Wed, Feb 03, 2021 at 08:07:21AM -0500, Brian Foster wrote:
> > On Tue, Feb 02, 2021 at 01:09:15PM -0800, Darrick J. Wong wrote:
> > > On Tue, Jan 19, 2021 at 09:37:14AM -0500, Brian Foster wrote:
> > > > On Fri, Jan 15, 2021 at 05:24:47PM -0800, Darrick J. Wong wrote:
> > > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > > 
> > > > > Teach the xfs_db version command about the 'needsrepair' flag, which can
> > > > > be used to force the system administrator to repair the filesystem with
> > > > > xfs_repair.
> > > > > 
> > > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > > ---
> > > > >  db/check.c           |    5 ++
> > > > >  db/sb.c              |  153 ++++++++++++++++++++++++++++++++++++++++++++++++--
> > > > >  db/xfs_admin.sh      |   10 ++-
> > > > >  man/man8/xfs_admin.8 |   15 +++++
> > > > >  man/man8/xfs_db.8    |    5 ++
> > > > >  5 files changed, 178 insertions(+), 10 deletions(-)
> > > > > 
> > > > > 
> > ...
> > > > > diff --git a/db/sb.c b/db/sb.c
> > > > > index d09f653d..fcc2a0ed 100644
> > > > > --- a/db/sb.c
> > > > > +++ b/db/sb.c
> > ...
> > > > > @@ -717,8 +836,23 @@ version_f(
> > > > >  			return 0;
> > > > >  		}
> > > > >  
> > > > > +		if (xfs_sb_version_needsrepair(&mp->m_sb)) {
> > > > > +			dbprintf(_("%s: filesystem needs xfs_repair\n"),
> > > > > +				progname);
> > > > > +			return 0;
> > > > > +		}
> > > > > +
> > > > >  		/* Logic here derived from the IRIX xfs_chver(1M) script. */
> > > > > -		if (!strcasecmp(argv[1], "extflg")) {
> > > > > +		if (!strcasecmp(argv[1], "needsrepair")) {
> > > > > +			if (!xfs_sb_version_hascrc(&mp->m_sb)) {
> > > > > +				dbprintf(
> > > > > +		_("needsrepair flag cannot be enabled on pre-V5 filesystems\n"));
> > > > > +				exitcode = 2;
> > > > > +				return 1;
> > > > 
> > > > Hmm.. I see that exitcode 1 means error && xfs_repair while exitcode 2
> > > > means error && !xfs_repair, but I'm still not sure I follow the high
> > > > level error semantics, particularly if we happen to fail updating
> > > > secondary supers. I wonder if it would be more straightforward to have
> > > > xfs_db only return an error when an update attempt occurs and fails and
> > > > then let xfs_admin run xfs_repair if status == 0 && NEEDSREPAIR is set.
> > > 
> > > Hm.  I'd be even more tempted to make it run if xfs_db just failed.
> > > 
> > > > I suppose the various other ".. bit already set" or "v5 super required"
> > > > conditions don't really need to be errors and thus repair would only run
> > > > in those cases if NEEDSREPAIR was still set on the fs. Otherwise if
> > > > xfs_db fails we dump an error message and encourage the user to run
> > > > xfs_repair themselves.
> > > 
> > > Yeah, that does seem more reasonable.  I'll change xfs_admin to force a
> > > run through repair if the NEEDSREPAIR feature is set or if the xfs_db
> > > command failed, since that probably means something's wrong with the fs.
> > > 
> > 
> > Perhaps, or the storage if an I/O happens to fail or something. I'm not
> > sure we should go that route where if the version upgrade happens to
> > fail we do a "well this operation failed, but something is probably
> > wrong so let me try and repair that for you." I'd personally be kind of
> > annoyed by that if I didn't have an opportunity to analyze the problem
> > before making the decision to run a (potentially destructive) repair
> > operation. I agree it's an unlikely situation, but IMO the automatically
> > invoked repair should be isolated to the specific case that warrants it
> > and everything else should probably just bail out.
> 
> Hm, good point, considering how long it can take to run repair.  I'm
> sure there's some sysadmin out there who would actually prefer to nuke
> the whole fs/node if the upgrade fails.
> 

I don't know if there are any likely scenarios where a user might throw
a feature upgrade attempt at a borked fs only to find it falling into
repair for some other reason, but I'd rather not hear about those cases
from a support perspective, whether it be complaints about feature
upgrade taking forever, confusion over why a feature upgrade failed but
then spit out some other repair related errors, losing the ability to
gather repair -n output, a metadump, etc. We do rarely have cases where
users are surprised a repair throws out a bunch of directory entries or
makes other big and unexpected changes to the fs because they don't
quite understand that repair != data recovery. With those types of
support cases in mind, I just think less can go wrong or down an
unexpected path if the upgrade repair logic is very explicitly tied to
feature bit upgrade success && needsrepair.

> > The user really doesn't need to know or care that a repair is involved
> > in the first place, so ISTM that either "upgrade operation succeeded" or
> > "upgrade operation failed, fs has problems" is fairly expected failure
> > handling behavior (as opposed to allowing things like "upgrade operation
> > failed, we ran repair anyways and fixed some other stuff, maybe try that
> > upgrade again since the last one basically just invoked xfs_repair?").
> > If we really wanted to be careful, we could even run a repair -n first
> > and require it succeed before attempting to touch the superblock. That
> > might be annoying in cases where repair takes forever, but at least if
> > the user bails on it it would likely be before we've modified anything.
> 
> ...or make it more likely that the user ^Cs and never uses our
> scurrilous upgrader tool. :)
> 

Heh. :P

> I dunno, I've a slight preference for /knowing/ that the fs isn't a
> crazy tangle of crap before we try to upgrade it.  Though as I've
> mentioned before, resize2fs has weird heuristics to guesstimate if a
> filesystem is clean "enough", and ext4 even tracks the last fsck and
> mount times.  I don't really want to go down that path.
> 
> Perhaps we should simply document xfs_repair -n as a preparation step?
> 

Yeah, it's probably a good idea to put that in writing. I don't have a
strong opinion on doing the pre-update repair thing. I was just throwing
it out there as a thought. Users may not be aware that a repair is part
of the normal procedure in the first place, so documenting this might be
helpful for those responsible enough to follow best practices.

Brian

> --D
> 
> > 
> > Brian
> > 
> > > > There are still corner cases I guess, but that does _seem_ a bit more
> > > > elegant to me. Otherwise I suppose a comment somewhere that explains
> > > > when/why to use which error code would be helpful.
> > > 
> > > <nod> I'll put them in.
> > > 
> > > --D
> > > 
> > > > Brian
> > > > 
> > > > > +			}
> > > > > +
> > > > > +			v5features.incompat |= XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
> > > > > +		} else if (!strcasecmp(argv[1], "extflg")) {
> > > > >  			switch (XFS_SB_VERSION_NUM(&mp->m_sb)) {
> > > > >  			case XFS_SB_VERSION_1:
> > > > >  				version = 0x0004 | XFS_SB_VERSION_EXTFLGBIT;
> > > > > @@ -809,6 +943,11 @@ version_f(
> > > > >  			mp->m_sb.sb_versionnum = version;
> > > > >  			mp->m_sb.sb_features2 = features;
> > > > >  		}
> > > > > +
> > > > > +		if (!upgrade_v5_features(mp, &v5features)) {
> > > > > +			exitcode = 1;
> > > > > +			return 1;
> > > > > +		}
> > > > >  	}
> > > > >  
> > > > >  	if (argc == 3) {	/* VERSIONNUM + FEATURES2 */
> > > > > diff --git a/db/xfs_admin.sh b/db/xfs_admin.sh
> > > > > index bd325da2..0e79bbf9 100755
> > > > > --- a/db/xfs_admin.sh
> > > > > +++ b/db/xfs_admin.sh
> > > > > @@ -7,9 +7,9 @@
> > > > >  status=0
> > > > >  DB_OPTS=""
> > > > >  REPAIR_OPTS=""
> > > > > -USAGE="Usage: xfs_admin [-efjlpuV] [-c 0|1] [-L label] [-U uuid] device [logdev]"
> > > > > +USAGE="Usage: xfs_admin [-efjlpuV] [-c 0|1] [-L label] [-U uuid] [-O v5_feature] device [logdev]"
> > > > >  
> > > > > -while getopts "efjlpuc:L:U:V" c
> > > > > +while getopts "efjlpuc:L:O:U:V" c
> > > > >  do
> > > > >  	case $c in
> > > > >  	c)	REPAIR_OPTS=$REPAIR_OPTS" -c lazycount="$OPTARG;;
> > > > > @@ -19,6 +19,9 @@ do
> > > > >  	l)	DB_OPTS=$DB_OPTS" -r -c label";;
> > > > >  	L)	DB_OPTS=$DB_OPTS" -c 'label "$OPTARG"'";;
> > > > >  	p)	DB_OPTS=$DB_OPTS" -c 'version projid32bit'";;
> > > > > +	O)	DB_OPTS=$DB_OPTS" -c 'version "$OPTARG"'";
> > > > > +		# Force repair to run by adding a single space to REPAIR_OPTS
> > > > > +		REPAIR_OPTS="$REPAIR_OPTS ";;
> > > > >  	u)	DB_OPTS=$DB_OPTS" -r -c uuid";;
> > > > >  	U)	DB_OPTS=$DB_OPTS" -c 'uuid "$OPTARG"'";;
> > > > >  	V)	xfs_db -p xfs_admin -V
> > > > > @@ -34,6 +37,7 @@ set -- extra $@
> > > > >  shift $OPTIND
> > > > >  case $# in
> > > > >  	1|2)
> > > > > +		status=0
> > > > >  		# Pick up the log device, if present
> > > > >  		if [ -n "$2" ]; then
> > > > >  			DB_OPTS=$DB_OPTS" -l '$2'"
> > > > > @@ -46,7 +50,7 @@ case $# in
> > > > >  			eval xfs_db -x -p xfs_admin $DB_OPTS $1
> > > > >  			status=$?
> > > > >  		fi
> > > > > -		if [ -n "$REPAIR_OPTS" ]
> > > > > +		if [ -n "$REPAIR_OPTS" ] && [ $status -ne 2 ]
> > > > >  		then
> > > > >  			# Hide normal repair output which is sent to stderr
> > > > >  			# assuming the filesystem is fine when a user is
> > > > > diff --git a/man/man8/xfs_admin.8 b/man/man8/xfs_admin.8
> > > > > index 8afc873f..b423981d 100644
> > > > > --- a/man/man8/xfs_admin.8
> > > > > +++ b/man/man8/xfs_admin.8
> > > > > @@ -6,6 +6,8 @@ xfs_admin \- change parameters of an XFS filesystem
> > > > >  [
> > > > >  .B \-eflpu
> > > > >  ] [
> > > > > +.BI \-O " feature"
> > > > > +] [
> > > > >  .BR "\-c 0" | 1
> > > > >  ] [
> > > > >  .B \-L
> > > > > @@ -103,6 +105,19 @@ The filesystem label can be cleared using the special "\c
> > > > >  " value for
> > > > >  .IR label .
> > > > >  .TP
> > > > > +.BI \-O " feature"
> > > > > +Add a new feature to the filesystem.
> > > > > +Only one feature can be specified at a time.
> > > > > +Features are as follows:
> > > > > +.RS 0.7i
> > > > > +.TP
> > > > > +.B needsrepair
> > > > > +If this is a V5 filesystem, flag the filesystem as needing repairs.
> > > > > +Until
> > > > > +.BR xfs_repair (8)
> > > > > +is run, the filesystem will not be mountable.
> > > > > +.RE
> > > > > +.TP
> > > > >  .BI \-U " uuid"
> > > > >  Set the UUID of the filesystem to
> > > > >  .IR uuid .
> > > > > diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
> > > > > index 58727495..7331cf19 100644
> > > > > --- a/man/man8/xfs_db.8
> > > > > +++ b/man/man8/xfs_db.8
> > > > > @@ -971,6 +971,11 @@ may toggle between
> > > > >  and
> > > > >  .B attr2
> > > > >  at will (older kernels may not support the newer version).
> > > > > +The filesystem can be flagged as requiring a run through
> > > > > +.BR xfs_repair (8)
> > > > > +if the
> > > > > +.B needsrepair
> > > > > +option is specified and the filesystem is formatted with the V5 format.
> > > > >  .IP
> > > > >  If no argument is given, the current version and feature bits are printed.
> > > > >  With one argument, this command will write the updated version number
> > > > > 
> > > > 
> > > 
> > 
> 

