Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5147E49622
	for <lists+linux-xfs@lfdr.de>; Tue, 18 Jun 2019 01:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbfFQX5v (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 17 Jun 2019 19:57:51 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:48010 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726685AbfFQX5v (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Jun 2019 19:57:51 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5HNn1Zm004881;
        Mon, 17 Jun 2019 23:57:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=zx1jLOgFcDfzE8yzH1LqeA6fZ7sWhGvXwu59mBGyfno=;
 b=PJT8ArKY/VUVoJVGx6EzvFVEEAdfyu2ZR+own0yLTaiN/n+KFvfJV6wxi9TgI0swPPOG
 yyIHxpaRuTd/2Zc4sD9TO87J3/9FR8CcMqSHXXzPuBNL2NoAqTtQu09hl95IvPJwDva8
 4g68aKR7X78IeVT0cZRU70L47NW5dDu79nzatIuQnnxrdF/Cc1SqmvwhUrd0Nv+aPaJ/
 rcEMCQ+NZCM2tVfK/8R9trOIdMIydqQoLtFlT9YOuBJzRGeFJ3TtCdjlS6WTeRaVSZLT
 F2AbWP8MPjsUKgZ8K1NVvuw2ld6hUlY/gAdBbpaCWexbjUpV0wnfpjtumvN3vsIeyM+q /w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2t4r3th8dp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Jun 2019 23:57:47 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5HNvKCm051340;
        Mon, 17 Jun 2019 23:57:46 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2t5h5tdygm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Jun 2019 23:57:46 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5HNvjUe025514;
        Mon, 17 Jun 2019 23:57:45 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 17 Jun 2019 16:57:45 -0700
Date:   Mon, 17 Jun 2019 16:57:44 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: misc log item related cleanups v2
Message-ID: <20190617235744.GR3773859@magnolia>
References: <20190613180300.30447-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190613180300.30447-1-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9291 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906170206
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9291 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906170206
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 13, 2019 at 08:02:40PM +0200, Christoph Hellwig wrote:
> Hi all,
> 
> I've recently been trying to debug issue related to latencies related to
> locked buffers and went all over our log item lifecycles for that.
> 
> It turns out a lot of code in that area is rather obsfucated and
> redundant.  This series is almost entirely cleanups, but there are lots
> of it.  The only exception is a fix for systematic memory leaks which
> appears entirely theoretical.
> 
> Note that this series sits on top of the series titled
> "use bios directly in the log code v4".  To make everyones life easier
> a git tree is available here:
> 
>     git://git.infradead.org/users/hch/xfs.git xfs-log-item-cleanup
> 
> Gitweb:
> 
>     http://git.infradead.org/users/hch/xfs.git/shortlog/refs/heads/xfs-log-item-cleanup

Generally looks good enough for wider testing, so for patches 1-4 and 6-20...

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> 
> 
> Changes since v1:
>  - improve a few commit messages
>  - add various comments
>  - minor code style fixes
>  - drop the patch to remove iop_pushed from the quotaoff item
>  - set XFS_LI_ABORTED earlier in xfs_trans_committed_bulk
