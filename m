Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A7753D1B7
	for <lists+linux-xfs@lfdr.de>; Tue, 11 Jun 2019 18:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390214AbfFKQGt (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 11 Jun 2019 12:06:49 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:50206 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391345AbfFKQGt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Jun 2019 12:06:49 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5BG4Het172737;
        Tue, 11 Jun 2019 16:06:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2018-07-02;
 bh=k+mMVdJK0vd3nLibOQ9kdE6vlhTL7VW0yTwjFrcvFTY=;
 b=kkdbTNF6GMVcd84aeiCqsVwXDPchcw4cmoKkQ23Gz269VDg86xg1AjjA3VMG3lqK+x0w
 RovdE/zKfPk3dqrNsDNLa1dVSK9OhA0Uh7AOiY21A8TBp66l4ujZBJOPSNF78KXXoIAn
 hCdcB8mggfQLZAGVTygNZcwRK7w8FXuaj0lGxuIueBgjolTi63J/hG5nIPn6qUm10chk
 25G4KA4K/P/UsB3pbClE6tgEZrbguKK1WvNx8+Rk4a3b4jaYJWXoZKrPi1FnD8+Ykp5X
 k2BnpRRpi+Z4HSbYn1NlytHAB2YEFfYPnotFBQNhZtM3PeMgmqtbNN8Mp7k/d6DfUPkz 8w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 2t02hepc5x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jun 2019 16:06:30 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5BG4m9C078281;
        Tue, 11 Jun 2019 16:06:29 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2t1jphhebk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jun 2019 16:06:29 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5BG6SWb015770;
        Tue, 11 Jun 2019 16:06:28 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 11 Jun 2019 09:06:28 -0700
Date:   Tue, 11 Jun 2019 09:06:27 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/10] xfs: poll waiting for quotacheck
Message-ID: <20190611160627.GS1871505@magnolia>
References: <155968496814.1657646.13743491598480818627.stgit@magnolia>
 <155968502703.1657646.17911228005649046316.stgit@magnolia>
 <20190611150712.GB10942@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190611150712.GB10942@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9284 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906110104
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9284 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906110104
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 11, 2019 at 11:07:12AM -0400, Brian Foster wrote:
> On Tue, Jun 04, 2019 at 02:50:27PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Create a pwork destroy function that uses polling instead of
> > uninterruptible sleep to wait for work items to finish so that we can
> > touch the softlockup watchdog.  IOWs, gross hack.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> 
> Seems reasonable given the quirky circumstances of quotacheck. Just a
> couple nits..
> 
> >  fs/xfs/xfs_iwalk.c |    3 +++
> >  fs/xfs/xfs_iwalk.h |    3 ++-
> >  fs/xfs/xfs_pwork.c |   21 +++++++++++++++++++++
> >  fs/xfs/xfs_pwork.h |    2 ++
> >  fs/xfs/xfs_qm.c    |    2 +-
> >  5 files changed, 29 insertions(+), 2 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
> > index 71ee1628aa70..c4a9c4c246b7 100644
> > --- a/fs/xfs/xfs_iwalk.c
> > +++ b/fs/xfs/xfs_iwalk.c
> > @@ -526,6 +526,7 @@ xfs_iwalk_threaded(
> >  	xfs_ino_t		startino,
> >  	xfs_iwalk_fn		iwalk_fn,
> >  	unsigned int		max_prefetch,
> > +	bool			polled,
> >  	void			*data)
> >  {
> >  	struct xfs_pwork_ctl	pctl;
> > @@ -556,5 +557,7 @@ xfs_iwalk_threaded(
> >  		startino = XFS_AGINO_TO_INO(mp, agno + 1, 0);
> >  	}
> >  
> > +	if (polled)
> > +		return xfs_pwork_destroy_poll(&pctl);
> >  	return xfs_pwork_destroy(&pctl);
> 
> Rather than have duplicate destruction paths, could we rework
> xfs_pwork_destroy_poll() to something like xfs_pwork_poll() that just
> does the polling and returns, then the caller can fall back into the
> current xfs_pwork_destroy()? I.e., this ends up looking like:
> 
> 	...
> 	/* poll to keep soft lockup watchdog quiet */
> 	if (polled)
> 		xfs_pwork_poll(&pctl);
> 	return xfs_pwork_destroy(&pctl);

Sounds good, will do!

> >  }
> ...
> > diff --git a/fs/xfs/xfs_pwork.c b/fs/xfs/xfs_pwork.c
> > index 19605a3a2482..3b885e0b52ac 100644
> > --- a/fs/xfs/xfs_pwork.c
> > +++ b/fs/xfs/xfs_pwork.c
> ...
> > @@ -97,6 +101,23 @@ xfs_pwork_destroy(
> >  	return pctl->error;
> >  }
> >  
> > +/*
> > + * Wait for the work to finish and tear down the control structure.
> > + * Continually poll completion status and touch the soft lockup watchdog.
> > + * This is for things like mount that hold locks.
> > + */
> > +int
> > +xfs_pwork_destroy_poll(
> > +	struct xfs_pwork_ctl	*pctl)
> > +{
> > +	while (atomic_read(&pctl->nr_work) > 0) {
> > +		msleep(1);
> > +		touch_softlockup_watchdog();
> > +	}
> 
> Any idea what the typical watchdog timeout is?

Usually 30s for the hangcheck timeout.

> I'm curious where the 1ms
> comes from and whether we could get away with anything larger. I realize
> that might introduce mount latency with the current sleep based
> implementation, but we could also consider a waitqueue and using
> something like wait_event_timeout() to schedule out for longer time
> periods and still wake up immediately when the count drops to 0.

That's a much better approach than this na�ve one which waits
unnecessarily after the pwork finishes; I'll replace it with this.
The kernel doesn't export the hang check timeout variable, so I think
I'll just set it to 1s, which should be infrequent enough not to use a
lot of CPU and frequent enough that we don't spew warnings everywhere.

--D

> Brian
> 
> > +
> > +	return xfs_pwork_destroy(pctl);
> > +}
> > +
> >  /*
> >   * Return the amount of parallelism that the data device can handle, or 0 for
> >   * no limit.
> > diff --git a/fs/xfs/xfs_pwork.h b/fs/xfs/xfs_pwork.h
> > index e0c1354a2d8c..08da723a8dc9 100644
> > --- a/fs/xfs/xfs_pwork.h
> > +++ b/fs/xfs/xfs_pwork.h
> > @@ -18,6 +18,7 @@ struct xfs_pwork_ctl {
> >  	struct workqueue_struct	*wq;
> >  	struct xfs_mount	*mp;
> >  	xfs_pwork_work_fn	work_fn;
> > +	atomic_t		nr_work;
> >  	int			error;
> >  };
> >  
> > @@ -45,6 +46,7 @@ int xfs_pwork_init(struct xfs_mount *mp, struct xfs_pwork_ctl *pctl,
> >  		unsigned int nr_threads);
> >  void xfs_pwork_queue(struct xfs_pwork_ctl *pctl, struct xfs_pwork *pwork);
> >  int xfs_pwork_destroy(struct xfs_pwork_ctl *pctl);
> > +int xfs_pwork_destroy_poll(struct xfs_pwork_ctl *pctl);
> >  unsigned int xfs_pwork_guess_datadev_parallelism(struct xfs_mount *mp);
> >  
> >  #endif /* __XFS_PWORK_H__ */
> > diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> > index e4f3785f7a64..de6a623ada02 100644
> > --- a/fs/xfs/xfs_qm.c
> > +++ b/fs/xfs/xfs_qm.c
> > @@ -1305,7 +1305,7 @@ xfs_qm_quotacheck(
> >  		flags |= XFS_PQUOTA_CHKD;
> >  	}
> >  
> > -	error = xfs_iwalk_threaded(mp, 0, xfs_qm_dqusage_adjust, 0, NULL);
> > +	error = xfs_iwalk_threaded(mp, 0, xfs_qm_dqusage_adjust, 0, true, NULL);
> >  	if (error)
> >  		goto error_return;
> >  
> > 
