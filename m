Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF6B6E0A26
	for <lists+linux-xfs@lfdr.de>; Tue, 22 Oct 2019 19:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732511AbfJVRKc (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 22 Oct 2019 13:10:32 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:44430 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731061AbfJVRKc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Oct 2019 13:10:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571764230;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rrcGsQR3S3co0JJyk41fP0V8lVPOmdTvB3CY59fzcT0=;
        b=GIHldFES2TjDQgPWxUarrHiK4gQpZlaPDtcgoUw6OP2rG7SYPSorIhAR92R84+nrDc4Fjs
        mKFjNsM0svDUFU8O0PspoBPS/HdFhnzODDdbeV2asUSsLmih6lGISX/bqos18Qv9wGXL8a
        ymhxy4J+uNZmBUtTAhzIV5ASjK7W33E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-184-vOcsKx-_MeOK2OZp8LUM-g-1; Tue, 22 Oct 2019 13:10:26 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 62ED3800D49;
        Tue, 22 Oct 2019 17:10:25 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EDC3452F7;
        Tue, 22 Oct 2019 17:10:24 +0000 (UTC)
Date:   Tue, 22 Oct 2019 13:10:23 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 2/2] xfs: don't set bmapi total block req where
 minleft is sufficient
Message-ID: <20191022171023.GD51627@bfoster>
References: <20191021121322.25659-1-bfoster@redhat.com>
 <20191021121322.25659-3-bfoster@redhat.com>
 <20191022165147.GL913374@magnolia>
MIME-Version: 1.0
In-Reply-To: <20191022165147.GL913374@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: vOcsKx-_MeOK2OZp8LUM-g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 22, 2019 at 09:51:47AM -0700, Darrick J. Wong wrote:
> On Mon, Oct 21, 2019 at 08:13:22AM -0400, Brian Foster wrote:
> > xfs_bmapi_write() takes a total block requirement parameter that is
> > passed down to the block allocation code and is used to specify the
> > total block requirement of the associated transaction. This is used
> > to try and select an AG that can not only satisfy the requested
> > extent allocation, but can also accommodate subsequent allocations
> > that might be required to complete the transaction. For example,
> > additional bmbt block allocations may be required on insertion of
> > the resulting extent to an inode data fork.
> >=20
> > While it's important for callers to calculate and reserve such extra
> > blocks in the transaction, it is not necessary to pass the total
> > value to xfs_bmapi_write() in all cases. The latter automatically
> > sets minleft to ensure that sufficient free blocks remain after the
> > allocation attempt to expand the format of the associated inode
> > (i.e., such as extent to btree conversion, btree splits, etc).
> > Therefore, any callers that pass a total block requirement of the
> > bmap mapping length plus worst case bmbt expansion essentially
> > specify the additional reservation requirement twice. These callers
> > can pass a total of zero to rely on the bmapi minleft policy.
> >=20
> > Beyond being superfluous, the primary motivation for this change is
> > that the total reservation logic in the bmbt code is dubious in
> > scenarios where minlen < maxlen and a maxlen extent cannot be
> > allocated (which is more common for data extent allocations where
> > contiguity is not required). The total value is based on maxlen in
> > the xfs_bmapi_write() caller. If the bmbt code falls back to an
> > allocation between minlen and maxlen, that allocation will not
> > succeed until total is reset to minlen, which essentially throws
> > away any additional reservation included in total by the caller. In
> > addition, the total value is not reset until after alignment is
> > dropped, which means that such callers drop alignment far too
> > aggressively than necessary.
> >=20
> > Update all callers of xfs_bmapi_write() that pass a total block
> > value of the mapping length plus bmbt reservation to instead pass
> > zero and rely on xfs_bmapi_minleft() to enforce the bmbt reservation
> > requirement. This trades off slightly less conservative AG selection
> > for the ability to preserve alignment in more scenarios.
> > xfs_bmapi_write() callers that incorporate unrelated or additional
> > reservations in total beyond what is already included in minleft
> > must continue to use the former.
> >=20
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
>=20
> Hmm, /me wonders about the other xfs_bmapi_write cases (remote attrs,
> dir/attr allocations, and symlinks) which pass in a nonzero @total?  I
> guess those are metadata so we have no alignment requirements and
> over-reserving isn't a huge deal?
>=20

I skipped over callsites like symlink just because they appeared to use
total for things other than btree expansion. That's what the bmapi layer
already handles via minleft, so those calls where total is equivalent
are straightforward conversions. We could probably do further work to
clean up bma.total in a more general sense..

> I also wonder if the xfs_bmapi_write call in xfs_iomap_write_unwritten
> needs the same treatment, but the resblks calculation inexplicably(?)
> doubles itself.  Not sure why, since in the "splitting the middle of an
> extent" case we hold the ilock across both insertions, and one split
> should leave us with two half-full leaves, right?  (Maybe this is its
> own investigate-and-fix patch...)
>=20

Yeah, I'm guessing I skipped over that one without thinking too hard
about it because it doubles resblks, but I agree that calculation doesn't
make a whole lot of practical sense. I'll make a note to send another
patch for this one..

> <shrug> In the mean time, this part looks ok.
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
>=20

Thanks!

Brian

