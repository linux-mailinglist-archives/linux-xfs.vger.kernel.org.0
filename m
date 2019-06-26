Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4524561ED
	for <lists+linux-xfs@lfdr.de>; Wed, 26 Jun 2019 07:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725954AbfFZF5N (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 26 Jun 2019 01:57:13 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:33532 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbfFZF5M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Jun 2019 01:57:12 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5Q5rwfw057223;
        Wed, 26 Jun 2019 05:57:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=JqOsYII0nKkXJFnUJO3utIoPo+dD2hXYSVkmsb99lhQ=;
 b=UFjDAwfMPzYRdJEzUzvefqjgKdnHxdBvRjt/1aHYaLgTRgayAB6+oB3QXnArycCRMmXv
 v+HQc5iX3oN8tq1YxGX74OpkjJzRMKDTCyTN0sxdwTAKCNAbWsqlafBx9hqg//142JJR
 ygbQ1kgyHXUJW+4UaA7rK0iZkwA1oiutDQ9qQQWwcyhDrgDMUoxwN9n9ZSlTxGlysfb4
 M2ZVH/CS990sx8LW7LHcrma+5IiKD3QZNCeH8i3GpEImOnrhdxJYLHr32O9O1N8/ZDRR
 OdqnmqXjvwlZinYWmc/sE6bVygGWv3JIxwSU41Lh1GprnGt/St2tBu0v1io6WH82YhNR bg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2t9brt85rf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jun 2019 05:57:04 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5Q5umt7025813;
        Wed, 26 Jun 2019 05:57:03 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2t9p6uk70d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jun 2019 05:57:03 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5Q5v2II022892;
        Wed, 26 Jun 2019 05:57:02 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 25 Jun 2019 22:57:02 -0700
Date:   Tue, 25 Jun 2019 22:57:01 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: Re: xfs cgroup writeback support
Message-ID: <20190626055701.GA5171@magnolia>
References: <20190624134315.21307-1-hch@lst.de>
 <20190625032527.GF1611011@magnolia>
 <20190625100532.GE1462@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190625100532.GE1462@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9299 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906260071
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9299 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906260071
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 25, 2019 at 12:05:32PM +0200, Christoph Hellwig wrote:
> On Mon, Jun 24, 2019 at 08:25:27PM -0700, Darrick J. Wong wrote:
> > By the way, did all the things Dave complained about in last year's
> > attempt[1] to add cgroup writeback support get fixed?  IIRC someone
> > whose name I didn't recognise complained about log starvation due to
> > REQ_META bios being charged to the wrong cgroup and other misbehavior.
> 
> As mentioned in the reference thread while the metadata throttling is
> an issue, it is in existing one and not one touched by the cgroup
> writeback support.  This patch just ensures that writeback takes the
> cgroup information from the inode instead of the current task.  The
> fact that blkcg should not even look at any cgroup information for
> REQ_META is something that should be fixed entirely in core cgroup
> code is orthogonal to how we pick the attached cgroup.

That may be, but I don't want to merge this patchset only to find out
I've unleashed Pandora's box of untested cgroupwb hell... I /think/ they
fixed all those problems, but it didn't take all that long tracing the
blkg/blkcg object relationships for my brain to fall out. :/

[Oh well I guess I'll try to turn all that on in my test vm and see if
its brain falls out overnight too...]

> > Also, I remember that in the earlier 2017 discussion[2] we talked about
> > a fstest to test that writeback throttling actually capped bandwidth
> > usage correctly.  I haven't been following cgroupwb development since
> > 2017 -- does it not ratelimit bandwidth now, or is there some test for
> > that?  The only test I could find was shared/011 which only tests the
> > accounting, not bandwidth.
> 
> As far as I can tell cfq could limit bandwith, but cgq is done now.
> Either way all that is hiddent way below us.

<shrug> ok?  I mean, if bandwidth limits died as a feature it'd be nice
to know that outright. :)

--D
