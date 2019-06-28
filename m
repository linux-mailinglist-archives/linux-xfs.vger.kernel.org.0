Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46D5D5A6CB
	for <lists+linux-xfs@lfdr.de>; Sat, 29 Jun 2019 00:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbfF1WSi (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 28 Jun 2019 18:18:38 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:37364 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726563AbfF1WSi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Jun 2019 18:18:38 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5SMEj5H063296;
        Fri, 28 Jun 2019 22:18:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=2BPEMvuOFAxnMfgrcjhqg6/iN78iUzzHNRAeVnviQOs=;
 b=2fBHrrxa5Uz6v+L9Cke4VdQafUlXu8ZddLdXHGUUuNgCYqoSgz+Kzd2EedJWm/YeDxb1
 JsdVOfQdFOjbKmZ41ja1YTlBQYIjBVUJidMyTi2NsXok0l79WvEdQWRvF+YmDZKMTP7a
 O3Xwn8O66sQ473Mk8xdkf8QYfe+bkLaoe7KEvqEJppwGhQ9Yzrio0ZBK5J9NhS9M8Gfo
 dHbmaD+bl/cCUWguWLvBQXRoTXaGVPLXr6vOC7NYKbWhH0d7E6yD9daMTeIvYCnzJ1VN
 cEuJ1+XfFK+y3zEPhE+5bXcuMwD2RPoj1k/Jodh3j3NGXhU5qO3F3Mh4dZSXQZXlGL7N ug== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2t9brtqqwy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Jun 2019 22:18:22 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5SMI29J020104;
        Fri, 28 Jun 2019 22:18:22 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2t99f5te2y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Jun 2019 22:18:22 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5SMIL14022659;
        Fri, 28 Jun 2019 22:18:21 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 28 Jun 2019 15:18:20 -0700
Date:   Fri, 28 Jun 2019 15:18:19 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Sheriff Esseson <sheriffesseson@gmail.com>,
        skhan@linuxfoundation.org, corbet@lwn.net,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH v1] Doc : fs : convert xfs.txt to ReST
Message-ID: <20190628221819.GG5179@magnolia>
References: <20190628214302.GA12096@localhost>
 <20190628215106.GE4286@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190628215106.GE4286@bombadil.infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9302 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906280255
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9302 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906280255
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 28, 2019 at 02:51:06PM -0700, Matthew Wilcox wrote:
> On Fri, Jun 28, 2019 at 10:43:02PM +0100, Sheriff Esseson wrote:
> > 	Convert xfs.txt to ReST, markup and rename accordingly. Update
> > 	Documentation/index.rst.
> 
> Didn't get_maintainers.pl suggest that you cc the linux-xfs mailing list?

No, because we suck. :(

> You also need to update MAINTAINERS.

Yes, please. :)

