Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62D5C24359
	for <lists+linux-xfs@lfdr.de>; Tue, 21 May 2019 00:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbfETWJH (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 20 May 2019 18:09:07 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40242 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725810AbfETWJG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 May 2019 18:09:06 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4KLt1KH096696;
        Mon, 20 May 2019 22:09:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=psiVQp/W0vlqNlnUuqSsaisybl1WmwZK8yssdTyCi78=;
 b=mdcv8viS+B1tBB6ujAqCS3GCjo2O/i2d9fHvmGewNDAzKaPXqSugELH08GDGg7WdX4oI
 3esyEeZrg6fn4VzwX63Xm5dDiHpezY44vjlelf7SpMh8A3UyrD0xpnVAlv3PKLvr18X1
 hoiiivDafxGamqp0fjoqHQZaa33jCwicRCnJQRXK1f1HheQxo31Pb5JTKCxKC/GxSDjL
 IzwZb8JKGB3O8SPNr0NZfegONesGRmaPofz7XLGFPcDtqrtIhWidFqwGe2HoG6eVz8Vj
 c9YED+tnJS9xq1adMerR0oLNBju/ta9HA49u7wgjCGn5sa7hvXqEPCsmnYoYM1BKQazr 1w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2sjapq9nfq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 May 2019 22:09:01 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4KM80hT021607;
        Mon, 20 May 2019 22:09:00 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2sm046me8q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 May 2019 22:09:00 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x4KM90Hm012091;
        Mon, 20 May 2019 22:09:00 GMT
Received: from localhost (/10.159.247.197)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 May 2019 22:09:00 +0000
Date:   Mon, 20 May 2019 15:08:59 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/20] xfs: fix a trivial comment typo in the
 xfs_trans_committed_bulk
Message-ID: <20190520220859.GE5335@magnolia>
References: <20190517073119.30178-1-hch@lst.de>
 <20190517073119.30178-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190517073119.30178-2-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9263 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905200136
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9263 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905200136
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 17, 2019 at 09:31:00AM +0200, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_trans.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 912b42f5fe4a..19f91312561a 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -815,7 +815,7 @@ xfs_log_item_batch_insert(
>   *
>   * If we are called with the aborted flag set, it is because a log write during
>   * a CIL checkpoint commit has failed. In this case, all the items in the
> - * checkpoint have already gone through iop_commited and iop_unlock, which
> + * checkpoint have already gone through iop_committed and iop_unlock, which
>   * means that checkpoint commit abort handling is treated exactly the same
>   * as an iclog write error even though we haven't started any IO yet. Hence in
>   * this case all we need to do is iop_committed processing, followed by an
> -- 
> 2.20.1
> 
