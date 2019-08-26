Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACB3B9D62A
	for <lists+linux-xfs@lfdr.de>; Mon, 26 Aug 2019 21:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732700AbfHZTB7 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 26 Aug 2019 15:01:59 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:43848 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732617AbfHZTB7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 15:01:59 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QIsRwf078144;
        Mon, 26 Aug 2019 19:01:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=LliEG6YqnKCwphD7aXWNMWWTbou4M0WDD2kIxLevclk=;
 b=bthsStf4VRWORjWo7C57qgMd7ByfzHUOElqQAxlKsNv+aK0VFJRSTmqsLX2kMLs1TXUz
 R9CCM72HxZFeTNFnktefNYam58TIgcsWmErNQBy9DB+B4htCNx9FBk03ESZX+vZ5bJjD
 VfnpLsjLew/dFTKAeXl0bFWeAVIBhAQSrWDiCQsvIDb0upHH+0BN0cI1w11KONyLVMPo
 eWqX/xnSQ9l3hWHaNWFE79yYCiGzBG/Nu+UiAq8BYZ8DMtHCboEKQkNsMkDw1ElPv0nn
 DTV/ZjHU0QRodbM76vEUOMvMq8+Hav0KkciC/IXsvec0JsNbT4XqFpc5Sss6WbZQNlMJ kg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2ujw703ghm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 19:01:54 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QIr9ld145604;
        Mon, 26 Aug 2019 19:01:53 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2umhu7s1m8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 19:01:53 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7QJ1q0C017843;
        Mon, 26 Aug 2019 19:01:52 GMT
Received: from localhost (/10.159.144.227)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 19:01:52 +0000
Date:   Mon, 26 Aug 2019 12:01:46 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: show error code when printing writeback error
 messages.
Message-ID: <20190826190146.GS1037350@magnolia>
References: <1564653826-8916-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp>
 <20190801103851.GL7777@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190801103851.GL7777@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=843
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908260179
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=899 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908260179
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 01, 2019 at 08:38:51PM +1000, Dave Chinner wrote:
> On Thu, Aug 01, 2019 at 07:03:46PM +0900, Tetsuo Handa wrote:
> > Even without backtraces, including error code should be helpful.
> > 
> >   [  630.162595][ T9218] XFS (sda1): writeback error -12 on sector 131495992
> >   [  631.718685][ T9432] XFS (sda1): writeback error -12 on sector 131503928
> >   [  632.015588][  T442] XFS (sda1): writeback error -12 on sector 157773936
> > 
> > Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> > ---
> >  fs/xfs/xfs_aops.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> > index f16d5f196c6b..d2c9076643cf 100644
> > --- a/fs/xfs/xfs_aops.c
> > +++ b/fs/xfs/xfs_aops.c
> > @@ -112,7 +112,7 @@ xfs_destroy_ioend(
> >  
> >  	if (unlikely(error && !quiet)) {
> >  		xfs_err_ratelimited(XFS_I(inode)->i_mount,
> > -			"writeback error on sector %llu", start);
> > +			"writeback error %d on sector %llu", error, start);
> 
> If you are going to do this, make the error message properly useful.
> Report the inode number and the ioend offset and length so we know
> what file and where in the file the writeback failure occurred.

Ping?

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
