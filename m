Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6198F5213E
	for <lists+linux-xfs@lfdr.de>; Tue, 25 Jun 2019 05:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726407AbfFYDZi (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 24 Jun 2019 23:25:38 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:57574 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726402AbfFYDZi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jun 2019 23:25:38 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5P3OPl5005644;
        Tue, 25 Jun 2019 03:25:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=DjkWni7c0BjRfL96GDOwn55d9PXgwO4r1wxGfOmb9/o=;
 b=dLFepTpCNdZU50kisQimY7vy3FtlqM6aaIgMKWO4EFIcmpoqYf9Bk3uNoVuXS4Tumfrm
 J9DhTfZU9cUiY8tDnJbOC+O1YO1l7O2uHn0gD5YSD36vEWN0hUYMzVrvu1WM9DPWC521
 iM7kpAOL1yP6OCFGyULG4i6iwKlv2IjDex/Dx3ZEEOZp3b5DLiKSUGqe6uqohRkLPGFx
 EZamv522LomQa79/Xts2HrY8Mt29zvYaU2uxRdmVN92zBL7rfheVl102FLC61LAZIIpg
 jxHeXkYZKmv6/RIt4aobbHMGWFiXYHzA5RZHRl+KkvlTTqguwp9Vzz/FfImaW7uc3L9A rA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2t9brt1ke9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jun 2019 03:25:30 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5P3PN8r015315;
        Tue, 25 Jun 2019 03:25:30 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2tat7c00uw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jun 2019 03:25:30 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5P3PThU028028;
        Tue, 25 Jun 2019 03:25:29 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Jun 2019 20:25:28 -0700
Date:   Mon, 24 Jun 2019 20:25:27 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: Re: xfs cgroup writeback support
Message-ID: <20190625032527.GF1611011@magnolia>
References: <20190624134315.21307-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190624134315.21307-1-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9298 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906250025
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9298 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906250025
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 24, 2019 at 03:43:13PM +0200, Christoph Hellwig wrote:
> Hi all,
> 
> this small series adds cgroup writeback support to XFS.  Unlike
> the previous iteration of the support a few years ago it also
> ensures that that trailing bios in an ioend inherit the right
> cgroup.  It has been tested with the shared/011 xfstests test
> that was written to test this functionality in all file systems,
> and manually by Stefan Priebe.
> 
> This work was funded by Profihost AG.
> 
> Note that the first patch was also in my series to move the xfs
> writepage code to iomap.c and the second one will conflict with
> it.  We'll need to sort out which series to merge first, but given
> how simple this one I would suggest to go for this one.

By the way, did all the things Dave complained about in last year's
attempt[1] to add cgroup writeback support get fixed?  IIRC someone
whose name I didn't recognise complained about log starvation due to
REQ_META bios being charged to the wrong cgroup and other misbehavior.

Also, I remember that in the earlier 2017 discussion[2] we talked about
a fstest to test that writeback throttling actually capped bandwidth
usage correctly.  I haven't been following cgroupwb development since
2017 -- does it not ratelimit bandwidth now, or is there some test for
that?  The only test I could find was shared/011 which only tests the
accounting, not bandwidth.

--D

[1] https://patchwork.kernel.org/comment/21658249/
[2] https://patchwork.kernel.org/comment/21042703/
