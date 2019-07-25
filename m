Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32180755B9
	for <lists+linux-xfs@lfdr.de>; Thu, 25 Jul 2019 19:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbfGYR2i (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 25 Jul 2019 13:28:38 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36766 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726547AbfGYR2i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jul 2019 13:28:38 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6PGuM2n007703;
        Thu, 25 Jul 2019 17:28:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=ZasOoQFf6k1tZJedSbcjVCVDAaqUUL2yGtpGzQIt/Lc=;
 b=Q5xc+IrukccsA473/Muk3LZvs+8eOnCMg8fzbvUU3uVdqRI9dWId0f9+4WMWoZHVVZb7
 DJtEcG5uNidy5jE3sc4FBm8Th0ozC5aT5SXiRgsdkCzfi2OGSCzqyDbCwyeWTadY4B9L
 kRWe7Y60HSpH88BqWJj7jg5zZmICfEjLnnby2zsMmpgFKeyQxzNPbkcA0lCl+UAECbdt
 lMl+atVuRRZoWy/mqD2v3R9TJL/FrqqeSq7IA8OteCafAyeiiPw/IWNSluHBWanx/YD2
 GGHTXN87l5h8sBg4xC9pG1Znf9aN44NgbcqFqWIHIBGOrS5iuV95S+Vw7mWctwZW4Ei6 hg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2tx61c5hmg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Jul 2019 17:28:32 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6PFwFx8008014;
        Thu, 25 Jul 2019 17:28:32 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2tyd3npx74-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Jul 2019 17:28:31 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6PHSUct024352;
        Thu, 25 Jul 2019 17:28:31 GMT
Received: from localhost (/10.144.111.83)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 25 Jul 2019 10:28:30 -0700
Date:   Thu, 25 Jul 2019 10:28:30 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: xfs: garbage file data inclusion bug under memory pressure
Message-ID: <20190725172830.GE1561054@magnolia>
References: <f7c3d69e-bbd4-244c-41d7-b03c923c5344@i-love.sakura.ne.jp>
 <20190725113231.GV7689@dread.disaster.area>
 <804d24cb-5b7c-4620-5a5f-4ec039472086@i-love.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <804d24cb-5b7c-4620-5a5f-4ec039472086@i-love.sakura.ne.jp>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9329 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1907250188
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9329 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1907250188
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 25, 2019 at 09:44:35PM +0900, Tetsuo Handa wrote:
> On 2019/07/25 20:32, Dave Chinner wrote:
> > You've had writeback errors. This is somewhat expected behaviour for
> > most filesystems when there are write errors - space has been
> > allocated, but whatever was to be written into that allocated space
> > failed for some reason so it remains in an uninitialised state....
> 
> This is bad for security perspective. The data I found are e.g. random
> source file, /var/log/secure , SQL database server's access log
> containing secret values...

Woot.  That's bad.

By any chance do the duo of patches:
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/commit/?id=bd012b434a56d9fac3cbc33062b8e2cd6e1ad0a0
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/commit/?id=adcf7c0c87191fd3616813c8ce9790f89a9a8eba

fix this problem?  I wrote them a while ago but I never got around to
quantifying how much of a performance impact they'd have.

> > For XFS and sequential writes, the on-disk file size is not extended
> > on an IO error, hence it should not expose stale data.  However,
> > your test code is not checking for errors - that's a bug in your
> > test code - and that's why writeback errors are resulting in stale
> > data exposure.  i.e. by ignoring the fsync() error,
> > the test continues writing at the next offset and the fsync() for
> > that new data write exposes the region of stale data in the
> > file where the previous data write failed by extending the on-disk
> > EOF past it....
> > 
> > So in this case stale data exposure is a side effect of not
> > handling writeback errors appropriately in the application.
> 
> But blaming users regarding not handling writeback errors is pointless
> when thinking from security perspective. A bad guy might be trying to
> steal data from inaccessible files.

My thoughts exactly.  I'm not sure what data is supposed to be read()
from a file after a write error <cough> but I'm pretty sure that
"someone else's discarded junk" is /not/ in that set.

> 
> > 
> > But I have to ask: what is causing the IO to fail? OOM conditions
> > should not cause writeback errors - XFS will retry memory
> > allocations until they succeed, and the block layer is supposed to
> > be resilient against memory shortages, too. Hence I'd be interested
> > to know what is actually failing here...
> 
> Yeah. It is strange that this problem occurs when close-to-OOM.
> But no failure messages at all (except OOM killer messages and writeback
> error messages).

That /is/ strange.  I wonder if your scsi driver is trying to allocate
memory, failing, and the block layer squishes that into EIO?

--D
