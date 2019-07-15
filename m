Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC0706975F
	for <lists+linux-xfs@lfdr.de>; Mon, 15 Jul 2019 17:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388225AbfGOPKJ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 15 Jul 2019 11:10:09 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:34772 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387849AbfGOPKI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Jul 2019 11:10:08 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6FF8uTw182350;
        Mon, 15 Jul 2019 15:09:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=xYC9s3CaYuMgC86KTTUoUWv/sga5Qu7SmLkX+eSoJGE=;
 b=LlJKEqWZtPXFD2fLIYkT3myZ/zT7IoloccPK97HR1WyhZ18E0p2oEfT3uvHAwLIMKjrV
 qztfFaTqjrxLo5rVifrjOZ6m2BSOb+KU/1Ox4JJmud8AziA9F7PHPyIo3suUN/9HhyPp
 fOZZ+fApxJAVLEgeU/BPURwVWJGUOUQIQVUflm4ruNhBwy4bWYG+9m9++5IbWAcllvOg
 5wLE85lhcn8x0i0jdhL9JhVk+MiFlwTMMt4tgEqa+VYfsHhlG5gJIOGY0A1m9fuGLwtk
 DWMia4CUamrJHwz7uPFTcu/imQEZhUJlnQVMGDdvCGPQSr1yaOBEuVWpW4v+wh8Cqtt1 2w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2tq6qtf4ys-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Jul 2019 15:09:52 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6FF7ZBA032620;
        Mon, 15 Jul 2019 15:09:51 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2tq742jt1j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Jul 2019 15:09:51 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x6FF9oWo012765;
        Mon, 15 Jul 2019 15:09:50 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 15 Jul 2019 08:09:49 -0700
Date:   Mon, 15 Jul 2019 08:09:50 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Eric Sandeen <sandeen@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] xfs: sync up xfs_trans_inode with userspace
Message-ID: <20190715150950.GA6147@magnolia>
References: <68ef2df9-3f8e-6547-4e2b-181bce30ca3c@redhat.com>
 <112d2e52-c96c-af83-7e53-5fca12448c76@redhat.com>
 <20190715113007.GB23406@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190715113007.GB23406@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9319 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907150181
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9319 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907150181
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 15, 2019 at 07:30:08AM -0400, Brian Foster wrote:
> On Fri, Jul 12, 2019 at 12:46:17PM -0500, Eric Sandeen wrote:
> > Add an XFS_ICHGTIME_CREATE case to xfs_trans_ichgtime() to keep in
> > sync with userspace.  (Currently no kernel caller sends this flag.)
> > 
> > Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> > ---
> > 
> > diff --git a/fs/xfs/libxfs/xfs_trans_inode.c b/fs/xfs/libxfs/xfs_trans_inode.c
> > index 93d14e47269d..a9ad90926b87 100644
> > --- a/fs/xfs/libxfs/xfs_trans_inode.c
> > +++ b/fs/xfs/libxfs/xfs_trans_inode.c
> > @@ -66,6 +66,10 @@ xfs_trans_ichgtime(
> >  		inode->i_mtime = tv;
> >  	if (flags & XFS_ICHGTIME_CHG)
> >  		inode->i_ctime = tv;
> > +	if (flags & XFS_ICHGTIME_CREATE) {
> > +		ip->i_d.di_crtime.t_sec = (int32_t)tv.tv_sec;
> > +		ip->i_d.di_crtime.t_nsec = (int32_t)tv.tv_nsec;
> > +	}
> 
> Could we add a "for libxfs" or some such one liner comment to this so
> long as this is unused in the kernel? With that:

FWIW I was planning (5.4) to fix xfs_ialloc to use ICHGTIME_CREATE, so
it won't be "for libxfs only" for long. :)

--D

> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> >  }
> >  
> >  /*
> > 
> > 
