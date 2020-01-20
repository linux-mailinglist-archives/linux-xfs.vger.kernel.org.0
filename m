Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64605143415
	for <lists+linux-xfs@lfdr.de>; Mon, 20 Jan 2020 23:34:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729093AbgATWek (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 20 Jan 2020 17:34:40 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:48422 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728853AbgATWeT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Jan 2020 17:34:19 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00KMXZqY063250;
        Mon, 20 Jan 2020 22:34:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=wvK8pWCMSjf5qbByY+6jCqF7hGkxx/yf5a9fkXeHIWY=;
 b=atDTVjXD/1lsYw/xgiVPf4b0JrVOCChdwYXduXTZ8BrC12m0Fm41Aay3t/VvzB46YWTA
 bu9HVZeADLG+jT8/N26ZgjxdMmArYkaz7wpSHgBgcgmY/zjMrhyElMzjy6rODfqgqt7B
 uCPKOkqsy6I1qDP2EhOmF6aGk9nSEFnWDjD2b9CG2mAIgeE9dt1azrjHdFMp6YAfhIN/
 IQrUqpoo0JKq+uYOHFs7Gpk1nTbHp4Vz3Xpt2ro5922mpguadN5tSeS1b6Zi9f3SHu9A
 Q1BVlzUoKGhFdb/Guer8nvhyD4NnaNp6hDsNNEE73Z+80fvg1w5TnIPb1S85y2gV12hW zA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2xkseu9shw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Jan 2020 22:34:14 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00KMWxNY146912;
        Mon, 20 Jan 2020 22:34:13 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2xmbj4gpat-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Jan 2020 22:34:13 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00KMYBdo012629;
        Mon, 20 Jan 2020 22:34:12 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 Jan 2020 14:34:11 -0800
Date:   Mon, 20 Jan 2020 14:34:10 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     "zhengbin (A)" <zhengbin13@huawei.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: change return value of xfs_inode_need_cow to int
Message-ID: <20200120223410.GP8257@magnolia>
References: <1577087776-59093-1-git-send-email-zhengbin13@huawei.com>
 <20191223173246.GU7489@magnolia>
 <6f3d3a92-8e12-6ff6-0e08-71fd9ed3bfa7@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6f3d3a92-8e12-6ff6-0e08-71fd9ed3bfa7@huawei.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9506 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001200189
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9506 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001200189
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jan 19, 2020 at 05:04:38PM +0800, zhengbin (A) wrote:
> 
> On 2019/12/24 1:32, Darrick J. Wong wrote:
> > On Mon, Dec 23, 2019 at 03:56:16PM +0800, zhengbin wrote:
> >> Fixes coccicheck warning:
> >>
> >> fs/xfs/xfs_reflink.c:236:9-10: WARNING: return of 0/1 in function 'xfs_inode_need_cow' with return type bool
> >>
> >> Reported-by: Hulk Robot <hulkci@huawei.com>
> >> Signed-off-by: zhengbin <zhengbin13@huawei.com>
> >> ---
> >>  fs/xfs/xfs_reflink.c | 2 +-
> >>  fs/xfs/xfs_reflink.h | 2 +-
> >>  2 files changed, 2 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> >> index de45123..21eeb94 100644
> >> --- a/fs/xfs/xfs_reflink.c
> >> +++ b/fs/xfs/xfs_reflink.c
> >> @@ -223,7 +223,7 @@ xfs_reflink_trim_around_shared(
> >>  	}
> >>  }
> >>
> >> -bool
> >> +int
> >>  xfs_inode_need_cow(
> > I started to think "just fix this predicate so it doesn't return 1--"
> >
> > But then I realized that this is /not/ an inode predicate, it's a
> > reflink trim wrapper for block mappings.  "xfs_bmap_trim_cow" is a
> > somewhat better name, so I'll commit this with a name change.
> >
> > And yeah, we turned negative errno into bool and back to int.  Wow.
> >
> > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> Does this apply? I do not see it in linux-next

Errr, oops.  I forgot to put this in my branch.  Sorry about that. :/

--D

> >
> > --D
> >
> >>  	struct xfs_inode	*ip,
> >>  	struct xfs_bmbt_irec	*imap,
> >> diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
> >> index d18ad7f..9a288b2 100644
> >> --- a/fs/xfs/xfs_reflink.h
> >> +++ b/fs/xfs/xfs_reflink.h
> >> @@ -22,7 +22,7 @@ extern int xfs_reflink_find_shared(struct xfs_mount *mp, struct xfs_trans *tp,
> >>  		xfs_agblock_t *fbno, xfs_extlen_t *flen, bool find_maximal);
> >>  extern int xfs_reflink_trim_around_shared(struct xfs_inode *ip,
> >>  		struct xfs_bmbt_irec *irec, bool *shared);
> >> -bool xfs_inode_need_cow(struct xfs_inode *ip, struct xfs_bmbt_irec *imap,
> >> +int xfs_inode_need_cow(struct xfs_inode *ip, struct xfs_bmbt_irec *imap,
> >>  		bool *shared);
> >>
> >>  int xfs_reflink_allocate_cow(struct xfs_inode *ip, struct xfs_bmbt_irec *imap,
> >> --
> >> 2.7.4
> >>
> > .
> >
> 
