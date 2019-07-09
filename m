Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5086638D1
	for <lists+linux-xfs@lfdr.de>; Tue,  9 Jul 2019 17:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbfGIPo4 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 9 Jul 2019 11:44:56 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:33414 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726055AbfGIPoz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Jul 2019 11:44:55 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x69FhpDM012771;
        Tue, 9 Jul 2019 15:44:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=/wzADajV2E/+Hy43stYBuuLltwxa7/mYu0GrbCUVsqI=;
 b=kBvYXxit7jQWYxB5L/JmaqvifmxPF7QT1myV/9L8/QxZ6lA/s+fQVoOa3ltk1+45vphO
 rbGMe9QqSUj1nqnZ18c/97/U1/ZlEVXH8978r4NzHodURei9ED9RSsRJGwRPgPTSanKd
 BUbMMOu1/T2CVHDSBmZzOax2Ujel+LMdQH7nKeyiraeIAuC8Z7x4gzTmGd1Cp50vLAGp
 sVR336SBJg2JmQ4w3SPcFRmOMaiGAXKNrHVFB68t4Iv7I5ldsaxq2Nj0v5qh3MncDweA
 oMrbfyumDOh6Ib2DfPzh76/iaULIXT1oorxO23Eo9IpduXHvGslIdWjJW0Ceo9LRQd2Y DA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2tjk2tn78x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Jul 2019 15:44:50 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x69FhAiK049010;
        Tue, 9 Jul 2019 15:44:49 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2tmwgx0c20-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Jul 2019 15:44:49 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x69FimDc028288;
        Tue, 9 Jul 2019 15:44:48 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 09 Jul 2019 08:44:48 -0700
Date:   Tue, 9 Jul 2019 08:44:47 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 19/24] xfs: use bios directly to read and write the log
 recovery buffers
Message-ID: <20190709154447.GR1404256@magnolia>
References: <20190605191511.32695-1-hch@lst.de>
 <20190605191511.32695-20-hch@lst.de>
 <20190708073740.GI7689@dread.disaster.area>
 <20190708161919.GN1404256@magnolia>
 <20190708213423.GA18177@lst.de>
 <20190708221508.GJ7689@dread.disaster.area>
 <20190709152330.GA3945@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190709152330.GA3945@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9313 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=881
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907090184
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9313 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=933 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907090184
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 09, 2019 at 05:23:30PM +0200, Christoph Hellwig wrote:
> On Tue, Jul 09, 2019 at 08:15:08AM +1000, Dave Chinner wrote:
> > That fixes the problem I saw, but I think bio_chain() needs some
> > more checks to prevent this happening in future. It's trivially
> > easy to chain the bios in the wrong order, very difficult to spot
> > in review, and difficult to trigger in testing as it requires
> > chain nesting and adverse IO timing to expose....
> 
> Not sure how we can better check it.  At best we can set a flag for a
> bio that is a chain "child" and complain if someone is calling
> submit_bio_wait, but that would only really cover the wait case.

I think submit_bio_wait ought to at least WARN_ON_ONCE if it was fed a
bio with bi_end_io already set, which at least would have made it more
obvious that we'd screwed something up in this case, even if the
detection was after we'd already done bio_chain in the wrong order.

Granted IIRC Dave sent a fix for a zeroout integer overflow a while ago
and Jens committed the patch with the debugging assertions removed, so
... yay?

Maybe we just need CONFIG_BLK_DEBUG for these kinds of assertions so
that ignorant clods like me have another line of defense against bugs
and the growing crowd of people who care about performance above
correctness can crash faster. <grumble>

> But one thing I planned to do is to lift xfs_chain_bio to the block
> layer so that people can use it for any kind of continuation bio
> instead of duplicating the logic.

That'll help, I suspect. :)

--D
