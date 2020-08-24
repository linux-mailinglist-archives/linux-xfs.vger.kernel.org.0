Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 654D624F142
	for <lists+linux-xfs@lfdr.de>; Mon, 24 Aug 2020 04:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726904AbgHXCnz (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 23 Aug 2020 22:43:55 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46380 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726737AbgHXCnz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Aug 2020 22:43:55 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07O2hjJP137572;
        Mon, 24 Aug 2020 02:43:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=jmEc7LEX72M9J+SWhhgI/bXZ1snMJxDO6mGt0Wu/CL8=;
 b=vs5dk/WUlBPLcxqPSBcy5iJ/8NOSs2h2nCEZnpFH8jIGitSSsH56ZEjSUrIAgOabhyvv
 s856cuoefe1+KB8NL/5MnhFcmkF4nrVzpLf+p5F7FYEA1cty6qKk6L8T/WS6QXhORSP8
 PcHtcYqWWkSOgVTGmf4urzItzfs4sVU+8GKOskO6Ts9Mat1rBM9/MI1r4w3lbdKEGDqE
 FJ9Zc0kZrA3529pWQpvsauerl66O4tW80BSHRhNyNudBvj3rwfn41HGLswmV8IJTIOfP
 VN1R48/m+nfMeJCfuBtKH4zCgl30ZZ561qlOmgGdCSplwgXELCRTHEiyNAgXnpEtj4Vf lg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 333dbrj38n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 24 Aug 2020 02:43:45 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07O2eVv8145172;
        Mon, 24 Aug 2020 02:43:44 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 333rtvvege-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Aug 2020 02:43:44 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07O2hgvw029153;
        Mon, 24 Aug 2020 02:43:43 GMT
Received: from localhost (/10.159.140.7)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 23 Aug 2020 19:43:42 -0700
Date:   Sun, 23 Aug 2020 19:43:41 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org,
        sandeen@sandeen.net
Subject: Re: [PATCH 08/11] xfs: widen ondisk timestamps to deal with y2038
 problem
Message-ID: <20200824024341.GT6096@magnolia>
References: <159797588727.965217.7260803484540460144.stgit@magnolia>
 <159797594159.965217.2504039364311840477.stgit@magnolia>
 <20200822073319.GH1629@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200822073319.GH1629@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9722 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008240010
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9722 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 lowpriorityscore=0 suspectscore=1
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008240010
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Aug 22, 2020 at 08:33:19AM +0100, Christoph Hellwig wrote:
> >   * in the AGI header so that we can skip the finobt walk at mount time when
> > @@ -855,12 +862,18 @@ struct xfs_agfl {
> >   *
> >   * Inode timestamps consist of signed 32-bit counters for seconds and
> >   * nanoseconds; time zero is the Unix epoch, Jan  1 00:00:00 UTC 1970.
> > + *
> > + * When bigtime is enabled, timestamps become an unsigned 64-bit nanoseconds
> > + * counter.  Time zero is the start of the classic timestamp range.
> >   */
> >  union xfs_timestamp {
> >  	struct {
> >  		__be32		t_sec;		/* timestamp seconds */
> >  		__be32		t_nsec;		/* timestamp nanoseconds */
> >  	};
> > +
> > +	/* Nanoseconds since the bigtime epoch. */
> > +	__be64			t_bigtime;
> >  };
> 
> So do we really need the union here?  What about:
> 
>  (1) keep the typedef instead of removing it
>  (2) switch the typedef to be just a __be64, and use trivial helpers
>      to extract the two separate legacy sec/nsec field
>  (3) PROFIT!!!

Been there, done that.  Dave suggested some replacement code (which
corrupted the values), then I modified that into a correct version,
which then made smatch angry because it doesn't like code that does bit
shifts on __be64 values.

> > +/* Convert an ondisk timestamp into the 64-bit safe incore format. */
> >  void
> >  xfs_inode_from_disk_timestamp(
> > +	struct xfs_dinode		*dip,
> >  	struct timespec64		*tv,
> >  	const union xfs_timestamp	*ts)
> 
> I think passing ts by value might lead to somewhat better code
> generation on modern ABIs (and older ABIs just fall back to pass
> by reference transparently).

Hm, ok.  I did not know that. :)

> >  {
> > +	if (dip->di_version >= 3 &&
> > +	    (dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_BIGTIME))) {
> 
> Do we want a helper for this condition?

Yes, yes we do.  Will add.

> > +		uint64_t		t = be64_to_cpu(ts->t_bigtime);
> > +		uint64_t		s;
> > +		uint32_t		n;
> > +
> > +		s = div_u64_rem(t, NSEC_PER_SEC, &n);
> > +		tv->tv_sec = s - XFS_INO_BIGTIME_EPOCH;
> > +		tv->tv_nsec = n;
> > +		return;
> > +	}
> > +
> >  	tv->tv_sec = (int)be32_to_cpu(ts->t_sec);
> >  	tv->tv_nsec = (int)be32_to_cpu(ts->t_nsec);
> 
> Nit: for these kinds of symmetric conditions and if/else feels a little
> more natural.
> 
> > +		xfs_log_dinode_to_disk_ts(from, &to->di_crtime, &from->di_crtime);
> 
> This adds a > 80 char line.

Do we care now that checkpatch has been changed to allow up to 100
columns?

> > +	if (from->di_flags2 & XFS_DIFLAG2_BIGTIME) {
> > +		uint64_t		t;
> > +
> > +		t = (uint64_t)(ts->tv_sec + XFS_INO_BIGTIME_EPOCH);
> > +		t *= NSEC_PER_SEC;
> > +		its->t_bigtime = t + ts->tv_nsec;
> 
> This calculation is dupliated in two places, might be worth
> adding a little helper (which will need to get the sec/nsec values
> passed separately due to the different structures).
> 
> > +		xfs_inode_to_log_dinode_ts(from, &to->di_crtime, &from->di_crtime);
> 
> Another line over 8 characters here.
> 
> > +	if (xfs_sb_version_hasbigtime(&mp->m_sb)) {
> > +		sb->s_time_min = XFS_INO_BIGTIME_MIN;
> > +		sb->s_time_max = XFS_INO_BIGTIME_MAX;
> > +	} else {
> > +		sb->s_time_min = XFS_INO_TIME_MIN;
> > +		sb->s_time_max = XFS_INO_TIME_MAX;
> > +	}
> 
> This is really a comment on the earlier patch, but maybe we should
> name the old constants with "OLD" or "LEGACY" or "SMALL" in the name?

Yes, good suggestion!

> > @@ -1494,6 +1499,10 @@ xfs_fc_fill_super(
> >  	if (XFS_SB_VERSION_NUM(&mp->m_sb) == XFS_SB_VERSION_5)
> >  		sb->s_flags |= SB_I_VERSION;
> >  
> > +	if (xfs_sb_version_hasbigtime(&mp->m_sb))
> > +		xfs_warn(mp,
> > + "EXPERIMENTAL big timestamp feature in use. Use at your own risk!");
> > +
> 
> Is there any good reason to mark this experimental?

As you and Dave have both pointed out, there are plenty of stupid bugs
still in this.  I think I'd like to have at least one EXPERIMENTAL cycle
to make sure I didn't commit anything pathologically stupid in here.

<cough> ext4 34-bit sign extension bug <cough>.

--D
