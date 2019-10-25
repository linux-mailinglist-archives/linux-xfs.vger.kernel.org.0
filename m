Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAA68E50C1
	for <lists+linux-xfs@lfdr.de>; Fri, 25 Oct 2019 18:05:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503934AbfJYQFC (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 25 Oct 2019 12:05:02 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:47284 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393851AbfJYQFC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Oct 2019 12:05:02 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9PFwmS3113431;
        Fri, 25 Oct 2019 16:04:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=Z9DvPxhEyCLdzjfHtwGzeLdtnG05wEjex73ZIhTLAWY=;
 b=I8h2upPj9YrkH1tFMO84ub9PVwft3gJxvoThGXKcqOT82MdAshEaw6SzmG+c/GuMrY1G
 q5DFU4AiV9DWjZXy3xfRWb4rulPSYAjBQE5g2QrC/1yy2JSmMotSUUC0vpL2+mMOBW4N
 0UiIgcliwm/BHbi/gbWmLzYuvgoR1NEn61wjJuQRdpEFGLK44FHgs9t6xUI4+TVR1qF9
 X9SCHspKSoNIBfo5/A6W21tcDU06kRr1RV9OAr51r31hhdzguDGvxpBZhWxyIFSnO1L4
 UtuAN51DrMDdrWbuB1YpfboxJvAHbM0+Cln1XFoPzQQKfbS6q7aGH4ZuPsaIN/eIRWVf og== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2vqswu45wq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Oct 2019 16:04:51 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9PFwrYi049941;
        Fri, 25 Oct 2019 16:04:50 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2vug0er01w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Oct 2019 16:04:50 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9PG4nlw021404;
        Fri, 25 Oct 2019 16:04:49 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 25 Oct 2019 09:04:49 -0700
Date:   Fri, 25 Oct 2019 09:04:48 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: namecheck directory entry names before listing
 them
Message-ID: <20191025160448.GI913374@magnolia>
References: <157198048552.2873445.18067788660614948888.stgit@magnolia>
 <157198050564.2873445.4054092614183428143.stgit@magnolia>
 <20191025125628.GD16251@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191025125628.GD16251@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9421 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910250146
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9421 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910250146
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 25, 2019 at 05:56:28AM -0700, Christoph Hellwig wrote:
> On Thu, Oct 24, 2019 at 10:15:05PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Actually call namecheck on directory entry names before we hand them
> > over to userspace.
> 
> This looks sensible:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Note that we can remove the check for '/' from xfs_dir2_namecheck for
> currentl mainline, given that verify_dirent_name in common code now has
> that check.

We can't, because this is the same function that xfs_repair uses to
decide if a directory entry is garbage.

--D
