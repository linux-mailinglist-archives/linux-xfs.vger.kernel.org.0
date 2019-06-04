Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5585E34EB4
	for <lists+linux-xfs@lfdr.de>; Tue,  4 Jun 2019 19:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725933AbfFDRZo (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 4 Jun 2019 13:25:44 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:37278 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725929AbfFDRZo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jun 2019 13:25:44 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x54HOAUi037986;
        Tue, 4 Jun 2019 17:25:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=zP/QQ23gVnIxJdfiIn8k4wqUJpy5dv/sRpoJPNF7rqo=;
 b=Iuvlhzqukke8cZZozBAmT359WuLPmb36D3EI9hJyOTT8N8XSymsO9YXzLnLF1bxHasMt
 B0ZfhPjl84dPCi1Q8d2pofczcwVM57y4wW1CMqgGMvpYgV7a90X7gNDeGJ68TDa+dJPA
 hVIKd7p0F6KGVHPMutVv9zUobtAw23ONq/Y5vjVjGKgZvqdmH57NBWsnVXuJFXSlTRHc
 WbWAYCwijnKLujK7HULj7yDtJE05hi9vE6T8wH4eElbrcmGA64aQ14qa5vr8f5VA8A76
 GGG4BM0/DqRUZQsIPqVyWH/xwI8oTtoZP5C1sEgYUruTd42R1Mg1Ur3TnuV23Ysa6Ic2 HQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2sugstef9p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Jun 2019 17:25:39 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x54HOQU6180901;
        Tue, 4 Jun 2019 17:25:38 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2swnh9qmhp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Jun 2019 17:25:38 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x54HPXoA017844;
        Tue, 4 Jun 2019 17:25:33 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 04 Jun 2019 10:25:33 -0700
Date:   Tue, 4 Jun 2019 10:25:31 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: use bios directly in the log code v2
Message-ID: <20190604172531.GA1200449@magnolia>
References: <20190603172945.13819-1-hch@lst.de>
 <20190603173506.GC5390@magnolia>
 <20190603173816.GA2162@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190603173816.GA2162@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9278 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=549
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906040111
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9278 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=582 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906040111
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 03, 2019 at 07:38:16PM +0200, Christoph Hellwig wrote:
> On Mon, Jun 03, 2019 at 10:35:06AM -0700, Darrick J. Wong wrote:
> > On Mon, Jun 03, 2019 at 07:29:25PM +0200, Christoph Hellwig wrote:
> > > Hi all,
> > > 
> > > this series switches the log writing and log recovery code to use bios
> > > directly, and remove various special cases from the buffer cache code.
> > > Note that I have developed it on top of the previous series of log item
> > > related cleanups, so if you don't have that applied there is a small
> > 
> > Hmm, /I/ don't have that applied. :/
> > 
> > Can you resend that series in its current form with (or without) all the
> > suggested review cleanups, please? :)
> 
> Actually that sentence above is stale.  It applied to v1, but not v2
> or this v3.

I assume you're going to resubmit the other log item cleanup series at
some point, right? :)

--D