> --D
>=20
> > ---
> >  fs/xfs/libxfs/xfs_bmap.c | 1 -
> >  fs/xfs/xfs_bmap_util.c   | 4 ++--
> >  fs/xfs/xfs_dquot.c       | 4 ++--
> >  fs/xfs/xfs_iomap.c       | 4 ++--
> >  fs/xfs/xfs_reflink.c     | 4 ++--
> >  fs/xfs/xfs_rtalloc.c     | 3 +--
> >  6 files changed, 9 insertions(+), 11 deletions(-)
> >=20
> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > index c118577deaa9..65e38bd954d1 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.c
> > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > @@ -4505,7 +4505,6 @@ xfs_bmapi_convert_delalloc(
> >  =09bma.wasdel =3D true;
> >  =09bma.offset =3D bma.got.br_startoff;
> >  =09bma.length =3D max_t(xfs_filblks_t, bma.got.br_blockcount, MAXEXTLE=
N);
> > -=09bma.total =3D XFS_EXTENTADD_SPACE_RES(ip->i_mount, XFS_DATA_FORK);
> >  =09bma.minleft =3D xfs_bmapi_minleft(tp, ip, whichfork);
> >  =09if (whichfork =3D=3D XFS_COW_FORK)
> >  =09=09bma.flags =3D XFS_BMAPI_COWFORK | XFS_BMAPI_PREALLOC;
> > diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> > index 4f443703065e..15547e089565 100644
> > --- a/fs/xfs/xfs_bmap_util.c
> > +++ b/fs/xfs/xfs_bmap_util.c
> > @@ -964,8 +964,8 @@ xfs_alloc_file_space(
> >  =09=09xfs_trans_ijoin(tp, ip, 0);
> > =20
> >  =09=09error =3D xfs_bmapi_write(tp, ip, startoffset_fsb,
> > -=09=09=09=09=09allocatesize_fsb, alloc_type, resblks,
> > -=09=09=09=09=09imapp, &nimaps);
> > +=09=09=09=09=09allocatesize_fsb, alloc_type, 0, imapp,
> > +=09=09=09=09=09&nimaps);
> >  =09=09if (error)
> >  =09=09=09goto error0;
> > =20
> > diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> > index aeb95e7391c1..b924dbd63a7d 100644
> > --- a/fs/xfs/xfs_dquot.c
> > +++ b/fs/xfs/xfs_dquot.c
> > @@ -305,8 +305,8 @@ xfs_dquot_disk_alloc(
> >  =09/* Create the block mapping. */
> >  =09xfs_trans_ijoin(tp, quotip, XFS_ILOCK_EXCL);
> >  =09error =3D xfs_bmapi_write(tp, quotip, dqp->q_fileoffset,
> > -=09=09=09XFS_DQUOT_CLUSTER_SIZE_FSB, XFS_BMAPI_METADATA,
> > -=09=09=09XFS_QM_DQALLOC_SPACE_RES(mp), &map, &nmaps);
> > +=09=09=09XFS_DQUOT_CLUSTER_SIZE_FSB, XFS_BMAPI_METADATA, 0, &map,
> > +=09=09=09&nmaps);
> >  =09if (error)
> >  =09=09return error;
> >  =09ASSERT(map.br_blockcount =3D=3D XFS_DQUOT_CLUSTER_SIZE_FSB);
> > diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> > index f780e223b118..27f2030690e2 100644
> > --- a/fs/xfs/xfs_iomap.c
> > +++ b/fs/xfs/xfs_iomap.c
> > @@ -277,8 +277,8 @@ xfs_iomap_write_direct(
> >  =09 * caller gave to us.
> >  =09 */
> >  =09nimaps =3D 1;
> > -=09error =3D xfs_bmapi_write(tp, ip, offset_fsb, count_fsb,
> > -=09=09=09=09bmapi_flags, resblks, imap, &nimaps);
> > +=09error =3D xfs_bmapi_write(tp, ip, offset_fsb, count_fsb, bmapi_flag=
s, 0,
> > +=09=09=09=09imap, &nimaps);
> >  =09if (error)
> >  =09=09goto out_res_cancel;
> > =20
> > diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> > index 0f08153b4994..3aa56cac1a47 100644
> > --- a/fs/xfs/xfs_reflink.c
> > +++ b/fs/xfs/xfs_reflink.c
> > @@ -410,8 +410,8 @@ xfs_reflink_allocate_cow(
> >  =09/* Allocate the entire reservation as unwritten blocks. */
> >  =09nimaps =3D 1;
> >  =09error =3D xfs_bmapi_write(tp, ip, imap->br_startoff, imap->br_block=
count,
> > -=09=09=09XFS_BMAPI_COWFORK | XFS_BMAPI_PREALLOC,
> > -=09=09=09resblks, imap, &nimaps);
> > +=09=09=09XFS_BMAPI_COWFORK | XFS_BMAPI_PREALLOC, 0, imap,
> > +=09=09=09&nimaps);
> >  =09if (error)
> >  =09=09goto out_unreserve;
> > =20
> > diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> > index 4a48a8c75b4f..d42b5a2047e0 100644
> > --- a/fs/xfs/xfs_rtalloc.c
> > +++ b/fs/xfs/xfs_rtalloc.c
> > @@ -792,8 +792,7 @@ xfs_growfs_rt_alloc(
> >  =09=09 */
> >  =09=09nmap =3D 1;
> >  =09=09error =3D xfs_bmapi_write(tp, ip, oblocks, nblocks - oblocks,
> > -=09=09=09=09=09XFS_BMAPI_METADATA, resblks, &map,
> > -=09=09=09=09=09&nmap);
> > +=09=09=09=09=09XFS_BMAPI_METADATA, 0, &map, &nmap);
> >  =09=09if (!error && nmap < 1)
> >  =09=09=09error =3D -ENOSPC;
> >  =09=09if (error)
> > --=20
> > 2.20.1
> >=20

