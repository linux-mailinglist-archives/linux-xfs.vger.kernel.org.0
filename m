Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD9691BD022
	for <lists+linux-xfs@lfdr.de>; Wed, 29 Apr 2020 00:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726272AbgD1Wnj (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 28 Apr 2020 18:43:39 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52116 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726042AbgD1Wni (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Apr 2020 18:43:38 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03SMdIe3135600;
        Tue, 28 Apr 2020 22:43:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=v3x0t0xeBNGwtfdqwjVMU3TMXMnpHQv+mc0qM8yQx6A=;
 b=zVUPWxAaHXc/oJh24mGYPmvgxt2eWiq1aygGLwzPweMfXPCpOIZzznwMsV7gpf5EwIBD
 Ryv+tbLLd0KK9cHNzQUAAl8rCNWVVjLdamXyjEn0XOo3wrKFCIIWtlGNQSAKXefhTupj
 x+QhoXDur49RuoVrxRIxAyOCXj0xzxrqo57WEUSX8akpcJBxxzXqxwbLHg4f6OYUFLmH
 dIOCoMftQ6aiGlUXLtuQqb5jR8aD5UHg6hU63wg72CK0rt9GIn4Fld3gOaR3EfGBhtlu
 vuwIeGA9OrXLwPdZRjiNOumDxhoCbKxPCiS6RfQUaHWfR0s7LtwgpiJ1s55rEURt67hG DQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 30p01ns919-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Apr 2020 22:43:35 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03SMb7Yb179979;
        Tue, 28 Apr 2020 22:41:34 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 30my0en4j1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Apr 2020 22:41:34 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03SMfYvW006027;
        Tue, 28 Apr 2020 22:41:34 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 28 Apr 2020 15:41:33 -0700
Date:   Tue, 28 Apr 2020 15:41:32 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/19] xfs: refactor EFI log item recovery dispatch
Message-ID: <20200428224132.GP6742@magnolia>
References: <158752116283.2140829.12265815455525398097.stgit@magnolia>
 <158752123303.2140829.7801078756588477964.stgit@magnolia>
 <20200425182801.GE16698@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200425182801.GE16698@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9605 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 suspectscore=2 adultscore=0 mlxlogscore=999 bulkscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004280175
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9605 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 clxscore=1015
 phishscore=0 mlxlogscore=999 adultscore=0 priorityscore=1501 mlxscore=0
 suspectscore=2 malwarescore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004280175
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Apr 25, 2020 at 11:28:01AM -0700, Christoph Hellwig wrote:
> On Tue, Apr 21, 2020 at 07:07:13PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Move the extent free intent and intent-done log recovery code into the
> > per-item source code files and use dispatch functions to call them.  We
> > do these one at a time because there's a lot of code to move.  No
> > functional changes.
> 
> What is the reason for splitting xlog_recover_item_type vs
> xlog_recover_intent_type?  To me it would seem more logical to have
> one operation vector, with some ops only set for intents.

Partly because I started by refactoring only the intent items, and then
decided to prepend a series to do everything; and partly to be stingy
with bytes. :P

That said, I like your suggestion of every XFS_LI_* code gets its own
xlog_recover_item_type so I'll go do that.

--D
