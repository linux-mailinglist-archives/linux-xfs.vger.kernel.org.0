Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 758289EC3A
	for <lists+linux-xfs@lfdr.de>; Tue, 27 Aug 2019 17:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727219AbfH0PS1 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 27 Aug 2019 11:18:27 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38540 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726170AbfH0PS1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Aug 2019 11:18:27 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7RFB0am127563;
        Tue, 27 Aug 2019 15:18:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=rF6FVGJk8hsrQ1PYudJNJFI5+KDrVGyYB5L6PpTe938=;
 b=DaV9KGhyRGMfhLNRL3nOpS5w6QRQvn775PHZbhRiDd71W8Wvg4/eN7ca8Qco2FF9lZAb
 FYbZ6SXIDJAZnWRPPvJ8KfxmKyyeY0cLBrfKI3MyfeGeb0awoyrco+Z8CLJ4+zTKJpNP
 f885FhAcVmjY8zrSU6vzH1nj2RYKueHU0qIQwmvvH/285Vii+i+Q2Vu1+wfbbwpg12uC
 oTZih1uDGFFhfE9yvz/e28H3fBrEBcD+F/aAH2+H5QgWVpNqmeLqWzJGV/+fy9ZJ209U
 0q421O5bWL5HU+kNcm15aWtk2DweQXv9qKBznl7BpmMWJol0E+KyvwQCZCo+/4Xifwxx zQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2un6qtr6fb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Aug 2019 15:18:15 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7RFHYfa053860;
        Tue, 27 Aug 2019 15:18:14 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2umhu8vk63-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Aug 2019 15:18:14 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7RFID9w000366;
        Tue, 27 Aug 2019 15:18:13 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 27 Aug 2019 08:18:13 -0700
Date:   Tue, 27 Aug 2019 08:18:12 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: bmap scrub should only scrub records once
Message-ID: <20190827151812.GA1037350@magnolia>
References: <156685612356.2853532.10960947509015722027.stgit@magnolia>
 <156685612978.2853532.15764464511279169366.stgit@magnolia>
 <20190827131403.GG10636@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190827131403.GG10636@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9362 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908270156
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9362 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908270155
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 27, 2019 at 09:14:03AM -0400, Brian Foster wrote:
> On Mon, Aug 26, 2019 at 02:48:49PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > The inode block mapping scrub function does more work for btree format
> > extent maps than is absolutely necessary -- first it will walk the bmbt
> > and check all the entries, and then it will load the incore tree and
> > check every entry in that tree, possibly for a second time.
> > 
> > Simplify the code and decrease check runtime by separating the two
> > responsibilities.  The bmbt walk will make sure the incore extent
> > mappings are loaded, check the shape of the bmap btree (via xchk_btree)
> > and check that every bmbt record has a corresponding incore extent map;
> > and the incore extent map walk takes all the responsibility for checking
> > the mapping records and cross referencing them with other AG metadata.
> > 
> > This enables us to clean up some messy parameter handling and reduce
> > redundant code.  Rename a few functions to make the split of
> > responsibilities clearer.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/scrub/bmap.c |   76 ++++++++++++++++++++++++++++++---------------------
> >  1 file changed, 45 insertions(+), 31 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
> > index 1bd29fdc2ab5..f6ed6eb133a6 100644
> > --- a/fs/xfs/scrub/bmap.c
> > +++ b/fs/xfs/scrub/bmap.c
> ...
> > @@ -402,9 +396,25 @@ xchk_bmapbt_rec(
> >  		}
> >  	}
> >  
> > -	/* Set up the in-core record and scrub it. */
> > +	/*
> > +	 * Check that the incore extent tree contains an extent that matches
> > +	 * this one exactly.  We validate those cached bmaps later, so we don't
> > +	 * need to check them here.  If the extent tree was freshly loaded by
> > +	 * the scrubber then we skip the check entirely.
> > +	 */
> > +	if (info->was_loaded)
> > +		return 0;
> > +
> 
> This all looks fine to me except that I don't follow the reasoning for
> skipping the lookup from the comment. Are we just saying that if we
> loaded the extent tree, then we can assume it reflects what is on disk?
> If so, can we fix up the last sentence in the comment to explain?

