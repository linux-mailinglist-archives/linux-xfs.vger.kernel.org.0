Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10E3A180DA
	for <lists+linux-xfs@lfdr.de>; Wed,  8 May 2019 22:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbfEHUM6 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 8 May 2019 16:12:58 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:33350 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726709AbfEHUM6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 May 2019 16:12:58 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x48K48qK130898;
        Wed, 8 May 2019 20:12:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=2LyK9UuCmEZo8WWuQEIa2S4CtpBkNhfO069ba6P/Ep8=;
 b=tvgmcuscBjj1z4A+znd6SnoLJEKIF470b3hN7VAQ2W6LqB9vHcDoEh3uOQAXVhzznVcd
 +5R3s57RlHt/WK20krDd1/7h+xPCRSdqUy54Y+HuruAsyfBBXJX149sZUdB/sXI4Udq5
 CSE6Tz63HNQwI8CMaG2VJgEVyNmZlH//XoH5sYe1SC6rlq34QEApm2RdktXmuc/+hDvB
 2+G1HIQIbQ+IqRuKU/tUTCmqpw6g+aAFb9f6qZWi+wKCW+nqmwL+NutHBVSXUF4nAeZR
 CiN8ctzDp9MD78cFoUUULVOG+NmYkLojxnVUCR2neRLogWFuq5qiK/k33GjkY9ZIB8Em gQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 2s94b66p4a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 May 2019 20:12:36 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x48K96hg116066;
        Wed, 8 May 2019 20:10:36 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2s9ayfruv4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 May 2019 20:10:36 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x48KAYg7016748;
        Wed, 8 May 2019 20:10:34 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 08 May 2019 13:10:34 -0700
Date:   Wed, 8 May 2019 13:10:33 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        David Valin <dvalin@redhat.com>
Subject: Re: [PATCH] xfs: short circuit xfs_get_acl() if no acl is possible
Message-ID: <20190508201033.GW5207@magnolia>
References: <35128e32-d69b-316e-c8d6-8f109646390d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35128e32-d69b-316e-c8d6-8f109646390d@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9251 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905080123
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9251 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905080123
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 08, 2019 at 02:28:09PM -0500, Eric Sandeen wrote:
> If there are no attributes on the inode, don't go through the
> cost of memory allocation and callling xfs_attr_get when we
> already know we'll just get -ENOATTR.
> 
> Reported-by: David Valin <dvalin@redhat.com>
> Suggested-by: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
> index 8039e35147dd..b469b44e9e71 100644
> --- a/fs/xfs/xfs_acl.c
> +++ b/fs/xfs/xfs_acl.c
> @@ -132,6 +132,9 @@ xfs_get_acl(struct inode *inode, int type)
>  		BUG();
>  	}
>  
> +	if (!xfs_inode_hasattr(ip))
> +		return NULL;

This isn't going to cause problems if someone's adding an ACL to the
inode at the same time, right?

I'm assuming that's the case since we only would load inodes when
setting up a vfs inode but before any userspace can get its sticky
fingers all over the inode, but it sure would be nice to know that
for sure. :)

--D

> +
>  	/*
>  	 * If we have a cached ACLs value just return it, not need to
>  	 * go out to the disk.
> 
