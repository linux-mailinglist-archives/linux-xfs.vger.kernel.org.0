Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 387ED5A6CE
	for <lists+linux-xfs@lfdr.de>; Sat, 29 Jun 2019 00:19:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726586AbfF1WTZ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 28 Jun 2019 18:19:25 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:37862 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726563AbfF1WTZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Jun 2019 18:19:25 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5SMEH3l062948;
        Fri, 28 Jun 2019 22:19:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=5Pwp6t+rQxVJm6v1xTwZH/DaGpQC10dd6MgfCdyStkg=;
 b=Fy8wo3VTDF0gp4s8VNPIYKWBTGTA4Vn9TcWFCZLZ91zrvOYC1qQPnUNmIfLpCCBDJAl4
 6YzH+UTcywDC5A2I7XafI9Cq3Hu68jbXcX8ZmsJKTiUH0NrdVp6MZcYZJHt6I14wA8DJ
 kUrkTvuQArNqBG3Q8LnwZvmZuIHqPJpJtFPN9BRK0iRkFtm5MgALCyo/OK51XKp53RUn
 6GnvvTYJHA2+TGimyg6N9sLFHeLI9uhcMiSYMpKL+jAewP5eQx7oBUFvsiDnL10C6Pb9
 fyTaWu7eVL5ejaBxjvxzgfURE7PN8POqpu7HveCuQIY8AxqAt52MVHlP1WSs0Tr+4VJz Xw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2t9brtqqyr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Jun 2019 22:19:16 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5SMIrGJ032599;
        Fri, 28 Jun 2019 22:19:16 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2t9p6w4p54-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Jun 2019 22:19:16 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5SMJF5M031438;
        Fri, 28 Jun 2019 22:19:15 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 28 Jun 2019 15:19:15 -0700
Date:   Fri, 28 Jun 2019 15:19:14 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        syzbot+b75afdbe271a0d7ac4f6@syzkaller.appspotmail.com
Subject: Re: [PATCH] xfs: fix iclog allocation size
Message-ID: <20190628221914.GD1404256@magnolia>
References: <20190627143950.19558-1-hch@lst.de>
 <20190628220253.GF30113@42.do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190628220253.GF30113@42.do-not-panic.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9302 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=958
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906280255
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9302 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906280255
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 28, 2019 at 10:02:53PM +0000, Luis Chamberlain wrote:
> On Thu, Jun 27, 2019 at 04:39:50PM +0200, Christoph Hellwig wrote:
> > Properly allocate the space for the bio_vecs instead of just one byte
> > per bio_vec.
> > 
> > Fixes: 991fc1d2e65e ("xfs: use bios directly to write log buffers")
> 
> I cannot find 991fc1d2e65e on Linus' tree, nor can I find the subject
> name patch on Linus' tree. I'm probably missing some context here?

This patch fixes a bug in for-next. :)

--D

> > Reported-by: syzbot+b75afdbe271a0d7ac4f6@syzkaller.appspotmail.com
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/xfs/xfs_log.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > index 0f849b4095d6..e230f3c18ceb 100644
> > --- a/fs/xfs/xfs_log.c
> > +++ b/fs/xfs/xfs_log.c
> > @@ -1415,7 +1415,8 @@ xlog_alloc_log(
> >  	 */
> >  	ASSERT(log->l_iclog_size >= 4096);
> >  	for (i = 0; i < log->l_iclog_bufs; i++) {
> > -		size_t bvec_size = howmany(log->l_iclog_size, PAGE_SIZE);
> > +		size_t bvec_size = howmany(log->l_iclog_size, PAGE_SIZE) *
> > +				sizeof(struct bio_vec);
> >  
> >  		iclog = kmem_zalloc(sizeof(*iclog) + bvec_size, KM_MAYFAIL);
> >  		if (!iclog)
> > -- 
> > 2.20.1
> > 
