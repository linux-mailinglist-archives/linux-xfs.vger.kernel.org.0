Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7464E803A6
	for <lists+linux-xfs@lfdr.de>; Sat,  3 Aug 2019 03:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388447AbfHCBNL (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 2 Aug 2019 21:13:11 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:36858 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387926AbfHCBNL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Aug 2019 21:13:11 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x731AREk023316;
        Sat, 3 Aug 2019 01:13:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=Vm8VuxZ8deOo43xgvf4lmfggQxp4ydiwf5VzoJlGCkw=;
 b=knFFPcnGEcq6TKQHlXzmo0EkZnZBmawnBKKsVUmxnMz4dR5EPLJvOS1GEB0mW8j2IrYh
 mfn99RFzA0NXhmBJUvHo1cFd5Es+2BohgUlZk87nHDiIMIklgD4pOMlpEHbEXSk7bN9N
 PftDRcrYELIQRlgBtH7hPbBSljeM3WhjYBUxLs0Wi3wFrWWzAmp5/xxyCVoVtXIxcB3C
 X7QIIN4AACfWzNGVw/SDmqIB6/mORt3bPt8FoxcVr03xyrwKWOXly8vDgDnfAvRvbiAn
 b3YpEgWueXlZbD/GE5lwgdeHh7xfCgCglpZpFTQYiduXKVLCI0txjF1BMu0/lrwmojuP PQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2u0e1ud9wj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Aug 2019 01:13:08 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x73187IX144015;
        Sat, 3 Aug 2019 01:11:08 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2u4ucabcfd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Aug 2019 01:11:07 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x731B7N9016032;
        Sat, 3 Aug 2019 01:11:07 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 02 Aug 2019 18:11:06 -0700
Date:   Fri, 2 Aug 2019 18:11:06 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Luciano ES <lucmove@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: XFS file system corruption, refuses to mount
Message-ID: <20190803011106.GJ7138@magnolia>
References: <20181211183203.7fdbca0f@lud1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181211183203.7fdbca0f@lud1.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9337 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908030008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9337 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908030008
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 02, 2019 at 09:53:56PM -0300, Luciano ES wrote:
> I've had this internal disk running for a long time. I had to 
> disconnect it from the SATA and power plugs for two days. 
> Now it won't mount. 
> 
> mount: wrong fs type, bad option, bad superblock on /dev/mapper/cab3,
>        missing codepage or helper program, or other error
>        In some cases useful info is found in syslog - try
>        dmesg | tail or so.
> 
> I get this in dmesg:
> 
> [   30.301450] XFS (dm-1): Mounting V5 Filesystem
> [   30.426206] XFS (dm-1): Corruption warning: Metadata has LSN
> (16:367696) ahead of current LSN (16:367520). Please unmount and run
> xfs_repair (>= v4.3) to resolve.

Hm, I think this means the superblock LSN is behind the log LSN, which
could mean that... software is buggy?  The disk didn't flush its cache
before it was unplugged?  Something else?

What kernel & xfsprogs?

And how did you disconnect it from the power plugs?

> [   30.426209] XFS (dm-1): log mount/recovery failed: error -22
> [   30.426310] XFS (dm-1): log mount failed
> 
> Note that the entire disk is encrypted with cryptsetup/LUKS, 
> which is working fine. Wrong passwords fail. The right password 
> opens it. But then it refuses to mount.
> 
> This has been happening a lot to me with XFS file systems. 
> Why is this happening?
> 
> Is there something I can do to recover the data?

Try xfs_repair -n to see what it would do if you ran repair?

--D

> -- 
> Luciano ES
> >>