Yes.

"If the incore extent tree was just loaded from disk by the scrubber,
we assume that its contents match what's on disk and skip the
equivalence check." ?

--D

> Brian
> 
> >  	xfs_bmbt_disk_get_all(&rec->bmbt, &irec);
> > -	return xchk_bmap_extent(ip, bs->cur, info, &irec);
> > +	if (!xfs_iext_lookup_extent(ip, ifp, irec.br_startoff, &icur,
> > +				&iext_irec) ||
> > +	    irec.br_startoff != iext_irec.br_startoff ||
> > +	    irec.br_startblock != iext_irec.br_startblock ||
> > +	    irec.br_blockcount != iext_irec.br_blockcount ||
> > +	    irec.br_state != iext_irec.br_state)
> > +		xchk_fblock_set_corrupt(bs->sc, info->whichfork,
> > +				irec.br_startoff);
> > +	return 0;
> >  }
> >  
> >  /* Scan the btree records. */
> > @@ -415,15 +425,26 @@ xchk_bmap_btree(
> >  	struct xchk_bmap_info	*info)
> >  {
> >  	struct xfs_owner_info	oinfo;
> > +	struct xfs_ifork	*ifp = XFS_IFORK_PTR(sc->ip, whichfork);
> >  	struct xfs_mount	*mp = sc->mp;
> >  	struct xfs_inode	*ip = sc->ip;
> >  	struct xfs_btree_cur	*cur;
> >  	int			error;
> >  
> > +	/* Load the incore bmap cache if it's not loaded. */
> > +	info->was_loaded = ifp->if_flags & XFS_IFEXTENTS;
> > +	if (!info->was_loaded) {
> > +		error = xfs_iread_extents(sc->tp, ip, whichfork);
> > +		if (!xchk_fblock_process_error(sc, whichfork, 0, &error))
> > +			goto out;
> > +	}
> > +
> > +	/* Check the btree structure. */
> >  	cur = xfs_bmbt_init_cursor(mp, sc->tp, ip, whichfork);
> >  	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, whichfork);
> >  	error = xchk_btree(sc, cur, xchk_bmapbt_rec, &oinfo, info);
> >  	xfs_btree_del_cursor(cur, error);
> > +out:
> >  	return error;
> >  }
> >  
> > @@ -671,13 +692,6 @@ xchk_bmap(
> >  	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
> >  		goto out;
> >  
> > -	/* Now try to scrub the in-memory extent list. */
> > -        if (!(ifp->if_flags & XFS_IFEXTENTS)) {
> > -		error = xfs_iread_extents(sc->tp, ip, whichfork);
> > -		if (!xchk_fblock_process_error(sc, whichfork, 0, &error))
> > -			goto out;
> > -	}
> > -
> >  	/* Find the offset of the last extent in the mapping. */
> >  	error = xfs_bmap_last_offset(ip, &endoff, whichfork);
> >  	if (!xchk_fblock_process_error(sc, whichfork, 0, &error))
> > @@ -689,7 +703,7 @@ xchk_bmap(
> >  	for_each_xfs_iext(ifp, &icur, &irec) {
> >  		if (xchk_should_terminate(sc, &error) ||
> >  		    (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
> > -			break;
> > +			goto out;
> >  		if (isnullstartblock(irec.br_startblock))
> >  			continue;
> >  		if (irec.br_startoff >= endoff) {
> > @@ -697,7 +711,7 @@ xchk_bmap(
> >  					irec.br_startoff);
> >  			goto out;
> >  		}
> > -		error = xchk_bmap_extent(ip, NULL, &info, &irec);
> > +		error = xchk_bmap_iextent(ip, &info, &irec);
> >  		if (error)
> >  			goto out;
> >  	}
> > 
