Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F554495E0
	for <lists+linux-xfs@lfdr.de>; Tue, 18 Jun 2019 01:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727419AbfFQXao (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 17 Jun 2019 19:30:44 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60254 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbfFQXao (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Jun 2019 19:30:44 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5HNTPhs188540;
        Mon, 17 Jun 2019 23:30:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=k+kWLzgtAizzYogxiIhnmfB5Fj2SLlrgXP1MKWQ4osQ=;
 b=pxf6Hrup5bS8XfYTBHjWnY3DyPGgkhkhOg0vEGElURG1UP1QR3LamotT9uCMPdeV+1hk
 67zHexI0Lod9JpU9cJ/Oia7mCjeDMuNHG5EawE/+WH0kY7L7nQ/5W5LLeWYNZtCyb0nr
 y7s9/vC5oHr8qmoTvggAR/8CSFrs0KwLtQHwCZdhpFoeqn4aB0LFpDI1m1DpL7DMiJ6B
 BrPmElsx5QL8lr2OXbpmhkWyq3Bz2owLHkDg7BADfT1brKtdat+F7liMGB1yUZOqmMdb
 0XBbilUVCKAsNi/MTP6PjMxQuRR81SyWtFlfWsSxFHuQHHMnxqnGYQAWV6E+YaiGPyZB Jg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2t4r3th6uv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Jun 2019 23:30:40 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5HNUPCj136580;
        Mon, 17 Jun 2019 23:30:39 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2t5mgbmmea-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Jun 2019 23:30:39 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5HNUbN2011211;
        Mon, 17 Jun 2019 23:30:38 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 17 Jun 2019 23:30:37 +0000
Date:   Mon, 17 Jun 2019 16:30:36 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: use bios directly in the log code v4
Message-ID: <20190617233036.GQ3773859@magnolia>
References: <20190605191511.32695-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190605191511.32695-1-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9291 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=955
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906170203
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9291 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906170203
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 05, 2019 at 09:14:47PM +0200, Christoph Hellwig wrote:
> Hi all,
> 
> this series switches the log writing and log recovery code to use bios
> directly, and remove various special cases from the buffer cache code.
> 
> A git tree is available here:
> 
>     git://git.infradead.org/users/hch/xfs.git xfs-log-bio
> 
> Gitweb:
> 
>     http://git.infradead.org/users/hch/xfs.git/shortlog/refs/heads/xfs-log-bio

I don't know if either (a) I'll find something in the other log cleanup
series to comment on or (b) if Dave has any further thoughts about
whatever it is he's doing with xfs_buf in userspace.  However, for
patches 1-15 and 17-24, I think this looks good enough for more
widespread testing, so...

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> 
> Chances since v3:
>  - add a few additional cleanup patches
>  - clean up iclog allocation
>  - drop a not required vmap invalidation
>  - better document the iclog size fields
>  - fix vmap invalidation
> 
> Changes since v2:
>  - rename the 'flush' flag to 'need_flush'
>  - spelling fixes
>  - minor cleanups
> 
> Changes since v1:
>  - rebased to not required the log item series first
>  - split the bio-related code out of xfs_log_recover.c into a new file
>    to ease using xfs_log_recover.c in xfsprogs
>  - use kmem_alloc_large instead of vmalloc to allocate the buffer
>  - additional minor cleanups