> > 	While at it, make "value" in "option=value" form xfs options definable by
> > 	the user, by embedding in angle "<>" brackets, rather than something
> > 	predifined elsewhere. This is inline with the conventions in manuals.
> > 	
> > 	Also, make defaults of boolean options prefixed with "(*)". This is
> > 	so that options can be compressed to "[no]option" and on a single line, which renders
> > 	consistently and nicely in htmldocs.
> > 	lastly, enforce a "one option, one definition" policy to keep things
> > 	consistent and simple.
> > 
> > Signed-off-by: Sheriff Esseson <sheriffesseson@gmail.com>
> > ---
> >  Documentation/filesystems/index.rst           |   1 +
> >  .../filesystems/{xfs.txt => xfs.rst}          | 190 ++++++++++--------
> >  2 files changed, 103 insertions(+), 88 deletions(-)
> >  rename Documentation/filesystems/{xfs.txt => xfs.rst} (74%)
> > 
> > diff --git a/Documentation/filesystems/index.rst b/Documentation/filesystems/index.rst
> > index 1131c34d7..be91fe616 100644
> > --- a/Documentation/filesystems/index.rst
> > +++ b/Documentation/filesystems/index.rst
> > @@ -41,3 +41,4 @@ Documentation for individual filesystem types can be found here.
> >     :maxdepth: 2
> >  
> >     binderfs.rst
> > +   xfs.rst
> 
> I believe the convention is to not include the .rst suffix (and yes,
> binderfs is wrong here).
>
> > diff --git a/Documentation/filesystems/xfs.txt b/Documentation/filesystems/xfs.rst
> > similarity index 74%
> > rename from Documentation/filesystems/xfs.txt
> > rename to Documentation/filesystems/xfs.rst
> > index a5cbb5e0e..5e29e1583 100644
> > --- a/Documentation/filesystems/xfs.txt
> > +++ b/Documentation/filesystems/xfs.rst
> > @@ -1,4 +1,4 @@
> > -
> > +======================
> >  The SGI XFS Filesystem
> >  ======================
> >  
> > @@ -18,10 +18,10 @@ Mount Options
> >  =============
> >  
> >  When mounting an XFS filesystem, the following options are accepted.
> > -For boolean mount options, the names with the (*) suffix is the
> > +For boolean mount options, the names with the "(*)" prefix is the
> >  default behaviour.
> >  
> > -  allocsize=size
> > +   allocsize=<size>
> >  	Sets the buffered I/O end-of-file preallocation size when
> >  	doing delayed allocation writeout (default size is 64KiB).
> >  	Valid values for this option are page size (typically 4KiB)
> > @@ -34,181 +34,195 @@ default behaviour.
> >  	to the file. Specifying a fixed allocsize value turns off
> >  	the dynamic behaviour.
> >  
> > -  attr2
> > -  noattr2
> > +   [no]attr2
> >  	The options enable/disable an "opportunistic" improvement to
> >  	be made in the way inline extended attributes are stored
> >  	on-disk.  When the new form is used for the first time when
> > -	attr2 is selected (either when setting or removing extended
> > +	``attr2`` is selected (either when setting or removing extended
> >  	attributes) the on-disk superblock feature bit field will be
> >  	updated to reflect this format being in use.
> >  
> >  	The default behaviour is determined by the on-disk feature
> > -	bit indicating that attr2 behaviour is active. If either
> > -	mount option it set, then that becomes the new default used
> > -	by the filesystem.
> > -
> > -	CRC enabled filesystems always use the attr2 format, and so
> > -	will reject the noattr2 mount option if it is set.
> > +	bit indicating that ``attr2`` behaviour is active. If either
> > +	mount options is set, then that becomes the new default used

"If either mount option is set..."

> > +	by the filesystem. However on CRC enabled filesystems, the
> > +        ``attr2`` format is always used , and so
> > +	will reject the ``noattr2`` mount option if it is set.
> >  
> > -  discard
> > -  nodiscard (*)
> > +   (*)[no]discard
> >  	Enable/disable the issuing of commands to let the block
> >  	device reclaim space freed by the filesystem.  This is
> >  	useful for SSD devices, thinly provisioned LUNs and virtual
> >  	machine images, but may have a performance impact.
> >  
> > -	Note: It is currently recommended that you use the fstrim
> > -	application to discard unused blocks rather than the discard
> > +	Note: It is currently recommended that you use the ``fstrim``
> > +	application to discard unused blocks rather than the ``discard``
> >  	mount option because the performance impact of this option
> >  	is quite severe.
> >  
> > -  grpid/bsdgroups
> > -  nogrpid/sysvgroups (*)
> > +   grpid/bsdgroups
> > +   nogrpid/(*)sysvgroups
> >  	These options define what group ID a newly created file
> > -	gets.  When grpid is set, it takes the group ID of the
> > +	gets.  When ``grpid`` is set, it takes the group ID of the
> >  	directory in which it is created; otherwise it takes the
> > -	fsgid of the current process, unless the directory has the
> > -	setgid bit set, in which case it takes the gid from the
> > -	parent directory, and also gets the setgid bit set if it is
> > +	``fsgid`` of the current process, unless the directory has the
> > +	``setgid`` bit set, in which case it takes the ``gid`` from the
> > +	parent directory, and also gets the ``setgid`` bit set if it is
> >  	a directory itself.
> >  
> > -  filestreams
> > +   filestreams
> >  	Make the data allocator use the filestreams allocation mode
> >  	across the entire filesystem rather than just on directories
> >  	configured to use it.
> >  
> > -  ikeep
> > -  noikeep (*)
> > -	When ikeep is specified, XFS does not delete empty inode
> > -	clusters and keeps them around on disk.  When noikeep is
> > +   (*)[no]ikeep
> > +	When ``ikeep`` is specified, XFS does not delete empty inode
> > +	clusters and keeps them around on disk.  When ``noikeep`` is
> >  	specified, empty inode clusters are returned to the free
> >  	space pool.
> >  
> > -  inode32
> > -  inode64 (*)
> > -	When inode32 is specified, it indicates that XFS limits
> > +   inode32 | (*)inode64
> > +	When ``inode32`` is specified, it indicates that XFS limits
> >  	inode creation to locations which will not result in inode
> >  	numbers with more than 32 bits of significance.
> >  
> > -	When inode64 is specified, it indicates that XFS is allowed
> > +	When ``inode64`` is specified, it indicates that XFS is allowed
> >  	to create inodes at any location in the filesystem,
> >  	including those which will result in inode numbers occupying
> > -	more than 32 bits of significance. 
> > +	more than 32 bits of significance.
> >  
> > -	inode32 is provided for backwards compatibility with older
> > +	``inode32`` is provided for backwards compatibility with older
> >  	systems and applications, since 64 bits inode numbers might
> >  	cause problems for some applications that cannot handle
> >  	large inode numbers.  If applications are in use which do
> > -	not handle inode numbers bigger than 32 bits, the inode32
> > +	not handle inode numbers bigger than 32 bits, the ``inode32``
> >  	option should be specified.
> >  
> >  
> > -  largeio
> > -  nolargeio (*)
> > -	If "nolargeio" is specified, the optimal I/O reported in
> > -	st_blksize by stat(2) will be as small as possible to allow
> > +   (*)[no]largeio
> > +	If ``nolargeio`` is specified, the optimal I/O reported in
> > +	st_blksize by **stat(2)** will be as small as possible to allow
> >  	user applications to avoid inefficient read/modify/write
> >  	I/O.  This is typically the page size of the machine, as
> >  	this is the granularity of the page cache.
> >  
> > -	If "largeio" specified, a filesystem that was created with a
> > -	"swidth" specified will return the "swidth" value (in bytes)
> > -	in st_blksize. If the filesystem does not have a "swidth"
> > -	specified but does specify an "allocsize" then "allocsize"
> > +	If ``largeio`` specified, a filesystem that was created with a

"If ``largeio`` is specified..."

> > +	``swidth`` specified will return the ``swidth`` value (in bytes)
> > +	in st_blksize. If the filesystem does not have a ``swidth``
> > +	specified but does specify an ``allocsize`` then ``allocsize``
> >  	(in bytes) will be returned instead. Otherwise the behaviour
> > -	is the same as if "nolargeio" was specified.
> > +	is the same as if ``nolargeio`` was specified.
> >  
> > -  logbufs=value
> > -	Set the number of in-memory log buffers.  Valid numbers
> > +   logbufs=<value>
> > +	Set the number of in-memory log buffers to ``value``.  Valid numbers
> >  	range from 2-8 inclusive.
> >  
> >  	The default value is 8 buffers.
> >  
> >  	If the memory cost of 8 log buffers is too high on small
> >  	systems, then it may be reduced at some cost to performance
> > -	on metadata intensive workloads. The logbsize option below
> > +	on metadata intensive workloads. The ``logbsize`` option below
> >  	controls the size of each buffer and so is also relevant to
> >  	this case.
> >  
> > -  logbsize=value
> > -	Set the size of each in-memory log buffer.  The size may be
> > -	specified in bytes, or in kilobytes with a "k" suffix.
> > +   logbsize=<value>
> > +	Set the size of each in-memory log buffer to ``value``.  The size
> > +        may be specified in bytes, or in kilobytes with a "k" suffix.

Why the indentation here?

> >  	Valid sizes for version 1 and version 2 logs are 16384 (16k)
> >  	and 32768 (32k).  Valid sizes for version 2 logs also
> >  	include 65536 (64k), 131072 (128k) and 262144 (256k). The
> > -	logbsize must be an integer multiple of the log
> > -	stripe unit configured at mkfs time.
> > +	``logbsize`` must be an integer multiple of the
> > +        "log stripe unit" configured at mkfs time.

Or here?

> >  
> >  	The default value for for version 1 logs is 32768, while the
> > -	default value for version 2 logs is MAX(32768, log_sunit).
> > +	default value for version 2 logs is ``MAX(32768, log_sunit)``.
> >  
> > -  logdev=device and rtdev=device
> > -	Use an external log (metadata journal) and/or real-time device.
> > -	An XFS filesystem has up to three parts: a data section, a log
> > -	section, and a real-time section.  The real-time section is
> > -	optional, and the log section can be separate from the data
> > -	section or contained within it.
> > +   logdev=<device>
> > +	Use ``device`` as an external log.

"...as an external log (metadata journal)."

> > +	In an XFS filesystem, the log section can be separate from
> > +        the data section or contained within it.

s/section/device/

Hmm, maybe it's time to just call them devices like everyone else on
Linux does.  I'd guess "section" is a holdover from IRIX(?)

> >  
> > -  noalign
> > +   rtdev=<device>
> > +        An XFS filesystem has up to three parts: a data section, a log
> > +	section, and a real-time section.  The real-time section is optional.
> > +        If enabled, ``rtdev`` sets ``device`` to be used as an
> > +        external real-time section, similar to ``logdev`` above.

Why indent here?

> > +   noalign
> >  	Data allocations will not be aligned at stripe unit
> >  	boundaries. This is only relevant to filesystems created
> >  	with non-zero data alignment parameters (sunit, swidth) by
> >  	mkfs.
> >  
> > -  norecovery
> > +   norecovery
> >  	The filesystem will be mounted without running log recovery.
> >  	If the filesystem was not cleanly unmounted, it is likely to
> > -	be inconsistent when mounted in "norecovery" mode.
> > +	be inconsistent when mounted in ``norecovery`` mode.
> >  	Some files or directories may not be accessible because of this.
> > -	Filesystems mounted "norecovery" must be mounted read-only or
> > +	Filesystems mounted ``norecovery`` must be mounted read-only or
> >  	the mount will fail.
> >  
> > -  nouuid
> > +   nouuid
> >  	Don't check for double mounted file systems using the file
> >  	system uuid.  This is useful to mount LVM snapshot volumes,
> > -	and often used in combination with "norecovery" for mounting
> > +	and often used in combination with ``norecovery`` for mounting
> >  	read-only snapshots.
> >  
> > -  noquota
> > +   noquota
> >  	Forcibly turns off all quota accounting and enforcement
> >  	within the filesystem.
> >  
> > -  uquota/usrquota/uqnoenforce/quota
> > +   uquota/usrquota/uqnoenforce/quota
> >  	User disk quota accounting enabled, and limits (optionally)
> > -	enforced.  Refer to xfs_quota(8) for further details.
> > +	enforced.  Refer to **xfs_quota(8)** for further details.
> >  
> > -  gquota/grpquota/gqnoenforce
> > +   gquota/grpquota/gqnoenforce
> >  	Group disk quota accounting enabled and limits (optionally)
> > -	enforced.  Refer to xfs_quota(8) for further details.
> > +	enforced.  Refer to **xfs_quota(8)** for further details.
> >  
> > -  pquota/prjquota/pqnoenforce
> > +   pquota/prjquota/pqnoenforce
> >  	Project disk quota accounting enabled and limits (optionally)
> > -	enforced.  Refer to xfs_quota(8) for further details.
> > +	enforced.  Refer to **xfs_quota(8)** for further details.
> >  
> > -  sunit=value and swidth=value
> > -	Used to specify the stripe unit and width for a RAID device
> > -	or a stripe volume.  "value" must be specified in 512-byte
> > -	block units. These options are only relevant to filesystems
> > +   sunit=<value>
> > +	Used to specify the stripe unit for a RAID device
> > +	or (in conjunction with ``swidth`` below) a stripe volume.  ``value`` must be specified in 512-byte

Long line?

> > +	block units. This option is only relevant to filesystems
> >  	that were created with non-zero data alignment parameters.
> >  
> > -	The sunit and swidth parameters specified must be compatible
> > +	The ``sunit`` parameter specified must be compatible
> >  	with the existing filesystem alignment characteristics.  In
> > -	general, that means the only valid changes to sunit are
> > -	increasing it by a power-of-2 multiple. Valid swidth values
> > -	are any integer multiple of a valid sunit value.
> > +	general, that means the only valid changes to ``sunit`` are
> > +	increasing it by a power-of-2 multiple.
> >  
> > -	Typically the only time these mount options are necessary if
> > -	after an underlying RAID device has had it's geometry
> > +	Typically, this mount option is necessary only
> > +	after an underlying RAID device has had its geometry
> >  	modified, such as adding a new disk to a RAID5 lun and
> >  	reshaping it.
> >  
> > -  swalloc
> > +   swidth=<value>
> > +        Used to specify the stripe width for a RAID device
> > +	or (in conjunction with ``sunit`` above) a stripe volume.  ``value`` must be specified in 512-byte

Line too long.

> > +	block units. This option, like ``sunit`` above, is only
> > +        relevant to filesystems that were created with non-zero data alignment parameters.

Why indent here?

> > +
> > +	The ``swidth`` parameter specified must be compatible
> > +	with the existing filesystem alignment characteristics.  In
> > +	general, that means the only valid swidth values
> > +	are any integer multiple of a valid ``sunit`` value.
> > +
> > +	Typically, this mount option is necessary only
> > +	after an underlying RAID device has had its geometry
> > +	modified, such as adding a new disk to a RAID5 lun and
> > +	reshaping it.
> > +
> > +
> > +   swalloc
> >  	Data allocations will be rounded up to stripe width boundaries
> >  	when the current end of file is being extended and the file
> >  	size is larger than the stripe width size.
> >  
> > -  wsync
> > +   wsync
> >  	When specified, all filesystem namespace operations are
> >  	executed synchronously. This ensures that when the namespace
> >  	operation (create, unlink, etc) completes, the change to the
> > @@ -302,27 +316,27 @@ The following sysctls are available for the XFS filesystem:
> >  
> >    fs.xfs.inherit_sync		(Min: 0  Default: 1  Max: 1)
> >  	Setting this to "1" will cause the "sync" flag set
> > -	by the xfs_io(8) chattr command on a directory to be
> > +	by the **xfs_io(8)** chattr command on a directory to be
> >  	inherited by files in that directory.
> >  
> >    fs.xfs.inherit_nodump		(Min: 0  Default: 1  Max: 1)
> >  	Setting this to "1" will cause the "nodump" flag set
> > -	by the xfs_io(8) chattr command on a directory to be
> > +	by the **xfs_io(8)** chattr command on a directory to be
> >  	inherited by files in that directory.
> >  
> >    fs.xfs.inherit_noatime	(Min: 0  Default: 1  Max: 1)
> >  	Setting this to "1" will cause the "noatime" flag set
> > -	by the xfs_io(8) chattr command on a directory to be
> > +	by the **xfs_io(8)** chattr command on a directory to be
> >  	inherited by files in that directory.
> >  
> >    fs.xfs.inherit_nosymlinks	(Min: 0  Default: 1  Max: 1)
> >  	Setting this to "1" will cause the "nosymlinks" flag set
> > -	by the xfs_io(8) chattr command on a directory to be
> > +	by the **xfs_io(8)** chattr command on a directory to be
> >  	inherited by files in that directory.
> >  
> >    fs.xfs.inherit_nodefrag	(Min: 0  Default: 1  Max: 1)
> >  	Setting this to "1" will cause the "nodefrag" flag set
> > -	by the xfs_io(8) chattr command on a directory to be
> > +	by the **xfs_io(8)** chattr command on a directory to be
> >  	inherited by files in that directory.

Otherwise, this looks good.  Thank you for taking on this conversion!

--D

> >  
> >    fs.xfs.rotorstep		(Min: 1  Default: 1  Max: 256)
> > -- 
> > 2.22.0
> > 
