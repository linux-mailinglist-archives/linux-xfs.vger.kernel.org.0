Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA55310A32
	for <lists+linux-xfs@lfdr.de>; Wed,  1 May 2019 17:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbfEAPjC (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 1 May 2019 11:39:02 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:46650 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbfEAPjC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 May 2019 11:39:02 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x41Fca5m195986;
        Wed, 1 May 2019 15:38:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2018-07-02;
 bh=7lWVHCATQxZy3dMPQYweHfvcXPTud9y3Q9mIXo77vmw=;
 b=kL6x7X9Ol5kh+4mD/CsAmfz558NMGdbykkNhYDcn3GowTm04gGV7xEKZ5mYzcM4nGLcA
 vnRjHMN43QtKRNerwhAjFPFSTlStChyqG1cLaVjmttkFma9NuWY2LP1yDUozL9pXhFHJ
 +pKRTxdIhnXOaOSc41YVbqkMbLhdM/eMI3+M1lMj5qoqDroaSqQLtQADTSn8o57nAl8x
 yfJSUsg407IKuPCOFJQNWB+tp9bCmTziw8IxC0QFf5pYTRcRnrid2z16IF9cVgDXSoUf
 TE6CtyPO8uqUPdcOBKBZaCNFtQ8WDmt6meoqJnEGouBFeMktCK7gRNGSv30KruCc5fsP Yg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2s6xhybcde-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 May 2019 15:38:48 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x41FZjfW066201;
        Wed, 1 May 2019 15:36:48 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2s6xhhaqxj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 May 2019 15:36:47 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x41FajKR022091;
        Wed, 1 May 2019 15:36:47 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 01 May 2019 08:36:45 -0700
Date:   Wed, 1 May 2019 08:36:43 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Andre Noll <maan@tuebingen.mpg.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: xfs: Assertion failed in xfs_ag_resv_init()
Message-ID: <20190501153643.GL5207@magnolia>
References: <20190430121420.GW2780@tuebingen.mpg.de>
 <20190430151151.GF5207@magnolia>
 <20190430162506.GZ2780@tuebingen.mpg.de>
 <20190430174042.GH5207@magnolia>
 <20190430190525.GB2780@tuebingen.mpg.de>
 <20190430191825.GF5217@magnolia>
 <20190430210724.GD2780@tuebingen.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190430210724.GD2780@tuebingen.mpg.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9243 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905010098
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9243 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905010099
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 30, 2019 at 11:07:24PM +0200, Andre Noll wrote:
> On Tue, Apr 30, 12:18, Darrick J. Wong wrote
> > > commit f847bda4d612744ff1812788417bd8df41a806d3
> > > Author: Dave Chinner <dchinner@redhat.com>
> > > Date:   Mon Nov 19 13:31:08 2018 -0800
> > > 
> > >     xfs: finobt AG reserves don't consider last AG can be a runt
> > >     
> > >     This is a backport of upstream commit c08768977b9 and the part of
> > >     21ec54168b36 which is needed by c08768977b9.
> > 
> > You could send this patch to the stable list, but my guess is that
> > they'd prefer a straight backport of all three commits...
> 
> Hm, cherry-picking the first commit onto 4.9,171 already gives
> four conflicting files. The conflicts are trivial to resolve (git
> cherry-pick -xX theirs 21ec54168b36 does it), but that doesn't
> compile because xfs_btree_query_all() is missing.  So e9a2599a249ed
> (xfs: create a function to query all records in a btree) is needed as
> well. But then, applying 86210fbebae (xfs: move various type verifiers
> to common file) on top of that gives non-trivial conflicts.

Ah, I suspected that might happen.  Backports are hard. :(

I suppose one saving grace of the patch you sent is that it'll likely
break the build if anyone ever /does/ attempt a backport of those first
two commits.  Perhaps that is the most practical way forward.

> So, for automatic backporting we would need to cherry-pick even more,
> and each backported commit should be tested of course. Given this, do
> you still think Greg prefers a rather large set of straight backports
> over the simple commit that just pulls in the missing function?

I think you'd have to ask him that, if you decide not to send
yesterday's patch.

> I guess the important question is how much impact this issue
> has on production systems (i.e., on CONFIG_XFS_DEBUG=n kernels,
> where the assert statement is not compiled in). If the unpatched
> xfs_inobt_max_size() is very unlikely to cause problems on such
> systems, we might as well live with it.

...but it's unlikely to cause problems since the allocator will probably
pass over that runt AG so long as the others have more space and it will
mostly stay empty.

(He says knocking on wood knowing that he's now tempted fate :P)

--D

> 
> Thanks
> Andre
> -- 
> Max Planck Institute for Developmental Biology
> Max-Planck-Ring 5, 72076 Tübingen, Germany. Phone: (+49) 7071 601 829
> http://people.tuebingen.mpg.de/maan/


