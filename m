Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6AE336D9
	for <lists+linux-xfs@lfdr.de>; Mon,  3 Jun 2019 19:35:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728054AbfFCRfV (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 3 Jun 2019 13:35:21 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:53984 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726604AbfFCRfV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Jun 2019 13:35:21 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x53HJRQF125303;
        Mon, 3 Jun 2019 17:35:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=iU++RKt8ZirrTaub2nUQnvTeTQHFAMKpL9fbQgzWzK0=;
 b=FWwZmx27NE6/VwVptVs+cGCuBWw7xWIp2TbAf/2uhh5NmrMGXqRuBebVx1VyKKgEGDuO
 6K6mKaPgd0OlAPnd1Jk1MwiYyhvM12NrLl1Ev2hDkClUt50gELwhL+vvq+/c747ikLTv
 7flNZcTQXqkpr84/N7EDI4XQsIsvm+CHv6ps/blSlqtGK+gkx1/7Oy5mfmWx21lbCAAz
 OFCroiyCXW0VGMzHa8l7BudeC6trWE2fkcRM8EuyuEFh3NRGyY9Qc16E09CEFZtIxJR/
 rHLxLcDGSA3n6/7q7/b9afW3tH9AiAp7QC9GrsVjyaDl8+TMiXPnyIeJgq9eCy8LaYdo MA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 2suevd8nyu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Jun 2019 17:35:15 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x53HYDsS078632;
        Mon, 3 Jun 2019 17:35:15 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2supp784es-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Jun 2019 17:35:15 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x53HZEA2004139;
        Mon, 3 Jun 2019 17:35:14 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 03 Jun 2019 10:35:14 -0700
Date:   Mon, 3 Jun 2019 10:35:06 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: use bios directly in the log code v2
Message-ID: <20190603173506.GC5390@magnolia>
References: <20190603172945.13819-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190603172945.13819-1-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9277 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=580
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906030120
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9277 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=616 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906030120
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 03, 2019 at 07:29:25PM +0200, Christoph Hellwig wrote:
> Hi all,
> 
> this series switches the log writing and log recovery code to use bios
> directly, and remove various special cases from the buffer cache code.
> Note that I have developed it on top of the previous series of log item
> related cleanups, so if you don't have that applied there is a small

Hmm, /I/ don't have that applied. :/

Can you resend that series in its current form with (or without) all the
suggested review cleanups, please? :)

--D

> conflict.  To make life easier I have pushed out a git branche here:
> 
>     git://git.infradead.org/users/hch/xfs.git xfs-log-bio
> 
> Gitweb:
> 
>     http://git.infradead.org/users/hch/xfs.git/shortlog/refs/heads/xfs-log-bio
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
