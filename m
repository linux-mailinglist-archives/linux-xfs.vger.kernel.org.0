Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99E6D5C0AB
	for <lists+linux-xfs@lfdr.de>; Mon,  1 Jul 2019 17:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730000AbfGAPvw (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 1 Jul 2019 11:51:52 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:34540 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728053AbfGAPvv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Jul 2019 11:51:51 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x61FnOW5041009;
        Mon, 1 Jul 2019 15:51:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=v58nZ4sOVzUxsIgxzLPHYMiDCb/PQf8nA8zBdMZYPrM=;
 b=Hl//A+Q++nOy6N2C6J/YeboBCJa9RqC3jBie72QOtCUy1Ovr8FbsyqQLSRdm1hmgZCtm
 KG6N38+KyRFnzqWEMu9ezz4KwaDoq2/uOZHuXolks2GYCt7LXiHxBjVccLLk/FpeVZIw
 mY2nNkDvTbQpAXpAFy9eKfTl3nM0wK9tc6XP3S8hcxZHMon3GiTI7y7x5kLfAPYc4A8b
 yBEdelu0iS6f+r5McYvVvsNZyvmGr6Th8xHBYNcemBWSI5RW2zPnRixPwuOSjs8QZX20
 hWFHGWtAV0QwgNGaXeQgBF0e+wsfHY/JExgfIak7JLoxjvf5SYbYP8D45PZThHaN8SZQ mg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2te5tbehd4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Jul 2019 15:51:46 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x61FmBc2126248;
        Mon, 1 Jul 2019 15:49:46 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2tebak8gvv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Jul 2019 15:49:46 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x61Fnjx4014393;
        Mon, 1 Jul 2019 15:49:45 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Jul 2019 08:49:45 -0700
Date:   Mon, 1 Jul 2019 08:49:44 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     linux-xfs@vger.kernel.org,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Adding some trees to linux-next?
Message-ID: <20190701154944.GL1404256@magnolia>
References: <20190701110603.5abcbb2c@canb.auug.org.au>
 <20190701153552.GJ1404256@magnolia>
 <20190702014210.1c95f9f1@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190702014210.1c95f9f1@canb.auug.org.au>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9305 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907010190
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9305 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907010191
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 02, 2019 at 01:42:10AM +1000, Stephen Rothwell wrote:
> Hi Darrick,
> 
> On Mon, 1 Jul 2019 08:35:52 -0700 "Darrick J. Wong" <darrick.wong@oracle.com> wrote:
> >
> > Could you add my iomap-for-next and vfs-for-next branches to linux-next,
> > please?  They can be found here:
> > 
> > git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git#iomap-for-next
> > git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git#vfs-for-next
> > 
> > I've decided that trying to munge all that through the xfs for-next
> > branch is too much insanity and splitting them up will help me prevent
> > my head from falling off.
> 
> Just out of interest, do you intend to send these directly to Linus, or
> via another tree?

The iomap stuff I'd definitely send directly to Linus.

For vfs stuff, it depends.  For work in the core vfs I'll probably just
keep sending patches through Al, but for treewide things like ioctl
cleanups I suspect it'll be easier to let them soak in -next and then
send them directly.

I also dropped the f2fs parts of the setflags/fssetxattr patches because
while I think your fix from yesterday's for-next is correct, I prefer to
let Eric Biggers' cleanup land through the f2fs tree before I try to
clean up f2fs again.  There shouldn't be any harm in letting that lag a
little while longer.

--D

> -- 
> Cheers,
> Stephen Rothwell


