Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19B705A6E1
	for <lists+linux-xfs@lfdr.de>; Sat, 29 Jun 2019 00:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbfF1WZ5 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 28 Jun 2019 18:25:57 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58780 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726794AbfF1WZ4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Jun 2019 18:25:56 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5SMNlZn075196;
        Fri, 28 Jun 2019 22:25:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=Xk63QctdV+gNP3cEM0Lpgpb6wEQlky1baWa5fKG4rYo=;
 b=KyAcPWtAjAzsbaXi5i1s4kXpvFKuiCKHRjEopL/ZZZBEwM3JmhdR5Ct9LRryAKXz+/4F
 3LQ7BObtGtWcZAkgRORkgfME5vKEYis3DbXJvyHrYzr72ub8iXQphfZ5PWlzAGbjtpUP
 MkGn+ww+X4yfr8QFIl6sNf3GJRCkTMiL9inxSaKhTjIDEx+EBlN4bCPlucq5pjIWktmT
 Ju1IMIYXn98O6XYuZh+nPy0TIlZOxdN5KdeWB/jh/agL29+d4u+u1kDIt40h6pxpHst8
 W2RheE7ODPPshIhxkDn6oeSmVObqG7DOneGDuJk2eowrJ6OS8lXgVB5Gi9+exp2MnVET aQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2t9cyqymga-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Jun 2019 22:25:50 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5SMPdtc090305;
        Fri, 28 Jun 2019 22:25:50 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2tat7e64p9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Jun 2019 22:25:50 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5SMPnOF026037;
        Fri, 28 Jun 2019 22:25:49 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 28 Jun 2019 15:25:49 -0700
Date:   Fri, 28 Jun 2019 15:25:48 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        syzbot+b75afdbe271a0d7ac4f6@syzkaller.appspotmail.com
Subject: Re: [PATCH] xfs: fix iclog allocation size
Message-ID: <20190628222548.GE1404256@magnolia>
References: <20190627143950.19558-1-hch@lst.de>
 <20190628220253.GF30113@42.do-not-panic.com>
 <20190628221914.GD1404256@magnolia>
 <20190628222310.GL19023@42.do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190628222310.GL19023@42.do-not-panic.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9302 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=835
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906280256
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9302 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=888 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906280257
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 28, 2019 at 10:23:10PM +0000, Luis Chamberlain wrote:
> On Fri, Jun 28, 2019 at 03:19:14PM -0700, Darrick J. Wong wrote:
> > On Fri, Jun 28, 2019 at 10:02:53PM +0000, Luis Chamberlain wrote:
> > > On Thu, Jun 27, 2019 at 04:39:50PM +0200, Christoph Hellwig wrote:
> > > > Properly allocate the space for the bio_vecs instead of just one byte
> > > > per bio_vec.
> > > > 
> > > > Fixes: 991fc1d2e65e ("xfs: use bios directly to write log buffers")
> > > 
> > > I cannot find 991fc1d2e65e on Linus' tree, nor can I find the subject
> > > name patch on Linus' tree. I'm probably missing some context here?
> > 
> > This patch fixes a bug in for-next. :)
> 
> I figured as much but the commit in question is not even on linux-next
> for today, so I take it that line would be removed from the commit log?

It looks like it is to me...

https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?h=next-20190628&id=991fc1d2e65e381fe8db9038d9a139d45c948f4f

--D

>   Luis
