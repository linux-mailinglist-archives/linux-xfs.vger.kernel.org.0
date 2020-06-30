Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 196EA20FB44
	for <lists+linux-xfs@lfdr.de>; Tue, 30 Jun 2020 20:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390587AbgF3SBu (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 30 Jun 2020 14:01:50 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52920 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390565AbgF3SBt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Jun 2020 14:01:49 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05UHrPP3176822;
        Tue, 30 Jun 2020 18:01:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=hZpALcb2AHG3Unqm53/OvBAz8iBRFV4C4p6vWD/PR3Q=;
 b=Pr4IpB7qsvWHD7kWU/kmqlGvxWdKZQITiV4AI9BqvpxM+pK+UUU2/g4cy1EdPJ46Gj1O
 IiC3ktVy7pE9rLAGaDdzvPLkgzuB7SomOKT3god5Oi6RAjuEnxqfkPnhTjl5n9kr9W7s
 xnxrzR5ZYwS46Os3mQrQ8/kot6iiKRutzJR1CVq+RKOUDsG4tgLokiC4a29UKQyiZySe
 ivqSirS6BU9JvgwUTEocC1omrDzhHbDw829Y+ENyoKOEEi3PN6N615byq1gY4vL3daca
 hF2TPnQqYQ6aDPG1GMaXn8bM4oare16COfpXmq+b0BhOclEKSM/F6xgbQ2m7eXjZYJMC mA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 31ywrbmash-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 30 Jun 2020 18:01:45 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05UHqiUB038518;
        Tue, 30 Jun 2020 18:01:45 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 31xg141d0m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Jun 2020 18:01:44 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05UI1iJS004999;
        Tue, 30 Jun 2020 18:01:44 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 30 Jun 2020 18:01:43 +0000
Date:   Tue, 30 Jun 2020 11:01:43 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: xfs inode structure cleanups v2
Message-ID: <20200630180143.GN7606@magnolia>
References: <20200620071102.462554-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200620071102.462554-1-hch@lst.de>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9668 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=867 suspectscore=1 bulkscore=0 mlxscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006300123
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9668 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=887
 clxscore=1015 cotscore=-2147483648 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 mlxscore=0 adultscore=0 suspectscore=1 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006300123
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jun 20, 2020 at 09:10:47AM +0200, Christoph Hellwig wrote:
> Hi all,
> 
> This series cleans up how we define struct xfs_inode.  Most importantly
> it removes the pointles xfs_icdinode sub-structure.
> 
> Changes since v1:
>  - rebased to 5.8-rc
>  - use xfs_extlen_t fo i_cowextsize
>  - cleanup xfs_fill_fsxattr

Hm, ok, so this all looks reasonable.  Two questions about the series:

1) What do the xfsprogs changes look like?

2) Does Dave's inode flushing patchset(s) clash with this?  I think this
(and the quota cleanups I just posted) will go in after those iflush
changes, assuming we get the bugs worked out...

--D
