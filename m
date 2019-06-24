Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B0BB51EEB
	for <lists+linux-xfs@lfdr.de>; Tue, 25 Jun 2019 01:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728012AbfFXXGu (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 24 Jun 2019 19:06:50 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50334 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726486AbfFXXGu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jun 2019 19:06:50 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5OMxCv9028713;
        Mon, 24 Jun 2019 23:06:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=8aaz9j1M6LHINBJUlIuo9GoM+F9OMUzYJ50d1fFl5mo=;
 b=d3k/PI56h4xW4/45hjVjCt+Hu7+XBzLfeLsRNu4++T8cCCDtywVk/SnLq1NfhCEuiz6K
 hA4I8Jp8rHWNpfwQf1YEv9UGG9KwIxs8G9Mo2+mlHR7m6NOT7Yl1lXoNzHiioRxfPLhE
 hpJg0q6MunIrBJYxj4R+Qc3UT0Lq7VQ7jgBfM0SbIBmws9netQ9dVhHodOUDCiYBId1v
 GXXoQKIBkQpa8CaSWBo6jRzoe9KWRWOmWZ6goSXZVcfr+KzjytZutUSMc4NdsIMO1ygC
 KqlyGPxEpXo/OBai3/R6eh9CnEckrA1A4UQkJxk169RGONXNcyLuNj0+JtHAgd/GgmNh ng== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2t9brt101h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jun 2019 23:06:37 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5ON5Tg5153848;
        Mon, 24 Jun 2019 23:06:36 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2t9acbs16x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jun 2019 23:06:36 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5ON6Ykc002346;
        Mon, 24 Jun 2019 23:06:34 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Jun 2019 16:06:34 -0700
Date:   Mon, 24 Jun 2019 16:06:33 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Ian Kent <raven@themaw.net>, linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 02/10] xfs: mount-api - refactor suffix_kstrtoint()
Message-ID: <20190624230633.GB5387@magnolia>
References: <156134510205.2519.16185588460828778620.stgit@fedora-28>
 <156134510851.2519.2387740442257250106.stgit@fedora-28>
 <20190624172943.GV5387@magnolia>
 <20190624223554.GA7777@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190624223554.GA7777@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9298 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906240181
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9298 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906240181
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 25, 2019 at 08:35:54AM +1000, Dave Chinner wrote:
> On Mon, Jun 24, 2019 at 10:29:43AM -0700, Darrick J. Wong wrote:
> > On Mon, Jun 24, 2019 at 10:58:30AM +0800, Ian Kent wrote:
> > > The mount-api doesn't have a "human unit" parse type yet so
> > > the options that have values like "10k" etc. still need to
> > > be converted by the fs.
> > 
> > /me wonders if that ought to be lifted to fs_parser.c, or is xfs the
> > only filesystem that has mount options with unit suffixes?
> 
> I've suggested the same thing (I've seen this patchset before :)
> and ISTR it makes everything easier if we just keep it here for this
> patchset and then lift it once everything is merged...

Ok, fair enough. :)

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
