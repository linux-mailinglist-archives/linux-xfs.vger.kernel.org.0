Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB18E5D285
	for <lists+linux-xfs@lfdr.de>; Tue,  2 Jul 2019 17:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbfGBPQX (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 2 Jul 2019 11:16:23 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55296 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbfGBPQW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jul 2019 11:16:22 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x62F4PWL048269;
        Tue, 2 Jul 2019 15:15:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=Wd7/jDGZt7wA0OBB1sG68ichRvmCNbJORNZMQ4MErHo=;
 b=p21bjyw2swR2sHpF3DnT2nxx1fBK7RBMt75L/irLaZmYqM2EKvE6dui97DV4aqvMVeIr
 oWjbvWudyVrb8fTZ1Fa721n+WJTM6B2jNiLauHqIxdvihyQsEbNJZg99tRdU0b9nTB80
 wZotZVloHUeaOfB7Ka8uWn1ZMS4Osh2yIIUtjf61v28jtRcaHHgsA/sAJOH+/p6iHsx7
 xOtIITunj1fFiXda+2Vvl9efxwi1mnOR5nZsqXjhpXWX/9lPmMdCHfDFM4F3WGCzSIZW
 TzC+8QmFWTua6YkNGdwXc7XynW4pLOUoh8HFaXFtcN8xsw29RG5SoV/Ju1oOtYfGCsYY 7Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2te61pv9h5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jul 2019 15:15:50 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x62F39mY121216;
        Tue, 2 Jul 2019 15:15:49 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2tebaktx1q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jul 2019 15:15:49 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x62FFlaP024699;
        Tue, 2 Jul 2019 15:15:47 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 02 Jul 2019 08:15:47 -0700
Date:   Tue, 2 Jul 2019 08:15:45 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Sheriff Esseson <sheriffesseson@gmail.com>,
        skhan@linuxfoundation.org, linux-xfs@vger.kernel.org,
        corbet@lwn.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [linux-kernel-mentees] [PATCH v5] Doc : fs : convert xfs.txt to
 ReST
Message-ID: <20190702151545.GO1404256@magnolia>
References: <20190702123040.GA30111@localhost>
 <20190702150452.GD1729@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190702150452.GD1729@bombadil.infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9306 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907020165
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9306 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907020165
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 02, 2019 at 08:04:52AM -0700, Matthew Wilcox wrote:
> On Tue, Jul 02, 2019 at 01:30:40PM +0100, Sheriff Esseson wrote:
> > +When mounting an XFS filesystem, the following options are accepted.  For
> > +boolean mount options, the names with the "(*)" prefix is the default behaviour.
> > +For example, take a behaviour enabled by default to be a one (1) or, a zero (0)
> > +otherwise, ``(*)[no]default`` would be 0 while ``[no](*)default`` , a 1.
> > -When mounting an XFS filesystem, the following options are accepted.
> > -For boolean mount options, the names with the (*) suffix is the
> > -default behaviour.
> 
> You seem to have reflowed all the text.  That means git no longer notices
> it's a rename, and quite frankly the shorter lines that were in use were
> better.

Agreed.  Please don't reflow text in a format conversion patch, it makes
it very difficult to figure out which changes were to accomodate rst.

If you want to reflow text (because of line length etc.) please do it as
a second patch.  I'd rather break the 80 column rule for a single commit
if it makes reviewing easy on the eyes.

> This is not an improvement; please undo it in the next version
> (which you should not post for several days to accumulate more feedback).

Seconded.  Thank you for sending v5 as a separate patch, though. :)

--D
