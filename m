Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0045C1D18F8
	for <lists+linux-xfs@lfdr.de>; Wed, 13 May 2020 17:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731154AbgEMPUB (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 13 May 2020 11:20:01 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51962 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728692AbgEMPUB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 May 2020 11:20:01 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04DFHL62025624;
        Wed, 13 May 2020 15:19:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=lQzg+hTLBo5ADd2ibPbdibWF8nrD4PGyeob0tXg672I=;
 b=Mj8Cmpx4iaUNtjryWqUYua97OZVdscA+fps2R3IYoIV2Hz+Wbv6t22PD0PT5cdDokKVr
 2U9PGKqPWuN0wmOttcZh3spgdzpK5CdVXpL5Ji5uRZsNaVDYvthYMMC3ZC5f+S0Df4EJ
 +lObwHBowhaHrxvSv65g8vdZZO1TPRwJEgYUUypuOPvXM6dpV2GDSqkqk9lCRdCsCXwO
 BzKxG+nzJ9Bwc2XV4sYnbzHY94Thz7JqbFjmXEawax7wFrDgNyFQCKt4SCJ5La8qRRVl
 dW5zuJpF4gu7KIKqcuiDTQDIwrdDnxbaBhErTH3msgeg2d2clvau31koUS3FsUoQZLWj yQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 3100xwcv47-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 13 May 2020 15:19:57 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04DFHveR096257;
        Wed, 13 May 2020 15:17:57 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 3100yaqdd0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 May 2020 15:17:56 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04DFHtO6024996;
        Wed, 13 May 2020 15:17:55 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 13 May 2020 08:17:55 -0700
Date:   Wed, 13 May 2020 08:17:54 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] xfs: fix error code in xfs_iflush_cluster()
Message-ID: <20200513151754.GC1984748@magnolia>
References: <20200513094803.GF347693@mwanda>
 <20200513132904.GE44225@bfoster>
 <20200513133905.GB3041@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200513133905.GB3041@kadam>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9620 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 phishscore=0
 adultscore=0 suspectscore=1 mlxscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005130137
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9620 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 lowpriorityscore=0
 suspectscore=1 mlxlogscore=999 clxscore=1011 cotscore=-2147483648
 mlxscore=0 phishscore=0 adultscore=0 impostorscore=0 bulkscore=0
 malwarescore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005130137
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 13, 2020 at 04:39:05PM +0300, Dan Carpenter wrote:
> Oh yeah.  You're right.  This patch isn't correct.  Sorry about that.
> 
> I worry that there are several static analyzer's which will warn about
> this code...

/me wonders if this particular instance ought to have a breadcrumb to
remind future readers that we can handle the lack of memory, e.g.

cilist = kmem_alloc(..., KM_MAYFAIL...);
if (!cilist) {
	/* memory is tight, so defer the inode cluster flush */
	goto out_put;
}

--D

> regards,
> dan carpenter
> 
