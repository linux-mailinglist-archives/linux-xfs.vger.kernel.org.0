Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA20C13DF91
	for <lists+linux-xfs@lfdr.de>; Thu, 16 Jan 2020 17:07:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbgAPQEr (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 16 Jan 2020 11:04:47 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:43504 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726552AbgAPQEr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jan 2020 11:04:47 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00GG3LKd140348;
        Thu, 16 Jan 2020 16:04:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=wDAoey4IwBFB0mJccm/aOCqEnG9HNfJKN67VYPOoV3Q=;
 b=oH/Pghb2Ucqexg2DlOAI0W36KdZ9xafnx8RhKUnWdesHxg00E+BqxPjem7rFg9Dhft8M
 vCetkoNR9jE3f1G30jLt9AztVkvoAhnL/yYojeYJ/3QO/IYsCJli/HfPpcXdbzNS/gIJ
 Io3ber5AoBcRWasM8Mo6/R9klaxj/QOlqqWkJhs1yFIkEybnZyAYMJujva/cRx64oo7i
 IQHj1aAqSL5iuvo8vq9lOIuXmNKwWGIqQng095rrjnpIdIjk3ZokQowGuaICLm/po6zo
 IgRm1TUigpmty+wN4cNBTap3/DGxMgZYGrWkS8HNAMgijc8083q7e2bWyAjguXiwfMNd Rw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2xf74skdmj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 16:04:37 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00GG4WWu167091;
        Thu, 16 Jan 2020 16:04:37 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2xj61mtydj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 16:04:35 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00GG3Ogj028070;
        Thu, 16 Jan 2020 16:03:25 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 16 Jan 2020 08:03:24 -0800
Date:   Thu, 16 Jan 2020 08:03:23 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     "yukuai (C)" <yukuai3@huawei.com>
Cc:     guaneryu@gmail.com, jbacik@fusionio.com, fstests@vger.kernel.org,
        linux-xfs@vger.kernel.org, zhengbin13@huawei.com,
        yi.zhang@huawei.com
Subject: Re: [PATCH] xfs/126: fix that corrupt xattr might fail with a small
 probability
Message-ID: <20200116160323.GC2149943@magnolia>
References: <20200108092758.41363-1-yukuai3@huawei.com>
 <20200108162227.GD5552@magnolia>
 <3c7e9497-e0ed-23e4-ff9c-4b1c1a77c9fa@huawei.com>
 <20200109164615.GA8247@magnolia>
 <51e99fd5-617f-6558-7a04-c4a198139cdd@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51e99fd5-617f-6558-7a04-c4a198139cdd@huawei.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9502 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001160133
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9502 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001160133
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 16, 2020 at 08:22:00PM +0800, yukuai (C) wrote:
> 
> 
> ON 2020/1/10 0:46, Darrick J. Wong wrote:
> > It sounds like a reasonable idea, though I was suggesting doing the
> > snapshot-and-check in the xfs_db source, not fstests.
> 
> The problem is that blocktrash do changed some bits of the attr block,
> however, corrupt will still fail if the change is only inside the 'zero'
> range.
> 
> So, I think it's hard to fix the problem by doing the snapshot-and-check
> in the xfs_db source.

<nod>

I'm a little concerned about having a static seed though, since the
xfs_db rng isn't great.

Does adding "-o 4" to the blocktrash command make it work reliably?
That should be close enough to the start of the attrleaf block that
we'll reliably corrupt *some* amount of stuff in the header.

--D

> Thanks!
> Yu Kuai
> 
