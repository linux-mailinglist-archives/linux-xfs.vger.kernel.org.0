Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E40D48A7A6
	for <lists+linux-xfs@lfdr.de>; Mon, 12 Aug 2019 21:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727177AbfHLT5t (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 12 Aug 2019 15:57:49 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:35864 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726200AbfHLT5t (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Aug 2019 15:57:49 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CJE3Zv099911;
        Mon, 12 Aug 2019 19:57:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=lWmlLtrurx18ZlQj3YD1B+kbSbv4Z8P6mnXsjJaaJjA=;
 b=DtxOq3jaMY3EQ5uWMTXe9uvxzcHqdn6jz8mmbGlOCq8PeeqNmXcvSozj59Lk4tngVUII
 nPghDPpEcQPbkLEmsX++wygEjsVMxqOeQjp5IMGp+5nXn97Pw4FQi4WWCijSaRKgesez
 lh4UdL4gMKqpn2Y+T5MHuFtGUZIJzthz/LafP9/0gK/T8D1EAGFKwFfQ2jJKlO67axU9
 MiqSrzikSMvWEKelDqEsJMSY6LvsIDWRFgYq5DfQGH95Vv545bhiKQH4TO4O21QgBIED
 mZ1d/bcK3N1H4KwJ6LHJt14iP9rhXsfvsdqM6cUh7aqqCquF2QUcNfa3Ix+uKoCk1sW1 fQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=lWmlLtrurx18ZlQj3YD1B+kbSbv4Z8P6mnXsjJaaJjA=;
 b=QBkbUDfNk1qGWgh75Aupst22dUw0sAGO6SloHrJpcLZcEr2J6kHzBA6AnBA1xsf2Mct3
 7T+baiyODoteg3FtdCEjUjphsSxtIqSPhB0C2pVMRDM5WUQUSKibpvO79aJxrJ5aR01/
 HoGgoWy2n9ecFabwVhCNRYwELBvoWgxbRB5NPzS/N1AEGlY5TBRub3BjP+h8iXIY09RX
 V8V2ldQ4o0K4LyAgFCQhyEeX45QU5LgAzR4mgbvw7YhN0gIcqr3wHEcadxui5XNpk48c
 aZFqvMS8CiJ9t47zClrhBPeM3Vg1/rPX2VeMFturMvud8Z9WTE7B7ndVzGAlVefQRETG fw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2u9nbt9vn9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Aug 2019 19:57:35 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CJDgkK163191;
        Mon, 12 Aug 2019 19:55:34 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2u9nre7qvu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Aug 2019 19:55:34 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7CJtXlN011284;
        Mon, 12 Aug 2019 19:55:33 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 12 Aug 2019 12:55:33 -0700
Date:   Mon, 12 Aug 2019 12:55:30 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     Luis Chamberlain <mcgrof@kernel.org>, linux-xfs@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>,
        Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] fs: xfs: xfs_log: Don't use KM_MAYFAIL at
 xfs_log_reserve().
Message-ID: <20190812195530.GK7138@magnolia>
References: <20190729215657.GI7777@dread.disaster.area>
 <1564653995-9004-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp>
 <20190801185057.GT30113@42.do-not-panic.com>
 <20190801204614.GD7138@magnolia>
 <20190802222158.GU30113@42.do-not-panic.com>
 <126f1f28-de58-815c-bd37-424a06216884@i-love.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <126f1f28-de58-815c-bd37-424a06216884@i-love.sakura.ne.jp>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908120198
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908120198
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 12, 2019 at 07:57:27PM +0900, Tetsuo Handa wrote:
> On 2019/08/03 7:21, Luis Chamberlain wrote:
> >> I'm pretty sure this didn't solve the underlying stale data exposure
> >> problem, which might be why you think this is "opaque".  It fixes a bug
> >> that causes data writeback failure (which was the exposure vector this
> >> time) but I think the ultimate fix for the exposure problem are the two
> >> patches I linked to quite a ways back in this discussion....
> >>
> >> --D
> >>
> >> https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/commit/?id=bd012b434a56d9fac3cbc33062b8e2cd6e1ad0a0
> >> https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/commit/?id=adcf7c0c87191fd3616813c8ce9790f89a9a8eba
> > 
> > Got it, thanks! Even with this, I still think the current commit could
> > say a bit a more about the effects of not having this patch applied.
> > What are the effects of say having the above two patches applied but not
> > the one being submitted now?
> 
> Is this patch going to be applied as-is? Or, someone have a plan to
> rewrite the changelog?

The first one, since the patch eliminates a vector to the writeback race
problem but does not iself solve the race.

--D
